#===============================================================================
# Advanced AI System - Doubles/VGC Optimizations
# Spread moves, redirection, Fake Out, Helping Hand, Protect coordination
#===============================================================================

module AdvancedAI
  module DoublesStrategy
    
    #===========================================================================
    # Spread Move Damage Reduction
    #===========================================================================
    
    SPREAD_MOVES = [
      :EARTHQUAKE, :SURF, :DISCHARGE, :LAVAPLUME, :ROCKSLIDE, :ICICLECRASH,
      :BLIZZARD, :HEATWAVE, :SLUDGEWAVE, :DAZZLINGGLEAM, :MUDDYWATER,
      :RAZORLEAF, :ICYWIND, :BULLDOZE, :PARABOLICCHARGE, :GMAXCANNONADE,
      :BOOMBURST, :RELICSONG, :PETALBLIZZARD, :EXPLOSION, :SELFDESTRUCT,
      :MAGNITUDE, :GLACIATE, :ORIGINPULSE, :PRECIPICEBLADES, :ERUPTION,
      :WATERSPOUT, :SNARL, :STRUGGLE
    ]
    
    # Spread moves deal 0.75x damage when hitting multiple targets
    SPREAD_DAMAGE_MULTIPLIER = 0.75
    
    #===========================================================================
    # Redirection Moves
    #===========================================================================
    
    REDIRECTION_MOVES = {
      :FOLLOWME => { priority: 2, duration: 1 },
      :RAGEPOWDER => { priority: 2, duration: 1 },
      :SPOTLIGHT => { priority: 3, duration: 1 }
    }
    
    # Abilities that redirect
    REDIRECTION_ABILITIES = [:LIGHTNINGROD, :STORMDRAIN]
    
    #===========================================================================
    # Support Moves
    #===========================================================================
    
    # Helping Hand: +50% damage to partner's next move
    HELPING_HAND_BOOST = 1.5
    
    #===========================================================================
    # Damage Calculation for Doubles
    #===========================================================================
    
    def self.adjust_damage_for_doubles(base_damage, move, battle)
      return base_damage unless battle.pbSideSize(0) > 1  # Only in doubles
      
      # Spread moves deal 0.75x damage
      if SPREAD_MOVES.include?(move.id)
        base_damage *= SPREAD_DAMAGE_MULTIPLIER
      end
      
      return base_damage
    end
    
    #===========================================================================
    # Redirection Detection
    #===========================================================================
    
    def self.has_active_redirection?(battle, side_index)
      return false unless battle.pbSideSize(0) > 1
      
      # Check all battlers on the side for redirection
      battle.allSameSideBattlers(side_index).each do |battler|
        next if battler.fainted?
        
        # Follow Me / Rage Powder effect
        return true if battler.effects[PBEffects::FollowMe] > 0
        
        # Spotlight effect
        return true if battler.effects[PBEffects::Spotlight] > 0
        
        # Lightning Rod / Storm Drain (redirects specific types)
        if REDIRECTION_ABILITIES.include?(battler.ability_id)
          return true
        end
      end
      
      return false
    end
    
    def self.score_redirection_move(user, move, battle, skill_level = 100)
      return 0 unless skill_level >= 70
      return 0 unless battle.pbSideSize(0) > 1
      return 0 unless REDIRECTION_MOVES.key?(move.id)
      
      score = 0
      
      # Protect partner from incoming attacks
      partner = user.allAllies.first
      return 0 unless partner && !partner.fainted?
      
      # High value if partner is low HP
      partner_hp_percent = AdvancedAI::CombatUtilities.hp_percent(partner)
      score += AdvancedAI::CombatUtilities.hp_threshold_score(
        partner_hp_percent,
        AdvancedAI::CombatUtilities::PARTNER_HP_CONCERN
      )
      score += 15  # Base value for setup/support
      
      # Bonus if partner is setting up
      if partner.effects[PBEffects::FocusEnergy] > 0 ||
         partner.stages[:ATTACK] > 0 || partner.stages[:SPECIAL_ATTACK] > 0
        score += 40  # Protect setup sweeper
      end
      
      # Penalty if user is frail (can't take hits)
      user_hp_percent = AdvancedAI::CombatUtilities.hp_percent(user)
      if user_hp_percent < 0.33
        score -= 60  # Can't redirect if we'll die
      elsif user_hp_percent < 0.50
        score -= 30
      end

      # === CONFLICT GUARD ===
      # If partner already registered Helping Hand / Protect, redirect is pointless.
      partner_move = DoublesCoordination.partner_planned_move_id(battle, partner) rescue nil
      if partner_move
        if partner_move == :HELPINGHAND
          score -= 200  # Redirect + Helping Hand = zero offense
        end
        if DoublesCoordination::PROTECT_MOVE_IDS.include?(partner_move)
          score -= 100  # Partner protected — doesn't need redirect cover
        end
      end
      
      return score
    end
    
    #===========================================================================
    # Helping Hand Bonus
    #===========================================================================
    
    def self.score_helping_hand(user, target, battle, skill_level = 100)
      return 0 unless skill_level >= 75
      return 0 unless battle.pbSideSize(0) > 1
      
      score = 0
      
      # Only useful for partner (not user)
      return 0 if target.index == user.index
      return 0 unless user.allAllies.include?(target)

      # === CONFLICT GUARD ===
      # If partner already registered a non-attacking move (Follow Me,
      # Rage Powder, Protect, etc.), Helping Hand is wasted.
      partner_move = DoublesCoordination.partner_planned_move_id(battle, target) rescue nil
      if partner_move
        if DoublesCoordination::REDIRECT_MOVE_IDS.include?(partner_move)
          return -200  # Redirect + Helping Hand = zero offense turn
        end
        if DoublesCoordination::PROTECT_MOVE_IDS.include?(partner_move)
          return -150  # Protect + Helping Hand = wasted
        end
      end
      
      # Check if partner has strong attacking move ready
      partner_has_strong_move = target.moves.any? do |m|
        m.damagingMove? && m.power && m.power >= 80
      end
      
      if partner_has_strong_move
        score += 60  # Boost strong attack
        
        # Extra bonus if partner can KO with boost
        # (Would require damage calc - simplified here)
        score += 40
      else
        score += 20  # Generic bonus
      end
      
      # Penalty if user could KO instead
      user_can_ko = user.moves.any? do |m|
        m.damagingMove? && m.power && m.power >= 100
      end
      
      if user_can_ko
        score -= 40  # Maybe better to attack yourself
      end
      
      return score
    end
    
    #===========================================================================
    # Fake Out Strategy
    #===========================================================================
    
    def self.score_fake_out_doubles(user, target, battle, skill_level = 100)
      return 0 unless skill_level >= 60
      return 0 unless battle.pbSideSize(0) > 1
      return 0 if battle.turnCount > 0  # Only Turn 1
      
      score = 0
      
      # Fake Out is CRITICAL Turn 1 in doubles
      score += 80  # High base value - flinch + free turn for partner
      
      # Bonus if partner can setup
      partner = user.allAllies.first
      if partner && !partner.fainted?
        partner_has_setup = partner.moves.any? do |m|
          [:TAILWIND, :TRICKROOM, :REFLECT, :LIGHTSCREEN].include?(m.id)
        end
        
        if partner_has_setup
          score += 60  # Free setup turn!
        end
      end
      
      # Bonus vs faster threats
      if target.pbSpeed > user.pbSpeed
        score += 30  # Prevent opponent from moving first
      end
      
      # Target Prioritization: Hit the bigger threat
      # (Simplified - would need threat assessment)
      if target.attack > 120 || target.spatk > 120
        score += 25  # Flinch the sweeper
      end
      
      return score
    end
    
    #===========================================================================
    # Protect Coordination (both partners protect = waste)
    #===========================================================================
    
    def self.score_protect_coordination(user, battle)
      return 0 unless battle.pbSideSize(0) > 1
      
      penalty = 0
      
      # Check if partner is also using Protect
      partner = user.allAllies.first
      if partner && !partner.fainted?
        # If partner used Protect last turn, don't both Protect this turn
        if partner.lastMoveUsed && [:PROTECT, :DETECT, :KINGSSHIELD, :SPIKYSHIELD, :BANEFULBUNKER].include?(partner.lastMoveUsed)
          penalty += 50  # Don't both protect - wasteful
        end
        
        # If partner is protecting this turn (check current move choice)
        # (Would need battle state tracking - simplified here)
      end
      
      return -penalty
    end
    
    #===========================================================================
    # Spread Move Target Selection
    #===========================================================================
    
    def self.prefer_spread_move?(user, battle, skill_level = 100)
      return false unless skill_level >= 80
      return false unless battle.pbSideSize(0) > 1
      
      # Check if user has spread move
      has_spread = user.moves.any? { |m| SPREAD_MOVES.include?(m.id) }
      return false unless has_spread
      
      # Prefer spread if both opponents are damaged equally
      opponents = user.allOpposing
      return false if opponents.length < 2
      
      # Check if both are weak to the spread move
      # (Simplified - would need type effectiveness calc)
      
      # Prefer spread if both opponents are low HP (can KO both)
      both_low_hp = opponents.all? { |opp| opp.hp < opp.totalhp * 0.4 }
      return true if both_low_hp
      
      return false
    end
    
    #===========================================================================
    # Wide Guard / Quick Guard Detection
    #===========================================================================
    
    def self.has_wide_guard?(side, battle)
      return false unless battle.pbSideSize(0) > 1
      
      # Check if opponent has Wide Guard active
      return side.effects[PBEffects::WideGuard] if side.effects[PBEffects::WideGuard]
      
      return false
    end
    
    def self.has_quick_guard?(side, battle)
      return false unless battle.pbSideSize(0) > 1
      
      # Check if opponent has Quick Guard active
      return side.effects[PBEffects::QuickGuard] if side.effects[PBEffects::QuickGuard]
      
      return false
    end
    
    def self.score_guard_penalty(user, move, target, battle)
      return 0 unless battle.pbSideSize(0) > 1
      
      penalty = 0
      target_side = target.pbOwnSide
      
      # Wide Guard blocks spread moves
      if has_wide_guard?(target_side, battle) && SPREAD_MOVES.include?(move.id)
        penalty += 200  # Move will fail!
      end
      
      # Quick Guard blocks priority moves
      if has_quick_guard?(target_side, battle) && move.priority > 0
        penalty += 200  # Move will fail!
      end
      
      return -penalty
    end
    
  end
end


#===============================================================================
# Integration: Hook into pbRegisterMove
#===============================================================================

class Battle::AI
  alias doubles_strategy_pbRegisterMove pbRegisterMove
  
  def pbRegisterMove(user, move)
    score = doubles_strategy_pbRegisterMove(user, move)
    
    # Skip if not doubles
    return score unless @battle.pbSideSize(0) > 1
    return score unless user && move
    
    skill_level = 100
    target = @battle.allOtherSideBattlers(user.index).find { |b| b && !b.fainted? }
    
    # Fake Out bonus (Turn 1 only)
    if move.id == :FAKEOUT && target
      score += AdvancedAI::DoublesStrategy.score_fake_out_doubles(user, target, @battle, skill_level)
    end
    
    # Redirection moves
    if AdvancedAI::DoublesStrategy::REDIRECTION_MOVES.key?(move.id)
      score += AdvancedAI::DoublesStrategy.score_redirection_move(user, move, @battle, skill_level)
    end
    
    # Helping Hand
    if move.id == :HELPINGHAND && target
      score += AdvancedAI::DoublesStrategy.score_helping_hand(user, target, @battle, skill_level)
    end
    
    # Protect coordination penalty
    if [:PROTECT, :DETECT, :KINGSSHIELD, :SPIKYSHIELD, :BANEFULBUNKER].include?(move.id)
      score += AdvancedAI::DoublesStrategy.score_protect_coordination(user, @battle)
    end
    
    # Wide Guard / Quick Guard penalties
    if target
      guard_penalty = AdvancedAI::DoublesStrategy.score_guard_penalty(user, move, target, @battle)
      score += guard_penalty
    end
    
    return score
  end
end


#===============================================================================
# Advanced AI System - Priority Move Tier System
# Distinguishes between priority levels for optimal move selection
#===============================================================================

module AdvancedAI
  module PriorityTiers
    
    #===========================================================================
    # Priority Move Categories
    #===========================================================================
    
    # Priority +4
    PRIORITY_PLUS_4 = [:HELPINGHAND]
    
    # Priority +3
    PRIORITY_PLUS_3 = [:MAGICCOAT, :SNATCH, :BANEFULBUNKER, :OBSTRUCT,
                       :KINGSSHIELD, :SPIKYSHIELD, :CRAFTYSHIELD]
    
    # Priority +2
    PRIORITY_PLUS_2 = [:EXTREMESPEED, :FEINT, :FOLLOWME, :RAGEPOWDER,
                       :FIRSTIMPRESSION]
    
    # Priority +1 (Most common)
    PRIORITY_PLUS_1 = [
      :ACCELEROCK, :AQUAJET, :BULLETPUNCH, :ICESHARD, :MACHPUNCH,
      :QUICKATTACK, :SHADOWSNEAK, :SUCKERPUNCH, :VACUUMWAVE,
      :WATERSHURIKEN, :JETPUNCH, :ZIPZAP, :GRASSYGLIDE,
      :THUNDERBOLT  # When Electric Terrain is active
    ]
    
    # Priority +0 (Normal moves)
    # ... all other moves
    
    # Priority -1 to -7 (Negative priority)
    NEGATIVE_PRIORITY = {
      :VITALTHROW => -1,
      :BEAKBLAST => -3,
      :FOCUSPUNCH => -3,
      :AVALANCHE => -4,
      :REVENGE => -4,
      :COUNTER => -5,
      :MIRRORCOAT => -5,
      :ROAR => -6,
      :WHIRLWIND => -6,
      :TRICKROOM => -7
    }
    
    #===========================================================================
    # Get Priority Level
    #===========================================================================
    
    def self.get_priority_tier(move)
      return 0 unless move
      
      # Check move's inherent priority
      base_priority = move.priority || 0
      
      # For conditional priority moves (e.g., Grassy Glide in Grassy Terrain)
      # This would need battle state context
      
      return base_priority
    end
    
    #===========================================================================
    # Priority Move Scoring
    #===========================================================================
    
    def self.score_priority_advantage(user, move, target, battle, skill_level = 100)
      return 0 unless skill_level >= 60
      return 0 unless move
      
      move_priority = get_priority_tier(move)
      return 0 if move_priority == 0  # Not a priority move
      
      score = 0
      
      # === POSITIVE PRIORITY ===
      if move_priority > 0
        # Check speed comparison
        user_speed = user.pbSpeed
        target_speed = target.pbSpeed
        
        # Priority is most valuable when we're slower
        if target_speed > user_speed
          score += 40 * move_priority  # Higher priority = more valuable
          
          # Extra bonus if we're MUCH slower
          speed_ratio = target_speed.to_f / [user_speed, 1].max
          if speed_ratio >= 2.0
            score += 30  # Completely outclassed in speed
          elsif speed_ratio >= 1.5
            score += 20
          end
          
          # Bonus if user is low HP (desperation)
          user_hp_percent = AdvancedAI::CombatUtilities.hp_percent(user)
          score += AdvancedAI::CombatUtilities.hp_threshold_score(
            user_hp_percent,
            { 0.33 => 50, 0.50 => 30 }
          )
          
          # Bonus if target is low HP (secure KO)
          target_hp_percent = AdvancedAI::CombatUtilities.hp_percent(target)
          if target_hp_percent < 0.33 && move.damagingMove?
            score += 60  # Guaranteed KO before they move
          elsif target_hp_percent < 0.50 && move.damagingMove?
            score += 40
          end
          
        else
          # We're already faster - priority is less valuable
          score += 10 * move_priority  # Small bonus
        end
        
        # === PRIORITY TIER BONUSES ===
        case move_priority
        when 4
          # Helping Hand: +50% damage to partner (doubles only)
          score += 40 if battle.pbSideSize(0) > 1
          
        when 3
          # Protection moves (King's Shield, Baneful Bunker, etc.)
          # High value if opponent is boosted or we're low HP
          if AdvancedAI::CombatUtilities.total_stat_boosts(target) > 2
            score += 50  # Protect vs boosted opponent
          end
          
          user_hp_percent = AdvancedAI::CombatUtilities.hp_percent(user)
          score += 60 if user_hp_percent < 0.33
          
        when 2
          # Extreme Speed, Feint, Follow Me
          if move.id == :EXTREMESPEED
            score += 30  # Very reliable priority damage
          elsif move.id == :FEINT
            # Bonus vs Protect users
            if target.effects[PBEffects::Protect]
              score += 80  # Bypass Protect!
            end
          elsif [:FOLLOWME, :RAGEPOWDER].include?(move.id)
            # Redirection in doubles
            score += 50 if battle.pbSideSize(0) > 1
          end
          
        when 1
          # Standard priority (Aqua Jet, Mach Punch, etc.)
          # Already scored above, but add type-specific bonuses
          
          # Sucker Punch: Only works if opponent attacks
          if move.id == :SUCKERPUNCH
            # Penalty if opponent is likely to use status move
            if target.lastMoveUsed
              last_move_data = GameData::Move.try_get(target.lastMoveUsed)
              if last_move_data && last_move_data.statusMove?
                score -= 100  # Likely to fail!
              end
            end
          end
          
          # Grassy Glide: Priority only in Grassy Terrain
          if move.id == :GRASSYGLIDE
            terrain = battle.field.terrain rescue nil
            if terrain != :Grassy
              score -= 40  # No priority boost
            end
          end
        end
      end
      
      # === NEGATIVE PRIORITY ===
      if move_priority < 0
        # Negative priority is usually BAD (move last)
        score -= 20 * move_priority.abs
        
        # EXCEPTIONS:
        
        # Trick Room: Intentionally move last to activate field
        if move.id == :TRICKROOM
          # Trick Room is valuable for slow teams
          if user_speed < 50
            score += 100  # Slow Pokemon loves Trick Room
          end
          
          # Check if already active (toggle off)
          if battle.field.effects[PBEffects::TrickRoom] > 0
            score -= 50  # Don't want to turn it off (usually)
          end
        end
        
        # Counter / Mirror Coat: Need to take hit first
        if [:COUNTER, :MIRRORCOAT].include?(move.id)
          # Bonus if we can survive and OHKO back
          user_hp_percent = AdvancedAI::CombatUtilities.hp_percent(user)
          if user_hp_percent > 0.70
            score += 60  # Healthy - can survive to counter
          else
            score -= 40  # Too risky if low HP
          end
        end
        
        # Avalanche / Revenge: Double power if hit first
        if [:AVALANCHE, :REVENGE].include?(move.id)
          # Bonus if we're bulky enough to survive
          if user.defense + user.spdef > 200
            score += 40  # Tanky - can take hit for 2x power
          end
        end
      end
      
      # === PRANKSTER ABILITY ===
      # Prankster gives status moves +1 priority
      if user.hasActiveAbility?(:PRANKSTER) && move.statusMove?
        # Treat as priority +1
        if target_speed > user_speed
          score += 50  # Status move goes first!
        else
          score += 20
        end
        
        # EXCEPTION: Dark-types are immune to Prankster
        if target.pbHasType?(:DARK)
          score -= 200  # Move will fail!
        end
      end
      
      # === GALE WINGS ABILITY ===
      # Gale Wings gives Flying moves priority at full HP
      if user.hasActiveAbility?(:GALEWINGS) && move.type == :FLYING
        user_hp_percent = AdvancedAI::CombatUtilities.hp_percent(user)
        if user_hp_percent >= 1.0
          # Treat as priority +1
          score += 40 if target_speed > user_speed
        end
      end
      
      # === TRIAGE ABILITY ===
      # Triage gives healing moves +3 priority
      if user.hasActiveAbility?(:TRIAGE) && move.healingMove?
        # Massive bonus - heal before getting hit
        user_hp_percent = AdvancedAI::CombatUtilities.hp_percent(user)
        if user_hp_percent < 0.50
          score += 80  # Critical healing
        else
          score += 40
        end
      end
      
      return score
    end
    
    #===========================================================================
    # Check for Priority Move Availability
    #===========================================================================
    
    def self.has_priority_move?(user)
      return false unless user
      
      user.moves.each do |move|
        return true if move && get_priority_tier(move) > 0
      end
      
      return false
    end
    
    def self.get_best_priority_move(user, target, battle)
      return nil unless user
      
      best_move = nil
      best_score = -999999
      
      user.moves.each do |move|
        next unless move
        next if get_priority_tier(move) <= 0  # Not a priority move
        
        score = score_priority_advantage(user, move, target, battle)
        if score > best_score
          best_score = score
          best_move = move
        end
      end
      
      return best_move
    end
    
  end
end


#===============================================================================
# Integration: Hook into pbRegisterMove
#===============================================================================

class Battle::AI
  alias priority_tiers_pbRegisterMove pbRegisterMove
  
  def pbRegisterMove(user, move)
    score = priority_tiers_pbRegisterMove(user, move)
    
    return score unless user && move
    
    skill_level = 100
    target = @battle.allOtherSideBattlers(user.index).find { |b| b && !b.fainted? }
    
    # Apply priority tier bonus/penalty
    if target
      priority_score = AdvancedAI::PriorityTiers.score_priority_advantage(user, move, target, @battle, skill_level)
      score += priority_score
    end
    
    return score
  end
end

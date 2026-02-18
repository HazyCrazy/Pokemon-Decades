#===============================================================================
# Advanced AI System - Recoil and Self-Damage Tracking
# Life Orb, recoil moves, confusion self-hit, Belly Drum, substitute HP cost
#===============================================================================

module AdvancedAI
  module RecoilTracking
    
    #===========================================================================
    # Recoil Move Lists
    #===========================================================================
    
    # Moves with recoil damage (% of damage dealt or max HP)
    RECOIL_MOVES = {
      # High recoil (50% of damage dealt)
      :BRAVEBIRD => { type: :dealt, percent: 0.33 },
      :DOUBLEEDGE => { type: :dealt, percent: 0.33 },
      :HEADSMASH => { type: :dealt, percent: 0.50 },
      :VOLTTACKLE => { type: :dealt, percent: 0.33 },
      :WOODHAMMER => { type: :dealt, percent: 0.33 },
      :FLAREBLITZ => { type: :dealt, percent: 0.33 },
      :WILDCHARGE => { type: :dealt, percent: 0.25 },
      :SUBMISSION => { type: :dealt, percent: 0.25 },
      :TAKEDOWN => { type: :dealt, percent: 0.25 },
      
      # Drain HP moves (% of max HP)
      :BELLYDRUM => { type: :max_hp, percent: 0.50 },
      :MINDBLOWN => { type: :max_hp, percent: 0.50 },
      :STEELBEAM => { type: :max_hp, percent: 0.50 },
      :CHLOROBLAST => { type: :max_hp, percent: 0.50 },
    }
    
    # Life Orb: 10% max HP per attack
    LIFE_ORB_RECOIL = 0.10
    
    # Confusion self-hit: 40 BP typeless physical move, 50% chance
    CONFUSION_DAMAGE_BP = 40
    CONFUSION_CHANCE = 0.50
    
    # Substitute: 25% max HP
    SUBSTITUTE_COST = 0.25
    
    # Rocky Helmet / Rough Skin / Iron Barbs: 1/8 max HP per contact
    CONTACT_DAMAGE_FRACTION = 0.125
    
    #===========================================================================
    # Calculate Total Recoil/Self-Damage
    #===========================================================================
    
    def self.calculate_recoil_damage(user, move, damage_dealt = nil)
      return 0 unless user && move
      
      total_recoil = 0
      
      # Move-specific recoil
      if RECOIL_MOVES.key?(move.id)
        recoil_data = RECOIL_MOVES[move.id]
        
        if recoil_data[:type] == :dealt
          # Recoil based on damage dealt (need damage_dealt parameter)
          if damage_dealt && damage_dealt > 0
            total_recoil += (damage_dealt * recoil_data[:percent]).to_i
          else
            # Estimate: assume 50% HP damage dealt as conservative guess
            estimated_damage = user.totalhp * 0.5
            total_recoil += (estimated_damage * recoil_data[:percent]).to_i
          end
          
        elsif recoil_data[:type] == :max_hp
          # Recoil based on max HP (Belly Drum, Mind Blown, etc.)
          total_recoil += (user.totalhp * recoil_data[:percent]).to_i
        end
      end
      
      # Life Orb recoil (only on damaging moves)
      if move.damagingMove? && user.hasActiveItem?(:LIFEORB)
        # Rock Head negates Life Orb recoil
        unless user.hasActiveAbility?(:ROCKHEAD)
          total_recoil += (user.totalhp * LIFE_ORB_RECOIL).to_i
        end
      end
      
      # Magic Guard negates all recoil/self-damage
      if user.hasActiveAbility?(:MAGICGUARD)
        total_recoil = 0
      end
      
      return total_recoil
    end
    
    #===========================================================================
    # Score Penalty for Recoil Risk
    #===========================================================================
    
    def self.score_recoil_penalty(user, move, target, damage_dealt = nil)
      return 0 unless user && move
      
      recoil_damage = self.calculate_recoil_damage(user, move, damage_dealt)
      return 0 if recoil_damage == 0
      
      penalty = 0
      hp_percent_lost = (recoil_damage.to_f / [user.hp, 1].max)
      
      # Massive penalty if recoil would KO self
      if recoil_damage >= user.hp
        penalty += 500  # NEVER use move that kills self (unless it KOs opponent)
      elsif hp_percent_lost >= 0.75
        penalty += 120  # Extremely risky - 75%+ HP loss
      elsif hp_percent_lost >= 0.50
        penalty += 80   # Very risky - 50%+ HP loss
      elsif hp_percent_lost >= 0.33
        penalty += 50   # Risky - 33%+ HP loss
      elsif hp_percent_lost >= 0.20
        penalty += 30   # Moderate risk - 20%+ HP loss
      elsif hp_percent_lost >= 0.10
        penalty += 15   # Minor risk - 10%+ HP loss
      else
        penalty += 5    # Negligible risk
      end
      
      # EXCEPTION: If move will KO opponent, recoil is acceptable
      if move.damagingMove?
        # Rough damage estimate (simplified - could use actual damage calc)
        estimated_damage = self.calculate_rough_damage_for_recoil(user, move, target)
        
        if estimated_damage >= target.hp
          # Move will KO - reduce penalty heavily
          penalty = (penalty * 0.2).to_i  # 80% penalty reduction
          
          # If both die (trade KO scenario)
          if recoil_damage >= user.hp
            # Use team advantage calculator - get battle from battler
            battle = user.respond_to?(:battle) ? user.battle : user.instance_variable_get(:@battle)
            opposing_idx = user.pbOpposingIndices[0] rescue 1
            advantage = AdvancedAI::CombatUtilities.team_advantage(
              battle, user.index, opposing_idx
            )
            
            case advantage
            when 1
              # We have numbers advantage - trade is GOOD
              penalty = -30  # Small BONUS for trading when ahead
            when 0
              # Even teams - trade is NEUTRAL
              penalty = 10  # Tiny penalty (acceptable)
            when -1
              # We're behind - trade is BAD
              penalty = 40  # Moderate penalty (avoid unless necessary)
            end
          end
        end
      end
      
      return -penalty  # Return negative score (penalty)
    end
    
    #===========================================================================
    # Confusion Self-Damage Tracking
    #===========================================================================
    
    def self.calculate_confusion_damage(user)
      return 0 unless user
      return 0 if user.effects[PBEffects::Confusion] == 0
      
      # Confusion self-hit: 40 BP typeless physical move
      # Damage = ((2*Level/5 + 2) * 40 * Atk/Def / 50 + 2) * 0.5 chance
      level = user.level
      atk = user.attack
      defense = user.defense
      
      base_damage = ((2.0 * level / 5 + 2) * CONFUSION_DAMAGE_BP * atk / defense / 50 + 2)
      expected_damage = (base_damage * CONFUSION_CHANCE).to_i
      
      return expected_damage
    end
    
    def self.score_confusion_risk(user)
      return 0 unless user
      return 0 if user.effects[PBEffects::Confusion] == 0
      
      confusion_damage = calculate_confusion_damage(user)
      hp_percent = (confusion_damage.to_f / [user.hp, 1].max)
      
      penalty = 0
      if hp_percent >= 0.50
        penalty += 60  # Huge risk - 50%+ HP from self-hit
      elsif hp_percent >= 0.33
        penalty += 40
      elsif hp_percent >= 0.20
        penalty += 25
      else
        penalty += 10
      end
      
      return -penalty
    end
    
    #===========================================================================
    # Substitute HP Cost Tracking
    #===========================================================================
    
    def self.can_afford_substitute?(user)
      return false unless user
      
      # Need > 25% HP to use Substitute
      required_hp = (user.totalhp * SUBSTITUTE_COST).to_i
      return user.hp > required_hp
    end
    
    def self.score_substitute_cost(user)
      return 0 unless user
      return -200 unless can_afford_substitute?(user)  # Can't afford
      
      hp_percent = user.hp.to_f / user.totalhp
      
      # Lower HP = higher penalty for using Substitute
      penalty = 0
      if hp_percent < 0.40
        penalty += 80  # Very low HP - risky
      elsif hp_percent < 0.60
        penalty += 40  # Moderate HP
      else
        penalty += 10  # Healthy - minimal penalty
      end
      
      return -penalty
    end
    
    #===========================================================================
    # Helper: Rough Damage Estimate for Recoil Decisions
    #===========================================================================
    
    def self.calculate_rough_damage_for_recoil(user, move, target)
      # Use centralized damage calculator
      AdvancedAI::CombatUtilities.estimate_damage(user, move, target)
    end
    
  end
end

#===============================================================================
# Integration: Hook into pbRegisterMove
#===============================================================================

class Battle::AI
  alias recoil_tracking_pbRegisterMove pbRegisterMove
  
  def pbRegisterMove(user, move)
    score = recoil_tracking_pbRegisterMove(user, move)
    
    return score unless user && move
    
    # Apply recoil penalty for recoil moves
    if AdvancedAI::RecoilTracking::RECOIL_MOVES.key?(move.id) || 
       (move.damagingMove? && user.hasActiveItem?(:LIFEORB))
      target = @battle.allOtherSideBattlers(user.index).find { |b| b && !b.fainted? }
      if target
        recoil_penalty = AdvancedAI::RecoilTracking.score_recoil_penalty(user, move, target)
        score += recoil_penalty
      end
    end
    
    # Apply confusion risk if confused
    if user.effects[PBEffects::Confusion] > 0
      confusion_penalty = AdvancedAI::RecoilTracking.score_confusion_risk(user)
      score += confusion_penalty if confusion_penalty < 0
    end
    
    # Substitute cost
    if move.id == :SUBSTITUTE
      sub_penalty = AdvancedAI::RecoilTracking.score_substitute_cost(user)
      score += sub_penalty
    end
    
    return score
  end
end

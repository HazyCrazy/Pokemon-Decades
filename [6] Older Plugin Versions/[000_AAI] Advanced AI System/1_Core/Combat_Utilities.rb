#===============================================================================
# Advanced AI System - Combat Utilities (Shared Functions)
# Centralized damage calculation and common combat utilities
#===============================================================================

module AdvancedAI
  module CombatUtilities
    
    #===========================================================================
    # HP Percentage Calculations (DRY - Don't Repeat Yourself)
    #===========================================================================
    
    def self.hp_percent(battler)
      return 0 unless battler && battler.totalhp > 0
      battler.hp.to_f / battler.totalhp
    end
    
    def self.hp_threshold_score(hp_percent, thresholds)
      # Generic HP-based scoring
      # thresholds: Hash like { 0.33 => 80, 0.50 => 50, 0.70 => 30 }
      thresholds.each do |threshold, score|
        return score if hp_percent < threshold
      end
      return 0
    end
    
    #===========================================================================
    # Simplified Damage Calculation (For Quick Estimates)
    #===========================================================================
    
    def self.estimate_damage(attacker, move, defender, options = {})
      return 0 unless attacker && move && defender
      return 0 unless move.damagingMove?
      
      # Get base power
      power = move.power || 0
      return 0 if power == 0
      
      # Get stats based on move category
      if move.physicalMove?
        atk = attacker.attack
        defense = defender.defense
      elsif move.specialMove?
        atk = attacker.spatk
        defense = defender.spdef
      else
        return 0
      end
      
      # Pokemon damage formula (simplified)
      level = attacker.level
      base_damage = ((2.0 * level / 5 + 2) * power * atk / defense / 50 + 2)
      
      # STAB
      stab = attacker.pbHasType?(move.type) ? 1.5 : 1.0
      
      # Type effectiveness
      effectiveness = Effectiveness.calculate(move.type, *defender.pbTypes(true))
      return 0 if Effectiveness.ineffective?(effectiveness)
      
      effectiveness_mult = effectiveness.to_f / Effectiveness::NORMAL_EFFECTIVE_MULTIPLIER
      
      # Apply modifiers
      estimated_damage = (base_damage * stab * effectiveness_mult * 0.925).to_i
      
      # Optional: Return as percentage
      if options[:as_percent]
        return estimated_damage.to_f / [defender.totalhp, 1].max
      end
      
      return estimated_damage
    end
    
    #===========================================================================
    # Speed Comparison Utilities
    #===========================================================================
    
    def self.speed_tier_difference(user, target)
      return 0 unless user && target
      
      user_speed = user.pbSpeed
      target_speed = target.pbSpeed
      
      return 0 if user_speed == target_speed
      
      # Return ratio (how much faster/slower)
      if target_speed > user_speed
        target_speed.to_f / [user_speed, 1].max  # Positive = opponent faster
      else
        -(user_speed.to_f / [target_speed, 1].max)  # Negative = we're faster
      end
    end
    
    def self.is_faster?(user, target)
      return false unless user && target
      user.pbSpeed > target.pbSpeed
    end
    
    def self.is_much_slower?(user, target, threshold = 1.5)
      speed_diff = speed_tier_difference(user, target)
      speed_diff >= threshold
    end
    
    #===========================================================================
    # Team Size Utilities (For Trade Calculations)
    #===========================================================================
    
    def self.count_alive_pokemon(battle, battler_index)
      return 0 unless battle
      
      party = battle.pbParty(battler_index)
      return 0 unless party
      
      party.count { |p| p && !p.fainted? }
    end
    
    def self.team_advantage(battle, user_index, opponent_index)
      user_count = count_alive_pokemon(battle, user_index)
      opponent_count = count_alive_pokemon(battle, opponent_index)
      
      return 0 if user_count == 0 || opponent_count == 0
      
      # Return: 1 = ahead, 0 = even, -1 = behind
      if user_count > opponent_count
        return 1
      elsif user_count == opponent_count
        return 0
      else
        return -1
      end
    end
    
    #===========================================================================
    # Doubles Battle Utilities
    #===========================================================================
    
    def self.is_doubles?(battle)
      return false unless battle
      battle.pbSideSize(0) > 1
    end
    
    def self.get_partner(battler)
      return nil unless battler
      
      partners = battler.allAllies
      return nil if partners.empty?
      
      partners.first
    end
    
    def self.partner_alive?(battler)
      partner = get_partner(battler)
      partner && !partner.fainted?
    end
    
    #===========================================================================
    # Setup Detection
    #===========================================================================
    
    def self.is_boosted?(battler, threshold = 1)
      return false unless battler
      
      # Check offensive stat boosts
      atk_boost = battler.stages[:ATTACK] || 0
      spatk_boost = battler.stages[:SPECIAL_ATTACK] || 0
      
      (atk_boost + spatk_boost) >= threshold
    end
    
    def self.total_stat_boosts(battler)
      return 0 unless battler
      battler.stages.values.sum
    end
    
    #===========================================================================
    # Common Scoring Patterns
    #===========================================================================
    
    # Generic low HP bonus (desperation / cleanup)
    LOW_HP_THRESHOLDS = {
      0.25 => 60,
      0.33 => 50,
      0.50 => 30,
      0.70 => 15
    }
    
    # Generic partner HP concern
    PARTNER_HP_CONCERN = {
      0.33 => 80,
      0.50 => 50,
      0.70 => 30
    }
    
  end
end

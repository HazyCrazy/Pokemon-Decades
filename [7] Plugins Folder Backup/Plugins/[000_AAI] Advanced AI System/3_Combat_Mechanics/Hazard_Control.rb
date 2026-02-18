#===============================================================================
# Advanced AI System - Hazard Control
# Entry hazard priorities, Defog timing, Heavy-Duty Boots awareness
#===============================================================================

module AdvancedAI
  module HazardControl
    #===========================================================================
    # Hazard Definitions
    #===========================================================================
    
    HAZARD_SETTERS = [:STEALTHROCK, :SPIKES, :TOXICSPIKES, :STICKYWEB]
    HAZARD_REMOVERS = [:DEFOG, :RAPIDSPIN, :COURTCHANGE, :MORTALSPIN, :TIDYUP]
    
    #===========================================================================
    # Hazard Damage Calculation
    #===========================================================================
    
    # Calculate exact hazard damage for a Pokemon switching in
    def self.calculate_hazard_damage(battle, battler, side_effects)
      return 0 unless battler
      
      total_damage = 0
      
      # Stealth Rock
      if side_effects[PBEffects::StealthRock]
        sr_damage = calculate_stealth_rock_damage(battler)
        total_damage += sr_damage
      end
      
      # Spikes (1, 2, or 3 layers)
      spikes = side_effects[PBEffects::Spikes] || 0
      if spikes > 0 && is_grounded?(battler)
        spikes_damage = case spikes
                        when 1 then battler.totalhp / 8
                        when 2 then battler.totalhp / 6
                        else battler.totalhp / 4  # 3 layers
                        end
        total_damage += spikes_damage
      end
      
      # Toxic Spikes (poison or badly poison)
      # Doesn't do direct damage, but important to track
      
      # Sticky Web (speed drop, not damage)
      
      total_damage
    end
    
    # Stealth Rock damage based on type
    def self.calculate_stealth_rock_damage(battler)
      return 0 unless battler
      
      type_mod = Effectiveness.calculate(:ROCK, *battler.pbTypes(true))
      
      # Base: 1/8 max HP, modified by effectiveness
      base = battler.totalhp / 8
      
      multiplier = type_mod / Effectiveness::NORMAL_EFFECTIVE.to_f
      (base * multiplier).to_i
    end
    
    # Check if grounded (for Spikes/Toxic Spikes/Sticky Web)
    def self.is_grounded?(battler)
      return false unless battler
      
      # Flying type
      return false if battler.pbHasType?(:FLYING)
      
      # Levitate
      return false if battler.ability_id == :LEVITATE
      
      # Air Balloon
      return false if battler.item_id == :AIRBALLOON
      
      # Magnet Rise effect
      if battler.effects[PBEffects::MagnetRise] && battler.effects[PBEffects::MagnetRise] > 0
        return false
      end
      
      # Telekinesis
      if battler.effects[PBEffects::Telekinesis] && battler.effects[PBEffects::Telekinesis] > 0
        return false
      end
      
      true
    end
    
    #===========================================================================
    # Hazard Setting Priority
    #===========================================================================
    
    def self.evaluate_hazard_setting(battle, attacker, move, skill_level = 100)
      return 0 unless skill_level >= 50
      return 0 unless HAZARD_SETTERS.include?(move.id)
      
      score = 0
      opp_side = battle.sides[(attacker.index + 1) % 2]
      
      case move.id
      when :STEALTHROCK
        score += evaluate_stealth_rock(battle, attacker, opp_side, skill_level)
      when :SPIKES
        score += evaluate_spikes(battle, attacker, opp_side, skill_level)
      when :TOXICSPIKES
        score += evaluate_toxic_spikes(battle, attacker, opp_side, skill_level)
      when :STICKYWEB
        score += evaluate_sticky_web(battle, attacker, opp_side, skill_level)
      end
      
      # Penalty if opponent has Defog/Spin user
      opponents = battle.allOtherSideBattlers(attacker.index).select { |b| b && !b.fainted? }
      has_removal = opponents.any? do |opp|
        opp.moves.any? { |m| m && HAZARD_REMOVERS.include?(m.id) }
      end
      
      if has_removal
        score -= 15  # They might remove it
      end
      
      # Bonus if opponent switches a lot
      # (Would need switch tracking to implement properly)
      
      score
    end
    
    def self.evaluate_stealth_rock(battle, attacker, opp_side, skill_level)
      # Already up?
      if opp_side.effects[PBEffects::StealthRock]
        return -80
      end
      
      score = 30  # Base value
      
      # Check opponent's team for SR weakness
      opp_party = battle.pbParty((attacker.index + 1) % 2)
      
      opp_party.each do |pkmn|
        next unless pkmn && !pkmn.fainted?
        
        # Party Pokemon use type1/type2, not types array
        type_mod = Effectiveness.calculate(:ROCK, pkmn.type1, pkmn.type2)
        
        if type_mod >= Effectiveness::SUPER_EFFECTIVE_ONE * 2  # 4x weak
          score += 25
        elsif type_mod >= Effectiveness::SUPER_EFFECTIVE_ONE  # 2x weak
          score += 15
        elsif type_mod <= Effectiveness::NOT_VERY_EFFECTIVE_ONE  # Resist
          score -= 5
        end
        
        # Heavy-Duty Boots negates
        if pkmn.item_id == :HEAVYDUTYBOOTS
          score -= 10
        end
      end
      
      score
    end
    
    def self.evaluate_spikes(battle, attacker, opp_side, skill_level)
      layers = opp_side.effects[PBEffects::Spikes] || 0
      
      # Max 3 layers
      if layers >= 3
        return -80
      end
      
      score = 20 - (layers * 5)  # Diminishing returns
      
      # Check grounded opponents
      opp_party = battle.pbParty((attacker.index + 1) % 2)
      grounded = opp_party.count do |pkmn|
        next false unless pkmn && !pkmn.fainted?
        # Party Pokemon use hasType? not pbHasType?, and ability_id not ability
        !pkmn.hasType?(:FLYING) && pkmn.ability_id != :LEVITATE
      end
      
      score += grounded * 10
      
      # Heavy-Duty Boots check
      boots_users = opp_party.count { |p| p && p.item_id == :HEAVYDUTYBOOTS }
      score -= boots_users * 8
      
      score
    end
    
    def self.evaluate_toxic_spikes(battle, attacker, opp_side, skill_level)
      layers = opp_side.effects[PBEffects::ToxicSpikes] || 0
      
      # Max 2 layers
      if layers >= 2
        return -80
      end
      
      score = 25 - (layers * 10)
      
      opp_party = battle.pbParty((attacker.index + 1) % 2)
      
      # Poison/Steel types absorb or are immune
      absorbers = opp_party.count do |pkmn|
        next false unless pkmn && !pkmn.fainted?
        # Party Pokemon use hasType? not pbHasType?
        pkmn.hasType?(:POISON) || pkmn.hasType?(:STEEL)
      end
      
      if absorbers > 0
        score -= absorbers * 15  # Poison types remove T-Spikes
      end
      
      # Grounded non-immune targets
      valid_targets = opp_party.count do |pkmn|
        next false unless pkmn && !pkmn.fainted?
        is_grounded_basic?(pkmn) && !pkmn.hasType?(:POISON) && !pkmn.hasType?(:STEEL)
      end
      
      score += valid_targets * 12
      
      score
    end
    
    def self.evaluate_sticky_web(battle, attacker, opp_side, skill_level)
      # Already up?
      if opp_side.effects[PBEffects::StickyWeb]
        return -80
      end
      
      score = 25
      
      opp_party = battle.pbParty((attacker.index + 1) % 2)
      
      # Fast grounded opponents benefit us
      fast_grounded = opp_party.count do |pkmn|
        next false unless pkmn && !pkmn.fainted?
        is_grounded_basic?(pkmn) && pkmn.speed >= 80
      end
      
      score += fast_grounded * 15
      
      # Defiant/Competitive punish - use ability_id for party Pokemon
      punishers = opp_party.count do |p|
        p && !p.fainted? && [:DEFIANT, :COMPETITIVE, :CONTRARY].include?(p.ability_id)
      end
      
      score -= punishers * 20
      
      score
    end
    
    #===========================================================================
    # Hazard Removal Priority
    #===========================================================================
    
    def self.evaluate_hazard_removal(battle, attacker, move, skill_level = 100)
      return 0 unless skill_level >= 55
      return 0 unless HAZARD_REMOVERS.include?(move.id)
      
      score = 0
      our_side = battle.sides[attacker.index % 2]
      opp_side = battle.sides[(attacker.index + 1) % 2]
      
      case move.id
      when :DEFOG
        score += evaluate_defog(battle, attacker, our_side, opp_side, skill_level)
      when :RAPIDSPIN
        score += evaluate_rapid_spin(battle, attacker, our_side, skill_level)
      when :COURTCHANGE
        score += evaluate_court_change(battle, our_side, opp_side, skill_level)
      when :MORTALSPIN
        score += evaluate_mortal_spin(battle, attacker, our_side, skill_level)
      when :TIDYUP
        score += evaluate_tidy_up_hazards(battle, attacker, skill_level)
      end
      
      score
    end
    
    def self.evaluate_defog(battle, attacker, our_side, opp_side, skill_level)
      score = 0
      
      # Value of removing our hazards
      if our_side.effects[PBEffects::StealthRock]
        score += 25
        
        # Extra value if we have SR-weak Pokemon in back
        party = battle.pbParty(attacker.index)
        sr_weak = party.count do |p|
          next false unless p && !p.fainted? && p != attacker.pokemon
          # Party Pokemon use type1/type2, not types[]
          type_mod = Effectiveness.calculate(:ROCK, p.type1, p.type2)
          type_mod >= Effectiveness::SUPER_EFFECTIVE_ONE
        end
        score += sr_weak * 10
      end
      
      spikes = our_side.effects[PBEffects::Spikes] || 0
      score += spikes * 10
      
      tspikes = our_side.effects[PBEffects::ToxicSpikes] || 0
      score += tspikes * 8
      
      if our_side.effects[PBEffects::StickyWeb]
        score += 20
      end
      
      # Penalty for removing opponent's hazards too
      if opp_side.effects[PBEffects::StealthRock]
        score -= 15
      end
      
      opp_spikes = opp_side.effects[PBEffects::Spikes] || 0
      score -= opp_spikes * 8
      
      # Also removes screens (bad if we have screens)
      if our_side.effects[PBEffects::Reflect] && our_side.effects[PBEffects::Reflect] > 0
        score -= 20
      end
      if our_side.effects[PBEffects::LightScreen] && our_side.effects[PBEffects::LightScreen] > 0
        score -= 20
      end
      
      score
    end
    
    def self.evaluate_rapid_spin(battle, attacker, our_side, skill_level)
      score = 0
      
      # Only removes our side hazards
      if our_side.effects[PBEffects::StealthRock]
        score += 25
      end
      
      spikes = our_side.effects[PBEffects::Spikes] || 0
      score += spikes * 10
      
      tspikes = our_side.effects[PBEffects::ToxicSpikes] || 0
      score += tspikes * 8
      
      if our_side.effects[PBEffects::StickyWeb]
        score += 20
      end
      
      # Removes Leech Seed, Bind, etc.
      if attacker.effects[PBEffects::LeechSeed] && attacker.effects[PBEffects::LeechSeed] >= 0
        score += 15
      end
      
      # Also raises Speed in Gen 8+
      score += 10
      
      # Ghost types make Spin fail
      opponents = battle.allOtherSideBattlers(attacker.index).select { |b| b && !b.fainted? }
      ghost_present = opponents.any? { |o| o.pbHasType?(:GHOST) }
      
      if ghost_present
        score -= 40  # Will fail
      end
      
      score
    end
    
    def self.evaluate_court_change(battle, our_side, opp_side, skill_level)
      score = 0
      
      # Swap hazards - good if we have none and they have some
      our_hazards = count_hazards(our_side)
      their_hazards = count_hazards(opp_side)
      
      # Also swaps screens, Tailwind, etc.
      our_screens = count_screens(our_side)
      their_screens = count_screens(opp_side)
      
      # Net hazard advantage
      score += (our_hazards - their_hazards) * 15
      
      # Net screen disadvantage (we lose screens, they gain them)
      score -= (our_screens - their_screens) * 20
      
      score
    end
    
    def self.evaluate_mortal_spin(battle, attacker, our_side, skill_level)
      score = 0
      
      # Rapid Spin + Poison effect
      if our_side.effects[PBEffects::StealthRock]
        score += 20
      end
      
      spikes = our_side.effects[PBEffects::Spikes] || 0
      score += spikes * 8
      
      # Poisons all adjacent opponents
      opponents = battle.allOtherSideBattlers(attacker.index).select { |b| b && !b.fainted? }
      poisonable = opponents.count do |o|
        o.status == :NONE && !o.pbHasType?(:POISON) && !o.pbHasType?(:STEEL)
      end
      
      score += poisonable * 15
      
      score
    end
    
    def self.evaluate_tidy_up_hazards(battle, attacker, skill_level)
      score = 0
      
      our_side = battle.sides[attacker.index % 2]
      opp_side = battle.sides[(attacker.index + 1) % 2]
      
      # Removes ALL hazards (both sides)
      our_hazards = count_hazards(our_side)
      their_hazards = count_hazards(opp_side)
      
      score += our_hazards * 15
      score -= their_hazards * 10
      
      # Also removes Substitutes
      opponents = battle.allOtherSideBattlers(attacker.index).select { |b| b && !b.fainted? }
      subs = opponents.count { |o| o.effects[PBEffects::Substitute] && o.effects[PBEffects::Substitute] > 0 }
      score += subs * 20
      
      # +1 Atk and Speed
      score += 20
      
      score
    end
    
    #===========================================================================
    # Heavy-Duty Boots Awareness
    #===========================================================================
    
    def self.has_heavy_duty_boots?(battler)
      return false unless battler
      battler.item_id == :HEAVYDUTYBOOTS
    end
    
    def self.evaluate_boots_vs_hazards(battle, battler, skill_level = 100)
      return 0 unless skill_level >= 60
      return 0 unless battler
      
      our_side = battle.sides[battler.index % 2]
      
      score = 0
      
      if has_heavy_duty_boots?(battler)
        # We're immune to hazards - switch in freely
        if our_side.effects[PBEffects::StealthRock]
          sr_damage = calculate_stealth_rock_damage(battler)
          score += (sr_damage * 100 / battler.totalhp)  # % HP saved
        end
        
        spikes = our_side.effects[PBEffects::Spikes] || 0
        if spikes > 0 && is_grounded?(battler)
          score += spikes * 5
        end
      end
      
      score
    end
    
    #===========================================================================
    # Helper Methods
    #===========================================================================
    private
    
    def self.count_hazards(side_effects)
      count = 0
      count += 1 if side_effects[PBEffects::StealthRock]
      count += side_effects[PBEffects::Spikes] || 0
      count += side_effects[PBEffects::ToxicSpikes] || 0
      count += 1 if side_effects[PBEffects::StickyWeb]
      count
    end
    
    def self.count_screens(side_effects)
      count = 0
      count += 1 if side_effects[PBEffects::Reflect] && side_effects[PBEffects::Reflect] > 0
      count += 1 if side_effects[PBEffects::LightScreen] && side_effects[PBEffects::LightScreen] > 0
      count += 1 if side_effects[PBEffects::AuroraVeil] && side_effects[PBEffects::AuroraVeil] > 0
      count
    end
    
    def self.is_grounded_basic?(pokemon)
      return false unless pokemon
      # Party Pokemon (Pokemon objects) use hasType? and ability_id
      !pokemon.hasType?(:FLYING) && pokemon.ability_id != :LEVITATE
    end
  end
end

# API Methods
module AdvancedAI
  def self.calculate_hazard_damage(battle, battler, side_effects)
    HazardControl.calculate_hazard_damage(battle, battler, side_effects)
  end
  
  def self.calculate_stealth_rock_damage(battler)
    HazardControl.calculate_stealth_rock_damage(battler)
  end
  
  def self.evaluate_hazard_setting(battle, attacker, move, skill_level = 100)
    HazardControl.evaluate_hazard_setting(battle, attacker, move, skill_level)
  end
  
  def self.evaluate_hazard_removal(battle, attacker, move, skill_level = 100)
    HazardControl.evaluate_hazard_removal(battle, attacker, move, skill_level)
  end
  
  def self.is_grounded?(battler)
    HazardControl.is_grounded?(battler)
  end
  
  def self.has_heavy_duty_boots?(battler)
    HazardControl.has_heavy_duty_boots?(battler)
  end
  
  def self.evaluate_boots_vs_hazards(battle, battler, skill_level = 100)
    HazardControl.evaluate_boots_vs_hazards(battle, battler, skill_level)
  end
end

AdvancedAI.log("Hazard Control System loaded", "Hazards")
AdvancedAI.log("  - Hazard damage calculation", "Hazards")
AdvancedAI.log("  - Stealth Rock type weakness check", "Hazards")
AdvancedAI.log("  - Spikes layer optimization", "Hazards")
AdvancedAI.log("  - Toxic Spikes vs Poison types", "Hazards")
AdvancedAI.log("  - Sticky Web speed control", "Hazards")
AdvancedAI.log("  - Defog decision making", "Hazards")
AdvancedAI.log("  - Rapid Spin (Ghost blocker awareness)", "Hazards")
AdvancedAI.log("  - Court Change hazard swapping", "Hazards")
AdvancedAI.log("  - Heavy-Duty Boots awareness", "Hazards")

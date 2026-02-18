#===============================================================================
# Advanced AI System - Speed Tiers
# Speed tier awareness, Scarf detection, effective speed calculations
#===============================================================================

module AdvancedAI
  module SpeedTiers
    #===========================================================================
    # Speed Tier Definitions (VGC Meta)
    #===========================================================================
    SPEED_TIERS = {
      ultra_fast: { min: 130, name: "Ultra Fast (130+)" },      # Regieleki, Electrode
      very_fast: { min: 110, name: "Very Fast (110-129)" },     # Weavile, Gengar
      fast: { min: 95, name: "Fast (95-109)" },                 # Garchomp, Hydreigon
      medium_fast: { min: 80, name: "Medium-Fast (80-94)" },    # Gyarados, Dragonite
      medium: { min: 60, name: "Medium (60-79)" },              # Tyranitar, Gastrodon
      slow: { min: 40, name: "Slow (40-59)" },                  # Ferrothorn, Dondozo
      very_slow: { min: 0, name: "Very Slow (<40)" }            # Trick Room mons
    }
    
    # Common Scarf benchmarks (base speeds that commonly run Scarf)
    COMMON_SCARF_USERS = [
      :LANDORUS, :LANDORUSTHERIAN, :URSHIFU, :URSHIFURAPIDSTRIKE,
      :DARMANITAN, :DITTO, :EXCADRILL, :HYDREIGON, :KARTANA,
      :TYRANITAR, :MAGNEZONE, :ROTOMWASH, :ROTOMHEAT,
      :GARCHOMP, :SALAMENCE, :CHANDELURE, :GOTHITELLE
    ]
    
    #===========================================================================
    # Effective Speed Calculation
    #===========================================================================
    
    # Calculate actual speed including all modifiers
    def self.calculate_effective_speed(battle, battler)
      return 0 unless battler && !battler.fainted?
      
      # Base speed with stages
      speed = battler.speed
      
      # Stat stage modifier
      stage = battler.stages[:SPEED] || 0
      if stage >= 0
        speed = speed * (2 + stage) / 2
      else
        speed = speed * 2 / (2 - stage)
      end
      
      # Paralysis halves speed (Gen 7+: 50%)
      if battler.status == :PARALYSIS
        speed /= 2 unless battler.ability_id == :QUICKFEET
      end
      
      # Abilities
      case battler.ability_id
      when :SWIFTSWIM
        if battle.field.weather == :Rain
          speed *= 2
        end
      when :CHLOROPHYLL
        if battle.field.weather == :Sun
          speed *= 2
        end
      when :SANDRUSH
        if battle.field.weather == :Sandstorm
          speed *= 2
        end
      when :SLUSHRUSH
        if [:Hail, :Snow].include?(battle.field.weather)
          speed *= 2
        end
      when :UNBURDEN
        if battler.effects[PBEffects::Unburden] # Item consumed
          speed *= 2
        end
      when :QUICKFEET
        if battler.status != :NONE
          speed = speed * 1.5
        end
      when :SLOWSTART
        if battler.effects[PBEffects::SlowStart] && battler.effects[PBEffects::SlowStart] > 0
          speed /= 2
        end
      end
      
      # Items
      case battler.item_id
      when :CHOICESCARF
        speed = speed * 1.5
      when :IRONBALL
        speed /= 2
      when :MACHOBRACE, :POWERANKLET, :POWERBAND, :POWERBELT,
           :POWERBRACER, :POWERLENS, :POWERWEIGHT
        speed /= 2
      when :QUICKPOWDER
        if battler.species == :DITTO && !battler.effects[PBEffects::Transform]
          speed *= 2
        end
      end
      
      # Tailwind
      own_side = battle.sides[battler.index % 2]
      if own_side.effects[PBEffects::Tailwind] && own_side.effects[PBEffects::Tailwind] > 0
        speed *= 2
      end
      
      # Sticky Web
      # Note: Already applied as stage drop, no additional calc needed
      
      speed.to_i
    end
    
    # Compare speeds considering Trick Room
    def self.compare_speed(battle, battler1, battler2)
      speed1 = calculate_effective_speed(battle, battler1)
      speed2 = calculate_effective_speed(battle, battler2)
      
      trick_room = battle.field.effects[PBEffects::TrickRoom] &&
                   battle.field.effects[PBEffects::TrickRoom] > 0
      
      if trick_room
        # Slower moves first in Trick Room
        if speed1 < speed2
          return 1  # battler1 goes first
        elsif speed1 > speed2
          return -1  # battler2 goes first
        end
      else
        # Faster moves first normally
        if speed1 > speed2
          return 1
        elsif speed1 < speed2
          return -1
        end
      end
      
      0  # Speed tie
    end
    
    # Check if battler1 outspeeds battler2
    def self.outspeeds?(battle, battler1, battler2)
      compare_speed(battle, battler1, battler2) > 0
    end
    
    #===========================================================================
    # Speed Tier Analysis
    #===========================================================================
    
    def self.get_speed_tier(base_speed)
      SPEED_TIERS.each do |tier, data|
        if base_speed >= data[:min]
          return tier
        end
      end
      :very_slow
    end
    
    def self.in_same_speed_tier?(battler1, battler2)
      tier1 = get_speed_tier(battler1.speed)
      tier2 = get_speed_tier(battler2.speed)
      tier1 == tier2
    end
    
    #===========================================================================
    # Choice Scarf Detection
    #===========================================================================
    
    # Suspect opponent has Choice Scarf
    def self.suspect_choice_scarf?(battle, battler, skill_level = 100)
      return false unless skill_level >= 70
      return false unless battler
      
      # Already revealed item
      return battler.item_id == :CHOICESCARF if battler.item_id
      
      # Common Scarf users
      if COMMON_SCARF_USERS.include?(battler.species)
        return true
      end
      
      # Moved first when they shouldn't have?
      # This would require tracking turn order history
      # For now, use species heuristics
      
      # Check if they're Choice-locked (same move twice)
      if battler.effects[PBEffects::ChoiceBand]
        # They're Choice locked - could be Scarf
        return true if battler.speed >= 80 && battler.speed <= 100
      end
      
      false
    end
    
    # Calculate "what if they have Scarf" speed
    def self.scarf_adjusted_speed(battle, battler)
      base_speed = calculate_effective_speed(battle, battler)
      
      # If already has Scarf, return as-is
      return base_speed if battler.item_id == :CHOICESCARF
      
      # Calculate potential Scarf speed
      (base_speed * 1.5).to_i
    end
    
    # Would we still outspeed if they have Scarf?
    def self.outspeeds_with_scarf?(battle, user, target)
      our_speed = calculate_effective_speed(battle, user)
      their_scarf_speed = scarf_adjusted_speed(battle, target)
      
      trick_room = battle.field.effects[PBEffects::TrickRoom] &&
                   battle.field.effects[PBEffects::TrickRoom] > 0
      
      if trick_room
        our_speed < their_scarf_speed
      else
        our_speed > their_scarf_speed
      end
    end
    
    #===========================================================================
    # Speed Control Evaluation
    #===========================================================================
    
    # Evaluate speed control moves
    def self.evaluate_speed_control(battle, attacker, move, skill_level = 100)
      return 0 unless skill_level >= 60
      
      score = 0
      
      case move.id
      when :TAILWIND
        score += evaluate_tailwind_value(battle, attacker, skill_level)
      when :TRICKROOM
        score += evaluate_trick_room_value(battle, attacker, skill_level)
      when :ICYWIND, :ELECTROWEB, :BULLDOZE, :ROCKTOMB, :LOWSWEEP
        score += evaluate_speed_drop_attack(battle, attacker, move, skill_level)
      when :STICKYWEB
        score += evaluate_sticky_web(battle, attacker, skill_level)
      when :STRINGSHOT, :COTTONSPORE, :SCARYFACE
        score += evaluate_speed_drop_status(battle, attacker, move, skill_level)
      end
      
      score
    end
    
    # Tailwind value
    def self.evaluate_tailwind_value(battle, attacker, skill_level)
      return 0 if skill_level < 65
      
      score = 0
      own_side = battle.sides[attacker.index % 2]
      
      # Already have Tailwind?
      if own_side.effects[PBEffects::Tailwind] && own_side.effects[PBEffects::Tailwind] > 0
        return -80  # Already active
      end
      
      # Count speed matchups
      allies = battle.allSameSideBattlers(attacker.index).select { |b| b && !b.fainted? }
      opponents = battle.allOtherSideBattlers(attacker.index).select { |b| b && !b.fainted? }
      
      currently_outspeed = 0
      would_outspeed = 0
      
      allies.each do |ally|
        opponents.each do |opp|
          ally_speed = calculate_effective_speed(battle, ally)
          opp_speed = calculate_effective_speed(battle, opp)
          
          currently_outspeed += 1 if ally_speed > opp_speed
          would_outspeed += 1 if (ally_speed * 2) > opp_speed
        end
      end
      
      # Value based on speed matchup improvement
      improvement = would_outspeed - currently_outspeed
      score += improvement * 20
      
      # Base value for Tailwind
      score += 25 if improvement > 0
      
      score
    end
    
    # Trick Room value
    def self.evaluate_trick_room_value(battle, attacker, skill_level)
      return 0 if skill_level < 70
      
      score = 0
      
      # Check if TR is active
      tr_active = battle.field.effects[PBEffects::TrickRoom] &&
                  battle.field.effects[PBEffects::TrickRoom] > 0
      
      if tr_active
        # We might want to reset TR (cancel it)
        # Only if TR is bad for us
        allies = battle.allSameSideBattlers(attacker.index).select { |b| b && !b.fainted? }
        opponents = battle.allOtherSideBattlers(attacker.index).select { |b| b && !b.fainted? }
        
        our_slow = allies.count { |a| a.speed < 60 }
        their_slow = opponents.count { |o| o.speed < 60 }
        
        if their_slow > our_slow
          score += 40  # Cancel their TR
        else
          score -= 60  # Don't cancel our TR
        end
      else
        # Set TR
        allies = battle.allSameSideBattlers(attacker.index).select { |b| b && !b.fainted? }
        opponents = battle.allOtherSideBattlers(attacker.index).select { |b| b && !b.fainted? }
        
        our_slow = allies.count { |a| a.speed < 60 }
        their_slow = opponents.count { |o| o.speed < 60 }
        
        if our_slow > their_slow
          score += 50 + (our_slow * 15)  # We benefit from TR
        else
          score -= 30  # TR helps them more
        end
      end
      
      score
    end
    
    # Speed-dropping attacks
    def self.evaluate_speed_drop_attack(battle, attacker, move, skill_level)
      return 0 if skill_level < 55
      
      score = 0
      
      opponents = battle.allOtherSideBattlers(attacker.index).select { |b| b && !b.fainted? }
      
      # How many opponents would we flip speed on?
      flips = 0
      opponents.each do |opp|
        our_speed = calculate_effective_speed(battle, attacker)
        their_speed = calculate_effective_speed(battle, opp)
        
        # If we're slower but would be faster after their speed drops
        if their_speed > our_speed
          # -1 speed stage = 2/3 speed
          new_their_speed = (their_speed * 2 / 3)
          if our_speed > new_their_speed
            flips += 1
          end
        end
      end
      
      score += flips * 20
      
      # Spread moves get bonus
      if [:ICYWIND, :ELECTROWEB, :BULLDOZE].include?(move.id)
        score += 10  # Hits multiple
      end
      
      score
    end
    
    # Sticky Web
    def self.evaluate_sticky_web(battle, attacker, skill_level)
      return 0 if skill_level < 65
      
      score = 0
      opp_side = battle.sides[(attacker.index + 1) % 2]
      
      # Already up?
      if opp_side.effects[PBEffects::StickyWeb]
        return -80
      end
      
      # Check opponent's back line speeds
      opp_party = battle.pbParty((attacker.index + 1) % 2)
      grounded_fast = opp_party.count do |pkmn|
        next false unless pkmn && !pkmn.fainted?
        # Fast and grounded (pkmn is party Pokemon, use hasType? and ability_id)
        pkmn.speed >= 80 && !pkmn.hasType?(:FLYING) && pkmn.ability_id != :LEVITATE
      end
      
      score += grounded_fast * 15
      score += 20 if grounded_fast >= 2
      
      score
    end
    
    # Pure speed drop status moves
    def self.evaluate_speed_drop_status(battle, attacker, move, skill_level)
      return 0 if skill_level < 60
      
      # Similar to speed drop attacks but single target
      10
    end
    
    #===========================================================================
    # Speed Tie Handling
    #===========================================================================
    
    def self.is_speed_tie?(battle, battler1, battler2)
      compare_speed(battle, battler1, battler2) == 0
    end
    
    # In speed ties, consider worst case
    def self.evaluate_speed_tie_risk(battle, user, target, skill_level = 100)
      return 0 unless skill_level >= 75
      return 0 unless is_speed_tie?(battle, user, target)
      
      # 50/50 speed tie - consider if losing is bad
      score = 0
      
      # Check if opponent could OHKO us
      target.moves.each do |move|
        next unless move && move.damagingMove?
        
        # Estimate if this could OHKO
        type_mod = Effectiveness.calculate(move.type, user.types[0], user.types[1])
        if Effectiveness.super_effective?(type_mod)
          # They have a SE move - speed tie is risky
          score -= 15
        end
      end
      
      score
    end
    
    private
    
    # Helper for tracking turn order (future enhancement)
    def self.record_turn_order(battle, first_battler, second_battler)
      # Could track to detect Scarf users
    end
  end
end

# API Methods
module AdvancedAI
  def self.calculate_effective_speed(battle, battler)
    SpeedTiers.calculate_effective_speed(battle, battler)
  end
  
  def self.outspeeds?(battle, battler1, battler2)
    SpeedTiers.outspeeds?(battle, battler1, battler2)
  end
  
  def self.get_speed_tier(battler)
    SpeedTiers.get_speed_tier(battler.speed)
  end
  
  def self.suspect_choice_scarf?(battle, battler, skill_level = 100)
    SpeedTiers.suspect_choice_scarf?(battle, battler, skill_level)
  end
  
  def self.outspeeds_with_scarf?(battle, user, target)
    SpeedTiers.outspeeds_with_scarf?(battle, user, target)
  end
  
  def self.evaluate_speed_control(battle, attacker, move, skill_level = 100)
    SpeedTiers.evaluate_speed_control(battle, attacker, move, skill_level)
  end
  
  def self.is_speed_tie?(battle, battler1, battler2)
    SpeedTiers.is_speed_tie?(battle, battler1, battler2)
  end
  
  def self.evaluate_speed_tie_risk(battle, user, target, skill_level = 100)
    SpeedTiers.evaluate_speed_tie_risk(battle, user, target, skill_level)
  end
end

AdvancedAI.log("Speed Tiers System loaded", "Speed")
AdvancedAI.log("  - Effective speed calculation", "Speed")
AdvancedAI.log("  - Weather ability speed boosts", "Speed")
AdvancedAI.log("  - Tailwind / Trick Room awareness", "Speed")
AdvancedAI.log("  - Choice Scarf detection", "Speed")
AdvancedAI.log("  - Speed tier classification", "Speed")
AdvancedAI.log("  - Speed control move evaluation", "Speed")
AdvancedAI.log("  - Speed tie risk assessment", "Speed")

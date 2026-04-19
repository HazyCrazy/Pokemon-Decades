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
    # Move Type & Power Resolution (Shared Helpers)
    #===========================================================================
    
    # Resolve the effective type of a move considering -ate abilities, Tera Blast,
    # Weather Ball, and Terrain Pulse.
    # Works with both Battler objects (hasActiveAbility?) and Pokemon objects (ability_id).
    def self.resolve_move_type(user, move)
      effective_type = move.type
      # Handle -ate abilities: Normal moves → typed
      if effective_type == :NORMAL
        ate_map = { PIXILATE: :FAIRY, AERILATE: :FLYING, REFRIGERATE: :ICE, GALVANIZE: :ELECTRIC }
        if user.respond_to?(:hasActiveAbility?)
          ate_ability = ate_map.keys.find { |a| user.hasActiveAbility?(a) }
        elsif user.respond_to?(:ability_id)
          ate_ability = ate_map.keys.find { |a| user.ability_id == a }
        end
        effective_type = ate_map[ate_ability] if ate_ability
      end
      # Handle Tera Blast: becomes user's Tera type when Terastallized
      if move.respond_to?(:id) && move.id == :TERABLAST
        battler = user.respond_to?(:battler) ? user.battler : user
        if battler.respond_to?(:tera?) && battler.tera? &&
           battler.respond_to?(:pokemon) && battler.pokemon.respond_to?(:tera_type)
          tera_type = battler.pokemon.tera_type
          effective_type = tera_type if tera_type
        end
      end
      # Handle Weather Ball: type changes based on active weather
      if move.respond_to?(:id) && move.id == :WEATHERBALL
        battle = user.respond_to?(:battle) ? user.battle : nil
        if battle
          weather = battle.pbWeather rescue :None
          case weather
          when :Sun, :HarshSun   then effective_type = :FIRE
          when :Rain, :HeavyRain then effective_type = :WATER
          when :Sandstorm        then effective_type = :ROCK
          when :Hail, :Snow      then effective_type = :ICE
          end
        end
      end
      # Handle Terrain Pulse: type changes based on active terrain (grounded user)
      if move.respond_to?(:id) && move.id == :TERRAINPULSE
        battle = user.respond_to?(:battle) ? user.battle : nil
        if battle
          terrain = battle.field.terrain rescue nil
          if terrain && user.respond_to?(:affectedByTerrain?) && user.affectedByTerrain?
            case terrain
            when :Electric then effective_type = :ELECTRIC
            when :Grassy   then effective_type = :GRASS
            when :Psychic  then effective_type = :PSYCHIC
            when :Misty    then effective_type = :FAIRY
            end
          end
        end
      end
      effective_type
    end
    
    # Calculate type effectiveness accounting for Scrappy / Mind's Eye.
    # Scrappy/Mind's Eye allow Normal and Fighting moves to hit Ghost types.
    # Works with both Battler objects (hasActiveAbility?) and Pokemon objects (ability_id).
    def self.scrappy_effectiveness(effective_type, user, defender_types)
      type_mod = Effectiveness.calculate(effective_type, *defender_types)
      if Effectiveness.ineffective?(type_mod) && [:NORMAL, :FIGHTING].include?(effective_type)
        has_scrappy = if user.respond_to?(:hasActiveAbility?)
                        user.hasActiveAbility?(:SCRAPPY) || user.hasActiveAbility?(:MINDSEYE)
                      elsif user.respond_to?(:ability_id)
                        ([:SCRAPPY, :MINDSEYE].include?(user.ability_id) rescue false)
                      else
                        false
                      end
        if has_scrappy
          non_ghost = defender_types.reject { |t| t == :GHOST }
          type_mod = non_ghost.empty? ? Effectiveness::NORMAL_EFFECTIVE_MULTIPLIER :
                     Effectiveness.calculate(effective_type, *non_ghost)
        end
      end
      type_mod
    end

    # Resolve effective base power for variable-power moves.
    # The engine uses power=1 in PBS for variable-power moves; convert to 60 (engine default).
    def self.resolve_move_power(move)
      power = move.power
      return 0 if power == 0
      return 60 if power == 1  # Variable-power move (Gyro Ball, Electro Ball, etc.)
      power
    end
    
    #===========================================================================
    # Field & Context Modifier (weather, terrain, items, burn)
    # Shared helper for all simplified damage calcs to avoid duplication.
    #===========================================================================
    
    def self.field_modifier(battle, attacker, effective_type, move, is_physical, target = nil)
      mod = 1.0
      battle ||= attacker.battle if attacker.respond_to?(:battle)
      return mod unless battle
      
      # Weather modifiers (Sun/Rain boost/nerf Fire/Water by 1.5x/0.5x)
      weather = battle.pbWeather rescue nil
      if weather
        if weather == :Sun || weather == :HarshSun
          mod *= 1.5 if effective_type == :FIRE
          mod *= 0.5 if effective_type == :WATER
        elsif weather == :Rain || weather == :HeavyRain
          mod *= 1.5 if effective_type == :WATER
          mod *= 0.5 if effective_type == :FIRE
        end
      end
      
      # Terrain modifiers
      terrain = battle.field.terrain rescue nil
      if terrain
        attacker_grounded = attacker.respond_to?(:affectedByTerrain?) && attacker.affectedByTerrain?
        if attacker_grounded
          mod *= 1.3 if terrain == :Electric && effective_type == :ELECTRIC
          mod *= 1.3 if terrain == :Grassy && effective_type == :GRASS
          mod *= 1.3 if terrain == :Psychic && effective_type == :PSYCHIC
        end
        # Misty Terrain: Dragon halved against grounded target
        if terrain == :Misty && effective_type == :DRAGON
          target_grounded = target && target.respond_to?(:affectedByTerrain?) && target.affectedByTerrain?
          mod *= 0.5 if target_grounded
        end
        # Grassy Terrain: Earthquake/Bulldoze/Magnitude halved against grounded target
        move_id = move.respond_to?(:id) ? move.id : nil
        if terrain == :Grassy && [:EARTHQUAKE, :BULLDOZE, :MAGNITUDE].include?(move_id)
          target_grounded = target && target.respond_to?(:affectedByTerrain?) && target.affectedByTerrain?
          mod *= 0.5 if target_grounded
        end
      end
      
      # Item modifiers (attacker)
      attacker_item = attacker.item_id rescue nil
      if attacker_item
        mod *= 1.5 if is_physical && attacker_item == :CHOICEBAND
        mod *= 1.5 if !is_physical && attacker_item == :CHOICESPECS
        mod *= 1.3 if attacker_item == :LIFEORB
      end
      
      # Burn halves physical damage (unless Guts)
      if is_physical
        attacker_burned = (attacker.status == :BURN rescue false)
        has_guts = attacker.respond_to?(:hasActiveAbility?) ? attacker.hasActiveAbility?(:GUTS) : false
        mod *= 0.5 if attacker_burned && !has_guts
      end
      
      mod
    end
    
    #===========================================================================
    # Defender Modifier (Assault Vest, Eviolite, weather defense boosts)
    # Shared helper so every simplified calc accounts for target-side factors.
    #===========================================================================
    
    def self.defender_modifier(battle, target, is_physical)
      mod = 1.0
      battle ||= target.battle if target.respond_to?(:battle)
      
      # Assault Vest: 1.5x SpDef on special moves → damage * 0.67
      target_item = target.item_id rescue nil
      if target_item
        if !is_physical && target_item == :ASSAULTVEST
          mod *= 0.67
        end
        # Eviolite: 1.5x Def/SpDef for NFE → damage * 0.67
        if target_item == :EVIOLITE
          has_evos = (target.species_data.get_evolutions(true).length > 0 rescue false)
          mod *= 0.67 if has_evos
        end
      end
      
      # Weather defense boosts (not included in stat getters)
      if battle
        weather = battle.pbWeather rescue nil
        if weather
          # Sandstorm: Rock-types get 1.5x SpDef → special damage * 0.67
          if weather == :Sandstorm && !is_physical
            has_rock = target.respond_to?(:pbHasType?) ? target.pbHasType?(:ROCK) : (target.types.include?(:ROCK) rescue false)
            mod *= 0.67 if has_rock
          end
          # Snow (Gen 9): Ice-types get 1.5x Def → physical damage * 0.67
          if weather == :Snow && is_physical
            has_ice = target.respond_to?(:pbHasType?) ? target.pbHasType?(:ICE) : (target.types.include?(:ICE) rescue false)
            mod *= 0.67 if has_ice
          end
        end
      end
      
      mod
    end
    
    #===========================================================================
    # Screen Modifier (Reflect / Light Screen / Aurora Veil)
    # Shared helper so every simplified calc accounts for active screens.
    #===========================================================================
    
    def self.screen_modifier(battle, attacker, target, is_physical)
      # Get target's side — Battler has pbOwnSide; party Pokemon does not
      target_side = nil
      if target.respond_to?(:pbOwnSide)
        target_side = target.pbOwnSide rescue nil
      elsif attacker.respond_to?(:pbOpposingSide)
        # Switch_Intelligence: target is party Pokemon, screens are on attacker's opposing side
        target_side = attacker.pbOpposingSide rescue nil
      end
      return 1.0 unless target_side
      
      # Infiltrator bypasses screens
      if attacker.respond_to?(:hasActiveAbility?) && attacker.hasActiveAbility?(:INFILTRATOR)
        return 1.0
      end
      
      # Singles: 0.5x, Doubles: ~0.67x
      battle ||= (target.battle rescue nil) || (attacker.battle rescue nil)
      is_doubles = battle && (battle.pbSideSize(0) > 1 rescue false)
      mult = is_doubles ? 0.67 : 0.5
      
      # Aurora Veil covers both physical and special
      if (target_side.effects[PBEffects::AuroraVeil] > 0 rescue false)
        return mult
      end
      
      if is_physical && (target_side.effects[PBEffects::Reflect] > 0 rescue false)
        return mult
      end
      if !is_physical && (target_side.effects[PBEffects::LightScreen] > 0 rescue false)
        return mult
      end
      
      1.0
    end
    
    #===========================================================================
    # Ability Damage Modifier (target & attacker abilities that affect damage)
    # Shared helper for defensive abilities like Fur Coat, Ice Scales, etc.
    # and offensive abilities like Tinted Lens.
    #===========================================================================
    
    def self.ability_damage_modifier(attacker, target, effective_type, is_physical, effectiveness)
      mod = 1.0
      
      # --- Target defensive abilities ---
      # For Battler objects use hasActiveAbility?; for party Pokemon fall back to ability_id
      if target.respond_to?(:hasActiveAbility?)
        # Fur Coat: physical damage halved
        mod *= 0.5 if is_physical && target.hasActiveAbility?(:FURCOAT)
        # Ice Scales: special damage halved
        mod *= 0.5 if !is_physical && target.hasActiveAbility?(:ICESCALES)
        # Thick Fat: Fire/Ice damage halved
        mod *= 0.5 if target.hasActiveAbility?(:THICKFAT) && [:FIRE, :ICE].include?(effective_type)
        # Heatproof: Fire damage halved
        mod *= 0.5 if target.hasActiveAbility?(:HEATPROOF) && effective_type == :FIRE
        # Water Bubble (target): Fire damage halved
        mod *= 0.5 if target.hasActiveAbility?(:WATERBUBBLE) && effective_type == :FIRE
        # Filter / Solid Rock / Prism Armor: SE damage reduced 25%
        if Effectiveness.super_effective?(effectiveness)
          if target.hasActiveAbility?(:FILTER) || target.hasActiveAbility?(:SOLIDROCK) || target.hasActiveAbility?(:PRISMARMOR)
            mod *= 0.75
          end
        end
        # Multiscale / Shadow Shield: damage halved at full HP
        if target.hp == target.totalhp
          if target.hasActiveAbility?(:MULTISCALE) || target.hasActiveAbility?(:SHADOWSHIELD)
            mod *= 0.5
          end
        end
      else
        # Party Pokemon (Switch_Intelligence) — use raw ability_id
        target_ability = target.ability_id rescue nil
        if target_ability
          mod *= 0.5 if is_physical && target_ability == :FURCOAT
          mod *= 0.5 if !is_physical && target_ability == :ICESCALES
          mod *= 0.5 if target_ability == :HEATPROOF && effective_type == :FIRE
          mod *= 0.5 if target_ability == :WATERBUBBLE && effective_type == :FIRE
          if Effectiveness.super_effective?(effectiveness)
            mod *= 0.75 if target_ability == :PRISMARMOR
          end
          # Multiscale/Shadow Shield: party Pokemon → assume full HP (switching in)
          if [:MULTISCALE, :SHADOWSHIELD].include?(target_ability)
            mod *= 0.5
          end
        end
      end
      
      # --- Attacker offensive abilities ---
      if attacker.respond_to?(:hasActiveAbility?)
        # Tinted Lens: NVE damage doubled
        if attacker.hasActiveAbility?(:TINTEDLENS) && Effectiveness.not_very_effective?(effectiveness)
          mod *= 2.0
        end
      else
        atk_ability = attacker.ability_id rescue nil
        if atk_ability == :TINTEDLENS && Effectiveness.not_very_effective?(effectiveness)
          mod *= 2.0
        end
      end
      
      mod
    end
    
    #===========================================================================
    # Simplified Damage Calculation (For Quick Estimates)
    #===========================================================================
    
    def self.estimate_damage(attacker, move, defender, options = {})
      return 0 unless attacker && move && defender
      return 0 unless move.damagingMove?
      
      # Get base power (handle variable-power moves with power=1)
      power = resolve_move_power(move)
      return 0 if power == 0
      
      # Resolve effective type considering -ate abilities and Tera Blast
      effective_type = resolve_move_type(attacker, move)
      
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
      base_damage = ((2.0 * level / 5 + 2) * power * atk / [defense, 1].max / 50 + 2)
      
      # STAB
      stab = attacker.pbHasType?(effective_type) ? 1.5 : 1.0
      stab = 2.0 if stab == 1.5 && attacker.hasActiveAbility?(:ADAPTABILITY)
      
      # Huge Power / Pure Power (2x Attack for physical moves)
      if move.physicalMove? && (attacker.hasActiveAbility?(:HUGEPOWER) || attacker.hasActiveAbility?(:PUREPOWER))
        base_damage *= 2
      end
      
      # Type effectiveness (Scrappy/Mind's Eye: Normal/Fighting hits Ghost)
      effectiveness = scrappy_effectiveness(effective_type, attacker, defender.pbTypes(true))
      return 0 if Effectiveness.ineffective?(effectiveness)
      
      effectiveness_mult = effectiveness.to_f / Effectiveness::NORMAL_EFFECTIVE_MULTIPLIER
      
      # Field & context modifiers (weather, terrain, items, burn)
      field_mod = field_modifier(nil, attacker, effective_type, move, move.physicalMove?, defender)
      
      # Defender modifiers (Assault Vest, Eviolite, weather defense)
      def_mod = defender_modifier(nil, defender, move.physicalMove?)
      
      # Screen modifiers (Reflect / Light Screen / Aurora Veil)
      scr_mod = screen_modifier(nil, attacker, defender, move.physicalMove?)
      
      # Parental Bond (1.25x — two hits: 100% + 25%)
      pb_mod = 1.0
      if !move.multiHitMove? && attacker.hasActiveAbility?(:PARENTALBOND)
        pb_mod = 1.25
      end
      
      # Ability damage modifiers (Fur Coat, Ice Scales, Multiscale, Tinted Lens, etc.)
      abil_mod = ability_damage_modifier(attacker, defender, effective_type, move.physicalMove?, effectiveness)
      
      # Apply modifiers
      estimated_damage = (base_damage * stab * effectiveness_mult * field_mod * def_mod * scr_mod * pb_mod * abil_mod * 0.925).to_i
      
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
      
      party = battle.pbParty(battler_index & 1)  # battler_index may be slot 0-3; & 1 gives side 0/1
      return 0 unless party
      
      party.count { |p| p && !p.fainted? }
    end
    
    def self.team_advantage(battle, user_index, opponent_index)
      user_count = count_alive_pokemon(battle, user_index)
      opponent_count = count_alive_pokemon(battle, opponent_index)
      
      return -1 if user_count == 0
      return 1 if opponent_count == 0
      
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
      battler.stages.values.select { |v| v > 0 }.sum
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

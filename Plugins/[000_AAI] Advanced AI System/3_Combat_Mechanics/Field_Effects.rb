#===============================================================================
# Advanced AI System - Field Effects
# Weather, Terrain, Trick Room, Gravity Awareness
#===============================================================================

module AdvancedAI
  module FieldEffects
    # Main Function: Calculates Field Effect Bonus
    def self.field_effect_bonus(battle, move, user, target, skill_level = 100)
      return 0 unless skill_level >= 70
      
      bonus = 0
      bonus += weather_bonus(battle, move, user, target)
      bonus += terrain_bonus(battle, move, user, target)
      bonus += trick_room_bonus(battle, move, user, target)
      bonus += gravity_bonus(battle, move, user, target)
      bonus += room_bonus(battle, move, user, target)
      
      bonus
    end
    
    # Weather Bonus
    def self.weather_bonus(battle, move, user, target)
      return 0 unless battle.field.weather
      
      bonus = 0
      weather = battle.field.weather
      
      case weather
      when :Sun, :HarshSun
        if move.type == :FIRE
          bonus += 30  # Fire moves x1.5
        elsif move.type == :WATER
          # Hydro Steam gets BOOSTED in Sun instead of weakened!
          if move.id == :HYDROSTEAM
            bonus += 35  # 1.5x power in Sun (reversed)
          else
            bonus -= 30  # Water moves x0.5
          end
        end
        
        # Weather Ball
        bonus += 20 if move.id == :WEATHERBALL
        # Growth gives +2/+2 in Sun instead of +1/+1
        bonus += 30 if move.id == :GROWTH  # Doubled effectiveness
        # Solar Beam/Blade no charge
        bonus += 25 if [:SOLARBEAM, :SOLARBLADE].include?(move.id)
        
        # Solar Power risk assessment - user loses 1/8 HP each turn
        if user.ability_id == :SOLARPOWER
          bonus -= 10 if user.hp < user.totalhp * 0.4  # Low HP = risky
        end
        
      when :Rain, :HeavyRain
        if move.type == :WATER
          bonus += 30  # Water moves x1.5
        elsif move.type == :FIRE
          bonus -= 30  # Fire moves x0.5
        end
        
        bonus += 25 if move.id == :THUNDER || move.id == :HURRICANE  # 100% accuracy
        bonus += 20 if move.id == :WEATHERBALL
        
      when :Sandstorm
        bonus += 20 if move.id == :WEATHERBALL
        bonus += 15 if move.id == :SHOREUP  # Heals more
        
        # Rock types get +50% SpDef boost in Sandstorm
        if move.specialMove? && target && target.pbHasType?(:ROCK)
          bonus -= 20  # Special attacks do less damage to Rock types
        end
        
        # Non-immune types take residual damage
        if target && !target.pbHasType?(:ROCK) && !target.pbHasType?(:STEEL) && !target.pbHasType?(:GROUND)
          bonus += 10  # Target takes residual damage
        end
        
        # Sand Veil evasion - accuracy moves less reliable
        if target && target.ability_id == :SANDVEIL
          bonus -= 10  # 20% evasion boost makes moves less accurate
        end
        
      when :Hail, :Snow
        bonus += 30 if move.id == :BLIZZARD  # 100% accuracy
        bonus += 20 if move.id == :WEATHERBALL
        bonus += 25 if move.id == :AURORAVEIL  # Aurora Veil only in Hail/Snow
        
        # Ice types immune to Hail damage
        bonus += 5 if user.pbHasType?(:ICE)
        
        # Snow Cloak evasion - accuracy moves less reliable
        if target && target.ability_id == :SNOWCLOAK
          bonus -= 10  # 20% evasion boost makes moves less accurate
        end
      end
      
      # Ability Synergies
      ability = user.ability_id
      case ability
      when :SWIFTSWIM
        bonus += 20 if weather == :Rain || weather == :HeavyRain
      when :CHLOROPHYLL
        bonus += 20 if weather == :Sun || weather == :HarshSun
      when :SANDRUSH
        bonus += 20 if weather == :Sandstorm
      when :SLUSHRUSH
        bonus += 20 if weather == :Hail || weather == :Snow
      # Paradox Pokemon abilities
      when :PROTOSYNTHESIS
        if weather == :Sun || weather == :HarshSun || user.item_id == :BOOSTERENERGY
          bonus += 25  # Stat boost active
          # Extra bonus if Speed is their highest stat (speed control)
          if user.speed >= [user.attack, user.defense, user.spatk, user.spdef].max
            bonus += 15  # Speed Protosynthesis is very strong
          end
        end
      end
      
      # Check target for Quark Drive (Electric Terrain activates it but handled in terrain_bonus)
      if target && target.ability_id == :QUARKDRIVE && target.item_id == :BOOSTERENERGY
        bonus -= 15  # Target has Quark Drive boost from Booster Energy
      end
      
      bonus
    end
    
    # Terrain Bonus
    def self.terrain_bonus(battle, move, user, target)
      return 0 unless battle.field.terrain
      
      bonus = 0
      terrain = battle.field.terrain
      
      case terrain
      when :Electric
        if move.type == :ELECTRIC && user.affectedByTerrain?
          bonus += 25  # x1.3 power
        end
        # Psyblade gets 1.5x power in Electric Terrain
        if move.id == :PSYBLADE && user.affectedByTerrain?
          bonus += 30  # 1.5x power boost
        end
        # Terrain Pulse becomes Electric type and 2x power
        if move.id == :TERRAINPULSE && user.affectedByTerrain?
          bonus += 35  # Type change + 2x power
        end
        bonus -= 40 if move.id == :SLEEPPOWDER || move.id == :SPORE  # Can't sleep
        
      when :Grassy
        if move.type == :GRASS && user.affectedByTerrain?
          bonus += 25  # x1.3 power
        end
        bonus -= 20 if move.id == :EARTHQUAKE || move.id == :MAGNITUDE  # x0.5 power
        bonus += 15 if move.id == :GIGADRAIN || move.id == :DRAINPUNCH  # Better healing
        
        # Grassy Glide gets priority
        bonus += 30 if move.id == :GRASSYGLIDE && user.affectedByTerrain?
        
        # Terrain Pulse becomes Grass type and 2x power
        if move.id == :TERRAINPULSE && user.affectedByTerrain?
          bonus += 35  # Type change + 2x power
        end
        
        # End-of-turn 1/16 HP heal for grounded Pokemon
        # Makes stalling/defensive play more valuable
        if user.affectedByTerrain? && move.statusMove?
          bonus += 8  # Small bonus for staying in and healing
        end
        
      when :Psychic
        if move.type == :PSYCHIC && user.affectedByTerrain?
          bonus += 25  # x1.3 power
        end
        # Terrain Pulse becomes Psychic type and 2x power
        if move.id == :TERRAINPULSE && user.affectedByTerrain?
          bonus += 35  # Type change + 2x power
        end
        prio = move.respond_to?(:priority) ? move.priority : (move.respond_to?(:move) ? move.move.priority : 0)
        bonus -= 40 if prio > 0  # Priority blocked
        
      when :Misty
        if move.type == :DRAGON
          bonus -= 30  # x0.5 power
        end
        bonus -= 40 if move.statusMove? && target && target.affectedByTerrain?  # Status blocked
        # Misty Explosion boost
        bonus += 25 if move.id == :MISTYEXPLOSION
        # Terrain Pulse becomes Fairy type and 2x power
        if move.id == :TERRAINPULSE && user.affectedByTerrain?
          bonus += 35  # Type change + 2x power
        end
      end
      
      # Ability Synergies
      ability = user.ability_id
      bonus += 20 if ability == :SURGESURFER && terrain == :Electric
      
      # Quark Drive (Paradox Pokemon) - activates in Electric Terrain or with Booster Energy
      if ability == :QUARKDRIVE
        if terrain == :Electric || user.item_id == :BOOSTERENERGY
          bonus += 25  # Stat boost active
          # Extra bonus if Speed is their highest stat
          if user.speed >= [user.attack, user.defense, user.spatk, user.spdef].max
            bonus += 15  # Speed Quark Drive is very strong
          end
        end
      end
      
      # Check target for Protosynthesis with Booster Energy (Sun handled in weather_bonus)
      if target && target.ability_id == :PROTOSYNTHESIS && target.item_id == :BOOSTERENERGY
        bonus -= 15  # Target has Protosynthesis boost from Booster Energy
      end
      
      bonus
    end
    
    # Trick Room Bonus
    def self.trick_room_bonus(battle, move, user, target)
      return 0 unless battle.field.effects[PBEffects::TrickRoom] > 0
      
      bonus = 0
      
      # If Trick Room active, prefer slow Pokemon
      if user.pbSpeed < 50
        bonus += 20  # Slow Pokemon benefits
      elsif user.pbSpeed > 120
        bonus -= 20  # Fast Pokemon penalized
      end
      
      # Priority Moves are stronger in Trick Room
      prio = move.respond_to?(:priority) ? move.priority : (move.respond_to?(:move) ? move.move.priority : 0)
      bonus += 15 if prio > 0
      
      bonus
    end
    
    # Gravity Bonus
    def self.gravity_bonus(battle, move, user, target)
      return 0 unless battle.field.effects[PBEffects::Gravity] > 0
      
      bonus = 0
      
      # OHKO moves 100% accuracy
      if [:GUILLOTINE, :FISSURE, :SHEERCOLD, :HORNDRILL].include?(move.id)
        bonus += 40
      end
      
      # Ground moves hit Flying/Levitate
      if move.type == :GROUND && target
        bonus += 30 if target.pbHasType?(:FLYING) || target.ability_id == :LEVITATE
      end
      
      bonus
    end
    
    # Room Effects (Magic Room, Wonder Room)
    def self.room_bonus(battle, move, user, target)
      bonus = 0
      
      # Magic Room (items disabled)
      if battle.field.effects[PBEffects::MagicRoom] > 0
        # Item-dependent Moves are weaker
        bonus -= 20 if move.id == :FLING || move.id == :NATURALGIFT
      end
      
      # Wonder Room (Def/SpDef swapped)
      if battle.field.effects[PBEffects::WonderRoom] > 0
        if move.physicalMove? && target && target.spdef > target.defense
          bonus += 15  # Physical hits SpDef now (better)
        elsif move.specialMove? && target && target.defense > target.spdef
          bonus += 15  # Special hits Def now (better)
        end
      end
      
      bonus
    end
    
    # Weather Setting Bonus
    def self.weather_setting_bonus(battle, move, user, skill_level = 100)
      return 0 unless skill_level >= 70
      
      bonus = 0
      
      # Check if Team benefits from Weather
      party = battle.pbParty(user.index)
      
      case move.id
      when :SUNNYDAY
        sun_users = party.count { |p| p && [:CHLOROPHYLL, :DROUGHT, :SOLARPOWER].include?(p.ability) }
        bonus += sun_users * 20
        
      when :RAINDANCE
        rain_users = party.count { |p| p && [:SWIFTSWIM, :DRIZZLE, :RAINDISH].include?(p.ability) }
        bonus += rain_users * 20
        
      when :SANDSTORM
        sand_users = party.count { |p| p && [:SANDRUSH, :SANDSTREAM, :SANDFORCE].include?(p.ability) }
        bonus += sand_users * 20
        
      when :HAIL, :SNOWSCAPE
        hail_users = party.count { |p| p && [:SLUSHRUSH, :SNOWWARNING, :ICEBODY].include?(p.ability) }
        bonus += hail_users * 20
      end
      
      bonus
    end
  end
  
  #===========================================================================
  # Weather War Aggression - Override opponent's weather
  #===========================================================================
  module FieldEffects
    def self.weather_war_bonus(battle, move, user, skill_level = 100)
      return 0 unless skill_level >= 75
      
      bonus = 0
      current_weather = battle.field.weather
      
      # Weather-setting moves
      weather_moves = {
        :SUNNYDAY   => [:Sun, :HarshSun],
        :RAINDANCE  => [:Rain, :HeavyRain],
        :SANDSTORM  => [:Sandstorm],
        :HAIL       => [:Hail],
        :SNOWSCAPE  => [:Snow]
      }
      
      return 0 unless weather_moves.key?(move.id)
      target_weathers = weather_moves[move.id]
      
      # Already have our preferred weather
      return -50 if target_weathers.include?(current_weather)
      
      # Check if opponent BENEFITS from current weather
      opponent_benefits = false
      battle.allOtherSideBattlers(user.index).each do |opp|
        next unless opp && !opp.fainted?
        
        case current_weather
        when :Sun, :HarshSun
          if [:CHLOROPHYLL, :SOLARPOWER, :LEAFGUARD, :FLOWERGIFT, :PROTOSYNTHESIS].include?(opp.ability_id)
            opponent_benefits = true
          end
          if opp.moves.any? { |m| m && m.type == :FIRE }
            opponent_benefits = true
          end
        when :Rain, :HeavyRain
          if [:SWIFTSWIM, :RAINDISH, :DRYSKIN, :HYDRATION].include?(opp.ability_id)
            opponent_benefits = true
          end
        when :Sandstorm
          if [:SANDRUSH, :SANDFORCE, :SANDVEIL].include?(opp.ability_id)
            opponent_benefits = true
          end
        when :Hail, :Snow
          if [:SLUSHRUSH, :ICEBODY, :SNOWCLOAK].include?(opp.ability_id)
            opponent_benefits = true
          end
        end
      end
      
      # HIGH PRIORITY: Override opponent's beneficial weather
      if opponent_benefits
        bonus += 60  # Actively disrupt their weather advantage
        
        # Even higher if they JUST set it
        if battle.field.weatherDuration && battle.field.weatherDuration >= 4
          bonus += 20  # They just set it, maximum disruption
        end
      end
      
      # Check if WE benefit from the new weather
      party = battle.pbParty(user.index)
      our_synergy = count_weather_synergy(party, target_weathers.first)
      bonus += our_synergy * 15
      
      bonus
    end
    
    # Terrain War - Override opponent's terrain
    def self.terrain_war_bonus(battle, move, user, skill_level = 100)
      return 0 unless skill_level >= 75
      
      bonus = 0
      current_terrain = battle.field.terrain
      
      terrain_moves = {
        :ELECTRICTERRAIN => :Electric,
        :GRASSYTERRAIN   => :Grassy,
        :PSYCHICTERRAIN  => :Psychic,
        :MISTYTERRAIN    => :Misty
      }
      
      return 0 unless terrain_moves.key?(move.id)
      target_terrain = terrain_moves[move.id]
      
      # Already have this terrain
      return -50 if current_terrain == target_terrain
      
      # Check if opponent benefits from CURRENT terrain
      opponent_benefits = false
      battle.allOtherSideBattlers(user.index).each do |opp|
        next unless opp && !opp.fainted?
        
        case current_terrain
        when :Electric
          if [:SURGESURFER, :QUARKDRIVE].include?(opp.ability_id)
            opponent_benefits = true
          end
          if opp.pbHasType?(:ELECTRIC) && (opp.respond_to?(:affectedByTerrain?) ? opp.affectedByTerrain? : true)
            opponent_benefits = true
          end
        when :Grassy
          if opp.pbHasType?(:GRASS) && (opp.respond_to?(:affectedByTerrain?) ? opp.affectedByTerrain? : true)
            opponent_benefits = true
          end
        when :Psychic
          # Psychic Terrain blocks OUR priority
          if user.moves.any? { |m| m && m.priority > 0 && m.damagingMove? }
            opponent_benefits = true  # They're protected from our priority!
          end
        end
      end
      
      if opponent_benefits
        bonus += 50
      end
      
      bonus
    end
    
    def self.count_weather_synergy(party, weather)
      synergy = {
        :Sun  => [:CHLOROPHYLL, :SOLARPOWER, :LEAFGUARD, :FLOWERGIFT, :HARVEST],
        :Rain => [:SWIFTSWIM, :RAINDISH, :DRYSKIN, :HYDRATION],
        :Sandstorm => [:SANDRUSH, :SANDFORCE, :SANDVEIL],
        :Hail => [:SLUSHRUSH, :ICEBODY, :SNOWCLOAK],
        :Snow => [:SLUSHRUSH, :ICEBODY, :SNOWCLOAK]
      }
      
      abilities = synergy[weather] || []
      party.count { |p| p && abilities.include?(p.ability) }
    end
    
    #===========================================================================
    # Mimicry Type Consideration
    #===========================================================================
    def self.mimicry_type_from_terrain(terrain)
      case terrain
      when :Electric then :ELECTRIC
      when :Grassy   then :GRASS
      when :Psychic  then :PSYCHIC
      when :Misty    then :FAIRY
      else nil
      end
    end
    
    def self.mimicry_bonus(battle, move, user, target, skill_level = 100)
      return 0 unless skill_level >= 70
      
      bonus = 0
      
      # Check if target has Mimicry
      if target && target.ability_id == :MIMICRY
        actual_type = mimicry_type_from_terrain(battle.field.terrain)
        
        if actual_type
          eff = Effectiveness.calculate(move.type, actual_type, target.types[1])
          
          if Effectiveness.super_effective?(eff)
            bonus += 25  # Our move is SE against their Mimicry type!
          elsif Effectiveness.not_very_effective?(eff)
            bonus -= 15
          elsif Effectiveness.ineffective?(eff)
            bonus -= 50
          end
        end
      end
      
      # Check if OUR Pokemon has Mimicry
      if user.ability_id == :MIMICRY
        new_type = mimicry_type_from_terrain(battle.field.terrain)
        
        if new_type && move.type == new_type
          bonus += 20  # We get STAB from Mimicry!
        end
      end
      
      bonus
    end
  end
end

# API-Wrapper
module AdvancedAI
  def self.field_effect_bonus(battle, move, user, target, skill_level = 100)
    FieldEffects.field_effect_bonus(battle, move, user, target, skill_level)
  end
  
  def self.weather_bonus(battle, move, user, target)
    FieldEffects.weather_bonus(battle, move, user, target)
  end
  
  def self.terrain_bonus(battle, move, user, target)
    FieldEffects.terrain_bonus(battle, move, user, target)
  end
  
  def self.trick_room_bonus(battle, move, user, target)
    FieldEffects.trick_room_bonus(battle, move, user, target)
  end
  
  def self.weather_setting_bonus(battle, move, user, skill_level = 100)
    FieldEffects.weather_setting_bonus(battle, move, user, skill_level)
  end
end

# Integration in Battle::AI
class Battle::AI
  def apply_field_effects(score, move, user, target)
    skill = @trainer&.skill || 100
    return score unless AdvancedAI.feature_enabled?(:core, skill)
    return score unless target
    
    # user and target are AIBattlers, need real battlers
    real_user = user.respond_to?(:battler) ? user.battler : user
    real_target = target.respond_to?(:battler) ? target.battler : target
    
    score += AdvancedAI.field_effect_bonus(@battle, move, real_user, real_target, skill)
    score += AdvancedAI.weather_setting_bonus(@battle, move, real_user, skill)
    
    return score
  end
end

AdvancedAI.log("Field Effects System loaded", "Field")

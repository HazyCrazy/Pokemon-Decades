#===============================================================================
# Advanced AI System - Weather & Terrain Wars
# Strategic weather/terrain manipulation and counter-play
#===============================================================================

class Battle::AI
  # ============================================================================
  # WEATHER WARS
  # ============================================================================
  
  alias weather_wars_pbRegisterMove pbRegisterMove
  def pbRegisterMove(user, move)
    score = weather_wars_pbRegisterMove(user, move)
    
    return score unless user && move
    
    # Weather-setting moves
    if move_sets_weather?(move)
      score += evaluate_weather_setting(user, move)
    end
    
    # Terrain-setting moves
    if move_sets_terrain?(move)
      score += evaluate_terrain_setting(user, move)
    end
    
    return score
  end
  
  # ============================================================================
  # WEATHER SETTING EVALUATION
  # ============================================================================
  
  def move_sets_weather?(move)
    weather_moves = {
      :SUNNYDAY    => :Sun,
      :RAINDANCE   => :Rain,
      :SANDSTORM   => :Sandstorm,
      :HAIL        => :Hail,
      :SNOWSCAPE   => :Snow,
    }
    return weather_moves.key?(move.id)
  end
  
  def evaluate_weather_setting(user, move)
    score = 0
    
    weather_map = {
      :SUNNYDAY  => :Sun,
      :RAINDANCE => :Rain,
      :SANDSTORM => :Sandstorm,
      :HAIL      => :Hail,
      :SNOWSCAPE => :Snow,
    }
    
    new_weather = weather_map[move.id]
    current_weather = @battle.field.weather
    
    # Don't set weather that's already active
    if current_weather == new_weather
      AdvancedAI.log("  #{move.name}: -80 (already active)", "Weather")
      return -80
    end
    
    # COUNTER-WEATHER: Remove opponent's beneficial weather
    if weather_benefits_opponent?(current_weather)
      score += 50
      AdvancedAI.log("  #{move.name}: +50 (counter opponent weather)", "Weather")
    end
    
    # OFFENSIVE WEATHER: Boost our attacks
    our_benefit = calculate_weather_benefit(user, new_weather)
    if our_benefit > 0
      score += our_benefit
      AdvancedAI.log("  #{move.name}: +#{our_benefit} (benefits us)", "Weather")
    elsif our_benefit < 0
      score += our_benefit  # Penalty
      AdvancedAI.log("  #{move.name}: #{our_benefit} (hurts us!)", "Weather")
    end
    
    # DEFENSIVE WEATHER: Hurt opponent
    opponent_penalty = calculate_opponent_weather_penalty(new_weather)
    if opponent_penalty > 0
      score += opponent_penalty
      AdvancedAI.log("  #{move.name}: +#{opponent_penalty} (hurts opponent)", "Weather")
    end
    
    # ABILITY SYNERGY
    if weather_activates_ability?(user, new_weather)
      score += 40
      AdvancedAI.log("  #{move.name}: +40 (activates ability)", "Weather")
    end
    
    return score
  end
  
  def weather_benefits_opponent?(weather)
    return false if weather == :None
    
    @battle.allOtherSideBattlers(0).each do |battler|
      next unless battler && !battler.fainted?
      
      # Check if opponent has weather-boosting ability
      weather_abilities = {
        :Sun       => [:SOLARPOWER, :CHLOROPHYLL, :FLOWERGIFT],
        :Rain      => [:SWIFTSWIM, :RAINDISH, :DRYSKIN],
        :Sandstorm => [:SANDFORCE, :SANDRUSH, :SANDVEIL],
        :Hail      => [:ICEBODY, :SNOWCLOAK, :SLUSHRUSH],
        :Snow      => [:SLUSHRUSH, :ICEBODY],
      }
      
      if weather_abilities[weather]&.include?(battler.ability_id)
        return true
      end
      
      # Check if opponent has weather-boosted moves
      battler.moves.each do |m|
        next unless m
        
        case weather
        when :Sun
          return true if [:FIRE].include?(m.type)
        when :Rain
          return true if [:WATER].include?(m.type)
        when :Sandstorm
          return true if [:ROCK, :GROUND, :STEEL].include?(battler.pbTypes(true).first)
        end
      end
    end
    
    return false
  end
  
  def calculate_weather_benefit(user, weather)
    benefit = 0
    
    case weather
    when :Sun
      # Fire moves 1.5x, Water moves 0.5x
      fire_moves = user.moves.count { |m| m && m.type == :FIRE }
      water_moves = user.moves.count { |m| m && m.type == :WATER }
      
      benefit += fire_moves * 20
      benefit -= water_moves * 15
      
      # Chlorophyll, Solar Power
      if [:CHLOROPHYLL, :SOLARPOWER].include?(user.battler.ability_id)
        benefit += 30
      end
      
    when :Rain
      # Water moves 1.5x, Fire moves 0.5x
      water_moves = user.moves.count { |m| m && m.type == :WATER }
      fire_moves = user.moves.count { |m| m && m.type == :FIRE }
      
      benefit += water_moves * 20
      benefit -= fire_moves * 15
      
      # Swift Swim, Rain Dish
      if [:SWIFTSWIM, :RAINDISH].include?(user.battler.ability_id)
        benefit += 30
      end
      
    when :Sandstorm
      # Rock types get SpDef boost
      if user.battler.pbTypes(true).include?(:ROCK)
        benefit += 25
      end
      
      # Sand Rush, Sand Force
      if [:SANDRUSH, :SANDFORCE].include?(user.battler.ability_id)
        benefit += 30
      end
      
      # Damage to non-immunetypes (not us)
      unless [:ROCK, :GROUND, :STEEL].include?(user.battler.pbTypes(true).first)
        benefit -= 10  # Hurts us
      end
      
    when :Snow, :Hail
      # Ice types get Def boost (Snow only)
      if weather == :Snow && user.battler.pbTypes(true).include?(:ICE)
        benefit += 25
      end
      
      # Slush Rush
      if user.battler.ability_id == :SLUSHRUSH
        benefit += 30
      end
      
      # Hail damage (not Snow)
      if weather == :Hail && !user.battler.pbTypes(true).include?(:ICE)
        benefit -= 10
      end
    end
    
    return benefit
  end
  
  def calculate_opponent_weather_penalty(weather)
    penalty = 0
    
    @battle.allOtherSideBattlers(0).each do |battler|
      next unless battler && !battler.fainted?
      
      case weather
      when :Sun
        # Hurt Water types
        water_moves = battler.moves.count { |m| m && m.type == :WATER }
        penalty += water_moves * 10
        
      when :Rain
        # Hurt Fire types
        fire_moves = battler.moves.count { |m| m && m.type == :FIRE }
        penalty += fire_moves * 10
        
      when :Sandstorm
        # Chip damage to non-immune
        unless [:ROCK, :GROUND, :STEEL].include?(battler.pbTypes(true).first)
          penalty += 15
        end
        
      when :Hail
        # Chip damage to non-Ice
        unless battler.pbTypes(true).include?(:ICE)
          penalty += 15
        end
      end
    end
    
    return penalty
  end
  
  def weather_activates_ability?(user, weather)
    ability_id = user.battler.ability_id
    
    activations = {
      :Sun       => [:CHLOROPHYLL, :SOLARPOWER, :FLOWERGIFT],
      :Rain      => [:SWIFTSWIM, :RAINDISH, :DRYSKIN],
      :Sandstorm => [:SANDRUSH, :SANDFORCE, :SANDVEIL],
      :Hail      => [:SLUSHRUSH, :ICEBODY, :SNOWCLOAK],
      :Snow      => [:SLUSHRUSH, :ICEBODY],
    }
    
    return activations[weather]&.include?(ability_id) || false
  end
  
  # ============================================================================
  # TERRAIN WARS
  # ============================================================================
  
  def move_sets_terrain?(move)
    terrain_moves = {
      :ELECTRICTERRAIN => :Electric,
      :GRASSYTERRAIN   => :Grassy,
      :MISTYTERRAIN    => :Misty,
      :PSYCHICTERRAIN  => :Psychic,
    }
    return terrain_moves.key?(move.id)
  end
  
  def evaluate_terrain_setting(user, move)
    score = 0
    
    terrain_map = {
      :ELECTRICTERRAIN => :Electric,
      :GRASSYTERRAIN   => :Grassy,
      :MISTYTERRAIN    => :Misty,
      :PSYCHICTERRAIN  => :Psychic,
    }
    
    new_terrain = terrain_map[move.id]
    current_terrain = @battle.field.terrain
    
    # Don't set terrain that's already active
    if current_terrain == new_terrain
      AdvancedAI.log("  #{move.name}: -80 (already active)", "Terrain")
      return -80
    end
    
    # COUNTER-TERRAIN: Remove opponent's beneficial terrain
    if terrain_benefits_opponent?(current_terrain)
      score += 45
      AdvancedAI.log("  #{move.name}: +45 (counter opponent terrain)", "Terrain")
    end
    
    # TERRAIN BENEFITS
    case new_terrain
    when :Electric
      # Electric moves 1.3x power (grounded)
      electric_moves = user.moves.count { |m| m && m.type == :ELECTRIC }
      score += electric_moves * 25
      
      # Prevents sleep
      score += 15
      
    when :Grassy
      # Grass moves 1.3x, heals grounded
      grass_moves = user.moves.count { |m| m && m.type == :GRASS }
      score += grass_moves * 20
      
      # Passive healing
      score += 20
      
    when :Misty
      # Halves Dragon moves
      dragon_moves_opponent = 0
      @battle.allOtherSideBattlers(user.index).each do |opp|
        next unless opp
        dragon_moves_opponent += opp.moves.count { |m| m && m.type == :DRAGON }
      end
      score += dragon_moves_opponent * 25
      
      # Prevents status (grounded)
      score += 20
      
    when :Psychic
      # Psychic moves 1.3x, blocks priority
      psychic_moves = user.moves.count { |m| m && m.type == :PSYCHIC }
      score += psychic_moves * 25
      
      # Blocks priority moves
      score += 30  # Very valuable
    end
    
    # ABILITY SYNERGY
    if terrain_activates_ability?(user, new_terrain)
      score += 35
      AdvancedAI.log("  #{move.name}: +35 (activates ability)", "Terrain")
    end
    
    return score
  end
  
  def terrain_benefits_opponent?(terrain)
    return false if terrain == :None
    
    @battle.allOtherSideBattlers(0).each do |battler|
      next unless battler && !battler.fainted?
      
      case terrain
      when :Electric
        return true if battler.moves.any? { |m| m && m.type == :ELECTRIC }
      when :Grassy
        return true if battler.moves.any? { |m| m && m.type == :GRASS }
      when :Psychic
        return true if battler.moves.any? { |m| m && m.type == :PSYCHIC }
      when :Misty
        # Hurts Dragon users
        return true if battler.moves.any? { |m| m && m.type == :DRAGON }
      end
    end
    
    return false
  end
  
  def terrain_activates_ability?(user, terrain)
    ability_id = user.battler.ability_id
    
    activations = {
      :Electric => [:SURGESURFER],
      :Grassy   => [:GRASSPELT],
      :Psychic  => [],  # No specific ability activations
      :Misty    => [],
    }
    
    return activations[terrain]&.include?(ability_id) || false
  end
end

AdvancedAI.log("Weather & Terrain Wars loaded", "Core")
AdvancedAI.log("  - Counter-weather strategy", "Weather")
AdvancedAI.log("  - Counter-terrain strategy", "Terrain")
AdvancedAI.log("  - Ability synergy detection", "Weather")

#===============================================================================
# Automatic Level Scaling Settings
# By Benitex
#===============================================================================

module LevelScalingSettings
  # These two below are the variables that control difficulty
  # (You can set both of them to be the same)
  TRAINER_VARIABLE = 98
  WILD_VARIABLE = 98#97

  # You can add your own difficulties in the following Hash, using the constructor "Difficulty.new(fixed_increase, random_increase)"
  #   "fixed_increase" is a pre defined value that is always added to the level avarage
  #   "random_increase" is a randomly selected value between 0 and the value provided
  # Each difficulty has an index in the Hash, which represents the difficulty
  # You can change the active difficulty by updating TRAINER_VARIABLE or WILD_VARIABLE according to these indexes
  DIFFICULTIES = {
    1 => Difficulty.new(fixed_increase: -3, random_increase: 3),  # Easy
    2 => Difficulty.new(random_increase: 2),                      # Medium
    3 => Difficulty.new(fixed_increase: 3, random_increase: 3),   # Hard
    4 => Difficulty.new,                                          # Avarage (Story Mode Showdown Mode)
    5 => Difficulty.new(fixed_increase: -2, random_increase: 5),  # Standard Essentials
	6 => Difficulty.new(fixed_increase: 0, fixed_increase: GameData::GrowthRate.max_level),# Player/Wild/Trainer Levels are 1:1 (Used in Battle Mode, also known as Showdown Mode)
	7 => Difficulty.new(fixed_increase: -100, random_increase: 0),  # Trivial Mode (Exists for those blizting through sections of the game they don't care about, and want all battle tedium removed)
  }

  # Scales levels but takes original level differences between members of the trainer party into consideration
  PROPORTIONAL_SCALING = true

  # Trainer parties will keep the same pokemon and levels of the first battle
  SAVE_TRAINER_PARTIES = false

  # Defines a "Map Level" in which all wild pokemon in the map will be, based on the the party when the player first enters the map
  USE_MAP_LEVEL_FOR_WILD_POKEMON = false

  # You can use the following to disable level scaling in any condition other then the selected below
  ONLY_SCALE_IF_HIGHER = true   # The script will only scale levels if the player is overleveled
  ONLY_SCALE_IF_LOWER = false    # The script will only scale levels if the player is underleveled

  AUTOMATIC_EVOLUTIONS = true     # Updates the evolution stage of the pokemon
  INCLUDE_PREVIOUS_STAGES = true  # Reverts pokemon to previous evolution stages if they did not reach the evolution level
  INCLUDE_NEXT_STAGES = true      # If false, stops evolution at the species used in the function call (or defined in the PBS)

  INCLUDE_NON_NATURAL_EVOLUTIONS = true # Evolve all pokemon, even if it only evolves by a non natural method
  # If INCLUDE_NON_NATURAL_EVOLUTIONS is false, the script will only consider evolutions that use the methods in the NATURAL_EVOLUTION_METHODS array
  # (All conditions other than level for these evolutions are ignored)
  NATURAL_EVOLUTION_METHODS = [
    :Level,
    :LevelMale, :LevelFemale,
    :LevelDay, :LevelNight, :LevelMorning, :LevelAfternoon, :LevelEvening,
    :LevelNoWeather, :LevelSun, :LevelRain, :LevelSnow, :LevelSandstorm,
    :LevelCycling, :LevelSurfing, :LevelDiving, :LevelDarkness, :LevelDarkInParty,

    # Specific pokemon
    :AttackGreater, :AtkDefEqual, :DefenseGreater,
    :Silcoon, :Cascoon, :Ninjask,
  ]

  # The default evolution levels are used for all evolution methods that are not in the NATURAL_EVOLUTION_METHODS array
  # 3 Stage Evolution: Level 30, Level 50 
  # 2 Stage Evolution: Level 35 
  DEFAULT_FIRST_EVOLUTION_LEVEL = 30#20		# Because Super Yellow has both Story and Battle mode, with Battle Mode using 1:1 Level Scaling, All Pokemon Evolution lines have to be uniform, in order for the workload to be as streamlinded as possible
  DEFAULT_SECOND_EVOLUTION_LEVEL = 50#40	# I do not care about people complaining about xyz Pokemon now evolving at Lvl.30, Lvl.35 or Lvl.50. For Battle Mode, I am not micro managing every specfic Level Scaling edge case, for every 3 trainer entries, for just one Pokemon Trainer battle.
end

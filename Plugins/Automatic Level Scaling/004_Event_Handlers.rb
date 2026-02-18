#===============================================================================
# Automatic Level Scaling Event Handlers
# By Benitex
#===============================================================================

# Activates script when a wild pokemon is created
EventHandlers.add(:on_wild_pokemon_created, :automatic_level_scaling,
  proc { |pokemon|
    id = pbGet(LevelScalingSettings::WILD_VARIABLE)
    next if id == 0
    AutomaticLevelScaling.difficulty = id

    if AutomaticLevelScaling.settings[:use_map_level_for_wild_pokemon]
      pokemon.scale(AutomaticLevelScaling.getMapLevel($game_map.map_id))
    else
      pokemon.scale
    end
  }
)

# Activates script when a trainer pokemon is created (Modded for 1:1 Player and Opponent Level Scaling)
#EventHandlers.add(:on_trainer_load, :automatic_level_scaling,
  #proc { |trainer|
    #id = pbGet(LevelScalingSettings::TRAINER_VARIABLE)
    #next if !trainer || id == 0
    #AutomaticLevelScaling.difficulty = id

    #if id == 6
      #LevelScalingSettings::DIFFICULTIES[6].fixed_increase = 0
      #LevelScalingSettings::DIFFICULTIES[6].random_increase = 0
      #LevelScalingSettings::DIFFICULTIES[6].fixed_increase = -AutomaticLevelScaling.getScaledLevel

      #highest_level = 0
      #$player.party.each { |pokemon|
        #highest_level = pokemon.level if pokemon.level > highest_level
      #}
      #LevelScalingSettings::DIFFICULTIES[5].random_increase = highest_level
    #end

    #avarage_level = 0
    #trainer.party.each { |pokemon| avarage_level += pokemon.level }
    #avarage_level /= trainer.party.length

    #for pokemon in trainer.party do
      #AutomaticLevelScaling.setNewLevel(pokemon, pokemon.level - avarage_level)
    #end
  #}
#)

# Activates script when a trainer pokemon is created
EventHandlers.add(:on_trainer_load, :automatic_level_scaling,
  proc { |trainer|
    id = pbGet(LevelScalingSettings::TRAINER_VARIABLE)
    next if !trainer || id == 0
    AutomaticLevelScaling.difficulty = id

    if AutomaticLevelScaling.settings[:save_trainer_parties] && AutomaticLevelScaling.battledTrainer?(trainer.key)
      AutomaticLevelScaling.scaleToPreviousTrainerParty(trainer)
      trainer.heal_party
      next
    end

    avarage_level = trainer.party_avarage_level
    for pokemon in trainer.party do
      if AutomaticLevelScaling.settings[:proportional_scaling]
        difference_from_average = pokemon.level - avarage_level
        pokemon.scale(AutomaticLevelScaling.getScaledLevel + difference_from_average)
      else
        pokemon.scale
      end
    end

    if AutomaticLevelScaling.settings[:save_trainer_parties]
      AutomaticLevelScaling.savePreviousTrainerParty(trainer.key, trainer.party)
    end
  }
)

# Updates partner's pokemon levels after battle
EventHandlers.add(:on_end_battle, :update_partner_levels,
  proc { |_decision, _canLose|
    id = pbGet(LevelScalingSettings::TRAINER_VARIABLE)
    next if !$PokemonGlobal.partner || id == 0

    avarage_level = 0
    $PokemonGlobal.partner[3].each { |pokemon| avarage_level += pokemon.level }
    avarage_level /= $PokemonGlobal.partner[3].length

    for pokemon in $PokemonGlobal.partner[3] do
      if AutomaticLevelScaling.settings[:proportional_scaling]
        difference_from_average = pokemon.level - avarage_level
        pokemon.scale(AutomaticLevelScaling.getScaledLevel + difference_from_average)
      else
        pokemon.scale
      end
    end
  }
)

# Resets settings after battle if they are temporaray
EventHandlers.add(:on_end_battle, :reset_settings,
  proc { |_decision, _canLose|
    if AutomaticLevelScaling.settings[:temporary]
      AutomaticLevelScaling.setSettings
    end 
  }
)

# Set map level when player enters a map
EventHandlers.add(:on_enter_map, :define_map_level,
  proc { |old_map_id|
    next if !AutomaticLevelScaling.settings[:use_map_level_for_wild_pokemon]
    next if $PokemonGlobal.map_levels.has_key?($game_map.map_id)

    id = pbGet(LevelScalingSettings::WILD_VARIABLE)
    next if id == 0
    AutomaticLevelScaling.difficulty = id

    $PokemonGlobal.map_levels[$game_map.map_id] = AutomaticLevelScaling.getScaledLevel
  }
)

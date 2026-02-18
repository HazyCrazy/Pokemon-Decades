#===============================================================================
# Auto Win Policy
#===============================================================================
ItemHandlers::UseFromBag.add(:AUTOWINPOLICY, proc { |item, bag_screen|
  if $game_switches[97] == true # Game Switch 97 is Trainer Battle Skip
    $game_switches[97] = false # Allow the player to engage in trainer battles
	pbMessage(_INTL("You now must properly fight wild Pokemon and Pokemon Trainers!"))
	elsif $game_switches[97] == false # # Game Switch 97 is Trainer Battle Skip
	$game_switches[97] = true # The player can now bypass trainer battles (Changes applied in Overworld_BattleStarting, Line 145)
	pbMessage(_INTL("You can now bypass fighting wild Pokemon and Pokemon Trainers!"))
	next 1 
  end
})

ItemHandlers::UseInField.add(:AUTOWINPOLICY, proc { |item|
	if $game_switches[97] == true # Game Switch 97 is Trainer Battle Skip
		$game_switches[97] = false # Allow the player to engage in trainer battles
		pbMessage(_INTL("You now must properly fight wild Pokemon and Pokemon Trainers!"))
		elsif $game_switches[97] == false # # Game Switch 97 is Trainer Battle Skip
		$game_switches[97] = true # The player can now bypass trainer battles (Changes applied in Overworld_BattleStarting, Line 145)
		pbMessage(_INTL("You can now bypass fighting wild Pokemon and Pokemon Trainers!"))
		next 1 
	end
    next true
})

#===============================================================================
# Soundtrack Earbuds
#===============================================================================
ItemHandlers::UseFromBag.add(:SOUNDTRACKEARBUDS, proc { |item, bag_screen|
  if $game_switches[100] == true # Game Switch 100 is Upload Safe Soundtrack when on
	$game_switches[100] = false # Change to Intended Soundtrack if set to Upload Safe
	pbMessage(_INTL("The Soundtrack is now set to Intended!"))
	elsif $game_switches[100] == false # # Game Switch 100 is Intended Soundtrack when off
	$game_switches[100] = true # Change to Upload Safe Soundtrack if set to Intended
	pbMessage(_INTL("The Soundtrack is now set to Upload Safe!"))
	next 1 
  end
})

ItemHandlers::UseInField.add(:SOUNDTRACKEARBUDS, proc { |item|
	if $game_switches[100] == true # Game Switch 100 is Upload Safe Soundtrack when on
		$game_switches[100] = false # Change to Intended Soundtrack if set to Upload Safe
		pbMessage(_INTL("The Soundtrack is now set to Intended!"))
		elsif $game_switches[100] == false # # Game Switch 100 is Intended Soundtrack when off
		$game_switches[100] = true # Change to Upload Safe Soundtrack if set to Intended
		pbMessage(_INTL("The Soundtrack is now set to Upload Safe!"))
		next 1 
	end
    next true
})

#===============================================================================
# No Clip Disk
#===============================================================================
ItemHandlers::UseFromBag.add(:NOCLIPDISK, proc { |item, bag_screen|
  if $game_switches[96] == true # Game Switch 96 is No Clip Toggle
    $game_switches[96] = false # The player follows standard collision detection
	pbMessage(_INTL("You now obey the laws of Physics!"))
	elsif $game_switches[96] == false # # Game Switch 96 is No Clip Toggle
	$game_switches[96] = true # The player ignores collision detection, and can walk on and through anything (Changes applied in Game_Player, Line 253)
	pbMessage(_INTL("No Clip lets you walk on and through anything!"))
	next 1 
  end
})

ItemHandlers::UseInField.add(:NOCLIPDISK, proc { |item|
	if $game_switches[96] == true # Game Switch 96 is No Clip Toggle
		$game_switches[96] = false # The player follows standard collision detection
		pbMessage(_INTL("You now obey the laws of Physics!"))
		elsif $game_switches[96] == false # # Game Switch 97 is Trainer Battle Skip
		$game_switches[96] = true # The player ignores collision detection, and can walk on and through anything (Changes applied in Game_Player, Line 253)
		pbMessage(_INTL("No Clip lets you walk on and through anything!"))
		next 1 
	end
    next true
})


#===============================================================================
#  Wild Music Adjuster
#===============================================================================
ItemHandlers::UseFromBag.add(:GBSOUNDS, proc { |item, bag_screen|
  cmds = ["Default Battle Music", "Gen 1 Battle Music", "Gen 2 Battle Music", "Gen 3 Battle Music", "Gen 4 Battle Music", "Gen 5 Battle Music", "Gen 6 Battle Music", "Gen 7 Battle Music", "Gen 8 Battle Music", "Gen 9 Battle Music", "A Random Weeb Song", "Cancel"]
  c = pbMessage("What wild battle music do you want?", cmds)
  	if c == 0
		$PokemonGlobal.nextBattleBGM = "RGS Wild Pokemon Battle Rip by Gladiogg"
		pbSEPlay("Voltorb Flip gain coins")
		#$PokemonGlobal.nextWildVictoryBGM = "RGS Peaceful Aftermath Rip by Gladiogg"
		#$PokemonGlobal.nextBattleVictoryBGM = "RGS Peaceful Aftermath Rip by Gladiogg"
		
	elsif c == 1
		$PokemonGlobal.nextBattleBGM = "Catch Wild Pokemon LGPE"
		pbSEPlay("Voltorb Flip gain coins")
		#$PokemonGlobal.nextWildVictoryBGM = "Caught Wild Pokemon LGPE"
		
	elsif c == 2
		$PokemonGlobal.nextBattleBGM = "XD 41 Wild Pokemon Battle"
		pbSEPlay("Voltorb Flip gain coins")
		#$PokemonGlobal.wild_victory_BGM = "HGSS 111 Victory! (Wild Pokemon)"
	
	elsif c == 3
		$PokemonGlobal.nextBattleBGM = "ORAS 008 Battle! (Wild Pokemon)"
		pbSEPlay("Voltorb Flip gain coins")
		#$PokemonGlobal.wild_victory_BGM = "ORAS 009 Victory! (Wild Pokemon)"
	
	elsif c == 4
		$PokemonGlobal.nextBattleBGM = "PLA 013 Battle! (Wild Pokemon)" #"DPPT 011 Battle! (Wild Pokemon)"
		pbSEPlay("Voltorb Flip gain coins")
		#$PokemonGlobal.wild_victory_BGM = "DPPT 012 Victory! (Wild Pokemon)"
	
	elsif c == 5
		$PokemonGlobal.nextBattleBGM = "TA 07 Zorua Archipelago" #"B2W2 107 Battle! (Wild Pokemon)"
		pbSEPlay("Voltorb Flip gain coins")
		#$PokemonGlobal.wild_victory_BGM = "BW 115 Victory! (Wild Pokemon)"
	
	elsif c == 6
		$PokemonGlobal.nextBattleBGM = "XY 016 Battle! (Wild Pokemon)"
		pbSEPlay("Voltorb Flip gain coins")
		#$PokemonGlobal.wild_victory_BGM = "XY 017 Victory! (Wild Pokemon)"
	
	elsif c == 7
		$PokemonGlobal.nextBattleBGM = "SM 021 Battle! (Wild Pokemon)"
		pbSEPlay("Voltorb Flip gain coins")
		#$PokemonGlobal.wild_victory_BGM = "SM 022 Victory! (Wild Pokemon)"
	
	elsif c == 8
		$PokemonGlobal.nextBattleBGM = "SwSh 010 Battle! (Wild Pokémon)"
		pbSEPlay("Voltorb Flip gain coins")
		#$PokemonGlobal.wild_victory_BGM = "SwSh 011 Victory! (Wild Pokémon)"
	
	elsif c == 9
		$PokemonGlobal.nextBattleBGM = "SV Wild Battle Poco Path"
		pbSEPlay("Voltorb Flip gain coins")
		#$PokemonGlobal.wild_victory_BGM = "Pokemon SV Victory Trainer Battle"
	
	elsif c == 10
		$PokemonGlobal.nextBattleBGM = "P4G 102 Time To Make History"
		pbMEPlay("Persona 4 Golden SFX Persona Change")
		#$PokemonGlobal.wild_victory_BGM = "Pokemon SV Victory Trainer Battle"	
	end	
	
	 next 1  
})

ItemHandlers::UseInField.add(:GBSOUNDS, proc { |item|
  cmds = ["Default Battle Music", "Gen 1 Battle Music", "Gen 2 Battle Music", "Gen 3 Battle Music", "Gen 4 Battle Music", "Gen 5 Battle Music", "Gen 6 Battle Music", "Gen 7 Battle Music", "Gen 8 Battle Music", "Gen 9 Battle Music", "A Random Weeb Song", "Cancel"]
  c = pbMessage("What wild battle music do you want?", cmds)
  	if c == 0
		$PokemonGlobal.nextBattleBGM = "RGS Wild Pokemon Battle Rip by Gladiogg"
		pbSEPlay("Voltorb Flip gain coins")
		#$PokemonGlobal.nextWildVictoryBGM = "RGS Peaceful Aftermath Rip by Gladiogg"
		#$PokemonGlobal.nextBattleVictoryBGM = "RGS Peaceful Aftermath Rip by Gladiogg"
		
	elsif c == 1
		$PokemonGlobal.nextBattleBGM = "Catch Wild Pokemon LGPE"
		pbSEPlay("Voltorb Flip gain coins")
		#$PokemonGlobal.nextWildVictoryBGM = "Caught Wild Pokemon LGPE"
		
	elsif c == 2
		$PokemonGlobal.nextBattleBGM = "XD 41 Wild Pokemon Battle"
		pbSEPlay("Voltorb Flip gain coins")
		#$PokemonGlobal.wild_victory_BGM = "HGSS 111 Victory! (Wild Pokemon)"
	
	elsif c == 3
		$PokemonGlobal.nextBattleBGM = "ORAS 008 Battle! (Wild Pokemon)"
		pbSEPlay("Voltorb Flip gain coins")
		#$PokemonGlobal.wild_victory_BGM = "ORAS 009 Victory! (Wild Pokemon)"
	
	elsif c == 4
		$PokemonGlobal.nextBattleBGM = "PLA 013 Battle! (Wild Pokemon)"
		pbSEPlay("Voltorb Flip gain coins")
		#$PokemonGlobal.wild_victory_BGM = "DPPT 012 Victory! (Wild Pokemon)"
	
	elsif c == 5
		$PokemonGlobal.nextBattleBGM = "TA 07 Zorua Archipelago"
		pbSEPlay("Voltorb Flip gain coins")
		#$PokemonGlobal.wild_victory_BGM = "BW 115 Victory! (Wild Pokemon)"
	
	elsif c == 6
		$PokemonGlobal.nextBattleBGM = "XY 016 Battle! (Wild Pokemon)"
		pbSEPlay("Voltorb Flip gain coins")
		#$PokemonGlobal.wild_victory_BGM = "XY 017 Victory! (Wild Pokemon)"
	
	elsif c == 7
		$PokemonGlobal.nextBattleBGM = "SM 021 Battle! (Wild Pokemon)"
		pbSEPlay("Voltorb Flip gain coins")
		#$PokemonGlobal.wild_victory_BGM = "SM 022 Victory! (Wild Pokemon)"
	
	elsif c == 8
		$PokemonGlobal.nextBattleBGM = "SwSh 010 Battle! (Wild Pokémon)"
		pbSEPlay("Voltorb Flip gain coins")
		#$PokemonGlobal.wild_victory_BGM = "SwSh 011 Victory! (Wild Pokémon)"
	
	elsif c == 9
		$PokemonGlobal.nextBattleBGM = "SV Wild Battle Poco Path"
		pbSEPlay("Voltorb Flip gain coins")
		#$PokemonGlobal.wild_victory_BGM = "Pokemon SV Victory Trainer Battle"
		
	elsif c == 10
		$PokemonGlobal.nextBattleBGM = "P4G 102 Time To Make History"
		pbMEPlay("Persona 4 Golden SFX Persona Change")
		#$PokemonGlobal.wild_victory_BGM = "Pokemon SV Victory Trainer Battle"		
	end
    next true
})

#===============================================================================
# Ability Vial 
#===============================================================================
ItemHandlers::UseOnPokemon.add(:ABILITYVIAL, proc { |item, qty, pkmn, scene|
	abils = pkmn.getAbilityList
    ability_commands = []
    abil_cmd = 0
    for i in abils
      ability_commands.push(((i[1] < 2) ? "" : "(H) ") + GameData::Ability.get(i[0]).name)
    end
    cmd = pbMessage("Which ability do you want for your Pokémon?",ability_commands,0,nil,0)
    pkmn.ability = abils[cmd][0]
	pbSEPlay("GUI trainer card open")
  next false
#if scene.pbConfirm(_INTL("Do you want to change {1}'s Ability?", pkmn.name))
#    abils = pkmn.getAbilityList
#    ability_commands = []
#    abil_cmd = 0
#    for i in abils
#      ability_commands.push(((i[1] < 2) ? "" : "(H) ") + GameData::Ability.get(i[0]).name)
#    end
#    cmd= pbMessage("Which ability do you want for your Pokémon?",ability_commands,0,nil,0)
#    pkmn.ability = abils[cmd][0]
#  end
#  next false
})

#===============================================================================
# Vial of Glitter
#===============================================================================
ItemHandlers::UseOnPokemon.add(:VIALOFGLITTER, proc { |item, qty, pkmn, scene|
  if pkmn.shiny? == false
    pbSEPlay('Item Used', 100, 100)
    pbMessage(_INTL("The sparkled glitter has altered your Pokémon!"))
    pkmn.shiny = true
    pkmn.super_shiny = false
  elsif pkmn.shiny? == true
    pbMessage(_INTL("The Pokémon lost it's shine!"))
    pkmn.shiny = false
    pkmn.super_shiny = false
    next false
  end
})

#===============================================================================
# Vial of Super Glitter
#===============================================================================
ItemHandlers::UseOnPokemon.add(:SUPERVIAL, proc { |item, qty, pkmn, scene|
  if pkmn.super_shiny? == false
    pbSEPlay('Item Used', 100, 100)
    pbMessage(_INTL("The sparkling essence has altered your Pokémon!"))
    pkmn.shiny = false
    pkmn.super_shiny = true
  elsif pkmn.super_shiny? == true
    pbMessage(_INTL("The Pokémon lost it's brillant shine!"))
    pkmn.shiny = false
    pkmn.super_shiny = false
    next false
  end
})

#===============================================================================
# All Moves Disk
#===============================================================================
ItemHandlers::UseFromBag.add(:INDIGODISK, proc { |item, bag_screen|
  if $game_variables[MOVETUTOR] == 2
    $game_variables[MOVETUTOR] = 3 # Enables the Hackmon setting, that simply allows every move in the game to be learned by anything
	pbMessage(_INTL("The All Moves Disk is active. Any Pokemon can learn any move!"))
	elsif $game_variables[MOVETUTOR] == 3
	$game_variables[MOVETUTOR] = 2 # Enables the relearning of Level Up, TM, Tutor, Egg, Pre Evolution and Event moves
	pbMessage(_INTL("The All Moves Disk has been turned off."))
	next 1 
  end
})

#===============================================================================
# Any Ability Disk
#===============================================================================
ItemHandlers::UseFromBag.add(:ANYABILITYDISK, proc { |pkmn, pkmnid, item, bag_screen|

})


#===============================================================================
# Any Item Disk
#===============================================================================
ItemHandlers::UseFromBag.add(:ANYITEMDISK, proc { |item, bag_screen|
  
})

#===============================================================================
# Set Poke Dollars Disk
#===============================================================================
ItemHandlers::UseFromBag.add(:SETPOKEDOLLARSDISK, proc { |item, bag_screen|
  params = ChooseNumberParams.new
  params.setRange(0, Settings::MAX_MONEY)
  params.setDefaultValue($player.money)
  $player.money = pbMessageChooseNumber("\\ts[]" + _INTL("Set the player's money."), params)
})

#===============================================================================
# Pokemon Center Disk
#===============================================================================
ItemHandlers::UseFromBag.add(:POKEMONCENTERDISK, proc { |pkmn, item, bag_screen|
  $player.party.each { |pkmn| pkmn.heal }
  pbMessage(_INTL("Your Pokémon were fully healed."))
})

ItemHandlers::UseInField.add(:POKEMONCENTERDISK, proc { |pkmn, item|
	$player.party.each { |pkmn| pkmn.heal }
	pbMessage(_INTL("Your Pokémon were fully healed."))

    next true
})

#===============================================================================
# Set Gym Badges Disk
#===============================================================================
ItemHandlers::UseFromBag.add(:SETGYMBADGEDISK, proc { |item, bag_screen|

})

#===============================================================================
# Dynamax Inhibitor 
#===============================================================================
ItemHandlers::UseOnPokemon.add(:DYNAMAXINHIBITOR, proc { |item, qty, pkmn, scene|
  if pkmn.dynamax_able? == true
    pbSEPlay('Item Used', 100, 100)
    pbMessage(_INTL("This Pokémon's Dynamax Factor has been inhibited!"))
    pkmn.dynamax_able = false
  elsif pkmn.dynamax_able? == false
    pbMessage(_INTL("The Pokémon's Dynamax Factor is now unleashed!"))
    pkmn.dynamax_able = true
    next false
  end
})

#===============================================================================
# Razor Claw
#===============================================================================
Battle::ItemEffects::DamageCalcFromUser.add(:RAZORCLAW,
  proc { |item, user, target, move, mults, baseDmg, type|
    mults[:power_multiplier] *= 1.2 if move.slicingMove?
  }
)

#===============================================================================
# Gold Teeth
#===============================================================================
Battle::ItemEffects::DamageCalcFromUser.add(:GOLDTEETH,
  proc { |item, user, target, move, mults, baseDmg, type|
    mults[:power_multiplier] *= 1.2 if move.bitingMove?
  }
)

#===============================================================================
# Encounter Adjuster
#===============================================================================
ItemHandlers::UseFromBag.add(:VSRECORDER, proc { |item|
	cmds = ["Encounter List", "Region Specfic Pokémon", "Dexnav and Listing Tips", "Cancel"]
	c = pbMessage("Choose an adjustment setting", cmds)
	if c == 0
		pbViewEncounters # Requires Encounter List UI: https://eeveeexpo.com/resources/658/
	elsif c == 1
		pbEncounterVersion # Requires Map Encounter Version - Selection Display: https://eeveeexpo.com/resources/1433/
	
	elsif c == 2
		pbShowTipCard(:ENCOUNTERNUMBERS,:ENCOUNTERNUMBERS2,:DEVNAV) # Requires Tip Cards: https://eeveeexpo.com/resources/1496/
	end
	
	next 1
})

ItemHandlers::UseInField.add(:VSRECORDER, proc { |item|
	cmds = ["Encounter List", "Region Specfic Pokémon", "Dexnav and Listing Tips", "Cancel"]
	c = pbMessage("Choose an adjustment setting", cmds)
	if c == 0
		pbViewEncounters # Requires Encounter List UI: https://eeveeexpo.com/resources/658/
	elsif c == 1
		pbEncounterVersion # Requires Map Encounter Version - Selection Display: https://eeveeexpo.com/resources/1433/
	
	elsif c == 2
		pbShowTipCard(:ENCOUNTERNUMBERS,:ENCOUNTERNUMBERS2,:DEVNAV) # Requires Tip Cards: https://eeveeexpo.com/resources/1496/
	end
	
	next true
})

#===============================================================================
# Doom Candy (Lowers Levels)
#===============================================================================
ItemHandlers::UseOnPokemonMaximum.add(:DOOMCANDY, proc { |item, pkmn|
  next GameData::GrowthRate.max_level - pkmn.level
})

ItemHandlers::UseOnPokemon.add(:DOOMCANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, pkmn.level - qty, scene)
  scene.pbHardRefresh
  next true
})

#===============================================================================
# Precision Candy (Exp is raised to just before the level is raised. Useful for Nuzlockes)
# Reset Candy (Will set a Pokemon back to Lvl.5. Needed for a UX friendly way of resetting the Level Scale for the player. The Level Adjuster already exists, but most players will not bother there arse with the tool)
#===============================================================================
ItemHandlers::UseOnPokemon.add(:EXPPRECISION, proc { |item, qty, pkmn, scene|
  #maxxp = pkmn.growth_rate.minimum_exp_for_level(pkmn.level + 1)
  #pkmn.exp = maxxp - 1
  #scene.pbDisplay(_INTL("{1} gained precise Exp!", pkmn.name))
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 5, scene)
  scene.pbHardRefresh
  next true
})

#===============================================================================
# Level Cap Candies (Used due to Plugin conflicts stopping the Rare Candy use in Quanity feature)
#===============================================================================
ItemHandlers::UseOnPokemon.add(:LVL1CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 1, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL2CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 2, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL3CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 3, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL4CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 4, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL5CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 5, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL6CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 6, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL7CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 7, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL8CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 8, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL9CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 9, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL10CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 10, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL11CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 11, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL12CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 12, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL13CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 13, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL14CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 14, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL15CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 15, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL16CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 16, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL17CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 17, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL18CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 18, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL19CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 19, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL20CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 20, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL21CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 21, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL22CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 22, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL23CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 23, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL24CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 24, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL25CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 25, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL26CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 26, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL27CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 27, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL28CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 28, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL29CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 29, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL30CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 30, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL31CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 31, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL32CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 32, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL33CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 33, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL34CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 34, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL35CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 35, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL36CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 36, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL37CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 37, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL38CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 38, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL39CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 39, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL40CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 40, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL41CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 41, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL42CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 42, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL43CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 43, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL44CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 44, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL45CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 45, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL46CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 46, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL47CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 47, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL48CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 48, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL49CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 49, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL50CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 50, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL51CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 51, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL52CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 52, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL53CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 53, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL54CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 54, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL55CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 55, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL56CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 56, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL57CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 57, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL58CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 58, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL59CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 59, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL60CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 60, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL61CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 61, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL62CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 62, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL63CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 63, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL64CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 64, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL65CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 65, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL66CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 66, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL67CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 67, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL68CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 68, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL69CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 69, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL70CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 70, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL71CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 71, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL72CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 72, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL73CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 73, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL74CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 74, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL75CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 75, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL76CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 76, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL77CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 77, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL78CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 78, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL79CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 79, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL80CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 80, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL81CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 81, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL82CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 82, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL83CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 83, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL84CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 84, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL85CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 85, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL86CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 86, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL87CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 87, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL88CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 88, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL89CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 89, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL90CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 90, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL91CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 91, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL92CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 92, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL93CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 93, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL94CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 94, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL95CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 95, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL96CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 96, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL97CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 97, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL98CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 98, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL99CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 99, scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:LVL100CANDY, proc { |item, qty, pkmn, scene|
  if pkmn.shadowPokemon?
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.level >= GameData::GrowthRate.max_level
    new_species = pkmn.check_evolution_on_level_up
    if !Settings::RARE_CANDY_USABLE_AT_MAX_LEVEL || !new_species
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    # Check for evolution
    pbFadeOutInWithMusic {
      evo = PokemonEvolutionScene.new
      evo.pbStartScreen(pkmn, new_species)
      evo.pbEvolution
      evo.pbEndScreen
      scene.pbRefresh if scene.is_a?(PokemonPartyScreen)
    }
    next true
  end
  # Level down
  pbSEPlay("Pkmn level up")
  pbChangeLevel(pkmn, 100, scene)
  scene.pbHardRefresh
  next true
})
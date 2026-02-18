# Dancer Nectar (Combines the Oricorio Form Nectars into one item, to allow for more Nectar Form changing items for Pokemon lines that need them)
ItemHandlers::UseOnPokemon.add(:REDNECTAR, proc { |item, qty, pkmn, scene|
  if !pkmn.isSpecies?(:ORICORIO)
    scene.pbDisplay(_INTL("It had no effect."))
    next false
  elsif pkmn.fainted?
    scene.pbDisplay(_INTL("This can't be used on the fainted Pokémon."))
    next false
  end
  choices = [ # Choices must match the ID number of Oricorio's Forms (A Pokemon's base Form begins at 0)
   _INTL("Baile Style"),
   _INTL("Pom-Pom Style"),
   _INTL("Pa'u Style"),
   _INTL("Sensu Style"),
	_INTL("Cancel")
  ]
  new_form = scene.pbShowCommands(_INTL("What Style do you want?"), choices, pkmn.form)
  if new_form == pkmn.form
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  elsif new_form >= 0 && new_form < choices.length - 1 # >= is used to allow Oricorio to revert back to it's Base Form, Baile Style (Fire/Flying)
    pkmn.setForm(new_form) do
      scene.pbRefresh
      scene.pbDisplay(_INTL("{1} transformed!", pkmn.name))
    end
    next true
  end
  next false
})

# Weather Nectar (Allows Castform's Forms to be manually changed. Castform in Pokemon Decades can use Abilties that are not Forecast)
ItemHandlers::UseOnPokemon.add(:YELLOWNECTAR, proc { |item, qty, pkmn, scene|
  if !pkmn.isSpecies?(:CASTFORM)
    scene.pbDisplay(_INTL("It had no effect."))
    next false
  elsif pkmn.fainted?
    scene.pbDisplay(_INTL("This can't be used on the fainted Pokémon."))
    next false
  end
  choices = [ # Choices must match the ID number of Castform's Forms (A Pokemon's base Form begins at 0)
   _INTL("Plain Weather"),
   _INTL("Sunny Weather"),
   _INTL("Rainy Weather"),
   _INTL("Snowy Weather"),
	_INTL("Cancel")
  ]
  new_form = scene.pbShowCommands(_INTL("What Weather do you want?"), choices, pkmn.form)
  if new_form == pkmn.form
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  elsif new_form >= 0 && new_form < choices.length - 1 # >= is used to allow Castform to revert back to it's Base Form, Plain Weather (Normal)
    pkmn.setForm(new_form) do
      scene.pbRefresh
      scene.pbDisplay(_INTL("{1} transformed!", pkmn.name))
    end
    next true
  end
  next false
})

# Nations Nectar (Allows Vivillion's Forms to be manually changed. Vivillion's Forms can have different Types, to justify the hassle of having 20 forms. Some forms, such as Jungle (Bug/Dragon) are different types.
ItemHandlers::UseOnPokemon.add(:PINKNECTAR, proc { |item, qty, pkmn, scene|
  if !pkmn.isSpecies?(:VIVILLON)
    scene.pbDisplay(_INTL("It had no effect."))
    next false
  elsif pkmn.fainted?
    scene.pbDisplay(_INTL("This can't be used on the fainted Pokémon."))
    next false
  end
  choices = [ # Choices must match the ID number of Vivillion's Forms (A Pokemon's base Form begins at 0)
   _INTL("Archipelago"),
   _INTL("Continental"),
   _INTL("Elegant"),
   _INTL("Garden"),
   _INTL("High Plains"),
   _INTL("Icy Snow"),
   _INTL("Jungle"),
   _INTL("Marine"),
   _INTL("Meadow"),
   _INTL("Modern"),
   _INTL("Monsoon"),
   _INTL("Ocean"),
   _INTL("Polar"),
   _INTL("River"),
   _INTL("Sandstorm"),
   _INTL("Savanna"),
   _INTL("Sun"),
   _INTL("Tundra"),
   _INTL("Fancy"),
   _INTL("Poké Ball"),
	_INTL("Cancel")
  ]
  new_form = scene.pbShowCommands(_INTL("What Pattern do you want?"), choices, pkmn.form)
  if new_form == pkmn.form
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  elsif new_form >= 0 && new_form < choices.length - 1 # >= is used to allow Vivillion to revert back to it's Base Form, Archipelago
    pkmn.setForm(new_form) do
      scene.pbRefresh
      scene.pbDisplay(_INTL("{1} transformed!", pkmn.name))
    end
    next true
  end
  next false
})

# Fashion Nectar (Allows Furfrou's Forms to be manually changed. Furfrou no longer loses it's Trim after five days. The trim's can have different Types)
ItemHandlers::UseOnPokemon.add(:PURPLENECTAR, proc { |item, qty, pkmn, scene|
  if !pkmn.isSpecies?(:FURFROU)
    scene.pbDisplay(_INTL("It had no effect."))
    next false
  elsif pkmn.fainted?
    scene.pbDisplay(_INTL("This can't be used on the fainted Pokémon."))
    next false
  end
  choices = [ # Choices must match the ID number of Furfrou's Forms (A Pokemon's base Form begins at 0)
   _INTL("Natural"),
   _INTL("Heart"),
   _INTL("Star"),
   _INTL("Diamond"),
   _INTL("Debutante"),
   _INTL("Matron"),
   _INTL("Dandy"),
   _INTL("La Reine"),
   _INTL("Kabuki"),
   _INTL("Pharaoh"),
	_INTL("Cancel")
  ]
  new_form = scene.pbShowCommands(_INTL("What Trim do you want?"), choices, pkmn.form)
  if new_form == pkmn.form
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  elsif new_form >= 0 && new_form < choices.length - 1 # >= is used to allow Furfrou to revert back to it's Base Form, Natural
    pkmn.setForm(new_form) do
      scene.pbRefresh
      scene.pbDisplay(_INTL("{1} transformed!", pkmn.name))
    end
    next true
  end
  next false
})
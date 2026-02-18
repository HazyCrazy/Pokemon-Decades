ItemHandlers::UseOnPokemon.add(:LEGENDPLATE, proc { |item, qty, pkmn, scene|
  if !pkmn.isSpecies?(:ARCEUS)
    scene.pbDisplay(_INTL("It had no effect."))
    next false
  elsif pkmn.fainted?
    scene.pbDisplay(_INTL("This can't be used on the fainted Pokémon."))
    next false
  end
  choices = [ # Choices must match the ID number of Arceus's Forms
    _INTL("Normal"),
    _INTL("Fighting"),
    _INTL("Flying"),
    _INTL("Poison"),
    _INTL("Ground"),
    _INTL("Rock"),
	_INTL("Bug"),
	_INTL("Ghost"),
	_INTL("Steel"),
	_INTL("???"),
	_INTL("Fire"),
	_INTL("Water"),
	_INTL("Grass"),
	_INTL("Electric"),
	_INTL("Psychic"),
	_INTL("Ice"),
	_INTL("Dragon"),
	_INTL("Dark"),
    _INTL("Fairy"),
	_INTL("Cancel")
  ]
  new_form = scene.pbShowCommands(_INTL("What Type do you want?"), choices, pkmn.form)
  if new_form == pkmn.form
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  elsif new_form >= 0 && new_form < choices.length - 1 # >= is used to allow Arceus to revert back to it's Normal Type
    pkmn.setForm(new_form) do
      scene.pbRefresh
      scene.pbDisplay(_INTL("{1} transformed!", pkmn.name))
    end
    next true
  end
  next false
})

ItemHandlers::UseOnPokemon.add(:ULTRAMEMORY, proc { |item, qty, pkmn, scene|
  if !pkmn.isSpecies?(:SILVALLY)
    scene.pbDisplay(_INTL("It had no effect."))
    next false
  elsif pkmn.fainted?
    scene.pbDisplay(_INTL("This can't be used on the fainted Pokémon."))
    next false
  end
  choices = [ # Choices must match the ID number of Silvally's Forms (No sprites in the Animated Pokemon/Gen 9 Pack exist for ??? Silvally)
    _INTL("Normal"),
    _INTL("Fighting"),
    _INTL("Flying"),
    _INTL("Poison"),
    _INTL("Ground"),
    _INTL("Rock"),
	_INTL("Bug"),
	_INTL("Ghost"),
	_INTL("Steel"),
	_INTL("???"),
	_INTL("Fire"),
	_INTL("Water"),
	_INTL("Grass"),
	_INTL("Electric"),
	_INTL("Psychic"),
	_INTL("Ice"),
	_INTL("Dragon"),
	_INTL("Dark"),
    _INTL("Fairy"),
	_INTL("Cancel")
  ]
  new_form = scene.pbShowCommands(_INTL("What Type do you want?"), choices, pkmn.form)
  if new_form == pkmn.form
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  elsif new_form >= 0 && new_form < choices.length - 1 # >= is used to allow Silvally to revert back to it's Normal Type
    pkmn.setForm(new_form) do
      scene.pbRefresh
      scene.pbDisplay(_INTL("{1} transformed!", pkmn.name))
    end
    next true
  end
  next false
})
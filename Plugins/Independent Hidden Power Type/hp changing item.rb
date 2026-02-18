#-----------------------
#The item that is used to change the hidden power type can be set to any item you desire.
#If you don't want to have an item that changes hidden power type you can simply don't edit the code below
#...unless you have an item in your game with id :ANYITEM  lol

#Unrestricted Hidden Power changing.
ItemHandlers::UseOnPokemon.add(:HIDDENORB, proc { |item, qty, pokemon, scene, screen, msg|
      commands = []
      types = []
      GameData::Type.each do |t|
        if !t.pseudo_type && ![:NORMAL, :SHADOW].include?(t.id)
          commands.push(t.name)
          types.push(t.id) 
       end
      end
      commands.push(_INTL("Cancel"))
      cmd = types.index(pokemon.hptype) || 0
      cmd = pbMessage(_INTL("Choose the type of {1}'s Hidden Power.",pokemon.name), commands, -1, nil, cmd)
      if cmd >=0 && cmd<types.length && pokemon.hptype != types[cmd]
      pokemon.hptype = types[cmd]
      scene.pbDisplay(_INTL("{1}'s Hidden Power has been set to {2}.",pokemon.name, pokemon.hptype))
      else
      # canceled
      end
})

#Restricted Hidden Power changing.
ItemHandlers::UseOnPokemon.add(:OLDGATEAU, proc { |item, qty, pokemon, scene, screen, msg|
  if !pokemon.hptypeflag  # If the pokemon's hidden power has not been altered, proceed.
    commands = []
    types = []
    GameData::Type.each do |t|
      if !t.pseudo_type && ![:NORMAL, :SHADOW].include?(t.id)
        commands.push(t.name)
        types.push(t.id) 
      end
    end
    commands.push(_INTL("Cancel"))
    cmd = types.index(pokemon.hptype) || 0
    cmd = pbMessage(_INTL("Choose the type of {1}'s Hidden Power.",pokemon.name), commands, -1, nil, cmd)
    if cmd >=0 && cmd<types.length && pokemon.hptype != types[cmd]
    pokemon.hptype = types[cmd]
    pokemon.sethptypeflag  # Marks the Pokemon as one with its Hidden Power altered.
    scene.pbDisplay(_INTL("{1}'s Hidden Power has been set to {2}.",pokemon.name, pokemon.hptype))
    else
    # canceled
    end
  else
    scene.pbDisplay(_INTL("This Pokemon's Hidden Power has already been altered."))
  end   
})

#Changing to a specified Hidden Power type.
ItemHandlers::UseOnPokemon.add(:HPCHANGINGSPECIFIED, proc { |item, qty, pokemon, scene, screen, msg|
      pokemon.hptype = :FIRE
      scene.pbDisplay(_INTL("{1}'s Hidden Power has been set to {2}.",pokemon.name, pokemon.hptype))
})
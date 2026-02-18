# Basic state tracking
$PermanentRepel = {
  active: false,
  type: nil
}

SaveData.register(:permanent_repel) do
  save_value { $PermanentRepel }
  load_value { |value| $PermanentRepel = value || { active: false, type: nil } }
  new_game_value { { active: false, type: nil } }
end

# Simple item handler that just toggles the state
ItemHandlers::UseFromBag.add(:REPELCHARM, proc { |item|
  if $PermanentRepel[:active] && $PermanentRepel[:type] == :REPELCHARM
    # Deactivate
    $PermanentRepel[:active] = false
    $PermanentRepel[:type] = nil
    pbMessage(_INTL("Repel Toggle offline. Wild Pokémon will appear normally."))
  else
    # Activate
    if $PokemonGlobal.repel > 0
      $PokemonGlobal.repel = 0
    end
    
    $PermanentRepel[:active] = true
    $PermanentRepel[:type] = :REPELCHARM
    pbMessage(_INTL("Repel Toggle online. Wild Pokémon will not appear. Dexnav can still be used."))
  end
  next 1  # Return 1 to close the bag after use
})

# Also make it usable in field
ItemHandlers::UseInField.add(:REPELCHARM, proc { |item|
  if $PermanentRepel[:active] && $PermanentRepel[:type] == :REPELCHARM
    # Deactivate
    $PermanentRepel[:active] = false
    $PermanentRepel[:type] = nil
	pbMessage(_INTL("Repel Toggle offline. Wild Pokémon will appear normally."))
  else
    # Activate
    if $PokemonGlobal.repel > 0
      $PokemonGlobal.repel = 0
    end
    
    $PermanentRepel[:active] = true
    $PermanentRepel[:type] = :REPELCHARM
    pbMessage(_INTL("Repel Toggle online. Wild Pokémon will not appear. Dexnav can still be used."))
  end
  next true  # Successfully used
})

# Block encounters when permanent repel is active
class PokemonEncounters  
  alias original_allow_encounter allow_encounter?
  def allow_encounter?(enc_data, repel_active = false)
    # Return false (no encounter) if permanent repel is active
    return false if $PermanentRepel && $PermanentRepel[:active]
    return original_allow_encounter(enc_data, repel_active)
  end
end
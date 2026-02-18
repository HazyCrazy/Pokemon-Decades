

#===============================================================================
# Creates and returns a Pokémon based on the given species and level.
# Applies wild Pokémon modifiers (wild held item, shiny chance modifiers,
# Pokérus, gender/nature forcing because of player's lead Pokémon).
def pbGenerateWildPokemon(species, level, isRoamer = false)
  genwildpoke = Pokemon.new(species, level)
  # Give the wild Pokémon a held item
  items = genwildpoke.wildHoldItems
  first_pkmn = $player.first_pokemon
  chances = [50, 5, 1]
  if first_pkmn
    case first_pkmn.ability_id
    when :COMPOUNDEYES
      chances = [60, 20, 5]
    when :SUPERLUCK
      chances = [60, 20, 5] if Settings::MORE_ABILITIES_AFFECT_WILD_ENCOUNTERS
    end
  end
  itemrnd = rand(100)
  if (items[0] == items[1] && items[1] == items[2]) || itemrnd < chances[0]
    genwildpoke.item = items[0].sample
  elsif itemrnd < (chances[0] + chances[1])
    genwildpoke.item = items[1].sample
  elsif itemrnd < (chances[0] + chances[1] + chances[2])
    genwildpoke.item = items[2].sample
  end
  # Improve chances of shiny Pokémon with Shiny Charm and battling more of the
  # same species
  shiny_retries = 0
  shiny_retries += 2 if $bag.has?(:SHINYCHARM)
  if Settings::HIGHER_SHINY_CHANCES_WITH_NUMBER_BATTLED
    values = [0, 0]
    case $player.pokedex.battled_count(species)
    when 0...50    then values = [0, 0]
    when 50...100  then values = [1, 15]
    when 100...200 then values = [2, 20]
    when 200...300 then values = [3, 25]
    when 300...500 then values = [4, 30]
    else                values = [5, 30]
    end
    shiny_retries += values[0] if values[1] > 0 && rand(1000) < values[1]
  end
  if shiny_retries > 0
    shiny_retries.times do
      break if genwildpoke.shiny?
      genwildpoke.shiny = nil   # Make it recalculate shininess
      genwildpoke.personalID = rand(2**16) | (rand(2**16) << 16)
    end
  end
  # Give Pokérus
  genwildpoke.givePokerus if rand(65_536) < Settings::POKERUS_CHANCE
  # Change wild Pokémon's gender/nature depending on the lead party Pokémon's
  # ability
  if first_pkmn
    if first_pkmn.hasAbility?(:CUTECHARM) && !genwildpoke.singleGendered?
      if first_pkmn.male?
        (rand(3) < 2) ? genwildpoke.makeFemale : genwildpoke.makeMale
      elsif first_pkmn.female?
        (rand(3) < 2) ? genwildpoke.makeMale : genwildpoke.makeFemale
      end
    elsif first_pkmn.hasAbility?(:SYNCHRONIZE)
      if !isRoamer && (Settings::MORE_ABILITIES_AFFECT_WILD_ENCOUNTERS || (rand(100) < 50))
        genwildpoke.nature = first_pkmn.nature
        genwildpoke.hptype = first_pkmn.hptype # DemICE Independent Hidden Power Type  edit
      end
    end
  end
  # Trigger events that may alter the generated Pokémon further
  EventHandlers.trigger(:on_wild_pokemon_created, genwildpoke)
  return genwildpoke
end


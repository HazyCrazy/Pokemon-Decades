module TrashCans
  DAILY_ITEMS = [
  #:SUPERREPEL,
  #:MAXELIXIR,
  #:DUSKBALL,
  #:HPUP,
  #:PROTEIN,
  #:IRON,
  :HONEY,
  #:POKETOY,
  #:PRETTYWING,
  #:TINYMUSHROOM,
  #:BIGMUSHROOM,
  #:MAXREVIVE,
  #:MENTALHERB
  ]
  
  TUESDAY_ITEMS = [
  #:MAXREPEL,
  #:NUGGET,
  :BIGNUGGET,
  #:CALCIUM,
  #:ZINC,
  #:CARBOS
  ]
  
  THURSDAY_ITEMS = [
  #:HONEY,
  #:PRISMSCALE,
  #:BIGMUSHROOM,
  #:BALMMUSHROOM,
  :EVIOLITE,
  #:HEALPOWDER,
  #:REVIVALHERB
  ]
  
  def self.pbTrashEncounter(force_daily = false)
    day = pbGetTimeNow.wday
    items = (day == 2 ? TUESDAY_ITEMS : day == 4 ? THURSDAY_ITEMS : DAILY_ITEMS)
    items = DAILY_ITEMS if force_daily
    chance = rand(2)
    chance = 0 if $PokemonGlobal.repel > 0
    if chance == 1
      $PokemonEncounters.pbFindTrashEncounter
    else
      item = items.sample
      pbItemBall(item)
    end
  end
end

GameData::EncounterType.register({
  :id             => :TrashCan,
  :type           => :trash
})

GameData::EncounterType.register({
  :id             => :TuesdayTrashCan,
  :type           => :trash
})

GameData::EncounterType.register({
  :id             => :ThursdayTrashCan,
  :type           => :trash
})

class PokemonEncounters
  def has_trash_encounters?
    GameData::EncounterType.each do |enc_type|
      return true if enc_type.type == :trash && has_encounter_type?(enc_type.id)
    end
    return false
  end
  
  def pbFindTrashEncounter(only_single = true)
    enc_type = (find_valid_encounter_type_for_trash(:TrashCan))
    enc_type.to_sym if enc_type
    Console.echo_warn("[Trash Cans Plugin]: No Trash Can Encounter is defined for this map!")
    return false if !enc_type
    pkmn1 = $PokemonEncounters.choose_wild_pokemon(enc_type)
    return false if !pkmn1
    if !only_single && $PokemonEncounters.have_double_wild_battle?
      pkmn2 = $PokemonEncounters.choose_wild_pokemon(enc_type)
      return false if !pkmn1
      WildBattle.start(pkmn1, pkmn2, can_override: true)
    else
      WildBattle.start(pkmn1, can_override: true)
    end
    $game_temp.encounter_type = nil
    $game_temp.force_single_battle = false
    return true
  end
  
  def find_valid_encounter_type_for_trash(base_type)
    ret = nil
    try_type = nil
    if PBDayNight.pbIsWeekday(0, 2)
      try_type = ("Tuesday" + base_type.to_s).to_sym
    elsif PBDayNight.pbIsWeekday(0, 4)
      try_type = ("Thursday" + base_type.to_s).to_sym
    end
    ret = try_type if try_type && has_encounter_type?(try_type)
    return ret if ret
    return (has_encounter_type?(base_type)) ? base_type : nil
  end
end
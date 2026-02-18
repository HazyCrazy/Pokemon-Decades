class PokemonRegionMap_Scene
  def getCounter
    @globalCounter = {}
    return if !ARMSettings::ProgressCounter
    locations = @mapPoints.map { |mapData| mapData[2] }.uniq
    # separate counter for wild pokemon because different maps can have the same species as another map.
    # They only need to be counted once in a same district.
    wild = Hash.new { |h, k| h[k] = { seen: 0, caught: 0, total: Hash.new(0), map: 0 } }
    # Initialize counters for each district
    gameMaps = { :trainers => {}, :items => {}, :wild => {} }
    districtCounters = Hash.new { |h, k| h[k] = { :progress => 0, :total => 0,
                                                  :maps => { visited: 0, total: 0 },
                                                  :encounters => { pokedex: 0, total: 0 },
                                                  :trainers => { defeated: 0, total: 0 },
                                                  :items => { found: 0, total: 0}
                                                } }
    GameData::MapMetadata.each do |gameMap|
      # check if the gameMap has a town map position and if it's equal to the current region ID.
      next if gameMap.town_map_position.nil? || gameMap.town_map_position[0] != @region
      # get the district name.
      district = getDistrictName(gameMap.town_map_position, @map)
      # get the encounter table for the current gameMap
      encounterData = GameData::Encounter.get(gameMap.id, $PokemonGlobal.encounter_version)
      unless encounterData.nil?
        tally = encounterData.types.values.flatten(1).map { |data| data[1] }.tally
        wild[district][:total].update(tally) { |key, oldVal, newVal| oldVal + newVal }
        gameMaps[:wild][gameMap.id] ||= 0
        gameMaps[:wild][gameMap.id] = tally.length
      end
      # Counting events that have an item
      begin
        map = load_data(sprintf("Data/Map%03d.rxdata", gameMap.id))
      rescue
        Console.echoln_li _INTL("Map%03d.rxdata not found, please check your mapMetadata.txt PBS file", gameMap.id)
        next
      end
      items = 0
      trainers = 0
      trainerlist = []
      map.events.each do |event|
        if event[1].name[/item/i]
          next if !ARMSettings::ProgressCountItems
          event[1].pages.each do |page|
            page.list.each do |line|
              # 111 is conditional, 355 is script command.
              next if line.code.nil? || line.code != 111 && line.code != 355
              script = line.code == 111 ? line.parameters[1] : line.parameters[0]
              next if script.nil? || script.is_a?(Numeric) || !(script.include?("pbItemBall") || script.include?("pbReceiveItem") || script.include?("pbGetKeyItem"))
              split = script.split(',').map { |s| s.split(')')[0] }
              number = !(split[1].nil?) ? split[1].to_i : 1
              items += number
            end
          end
        elsif event[1].name[/trainer/i]
          next if !ARMSettings::ProgressCountTrainers
          event[1].pages.each do |page|
            page.list.each do |line|
              next if line.code.nil? || line.code != 111
              script = line.parameters[1]
              next if script.nil? || script.is_a?(Numeric) || !(script.include?("TrainerBattle.start"))
              tName = script.split('(').map { |s| s.split(',') }[1][1]
              next if trainerlist.any? { |name, id| name == tName && (event[0] == id || tName.include?("&"))}
              trainerlist << [tName, event[0]]
              trainers += 1
            end
          end
        elsif event[1].name[/wild|static/i]
          next if !ARMSettings::ProgressCountSpecies
          event[1].pages.each do |page|
            page.list.each do |line|
              next if line.code.nil? || line.code != 355
              script = line.parameters[0]
              next if script.nil? || script.is_a?(Numeric) || !(script.include?("WildBattle.start"))
              split = script.split('(').map { |s| s.split(', ') }
              species = split[1].select { |el| /[A-Z]/.match?(el) }.map! { |sp| sp.gsub(":", "").to_sym }
              wild[district][:total].update(species.tally) { |key, oldVal, newVal| oldVal + newVal }
            end
          end
        end
      end
      gameMaps[:items][gameMap.id] ||= 0
      gameMaps[:items][gameMap.id] += items
      districtCounters[district][:items][:total] += items
      gameMaps[:trainers][gameMap.id] ||= 0
      gameMaps[:trainers][gameMap.id] += trainers
      districtCounters[district][:trainers][:total] += trainers
      # main maps
      map = locations.find { |map| pbGetMessageFromHash(LocationNames, map) == gameMap.name && gameMap.outdoor_map }
      # check for POI map if no main map found
      if map.nil?
        findMap = ARMSettings::LinkPoiToMap.find { |name| gameMap.id == name[1] }
        unless findMap.nil?
          map = GameData::MapMetadata.try_get(findMap[1])
        end
      end
      # skip if there's still no match found
      next if map.nil?
      # Check if the map belongs to any district
      unless district.nil?
        # Update district counters
        next if !ARMSettings::ProgressCountVisitedLocations
        districtCounters[district][:maps][:total] += 1
        districtCounters[district][:maps][:visited] += 1 if $PokemonGlobal.visitedMaps[gameMap.id]
      end
    end
    # Wild Encounters
    if ARMSettings::ProgressCountSpecies
      wild.each do |district, encounters|
        districtCounters[district][:encounters][:total] = encounters[:total].count * 2
        encounters[:total].keys.each do |species|
          districtCounters[district][:encounters][:pokedex] += 1 if $player.seen?(species)
          districtCounters[district][:encounters][:pokedex] += 1 if $player.owned?(species)
        end
      end
    end
    # Create the total count for each district and overall.
    progressCount = totalCount = 0
    districtCounters.each do |district, counters|
      if !$ArckyGlobal.itemTracker.nil?
        districtCounters[district][:items][:found] = $ArckyGlobal.itemTracker[district][:total] if $ArckyGlobal.itemTracker[district]
      end
      if !$ArckyGlobal.trainerTracker.nil?
        districtCounters[district][:trainers][:defeated] = $ArckyGlobal.trainerTracker[district][:total] if $ArckyGlobal.trainerTracker[district]
      end
      total = progress = 0
      counters.each do |key, hash|
        next if key == :gameMap
        next if key == :progress || key == :total
        progress += hash.values[0]
        total += hash[:total]
      end
      districtCounters[district][:progress] = progress
      districtCounters[district][:total] = total
      progressCount += progress
      totalCount += total
    end
    @globalCounter = { progress: progressCount, total: totalCount, districts: districtCounters, gameMaps: gameMaps }
    $ArckyGlobal.globalCounter = convertToRegularHash(@globalCounter)
  end
end

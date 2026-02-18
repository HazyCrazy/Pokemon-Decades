class PokemonRegionMap_Scene
  def addTrainerIconSprites(trainerIndex = nil)
    usedPositions = {}
    if !@spritesMap["TrainerIcons"] && ARMSettings::ShowTrainerIcons
      @spritesMap["TrainerIcons"] = BitmapSprite.new(@mapWidth, @mapHeight, @viewportMap)
      @spritesMap["TrainerIcons"].x = @spritesMap["map"].x
      @spritesMap["TrainerIcons"].y = @spritesMap["map"].y
      @spritesMap["TrainerIcons"].z = 50
    end
    return if !@spritesMap["TrainerIcons"]
    @spritesMap["TrainerIcons"].bitmap.clear
    @trainerData.each do |trainer|
      @playerOnIcon = adjustPosX(trainer[:mapX]) === @playerPos[1] && adjustPosY(trainer[:mapY]) === @playerPos[2] if !@playerOnIcon
      if trainerIndex
        next if trainer[:name] != trainerIndex[:name] && trainer[:type] != trainerIndex[:type] && trainer[:mapX] == trainerIndex[:mapX] && trainer[:mapY] == trainerIndex[:mapY]
      end
      next if usedPositions.key?([trainer[:mapX], trainer[:mapY]])
      pbDrawImagePositions(
        @spritesMap["TrainerIcons"].bitmap,
        [["#{Folder}Icons/Trainer/mapTrainer#{trainer[:type].to_s}", pointXtoScreenX(trainer[:mapX]), pointYtoScreenY(trainer[:mapY])]]
      )
      usedPositions[[trainer[:mapX], trainer[:mapY]]] = true
    end
    @spritesMap["TrainerIcons"].visible = @mode == 5
  end

  def getTrainerName(x, y)
    return if @trainerData.empty?
    @previewWidth = 284
    value = ""
    trainers = @trainerData.select { |trainer| trainer[:mapX] == x && trainer[:mapY] == y }
    if !trainers.empty?
      if trainers.length > 1
        @trainerIndex = @trainerIndex.floor if !@trainerIndex.nil?
        value = "Rematches: #{trainers.length} Trainers" if @trainerIndexex.nil? || @trainerIndex == 0
        if !@trainerIndex.nil? && @trainerIndex != 0
          type = trainers[@trainerIndex - 1][:type]
          type = type.to_sym if !type.is_a?(Symbol)
          trainerType = GameData::TrainerType.try_get(trainers[@trainerIndex - 1][:type])
          value = "Rematch: #{trainerType.real_name} #{trainers[@trainerIndex - 1][:name]}"
        end
      else
        trainerType = GameData::TrainerType.try_get(trainers[0][:type])
        value = "Rematch: #{trainerType.real_name} #{trainers[0][:name]}"
      end
    end
    updateButtonInfo if !ARMSettings::ButtonBoxPosition.nil?
    @sprites["modeName"].bitmap.clear
    mapModeSwitchInfo if value == ""
    return value
  end

  def getTrainerData
    @trainerData = []
    return if !ARMSettings::ShowTrainerIcons
    $PokemonGlobal.phone.contacts.each do |contact|
      addTrainerData(contact.name, contact.trainer_type, contact.map_id, contact.event_id)
    end
    ARMSettings::TrainerRematchesConfig.each do |switch, data|
      next if switch.is_a?(Integer) && !$game_switches[switch]
      if data.is_a?(Array) && switch.is_a?(Integer)
        data.each do |trainer|
          addTrainerData(trainer[:name], trainer[:type], trainer[:map], trainer[:event])
        end
      elsif ["A", "B", "C", "D"].include?(switch)
        if data.is_a?(Array)
          Console.echoln_li _INTL("The Self Switch may only be assigned to 1 trainer")
          next
        end
        next if !$game_self_switches[[data[:map], data[:event], switch]]
        addTrainerData(data[:name], data[:type], data[:map], data[:event])
      end
    end
  end

  def addTrainerData(name, type, mapId, eventId)
    gameMap, mapPos, map, event = getTrainerEventData(mapId, eventId)
    return if gameMap.nil?
    eventX, eventY = adjustTrainerPosition(gameMap, map.width, map.height, mapPos[1], mapPos[2], event[1].x, event[1].y)
    @trainerData << {
      name: name,
      type: type,
      mapX: adjustPosX(eventX, true, mapPos[0]),
      mapY: adjustPosY(eventY, true, mapPos[0])
    }
  end

  def getTrainerEventData(mapId, eventId)
    gameMap = GameData::MapMetadata.try_get(mapId)
    return nil if !gameMap
    mapPos = gameMap.town_map_position
    return nil if !@regionData.any? { |region, _| region == mapPos[0] }
    if !mapPos || mapPos.length < 3
      Console.echoln_li _INTL("Game map with ID #{mapId} has either no or an invalid Map Position.")
      return nil
    end
    map = load_data(sprintf("Data/Map%03d.rxdata", mapId))
    if !map
      Console.echoln_li _INTL("No rxdata file found for map #{mapId}")
      return nil
    end
    event = map.events.find { |id, event| event.id == eventId }
    if event.nil?
      Console.echoln_li _INTL("event #{eventId} does not exist on map #{mapId}")
      return nil
    end
    return gameMap, mapPos, map, event
  end

  def adjustTrainerPosition(gameMap, mapWidth, mapHeight, mapPosX, mapPosY, eventX, eventY)
    x = mapPosX
    y = mapPosY
    mapSize = gameMap.town_map_size
    if mapSize && mapSize[0] && mapSize[0] > 0
      sqWidth = mapSize[0]
      sqHeight = (mapSize[1].length.to_f / mapSize[0]).ceil
      x = mapPosX + (eventX * sqWidth / mapWidth).floor if sqWidth > 1
      y = mapPosY + (eventY * sqHeight / mapHeight).floor if sqHeight > 1
    end
    return x, y
  end
end

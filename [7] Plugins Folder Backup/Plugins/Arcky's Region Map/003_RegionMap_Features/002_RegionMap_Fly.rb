class PokemonRegionMap_Scene
  def getFlyIconPositions
    @mapInfo.each do |key, value|
      selFlySpots = Hash.new { |hash, key| hash[key] = [] }
      value[:positions].each do |pos|
        flySpot = pos[:flyspot]
        next if flySpot.empty?
        key = [flySpot[:map], flySpot[:x], flySpot[:y]]
        selFlySpots[key] << [flySpot, pos[:x], pos[:y]]
      end
      selFlySpots.each do |index, spot|
        visited = spot.any? { |map| map[0][:visited] }
        mapData = GameData::MapMetadata.try_get(spot[0][0][:map])
        if !mapData
          Console.echoln_li _INTL("The Game Map '#{spot[0][0][:map]}' does not exist!")
          next
        end
        mapRegion = mapData.town_map_position[0]
        if mapRegion != @playerPos[0] || !ARMSettings::UseRegionConnecting
          visited = canFlyOtherRegion(mapRegion) if visited && mapRegion != @playerPos[0]
        end
        name = visited ? "mapFly" : "mapFlyDis"
        centerX = spot.map { |map| map[1] }.sum.to_f / spot.length
        centerY = spot.map { |map| map[2] }.sum.to_f / spot.length
        original = spot.map { |map| { x: map[1], y: map[2] } }
        result = [centerX, centerY]
        unless result.nil?
          value[:flyicons] << { name: name, x: result[0], y: result[1], originalpos: original }
        end
      end
    end
  end

  def addFlyIconSprites
    if !@spritesMap["FlyIcons"]
      @spritesMap["FlyIcons"] = BitmapSprite.new(@mapWidth, @mapHeight, @viewportMap)
      @spritesMap["FlyIcons"].x = @spritesMap["map"].x
      @spritesMap["FlyIcons"].y = @spritesMap["map"].y
      @spritesMap["FlyIcons"].visible = @mode == 1
    end
    @spritesMap["FlyIcons"].z = 15
    @mapInfo.each do |key, value|
      value[:flyicons].each do |spot|
        next if spot.nil?
        pbDrawImagePositions(
          @spritesMap["FlyIcons"].bitmap,
          [["#{Folder}Icons/Fly/#{spot[:name]}", pointXtoScreenX(spot[:x]), pointYtoScreenY(spot[:y])]]
        )
      end
    end
    @spritesMap["FlyIcons"].visible = @mode == 1
  end

  def getFlyLocationAndConfirm
    @healspot = pbGetHealingSpot(@mapX, @mapY)
    if @healspot && (($PokemonGlobal.visitedMaps[@healspot[0]] && (canFlyOtherRegion(@healspot[3]) || @region == @playerPos[0])) || ($DEBUG && Input.press?(Input::CTRL)))
      name = pbGetMapNameFromId(@healspot[0])
      return confirmMessageMap(_INTL("Would you like to use Fly to go to {1}?", name))
    end
  end

  def canFlyOtherRegion(region = @region, modeCheck = false)
    @mapName = @mapMetadata.real_name if !@mapName
    return false if !ARMSettings::AllowFlyToOtherRegions
    regionName = (@regionName).to_sym
    canFly = ARMSettings::FlyToRegions.dig(regionName)&.include?(region)
    canFly = ARMSettings::LocationFlyToOtherRegion.dig(regionName, @mapName)&.include?(region) if !modeCheck
    return canFly
  end

  def canActivateQuickFly(lastChoiceFly, cursor)
    @visited = getFlyLocations
    return if @visited.empty?
    if enableMode(ARMSettings::CanQuickFly) && Input.trigger?(ARMSettings::QuickFlyButton)
      findChoice = @visited.find_index { |pos| pos[:x] == @mapX && pos[:y] == @mapY }
      lastChoiceFly = findChoice if findChoice
      choice = messageMap(_INTL("Quick Fly: Choose one of the available locations to fly to."),
          (0...@visited.size).to_a.map{ |i| "#{@visited[i][:name]}" }, -1, nil, lastChoiceFly, true) { pbUpdate }
      if choice != -1
        @mapX = @visited[choice][:x]
        @mapY = @visited[choice][:y]
      elsif choice == -1
        @mapX = cursor[:oldX]
        @mapY = cursor[:oldY]
      end
      @sprites["cursor"].x = 8 + (@mapX * ARMSettings::SquareWidth)
      @sprites["cursor"].y = 24 + (@mapY * ARMSettings::SquareHeight)
      @sprites["cursor"].x -= UIBorderWidth if ARMSettings::RegionMapBehindUI
      @sprites["cursor"].y -= UIBorderHeight if ARMSettings::RegionMapBehindUI
      pbGetMapLocation(@mapX, @mapY)
      centerMapOnCursor
    end
    return choice
  end

  def getFlyLocations
    visits = []
    @mapInfo.each do |key, value|
      value[:positions].each do |pos|
        next if pos[:flyspot].empty? || !pos[:flyspot][:visited]
        next if !canFlyOtherRegion(value[:region]) && ((value[:region] != @playerPos[0]) && ARMSettings::UseRegionConnecting)
        sel = { name: value[:mapname], x: pos[:x], y: pos[:y], flyspot: pos[:flyspot] }
        visits << sel unless visits.any? { |visited| visited[:flyspot] == sel[:flyspot] }
      end
    end
    return visits
  end
end

if ARMSettings::QuickTravelInsteadOfFly
  def pbFlyToNewLocation(pkmn = nil, move = :FLY)
    return false if $game_temp.fly_destination.nil?
    pkmn = $player.get_pokemon_with_move(move) if !pkmn
    if !$DEBUG && !pkmn
      $game_temp.fly_destination = nil
      yield if block_given?
      return false
    end
    pbMessage(_INTL("Quick traveling to {1}!", GameData::MapMetadata.get($game_temp.fly_destination[0]).name))
    pbFadeOutIn do
      $game_temp.player_new_map_id    = $game_temp.fly_destination[0]
      $game_temp.player_new_x         = $game_temp.fly_destination[1]
      $game_temp.player_new_y         = $game_temp.fly_destination[2]
      $game_temp.player_new_direction = 2
      $game_temp.fly_destination = nil
      pbDismountBike
      $scene.transfer_player
      $game_map.autoplay
      $game_map.refresh
      yield if block_given?
      pbWait(0.25)
    end
    pbEraseEscapePoint
    return true
  end
end

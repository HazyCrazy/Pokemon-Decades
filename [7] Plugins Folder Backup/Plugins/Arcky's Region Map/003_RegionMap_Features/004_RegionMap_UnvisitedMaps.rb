class PokemonRegionMap_Scene
  def getMapVisited(mapData)
    healSpot = pbGetHealingSpot(mapData[0], mapData[1])
    if healSpot
      if $PokemonGlobal.visitedMaps[healSpot[0]]
        return true
      else
        return false
      end
    else
      return nil
    end
  end

  def addUnvisitedMapSprites
    if !@spritesMap["Visited"]
      @spritesMap["Visited"] = BitmapSprite.new(@mapWidth, @mapHeight, @viewportMap)
      @spritesMap["Visited"].x = @spritesMap["map"].x
      @spritesMap["Visited"].y = @spritesMap["map"].y
      @spritesMap["Visited"].z = 10
    end
    curPos = {}
    @mapInfo.each do |key, value|
      value[:positions].each do |pos|
        next if pos[:image].nil?
        # Position has flyspot? Image already drawn (for this location)? Location is visted?
        next if pos[:flyspot].empty? || curPos[:name] == key && curPos[:image] == pos[:image][:name] || pos[:flyspot][:visited]
        curPos = { name: value[:name], image: pos[:image][:name] }
        image = "#{Folder}Unvisited/#{pos[:image][:name].to_s}"
        # Image exists?
        if !pbResolveBitmap(image)
          Console.echoln_li _INTL("No Unvisited Image found for point '#{value[:realname]}' in PBS file: town_map.txt")
          next
        end
        pbDrawImagePositions(
          @spritesMap["Visited"].bitmap,
          [[image, (pos[:image][:x].to_i * ARMSettings::SquareWidth) , (pos[:image][:y].to_i * ARMSettings::SquareHeight)]]
        )
      end
    end
    curPos.clear
  end

  def pbGetHealingSpot(x, y)
    return nil if !@mapPoints
    @mapPoints.each do |point|
      next if point[0] != x || point[1] != y
      return nil if point[7] && (@wallmap || point[7] <= 0 || !$game_switches[point[7]])
      return (point[4] && point[5] && point[6]) ? [point[4], point[5], point[6], point[9]] : nil
    end
    return nil
  end
end

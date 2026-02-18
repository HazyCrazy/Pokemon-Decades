class PokemonRegionMap_Scene
  def colorCurrentLocation
    addHighlightSprites if !@spritesMap["highlight"]
    return if @curMapLoc.nil?
    curPos = @curMapLoc.gsub(" ", "").to_sym
    highlight = @mapInfo[curPos][:positions].find { |pos| pos[:x] == @mapX && pos[:y] == @mapY}
    return if highlight.nil? || (highlight[:image].nil? && @mode != 1)
    if @mode != 1
      image = highlight[:image]
      mapFolder = getMapFolderName(image)
      imageName = "#{Folder}highlights/#{mapFolder}/#{image[:name]}"
      if !pbResolveBitmap(imageName)
        Console.echoln_li _INTL("No Higlight Image found for point '#{@mapInfo[curPos][:realname].to_s}' in PBS file: town_map.txt")
        return
      end
      pbDrawImagePositions(
        @spritesMap["highlight"].bitmap,
        [["#{Folder}highlights/#{mapFolder}/#{image[:name]}", (image[:x] * ARMSettings::SquareWidth) , (image[:y] * ARMSettings::SquareHeight)]]
      )
    else
      flyicon = @mapInfo[curPos][:flyicons].find { |icon| icon[:originalpos].any? { |pos| pos[:x] == highlight[:x] && pos[:y] == highlight[:y] } }
      return if flyicon.nil? || flyicon[:name] == "mapFlyDis"
      pbDrawImagePositions(
        @spritesMap["highlight"].bitmap,
        [["#{Folder}Icons/Fly/mapFlySel", (flyicon[:x] * ARMSettings::SquareWidth) - 8 , (flyicon[:y] * ARMSettings::SquareHeight) - 8]]
      )
    end
  end

  def addHighlightSprites
    @spritesMap["highlight"] = BitmapSprite.new(@mapWidth, @mapHeight, @viewportMap)
    @spritesMap["highlight"].x = @spritesMap["map"].x
    @spritesMap["highlight"].y = @spritesMap["map"].y
    @spritesMap["highlight"].opacity = convertOpacity(ARMSettings::HighlightOpacity)
    @spritesMap["highlight"].visible = true
    @spritesMap["highlight"].z = 20
  end
end

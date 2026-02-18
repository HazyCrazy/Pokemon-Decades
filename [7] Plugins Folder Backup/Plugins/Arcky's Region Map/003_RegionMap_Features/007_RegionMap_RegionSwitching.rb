class PokemonRegionMap_Scene
  def switchRegionMap
    getAvailableRegions if !@avRegions
    @avRegions = @avRegions.sort_by { |index| index[1] }
    @avRegions = checkConnectedRegions
    if @avRegions.length >= 3
      choice = messageMap(_INTL("Which Region would you like to change to?"),
        @avRegions.map { |mode| "#{mode[0]}" }, -1, nil, @region) { pbUpdate }
      return if choice == -1 || @region == @avRegions[choice][1]
      @region = @avRegions[choice][1]
    else
      return if @avRegions.length <= 1
      @region = @avRegions[0][1] == @region ? @avRegions[1][1] : @avRegions[0][1]
    end
    @choiceMode = 0
    @regionData = nil
    @regionFile = nil
    refreshRegionMap
  end

  def getAvailableRegions
    map = []
    GameData::MapMetadata.each do |gameMap|
      next if gameMap.town_map_position.nil?
      map << [gameMap.id, gameMap.real_name, gameMap.town_map_position] if $PokemonGlobal.visitedMaps[gameMap.id]
    end
    @avRegions = []
    map.each do |id, name, region|
      if GameData::TownMap.exists?(region[0])
        name = GameData::TownMap.get(region[0]).name
      else
        Console.echoln_li _INTL("Game map: #{id}, #{name}: MapPosition = #{region[0]},#{region[1]},#{region[2]} => #{region[0]} is not a valid Region ID.")
        next
      end
      next if @avRegions.include?([name, region[0]])
      @avRegions << [pbGetMessageFromHash(ScriptTexts, name), region[0]]
    end
    # Return avRegions for the pokedex call, normal call is not needed.
    return @avRegions
  end

  def refreshRegionMap
    startFade {pbUpdate}
    pbDisposeSpriteHash(@sprites)
    pbDisposeSpriteHash(@spritesMap)
    @viewport.dispose
    @viewportCursor.dispose
    @viewportMap.dispose
    pbStartScene
    # Recalculate the UI sizes and cursor limits
    @uiWidth = @mapWidth < UIWidth ? @mapWidth : UIWidth
    @uiHeight = @mapHeight < UIHeight ? @mapHeight : UIHeight
    @limitCursor = createCursorLimitObject(16, 8)
  end
end

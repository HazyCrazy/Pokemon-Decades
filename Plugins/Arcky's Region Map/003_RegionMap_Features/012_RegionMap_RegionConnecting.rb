class PokemonRegionMap_Scene
  def changeRegionOnMapPosition
    @regionData.each do |region, data|
      if @mapX.between?(data[:beginX], data[:endX]) && @mapY.between?(data[:beginY], data[:endY])
        @region = region
        @map = GameData::TownMap.get(@region)
        #getCounter #getCounter should only be called once on actual region changing not every frame or movement.
      end
    end
  end

  def checkRegionBorderLimit
    getAvailableRegions
    minX, maxX, minY, maxY = nil, nil, nil, nil
    @regionData.each do |region, data|
      next unless @avRegions.any? { |_, id| id == region }
      minX = minX.nil? ? data[:beginX] : [minX, data[:beginX]].min
      maxX = maxX.nil? ? data[:endX] : [maxX, data[:endX]].max
      minY = minY.nil? ? data[:beginY] : [minY, data[:beginY]].min
      maxY = maxY.nil? ? data[:endY] : [maxY, data[:endY]].max
    end
    mapWidth = ((maxX - minX) + 1) * ARMSettings::SquareWidth if minX && maxX
    mapHeight = ((maxY - minY) + 1) * ARMSettings::SquareHeight if minY && maxY
    zoomLevel = @zoomHash ? @zoomHash[@zoomIndex][:level] : 1
    @regionLimits = {
      :mapStartX => -(minX * ARMSettings::SquareWidth) / zoomLevel,
      :mapMaxX => -(minX * ARMSettings::SquareWidth) / zoomLevel - ((mapWidth / zoomLevel) - UIWidth),
      :mapWidth => mapWidth / zoomLevel,
      :mapStartY => -(minY * ARMSettings::SquareHeight) / zoomLevel,
      :mapMaxY => -(minY * ARMSettings::SquareHeight) / zoomLevel - ((mapHeight / zoomLevel) - UIHeight),
      :mapHeight => mapHeight / zoomLevel
    }
  end

  def checkConnectedRegions
    return @avRegions if @regionData.length == 1  # If only one region exists, return all available regions
    @avRegions.reject { |_, id| @regionData.key?(id) && ARMSettings::UseRegionConnecting }
  end
end

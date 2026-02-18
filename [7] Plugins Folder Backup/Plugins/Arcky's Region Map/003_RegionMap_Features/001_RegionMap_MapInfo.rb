class PokemonRegionMap_Scene
  def getMapObject
    @mapInfo = {}
    if @regionData && ARMSettings::UseRegionConnecting
      @mapPoints = []
      @regionData.each do |id, data|
        next unless @avRegions.any? { |_, region| region == id}
        mapData = GameData::TownMap.get(id)
        mapPoints = mapData.point.map(&:dup).sort_by { |index| [index[2], index[0], index[1]] }
        mapPoints.each do |point|
          point[0] += data[:beginX]
          point[1] += data[:beginY]
          point[9] = id
        end
        @mapPoints.push(mapPoints)
      end
      @mapPoints = @mapPoints.flatten(1)
    else
      # v21.1 and above.
      @mapPoints = @map.point.map(&:dup).sort_by { |index| [index[2], index[0], index[1]] }
    end
    @mapPoints.each do |mapData|
      # skip locations that are invisible
      next if mapData[7] && (mapData[7] <= 0 || !$game_switches[mapData[7]])
      mapKey = mapData[2].gsub(" ", "").to_sym
      #region = @regionData ? : @region
      @mapInfo[mapKey] ||= {
        mapname: replaceMapName(mapData[2].clone),
        realname: mapData[2],
        region: mapData[9],
        positions: [],
        flyicons: []
      }
      name = replaceMapPOI(@mapInfo[mapKey][:mapname], mapData[3].clone) if mapData[3]||nil
      position = {
        poiname: name,
        realpoiname: mapData[3],
        x: mapData[0],
        y: mapData[1],
        flyspot: {},
        image: getImagePosition(@mapPoints.clone, mapData.clone),
      }
      unless position[:image].nil?
        imageName = position[:image][:name]
        posWithSameImage = @mapInfo[mapKey][:positions].select do |p|
          p[:image] && p[:image][:name] == imageName
        end
        minImageCoords = posWithSameImage.map { |p| [p[:image][:x], p[:image][:y]] }.min
        if (minImageCoords)
          minImageCoords = [[position[:image][:x], position[:image][:y]], minImageCoords].min
        end
        posWithSameImage.each do |p|
          p[:image][:x], p[:image][:y] = minImageCoords
        end
      end
      # Add flyspot details
      healSpot = getMapVisited(mapData)
      position[:flyspot] = {
        visited: healSpot,
        map: mapData[4],
        x: mapData[5],
        y: mapData[6]
      } unless healSpot.nil?
      @mapInfo[mapKey][:positions] << position
    end
  end

  def getImagePosition(mapPoints, mapData)
    name = "map#{mapData[8]}"
    if mapData[8].nil?
      Console.echoln_li _INTL("No Highlight Image defined for point '#{mapData[0]}, #{mapData[1]} - #{mapData[2]}' in PBS file: town_map.txt")
      return
    end
    points = mapPoints.select { |point| point[8] == mapData[8] && point[2] == mapData[2] }.map { |point| point [0..1] }
    x = points.min_by { |xy| xy[0] }[0]
    y = points.min_by { |xy| xy[1] }[1]
    if mapData[8] && !mapData[8].include?("Small") && !mapData[8].include?("Route")
      x -= 1
      y -= 1
    end
    return {name: name, x: x, y: y }
  end

  def replaceMapName(name)
    return name if !ARMSettings::NoUnvistedMapInfo
    repName = ARMSettings::UnvisitedMapText
    oriName = pbGetMessageFromHash(LocationNames, name)
    maps = []
    GameData::MapMetadata.each { |gameMap| maps << gameMap if gameMap.name == oriName && (gameMap.announce_location || gameMap.outdoor_map) }
    name = maps.any? { |gameMap| $PokemonGlobal.visitedMaps[gameMap.id] } ? oriName : repName
    return name
  end

  def replaceMapPOI(mapName, poiName)
    return pbGetMessageFromHash(POINames, poiName) if poiName == "" || !ARMSettings::NoUnvistedMapInfo
    findPOI = ARMSettings::LinkPoiToMap.keys.find { |key| key.include?(poiName) }
    if findPOI
      poiName = ARMSettings::UnvisitedPoiText if $PokemonGlobal.visitedMaps[ARMSettings::LinkPoiToMap[findPOI]].nil?
    else
      poiName = ARMSettings::UnvisitedPoiText if mapName == ARMSettings::UnvisitedMapText
    end
    return pbGetMessageFromHash(POINames, poiName)
  end

  def getMapName(x, y)
    district = getDistrictName([@region, adjustPosX(x), adjustPosY(y)], @map)
    if ARMSettings::ProgressCounter && !@globalCounter[:districts].empty? && !ARMSettings::DisableProgressCounterPercentage
      if (district == pbGetMessageFromHash(RegionNames, @map.name.to_s))
        district = "#{district} - #{convertIntegerOrFloat((@globalCounter[:progress].to_f / @globalCounter[:total] * 100).round(1))}%" if @mode == 0
      else
        districtData = @globalCounter[:districts][district]
        district = "#{district} - #{convertIntegerOrFloat((districtData[:progress].to_f / districtData[:total] * 100).round(1))}%" if districtData && districtData[:total] != 0 && @mode == 0
      end
    end
    return district
  end

  def pbGetMapLocation(x, y)
    @curMapLoc = nil
    map = getMapPoints
    return "" if !map
    name = ""
    replaceName = ARMSettings::UnvisitedMapText
    @spritesMap["highlight"].bitmap.clear if @spritesMap["highlight"]
    map.each do |point|
      next if adjustPosX(point[0], true) != x || adjustPosY(point[1]) != y
      return "" if point[7] && (point[7] <= 0 || !$game_switches[point[7]])
      mapPoint = point[2].gsub(" ", "").to_sym
      if @mapInfo.include?(mapPoint)
        @curMapLoc = @mapInfo[mapPoint][:realname].to_s
        name = @mapInfo[mapPoint][:mapname].to_s
        colorCurrentLocation
      end
    end
    updateButtonInfo(name, replaceName) if !ARMSettings::ButtonBoxPosition.nil?
    mapModeSwitchInfo if name == "" || (name == replaceName && !ARMSettings::CanViewInfoUnvisitedMaps)
    return name
  end

  def pbGetMapDetails(x, y)
    @curPOIname = nil
    map = getMapPoints
    return "" if !map
    map.each do |point|
      next if point[0] != x || point[1] != y
      return "" if !point[3] || (point[7] && (@wallmap || point[7] <= 0 || !$game_switches[point[7]]))
      mapPoint = point[2].gsub(" ", "").to_sym
      @mapInfo[mapPoint][:positions].each do |key, value|
        mapdesc = key[:poiname] if key[:x] == point[0] && key[:y] == point[1]
        @curPOIname = key[:realpoiname]
        return mapdesc if mapdesc
      end
    end
    return ""
  end

  def getMapPoints
    return false if !@map.point
    return @map.point
  end
end

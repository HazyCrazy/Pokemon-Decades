class PokemonRegionMap_Scene
  def canSearchLocation(lastChoiceLocation, cursor)
    return if @zoom
    @listMaps = getAllLocations
    return if @listMaps.empty? || (@listMaps.length + 1) <= ARMSettings::MinimumMapsCount
    if enableMode(ARMSettings::CanLocationSearch) && Input.trigger?(ARMSettings::LocationSearchButton) && @previewBox.isHidden
      match = ARMSettings::LinkPoiToMap.find { |_,poi| poi == $game_map.map_id }
      findChoice = @listMaps.find_index { |map| match[0] == map[:name] } if !match.nil?
      findChoice = @listMaps.find_index { |map| @curMapLoc == map[:name] } if !findChoice
      lastChoiceLocation = findChoice if findChoice
      @searchActive = true
      updateButtonInfo if !ARMSettings::ButtonBoxPosition.nil?
      choice = messageMap(_INTL("Choose a Location (press #{convertButtonToString(ARMSettings::OrderSearchButton)} to order the list.)"),
        @listMaps.map { |mapData| mapData[:name] }, -1, nil, lastChoiceLocation, true) { pbUpdate }
      if $resultWindow
        $resultWindow.dispose
        $resultWindow = nil
      end
      if choice.is_a?(String)
        @listMaps = updateLocationList(choice)
      elsif choice.is_a?(Integer)
        if choice != -1
          @mapX = @listMaps[choice][:pos][:x]
          @mapY = @listMaps[choice][:pos][:y]
        else
          @mapX = cursor[:oldX]
          @mapY = cursor[:oldY]
        end
        steps = @zoomHash[@zoomIndex][:steps]
        curCorr = @zoomHash[@zoomIndex][:curCorr]
        @sprites["cursor"].x = 8 + (@mapX * ARMSettings::SquareWidth)
        @sprites["cursor"].y = 24 + (@mapY * ARMSettings::SquareHeight)
        @sprites["cursor"].x -= UIBorderWidth if ARMSettings::RegionMapBehindUI
        @sprites["cursor"].y -= UIBorderHeight if ARMSettings::RegionMapBehindUI
        pbGetMapLocation(@mapX, @mapY)
        centerMapOnCursor
      end
      @searchActive = false
    end
    return choice
  end

  def getAllLocations
    listMaps = []
    unvisited = ARMSettings::IncludeUnvisitedMaps
    @mapInfo.each do |_, map|
      usename = unvisited ? "realpoiname" : "poiname"
      poinames = map[:positions].map { |pos| pos[usename.to_sym] }
      next if map[:mapname] == ARMSettings::UnvisitedMapText && !unvisited
      pos = map[:positions][0]
      usename = unvisited ? "realname" : "mapname"
      listMaps << {name: map[usename.to_sym], :pos => {region: map[:region], x: pos[:x], y: pos[:y] } }
      poiMaps = []
      poinames.each_with_index do |name, index|
        next if (name == ARMSettings::UnvisitedPoiText && !unvisited) || name.nil? || name == "" || poiMaps.any? { |map| map[:name] == name }
        pos = map[:positions][index]
        poiMaps << {name: name, :pos => {region: map[:region], x: pos[:x], y: pos[:y] } }
      end
      listMaps += poiMaps
    end
    return listMaps
  end

  def updateLocationList(term)
    return getAllLocations if term == ""
    @termList = [] if !@termList
    @termList << term
    filtered = @listMaps.select do |location|
      location[:name].downcase.include?(term.downcase)
    end
    if filtered.empty?
      filtered = @listMaps
      text = "No results"
    else
      word = filtered.length > 1 ? "results" : "result"
      text = "#{filtered.length} #{word}"
    end
    unless text == ""
      $resultWindow = Window_AdvancedTextPokemon.new(_INTL(text))
      $resultWindow.resizeToFit($resultWindow.text, Graphics.width)
      $resultWindow.z = 100003
    end
    return filtered
  end
end

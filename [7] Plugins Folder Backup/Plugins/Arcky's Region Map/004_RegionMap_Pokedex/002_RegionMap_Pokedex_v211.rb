#===============================================================================
#
#===============================================================================
if Essentials::VERSION.include?("21")
  class PokemonPokedexInfo_Scene
    UIWidth = Settings::SCREEN_WIDTH - 32
    UIHeight = Settings::SCREEN_HEIGHT - 64
    BehindUI = ARMSettings::RegionMapBehindUI ? [0, 0, 0, 0] : [16, 32, 48, 64]
    ThemePlugin = PluginManager.installed?("Lin's Pokegear Themes")
    Folder = "Graphics/UI/Town Map/"
    FilterFollowUp = ARMSettings::FilterMenuType == "followUp"
    FilterChoice = ARMSettings::FilterMenuType == "choice"
    FilterDefault = ARMSettings::FilterMenuType == "default"

    alias arcky_pbStartScene pbStartScene
    def pbStartScene(*args)
      @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
      @viewport.z = 100000
      @viewportMap = Viewport.new(BehindUI[0], BehindUI[2], (Graphics.width - BehindUI[1]), (Graphics.height - BehindUI[3]))
      @viewportMap.z = 99999
      arcky_pbStartScene(*args)
      setRegionMapGraphic
      @sprites["areahighlight"] = BitmapSprite.new(@sprites["areamap"].bitmap.width, @sprites["areamap"].bitmap.height, @viewportMap)
      @sprites["areaText"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
      pbSetSystemFont(@sprites["areaText"].bitmap)
      makeMapArrows
      scene = PokemonRegionMap_Scene.new(-1, false)
      @avRegions = scene.getAvailableRegions
      refreshAreaVariables
    end

    def setRegionMapGraphic
      @sprites["areamap"].dispose
      @sprites["areamap"] = IconSprite.new(0, 0, @viewportMap)
      @sprites["areamap"].setBitmap("Graphics/UI/Town Map/Regions/#{@mapdata.filename}")
      ARMSettings::RegionMapExtras.each do |hidden|
        next if hidden[0] != @region || hidden[1] <= 0 || !$game_switches[hidden[1]]
        pbDrawImagePositions(
          @sprites["areamap"].bitmap,
          [["Graphics/UI/Town Map/HiddenRegionMaps/#{hidden[4]}",
            hidden[2] * ARMSettings::SquareWidth,
            hidden[3] * ARMSettings::SquareHeight]]
        )
      end
    end 

    def refreshAreaVariables
      mapMetadata = $game_map.metadata
      if !mapMetadata
        Console.echo_error _INTL("There's no mapMetadata for map '#{$game_map.name}' with ID #{$game_map.map_id}. \nAdd it to the map_metadata.txt to fix this error!")
      end
      playerPos = mapMetadata && mapMetadata.town_map_position ? mapMetadata.town_map_position : [0, 0, 0]
      mapSize = mapMetadata.town_map_size
      mapX = playerPos[1]
      mapY = playerPos[2]
      if mapSize && mapSize[0] && mapSize[0].ceil
        sqwidth = mapSize[0]
        sqheight = (mapSize[1].length.to_f / mapSize[0]).ceil
        mapX += ($game_player.x * sqwidth / $game_map.width).floor if sqwidth > 1
        mapY += ($game_player.x * sqheight / $game_map.height).floor if sqheight > 1
      end
      @mapWidth = @sprites["areamap"].bitmap.width
      @mapHeight = @sprites["areamap"].bitmap.height
      @playerX = (-8 + BehindUI[0]) + (ARMSettings::SquareWidth * mapX)
      @playerY = (-8 + BehindUI[1]) + (ARMSettings::SquareHeight * mapY)
      @mapMaxX = -1 * (@mapWidth - (Graphics.width - BehindUI[1]))
      @mapMaxY = -1 * (@mapHeight - (Graphics.height - BehindUI[3]))
      @mapPosX = (UIWidth / 2) - @playerX
      @mapPosY = (UIHeight / 2) - @playerY
      @mapOffsetX = @mapWidth < (Graphics.width - BehindUI[1]) ? ((Graphics.width - BehindUI[1]) - @mapWidth) / 2 : 0
      @mapoffsetY = @mapHeight < (Graphics.height - BehindUI[3]) ? ((Graphics.height - BehindUI[3]) - @mapHeight) / 2 : 0
      pos = @mapPosX < @mapMaxX ? @mapMaxX : @mapPosX
      if @playerX > (Settings::SCREEN_WIDTH / 2) && ((@mapWidth > Graphics.width && ARMSettings::RegionMapBehindUI) || (@mapWidth > UIWidth && !ARMSettings::RegionMapBehindUI))
        @sprites["areamap"].x = pos % ARMSettings::SquareWidth != 0 ? pos + 8 : pos
      else
        @sprites["areamap"].x = @mapOffsetX
      end
      pos = @mapPosY < @mapMaxY ? @mapMaxY : @mapPosY
      if @playerY > (Settings::SCREEN_HEIGHT / 2) && ((@mapHeight > Graphics.height && ARMSettings::RegionMapBehindUI) || (@mapHeight > UIHeight && !ARMSettings::RegionMapBehindUI))
        @sprites["areamap"].y = pos % ARMSettings::SquareHeight != 0 ? pos + 24 : pos
      else
        @sprites["areamap"].y = @mapoffsetY
      end
      @mapX = -(@sprites["areamap"].x / ARMSettings::SquareWidth)
      @mapY = -(@sprites["areamap"].y / ARMSettings::SquareHeight)
      @initialLocData, @initialEncTypeData = getEncounterMapAreas
      @locData = @initialLocData.clone
      @encTypeData = @initialEncTypeData.clone
      @initialSpecies = @species.clone
      @filterMenuActive = false 
    end 

    def getEncounterMapAreas
      mapIDs = []
      mapNames = []
      typesToMaps = Hash.new { |h, k| h[k] = [] }
      mapEncounterTypes = []
      GameData::Encounter.each_of_version($PokemonGlobal.encounter_version) do |enc_data|
        # Check if Encounter belongs to current encounter table.
        next if !pbFindEncounter(enc_data.types, @species)
        map_metadata = GameData::MapMetadata.try_get(enc_data.map)
        # Check if map is found and if there's no hideEncounter flag.
        next if !map_metadata || map_metadata.has_flag?("HideEncountersInPokedex")
        mapPos = map_metadata.town_map_position
        # Check if map has a mapPosition defined.
        if mapPos.nil?
          Console.echoln_li _INTL("#{map_metadata.name} has no mapPosition defined in map_metadata.txt PBS file.")
          next 
        end 
        # Check if map is from current Region.
        next if mapPos[0] != @region 
        # Check map name and check if no other maps had already this name.
        mapName = ARMSettings::LinkPoiToMap.key(map_metadata.id) || map_metadata.name 
        next if mapNames.include?(mapName)
        mapNames.push(mapName)
        mapIDs.push(enc_data.map)

        encounterTypes = enc_data.types.select {|type, species| species.any? {|specie| specie[1] == @species } }

        encounterTypes.each_key do |type|
          typesToMaps[type] << enc_data.map 
        end
      end 
      #mapEncounterTypes = typesToMaps.map { |type, maps| { type => maps } }
      return mapIDs, typesToMaps
    end 

    def pbFindEncounter(enc_types, species)
      return false if !enc_types
      enc_types.each_value do |slots|
        next if !slots
        slots.each { |slot| return true if GameData::Species.get(slot[1]).species == species }
      end
      return false
    end

    # Returns a 1D array of values corresponding to points on the Town Map. Each
    # value is true or false.
    def pbGetEncounterPoints
      if @species != @initialSpecies
        @initialLocData, @initialEncTypeData = getEncounterMapAreas
        @locData = @initialLocData.clone
        @encTypeData = @initialEncTypeData.clone
        @initialSpecies = @species.clone
        @locChoice = nil
        @encTypeChoice = nil
        @filterChoice = nil 
      end 
      # Determine all visible points on the Town Map (i.e. only ones with a
      # defined point in town_map.txt, and which either have no Self Switch
      # controlling their visibility or whose Self Switch is ON)
      visible_points = []
      @mapdata.point.each do |loc|
        next if loc[7] && !$game_switches[loc[7]]   # Point is not visible
        visible_points.push([loc[0], loc[1]])
      end
      # Find all points with a visible area for @species
      town_map_width = @mapWidth / ARMSettings::SquareWidth
      ret = []
      GameData::Encounter.each_of_version($PokemonGlobal.encounter_version) do |enc_data|
        # Check if Map is in filter. When generating @locData, several checks have already been done.
        next if !@locData.include?(enc_data.map) || !@encTypeData.any? { |type, maps | maps.include?(enc_data.map) }
        map_metadata = GameData::MapMetadata.try_get(enc_data.map)
        mappos = map_metadata.town_map_position
        # Get the size and shape of the map in the Town Map
        map_size = map_metadata.town_map_size
        map_width = 1
        map_height = 1
        map_shape = "1"
        if map_size && map_size[0] && map_size[0] > 0   # Map occupies multiple points
          map_width = map_size[0]
          map_shape = map_size[1]
          map_height = (map_shape.length.to_f / map_width).ceil
        end
        # Mark each visible point covered by the map as containing the area
        map_width.times do |i|
          map_height.times do |j|
            next if map_shape[i + (j * map_width), 1].to_i == 0   # Point isn't part of map
            next if !visible_points.include?([mappos[1] + i, mappos[2] + j])   # Point isn't visible
            ret[mappos[1] + i + ((mappos[2] + j) * town_map_width)] = true
          end
        end
      end
      return ret
    end

    # Called once when switching to Area Page or changing species
    def drawPageArea
      @sprites["areamap"].visible       = true
      @sprites["areahighlight"].visible = true
      @sprites["areaoverlay"].visible   = true
      @sprites["background"].setBitmap(_INTL("Graphics/UI/Pokedex/bg_area"))
      overlay = @sprites["areaText"].bitmap
      overlay.clear
      base   = Color.new(88, 88, 80)
      shadow = Color.new(168, 184, 184)
      @sprites["areahighlight"].bitmap.clear
      @sprites["areahighlight"].x = @sprites["areamap"].x
      @sprites["areahighlight"].y = @sprites["areamap"].y
      @sprites["areahighlight"].z = 20
      @noArea = false
      # Get all points to be shown as places where @species can be encountered
      # v3.3.0 mapIDs is an array of all game maps, this @species can be encountered.
      points = pbGetEncounterPoints
      # Draw coloured squares on each point of the Town Map with a nest
      pointcolor   = Color.new(0, 248, 248)
      pointcolorhl = Color.new(192, 248, 248)
      sqwidth = ARMSettings::SquareWidth
      sqheight = ARMSettings::SquareHeight
      town_map_width = @mapWidth / sqwidth
      points.length.times do |j|
        next if !points[j]
        x = (j % town_map_width) * sqwidth
        y = (j / town_map_width) * sqheight
        @sprites["areahighlight"].bitmap.fill_rect(x, y, sqwidth, sqheight, pointcolor)
        if j - town_map_width < 0 || !points[j - town_map_width]
          @sprites["areahighlight"].bitmap.fill_rect(x, y - 2, sqwidth, 2, pointcolorhl)
        end
        if j + town_map_width >= points.length || !points[j + town_map_width]
          @sprites["areahighlight"].bitmap.fill_rect(x, y + sqheight, sqwidth, 2, pointcolorhl)
        end
        if j % town_map_width == 0 || !points[j - 1]
          @sprites["areahighlight"].bitmap.fill_rect(x - 2, y, 2, sqheight, pointcolorhl)
        end
        if (j + 1) % town_map_width == 0 || !points[j + 1]
          @sprites["areahighlight"].bitmap.fill_rect(x + sqwidth, y, 2, sqheight, pointcolorhl)
        end
      end

      # Set the text
      textpos = []
      if points.length == 0
        pbDrawImagePositions(
          overlay,
          [[sprintf("Graphics/UI/Pokedex/overlay_areanone"), 108, 188]]
        )
        #textpos.push([_INTL("Area unknown"), Graphics.width / 2, (Graphics.height / 2) + 6, 2, base, shadow])
		textpos.push([_INTL("Evolutions are Level Scaled"), Graphics.width / 2, (Graphics.height / 2) + 6, 2, base, shadow])
        @noArea = true
      end
      textpos.push([@mapdata.name, 414, 50, 2, base, shadow])
      textpos.push([_INTL("{1}'s area [C] Move", GameData::Species.get(@species).name),
                    Graphics.width / 2, 358, 2, base, shadow])
      pbDrawTextPositions(overlay, textpos)
    end

    def makeMapArrows
      @sprites["mapArrowUp"] = AnimatedSprite.new(findUsableUI("mapArrowUp"), 8, 28, 40, 2, @viewport)
      @sprites["mapArrowUp"].x = Graphics.width / 2
      @sprites["mapArrowUp"].y = 32
      @sprites["mapArrowUp"].play
      @sprites["mapArrowUp"].visible = false
      @sprites["mapArrowDown"] = AnimatedSprite.new(findUsableUI("mapArrowDown"), 8, 28, 40, 2, @viewport)
      @sprites["mapArrowDown"].x = Graphics.width / 2
      @sprites["mapArrowDown"].y = Graphics.height - 60
      @sprites["mapArrowDown"].play
      @sprites["mapArrowDown"].visible = false
      @sprites["mapArrowLeft"] = AnimatedSprite.new(findUsableUI("mapArrowLeft"), 8, 40, 28, 2, @viewport)
      @sprites["mapArrowLeft"].y = Graphics.height / 2
      @sprites["mapArrowLeft"].play
      @sprites["mapArrowLeft"].visible = false
      @sprites["mapArrowRight"] = AnimatedSprite.new(findUsableUI("mapArrowRight"), 8, 40, 28, 2, @viewport)
      @sprites["mapArrowRight"].x = Graphics.width - 40
      @sprites["mapArrowRight"].y = Graphics.height / 2
      @sprites["mapArrowRight"].play
      @sprites["mapArrowRight"].visible = false
    end

    def findUsableUI(image)
      if ThemePlugin
        # Use Current set Theme's UI Graphics
        return "#{Folder}UI/#{$PokemonSystem.pokegear}/#{image}"
      else
        folderUI = "UI/Region#{@region}/"
        bitmap = pbResolveBitmap("#{Folder}#{folderUI}#{image}")
        if bitmap && ARMSettings::ChangeUIOnRegion
          # Use UI Graphics for the Current Region.
          return "#{Folder}#{folderUI}#{image}"
        else
          # Use Default UI Graphics.
          return "#{Folder}UI/Default/#{image}"
        end
      end
    end

    def showChoiceFilterMenu
      @lastFilterChoice = 0 if !@filterChoice
      @filterChoice = messageMap(_INTL("Which filter would you like to use?"),
        ["Location", "Encounter Type"], -1, nil, @lastFilterChoice) {pbUpdate}
      if @filterChoice == 0
        showLocFilterMenu
      elsif @filterChoice == 1
        showEncTypeFilterMenu
      else 
        @filterChoice = @lastFilterChoice
      end 
      @lastFilterChoice = @filterChoice
    end 

    def showLocFilterMenu
      return if @initialLocData.length == 0 || @filterMenuActive
      @filterMenuActive = true 
      @lastLocChoice = 0 if !@locChoice
      options = []
      if FilterFollowUp
        data = @encTypeData.values.map { |value| value }.flatten
      else 
        data = @initialLocData.clone
      end 
      data.each do |map| 
        mapData = GameData::MapMetadata.try_get(map)
        options.push(ARMSettings::LinkPoiToMap.key(mapData.id) || mapData.name)
      end 
      @locChoice = messageMap(_INTL("Choose a Location to Filter the Encounter Area."),
      options.insert(0, "All").uniq, -1, nil, @lastLocChoice, true, "loc") {pbUpdate}
      @filterMenuActive = false
      if @locChoice == -1
        @locChoice = @lastLocChoice 
        showChoiceFilterMenu if FilterChoice
      elsif @locChoice > 0 
        @locData = [data[@locChoice - 1]]
      elsif @locChoice == 0
        resetLocFilter
      end
      @lastLocChoice = @locChoice
      drawPageArea
    end 

    def resetLocFilter 
      @locData = @initialLocData.clone 
    end

    def handleLocChoice 
      if FilterFollowUp
        data = @encTypeData.values.map { |value| value }.flatten
      else 
        resetEncTypeFilter
        data = @initialLocData.clone
      end 
      if @locChoice != 0
        @locData = [data[@locChoice - 1]]
      else 
        resetLocFilter
      end
      drawPageArea
    end

    def showEncTypeFilterMenu
      return if @initialEncTypeData.length == 0 || @filterMenuActive
      @filterMenuActive = true 
      @lastEncTypeChoice = 0 if !@encTypeChoice
      options = @initialEncTypeData.keys.map { |type| ARMSettings::EncounterTypes[type] || type.to_s }
      @encTypeChoice = messageMap(_INTL("Choose an Encounter Type to Filter the Encounter Area."),
      options.insert(0, "All").uniq, -1, nil, @lastEncTypeChoice, true, "encType") {pbUpdate}
      @filterMenuActive = false
      if @encTypeChoice == -1
        @encTypeChoice = @lastEncTypeChoice 
        showChoiceFilterMenu if FilterChoice
      elsif @encTypeChoice > 0
        key = @initialEncTypeData.keys[@encTypeChoice - 1]
        @encTypeData = { key => @initialEncTypeData[key] }
      elsif @encTypeData == 0
        resetEncTypeFilter
      end 

      if FilterFollowUp
        @lastLocChoice = 0 if @lastEncTypeChoice != @encTypeChoice && @encTypeChoice != -1
      end 
      @lastEncTypeChoice = @encTypeChoice
      drawPageArea
      showLocFilterMenu if FilterFollowUp
    end 

    def resetEncTypeFilter
      @encTypeData = @initialEncTypeData.clone
    end 

    def handleEncTypeChoice
      resetLocFilter
      if @encTypeChoice != 0
        key = @initialEncTypeData.keys[@encTypeChoice - 1]
        @encTypeData = { key => @initialEncTypeData[key] }
      else 
        resetEncTypeFilter
      end 
      drawPageArea
    end 

    def switchAreaRegion
      echoln("we do this maybe?")
      @avRegions = @avRegions.sort_by { |index| index[1] }
      if @avRegions.length >= 3
        choice = messageMap(_INTL("Which Region would you like to change to?"),
          @avRegions.map {|mode| "#{mode[0]}"}, -1, nil, @region) { pbUpdate }
        return if choice == -1 || @region == @avRegions[choice][1]
        @region = @avRegions[choice][1]
      else 
        return if @avRegions.length <= 1
        @region = @avRegions[0][1] == @region ? @avRegions[1][1] : @avRegions[0][1]
      end 
      @mapdata = GameData::TownMap.get(@region)
      setRegionMapGraphic
      refreshAreaVariables
      drawPageArea
    end 

    if PluginManager.installed?("Modular UI Scenes")
      alias _region_map_pbUpdate pbUpdate 
      def pbUpdate
        _region_map_pbUpdate
        if ARMSettings::ToggleLocFilterButton && Input.trigger?(ARMSettings::ToggleLocFilterButton) && !@filterMenuActive && !FilterFollowUp
          if @page_id === :page_area
            if FilterDefault
              showLocFilterMenu
            elsif FilterChoice
              showChoiceFilterMenu 
            end 
          end 
        elsif ARMSettings::ToggleEncTypeFilterButton && Input.trigger?(ARMSettings::ToggleEncTypeFilterButton) && (FilterDefault || FilterFollowUp) && !@filterMenuActive
          if @page_id == :page_area
            showEncTypeFilterMenu
          end 
        elsif ARMSettings::ToggleRegionSwitchButton && Input.trigger?(ARMSettings::ToggleRegionSwitchButton)
          if @page_id === :page_area
            switchAreaRegion
          end 
        end
      end  

      def pbRegionMapControls
        return if @noArea
        new_x = @sprites["areamap"].x
        new_y = @sprites["areamap"].y
        ox = oy = 0
        distPerFrame = System.uptime
        pbPlayCursorSE
        loop do
          Graphics.update
          Input.update
          pbUpdate
          @sprites["mapArrowUp"].visible = -(@mapY * 16) < 0
          @sprites["mapArrowDown"].visible = -(@mapY * 16) > @mapMaxY
          @sprites["mapArrowLeft"].visible = -(@mapX * 16) < 0
          @sprites["mapArrowRight"].visible = -(@mapX * 16) > @mapMaxX
          if ox != 0 || oy != 0
            if ox != 0
              @sprites["areamap"].x = lerp(new_x - ox, new_x, 0.1, distPerFrame, System.uptime)
              @sprites["areahighlight"].x = @sprites["areamap"].x
              ox = 0 if @sprites["areamap"].x == new_x
            end
            if oy != 0
              @sprites["areamap"].y = lerp(new_y - oy, new_y, 0.1, distPerFrame, System.uptime)
              @sprites["areahighlight"].y = @sprites["areamap"].y
              oy = 0 if @sprites["areamap"].y == new_y
            end
            next if ox != 0 || oy != 0
          end
          if Input.trigger?(Input::BACK)
            @sprites["mapArrowUp"].visible = false
            @sprites["mapArrowDown"].visible = false
            @sprites["mapArrowLeft"].visible = false
            @sprites["mapArrowRight"].visible = false
            pbPlayCancelSE
            break
          else
            case Input.dir8
            when 1, 2, 3
              if -(@mapY * 16) > @mapMaxY
                @mapY += 1
                oy = -1 * ARMSettings::SquareHeight
                new_y = @sprites["areamap"].y + oy
                distPerFrame = System.uptime
              end
            when 7, 8, 9
              if -(@mapY * 16) < 0
                @mapY -= 1
                oy = 1 * ARMSettings::SquareHeight
                new_y = @sprites["areamap"].y + oy
                distPerFrame = System.uptime
              end
            end
            case Input.dir8
            when 1, 4, 7
              if -(@mapX * 16) < 0
                @mapX -= 1
                ox = 1 * ARMSettings::SquareWidth
                new_x = @sprites["areamap"].x + ox
                distPerFrame = System.uptime
              end
            when 3, 6, 9
              if -(@mapX * 16) > @mapMaxX
                @mapX += 1
                ox = -1 * ARMSettings::SquareWidth
                new_x = @sprites["areamap"].x + ox
                distPerFrame = System.uptime
              end
            end
          end
        end
      end

      alias _region_map_pbPageCustomUse pbPageCustomUse
      def pbPageCustomUse(page_id)
        if page_id == :page_area
          pbRegionMapControls
          return true
        end
        return _region_map_pbPageCustomUse(page_id)
      end
    else
      def pbScene
        Pokemon.play_cry(@species, @form)
        @mapMovement = false
        new_x = 0
        new_y = 0
        ox = 0
        oy = 0
        distPerFrame = System.uptime
        loop do
          Graphics.update
          Input.update
          pbUpdate
          dorefresh = false
          if ox != 0 || oy != 0
            if ox != 0
              @sprites["areamap"].x = lerp(new_x - ox, new_x, 0.1, distPerFrame, System.uptime)
              @sprites["areahighlight"].x = @sprites["areamap"].x
              ox = 0 if @sprites["areamap"].x == new_x
            end
            if oy != 0
              @sprites["areamap"].y = lerp(new_y - oy, new_y, 0.1, distPerFrame, System.uptime)
              @sprites["areahighlight"].y = @sprites["areamap"].y
              oy = 0 if @sprites["areamap"].y == new_y
            end
            next if ox != 0 || oy != 0
          end
          if @mapMovement
            @sprites["mapArrowUp"].visible = -(@mapY * 16) < 0 ? true : false
            @sprites["mapArrowDown"].visible = -(@mapY * 16) > @mapMaxY ? true : false
            @sprites["mapArrowLeft"].visible = -(@mapX * 16) < 0 ? true : false
            @sprites["mapArrowRight"].visible = -(@mapX * 16) > @mapMaxX ? true : false
          end
          if Input.trigger?(Input::ACTION)
            pbSEStop
            Pokemon.play_cry(@species, @form) if @page == 1
          elsif Input.trigger?(Input::BACK)
            if @mapMovement
              @mapMovement = false
              @sprites["mapArrowUp"].visible = false
              @sprites["mapArrowDown"].visible = false
              @sprites["mapArrowLeft"].visible = false
              @sprites["mapArrowRight"].visible = false
            else
              pbPlayCloseMenuSE
              break
            end
          elsif Input.trigger?(Input::SPECIAL)
            pbPokedexEntryTextScroll if @page == 1
          elsif ARMSettings::ToggleLocFilterButton && Input.trigger?(ARMSettings::ToggleLocFilterButton) && !@filterMenuActive && !FilterFollowUp
            if @page == 2 
              if FilterDefault
                showLocFilterMenu 
              elsif filterChoice
                showChoiceFilterMenu
              end 
            end 
          elsif ARMSettings::ToggleEncTypeFilterButton && Input.trigger?(ARMSettings::ToggleEncTypeFilterButton) && (FilterDefault || FilterFollowUp) && !@filterMenuActive
            showEncTypeFilterMenu if @page == 2
          elsif ARMSettings::ToggleRegionSwitchButton && Input.trigger?(ARMSettings::ToggleRegionSwitchButton)
            switchAreaRegion if @page == 2
          elsif Input.trigger?(Input::USE)
            case @page
            when 1   # Info
              @show_battled_count = !@show_battled_count
              @mapMovement = false
              dorefresh = true
            when 2   # Area
              if !@noArea && (@sprites["areamap"].bitmap.width > 480 || @sprites["areamap"].bitmap.height > 320)
                pbPlayCursorSE
                @mapMovement = true
              end
              dorefresh = true
            when 3   # Forms
              if @available.length > 1
                pbPlayDecisionSE
                @mapMovement = false
                pbChooseForm
                dorefresh = true
              end
            end
          elsif !@mapMovement
            if Input.trigger?(Input::UP)
              oldindex = @index
              pbGoToPrevious
              if @index != oldindex
                pbUpdateDummyPokemon
                @available = pbGetAvailableForms
                pbSEStop
                (@page == 1) ? Pokemon.play_cry(@species, @form) : pbPlayCursorSE
                dorefresh = true
              end
            elsif Input.trigger?(Input::DOWN)
              oldindex = @index
              pbGoToNext
              if @index != oldindex
                pbUpdateDummyPokemon
                @available = pbGetAvailableForms
                pbSEStop
                (@page == 1) ? Pokemon.play_cry(@species, @form) : pbPlayCursorSE
                dorefresh = true
              end
            elsif Input.trigger?(Input::LEFT)
              oldpage = @page
              @page -= 1
              @page = 1 if @page < 1
              @page = 3 if @page > 3
              if @page != oldpage
                pbPlayCursorSE
                dorefresh = true
              end
            elsif Input.trigger?(Input::RIGHT)
              oldpage = @page
              @page += 1
              @page = 1 if @page < 1
              @page = 3 if @page > 3
              if @page != oldpage
                pbPlayCursorSE
                dorefresh = true
              end
            end
          else
            case Input.dir8
            when 1, 2, 3
              if -(@mapY * 16) > @mapMaxY
                @mapY += 1
                oy = -1 * ARMSettings::SquareHeight
                new_y = @sprites["areamap"].y + oy
                distPerFrame = System.uptime
              end
            when 7, 8, 9
              if -(@mapY * 16) < 0
                @mapY -= 1
                oy = 1 * ARMSettings::SquareHeight
                new_y = @sprites["areamap"].y + oy
                distPerFrame = System.uptime
              end
            end
            case Input.dir8
            when 1, 4, 7
              if -(@mapX * 16) < 0
                @mapX -= 1
                ox = 1 * ARMSettings::SquareWidth
                new_x = @sprites["areamap"].x + ox
                distPerFrame = System.uptime
              end
            when 3, 6, 9
              if -(@mapX * 16) > @mapMaxX
                @mapX += 1
                ox = -1 * ARMSettings::SquareWidth
                new_x = @sprites["areamap"].x + ox
                distPerFrame = System.uptime
              end
            end
          end
          if dorefresh
            drawPage(@page)
          end
        end
        return @index
      end
    end

    alias arcky_drawPage drawPage
    def drawPage(page)
      @sprites["areaText"].bitmap.clear if @sprites["areaText"]
      arcky_drawPage(page)
    end
  end
end
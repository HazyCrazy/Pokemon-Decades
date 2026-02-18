class PokemonRegionMap_Scene
  def addBerryIconSprites
    return if !BerryPlugin || !allowShowingBerries
    if !@spritesMap["BerryIcons"]
      @berryIcons = {}
      berryPlants = []
      @regionData.each do |region,_|
        berryPlants << pbForceUpdateAllBerryPlants(mapOnly: true, region: region, returnArray: true)
      end
      berryPlants = berryPlants.flatten(1)
      settings = Settings::BERRIES_ON_MAP_SHOW_PRIORITY
      berryPlants.each do |plant|
        img = 999
        settings.each_with_index { |set, i|
            if set == :ReadyToPick && plant.grown? then img = i
            elsif set == :HasPests && plant.pests then img = i
            elsif set == :NeedsWater && plant.moisture_stage == 0 then img = i
            elsif set == :HasWeeds && plant.weeds then img = i
            end
            break if img != 999
          }
          if @berryIcons[plant.town_map_location]
            @berryIcons[plant.town_map_location] = img if img < @berryIcons[plant.town_map_location]
          else
            @berryIcons[plant.town_map_location] = img
          end
      end
      @spritesMap["BerryIcons"] = BitmapSprite.new(@mapWidth, @mapHeight, @viewportMap)
      @spritesMap["BerryIcons"].x = @spritesMap["map"].x
      @spritesMap["BerryIcons"].y = @spritesMap["map"].y
      @spritesMap["BerryIcons"].z = 59
      @spritesMap["BerryIcons"].visible = @mode == 3
    end
    @berryIcons.each { |key, value|
      conversion = {:NeedsWater => "mapBerryDry", :ReadyToPick => "mapBerryReady",
              :HasPests => "mapBerryPest", :HasWeeds => "mapBerryWeeds"}[settings[value]] || "mapBerry"
      pbDrawImagePositions(@spritesMap["BerryIcons"].bitmap,
        [[pbGetBerryMapIcon(conversion), pointXtoScreenX(adjustPosX(key[1], true, key[0])), pointYtoScreenY(adjustPosY(key[2], true, key[0]))]])
    }
  end

  def pbGetBerriesAtMapPoint(region, x = nil, y = nil)
    array = []
    $PokemonGlobal.eventvars.each do |info|
      plant = info[1]
      next if !plant.is_a?(BerryPlantData) || plant.town_map_location.nil? || !plant.planted? || plant.town_map_location[0] != region ||
              (!x.nil? && plant.town_map_location[1] != adjustPosX(x)) || (!y.nil? && plant.town_map_location[2] != adjustPosY(y))
      array.push(plant)
    end
    return array
  end

  def getBerryName(x, y)
    berries = pbGetBerriesAtMapPoint(@region, x, y)
    value = ""
    unless berries.empty?
      count = berries.length
      if count >= 1
        @berryPlants = { }
        berryCounter = Hash.new { |h, k| h[k] = { amount: 0, stages: Hash.new { |h, k| h[k] = 0 } } }
        berries.each do |berry|
          berryCounter[berry.berry_id][:amount] += 1
          case berry.growth_stage
          when 1
            stage = "Planted"
          when 2
            stage = "Sprouted"
          when 3
            stage = "Grown"
          else
            stage = "Flowered"
          end
          berryCounter[berry.berry_id][:stages][stage] += 1
        end
        stageOrder = ["Planted", "Sprouted", "Grown", "Flowered"]
        @berryPlants = berryCounter.transform_values do |info|
          {
            amount: info[:amount],
            stages: info[:stages].sort_by { |s, _| stageOrder.index(s) }.to_h
          }
        end
        if @berryPlants.length >= 2
          value = "#{count} Berries planted"
        else
          value = getBerryNameAndAmount(berries[0].berry_id)
        end
      end
    end
    updateButtonInfo if !ARMSettings::ButtonBoxPosition.nil?
    @sprites["modeName"].bitmap.clear
    mapModeSwitchInfo if value == ""
    return value
  end

  def getBerryNameAndAmount(berry)
    amount = @berryPlants[berry][:amount]
    if amount >= 2
      value = "#{amount} #{GameData::Item.get(berry).portion_name_plural}"
    else
      value = "#{amount} #{GameData::Item.get(berry).portion_name}"
    end
    return value
  end

  def showBerryInformation(lastChoiceBerries)
    berryInfo = @berryIcons.select { |coords, _| coords[0..2] == [@region, adjustPosX(@mapX), adjustPosY(@mapY)] }
    return choice = -1 if @berryPlants.nil? || berryInfo.empty?
    input, berry, choice = getCurrentBerryInfo(lastChoiceBerries)
    @oldLineCount = @lineCount
    if input && berry
      berryInfoText = []
      name = getBerryNameAndAmount(berry)
      @sprites["mapbottom"].previewName = ["#{name}", @sprites["previewBox"].width]
      if !@sprites["locationText"]
        @sprites["locationText"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
        pbSetSystemFont(@sprites["locationText"].bitmap)
        @sprites["locationText"].visible = false
      end
      @sprites["locationText"].bitmap.clear
      base = (ARMSettings::BerryInfoTextBase).to_rgb15
      shadow = (ARMSettings::BerryInfoTextShadow).to_rgb15
      selBerry = @berryPlants[berry]
      amount = selBerry[:amount]
      selBerry[:stages].each do |stage,value|
        text = "<c2=#{base}#{shadow}>#{stage}: #{value}"
        berryInfoText << text
      end
      x = 16
      y = 8
      lineHeight = ARMSettings::PreviewLineHeight
      berryInfoText.each do |text|
        chars = getFormattedText(@sprites["locationText"].bitmap, x, y, 272, -1, text, lineHeight)
        y += (1 + chars.count { |item| item[0] == "\n" }) * lineHeight
        drawFormattedChars(@sprites["locationText"].bitmap, chars)
        @lineCount = (y / lineHeight)
      end
      @lineCount = ARMSettings::MaxBerryLines if @lineCount > ARMSettings::MaxBerryLines
      getPreviewBox
      @sprites["locationText"].x = Graphics.width - (@sprites["previewBox"].width + UIBorderWidth + ARMSettings::BerryInfoTextOffsetX)
      @sprites["locationText"].y = UIBorderHeight + ARMSettings::BerryInfoTextOffsetY
      @sprites["locationText"].z = 28
    end
    return choice
  end

  def getCurrentBerryInfo(lastChoiceBerries)
    if @berryPlants.length >= 2
      choice = messageMap(_INTL("Which berry would you like to view info about?"),
      @berryPlants.keys.map { |berry|
        next "#{pbGetMessageFromHash(ScriptTexts, getBerryNameAndAmount(berry))}"
      }, -1, nil, lastChoiceBerries) { pbUpdate }
      input = choice != -1
      berry = @berryPlants.keys[choice]
    else
      input = 0
      berry = @berryPlants.keys[0]
    end
    return input, berry, choice
  end

  def checkBerriesOnPosition(multiple = false)
    unless multiple
      return !pbGetBerriesAtMapPoint(@region, @mapX, @mapY).empty? && pbGetBerriesAtMapPoint(@region, @mapX, @mapY).length == 1
    else
      return !pbGetBerriesAtMapPoint(@region, @mapX, @mapY).empty? && pbGetBerriesAtMapPoint(@region, @mapX, @mapY).length > 1
    end
  end
end

class PokemonRegionMap_Scene
  def centerMapOnCursor
    centerMapX
    centerMapY
    addArrowSprites if !@sprites["upArrow"]
    updateArrows
  end

  def centerMapX
    posX, center = getCenterMapX(@sprites["cursor"].x, true)
    @mapOffsetX = @mapWidth < (Graphics.width - BehindUI[1]) ? ((Graphics.width - BehindUI[1]) - @mapWidth) / 2 : 0
    if center
      @spritesMap.each do |key, value|
        @spritesMap[key].x = posX
      end
    else
      @spritesMap.each do |key, value|
        @spritesMap[key].x = @mapOffsetX
      end
    end
    @sprites["cursor"].x += @spritesMap["map"].x
  end

  def getCenterMapX(cursorX, getCenter = false)
    center = cursorX > (Settings::SCREEN_WIDTH / 2) && ((@mapWidth > Graphics.width && ARMSettings::RegionMapBehindUI) || (@mapWidth > UIWidth && !ARMSettings::RegionMapBehindUI))
    steps = @zoomHash[@zoomIndex][:steps]
    curCorr = @zoomHash[@zoomIndex][:curCorr]
    mapStartX = @regionLimits[:mapStartX]
    mapMaxX = @regionLimits[:mapMaxX]
    mapMaxX += UIBorderWidth * 2 if ARMSettings::RegionMapBehindUI
    mapPosX = (UIWidth / 2) - cursorX
    pos = [[mapPosX, mapMaxX].max, mapStartX].min
    posX = pos % steps != 0 ? pos + curCorr : pos
    if getCenter
      return posX, center
    elsif center
      return posX
    else
      return 0
    end
  end

  def centerMapY
    posY, center = getCenterMapY(@sprites["cursor"].y, true)
    @mapOffsetY = @mapHeight < (Graphics.height - BehindUI[3]) ? ((Graphics.height - BehindUI[3]) - @mapHeight) / 2 : 0
    if center
      @spritesMap.each do |key, value|
        @spritesMap[key].y = posY
      end
    else
      @spritesMap.each do |key, value|
        @spritesMap[key].y = @mapOffsetY
      end
    end
    @sprites["cursor"].y += @spritesMap["map"].y
  end

  def getCenterMapY(cursorY, getCenter = false)
    center = cursorY > (Settings::SCREEN_HEIGHT / 2) && ((@mapHeight > Graphics.height && ARMSettings::RegionMapBehindUI) || (@mapHeight > UIHeight && !ARMSettings::RegionMapBehindUI))
    steps = @zoomHash[@zoomIndex][:steps]
    curCorr = @zoomHash[@zoomIndex][:curCorr]
    mapStartY = @regionLimits[:mapStartY]
    mapMaxY = @regionLimits[:mapMaxY]
    mapMaxY += UIBorderHeight * 2 if ARMSettings::RegionMapBehindUI
    mapPosY = (UIHeight / 2) - cursorY
    pos = [[mapPosY, mapMaxY].max, mapStartY].min
    posY = pos % steps != 0 ? pos + curCorr : pos
    if getCenter
      return posY, center
    elsif center
      return posY
    else
      return 0
    end
  end

  def addArrowSprites
    @sprites["upArrow"] = AnimatedSprite.new(findUsableUI("mapArrowUp"), 8, 28, 40, 2, @viewport)
    @sprites["upArrow"].x = (Graphics.width / 2) - 14
    @sprites["upArrow"].y = (BoxTopLeft && (@sprites["buttonPreview"].x + @sprites["buttonPreview"].width) > (Graphics.width / 2)) || (BoxTopRight && @sprites["buttonPreview"].x < (Graphics.width / 2)) ? @sprites["buttonPreview"].height : 16
    @sprites["upArrow"].z = 35
    @sprites["upArrow"].play
    @sprites["downArrow"] = AnimatedSprite.new(findUsableUI("mapArrowDown"), 8, 28, 40, 2, @viewport)
    @sprites["downArrow"].x = (Graphics.width / 2) - 14
    @sprites["downArrow"].y = (BoxBottomLeft && (@sprites["buttonPreview"].x + @sprites["buttonPreview"].width) > (Graphics.width / 2)) || (BoxBottomRight && @sprites["buttonPreview"].x < (Graphics.width / 2)) ? (Graphics.height - (44 + @sprites["buttonPreview"].height)) : (Graphics.height - 60)
    @sprites["downArrow"].z = 35
    @sprites["downArrow"].play
    @sprites["leftArrow"] = AnimatedSprite.new(findUsableUI("mapArrowLeft"), 8, 40, 28, 2, @viewport)
    @sprites["leftArrow"].y = (Graphics.height / 2) - 14
    @sprites["leftArrow"].z = 35
    @sprites["leftArrow"].play
    @sprites["rightArrow"] = AnimatedSprite.new(findUsableUI("mapArrowRight"), 8, 40, 28, 2, @viewport)
    @sprites["rightArrow"].x = Graphics.width - 40
    @sprites["rightArrow"].y = (Graphics.height / 2) - 14
    @sprites["rightArrow"].z = 35
    @sprites["rightArrow"].play
  end

  def updateArrows
    @sprites["upArrow"].visible = @spritesMap["map"].y < @regionLimits[:mapStartY] && !@previewBox.isExtShown
    @sprites["downArrow"].visible = @spritesMap["map"].y > @regionLimits[:mapMaxY] && !@previewBox.isExtShown
    @sprites["leftArrow"].visible =  @spritesMap["map"].x < @regionLimits[:mapStartX] - @cursorCorrZoom && !@previewBox.isExtShown
    @sprites["rightArrow"].visible = @spritesMap["map"].x > @regionLimits[:mapMaxX] + @cursorCorrZoom && !@previewBox.isExtShown
  end

  def updateMapRange
    offset = ARMSettings::CursorMapOffset ? 16 * @zoomLevel : 0
    mapOffsetX = ARMSettings::RegionMapBehindUI ? UIBorderWidth / @zoomHash[@zoomIndex][:steps].ceil : 0
    #mapOffsetX += 1 if @zoomHash[@zoomIndex][:level] == 0.5 && ARMSettings::CursorMapOffset
    mapOffsetY = ARMSettings::RegionMapBehindUI ? UIBorderHeight / @zoomHash[@zoomIndex][:steps].ceil : 0
    @mapRange = {
      :minX => (((@spritesMap["map"].x - offset) / (ARMSettings::SquareWidth * @zoomLevel)).abs).ceil + mapOffsetX,
      :maxX => (((@spritesMap["map"].x + offset).abs + (UIWidth - (ARMSettings::SquareWidth * @zoomLevel))) / (ARMSettings::SquareWidth * @zoomLevel)).ceil + mapOffsetX,
      :minY => (((@spritesMap["map"].y - offset) / (ARMSettings::SquareHeight * @zoomLevel)).abs).ceil + mapOffsetY,
      :maxY => (((@spritesMap["map"].y + offset).abs + (UIHeight - (ARMSettings::SquareHeight * @zoomLevel))) / (ARMSettings::SquareHeight * @zoomLevel)).ceil + mapOffsetY
    }
    if ARMSettings::CursorMapOffset
      @mapRange[:maxX] -= 2 if @spritesMap["map"].x == 0
      @mapRange[:maxY] -= 2 if @spritesMap["map"].y == 0
    end
  end

  def createCursorLimitObject(offset, curCorr, level = 1.0)
    cursorOffset = ARMSettings::CursorMapOffset ? offset : 0
    width = @sprites["cursor"].bitmap.width / level # 64, 32, 16
    height = @sprites["cursor"].bitmap.height / level # 64, 32, 16
    @mapOffsetX = 0 if @mapOffsetX.nil?
    @mapOffsetY = 0 if @mapOffsetY.nil?
    minX =  if !ARMSettings::RegionMapBehindUI
              (UIBorderWidth + @mapOffsetX + cursorOffset) - curCorr # ok
            else
              if @mapWidth > UIWidth
                (UIBorderWidth + cursorOffset) - curCorr # ok
              else
                @mapOffsetX + cursorOffset
              end
            end
    maxX =  if !ARMSettings::RegionMapBehindUI
              (UIWidth + UIBorderWidth) - ((width / 2) + @mapOffsetX + cursorOffset)
            else
              if @mapWidth > UIWidth
                (UIWidth + UIBorderWidth) - ((width / 2) + cursorOffset)
              else
                UIWidth - (@mapOffsetX + cursorOffset)
              end
            end
    minY = if !ARMSettings::RegionMapBehindUI
              (UIBorderHeight + @mapOffsetY + cursorOffset) - curCorr
            else
              if @mapHeight > UIHeight
                (UIBorderHeight + cursorOffset) - curCorr
              else
                @mapOffsetY + cursorOffset
              end
            end
    maxY = if !ARMSettings::RegionMapBehindUI
              (UIHeight + UIBorderHeight) - (height + @mapOffsetY + cursorOffset)
            else
              if @mapHeight > UIHeight
                (UIHeight + UIBorderHeight) - (height + cursorOffset)
              else
                (UIHeight + UIBorderHeight) - (@mapOffsetY + cursorOffset)
              end
            end
    return {
      minX: minX,
      maxX: maxX,
      minY: minY,
      maxY: maxY
    }
  end
end

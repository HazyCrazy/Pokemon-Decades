class PokemonRegionMap_Scene
  def getMouseInput(ox, oy, mox, moy, lastChoiceQuest, lastChoiceBerries, lastChoiceTrainers)
    return if !ARMSettings::UseMouseOnRegionMap || previewAnimation
    mousePos = Mouse.getMousePos
    if mousePos
      convertMouseToMapPos(mousePos)
      @oldPosX ||= mousePos[0]
      @oldPosY ||= mousePos[1]
      if mousePos.none? { |pos| pos < 0 } #checks if the mouse position is not negative.
        if Input.press?(ARMSettings::MouseButtonMoveMap)
          if @previewBox.isShown || @previewBox.isUpdated
            @previewBox.hideIt
            hidePreviewBox
          elsif @previewBox.isExtHidden
            @previewBox.showIt
          else
            if mousePos[0] < @oldPosX
              mox = -1 if @spritesMap["map"].x > @regionLimits[:mapMaxX]
              ox = -1 if @sprites["cursor"].x > @limitCursor[:minX] && mox == -1
            elsif mousePos[0] > @oldPosX
              mox = 1 if @spritesMap["map"].x < @regionLimits[:mapStartX] - @cursorCorrZoom
              ox = 1 if @sprites["cursor"].x < @limitCursor[:maxX] && mox == 1
            end
            if mousePos[1] < @oldPosY
              moy = -1 if @spritesMap["map"].y > @regionLimits[:mapMaxY]
              oy = -1  if @sprites["cursor"].y > @limitCursor[:minY] && moy == -1
            elsif mousePos[1] > @oldPosY
              moy = 1 if @spritesMap["map"].y < @regionLimits[:mapStartY]
              oy = 1  if @sprites["cursor"].y < @limitCursor[:maxY] && moy == 1
            end
          end
        elsif Input.trigger?(ARMSettings::MouseButtonSelectLocation)
          if !(mousePos[0] == @mapX && mousePos[1] == @mapY)
            if !mousePos[0].between?(@mapRange[:minX], @mapRange[:maxX])
              if mousePos[0] < @mapRange[:minX]
                mousePos[0] = @mapRange[:minX]
              elsif mousePos[0] > @mapRange[:maxX]
                mousePos[0] = @mapRange[:maxX]
              end
            end
            if !mousePos[1].between?(@mapRange[:minY], @mapRange[:maxY])
              if mousePos[1] < @mapRange[:minY]
                mousePos[1] = @mapRange[:minY]
              elsif mousePos[1] > @mapRange[:maxY]
                mousePos[1] = @mapRange[:maxY]
              end
            end
            @mapX = mousePos[0]
            @mapY = mousePos[1]
            @sprites["cursor"].x = (8 + (@mapX * (ARMSettings::SquareWidth * @zoomLevel))) + @spritesMap["map"].x
            @sprites["cursor"].x -= UIBorderWidth if ARMSettings::RegionMapBehindUI
            @sprites["cursor"].x -= 8 if @zoomLevel == 2.0
            @sprites["cursor"].x += 4 if @zoomLevel == 0.5
            @sprites["cursor"].y = (24 + (@mapY * (ARMSettings::SquareHeight * @zoomLevel))) + @spritesMap["map"].y
            @sprites["cursor"].y -= UIBorderHeight if ARMSettings::RegionMapBehindUI
            @sprites["cursor"].y -= 8 if @zoomLevel == 2.0
            @sprites["cursor"].y += 4 if @zoomLevel == 0.5
            if @previewBox.isShown
              if @mode == 0 && @curLocName == pbGetMapLocation(@mapX, @mapY)
                @previewBox.updateIt
                updatePreviewBox
              else
                @previewBox.hideIt
                hidePreviewBox
              end
            end
          else
            case @mode
            when 0
              if ARMSettings::UseLocationPreview && getLocationInfo
                if @previewBox.isShown && !@cannotExtPreview
                  showExtendedPreview
                else
                  @previewBox.showIt
                  showPreviewBox
                end
              end
            when 2
              if QuestPlugin
                choice = showQuestInformation(lastChoiceQuest)
                if choice != -1
                  showPreviewBox
                  lastChoiceQuest = choice
                end
              end
            when 3
              if BerryPlugin
                choice = showBerryInformation(lastChoiceBerries)
                if choice != -1
                  showPreviewBox
                  lastChoiceBerries = choice
                end
              end
            end
          end
        end
      end
      @oldPosX = mousePos[0] if mox == 0
      @oldPosY = mousePos[1] if moy == 0
    end
    return ox, oy, mox, moy, lastChoiceQuest, lastChoiceBerries, lastChoiceTrainers
  end

  def convertMouseToMapPos(mousePos)
    mousePos[0] -= @spritesMap["map"].x
    mousePos[0] -= UIBorderWidth if !ARMSettings::RegionMapBehindUI
    mousePos[1] -= @spritesMap["map"].y
    mousePos[1] -= UIBorderHeight if !ARMSettings::RegionMapBehindUI
    mousePos[0] /= (ARMSettings::SquareWidth * @zoomLevel).round
    mousePos[1] /= (ARMSettings::SquareHeight * @zoomLevel).round
    return mousePos
  end
end

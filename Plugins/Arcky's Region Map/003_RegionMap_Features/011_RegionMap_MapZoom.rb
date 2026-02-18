class PokemonRegionMap_Scene
  def getZoomLevels
    @zoomIndex = 1
    offset = ARMSettings::CursorMapOffset ? 1 : 0
    @zoomHash = {
      0 => {
        :enabled => !((@mapWidth < UIWidth) || (@mapHeight < UIHeight)),
        :level => 0.5, #steps 32px
        :steps => 32,
        :curCorr => 16,
        :limits => createCursorLimitObject(32, 16, 0.5),
        :map => {
          :minX => (UIBorderWidth.to_f / 32).ceil + offset,
          :maxX => ((@mapWidth / 16) - 1) - (UIBorderWidth.to_f / 32).ceil - offset,
          :minY => (UIBorderHeight.to_f / 32).ceil + offset,
          :maxY => ((@mapHeight / 16) - 1) - (UIBorderHeight.to_f / 32).ceil - offset
        }
      },
      1 => {
        :enabled => true,
        :level => 1.0, #steps 16px
        :steps => 16,
        :curCorr => 8,
        :limits => createCursorLimitObject(16, 8, 1.0),
        :map => {
          :minX => (UIBorderWidth.to_f / 16).ceil + offset,
          :maxX => ((@mapWidth / 16) - 1) - (UIBorderWidth.to_f / 16).ceil - offset,
          :minY => (UIBorderHeight.to_f / 16).ceil + offset,
          :maxY => ((@mapHeight / 16) - 1) - (UIBorderHeight.to_f / 16).ceil - offset
        }
      },
      2 => {
        :enabled => (@mapWidth >= UIWidth * 2.0) && (@mapHeight >= UIHeight * 2.0),
        :level => 2.0, #steps 8px
        :steps => 8,
        :curCorr => 4,
        :limits => createCursorLimitObject(8, 4, 2.0),
        :map => {
          :minX => (UIBorderWidth.to_f / 8).ceil + offset,
          :maxX => ((@mapWidth / 16) - 1) - (UIBorderWidth.to_f / 8).ceil - offset,
          :minY => (UIBorderHeight.to_f / 8).ceil + offset,
          :maxY => ((@mapHeight / 16) - 1) - (UIBorderHeight.to_f / 8).ceil - offset
        }
      },
    }
    @cursorCorrZoom = @zoomHash[@zoomIndex][:level] == 0.5 && ARMSettings::RegionMapBehindUI ? @zoomHash[@zoomIndex][:steps] / 2 : 0
  end

  def getZoomValues
    @limitCursor = @zoomHash[@zoomIndex][:limits]
    @cursorCorrZoom = @zoomHash[@zoomIndex][:level] == 0.5 && ARMSettings::RegionMapBehindUI ? @zoomHash[@zoomIndex][:steps] / 2 : 0
    if ARMSettings::RegionMapBehindUI
      if @mapX < @zoomHash[@zoomIndex][:map][:minX]
        @mapX = @zoomHash[@zoomIndex][:map][:minX]
      elsif @mapX > @zoomHash[@zoomIndex][:map][:maxX]
        @mapX = @zoomHash[@zoomIndex][:map][:maxX]
      end
      if @mapY < @zoomHash[@zoomIndex][:map][:minY]
        @mapY = @zoomHash[@zoomIndex][:map][:minY]
      elsif @mapY > @zoomHash[@zoomIndex][:map][:maxY]
        @mapY = @zoomHash[@zoomIndex][:map][:maxY]
      end
    end
    @mapWidth = @spritesMap["map"].bitmap.width
    @mapHeight = @spritesMap["map"].bitmap.height
    checkRegionBorderLimit
    @mapWidth /= @zoomHash[@zoomIndex][:level]
    @mapHeight /= @zoomHash[@zoomIndex][:level]
    @zoomLevel = 1.to_f / @zoomHash[@zoomIndex][:level]
    steps = @zoomHash[@zoomIndex][:steps]
    curCorr = @zoomHash[@zoomIndex][:curCorr]
    cursorX = ((-curCorr + BehindUI[0]) + steps * @mapX)
    cursorY = ((-curCorr + BehindUI[2]) + steps * @mapY)
    checkRegionBorderLimit
    posX = getCenterMapX(cursorX)
    posY = getCenterMapY(cursorY)
    @ZoomValues = {
      :begin => {
        :cursor => {
          :x => @sprites["cursor"].x,
          :y => @sprites["cursor"].y,
          :zoom => @sprites["cursor"].zoom_x
        },
        :map => {
          :zoom => @spritesMap["map"].zoom_x,
          :x => @spritesMap["map"].x,
          :y => @spritesMap["map"].y
        }
      },
      :end => {
        :cursor => {
          :x => cursorX - @cursorCorrZoom + posX,
          :y => cursorY + posY,
          :zoom => @zoomLevel
        },
        :map => {
          :zoom => @zoomLevel,
          :x => posX - @cursorCorrZoom,
          :y => posY
        }
      }
    }
    mapModeSwitchInfo
    @zoomSpeed = ARMSettings::ZoomSpeed.to_f / 500
    @distPerFrame = System.uptime
  end
end

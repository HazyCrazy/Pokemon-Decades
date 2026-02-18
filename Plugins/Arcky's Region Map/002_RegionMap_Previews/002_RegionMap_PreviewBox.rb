class PokemonRegionMap_Scene
  def getPreviewName(x, y)
    return getQuestName(x, y) if @mode == 2
    return getBerryName(x, y) if @mode == 3
    return getRoamingName(x, y) if @mode == 4
    return getTrainerName(x, y) if @mode == 5
  end

  def getPreviewBox
    # Initialize previewBox if it doesn't exist
    if !@sprites["previewBox"]
      @sprites["previewBox"] = IconSprite.new(0, 0, @viewport)
      @sprites["previewBox"].z = 27
      @sprites["previewBox"].visible = false
    end

    # Initialize previewBoxOld if it doesn't exist
    if !@sprites["previewBoxOld"]
      @sprites["previewBoxOld"] = IconSprite.new(0, 0, @viewport)
      @sprites["previewBoxOld"].z = 28
      @sprites["previewBoxOld"].visible = false
    end

    # Return early if the mode is 1 or 4 (no updates required)
    return if @mode == 1 || @mode == 4 || @mode == 5

    # Update the preview box with the new bitmap
    @sprites["previewBox"].setBitmap(findUsableUI("#{getPreviewGraphic}#{@lineCount}"))

    # Update the preview width if the mode is 2 or 3
    @previewWidth = @sprites["previewBox"].width if @mode == 2 || @mode == 3
  end

  def getPreviewGraphic
    if @mode == 0
      preview = "LocationPreview/mapLocBox#{@useAlt}"
      @sprites["previewBox"].x = @sprites["previewBoxOld"].x = 16
    else
      @lineCount = 2 if @lineCount == 1
      preview = "QuestPreview/mapQuestBox" if @mode == 2
      preview = "BerryPreview/mapBerryBox" if @mode == 3
      @sprites["previewBox"].x = @sprites["previewBoxOld"].x = Graphics.width - (16 + @sprites["previewBox"].width)
    end
    return preview
  end

  def showPreviewBox
    return if @lineCount == 0 || @previewBox.isShown || previewAnimation
    if WeatherPlugin
      if BoxTopLeft
        @sprites["weatherPreview"].y = 54
        @sprites["weatherIcon"].y = 68
      else
        @sprites["weatherPreview"].y = 22
        @sprites["weatherIcon"].y = 36
      end
    end
    @sprites["previewBox"].visible = true
    @sprites["locationText"].visible = true
    if @mode == 0
      @sprites["locationDash"].visible = true
      @sprites["locationIcon"].visible = true
    end
    getPreviewWeather
    height = @sprites["previewBox"].height
    previewY, nameY, arrowY = changePreviewBoxAndArrow(height)
    oldPreviewY = oldNameY = 0
    if @mode == 0
      @sprites["previewBox"].y = Graphics.height - 32
      if BoxBottomLeft || BoxBottomRight
        oldPreviewY = @sprites["buttonPreview"].y
        oldNameY = @sprites["buttonName"].y
      end
      @previewValues = {
        :begin => {
          :box => Graphics.height - 32,
          :text => Graphics.height - 32,
          :dash => Graphics.height - 32,
          :icon => Graphics.height - 32,
          :preview => oldPreviewY,
          :name => oldNameY,
          :arrow => (BoxBottomLeft && (@sprites["buttonPreview"].x + @sprites["buttonPreview"].width) > (Graphics.width / 2)) || (BoxBottomRight && @sprites["buttonPreview"].x < (Graphics.width / 2)) ? (Graphics.height - (44 + @sprites["buttonPreview"].height)) : (Graphics.height - 60),
          :weather1 => WeatherPlugin ? @sprites["weatherPreview"].y - @sprites["weatherPreview"].height : 0,
          :weather2 => WeatherPlugin ? @sprites["weatherIcon"].y - @sprites["weatherPreview"].height : 0,
          :opacity => 0
        },
        :end => {
          :box => (Graphics.height - 32) - height,
          :text => Graphics.height - (@totalHeight + UIBorderHeight),
          :dash => Graphics.height - (@totalHeight + UIBorderHeight),
          :icon => Graphics.height - (@totalHeight + UIBorderHeight),
          :preview => previewY,
          :name => nameY,
          :arrow => arrowY,
          :weather1 => WeatherPlugin ? @sprites["weatherPreview"].y : 0,
          :weather2 => WeatherPlugin ? @sprites["weatherIcon"].y : 0,
          :opacity => 255
        }
      }
    elsif @mode == 2 || @mode == 3
      @sprites["previewBox"].y = 32 - @sprites["previewBox"].height
      if BoxTopRight
        oldPreviewY = @sprites["buttonPreview"].y
        oldNameY = @sprites["buttonName"].y
      end
      @previewValues = {
        :begin => {
          :box => 32 - @sprites["previewBox"].height,
          :text => 32 - @sprites["previewBox"].height,
          :preview => oldPreviewY,
          :name => oldNameY,
          :arrow => (BoxTopLeft && (@sprites["buttonPreview"].x + @sprites["buttonPreview"].width) > (Graphics.width / 2)) || (BoxTopRight && @sprites["buttonPreview"].x < (Graphics.width / 2)) ? @sprites["buttonPreview"].height : 16,
          :opacity => 0
        },
        :end => {
          :box => 32,
          :text => 32,
          :preview => previewY,
          :name => nameY,
          :arrow => arrowY,
          :opacity => 255
        }
      }
    end
    @previewBox.showAnim
    @animDistPerFrame = System.uptime
  end

  def updatePreviewBox
    return if @previewBox.isHidden || previewAnimation
    getPreviewWeather
    getLocationInfo if @mode == 0
    @sprites["previewBoxOld"].setBitmap(findUsableUI("#{getPreviewGraphic}#{@oldLineCount}"))
    oldHeight = @sprites["previewBoxOld"].height
    newHeight = @sprites["previewBox"].height
    @sprites["previewBoxOld"].visible = oldHeight != newHeight
    @sprites["previewBoxOld"].opacity = 255
    oldPreviewY, oldNameY, oldArrowY = changePreviewBoxAndArrow(oldHeight)
    previewY, nameY, arrowY = changePreviewBoxAndArrow(newHeight)
    if @mode == 0
      @previewValues = {
        :begin => {
          :box => (Graphics.height - 32) - oldHeight,
          :text => Graphics.height - (@oldTotalHeight + UIBorderHeight),
          :dash => Graphics.height - (@oldTotalHeight + UIBorderHeight),
          :icon => Graphics.height - (@oldTotalHeight + UIBorderHeight),
          :preview => oldPreviewY,
          :name => oldNameY,
          :arrow => oldArrowY,
          :weather1 => WeatherPlugin ? @sprites["weatherPreview"].y : 0,
          :weather2 => WeatherPlugin ? @sprites["weatherIcon"].y : 0,
          :opacity => 255
        },
        :end => {
          :box => (Graphics.height - 32) - newHeight,
          :text => Graphics.height - (@totalHeight + UIBorderHeight),
          :dash => Graphics.height - (@totalHeight + UIBorderHeight),
          :icon => Graphics.height - (@totalHeight + UIBorderHeight),
          :preview => previewY,
          :name => nameY,
          :arrow => arrowY,
          :weather1 => WeatherPlugin ? @sprites["weatherPreview"].y : 0,
          :weather2 => WeatherPlugin ? @sprites["weatherIcon"].y : 0,
          :opacity => 0
        }
      }
    elsif @mode == 2 || @mode == 3
      @previewValues = {
        :begin => {
          :box => 32 - (newHeight - oldHeight),
          :text => 32 - (newHeight - oldHeight),
          :preview => oldPreviewY,
          :name => oldNameY,
          :arrow => oldArrowY,
          :opacity => 255
        },
        :end => {
          :box => 32,
          :text => 32,
          :preview => previewY,
          :name => nameY,
          :arrow => arrowY,
          :opacity => 0
        }
      }
    end
    @previewBox.updateAnim
    @animDistPerFrame = System.uptime
  end

  def hidePreviewBox
    return false if !@previewBox.canHide || previewAnimation
    height = @sprites["previewBox"].height
    previewY, nameY, arrowY = changePreviewBoxAndArrow(height)
    oldPreviewY = oldNameY = 0
    textPos = getTextPosition
    if @mode == 0
      if BoxBottomLeft || BoxBottomRight
        oldPreviewY = previewY
        previewY = textPos[1]
        oldNameY = nameY
        nameY = 0
      end
      @previewValues = {
        :begin => {
          :box => (Graphics.height - 32) - height,
          :text => Graphics.height - (@totalHeight + UIBorderHeight),
          :dash => Graphics.height - (@totalHeight + UIBorderHeight),
          :icon => Graphics.height - (@totalHeight + UIBorderHeight),
          :preview => oldPreviewY,
          :name => oldNameY,
          :arrow => arrowY,
          :weather1 => WeatherPlugin ? @sprites["weatherPreview"].y : 0,
          :weather2 => WeatherPlugin ? @sprites["weatherIcon"].y : 0,
          :opacity => 255
        },
        :end => {
          :box => Graphics.height - 32,
          :text => Graphics.height - 32,
          :dash => Graphics.height - 32,
          :icon => Graphics.height - 32,
          :preview => previewY,
          :name => nameY,
          :arrow => (BoxBottomLeft && (@sprites["buttonPreview"].x + @sprites["buttonPreview"].width) > (Graphics.width / 2)) || (BoxBottomRight && @sprites["buttonPreview"].x < (Graphics.width / 2)) ? (Graphics.height - (44 + @sprites["buttonPreview"].height)) : (Graphics.height - 60),
          :weather1 => WeatherPlugin ? @sprites["weatherPreview"].y - @sprites["weatherPreview"].height : 0,
          :weather2 => WeatherPlugin ? @sprites["weatherIcon"].y - @sprites["weatherPreview"].height : 0,
          :opacity => 255
        }
      }
    elsif @mode == 2 || @mode == 3
      if BoxTopRight
        oldPreviewY = previewY
        previewY = textPos[1]
        oldNameY = nameY
        nameY = 0
      end
      @previewValues = {
        :begin => {
          :box => 32,
          :text => 32,
          :preview => oldPreviewY,
          :name => oldNameY,
          :arrow => arrowY,
          :opacity => 0
        },
        :end => {
          :box => 32 - @sprites["previewBox"].height,
          :text => 32 - @sprites["previewBox"].height,
          :preview => previewY,
          :name => nameY,
          :arrow => (BoxTopLeft && (@sprites["buttonPreview"].x + @sprites["buttonPreview"].width) > (Graphics.width / 2)) || (BoxTopRight && @sprites["buttonPreview"].x < (Graphics.width / 2)) ? @sprites["buttonPreview"].height : 16,
          :opacity => 255
        }
      }
    end
    @previewBox.hideAnim
    @animDistPerFrame = System.uptime
  end

  def changePreviewBoxAndArrow(height)
    previewWidthBiggerButtonX = @sprites["previewBox"].width > @sprites["buttonPreview"].x
    halfScreenWidth = Graphics.width / 2
    previewWidthHalfScreenSize = @sprites["previewBox"].width > halfScreenWidth
    previewWidthDownArrowX = @sprites["previewBox"].width > @sprites["downArrow"].x if @sprites["downArrow"].visible
    previewXUpArrowX = @sprites["previewBox"].x < @sprites["upArrow"].x if @sprites["upArrow"].visible
    buttonXDownArrowX = @sprites["buttonPreview"].x > @sprites["downArrow"].x if @sprites["downArrow"].visible
    buttonWidthDownArrowX = @sprites["buttonPreview"].width > (@sprites["downArrow"].x + 14) if @sprites["downArrow"].visible
    buttonXHalfScreenSize = @sprites["buttonPreview"].x < halfScreenWidth
    previewY = nameY = arrowY = 0
    if @mode == 0
      arrowY = (Graphics.height - 60) - height if previewWidthDownArrowX
      if BoxBottomLeft
        previewY = (Graphics.height - (22 + @sprites["buttonPreview"].height)) - height
        nameY = -height
        if previewWidthHalfScreenSize && previewWidthDownArrowX && buttonWidthDownArrowX
          arrowY = (Graphics.height - (44 + @sprites["buttonPreview"].height)) - height
        end
      elsif BoxBottomRight
        if previewWidthBiggerButtonX
          previewY = (Graphics.height - (22 + @sprites["buttonPreview"].height)) - height
          nameY = -height
        end
        if previewWidthHalfScreenSize && !(previewWidthDownArrowX && buttonXDownArrowX)
          arrowY = (Graphics.height - (44 + @sprites["buttonPreview"].height)) - height
        end
      end
    elsif @mode == 2 || @mode == 3
      arrowY = 16 + height if previewXUpArrowX
      arrowY = @sprites["buttonPreview"].height + height if buttonXHalfScreenSize && BoxTopRight
      if BoxTopRight
        previewY = 22 + height
        nameY = height
      end
    end
    return previewY, nameY, arrowY
  end

  def animatePreviewBox
    @sprites["previewBox"].y = lerp(@previewValues[:begin][:box], @previewValues[:end][:box], 0.2, @animDistPerFrame, System.uptime)
    @sprites["locationText"].y = lerp(@previewValues[:begin][:text], @previewValues[:end][:text], 0.2, @animDistPerFrame, System.uptime)
    if WeatherPlugin
      if @sprites["weatherPreview"].visible == true && @mode == 0
        @sprites["weatherPreview"].y = lerp(@previewValues[:begin][:weather1], @previewValues[:end][:weather1], 0.2, @animDistPerFrame, System.uptime)
        @sprites["weatherIcon"].y = lerp(@previewValues[:begin][:weather2], @previewValues[:end][:weather2], 0.2, @animDistPerFrame, System.uptime)
      end
    end
    if @mode == 0
      @sprites["locationIcon"].y = lerp(@previewValues[:begin][:icon], @previewValues[:end][:icon], 0.2, @animDistPerFrame, System.uptime)
      @sprites["locationDash"].y = lerp(@previewValues[:begin][:dash], @previewValues[:end][:dash], 0.2, @animDistPerFrame, System.uptime)
    end
    if @previewBox.isUpdateAnim
      @sprites["previewBoxOld"].opacity = lerp(@previewValues[:begin][:opacity], @previewValues[:end][:opacity], 0.2, @animDistPerFrame, System.uptime)
      @sprites["previewBoxOld"].y = lerp(@previewValues[:begin][:box], @previewValues[:end][:box], 0.2, @animDistPerFrame, System.uptime)
    else
      @sprites["locationText"].opacity = lerp(@previewValues[:begin][:opacity], @previewValues[:end][:opacity], 0.2, @animDistPerFrame, System.uptime)
      if @mode == 0
        @sprites["locationIcon"].opacity = lerp(@previewValues[:begin][:opacity], @previewValues[:end][:opacity], 0.2, @animDistPerFrame, System.uptime)
        @sprites["locationDash"].opacity = lerp(@previewValues[:begin][:opacity], @previewValues[:end][:opacity], 0.2, @animDistPerFrame, System.uptime)
      end
    end
    unless @previewValues[:end][:preview] == 0 && @previewValues[:end][:name] == 0
      @sprites["buttonPreview"].y = lerp(@previewValues[:begin][:preview], @previewValues[:end][:preview], 0.2, @animDistPerFrame, System.uptime)
      @sprites["buttonName"].y = lerp(@previewValues[:begin][:name], @previewValues[:end][:name], 0.2, @animDistPerFrame, System.uptime)
    end
    unless @previewValues[:end][:arrow] == 0
      if @mode == 0
        @sprites["downArrow"].y = lerp(@previewValues[:begin][:arrow], @previewValues[:end][:arrow], 0.2, @animDistPerFrame, System.uptime)
      elsif (@mode == 2 || @mode == 3)
        @sprites["upArrow"].y = lerp(@previewValues[:begin][:arrow], @previewValues[:end][:arrow], 0.2, @animDistPerFrame, System.uptime)
      end
    end
    if @sprites["previewBox"].y == @previewValues[:end][:box]
      if @previewBox.isShowAnim
        @previewBox.shown
      elsif @previewBox.isUpdateAnim
        @sprites["previewBoxOld"].visible = false
        @previewBox.shown
      elsif @previewBox.isHideAnim
        @previewBox.hidden
        @sprites["previewBox"].visible = false
        @sprites["locationText"].bitmap.clear if @sprites["locationText"]
        if @mode == 0
          if @locationIcon
            @sprites["locationIcon"].bitmap.clear
            @sprites["locationIcon"].visible = false
          end
          if @locationDash
            @sprites["locationDash"].bitmap.clear
            @sprites["locationDash"].visible = false
          end
          @locationIcon = false
          @locationDash = false
        end
        clearPreviewBox
        if @switchMode
          switchMapMode
          @switchMode = false
        end
      end
    end
  end

  def clearPreviewBox
    return if @sprites["previewBox"].visible == false
    @sprites["locationText"].bitmap.clear if @sprites["locationText"]
    @sprites["modeName"].visible = true
  end

  def previewAnimation
    return @previewBox.isShowAnim || @previewBox.isUpdateAnim || @previewBox.isHideAnim
  end
end

class PreviewState
  def initialize
    @state = :hidden
  end

  def state
    @state
  end

  def showIt
    @state = :show
  end

  def showAnim
    @state = :showing
  end

  def shown
    @state = :shown
  end

  def hideIt
    @state = :hide
  end

  def hideAnim
    @state = :hiding
  end

  def hidden
    @state = :hidden
  end

  def updateIt
    @state = :update
  end

  def updateAnim
    @state = :updating
  end

  def updated
    @state = :updated
  end

  def isShowAnim
    return @state == :showing
  end

  def isUpdateAnim
    return @state == :updating
  end

  def isHideAnim
    return @state == :hiding
  end

  def isShown
    return @state == :shown
  end

  def isUpdated
    return @state == :updated
  end

  def isHidden
    return @state == :hidden
  end

  def canShow
    return @state == :show
  end

  def canHide
    return @state == :hide
  end

  def canUpdate
    return @state == :update
  end

  def isExtShown
    return @state == :extShown
  end

  def isExtHidden
    return @state == :extHidden
  end

  def extShow
    @state = :extShown
  end

  def extHide
    @state = :extHidden
  end
end

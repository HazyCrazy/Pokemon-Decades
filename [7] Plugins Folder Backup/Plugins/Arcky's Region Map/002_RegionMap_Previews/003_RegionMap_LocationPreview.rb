class PokemonRegionMap_Scene
  def getLocationInfo
    # Generate Sprites if they don't exist
    if !@sprites["locationText"]
      @sprites["locationText"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
      pbSetSystemFont(@sprites["locationText"].bitmap)
      @sprites["locationText"].visible = false
    end
    if !@sprites["locationIcon"]
      @sprites["locationIcon"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
      @sprites["locationIcon"].z = 28
      @sprites["locationIcon"].visible = false
    end
    if !@sprites["locationDash"]
      @sprites["locationDash"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
      @sprites["locationDash"].z = 28
      @sprites["locationDash"].visible = false
    end
    # Reset the line count to the default value.
    @oldLineCount = @lineCount
    @lineCount = 1
    @oldTotalHeight = @totalHeight || 0
    # update the Current Location Name
    name = @curLocName = pbGetMapLocation(@mapX, @mapY)
    # assign the sprites and clear their content.
    spriteBox = @sprites["previewBox"]

    spriteText = @sprites["locationText"]
    spriteText.bitmap.clear

    spriteIcon = @sprites["locationIcon"]
    spriteIcon.bitmap.clear

    spriteDash = @sprites["locationDash"]
    spriteDash.bitmap.clear

    # Get the default width for text.
    locDescrWidth = spriteBox.width - 20

    # by default the Alternative Preview Box is used.
    @useAlt = "Alt"
    mapInfo = @mapInfo[@curMapLoc.gsub(" ", "").to_sym] unless @curMapLoc.nil?
    if !mapInfo.nil? && mapInfo[:mapname] == pbGetMessageFromHash(LocationNames, mapInfo[:realname]) && ARMSettings::CanViewInfoUnvisitedMaps
      name = mapInfo[:realname].gsub(/[ ,.\-_'()]/, "")
      locDescr = _INTL("No information given.")
      locDescr = pbGetMessageFromHash(ScriptTexts, locDescr)
      @cannotExtPreview = true
      if ARMLocationPreview.const_defined?(name) || ARMLocationPreview.const_defined?("#{name}_#{@region}")
        @locObject = ARMLocationPreview.const_get(ARMLocationPreview.const_defined?("#{name}_#{@region}") ? "#{name}_#{@region}" : name)
        key = "#{:description}_#{adjustPosX(@mapX).round}_#{adjustPosY(@mapY).round}".to_sym
        key = :description unless @locObject.key?(key)
        unless @locObject[key].nil?
          locDescr = pbGetMessageFromHash(ScriptTexts, @locObject[key])
          getExtendedInfo(true)
          @cannotExtPreview = false if ARMSettings::UseExtendedPreview && [ARMSettings::ProgressCountItems, ARMSettings::ProgressCountSpecies, ARMSettings::ProgressCountTrainers].any? { |value| value } && !(ARMSettings::ExcludeMapsWithNoData && @getData.empty?)
        end
        if @locObject[:icon]
          iconImage = findUsableUI("LocationPreview/MiniMaps/map#{@locObject[:icon]}")
          iconWidth = getBitmapWidth(iconImage)
          iconHeight = getBitmapHeight(iconImage)
          xIcon = (spriteBox.width - (20 + iconWidth)) + ARMSettings::IconOffsetX
          #spriteIcon.setBitmap(findUsableUI("LocationPreview/MiniMaps/map#{@locObject[:icon]}"))
          locDescrWidth = xIcon - (spriteBox.x + 20)
          @locationIcon = true
        end
        getDir = []
        dirWidths = []
        directions = [:north, :northEast, :east, :southEast, :south, :southWest, :west, :northWest]
        locDirWidth = spriteBox.width - 20
        directions.each do |dir|
          key = "#{dir}_#{adjustPosX(@mapX)}_#{adjustPosY(@mapY)}".to_sym
          key = dir unless @locObject.key?(key)
          loc = @locObject[key]
          name = ""
          if loc.is_a?(Array) && !loc.nil?
            value = @mapInfo.find { |_, location| location[:positions].any? { |pos| adjustPosX(pos[:x]) == loc[0] && adjustPosY(pos[:y]) == loc[1] } }
            if value
              name = pbGetMessageFromHash(ScriptTexts, value[1][:mapname])
            else
              name = pbGetMessageFromHash(ScriptTexts, _INTL("Invalid Location"))
            end
          else
            name = loc
          end
          if @locObject.key?(key) && name != ""
            name += ' ' * ARMSettings::LocationDirectionSpaces
            dirWidths << (getBitmapWidth("Graphics/Icons/#{dir.to_s}") + spriteText.bitmap.text_size(name.to_s).width)
            getDir << "<icon=#{dir.to_s}>#{name}"
          end
        end
        currSum = 0
        newLines = []
        dirWidths.each_with_index do |width, index|
          currSum += width
          if currSum > locDirWidth
            newLines << index
            currSum = width
          end
        end
        newLines.each do |index|
          getDir[index] = "\n#{getDir[index]}"
        end
        locDir = "#{getDir.join('')}"
      end
    else
      if ARMSettings::CanViewInfoUnvisitedMaps && (name == "???" || !ARMSettings::NoUnvistedMapInfo)
        locDescr = pbGetMessageFromHash(ScriptTexts, ARMSettings::UnvisitedMapInfoText)
        @cannotExtPreview = true
      else
        return false
      end
    end
    @lineCount -= 1 if locDescr.nil? || locDescr == ""
    if @lineCount != 0 || !@lineCount.nil?
      xDescr = 8 + ARMSettings::DescriptionTextOffsetX
      yDescr = 8 + ARMSettings::DescriptionTextOffsetY
      maxHeight = ARMSettings::MaxIconHeight #ARMSettings::MaxDescriptionLines * ARMSettings::PreviewLineHeight
      base = (ARMSettings::DescriptionTextMain).to_rgb15
      shadow = (ARMSettings::DescriptionTextShadow).to_rgb15
      text = "<c2=#{base}#{shadow}>#{locDescr}"
      spriteText.bitmap.clear
      spriteDash.visible == false if spriteDash
      chars = drawText(spriteText.bitmap, xDescr, yDescr, locDescrWidth, maxHeight, text)
      @lineCount = 1 + (chars.count { |item| item[0] == "\n"})
      @lineCount = ARMSettings::MaxDescriptionLines if @lineCount > ARMSettings::MaxDescriptionLines
      descrHeight = @lineCount * ARMSettings::PreviewLineHeight
      descrOffset = 0
      @totalHeight = descrHeight
      if @locationIcon
        @iconOffset = 4
        # Adjust Description Lines to Icon Height
        @lineCount += (iconHeight - descrHeight) / ARMSettings::PreviewLineHeight if iconHeight && iconHeight > descrHeight && @lineCount <= ARMSettings::MaxDescriptionLines

        # Center Text in height
        if iconHeight && descrHeight < iconHeight && ARMSettings::CenterDescriptionText
          descrOffset = (@lineCount * ARMSettings::PreviewLineHeight - descrHeight) / 2
          spriteText.bitmap.clear
          chars = drawText(spriteText.bitmap, xDescr, (yDescr + descrOffset), locDescrWidth, maxHeight, text)
        end

        # Center Icon in height
        if iconHeight && iconHeight < @lineCount * ARMSettings::PreviewLineHeight && ARMSettings::CenterIcon
          @iconOffset += ((@lineCount * ARMSettings::PreviewLineHeight) - iconHeight) / 2
        end
        yIcon = @iconOffset + ARMSettings::IconOffsetY
        pbDrawImagePositions(spriteIcon.bitmap, [[iconImage, xIcon, yIcon]])
        @totalHeight = iconHeight if iconHeight && iconHeight >= descrHeight
      end
      if locDir && !locDir.empty?
        if ARMSettings::DrawDashImages
          @useAlt = "" if ARMSettings::DirectionHeightSpacing != 0
          dashImage = findUsableUI("LocationPreview/mapLocDash")
          dashWidth = getBitmapWidth("#{dashImage}")
          dashHeight = getBitmapHeight("#{dashImage}")
          xDash = 12 + ARMSettings::DashOffsetX
          yDash = (((yDescr + @totalHeight) - (dashHeight / 2))) + 2 + ARMSettings::DashOffsetY
          @totalHeight += ARMSettings::DirectionHeightSpacing
          spriteDash.bitmap.clear
          @locationDash = true
          if dashHeight <= ARMSettings::DirectionHeightSpacing
            while xDash <= locDirWidth do
              pbDrawImagePositions(spriteDash.bitmap, [[findUsableUI("LocationPreview/mapLocDash"), xDash, yDash]])
              xDash += dashWidth + (dashWidth / 2)
            end
          end
        end
        xDir = 8 + ARMSettings::DirecitonTextOffsetX
        yDir = yDescr + @totalHeight + ARMSettings::DirectionTextOffsetY
        maxHeight = ARMSettings::MaxDirectionLines * ARMSettings::PreviewLineHeight
        base = (ARMSettings::DirectionTextBase).to_rgb15
        shadow = (ARMSettings::DirectionTextShadow).to_rgb15
        text = "<c2=#{base}#{shadow}>#{locDir}"
        chars = drawText(spriteText.bitmap, xDir, yDir, locDirWidth, maxHeight, text)
        count = 1 + (chars.count { |item| item[0] == "\n"})
        count = ARMSettings::MaxDirectionLines if count > ARMSettings::MaxDirectionLines
        @totalHeight += count * ARMSettings::PreviewLineHeight
        @lineCount += count
      end
      getPreviewBox
      @sprites["locationText"].x = @sprites["previewBox"].x
      @sprites["locationText"].y = Graphics.height - (@totalHeight + UIBorderHeight)
      if @locationDash
        @sprites["locationDash"].x = @sprites["locationText"].x
        @sprites["locationDash"].y = @sprites["locationText"].y
      end
      if @locationIcon
        @sprites["locationIcon"].x = @sprites["locationText"].x
        @sprites["locationIcon"].y = @sprites["locationText"].y
      end
      @sprites["locationText"].z = 28
    end
  end

  def drawText(bitmapText, x, y, locDescrWidth, maxHeight, text)
    chars = getFormattedText(bitmapText, x, y, locDescrWidth, maxHeight, text)
    drawFormattedChars(@sprites["locationText"].bitmap, chars)
    return chars
  end
end

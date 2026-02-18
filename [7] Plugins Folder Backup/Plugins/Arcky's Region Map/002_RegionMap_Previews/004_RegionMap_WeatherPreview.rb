class PokemonRegionMap_Scene
  def getPreviewWeather
    if WeatherPlugin
      if !@sprites["weatherPreview"]
        @sprites["weatherPreview"] = IconSprite.new(0, 0, @viewport)
        @sprites["weatherPreview"].setBitmap(findUsableUI("WeatherPreview/mapWeatherBox"))
        if BoxTopLeft
          @sprites["weatherPreview"].y = 54
        else
          @sprites["weatherPreview"].y = 22
        end
        @sprites["weatherPreview"].x = 4
        @sprites["weatherPreview"].z = 23
      end
      if ARMSettings::WeatherOnLocationPreviewActive && @mode == 0
        @sprites["weatherPreview"].visible = @previewBox.canShow || previewAnimation || @previewBox.isShown
      else
        if ARMSettings::WeatherOnModes.include?(@mode) && pbGetMapLocation(@mapX, @mapY) != ""
          @sprites["weatherPreview"].visible = true
        else
          @sprites["weatherPreview"].visible = false
        end
      end
      showPreviewWeather
    end
  end

  def showPreviewWeather
    if !@sprites["weatherIcon"]
      @sprites["weatherIcon"] = IconSprite.new(0, 0, @viewport)
      if BoxTopLeft
        @sprites["weatherIcon"].y = 68
      else
        @sprites["weatherIcon"].y = 36
      end
      @sprites["weatherIcon"].x = 20
      @sprites["weatherIcon"].z = 24
    else
      if @sprites["weatherIcon"]
        @sprites["weatherIcon"].visible = @sprites["weatherPreview"].visible
        return if !@sprites["weatherIcon"].visible
      end
      zone = pbGetMapZone(@mapX, @mapY)
      weather = :None
      if zone != nil
        weather = $WeatherSystem.actualWeather[zone].mainWeather
        weather = pbCheckValidWeather(weather, zone)
      end
      conversion = WeatherConfig::WEATHER_IMAGE
      id = conversion[weather]
      unless id.nil?
        @sprites["weatherIcon"].visible = true
        @sprites["weatherIcon"].setBitmap("#{Folder}Icons/Weather/#{id}")
      else
        @sprites["weatherIcon"].visible = false
      end
      @sprites["weatherPreview"].visible = @sprites["weatherIcon"].visible
    end
  end
end

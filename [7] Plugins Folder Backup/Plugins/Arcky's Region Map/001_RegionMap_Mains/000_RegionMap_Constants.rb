class PokemonRegionMap_Scene
  QuestPlugin = PluginManager.installed?("Modern Quest System + UI")
  BerryPlugin = PluginManager.installed?("TDW Berry Planting Improvements")
  WeatherPlugin = PluginManager.installed?("Lin's Weather System") && ARMSettings::UseWeatherPreview
  ThemePlugin = PluginManager.installed?("Lin's Pokegear Themes")

  ZeroPointX  = ARMSettings::CursorMapOffset ? 1 : 0
  ZeroPointY  = ARMSettings::CursorMapOffset ? 1 : 0

  RegionUI = ARMSettings::ChangeUIOnRegion
  UIBorderWidth = 16 # don't edit this
  UIBorderHeight = 32 # don't edit this
  UIWidth = Settings::SCREEN_WIDTH - (UIBorderWidth * 2)
  UIHeight = Settings::SCREEN_HEIGHT - (UIBorderHeight * 2)
  BehindUI = ARMSettings::RegionMapBehindUI ? [0, 0, 0, 0] : [UIBorderWidth, (UIBorderWidth * 2), UIBorderHeight, (UIBorderHeight * 2)]

  Folder = "Graphics/UI/Town Map/"
  UIFolder = ARMSettings::UseSpecialUI ? "Special" : "Default"
  SpecialUI = ARMSettings::ExtendedMainInfoFixed && ARMSettings::UseSpecialUI && !ThemePlugin

  BoxBottomLeft = ARMSettings::ButtonBoxPosition == 2
  BoxBottomRight = ARMSettings::ButtonBoxPosition == 4
  BoxTopLeft = ARMSettings::ButtonBoxPosition == 1
  BoxTopRight = ARMSettings::ButtonBoxPosition == 3
  BOX_PREVIEW_DISABLED = ARMSettings::ButtonBoxPosition.nil?

  RegionNames = MessageTypes::REGION_NAMES

  LocationNames = MessageTypes::REGION_LOCATION_NAMES

  POINames = MessageTypes::REGION_LOCATION_DESCRIPTIONS

  ScriptTexts = MessageTypes::SCRIPT_TEXTS
end

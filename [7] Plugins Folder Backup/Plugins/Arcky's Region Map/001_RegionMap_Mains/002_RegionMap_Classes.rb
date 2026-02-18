#===============================================================================
# UI stuff on loading the Region Map
#===============================================================================
class MapBottomSprite < Sprite
  def initialize(viewport = nil)
    super(viewport)
    @mapname      = ""
    @maplocation  = ""
    @mapdetails   = ""
    @previewName  = ""
    @previewWidth = 0
    self.bitmap = Bitmap.new(Graphics.width, Graphics.height)
    pbSetSystemFont(self.bitmap)
    refresh
  end

  def previewName=(value)
    return if @previewName == value[0]
    @previewName = value[0]
    @previewWidth = value[1] || 0
    refresh
  end

  def refresh
    bitmap.clear
    textpos = [
      [
        @mapname,
        18 + ARMSettings::RegionNameOffsetX, 4 + ARMSettings::RegionNameOffsetY, 0,
        ARMSettings::RegionTextMain, ARMSettings::RegionTextShadow
      ],
      [
        @maplocation,
        18 + ARMSettings::LocationNameOffsetX, (Graphics.height - 24) + ARMSettings::LocationNameOffsetY, 0,
        ARMSettings::LocationTextMain, ARMSettings::LocationTextShadow
      ],
      [
        @mapdetails,
        Graphics.width - (PokemonRegionMap_Scene::UIBorderWidth - ARMSettings::PoiNameOffsetX), (Graphics.height - 24) + ARMSettings::PoiNameOffsetY, 1,
        ARMSettings::PoiTextMain, ARMSettings::PoiTextShadow
      ],
      [
        @previewName,
        Graphics.width - (@previewWidth + PokemonRegionMap_Scene::UIBorderWidth + ARMSettings::PreviewNameOffsetX - 16), 4 + ARMSettings::PreviewNameOffsetY, 0,
        ARMSettings::PreviewTextMain, ARMSettings::PreviewTextShadow
      ]
    ]
    pbDrawTextPositions(bitmap, textpos)
  end
end
#===============================================================================
# Fly Region Map
#===============================================================================
class PokemonRegionMapScreen
  def pbStartScreen
    @scene.pbStartScene
    ret = @scene.pbMapScene
    @scene.pbEndScene
    return ret
  end
end
#===============================================================================
# Debug menu editor
#===============================================================================
class RegionMapSprite
  def createRegionMap(map)
    townMap = GameData::TownMap.get(map)
    bitmap = AnimatedBitmap.new("Graphics/UI/Town Map/Regions/#{townMap.filename}").deanimate
    retbitmap = BitmapWrapper.new(bitmap.width / 2, bitmap.height / 2)
    retbitmap.stretch_blt(
      Rect.new(0, 0, bitmap.width / 2, bitmap.height / 2),
      bitmap,
      Rect.new(0, 0, bitmap.width, bitmap.height)
    )
    bitmap.dispose
    return retbitmap
  end
end
#===============================================================================
# SpriteWindow_text
#===============================================================================
class Window_CommandPokemon < Window_DrawableCommand
  def initialize(commands, width = nil, custom = false)
    @starting = true
    @commands = []
    dims = []
    @custom = custom
    super(0, 0, 32, 32)
    getAutoDims(commands, dims, width)
    self.width = dims[0]
    self.height = dims[1]
    @commands = commands
    self.active = true
    colors = getDefaultTextColors(self.windowskin)
    self.baseColor = colors[0]
    self.shadowColor = colors[1]
    refresh
    @starting = false
  end

  def resizeToFit(commands, width = nil)
    dims = []
    getAutoDims(commands, dims, width)
    self.width = dims[0]
    self.height = @custom && @commands.length > ARMSettings::MaxOptionsChoiceMenu ? (32 + (ARMSettings::MaxOptionsChoiceMenu * 32)) : dims[1]
  end
end

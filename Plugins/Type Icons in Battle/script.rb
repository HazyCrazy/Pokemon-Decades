#-------------------------------------------------------------------------------
# Config Options
#-------------------------------------------------------------------------------
class Battle::Scene::PokemonDataBox

  # Set this to certain values to draw the icons at different positions
  # 0 - Draw above the databox
  # 1 - Draw below the databox
  # 2 - Draw at the side of the databox
  TYPE_ICONS_POSITION = 2

end

#-------------------------------------------------------------------------------
# Main Script
#-------------------------------------------------------------------------------
class Battle::Scene::PokemonDataBox
  alias __types__initializeOtherGraphics initializeOtherGraphics unless method_defined?(:__types__initializeOtherGraphics)
  def initializeOtherGraphics(*args)
    @types_bitmap = AnimatedBitmap.new("Graphics/UI/Battle/icon_types")
    @types_sprite = Sprite.new(viewport)
    height = @types_bitmap.height / GameData::Type.count
    @types_x, @types_y, height = 0
    case TYPE_ICONS_POSITION
    when 2
      height = @databoxBitmap.height
      @types_x = (@battler.opposes?(0)) ? @databoxBitmap.width - @types_bitmap.width : 0
      @types_y = 10
    when 1
      height = @types_bitmap.height / GameData::Type.count
      @types_x = (@battler.opposes?(0)) ? 24 : 40
      @types_y = @databoxBitmap.height
    when 0
      height = @types_bitmap.height / GameData::Type.count
      @types_x = (@battler.opposes?(0)) ? 24 : 40
      @types_y = -height
    end
    @types_sprite.bitmap = Bitmap.new(@databoxBitmap.width - @types_x, height)
    @sprites["types_sprite"] = @types_sprite
    __types__initializeOtherGraphics(*args)
  end

  alias __types__dispose dispose unless method_defined?(:__types__dispose)
  def dispose(*args)
    __types__dispose(*args)
    @types_bitmap.dispose
  end

  alias __types__set_x x= unless method_defined?(:__types__set_x)
  def x=(value)
    __types__set_x(value)
    @types_sprite.x = value + @types_x
  end

  alias __types__set_y y= unless method_defined?(:__types__set_y)
  def y=(value)
    __types__set_y(value)
    @types_sprite.y = value + @types_y
  end

  alias __types__set_z z= unless method_defined?(:__types__set_z)
  def z=(value)
    __types__set_z(value)
    @types_sprite.z = value - 1
  end

  alias __databox__refresh refresh unless method_defined?(:__databox__refresh)
  def refresh
    self.bitmap.clear
    return if !@battler.pokemon
    __databox__refresh
    draw_type_icons
  end

  def draw_type_icons
    # Draw Pokémon's types
    @types_sprite.bitmap.clear
    width  = @types_bitmap.width
    height = @types_bitmap.height / GameData::Type.count
    types  = @battler.pbTypes.clone
    if @battler.effects[PBEffects::Illusion]
      illusion_types = @battler.effects[PBEffects::Illusion].types
      base_types = @battler.pokemon.types
      base_types.each { |type| types.delete(type) }
      illusion_types.reverse.each { |type| types.insert(0, type) }
    end
    types.each_with_index do |type, i|
      type_number = GameData::Type.get(type).icon_position
      if TYPE_ICONS_POSITION == 2
        type_rect = Rect.new(0, type_number * height, width, height)
        @types_sprite.bitmap.blt(0, height * i, @types_bitmap.bitmap, type_rect)
      else
        type_rect = Rect.new(0, type_number * height, width, height)
        @types_sprite.bitmap.blt((width - 6) * i, 0, @types_bitmap.bitmap, type_rect)
      end
    end
  end
end

class Battle::Battler
  alias __types__pbChangeTypes pbChangeTypes unless method_defined?(:__types__pbChangeTypes)
  def pbChangeTypes(*args)
    ret = __types__pbChangeTypes(*args)
    @battle.scene.sprites["dataBox_#{self.index}"]&.refresh
    return ret
  end

  alias __types__pbEffectsOnMakingHit pbEffectsOnMakingHit unless method_defined?(:__types__pbEffectsOnMakingHit)
  def pbEffectsOnMakingHit(*args)
    ret = __types__pbEffectsOnMakingHit(*args)
    @battle.scene.sprites["dataBox_#{args[1]&.index || 0}"]&.refresh
    @battle.scene.sprites["dataBox_#{args[2]&.index || 0}"]&.refresh
    return ret
  end
end

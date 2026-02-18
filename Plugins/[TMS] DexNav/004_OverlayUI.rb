module MyOverlayModule
  @overlay_sprite = nil  # Sprite per il bitmap dell'overlay

  # @param viewport [Viewport] viewport for sprite overlay
  # @param info [DexNavInfo] contains overlay info for the pokemon
  def self.pbShowMyOverlay(info, viewport = nil)
    return if @overlay_sprite # Già presente, non fare nulla
    viewport ||= Viewport.new(0, 0, Graphics.width, Graphics.height)
    viewport.z = 99999 # Assicurati che sia sopra tutto

    @overlay_sprite = Sprite.new(viewport)
    @overlay_sprite.bitmap = Settings::DEXNAV_OVERLAY_USE_ICON ?
                               Bitmap.new("Graphics/UI/DexNav/DexnavSearchUI_with_icons") :
                               Bitmap.new("Graphics/UI/DexNav/DexnavSearchUI")
    pkmn = info.get_pkmn
    @sprite = PokemonIconSprite.new(pkmn, viewport)
    @sprite.x = 440
    @sprite.y = 185
    @text = Window_AdvancedTextPokemon.newWithSize("", 280, 248, 250, 126, viewport)
    @text.opacity = 0
    @text.text = _INTL("</c2>{1}\n{2}\n{3}", pkmn.name, info.get_ability, info.get_move)
    if info.overlay_item
      @item = ItemIconSprite.new(480, 354, info.get_item, viewport)
    end
    ivs = info.get_ivs
    if ivs > 0
      @ivs_sprite = Sprite.new(viewport)
    end
    case ivs
    when 1
      @ivs_sprite.bitmap = Bitmap.new("Graphics/UI/DexNav/OneIVs")
    when 2
      @ivs_sprite.bitmap = Bitmap.new("Graphics/UI/DexNav/TwoIVs")
    when 3
      @ivs_sprite.bitmap = Bitmap.new("Graphics/UI/DexNav/ThreeIVs")
    else
      @ivs_sprite = nil
    end
    if ivs > 0
      @ivs_sprite.x = 294
      @ivs_sprite.y = 358
    end

  end

  # Metodo per terminare l'overlay
  def self.pbEndMyOverlay
    return unless @overlay_sprite  # Se non esiste, non fare nulla

    @overlay_sprite.bitmap.dispose if @overlay_sprite.bitmap
    @overlay_sprite.dispose
    @overlay_sprite = nil
    @sprite.bitmap.dispose if @sprite.bitmap
    @sprite.dispose
    @sprite = nil
    @text.dispose
    @text = nil
    if @item
      @item.bitmap.dispose if @item.bitmap
      @item.dispose
      @item = nil
    end
    unless @ivs_sprite.nil?
      @ivs_sprite.bitmap.dispose
      @ivs_sprite.dispose
      @ivs_sprite = nil
    end
  end
end

class DexNavInfo
  attr_accessor :overlay_sprite
  attr_accessor :overlay_move
  attr_accessor :overlay_ability
  attr_accessor :overlay_ivs
  attr_accessor :overlay_item

  def initialize(overlay_sprite = nil, overlay_move = nil, overlay_ability = nil, overlay_ivs = 0, overlay_item = nil)
    @overlay_sprite = overlay_sprite
    @overlay_move   = overlay_move
    @overlay_ability = overlay_ability
    @overlay_ivs = overlay_ivs
    @overlay_item = overlay_item
  end

  def get_pkmn
    icon = Pokemon.new(@overlay_sprite, 1)
    return icon
  end

  def get_item
    return @overlay_item if @overlay_item
  end

  def get_ability
    ability = !@overlay_ability.nil? ? @overlay_ability : "---"
    return ability
  end

  def get_move
    move = !@overlay_move.nil? ? GameData::Move.get(@overlay_move).name : "---"
    return move
  end

  def get_ivs
    return @overlay_ivs
  end

end
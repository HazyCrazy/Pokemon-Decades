#===============================================================================
# Adds/edits various Summary utilities.
#===============================================================================
class PokemonSummary_Scene
  def drawPageIV
    overlay = @sprites["overlay"].bitmap
    base   = Color.new(248, 248, 248)
    shadow = Color.new(104, 104, 104)
    # Determine which stats are boosted and lowered by the Pokémon's nature
    statshadows = {}
    GameData::Stat.each_main { |s| statshadows[s.id] = shadow }
    if !@pokemon.shadowPokemon? || @pokemon.heartStage <= 3
      @pokemon.nature_for_stats.stat_changes.each do |change|
        statshadows[change[0]] = Color.new(136, 96, 72) if change[1] > 0
        statshadows[change[0]] = Color.new(64, 120, 152) if change[1] < 0
      end
    end
    # Write various bits of text
    textpos = [
      [_INTL("HP"), 248, 94, :left, base, statshadows[:HP]],
      [sprintf("%d", @pokemon.iv[:HP]), 456, 94, :right, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [_INTL("Attack"), 248, 126, :left, base, statshadows[:ATTACK]],
      [sprintf("%d", @pokemon.iv[:ATTACK]), 456, 126, :right, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [_INTL("Defense"), 248, 158, :left, base, statshadows[:DEFENSE]],
      [sprintf("%d", @pokemon.iv[:DEFENSE]), 456, 158, :right, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [_INTL("Sp. Atk"), 248, 190, :left, base, statshadows[:SPECIAL_ATTACK]],
      [sprintf("%d", @pokemon.iv[:SPECIAL_ATTACK]), 456, 190, :right, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [_INTL("Sp. Def"), 248, 222, :left, base, statshadows[:SPECIAL_DEFENSE]],
      [sprintf("%d", @pokemon.iv[:SPECIAL_DEFENSE]), 456, 222, :right, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [_INTL("Speed"), 248, 254, :left, base, statshadows[:SPEED]],
      [sprintf("%d", @pokemon.iv[:SPEED]), 456, 254, :right, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [_INTL("Hidden Power"), 220, 340, :left, base, shadow]
    ]
    # Draw all text
    pbDrawTextPositions(overlay, textpos)
    typebitmap = AnimatedBitmap.new(_INTL("Graphics/UI/types"))
    hiddenpower = pbHiddenPower(@pokemon)
    type_number = GameData::Type.get(hiddenpower[0]).icon_position
    type_rect = Rect.new(0, type_number * 28, 64, 28)
    overlay.blt(398, 336, @typebitmap.bitmap, type_rect)
  end
end
#===============================================================================
# Adds/edits various Summary utilities.
#===============================================================================
class PokemonSummary_Scene
  def drawPageIVEV
    overlay = @sprites["overlay"].bitmap
    base   = Color.new(248, 248, 248)
    shadow = Color.new(104, 104, 104)
    ev_total = 0
    # Determine which stats are boosted and lowered by the Pokémon's nature
    statshadows = {}
    GameData::Stat.each_main { |s| statshadows[s.id] = shadow; ev_total += @pokemon.ev[s.id] }
    if !@pokemon.shadowPokemon? || @pokemon.heartStage <= 3
      @pokemon.nature_for_stats.stat_changes.each do |change|
        statshadows[change[0]] = Color.new(136, 96, 72) if change[1] > 0
        statshadows[change[0]] = Color.new(64, 120, 152) if change[1] < 0
      end
    end
    # Write various bits of text
    textpos = [
      [_INTL("IV"), 388, 94, :center, base, shadow],
      [_INTL("EV"), 454, 94, :center, base, shadow],
      [_INTL("HP"), 248, 126, :left, base, statshadows[:HP]],
      [sprintf("%d", @pokemon.iv[:HP]), 400, 126, :right, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [sprintf("%d", @pokemon.ev[:HP]), 472, 126, :right, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [_INTL("Attack"), 248, 158, :left, base, statshadows[:ATTACK]],
      [sprintf("%d", @pokemon.iv[:ATTACK]), 400, 158, :right, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [sprintf("%d", @pokemon.ev[:ATTACK]), 472, 158, :right, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [_INTL("Defense"), 248, 190, :left, base, statshadows[:DEFENSE]],
      [sprintf("%d", @pokemon.iv[:DEFENSE]), 400, 190, :right, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [sprintf("%d", @pokemon.ev[:DEFENSE]), 472, 190, :right, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [_INTL("Sp. Atk"), 248, 222, :left, base, statshadows[:SPECIAL_ATTACK]],
      [sprintf("%d", @pokemon.iv[:SPECIAL_ATTACK]), 400, 222, :right, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [sprintf("%d", @pokemon.ev[:SPECIAL_ATTACK]), 472, 222, :right, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [_INTL("Sp. Def"), 248, 254, :left, base, statshadows[:SPECIAL_DEFENSE]],
      [sprintf("%d", @pokemon.iv[:SPECIAL_DEFENSE]), 400, 254, :right, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [sprintf("%d", @pokemon.ev[:SPECIAL_DEFENSE]), 472, 254, :right, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [_INTL("Speed"), 248, 286, :left, base, statshadows[:SPEED]],
      [sprintf("%d", @pokemon.iv[:SPEED]), 400, 286, :right, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [sprintf("%d", @pokemon.ev[:SPEED]), 472, 286, :right, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [_INTL("Total EV"), 224, 324, :left, base, shadow],
      [sprintf("%d/%d", ev_total, Pokemon::EV_LIMIT), 444, 324, :center, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [_INTL("Hidden Power"), 220, 356, :left, base, shadow]
    ]
    # Draw all text
    pbDrawTextPositions(overlay, textpos)
    typebitmap = AnimatedBitmap.new(_INTL("Graphics/UI/types"))
    hiddenpower = pbHiddenPower(@pokemon)
    type_number = GameData::Type.get(hiddenpower[0]).icon_position
    type_rect = Rect.new(0, type_number * 28, 64, 28)
    overlay.blt(398, 351, @typebitmap.bitmap, type_rect)
  end
end
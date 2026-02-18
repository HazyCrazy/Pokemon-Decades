#===============================================================================
# Adds/edits various Summary utilities.
#===============================================================================
class PokemonSummary_Scene
  def drawPageAllStats
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
      [_INTL("Base"), 386, 94, :center, base, shadow],
      [_INTL("IV"), 432, 94, :center, base, shadow],
      [_INTL("EV"), 478, 94, :center, base, shadow],
      [_INTL("HP"), 228, 126, :left, base, statshadows[:HP]],
      [@pokemon.totalhp.to_s, 352, 126, :right, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [sprintf("%d", @pokemon.baseStats[:HP]), 408, 126, :right, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [sprintf("%d", @pokemon.iv[:HP]), 444, 126, :right, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [sprintf("%d", @pokemon.ev[:HP]), 496, 126, :right, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [_INTL("Atk"), 228, 158, :left, base, statshadows[:ATTACK]],
      [@pokemon.attack.to_s, 352, 158, :right, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [sprintf("%d", @pokemon.baseStats[:ATTACK]), 408, 158, :right, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [sprintf("%d", @pokemon.iv[:ATTACK]), 444, 158, :right, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [sprintf("%d", @pokemon.ev[:ATTACK]), 496, 158, :right, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [_INTL("Def"), 228, 190, :left, base, statshadows[:DEFENSE]],
      [@pokemon.defense.to_s, 352, 190, :right, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [sprintf("%d", @pokemon.baseStats[:DEFENSE]), 408, 190, :right, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [sprintf("%d", @pokemon.iv[:DEFENSE]), 444, 190, :right, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [sprintf("%d", @pokemon.ev[:DEFENSE]), 496, 190, :right, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [_INTL("Sp. Atk"), 228, 222, :left, base, statshadows[:SPECIAL_ATTACK]],
      [@pokemon.spatk.to_s, 352, 222, :right, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [sprintf("%d", @pokemon.baseStats[:SPECIAL_ATTACK]), 408, 222, :right, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [sprintf("%d", @pokemon.iv[:SPECIAL_ATTACK]), 444, 222, :right, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [sprintf("%d", @pokemon.ev[:SPECIAL_ATTACK]), 496, 222, :right, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [_INTL("Sp. Def"), 228, 254, :left, base, statshadows[:SPECIAL_DEFENSE]],
      [@pokemon.spdef.to_s, 352, 254, :right, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [sprintf("%d", @pokemon.baseStats[:SPECIAL_DEFENSE]), 408, 254, :right, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [sprintf("%d", @pokemon.iv[:SPECIAL_DEFENSE]), 444, 254, :right, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [sprintf("%d", @pokemon.ev[:SPECIAL_DEFENSE]), 496, 254, :right, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [_INTL("Speed"), 228, 286, :left, base, statshadows[:SPEED]],
      [@pokemon.speed.to_s, 352, 286, :right, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [sprintf("%d", @pokemon.baseStats[:SPEED]), 408, 286, :right, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [sprintf("%d", @pokemon.iv[:SPEED]), 444, 286, :right, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [sprintf("%d", @pokemon.ev[:SPEED]), 496, 286, :right, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [_INTL("BST:"),250,90, :center, base, shadow],
	  [sprintf("%d", @pokemon.baseStats[:HP] + @pokemon.baseStats[:ATTACK] + @pokemon.baseStats[:DEFENSE] + @pokemon.baseStats[:SPECIAL_ATTACK] + @pokemon.baseStats[:SPECIAL_DEFENSE] + @pokemon.baseStats[:SPEED]), 348, 90, :right, Color.new(64, 64, 64), Color.new(176, 176, 176)],
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
#===============================================================================
# Adds/edits various Summary utilities.
#===============================================================================
class PokemonSummary_Scene
  def drawPageEV
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
      [_INTL("HP"), 248, 94, :left, base, statshadows[:HP]],
      [sprintf("%d", @pokemon.ev[:HP]), 456, 94, :right, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [_INTL("Attack"), 248, 126, :left, base, statshadows[:ATTACK]],
      [sprintf("%d", @pokemon.ev[:ATTACK]), 456, 126, :right, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [_INTL("Defense"), 248, 158, :left, base, statshadows[:DEFENSE]],
      [sprintf("%d", @pokemon.ev[:DEFENSE]), 456, 158, :right, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [_INTL("Sp. Atk"), 248, 190, :left, base, statshadows[:SPECIAL_ATTACK]],
      [sprintf("%d", @pokemon.ev[:SPECIAL_ATTACK]), 456, 190, :right, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [_INTL("Sp. Def"), 248, 222, :left, base, statshadows[:SPECIAL_DEFENSE]],
      [sprintf("%d", @pokemon.ev[:SPECIAL_DEFENSE]), 456, 222, :right, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [_INTL("Speed"), 248, 254, :left, base, statshadows[:SPEED]],
      [sprintf("%d", @pokemon.ev[:SPEED]), 456, 254, :right, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [_INTL("Total EV"), 224, 340, :left, base, shadow],
      [sprintf("%d/%d", ev_total, Pokemon::EV_LIMIT), 444, 340, :center, Color.new(64, 64, 64), Color.new(176, 176, 176)]
    ]
    # Draw all text
    pbDrawTextPositions(overlay, textpos)
  end
end
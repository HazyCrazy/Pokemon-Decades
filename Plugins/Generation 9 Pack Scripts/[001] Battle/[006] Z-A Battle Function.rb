class Battle
  #=============================================================================
  # Aliased to add Tatsugiri commander effect.
  #=============================================================================
  alias za_pbCanMegaEvolve? pbCanMegaEvolve?
  def pbCanMegaEvolve?(idxBattler)
    return za_pbCanMegaEvolve?(idxBattler) &&
           !@battlers[idxBattler].effects[PBEffects::Commander]
  end

  #=============================================================================
  # Mega Evolving a battler
  #=============================================================================
  alias za_pbMegaEvolve pbMegaEvolve
  def pbMegaEvolve(idxBattler)
    battler = @battlers[idxBattler]
    return if !battler || !battler.pokemon
    return if !battler.hasMega? || battler.mega?
    za_pbMegaEvolve(idxBattler)
    if !defined?(battler.display_mega_moves)
      MultipleForms.call("changePokemonOnMegaEvolve", battler, self)
    end
  end
end
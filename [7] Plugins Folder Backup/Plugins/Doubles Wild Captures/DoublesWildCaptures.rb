# Removing aiming message & allowing capture against two Pokemon
ItemHandlers::CanUseInBattle.addIf(:poke_balls,
  proc { |item| GameData::Item.get(item).is_poke_ball? },
  proc { |item, pokemon, battler, move, firstAction, battle, scene, showMessages|
    if battle.pbPlayer.party_full? && $PokemonStorage.full?
      scene.pbDisplay(_INTL("There is no room left in the PC!")) if showMessages
      next false
    end
    if battle.disablePokeBalls
      scene.pbDisplay(_INTL("You can't throw a Poké Ball!")) if showMessages
      next false
    end
    # NOTE: Using a Poké Ball consumes all your actions for the round. The code
    #       below is one half of making this happen; the other half is in def
    #       pbItemUsesAllActions?.
    if battler.semiInvulnerable?
      scene.pbDisplay(_INTL("It's no good! It's impossible to aim at a Pokémon that's not in sight!")) if showMessages
      next false
    end
    # NOTE: The code below stops you from throwing a Poké Ball if there is more
    #       than two unfainted opposing Pokémon. (Snag Balls can be thrown in
    #       this case, but only in trainer battles, and the trainer will deflect
    #       them if they are trying to catch a non-Shadow Pokémon.)
    #if battle.pbOpposingBattlerCount > 2 && !(GameData::Item.get(item).is_snag_ball? && battle.trainerBattle?)
    #  if battle.pbOpposingBattlerCount == 3
	if battle.pbOpposingBattlerCount > 3 && !(GameData::Item.get(item).is_snag_ball? && battle.trainerBattle?) # Triple Battles Capture Tweak
      if battle.pbOpposingBattlerCount == 4
        scene.pbDisplay(_INTL("It's no good! It's impossible to aim when there are two Pokémon!")) if showMessages
      elsif showMessages
        scene.pbDisplay(_INTL("It's no good! It's impossible to aim when there is more than one Pokémon!"))
      end
      next false
    end
    next true
  }
)




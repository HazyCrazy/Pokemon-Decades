#===============================================================================
# Code for party menu skills.
#===============================================================================

#-------------------------------------------------------------------------------
# Healing Skill - Uses own HP to heal a party Pokemon's HP.
#-------------------------------------------------------------------------------
def pbHealPartySkill(pkmn, movename, screen, party, party_idx)
  amt = [(pkmn.totalhp / 5).floor, 1].max
  screen.scene.pbSetHelpText(_INTL("Use on which Pokémon?"))
  old_party_idx = party_idx
  loop do
    screen.scene.pbPreSelect(old_party_idx)
    party_idx = screen.scene.pbChoosePokemon(true, party_idx)
    break if party_idx < 0
    newpkmn = party[party_idx]
    if party_idx == old_party_idx
      screen.scene.pbDisplay(_INTL("{1} can't use {2} on itself!", pkmn.name, movename))
    elsif newpkmn.egg?
      screen.scene.pbDisplay(_INTL("{1} can't be used on an Egg!", movename))
    elsif newpkmn.fainted? || newpkmn.hp == newpkmn.totalhp
      screen.scene.pbDisplay(_INTL("{1} can't be used on that Pokémon.", movename))
    else
      pkmn.hp -= amt
      hpgain = pbItemRestoreHP(newpkmn, amt)
      screen.scene.pbDisplay(_INTL("{1}'s HP was restored by {2} points.", newpkmn.name, hpgain))
      screen.scene.pbRefresh
    end
    break if pkmn.hp <= amt
  end
  screen.scene.pbSelect(old_party_idx)
  screen.scene.pbRefresh
end


#-------------------------------------------------------------------------------
# Recover Skill - Allows a Pokemon to recover its own HP.
#-------------------------------------------------------------------------------
def pbRecoverPartySkill(pkmn, movename, screen, party_idx)
  ret = 0
  if pkmn.hp == 0 || pkmn.hp == pkmn.totalhp
    screen.scene.pbDisplay(_INTL("It won't have any effect."))
  else
    amt = [(pkmn.totalhp / 4).floor, 1].max
    hpgain = pbItemRestoreHP(pkmn, amt)
    screen.scene.pbDisplay(_INTL("{1}'s HP was restored by {2} points.", pkmn.name, hpgain))
	ret = 1
  end
  screen.scene.pbSelect(party_idx)
  screen.scene.pbRefresh
  return ret
end


#-------------------------------------------------------------------------------
# Life Dew Skill - Allows a Pokemon to restore HP of the whole party at once.
#-------------------------------------------------------------------------------
def pbLifeDewPartySkill(pkmn, movename, screen, party, party_idx)
  ret = 0
  if pkmn.hp == 0
    screen.scene.pbDisplay(_INTL("It won't have any effect."))
  else
    party.each do |p|
      next if p.hp == 0 || p.hp == p.totalhp
      amt = [(p.totalhp / 4).floor, 1].max
      pbItemRestoreHP(p, amt)
      ret += 1
    end
    case ret
    when 0 then screen.scene.pbDisplay(_INTL("It won't have any effect."))
    else        screen.scene.pbDisplay(_INTL("{1} restored the party's HP!", pkmn.name))
    end
  end
  screen.scene.pbSelect(party_idx)
  screen.scene.pbRefresh
  return ret
end


#-------------------------------------------------------------------------------
# Status Skill - Allows a Pokemon to heal the status of the entire party at once.
#-------------------------------------------------------------------------------
def pbStatusPartySkill(pkmn, movename, screen, party, party_idx)
  ret = 0
  if pkmn.hp == 0
    screen.scene.pbDisplay(_INTL("It won't have any effect."))
  else
    party.each do |p|
      next if p.status == :NONE
      p.heal_status
      ret += 1
    end
    case ret
    when 0 then screen.scene.pbDisplay(_INTL("It won't have any effect."))
    else        screen.scene.pbDisplay(_INTL("{1} restored the party's condition!", pkmn.name))
    end
  end
  screen.scene.pbSelect(party_idx)
  screen.scene.pbRefresh
  return ret
end


#-------------------------------------------------------------------------------
# Sketch Skill - Sketches a party Pokemon's move from the party menu.
#-------------------------------------------------------------------------------
def pbSketchPartySkill(pkmn, movename, screen, party, party_idx)
  screen.scene.pbSetHelpText(_INTL("Sketch from which Pokémon?"))
  old_party_idx = party_idx
  loop do
    screen.scene.pbPreSelect(old_party_idx)
    party_idx = screen.scene.pbChoosePokemon(true, party_idx)
    break if party_idx < 0
    newpkmn = party[party_idx]
    if party_idx == old_party_idx
      screen.scene.pbDisplay(_INTL("{1} can't use {2} on itself!", pkmn.name, movename))
    elsif newpkmn.egg?
      screen.scene.pbDisplay(_INTL("{1} can't be used on an Egg!", movename))
    else
      newcommands = []
      newpkmn.moves.each do |move|
        newcommands.push(move.name)
      end
      newcommands.push("Cancel")
      newmove = screen.scene.pbShowCommands(_INTL("Sketch which of {1}'s moves?", newpkmn.name), newcommands)
      if newmove < (newcommands.length - 1) && newmove > -1
        newmove = newpkmn.moves[newmove]
        if pkmn.hasMove?(newmove.id)
            screen.scene.pbDisplay(_INTL("{1} already knows {2}.", pkmn.name, newmove.name))
        elsif newmove.type == :SHADOW
            screen.scene.pbDisplay(_INTL("{1} can't be sketched.", newmove.name))
        elsif screen.scene.pbConfirmMessage(_INTL("Sketch {1}?", newmove.name))
          for i in 0..pkmn.moves.length
            if pkmn.moves[i].id == :SKETCH
              pkmn.moves[i] = Pokemon::Move.new(newmove.id)
              screen.scene.pbMessage(_INTL("\\se[]{1} learned {2}!\\se[Pkmn move learnt]", pkmn.name, newmove.name))
              break
            end
          end
          screen.scene.pbRefresh
          break
        else
          screen.scene.pbSetHelpText(_INTL("Sketch from which Pokémon?"))
        end
      else
        screen.scene.pbSetHelpText(_INTL("Sketch from which Pokémon?"))
      end
    end
  end
  screen.scene.pbSelect(old_party_idx)
  screen.scene.pbRefresh
  return 0
end


#-------------------------------------------------------------------------------
# Future Sight Skill - Views the species of an Egg, or an upcoming move of a party member.
#-------------------------------------------------------------------------------
def pbFutureSightPartySkill(pkmn, movename, screen, party, party_idx, idxMove)
  ret = 0
  screen.scene.pbSetHelpText(_INTL("Use on which Pokémon?"))
  old_party_idx = party_idx
  loop do
    screen.scene.pbPreSelect(old_party_idx)
    party_idx = screen.scene.pbChoosePokemon(true, party_idx)
    break if party_idx < 0
    newpkmn = party[party_idx]
    if newpkmn.egg?
      annotations = [nil, nil, nil, nil, nil, nil]
      annotations[party_idx] = " "
      screen.scene.pbAnnotate(annotations)
      steps                  = newpkmn.steps_to_hatch
      newpkmn.name           = newpkmn.speciesName
      newpkmn.steps_to_hatch = 0
      newpkmn.hatched_map    = 0
      newpkmn.timeEggHatched = pbGetTimeNow
      screen.scene.pbDisplay(_INTL("{1} caught a glimpse of this Egg's future...", pkmn.name))
      ret += 1 if screen.scene.pbSummary(party_idx)
      newpkmn.steps_to_hatch = steps
      newpkmn.hatched_map    = nil
      newpkmn.timeEggHatched = nil
      newpkmn.name           = "Egg"
      screen.scene.pbRefresh
    elsif newpkmn.level < GameData::GrowthRate.max_level
      next_move = nil
      moveList = newpkmn.getMoveList
      moveList.each do |m|
        next if newpkmn.level > m[0]
        next if newpkmn.hasMove?(m[1])
        next_move = m
        break
      end
      if next_move
        next_move_name = GameData::Move.get(next_move[1]).name
        screen.scene.pbDisplay(_INTL("{1} may learn {2} at level {3}.", newpkmn.name, next_move_name, next_move[0]))
        ret += 1
      else
        screen.scene.pbDisplay(_INTL("{1}'s future is too vast to read.", newpkmn.name))
      end
    else
      screen.scene.pbDisplay(_INTL("{1}'s future is too vast to read.", newpkmn.name))
    end
    if Settings::CUSTOM_SKILLS_REQUIRE_MOVE
      break if ret >= pkmn.moves[idxMove].pp
    end
  end
  screen.scene.pbSelect(old_party_idx)
  screen.scene.pbRefresh
  return ret
end
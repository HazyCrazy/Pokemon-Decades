#===============================================================================
# DEBUG: Log AI replacement Pokemon selection
#===============================================================================

class Battle::AI
  alias debug_choose_best_replacement_pokemon choose_best_replacement_pokemon
  def choose_best_replacement_pokemon(idxBattler, terrible_moves = false)
    echoln "=" * 80
    echoln "=== AI REPLACEMENT POKEMON DEBUG ==="
    echoln "  Battler Index: #{idxBattler}"
    echoln "  Terrible Moves?: #{terrible_moves}"
    echoln "  Trainer Skill: #{@trainer&.skill || 'Unknown'}"
    echoln "  Has ReserveLastPokemon?: #{@trainer&.has_skill_flag?('ReserveLastPokemon')}"
    
    party = @battle.pbParty(idxBattler)
    idxPartyStart, idxPartyEnd = @battle.pbTeamIndexRangeFromBattlerIndex(idxBattler)
    
    echoln "  Party Size: #{party.compact.length} (Start: #{idxPartyStart}, End: #{idxPartyEnd})"
    echoln "  --- PARTY ANALYSIS ---"
    party.each_with_index do |pkmn, i|
      next unless pkmn
      
      can_switch = @battle.pbCanSwitchIn?(idxBattler, i)
      is_active = @battle.pbFindBattler(i, idxBattler)
      is_last = (i == idxPartyEnd - 1)
      
      status = []
      status << "FAINTED" if pkmn.fainted?
      status << "ACTIVE" if is_active
      status << "LAST_POKEMON" if is_last
      status << "CAN_SWITCH" if can_switch
      status << "BLOCKED_pbCanSwitchIn" if !can_switch && !is_active && !pkmn.fainted?
      
      echoln "    [#{i}] #{pkmn.name}: #{status.join(', ')}"
    end
    
    result = debug_choose_best_replacement_pokemon(idxBattler, terrible_moves)
    
    echoln "  ─────────────────────────────────────"
    echoln "  RESULT: #{result >= 0 ? "Party Index #{result} (#{party[result]&.name})" : "NO VALID POKEMON (-1)"}"
    echoln "=" * 80
    
    return result
  end
end

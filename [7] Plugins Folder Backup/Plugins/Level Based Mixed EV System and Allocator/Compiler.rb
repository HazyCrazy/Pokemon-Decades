module Compiler
  module_function

  def validate_compiled_trainer(hash)
    # Split trainer type, name and version into their own values, generate compound ID from them
    hash[:id][2] ||= 0
    hash[:trainer_type] = hash[:id][0]
    hash[:real_name] = hash[:id][1]
    hash[:version] = hash[:id][2]
    # Ensure the trainer has at least one Pokémon
    if hash[:pokemon].empty?
      raise _INTL("Trainer with ID {1} has no Pokémon.\n{2}", hash[:id], FileLineData.linereport)
    end
    max_level = GameData::GrowthRate.max_level
    hash[:pokemon].each do |pkmn|
      # Ensure valid level
      if pkmn[:level] > max_level
        raise _INTL("Invalid Pokémon level {1} (must be 1-{2}).\n{3}",
                    pkmn[:level], max_level, FileLineData.linereport)
      end
      # Ensure valid name length
      if pkmn[:real_name] && pkmn[:real_name].length > Pokemon::MAX_NAME_SIZE
        raise _INTL("Invalid Pokémon nickname: {1} (must be 1-{2} characters).\n{3}",
                    pkmn[:real_name], Pokemon::MAX_NAME_SIZE, FileLineData.linereport)
      end
      # Ensure no duplicate moves
      pkmn[:moves].uniq! if pkmn[:moves]
      # Ensure valid IVs, convert IVs to hash format
      if pkmn[:iv]
        iv_hash = {}
        GameData::Stat.each_main do |s|
          next if s.pbs_order < 0
          iv_hash[s.id] = pkmn[:iv][s.pbs_order] || pkmn[:iv][0]
          if iv_hash[s.id] > Pokemon::IV_STAT_LIMIT
            raise _INTL("Invalid IV: {1} (must be 0-{2}).\n{3}",
                        iv_hash[s.id], Pokemon::IV_STAT_LIMIT, FileLineData.linereport)
          end
        end
        pkmn[:iv] = iv_hash
      end
      if pkmn[:ev]
        ev_hash = {}
        ev_total = 0
        GameData::Stat.each_main do |s|
          next if s.pbs_order < 0
          ev_hash[s.id] = pkmn[:ev][s.pbs_order] || pkmn[:ev][0]
          ev_total += ev_hash[s.id]
          if ev_hash[s.id] > 256
            raise _INTL("Invalid EV: {1} (must be 0-{2}).\n{3}",
                        ev_hash[s.id], Pokemon::EV_STAT_LIMIT, FileLineData.linereport)
          end
        end
        pkmn[:ev] = ev_hash
        if ev_total > 512
          raise _INTL("Invalid EV set (must sum to {1} or less).\n{2}",
                      Pokemon::EV_LIMIT, FileLineData.linereport)
        end
      end
      # Ensure valid happiness
      if pkmn[:happiness]
        if pkmn[:happiness] > 255
          raise _INTL("Bad happiness: {1} (must be 0-255).\n{2}", pkmn[:happiness], FileLineData.linereport)
        end
      end
      # Ensure valid Poké Ball
      if pkmn[:poke_ball]
        if !GameData::Item.get(pkmn[:poke_ball]).is_poke_ball?
          raise _INTL("Value {1} isn't a defined Poké Ball.\n{2}", pkmn[:poke_ball], FileLineData.linereport)
        end
      end
    end
  end
end  



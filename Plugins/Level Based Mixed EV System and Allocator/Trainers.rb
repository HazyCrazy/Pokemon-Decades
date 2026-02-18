
module GameData
  class Trainer

    #SCHEMA["TEV"] = [:trainerevs,              "uUUUUU"]

    # alias mixed_ev_alloc_initialize initialize
    # def initialize(hash)
    #   mixed_ev_alloc_initialize(hash)
    #   @pokemon.each do |pkmn|
    #     GameData::Stat.each_main do |s|
    #       print pkmn
    #       pkmn[:trainerevs][s.id] ||= 0 if pkmn[:trainerevs]
    #     end
    #   end
    # end    

    alias mixed_ev_alloc_to_trainer to_trainer
    def to_trainer
      trainer = mixed_ev_alloc_to_trainer
      trainer.party.each_with_index do |pkmn, i|
        pkmn_data = @pokemon[i]
        GameData::Stat.each_main do |s|
          if pkmn_data[:ev]
            evcap=236+pkmn_data[:level]*4
            pkmn.ev[s.id] = pkmn_data[:ev][s.id]
            if pkmn.ev[s.id] >evcap
              pkmn.ev[s.id]=evcap
            end 
          else
            limit=472+pkmn_data[:level]*8
            pkmn.ev[s.id] = [pkmn_data[:level] * 3 / 2, limit / 6].min
          end	
        end  
        if !Settings::PURIST_MODE 
          pkmn.ev[:ATTACK]=pkmn.ev[:SPECIAL_ATTACK] if pkmn.ev[:SPECIAL_ATTACK]>pkmn.ev[:ATTACK]
        end 
        pkmn.calc_stats
      end
      return trainer
    end
    
  end
end
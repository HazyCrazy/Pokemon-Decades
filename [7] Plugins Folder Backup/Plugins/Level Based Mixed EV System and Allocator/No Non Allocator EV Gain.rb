# EV Gain from all sources that are not the Allocator are turned off
# the player has to use the EV Allocator
# Required to prevent crashing issues when a Pokemon gets EV's and has already maxed them out
alias mixed_ev_alloc_pbChangeLevel pbChangeLevel
def pbChangeLevel(pkmn, new_level, scene)
  if new_level > pkmn.level
    # DemICE edit
    evpool=472+pkmn.level*8
    evpool=(evpool.div(4))*4      
    evpool=512 if evpool>512    
    evcap=236+pkmn.level*4
    evcap=(evcap.div(4))*4
    evcap=256 if evcap>256
    increment=4*(new_level-pkmn.level)
    evsum=pkmn.ev[:HP]+pkmn.ev[:ATTACK]+pkmn.ev[:DEFENSE]+pkmn.ev[:SPECIAL_DEFENSE]+pkmn.ev[:SPEED] 	
		evsum+=pkmn.ev[:SPECIAL_ATTACK] if Settings::PURIST_MODE
    evarray=[]
    GameData::Stat.each_main do |s|
      evarray.push(pkmn.ev[s.id])
    end
    if evsum>0 && evpool>evsum && evarray.max<evcap && evarray.max_nth(2)<evcap
      GameData::Stat.each_main do |s|
        if pkmn.ev[s.id]==evarray.max
          pkmn.ev[s.id]+=increment
          pkmn.calc_stats
          pkmn.ev[s.id]+=increment if pkmn.ev[s.id]<evcap
          pkmn.calc_stats
        end
      end	
      evsum=pkmn.ev[:HP]+pkmn.ev[:ATTACK]+pkmn.ev[:DEFENSE]+pkmn.ev[:SPECIAL_DEFENSE]+pkmn.ev[:SPEED] 
      evsum+=pkmn.ev[:SPECIAL_ATTACK] if Settings::PURIST_MODE
      evarray=[]
      GameData::Stat.each_main do |s|
        evarray.push(pkmn.ev[s.id])
      end
      if evpool>evsum
        GameData::Stat.each_main do |s|
          if pkmn.ev[s.id]==evarray.max_nth(2)
            pkmn.ev[s.id]+=increment
            pkmn.calc_stats
          end
        end	
      end														
    end		    
    # DemICE end
  elsif new_level < pkmn.level
    GameData::Stat.each_main do |s|
      if pkmn.ev[s.id]=0
        pkmn.calc_stats
      end
    end	    
  end
  mixed_ev_alloc_pbChangeLevel(pkmn, new_level, scene)
end

class Battle

  alias mixed_ev_alloc_pbGainExpOne pbGainExpOne
  def pbGainExpOne(idxParty, defeatedBattler, numPartic, expShare, expAll, showMessages = true)
    pkmn = pbParty(0)[idxParty]   # The Pokémon gaining Exp from defeatedBattler
    current_level = pkmn.level

    mixed_ev_alloc_pbGainExpOne(idxParty, defeatedBattler, numPartic, expShare, expAll, showMessages)
    
    if pkmn.level > current_level
      # DemICE edit
      evpool=472+pkmn.level*8
      evpool=(evpool.div(4))*4      
      evpool=512 if evpool>512    
      evcap=236+pkmn.level*4
      evcap=(evcap.div(4))*4
      evcap=256 if evcap>256
      evsum=pkmn.ev[:HP]+pkmn.ev[:ATTACK]+pkmn.ev[:DEFENSE]+pkmn.ev[:SPECIAL_DEFENSE]+pkmn.ev[:SPEED] 	
      evsum+=pkmn.ev[:SPECIAL_ATTACK] if Settings::PURIST_MODE
        evarray=[]
        GameData::Stat.each_main do |s|
        evarray.push(pkmn.ev[s.id])
        end
      if evsum>0 && evpool>evsum && evarray.max<evcap && evarray.max_nth(2)<evcap
        GameData::Stat.each_main do |s|
          if pkmn.ev[s.id]==evarray.max
            pkmn.ev[s.id]+=4
            pkmn.calc_stats
            pkmn.ev[s.id]+=4 if pkmn.ev[s.id]<evcap
            pkmn.calc_stats
          end
        end	
        evsum=pkmn.ev[:HP]+pkmn.ev[:ATTACK]+pkmn.ev[:DEFENSE]+pkmn.ev[:SPECIAL_DEFENSE]+pkmn.ev[:SPEED] 
        evsum+=pkmn.ev[:SPECIAL_ATTACK] if Settings::PURIST_MODE
        evarray=[]
        GameData::Stat.each_main do |s|
          evarray.push(pkmn.ev[s.id])
        end
        if evpool>evsum
          GameData::Stat.each_main do |s|
            if pkmn.ev[s.id]==evarray.max_nth(2)
              pkmn.ev[s.id]+=4
              pkmn.calc_stats
            end
          end	
        end														
      end	
      pkmn.calc_stats
      # DemICE end
    elsif pkmn.level < current_level
      GameData::Stat.each_main do |s|
        if pkmn.ev[s.id]=0
          pkmn.calc_stats
        end
      end	       
    end  
  end

  def pbGainEVsOne(idxParty, defeatedBattler)
    return
  end

end  
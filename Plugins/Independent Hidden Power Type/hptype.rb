#This plugin makes every pokemon able to randomly have any hidden power type regardless of its IVs

class Battle
  attr_accessor :hptype 
  attr_accessor :hptypeflag 
end

class Battle::Battler
  def hptype;          return @pokemon ? @pokemon.hptype : 0;          end  	
  def hptypeflag;          return @pokemon ? @pokemon.hptypeflag : false;          end  	
end

# NOTE: This allows Hidden Power to be Fairy-type (if you have that type in your
#       game). I don't care that the official games don't work like that.
def pbHiddenPower(pkmn)
  iv = pkmn.iv
  idxType = 0
  power = 60
  types = []
  GameData::Type.each do |t|
    types[t.icon_position] ||= []
    types[t.icon_position].push(t.id) if !t.pseudo_type && ![:NORMAL, :SHADOW].include?(t.id)
  end
  types.flatten!.compact!
  #idxType = pkmn.hptype
  type = pkmn.hptype
  if Settings::MECHANICS_GENERATION <= 5
    powerMin = 30
    powerMax = 70
    power |= (iv[:HP] & 2) >> 1
    power |= (iv[:ATTACK] & 2)
    power |= (iv[:DEFENSE] & 2) << 1
    power |= (iv[:SPEED] & 2) << 2
    power |= (iv[:SPECIAL_ATTACK] & 2) << 3
    power |= (iv[:SPECIAL_DEFENSE] & 2) << 4
    power = powerMin + ((powerMax - powerMin) * power / 63)
  end
  return [type, power]
end 


#===============================================================================
# Instances of this class are individual Pokémon.
# The player's party Pokémon are stored in the array $player.party.
#===============================================================================
class Pokemon
  attr_writer :hptype 
   
  # The hidden power type is now a separate attribute of the Pokemon.
  def hptype
    if !@hptype
      types = []
      GameData::Type.each do |t|
        types.push(t.id) if !t.pseudo_type && ![:PLAGUE, :SHADOW].include?(t.id)
      end
    @hptype=types.sample
    end
    return @hptype
  end
  
  # The flag that indicates a Pokemon has had its hidden power type altered.
  def hptypeflag
    if !@hptypeflag
      @hptypeflag = false
    end
    return @hptypeflag
  end  
  
  # Set the flag that indicates a Pokemon has had its hidden power type altered.
  def sethptypeflag
    @hptypeflag=true
  end  
end

  
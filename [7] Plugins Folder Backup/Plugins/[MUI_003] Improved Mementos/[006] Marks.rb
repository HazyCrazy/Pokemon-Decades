#===============================================================================
# Mark generation.
#===============================================================================
# Functions for getting certain Marks of a particular group.
#-------------------------------------------------------------------------------
def pbGetPersonalityMark
  personalities = []
  GameData::Ribbon.each { |m| personalities.push(m.id) if m.is_mark? && m.is_personality_mark? }
  return personalities.sample
end

def pbGetTimeMark
  if PBDayNight.isMorning?      then return :DAWNMARK
  elsif PBDayNight.isAfternoon? then return :LUNCHTIMEMARK
  elsif PBDayNight.isEvening?   then return :DUSKMARK
  elsif PBDayNight.isNight?     then return :SLEEPYTIMEMARK
  end
end

def pbGetWeatherMark
  case $game_screen.weather_type
  when :Rain, :HeavyRain then return :RAINYMARK
  when :Storm            then return :STORMYMARK
  when :Snow             then return :SNOWYMARK
  when :Blizzard         then return :BLIZZARDMARK
  when :Sandstorm        then return :SANDSTORMMARK
  when :Sun              then return :DRYMARK
  when :Fog              then return :MISTYMARK
  # Cloudy weather doesn't exist in Essentials by defalt. Must be added to generate this mark.
  when :Cloudy           then return :CLOUDYMARK
  end
end


#-------------------------------------------------------------------------------
# Generates appropriate Marks on wild Pokemon.
#-------------------------------------------------------------------------------
class Game_Temp
  attr_accessor :used_sweet_scent
  alias mark_initialize initialize
  def initialize
    mark_initialize
    @used_sweet_scent = false
  end
end

alias mark_pbSweetScent pbSweetScent
def pbSweetScent
  $game_temp.used_sweet_scent = true
  mark_pbSweetScent
  $game_temp.used_sweet_scent = false
end

alias mark_pbGenerateWildPokemon pbGenerateWildPokemon
def pbGenerateWildPokemon(species, level, isRoamer = false)
  genwildpoke = mark_pbGenerateWildPokemon(species, level, isRoamer)
  pbApplyWildMarks(genwildpoke) if !isRoamer
  return genwildpoke
end

def pbApplyWildMarks(pokemon)
  mark = nil
  mark_attempts = 1
  mark_attempts += 2 if $bag.has?(:MARKCHARM)
  ratio = Settings::BASE_MARK_GENERATION_RATIO
  mark_attempts.times do |i|
    break if mark
    if rand(ratio * 20) == 0
      mark = :RAREMARK             # Checks for Rare Mark.
    elsif rand(ratio * 2) == 0
      mark = pbGetPersonalityMark  # Checks for random Personality Mark.
    elsif rand(ratio) == 0
      mark = :UNCOMMONMARK         # Checks for Uncommon Mark.
    elsif rand(ratio) == 0 && $game_screen.weather_type != :None
      mark = pbGetWeatherMark      # Checks for Weather Mark based on the weather of the current map.
    elsif rand(ratio) == 0
      mark = pbGetTimeMark         # Checks for Time Mark based on the current time of day.
    elsif rand(ratio / 2).floor == 0 && $game_temp.encounter_type && 
          GameData::EncounterType.get($game_temp.encounter_type).type == :fishing
      mark = :FISHINGMARK          # Checks for Fishing Mark if a fishing encounter.
    elsif $game_temp.used_sweet_scent && rand(ratio / 2).floor == 0
      mark = :CURRYMARK            # Checks for Curry Mark if luring Pokemon with Sweet Scent/Honey.
    elsif $player.is_anniversary? && rand(ratio / 2).floor == 0
      mark = :DESTINYMARK          # Checks for Destiny Mark if it's the player's birthday.
    end
  end
  pokemon.giveMemento(mark) if mark
end


#-------------------------------------------------------------------------------
# Generates Partner Mark on party Pokemon with high happiness while walking.
#-------------------------------------------------------------------------------
class PokemonGlobalMetadata
  attr_accessor :partnerSteps
  
  alias mark_initialize initialize
  def initialize
    mark_initialize
    @partnerSteps = 0
  end
end

EventHandlers.add(:on_player_step_taken, :partner_mark,
  proc {
    $PokemonGlobal.partnerSteps = 0 if !$PokemonGlobal.partnerSteps
    $PokemonGlobal.partnerSteps += 1
    next if $PokemonGlobal.partnerSteps < 10000
    odds = ($bag.has?(:MARKCHARM)) ? 1 : 2
    $player.able_party.each do |pkmn|
      next if pkmn.happiness < 200
      next if pkmn.hasMemento?(:PARTNERMARK)
      next if rand(Settings::BASE_MARK_GENERATION_RATIO * odds) > 0
      pkmn.giveMemento(:PARTNERMARK)
    end
    $PokemonGlobal.partnerSteps = 0
  }
)


#-------------------------------------------------------------------------------
# Generates Itemfinder Mark on lead Pokemon while finding items in the overworld.
#-------------------------------------------------------------------------------
alias mark_pbItemBall pbItemBall
def pbItemBall(item, quantity = 1)
  ret = mark_pbItemBall(item, quantity)
  if ret
    pkmn = $player.first_able_pokemon
    odds = ($bag.has?(:MARKCHARM)) ? 1 : 2
    if pkmn && !pkmn.hasMemento?(:ITEMFINDERMARK) &&
       rand(Settings::BASE_MARK_GENERATION_RATIO * odds) == 0
      pkmn.giveMemento(:ITEMFINDERMARK)
    end
  end
  return ret  
end


#-------------------------------------------------------------------------------
# Generates Gourmand Mark on party Pokemon while picking or purchasing berries.
#-------------------------------------------------------------------------------
alias mark_pbPickBerry pbPickBerry
def pbPickBerry(berry, qty = 1)
  ret = mark_pbPickBerry(berry, qty)
  if ret
    odds = ($bag.has?(:MARKCHARM)) ? 4 : 2
    $player.able_party.each do |pkmn|
      next if pkmn.hasMemento?(:GOURMANDMARK)
      next if rand((Settings::BASE_MARK_GENERATION_RATIO / odds).floor) > 0
      pkmn.giveMemento(:GOURMANDMARK)
    end
  end
  return ret
end

class PokemonMartAdapter
  alias mark_addItem addItem
  def addItem(item)
    ret = mark_addItem(item)
    if ret
      itm = GameData::Item.get(item)
      if itm.is_berry?
        odds = ($bag.has?(:MARKCHARM)) ? 4 : 2
        $player.able_party.each do |pkmn|
          next if pkmn.hasMemento?(:GOURMANDMARK)
          next if rand((Settings::BASE_MARK_GENERATION_RATIO / odds).floor) > 0
          pkmn.giveMemento(:GOURMANDMARK)
        end
      end
    end
    return ret
  end
end
#===============================================================================
# Memento data.
#===============================================================================
# Edits GameData::Ribbon to include data for Marks, Titles, and related flags.
#-------------------------------------------------------------------------------
module GameData
  class Ribbon
    attr_reader :prev_ranks
    attr_reader :real_title, :prefix_title
    attr_reader :mark
	
    SCHEMA["Title"]         = [:real_title,   "s"]
    SCHEMA["PrefixTitle"]   = [:prefix_title, "s"]
    SCHEMA["PreviousRanks"] = [:prev_ranks,   "*m"]
    SCHEMA["IsMark"]        = [:mark,         "b"]
	
    alias memento_initialize initialize
    def initialize(hash)
      memento_initialize(hash)
      @real_title   = hash[:prefix_title] || hash[:real_title]
      @prefix_title = !hash[:prefix_title].nil?
      @prev_ranks   = hash[:prev_ranks] || []
      @mark         = hash[:mark]
    end
	
    def title(pkmn = nil)
      return "" if !@real_title
      title = pbGetMessageFromHash(MessageTypes::MEMENTO_TITLES, @real_title)
      if title.include?("/")
        new_title = ""
        split = title.split("/")
        split.each_with_index do |t, i|
          case t
          when "Owner"  then split[i] = pkmn.owner.name if pkmn
          when "Player" then split[i] = $player.name
          else
            if t.include?("Variable_")
              num = t.split("_").last.to_i
              var = $game_variables[num]
              split[i] = var if !nil_or_empty?(var)
            end
          end
          new_title += split[i]
        end
        return _INTL("#{new_title}") if !nil_or_empty?(new_title)
      end
      return title
    end
	
    def title_upcase(pkmn = nil)
      return "" if !@real_title
      title = self.title(pkmn)
      return _INTL("#{title.first.upcase + title[1..title.length]}")
    end
    
    def max_rank
      return 1 + @prev_ranks.length
    end
	  
    #---------------------------------------------------------------------------
    # Flag checks.
    #---------------------------------------------------------------------------
    def is_ribbon?;           return !@mark; end
    def is_contest_ribbon?;   return has_flag?("ContestRibbon");   end
    def is_league_ribbon?;    return has_flag?("LeagueRibbon");    end
    def is_frontier_ribbon?;  return has_flag?("FrontierRibbon");  end
    def is_memorial_ribbon?;  return has_flag?("MemorialRibbon");  end
    def is_gift_ribbon?;      return has_flag?("GiftRibbon");      end
    
    def is_mark?;             return @mark; end
    def is_rarity_mark?;      return has_flag?("RarityMark");      end
    def is_encounter_mark?;   return has_flag?("EncounterMark");   end
    def is_time_mark?;        return has_flag?("TimeMark");        end
    def is_weather_mark?;     return has_flag?("WeatherMark");     end
    def is_personality_mark?; return has_flag?("PersonalityMark"); end
    def is_size_mark?;        return has_flag?("SizeMark");        end
    def is_party_mark?;       return has_flag?("PartyMark");       end
    def is_boss_mark?;        return has_flag?("BossMark");        end
  end
end


#===============================================================================
# Pokemon data.
#===============================================================================
# Adds data for setting size and titles, and improves ribbon code.
#-------------------------------------------------------------------------------
class Pokemon
  attr_accessor :scale
  attr_accessor :memento
  
  #-----------------------------------------------------------------------------
  # Size values.
  #-----------------------------------------------------------------------------
  def scale
    return @scale || 100
  end
  
  def scale=(value)
    @scale = value.clamp(0, 255)
  end
  
  #-----------------------------------------------------------------------------
  # Returns the Pokemon's name & title as a colorized string.
  #-----------------------------------------------------------------------------
  def name_title(withColor = true)
    name = self.name
    if @memento && !shadowPokemon?
      memento = GameData::Ribbon.get(@memento)
      title = memento.title(self)
      return name if nil_or_empty?(title)
      if memento.prefix_title
        full_title = _INTL("{1} {2}", title, name)
      else
        full_title = _INTL("{1} {2}", name, title)
      end
      return full_title if !withColor
      case Settings::TITLE_COLORATION
      when 1 then name = "<c2=043c3aff>#{full_title}</c2>"
      when 2 then name = "<c2=06644bd2>#{full_title}</c2>"
      when 3 then name = "<c2=65467b14>#{full_title}</c2>"
      else        name = "'#{full_title}'"
      end
    end
    return name
  end
  
  #-----------------------------------------------------------------------------
  # Attaches a memento on a Pokemon to confer its title.
  #-----------------------------------------------------------------------------
  def memento=(value)
    return if shadowPokemon?
    memento = GameData::Ribbon.try_get(value)
    @memento = value if value.nil? || (memento && memento.title)
    giveMemento(value) if !@ribbons.include?(value) && @memento == value
  end
  
  #-----------------------------------------------------------------------------
  # Gets a collapsed array of the Pokemon's mementos.
  #-----------------------------------------------------------------------------
  def collapsed_mementos
    mementos = @ribbons.clone
    @ribbons.each_with_index do |r, i|
      prev_ranks = GameData::Ribbon.get(r).prev_ranks
      next if prev_ranks.empty?
      prev_ranks.each { |p| mementos.delete(p) if mementos.include?(p)}
    end
    return mementos
  end
  
  #-----------------------------------------------------------------------------
  # Checks if the Pokemon has any memento of a given type or ID.
  #-----------------------------------------------------------------------------
  def hasMementoType?(filter = nil)
    @ribbons.each do |m|
      memento = GameData::Ribbon.get(m)
      case filter
      when :rank        then return true if memento.max_rank > 1
      when :ribbon      then return true if memento.is_ribbon?
      when :contest     then return true if memento.is_contest_ribbon?
      when :league      then return true if memento.is_league_ribbon?
      when :frontier    then return true if memento.is_frontier_ribbon?
      when :memorial    then return true if memento.is_memorial_ribbon?
      when :gift        then return true if memento.is_gift_ribbon?
      when :mark        then return true if memento.is_mark?
      when :rarity      then return true if memento.is_rarity_mark?
      when :size        then return true if memento.is_size_mark?
      when :time        then return true if memento.is_time_mark?
      when :weather     then return true if memento.is_weather_mark?
      when :personality then return true if memento.is_personality_mark?
      when :boss        then return true if memento.is_boss_mark?
      when Symbol       then return true if memento.id == m
      else              return false
      end
    end
    return false
  end
  
  #-----------------------------------------------------------------------------
  # Gets the current rank of a given memento.
  #-----------------------------------------------------------------------------
  def getMementoRank(memento)
    memento_data = GameData::Ribbon.try_get(memento)
    return 0 if !memento_data
    rank = 1
    memento_data.prev_ranks.each { |p| rank += 1 if @ribbons.include?(p) }
    return [rank, memento_data.max_rank].min
  end
  
  #-----------------------------------------------------------------------------
  # Used for properly giving the Contest Memory and Battle Memory Ribbons.
  #-----------------------------------------------------------------------------
  def giveMemoryRibbon(memento)
    return if !memento
    if memento.is_contest_ribbon?
      if !@ribbons.include?(:CONTESTMEMORYGOLD)
        ranks = GameData::Ribbon.get(:CONTESTMEMORYGOLD).prev_ranks
        if ranks.include?(memento.id)
          max_rank = GameData::Ribbon.get(:CONTESTMEMORYGOLD).max_rank
          if getMementoRank(:CONTESTMEMORYGOLD) >= max_rank
            index = @ribbons.index(:CONTESTMEMORY) || @ribbons.length
            @ribbons[index] = :CONTESTMEMORYGOLD
          else
            index = @ribbons.index(memento.id)
            @ribbons.insert(index, :CONTESTMEMORY) if !@ribbons.include?(:CONTESTMEMORY)
          end
        end
      end
    elsif memento.is_frontier_ribbon?
      if !@ribbons.include?(:BATTLEMEMORYGOLD)
        ranks = GameData::Ribbon.get(:BATTLEMEMORYGOLD).prev_ranks
        if ranks.include?(memento.id)
          max_rank = GameData::Ribbon.get(:BATTLEMEMORYGOLD).max_rank
          if getMementoRank(:BATTLEMEMORYGOLD) >= max_rank
            index = @ribbons.index(:BATTLEMEMORY) || @ribbons.length
            @ribbons[index] = :BATTLEMEMORYGOLD
          else
            index = @ribbons.index(memento.id)
            @ribbons.insert(index, :BATTLEMEMORY) if !@ribbons.include?(:BATTLEMEMORY)
          end
        end
      end
    end
  end
  
  #-----------------------------------------------------------------------------
  # Aliases & edits of existing Ribbon code.
  #-----------------------------------------------------------------------------
  alias numMementos numRibbons
  alias hasMemento? hasRibbon?
  alias upgradeMemento upgradeRibbon
  
  def giveRibbon(ribbon)
    case ribbon
    when :CONTESTMEMORY then return if @ribbons.include?(:CONTESTMEMORYGOLD)
    when :BATTLEMEMORY  then return if @ribbons.include?(:BATTLEMEMORYGOLD)
    end
    ribbon_data = GameData::Ribbon.try_get(ribbon)
    return if !ribbon_data || @ribbons.include?(ribbon_data.id)
    @ribbons.push(ribbon_data.id)
    giveMemoryRibbon(ribbon_data)
    if Settings::AUTO_SET_TITLES && !@memento && ribbon_data.title
      @memento = ribbon 
    end
  end
  alias giveMemento giveRibbon
  
  def takeRibbon(ribbon)
    ribbon_data = GameData::Ribbon.try_get(ribbon)
    return if !ribbon_data
    @ribbons.delete_at(@ribbons.index(ribbon_data.id))
    @memento = nil if @memento == ribbon
  end
  alias takeMemento takeRibbon
  
  def clearAllRibbons
    @ribbons.clear
    @memento = nil
  end
  alias clearAllMementos clearAllRibbons
  
  #-----------------------------------------------------------------------------
  # Initializes size and memento data.
  #-----------------------------------------------------------------------------
  alias memento_initialize initialize  
  def initialize(*args)
    memento_initialize(*args)
    @memento = nil
    @scale = rand(256)
    if Settings::GUARANTEED_WILD_SIZE_MARKS
      case @scale
      when 0   then giveMemento(:MINIMARK)
      when 255 then giveMemento(:JUMBOMARK)
      end
    end
  end
end


#===============================================================================
# Player data.
#===============================================================================
# Adds data for the player's birthday. Used for the Destiny Mark.
#-------------------------------------------------------------------------------
class Player < Trainer
  def birthdate
    return @birthdate || $PokemonGlobal.startTime
  end
  
  def setBirthdate(day, month, year = nil)
    year = Time.now.year - 1 if !year
    @birthdate = Time.new(year, month, day)
  end
  
  def is_anniversary?(date = nil)
    time = pbGetTimeNow
    date = $player.birthdate if !date
    return time.day == date.day && time.mon == date.mon && time.year > date.year
  end
end

def pbSetPlayerBirthday
  months = []
  mon = day = 1
  12.times { |i| months.push(_INTL("{1}", pbGetMonthName(i + 1))) }
  loop do
    mon = pbMessage(_INTL("Which month is your birthday in?"), months) + 1
    maxval = ([4, 6, 9, 11].include?(mon)) ? 30 : (mon == 2) ? 28 : 31
    params = ChooseNumberParams.new
    params.setRange(1, maxval)
    params.setInitialValue(1)
    params.setCancelValue(1)
    day = pbMessageChooseNumber(_INTL("Which day in {1} is your birthday?", pbGetMonthName(mon)), params)
    case day.to_s.last
    when "1" then suffix = (day != 11) ? "st" : "th"
    when "2" then suffix = (day != 12) ? "nd" : "th"
    when "3" then suffix = (day != 13) ? "rd" : "th"
    else          suffix = "th"
    end
    break if pbConfirmMessage(_INTL("So, your birthday is {1} {2}{3}, correct?", pbGetMonthName(mon), day, suffix))
  end
  $player.setBirthdate(day, mon)
end
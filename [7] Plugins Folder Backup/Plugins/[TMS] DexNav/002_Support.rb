#===============================================================================
# Support Class
# ===============================================================================

class PokemonIconSprite < Sprite
  attr_accessor :selected
  attr_accessor :active
  attr_reader   :pokemon

  # Time in seconds for one animation cycle of this Pokémon icon. It is doubled
  # if the Pokémon is at 50% HP or lower, and doubled again if it is at 25% HP
  # or lower. The icon doesn't animate at all if the Pokémon is fainted.
  ANIMATION_DURATION = 0.25

  def initialize(pokemon, viewport = nil)
    super(viewport)
    @selected      = false
    @active        = false
    @frames_count  = 0
    @current_frame = 0
    self.pokemon   = pokemon
    @logical_x     = 0   # Actual x coordinate
    @logical_y     = 0   # Actual y coordinate
    @adjusted_x    = 0   # Offset due to "jumping" animation in party screen
    @adjusted_y    = 0   # Offset due to "jumping" animation in party screen
  end

  def dispose
    @animBitmap&.dispose
    super
  end

  def x; return @logical_x; end
  def y; return @logical_y; end

  def x=(value)
    @logical_x = value
    super(@logical_x + @adjusted_x)
  end

  def y=(value)
    @logical_y = value
    super(@logical_y + @adjusted_y)
  end

  def pokemon=(value)
    @pokemon = value
    @animBitmap&.dispose
    @animBitmap = nil
    if !@pokemon || @pokemon.nil?
      @animBitmap = AnimatedBitmap.new("Graphics/Pokemon/Icons/000")
    else
      @animBitmap = AnimatedBitmap.new(GameData::Species.icon_filename_from_pokemon(value))
    end
    self.bitmap = @animBitmap.bitmap
    self.src_rect.width  = @animBitmap.height
    self.src_rect.height = @animBitmap.height
    @frames_count = @animBitmap.width / @animBitmap.height
    @current_frame = 0 if @current_frame >= @frames_count
    changeOrigin
  end

  def setOffset(offset = PictureOrigin::CENTER)
    @offset = offset
    changeOrigin
  end

  def changeOrigin
    return if !self.bitmap
    @offset = PictureOrigin::TOP_LEFT if !@offset
    case @offset
    when PictureOrigin::TOP_LEFT, PictureOrigin::LEFT, PictureOrigin::BOTTOM_LEFT
      self.ox = 0
    when PictureOrigin::TOP, PictureOrigin::CENTER, PictureOrigin::BOTTOM
      self.ox = self.src_rect.width / 2
    when PictureOrigin::TOP_RIGHT, PictureOrigin::RIGHT, PictureOrigin::BOTTOM_RIGHT
      self.ox = self.src_rect.width
    end
    case @offset
    when PictureOrigin::TOP_LEFT, PictureOrigin::TOP, PictureOrigin::TOP_RIGHT
      self.oy = 0
    when PictureOrigin::LEFT, PictureOrigin::CENTER, PictureOrigin::RIGHT
      # NOTE: This assumes the top quarter of the icon is blank, so oy is placed
      #       in the middle of the lower three quarters of the image.
      self.oy = self.src_rect.height * 5 / 8
    when PictureOrigin::BOTTOM_LEFT, PictureOrigin::BOTTOM, PictureOrigin::BOTTOM_RIGHT
      self.oy = self.src_rect.height
    end
  end

  def update_frame
    duration = ANIMATION_DURATION
    @current_frame = (@frames_count * (System.uptime % duration) / duration).floor
  end

  def update
    return if !@animBitmap
    super
    @animBitmap.update
    self.bitmap = @animBitmap.bitmap
    # Update animation
    update_frame
    self.src_rect.x = self.src_rect.width * @current_frame
    # Update "jumping" animation (used in party screen)
    if @selected
      @adjusted_x = 4
      @adjusted_y = (@current_frame >= @frames_count / 2) ? -2 : 6
    else
      @adjusted_x = 0
      @adjusted_y = 0
    end
    self.x = self.x
    self.y = self.y
  end
end

#===============================================================================
# Constant
# ===============================================================================

module Constant
  TEXTS = {
    :DexNav => {
      :text => _INTL("DexNav"),
      :x => 4,
      :y => 8,
      :align => 0, # 0 = left, 1 = right, 2 = center
      :color => Color.new(255, 255, 255),
      :shadow_color => Color.new(180, 180, 180),
      :to_print => true
    },
    :DexNavFalse => {
      :text => _INTL("DexNav"),
      :x => 4,
      :y => 8,
      :align => 0,
      :color => Color.new(255, 255, 255),
      :shadow_color => Color.new(180, 180, 180),
      :to_print => false
    },
    :LandLabel => {
      :text => _INTL("Land"),
      :x => 12,
      :y => 220,
      :align => 0,
      :color => Color.new(255, 255, 255),
      :shadow_color => Color.new(100, 100, 100),
      :to_print => true
    },
    :WaterLabel => {
      :text => _INTL("Water"),
      :x => 12,
      :y => 44,
      :align => 0,
      :color => Color.new(255, 255, 255),
      :shadow_color => Color.new(100, 100, 100),
      :to_print => false
    },
    :LandLabelFalse => {
      :text => _INTL("Land - Action to change"),
      :x => 12,
      :y => 220,
      :align => 0,
      :color => Color.new(255, 255, 255),
      :shadow_color => Color.new(100, 100, 100),
      :to_print => false
    },
    :WaterLabelFalse => {
      :text => _INTL("Water - Action to change"),
      :x => 12,
      :y => 44,
      :align => 0,
      :color => Color.new(255, 255, 255),
      :shadow_color => Color.new(100, 100, 100),
      :to_print => true
    },
  }
  TEXTS_SMALL = {
    :SearchLevel => {
      :text => _INTL("Search Level"),
      :x => 347,
      :y => 96,
      :align => 0,
      :color => Color.new(255, 255, 255),
      :shadow_color => nil
    },
    :Method => {
      :text => _INTL("Method"),
      :x => 347,
      :y => 156,
      :align => 0,
      :color => Color.new(255, 255, 255),
      :shadow_color => nil
    },
    :Ability => {
      #:text => _INTL("Hidden Ability"),
	  :text => _INTL("Abilities"),
      :x => 347,
      :y => 215,
      :align => 0,
      :color => Color.new(255, 255, 255),
      :shadow_color => nil
    },
    :Item => {
      :text => _INTL("Item"),
      :x => 347,
      :y => 274,
      :align => 0,
      :color => Color.new(255, 255, 255),
      :shadow_color => nil
    }
  }

  ENCOUNTER_LAND = {
    :Land => [:LandDay, :LandNight, :LandMorning, :LandAfternoon, :LandEvening],
    :Cave => [:CaveDay, :CaveNight, :CaveMorning, :CaveAfternoon, :CaveEvening]
  }
  ENCOUNTER_WATER = {
    :Water => [:WaterDay, :WaterNight, :WaterMorning, :WaterAfternoon, :WaterEvening],
  }
  TYPES_NUMBERS = {
    :NORMAL => 0,
    :FIGHTING => 1,
    :FLYING => 2,
    :POISON => 3,
    :GROUND => 4,
    :ROCK => 5,
    :BUG => 6,
    :GHOST => 7,
    :STEEL => 8,
    :UNKNOWN => 9,
    :FIRE => 10,
    :WATER => 11,
    :GRASS => 12,
    :ELECTRIC => 13,
    :PSYCHIC => 14,
    :ICE => 15,
    :DRAGON => 16,
    :DARK => 17,
    :FAIRY => 18,
    :STELLAR => 19
  }
end

class DexNavMapData
  attr_accessor :species_list
  attr_reader   :coords
  attr_accessor :max_steps
  attr_accessor :active_species
  attr_reader   :active_chain
  attr_accessor :active_species_level
  attr_accessor :in_battle
  attr_reader   :info
  attr_reader   :battler
  attr_reader   :is_grass

  def initialize
    @species_list = Hash.new(0) # Hash to store species and their chain level
    @coords = []
    @max_steps = 0
    @active_species = nil
    @active_species_level = 1
    @in_battle = false
    @active_chain = 0
    reset_info
    @battler = nil
    @is_grass = true
  end

  def reset_info
    @info = {
      :item => nil,
      :ability => nil,
      :IVs => 0,
      :egg_moves => nil
    }
  end

  def set_active_species(species, max_steps = 15, is_grass = true)
    levelScalePlugin = PluginManager.installed?("Automatic Level Scaling")
    reset_active_chain if @active_species != species
    @active_species = species
    if levelScalePlugin
      @active_species_level = AutomaticLevelScaling.getScaledLevel
    else
      @active_species_level = get_enc_level
    end
    @max_steps = max_steps
    @is_grass = is_grass
  end

  def increase_active_chain
    @active_chain += 1 if @active_chain < Settings::DEXNAX_MAX_CHAIN_VALUE
  end

  def reset_active_chain
    @active_chain = 0
  end

  def set_coords(coords)
    @coords = [coords[0], coords[1]]
  end

  def increase_search_level(species = @active_species)
    return if species.nil?
    @species_list[species] += 1 if @species_list[species] < Settings::DEXNAX_MAX_SEARCH_LEVEL_VALUE
  end

  def are_right_coords?(coords)
    return false if @coords.empty?
    return @coords[0] == coords[0] && @coords[1] == coords[1]
  end

  def decrease_step
    @max_steps -= 1
    if @max_steps <= 0
      @coords = []
      MyOverlayModule.pbEndMyOverlay
      pbMessage(_INTL("The Pokémon ran away!"))
      pbWait(0.5)
    end
  end

  def set_inactive
    @max_steps = 0
    @coords = []
    @in_battle = false
    @battler = nil
    reset_info
  end

  def is_active?
    return !@coords.empty? && @max_steps > 0 && !@active_species.nil?
  end

  def prepare_battler
    return nil unless is_active?
    pkmn = Pokemon.new(@active_species, @active_species_level)
    return nil if pkmn.nil?
    pkmn.shiny = true if rand(2000) < (get_chain_level + @active_chain + 1)
    #battler_set_ability(pkmn)
    #battler_set_egg_move(pkmn)
    battler_set_item(pkmn)
    #battler_perfects_IVs(pkmn)
    @battler = pkmn
  end

  def battler_set_ability(pkmn)
    abilities = pkmn.species_data.abilities
    if $player.pokedex.owned?(@active_species)
      hidden = pkmn.species_data.hidden_abilities
      abilities.push(hidden[0]) if !hidden.nil? && !hidden.empty?
    end
    pkmn.ability = abilities.sample
    @info[:ability] = pkmn.ability.name
  end

  def battler_set_egg_move(pkmn)
    egg_moves = pkmn.species_data.egg_moves
    if !egg_moves.empty? && @active_chain > Settings::DEXNAX_MIN_CHAIN_EGG_MOVES
      if rand(100) < (get_chain_level + @active_chain + 1)
        move = egg_moves.sample
        pkmn.learn_move(move)
        @info[:egg_moves] = move
      end
    end
  end

  def battler_perfects_IVs(pkmn)
    stats = [:HP, :ATTACK, :DEFENSE, :SPECIAL_ATTACK, :SPECIAL_DEFENSE, :SPEED]
    if @active_chain >= Settings::DEXNAX_MIN_CHAIN_THREE_IVS
      if rand(500) < (get_chain_level + @active_chain + 50) # 10% chance for three perfect IV
        stats.sample(3).each do |stat|
          pkmn.iv[stat] = 31
        end
        @info[:IVs] = 3
      end
    elsif @active_chain >= Settings::DEXNAX_MIN_CHAIN_TWO_IVS
      if rand(500) < (get_chain_level + @active_chain + 125) # 25% chance for two perfect IV
        stats.sample(2).each do |stat|
          pkmn.iv[stat] = 31
        end
        @info[:IVs] = 2
      end
    elsif @active_chain >= Settings::DEXNAX_MIN_CHAIN_ONE_IVS
      if rand(500) < (get_chain_level + @active_chain + 250) # 50% chance for one perfect IV
        pkmn.iv[stats.sample] = 31
      end
      @info[:IVs] = 1
    end
  end

  def battler_set_item(pkmn)
    item_common = pkmn.species_data.wild_item_common
    item_uncommon = pkmn.species_data.wild_item_uncommon
    item_rare = pkmn.species_data.wild_item_rare
    if !item_common.nil? && !item_common.empty? && item_common == item_uncommon && item_common == item_rare
      pkmn.item = item_common[0]
    elsif rand(500) < (get_chain_level + @active_chain + 5) # 1% chance for a rare item that increases with the chain level
      pkmn.item = item_rare[0] if !item_rare.nil? && !item_rare.empty?
    elsif rand(500) < (get_chain_level + @active_chain + 50) # 10% chance for an uncommon item that increases with the chain level
      pkmn.item = item_uncommon[0] if !item_uncommon.nil? && !item_uncommon.empty?
    elsif rand(500) < (get_chain_level + @active_chain + 250) # 50% chance for a common item that increases with the chain level
      pkmn.item = item_common[0] if !item_common.nil? && !item_common.empty?
    end
    @info[:item] = pkmn.item unless pkmn.item.nil?
  end

  def get_info
    item = @active_chain > 2 ? @info[:item] : nil
    return DexNavInfo.new(@active_species,@info[:egg_moves], @info[:ability], @info[:IVs], item)
  end

  def get_str_info
    return "" if @info[:ability].nil?
    info_text = "Found!"
    info_text += "\\nWith one item." if @info[:item]
    info_text += "\\nAbility: " + @info[:ability].to_s.capitalize if @info[:ability]
    info_text += "\\nWith " + @info[:IVs].to_s + " Perfect IVs" if @info[:IVs] > 0
    info_text += "\\nEgg Moves: " + @info[:egg_moves].to_s.capitalize if @info[:egg_moves]
    return info_text
  end

  def get_chain_level(species = @active_species)
    return  @species_list[species]
  end

  def get_enc_level
    map_id = $game_map.map_id
    encounterData = GameData::Encounter.get(map_id, $PokemonGlobal.encounter_version)
    unless encounterData.nil?
      encounterTables = Marshal.load(Marshal.dump(encounterData.types))
      encounterTables.each do |type, enc|
        next if enc.empty?
        enc.each do |encounter|
          next if encounter[1] != @active_species
          return rand(encounter[2]..encounter[3]) if encounter[2] && encounter[3]
        end
      end
    end
    return 1
  end

  def debug_print
    Console.echo_warn(_INTL("Max Steps: {1}; Coords {2},{3}; Active species: {4}", @max_steps, @coords[0], @coords[1], @active_species))
    Console.echo_warn(_INTL("Battler {1}", @battler.name))
  end
end

def safeAccessDexNav
  dexnav = $game_variables[Settings::DEXNAX_GLOBAL_STORAGE_VARIABLE_ID]
  if dexnav.nil? || dexnav == 0
    dexnav = DexNavMapData.new
    $game_variables[Settings::DEXNAX_GLOBAL_STORAGE_VARIABLE_ID] = dexnav
  end
  return dexnav
end
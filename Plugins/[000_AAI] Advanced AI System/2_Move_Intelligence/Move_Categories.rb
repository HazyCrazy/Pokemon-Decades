#===============================================================================
# [014] Move Categories - 900+ Move Classification
#===============================================================================
# Categorizes all Moves for intelligent AI decisions
#
# Categories:
# - Priority Moves (Quick Attack, Aqua Jet, Mach Punch, etc.)
# - Setup Moves (Swords Dance, Nasty Plot, Dragon Dance, etc.)
# - Hazard Moves (Stealth Rock, Spikes, Sticky Web, etc.)
# - Healing Moves (Roost, Recover, Synthesis, etc.)
# - OHKO Moves (Fissure, Guillotine, Sheer Cold, etc.)
# - Spread Moves (Earthquake, Surf, Rock Slide, etc.)
# - Protect Moves (Protect, Detect, Spiky Shield, etc.)
# - Status Moves (Will-O-Wisp, Thunder Wave, Toxic, etc.)
# - Screen Moves (Light Screen, Reflect, Aurora Veil, etc.)
# - Weather Moves (Rain Dance, Sunny Day, Sandstorm, etc.)
# - Terrain Moves (Electric Terrain, Grassy Terrain, etc.)
# - Pivot Moves (U-turn, Volt Switch, Flip Turn, etc.)
#===============================================================================

module AdvancedAI
  module MoveCategories
    
    #===========================================================================
    # Priority Move Detection
    #===========================================================================
    PRIORITY_MOVES = [
      # +5 Priority
      :HELPINGHAND,
      
      # +4 Priority
      :MAGICCOAT, :SNATCH,
      
      # +3 Priority
      :FAKEOUT, :SPOTLIGHT, :FOLLOWME, :RAGEPOWDER,
      
      # +2 Priority
      :EXTREMESPEED, :FEINT, :FIRSTIMPRESSION,
      
      # +1 Priority
      :ACCELEROCK, :AQUAJET, :BABYDOLLEYES, :BULLETPUNCH, :ICESHARD,
      :JETPUNCH, :MACHPUNCH, :QUICKATTACK, :SHADOWSNEAK, :SUCKERPUNCH,
      :VACUUMWAVE, :WATERSHURIKEN,
      
      # Prankster-affected (status moves with Prankster)
      :THUNDERWAVE, :WILLOWISP, :TOXIC, :SPORE, :SLEEPPOWDER,
      :STUNSPORE, :TAUNT, :ENCORE, :DISABLE, :LIGHTSCREEN,
      :REFLECT, :AURORAVEIL, :TAILWIND, :TRICKROOM,
    ]
    
    #===========================================================================
    # Setup Move Detection (Stat Boosts)
    #===========================================================================
    SETUP_MOVES = {
      # +2 Attack
      :SWORDSDANCE    => { stat: :attack, stages: 2 },
      :BULKUP         => { stat: :attack_defense, stages: 1 },
      :CURSE          => { stat: :attack_defense, stages: 1, speed: -1 },
      :COIL           => { stat: :attack_defense_accuracy, stages: 1 },
      :HONECLAWS      => { stat: :attack_accuracy, stages: 1 },
      :HOWL           => { stat: :attack, stages: 1 },
      :MEDITATE       => { stat: :attack, stages: 1 },
      :POWERUPPUNCH   => { stat: :attack, stages: 1, damage: true },
      :SHARPEN        => { stat: :attack, stages: 1 },
      
      # +2 Special Attack
      :NASTYPLOT      => { stat: :spatk, stages: 2 },
      :TAILGLOW       => { stat: :spatk, stages: 3 },
      :GEOMANCY       => { stat: :spatk_spdef_speed, stages: 2, charge: true },
      :GROWTH         => { stat: :attack_spatk, stages: 1 },
      :CHARGEBEAM     => { stat: :spatk, stages: 1, damage: true },
      :FIERYDANCE     => { stat: :spatk, stages: 1, damage: true },
      :METEORBEAM     => { stat: :spatk, stages: 1, charge: true },
      
      # +2 Defense
      :IRONDEFENSE    => { stat: :defense, stages: 2 },
      :ACIDARMOR      => { stat: :defense, stages: 2 },
      :BARRIER        => { stat: :defense, stages: 2 },
      :COTTONGUARD    => { stat: :defense, stages: 3 },
      :DEFENDORDER    => { stat: :defense, stages: 1 },
      :HARDEN         => { stat: :defense, stages: 1 },
      :STOCKPILE      => { stat: :defense_spdef, stages: 1 },
      :WITHDRAW       => { stat: :defense, stages: 1 },
      
      # +2 Special Defense
      :AMNESIA        => { stat: :spdef, stages: 2 },
      :CALMMIND       => { stat: :spatk_spdef, stages: 1 },
      
      # +2 Speed
      :AGILITY        => { stat: :speed, stages: 2 },
      :AUTOTOMIZE     => { stat: :speed, stages: 2 },
      :ROCKPOLISH     => { stat: :speed, stages: 2 },
      :DRAGONDANCE    => { stat: :attack_speed, stages: 1 },
      :QUIVERDANCE    => { stat: :spatk_spdef_speed, stages: 1 },
      :SHIFTGEAR      => { stat: :attack_speed, stages: 1, speed_extra: 1 },
      :FLAMECHARGE    => { stat: :speed, stages: 1, damage: true },
      
      # Multi-Stat
      :SHELLSMASH     => { stat: :attack_spatk_speed, stages: 2, defense_spdef: -1 },
      :VICTORYDANCE   => { stat: :attack_defense_speed, stages: 1 },
      :COIL           => { stat: :attack_defense_accuracy, stages: 1 },
      :ACUPRESSURE    => { stat: :random, stages: 2 },
      :ANCIENTPOWER   => { stat: :all, stages: 1, damage: true, chance: 10 },
      :OMINOUSWIND    => { stat: :all, stages: 1, damage: true, chance: 10 },
      :SILVERPOWDER   => { stat: :all, stages: 1, damage: true, chance: 10 },
      
      # Evasion
      :DOUBLETEAM     => { stat: :evasion, stages: 1 },
      :MINIMIZE       => { stat: :evasion, stages: 2 },
      
      # Accuracy
      :HONECLAWS      => { stat: :attack_accuracy, stages: 1 },
      
      # Ability-Based Setup
      :BELLYDRUM      => { stat: :attack, stages: 6, hp_cost: 0.5 },
      :NORETREAT      => { stat: :all, stages: 1, trap: true },
    }
    
    #===========================================================================
    # Hazard Move Detection
    #===========================================================================
    HAZARD_MOVES = {
      # Entry Hazards
      :STEALTHROCK    => { type: :entry, damage: :type_based, layers: 1 },
      :SPIKES         => { type: :entry, damage: :fixed, layers: 3 },
      :TOXICSPIKES    => { type: :entry, damage: :poison, layers: 2 },
      :STICKYWEB      => { type: :entry, effect: :speed_drop, layers: 1 },
      :GMAXSTEELSURGE => { type: :entry, damage: :type_based, layers: 1 },
      
      # Hazard Removal
      :RAPIDSPIN      => { type: :removal, damage: true },
      :DEFOG          => { type: :removal, stat_drop: true },
      :COURTCHANGE    => { type: :swap },
      :TIDYUP         => { type: :removal, stat_boost: true },
    }
    
    #===========================================================================
    # Healing Move Detection
    #===========================================================================
    HEALING_MOVES = {
      # 50% HP Recovery
      :RECOVER        => { heal: 0.5 },
      :ROOST          => { heal: 0.5, lose_flying: true },
      :SLACKOFF       => { heal: 0.5 },
      :SOFTBOILED     => { heal: 0.5 },
      :MILKDRINK      => { heal: 0.5 },
      :HEALORDER      => { heal: 0.5 },
      :SHOREUP        => { heal: 0.5, weather_boost: :sandstorm },
      
      # Weather-Based
      :SYNTHESIS      => { heal: 0.5, weather: true },
      :MOONLIGHT      => { heal: 0.5, weather: true },
      :MORNINGSUN     => { heal: 0.5, weather: true },
      
      # Wish (Delayed)
      :WISH           => { heal: 0.5, delayed: true },
      
      # Rest (Full Heal + Sleep)
      :REST           => { heal: 1.0, sleep: true },
      
      # Drain Moves
      :ABSORB         => { heal: 0.5, damage: true },
      :MEGADRAIN      => { heal: 0.5, damage: true },
      :GIGADRAIN      => { heal: 0.5, damage: true },
      :DRAINPUNCH     => { heal: 0.5, damage: true },
      :DRAININGKISS   => { heal: 0.75, damage: true },
      :LEECHLIFE      => { heal: 0.5, damage: true },
      :PARABOLICCHARGE => { heal: 0.5, damage: true, spread: true },
      :OBLIVIONWING   => { heal: 0.75, damage: true },
      :STRENGTHSAP    => { heal: :opponent_attack, stat_drop: true },
      
      # Passive Healing
      :AQUARING       => { heal: 0.0625, per_turn: true },
      :INGRAIN        => { heal: 0.0625, per_turn: true, trap: true },
      :LEECHSEED      => { heal: 0.125, per_turn: true, opponent_damage: true },
    }
    
    #===========================================================================
    # OHKO Move Detection
    #===========================================================================
    OHKO_MOVES = [
      :FISSURE,       # Ground-type
      :GUILLOTINE,    # Normal-type
      :HORNDRILL,     # Normal-type
      :SHEERCOLD,     # Ice-type
    ]
    
    #===========================================================================
    # Spread Move Detection (hits multiple targets in Doubles/Triples)
    #===========================================================================
    SPREAD_MOVES = [
      # Damaging Spread
      :EARTHQUAKE, :SURF, :DISCHARGE, :LAVAPLUME, :BLIZZARD,
      :ROCKSLIDE, :RAZORLEAF, :ICICLESPEAR, :BULLDOZE, :SNARL,
      :DAZZLINGGLEAM, :HEATWAVE, :PARABOLICCHARGE, :RELICSONG,
      :GLACIATE, :MUDDYWATER, :ORIGINPULSE, :PRECIPICEBLADES,
      
      # Status Spread
      :SWEETSCENT, :GROWL, :SCREECH, :STRINGSHOT, :SANDATTACK,
      :SMOKESCREEN, :CONFUSERAY, :SUPERSONIC, :LOVELYKISS,
      
      # Self + Ally
      :HEALPULSE, :POLLENPUFF, :FLORALHEALING,
    ]
    
    #===========================================================================
    # Protect Move Detection
    #===========================================================================
    PROTECT_MOVES = {
      :PROTECT        => { priority: 4, bypass: false },
      :DETECT         => { priority: 4, bypass: false },
      :KINGSSHIELD    => { priority: 4, bypass: false, effect: :attack_drop },
      :SPIKYSHIELD    => { priority: 4, bypass: false, effect: :damage },
      :BANEFULBUNKER  => { priority: 4, bypass: false, effect: :poison },
      :OBSTRUCT       => { priority: 4, bypass: false, effect: :defense_drop_2 },
      :SILKTRAP       => { priority: 4, bypass: false, effect: :speed_drop },
      :BURNINGBULWARK => { priority: 4, bypass: false, effect: :burn },
      :ENDURE         => { priority: 4, bypass: false, hp: 1 },
      :QUICKGUARD     => { priority: 3, bypass: false, team: true, priority_only: true },
      :WIDEGUARD      => { priority: 3, bypass: false, team: true, spread_only: true },
      :MATBLOCK       => { priority: 0, bypass: false, team: true, turn: 1 },
      :CRAFTYSHIELD   => { priority: 3, bypass: false, team: true, status_only: true },
    }
    
    #===========================================================================
    # Status Move Detection
    #===========================================================================
    STATUS_MOVES = {
      # Paralysis
      :THUNDERWAVE    => { status: :paralysis, accuracy: 90 },
      :STUNSPORE      => { status: :paralysis, accuracy: 75 },
      :GLARE          => { status: :paralysis, accuracy: 100 },
      :NUZZLE         => { status: :paralysis, damage: true },
      
      # Burn
      :WILLOWISP      => { status: :burn, accuracy: 85 },
      :SACREDFIRE     => { status: :burn, chance: 50, damage: true },
      
      # Poison
      :TOXIC          => { status: :toxic, accuracy: 90 },
      :POISONPOWDER   => { status: :poison, accuracy: 75 },
      :POISONGAS      => { status: :poison, accuracy: 90 },
      
      # Sleep
      :SPORE          => { status: :sleep, accuracy: 100 },
      :SLEEPPOWDER    => { status: :sleep, accuracy: 75 },
      :HYPNOSIS       => { status: :sleep, accuracy: 60 },
      :DARKVOID       => { status: :sleep, accuracy: 50 },
      :YAWN           => { status: :sleep, delayed: true },
      
      # Freeze
      :ICEBEAM        => { status: :freeze, chance: 10, damage: true },
      :BLIZZARD       => { status: :freeze, chance: 10, damage: true },
      
      # Confusion
      :CONFUSERAY     => { status: :confusion, accuracy: 100 },
      :SUPERSONIC     => { status: :confusion, accuracy: 55 },
      :SWEETKISS      => { status: :confusion, accuracy: 75 },
      
      # Infatuation
      :ATTRACT        => { status: :infatuation, accuracy: 100 },
      :CAPTIVATE      => { status: :infatuation, accuracy: 100 },
      
      # Flinch
      :FAKEOUT        => { status: :flinch, damage: true, turn: 1 },
      :AIRSLASH       => { status: :flinch, chance: 30, damage: true },
      :IRONHEAD       => { status: :flinch, chance: 30, damage: true },
    }
    
    #===========================================================================
    # Screen Move Detection
    #===========================================================================
    SCREEN_MOVES = {
      :LIGHTSCREEN    => { type: :special, duration: 5 },
      :REFLECT        => { type: :physical, duration: 5 },
      :AURORAVEIL     => { type: :both, duration: 5, weather: :hail },
      :SAFEGUARD      => { type: :status, duration: 5 },
      :MIST           => { type: :stat_drop, duration: 5 },
      :LUCKYCHANT     => { type: :crit, duration: 5 },
    }
    
    #===========================================================================
    # Weather Move Detection
    #===========================================================================
    WEATHER_MOVES = {
      :SUNNYDAY       => { weather: :sun, duration: 5 },
      :RAINDANCE      => { weather: :rain, duration: 5 },
      :SANDSTORM      => { weather: :sandstorm, duration: 5 },
      :HAIL           => { weather: :hail, duration: 5 },
      :SNOWSCAPE      => { weather: :snow, duration: 5 },  # Gen 9
    }
    
    #===========================================================================
    # Terrain Move Detection
    #===========================================================================
    TERRAIN_MOVES = {
      :ELECTRICTERRAIN => { terrain: :electric, duration: 5 },
      :GRASSYTERRAIN   => { terrain: :grassy, duration: 5 },
      :MISTYTERRAIN    => { terrain: :misty, duration: 5 },
      :PSYCHICTERRAIN  => { terrain: :psychic, duration: 5 },
    }
    
    #===========================================================================
    # Pivot Move Detection (U-turn, Volt Switch, etc.)
    #===========================================================================
    PIVOT_MOVES = [
      :UTURN,         # Bug-type
      :VOLTSWITCH,    # Electric-type
      :FLIPTURN,      # Water-type
      :BATONPASS,     # Passes stat changes
      :PARTINGSHOT,   # Lowers stats + switches
      :TELEPORT,      # -6 priority (escape)
      :CHILLYRECEPTION, # Sets Snow + switches (Gen 9)
      :SHEDTAIL,      # Creates Substitute + switches (Gen 9)
    ]
    
    #===========================================================================
    # Move Category Checking Methods
    #===========================================================================
    
    def self.priority_move?(move_id)
      return false if !move_id
      move_id = move_id.to_sym if move_id.is_a?(String)
      
      # Check list
      return true if PRIORITY_MOVES.include?(move_id)
      
      # Check move data
      move = GameData::Move.try_get(move_id)
      return move && move.priority > 0
    end
    
    def self.setup_move?(move_id)
      return false if !move_id
      move_id = move_id.to_sym if move_id.is_a?(String)
      return SETUP_MOVES.key?(move_id)
    end
    
    def self.hazard_move?(move_id)
      return false if !move_id
      move_id = move_id.to_sym if move_id.is_a?(String)
      return HAZARD_MOVES.key?(move_id)
    end
    
    def self.healing_move?(move_id)
      return false if !move_id
      move_id = move_id.to_sym if move_id.is_a?(String)
      return HEALING_MOVES.key?(move_id)
    end
    
    def self.ohko_move?(move_id)
      return false if !move_id
      move_id = move_id.to_sym if move_id.is_a?(String)
      return OHKO_MOVES.include?(move_id)
    end
    
    def self.spread_move?(move_id)
      return false if !move_id
      move_id = move_id.to_sym if move_id.is_a?(String)
      
      # Check list
      return true if SPREAD_MOVES.include?(move_id)
      
      # Check move data
      move = GameData::Move.try_get(move_id)
      return move && move.target == :AllNearFoes
    end
    
    def self.protect_move?(move_id)
      return false if !move_id
      move_id = move_id.to_sym if move_id.is_a?(String)
      return PROTECT_MOVES.key?(move_id)
    end
    
    def self.status_move?(move_id)
      return false if !move_id
      move_id = move_id.to_sym if move_id.is_a?(String)
      return STATUS_MOVES.key?(move_id)
    end
    
    def self.screen_move?(move_id)
      return false if !move_id
      move_id = move_id.to_sym if move_id.is_a?(String)
      return SCREEN_MOVES.key?(move_id)
    end
    
    def self.weather_move?(move_id)
      return false if !move_id
      move_id = move_id.to_sym if move_id.is_a?(String)
      return WEATHER_MOVES.key?(move_id)
    end
    
    def self.terrain_move?(move_id)
      return false if !move_id
      move_id = move_id.to_sym if move_id.is_a?(String)
      return TERRAIN_MOVES.key?(move_id)
    end
    
    def self.pivot_move?(move_id)
      return false if !move_id
      move_id = move_id.to_sym if move_id.is_a?(String)
      return PIVOT_MOVES.include?(move_id)
    end
    
    # Returns Setup Data (which Stat, by how much)
    def self.get_setup_data(move_id)
      return nil if !move_id
      move_id = move_id.to_sym if move_id.is_a?(String)
      return SETUP_MOVES[move_id]
    end
    
    # Categorizes Move
    def self.categorize_move(move_id)
      categories = []
      return categories if !move_id
      
      categories << :priority if priority_move?(move_id)
      categories << :setup if setup_move?(move_id)
      categories << :hazard if hazard_move?(move_id)
      categories << :healing if healing_move?(move_id)
      categories << :ohko if ohko_move?(move_id)
      categories << :spread if spread_move?(move_id)
      categories << :protect if protect_move?(move_id)
      categories << :status if status_move?(move_id)
      categories << :screen if screen_move?(move_id)
      categories << :weather if weather_move?(move_id)
      categories << :terrain if terrain_move?(move_id)
      categories << :pivot if pivot_move?(move_id)
      
      return categories
    end
    
  end
end

#===============================================================================
# API Wrapper
#===============================================================================
module AdvancedAI
  def self.priority_move?(move_id)
    MoveCategories.priority_move?(move_id)
  end
  
  def self.setup_move?(move_id)
    MoveCategories.setup_move?(move_id)
  end
  
  def self.hazard_move?(move_id)
    MoveCategories.hazard_move?(move_id)
  end
  
  def self.healing_move?(move_id)
    MoveCategories.healing_move?(move_id)
  end
  
  def self.ohko_move?(move_id)
    MoveCategories.ohko_move?(move_id)
  end
  
  def self.spread_move?(move_id)
    MoveCategories.spread_move?(move_id)
  end
  
  def self.protect_move?(move_id)
    MoveCategories.protect_move?(move_id)
  end
  
  def self.pivot_move?(move_id)
    MoveCategories.pivot_move?(move_id)
  end
  
  def self.get_setup_data(move_id)
    MoveCategories.get_setup_data(move_id)
  end
  
  def self.categorize_move(move_id)
    MoveCategories.categorize_move(move_id)
  end
end

#===============================================================================
# [015] Item Intelligence - 693+ Item Analysis
#===============================================================================
# Intelligent Item Recognition and Usage
#
# Categories:
# - Choice Items (Choice Band, Choice Specs, Choice Scarf)
# - Life Orb & Damage Boost Items
# - Assault Vest & Defensive Items
# - Recovery Items (Leftovers, Black Sludge, etc.)
# - Type-Boosting Items (Charcoal, Mystic Water, etc.)
# - Status Items (Flame Orb, Toxic Orb, etc.)
# - Terrain/Weather Extenders
# - Z-Crystals & Mega Stones (DBK Integration)
#===============================================================================

module AdvancedAI
  module ItemIntelligence
    
    #===========================================================================
    # Choice Item Detection (locked into one move)
    #===========================================================================
    CHOICE_ITEMS = {
      :CHOICEBAND   => { stat: :attack, multiplier: 1.5 },
      :CHOICESPECS  => { stat: :spatk, multiplier: 1.5 },
      :CHOICESCARF  => { stat: :speed, multiplier: 1.5 },
    }
    
    #===========================================================================
    # Damage Boost Items
    #===========================================================================
    DAMAGE_BOOST_ITEMS = {
      # Life Orb (1.3x damage, 10% recoil)
      :LIFEORB      => { multiplier: 1.3, recoil: 0.1 },
      
      # Expert Belt (1.2x SE damage)
      :EXPERTBELT   => { multiplier: 1.2, condition: :super_effective },
      
      # Muscle Band / Wise Glasses
      :MUSCLEBAND   => { multiplier: 1.1, category: :physical },
      :WISEGLASSES  => { multiplier: 1.1, category: :special },
      
      # Metronome (stacks per repeated move)
      :METRONOME    => { multiplier: 1.2, stacks: true, max: 2.0 },
      
      # Punching Glove (1.1x punching moves, no contact)
      :PUNCHINGGLOVE => { multiplier: 1.1, moves: :punching, no_contact: true },
      
      # Loaded Dice (multi-hit = 4-5 hits)
      :LOADEDDICE   => { multihit: true, min: 4 },
    }
    
    #===========================================================================
    # Type-Boosting Items (1.2x type damage)
    #===========================================================================
    TYPE_BOOST_ITEMS = {
      :CHARCOAL       => :FIRE,
      :MYSTICWATER    => :WATER,
      :MIRACLESEED    => :GRASS,
      :MAGNET         => :ELECTRIC,
      :NEVERMELTICE   => :ICE,
      :BLACKBELT      => :FIGHTING,
      :POISONBARB     => :POISON,
      :SOFTSAND       => :GROUND,
      :SHARPBEAK      => :FLYING,
      :TWISTEDSPOON   => :PSYCHIC,
      :SILVERPOWDER   => :BUG,
      :HARDSTONE      => :ROCK,
      :SPELLTAG       => :GHOST,
      :DRAGONFANG     => :DRAGON,
      :BLACKGLASSES   => :DARK,
      :METALCOAT      => :STEEL,
      :SILKSCARF      => :NORMAL,
      :PIXIEPLATE     => :FAIRY,
    }
    
    #===========================================================================
    # Plates & Type-Memories (1.2x + Arceus/Silvally form change)
    #===========================================================================
    PLATE_ITEMS = [
      :FLAMEPLATE, :SPLASHPLATE, :MEADOWPLATE, :ZAPPLATE,
      :ICICLEPLATE, :FISTPLATE, :TOXICPLATE, :EARTHPLATE,
      :SKYPLATE, :MINDPLATE, :INSECTPLATE, :STONEPLATE,
      :SPOOKYPLATE, :DRACOPLATE, :DREADPLATE, :IRONPLATE,
      :PIXIEPLATE,
    ]
    
    MEMORY_ITEMS = [
      :BURNINGMEMORY, :WATERMEMORY, :GRASSYMEMORY, :ELECTRICMEMORY,
      :ICYMEMORY, :FIGHTINGMEMORY, :POISONMEMORY, :GROUNDMEMORY,
      :FLYINGMEMORY, :PSYCHICMEMORY, :BUGMEMORY, :ROCKMEMORY,
      :GHOSTMEMORY, :DRAGONMEMORY, :DARKMEMORY, :STEELMEMORY,
      :FAIRYMEMORY,
    ]
    
    #===========================================================================
    # Defensive Items
    #===========================================================================
    DEFENSIVE_ITEMS = {
      # Assault Vest (1.5x SpDef, no status moves)
      :ASSAULTVEST  => { stat: :spdef, multiplier: 1.5, no_status: true },
      
      # Eviolite (1.5x Def/SpDef for NFE Pokemon)
      :EVIOLITE     => { stat: :both, multiplier: 1.5, nfe_only: true },
      
      # Rocky Helmet (1/6 damage on contact)
      :ROCKYHELMET  => { recoil: 0.167, contact: true },
      
      # Focus Sash (survive 1 hit at full HP)
      :FOCUSSASH    => { survive: true, full_hp: true },
      
      # Focus Band (10% chance to survive at 1 HP)
      :FOCUSBAND    => { survive: true, chance: 0.1 },
      
      # Weakness Policy (+2 Atk/SpAtk when hit SE)
      :WEAKNESSPOLICY => { trigger: :super_effective, boost: 2 },
      
      # Air Balloon (Ground immunity until hit)
      :AIRBALLOON   => { immunity: :GROUND, until_hit: true },
      
      # Heavy-Duty Boots (ignore entry hazards)
      :HEAVYDUTYBOOTS => { hazard_immunity: true },
    }
    
    #===========================================================================
    # Recovery Items
    #===========================================================================
    RECOVERY_ITEMS = {
      :LEFTOVERS    => { heal: 0.0625, per_turn: true },
      :BLACKSLUDGE  => { heal: 0.0625, per_turn: true, poison_only: true },
      :SHELLBELL    => { heal: 0.125, on_damage: true },
      :SITRUSBERRY  => { heal: 0.25, trigger: :low_hp },
      :ORANBERRY    => { heal: 10, trigger: :low_hp },
    }
    
    #===========================================================================
    # Status Orbs (Guts/Flame Orb synergy)
    #===========================================================================
    STATUS_ORBS = {
      :FLAMEORB     => { status: :burn, turn: 1 },
      :TOXICORB     => { status: :toxic, turn: 1 },
    }
    
    #===========================================================================
    # Terrain/Weather Extenders
    #===========================================================================
    EXTENDER_ITEMS = {
      :HEATROCK     => { weather: :sun, turns: 3 },
      :DAMPROCK     => { weather: :rain, turns: 3 },
      :SMOOTHROCK   => { weather: :sandstorm, turns: 3 },
      :ICYROCK      => { weather: :hail, turns: 3 },
      :TERRAINEXTENDER => { terrain: :any, turns: 3 },
    }
    
    #===========================================================================
    # Item Detection Methods
    #===========================================================================
    
    def self.choice_item?(item_id)
      return false if !item_id
      item_id = item_id.to_sym if item_id.is_a?(String)
      return CHOICE_ITEMS.key?(item_id)
    end
    
    def self.damage_boost_item?(item_id)
      return false if !item_id
      item_id = item_id.to_sym if item_id.is_a?(String)
      return DAMAGE_BOOST_ITEMS.key?(item_id)
    end
    
    def self.type_boost_item?(item_id)
      return false if !item_id
      item_id = item_id.to_sym if item_id.is_a?(String)
      return TYPE_BOOST_ITEMS.key?(item_id) || PLATE_ITEMS.include?(item_id) || MEMORY_ITEMS.include?(item_id)
    end
    
    def self.defensive_item?(item_id)
      return false if !item_id
      item_id = item_id.to_sym if item_id.is_a?(String)
      return DEFENSIVE_ITEMS.key?(item_id)
    end
    
    def self.recovery_item?(item_id)
      return false if !item_id
      item_id = item_id.to_sym if item_id.is_a?(String)
      return RECOVERY_ITEMS.key?(item_id)
    end
    
    # Calculates Item Damage Multiplier
    def self.calculate_item_multiplier(battler, move)
      return 1.0 if !battler || !move
      item = battler.item_id
      return 1.0 if !item
      
      multiplier = 1.0
      
      # Choice Items
      if CHOICE_ITEMS.key?(item)
        data = CHOICE_ITEMS[item]
        if (data[:stat] == :attack && move.physicalMove?) ||
           (data[:stat] == :spatk && move.specialMove?) ||
           (data[:stat] == :speed)
          multiplier *= data[:multiplier]
        end
      end
      
      # Life Orb
      if item == :LIFEORB
        multiplier *= 1.3
      end
      
      # Expert Belt (SE only)
      if item == :EXPERTBELT
        # Needs target - handle in battle context
      end
      
      # Type-Boost Items
      if TYPE_BOOST_ITEMS.key?(item)
        multiplier *= 1.2 if move.type == TYPE_BOOST_ITEMS[item]
      end
      
      # Muscle Band / Wise Glasses
      if item == :MUSCLEBAND && move.physicalMove?
        multiplier *= 1.1
      elsif item == :WISEGLASSES && move.specialMove?
        multiplier *= 1.1
      end
      
      return multiplier
    end
    
    # Checks if Pokemon is Choice-locked
    def self.choice_locked?(battler)
      return false if !battler
      return false if !battler.item_id
      return false if !choice_item?(battler.item_id)
      
      # Check if already used a move
      return battler.effects[PBEffects::ChoiceBand] if defined?(PBEffects::ChoiceBand)
      return false
    end
    
    # Checks if Assault Vest blocks Status Moves
    def self.blocks_status_moves?(battler)
      return false if !battler
      return battler.item_id == :ASSAULTVEST
    end
    
    # Threat Modifier for Item
    def self.get_item_threat_modifier(battler)
      return 0.0 if !battler
      item = battler.item_id
      return 0.0 if !item
      
      modifier = 0.0
      
      # Choice Items = +1.0 threat (locked but powerful)
      modifier += 1.0 if choice_item?(item)
      
      # Life Orb = +0.8 threat
      modifier += 0.8 if item == :LIFEORB
      
      # Assault Vest = -0.5 threat (defensive)
      modifier -= 0.5 if item == :ASSAULTVEST
      
      # Weakness Policy = +0.5 threat (can be dangerous)
      modifier += 0.5 if item == :WEAKNESSPOLICY
      
      # Focus Sash = -0.3 threat (survives 1 hit)
      modifier -= 0.3 if item == :FOCUSSASH
      
      # Heavy-Duty Boots = -0.2 threat (ignores hazards)
      modifier -= 0.2 if item == :HEAVYDUTYBOOTS
      
      return modifier
    end
    
    #===========================================================================
    # Item Recommendations
    #===========================================================================
    
    # Recommends best item for Pokemon Role
    def self.recommend_item_for_role(pokemon, role)
      return nil if !pokemon || !role
      
      case role
      when :sweeper
        # Hoher Atk/SpAtk → Life Orb oder Choice
        if pokemon.speed >= 100
          return :CHOICESCARF  # Outspeed everything
        elsif pokemon.attack >= pokemon.spatk
          return :CHOICEBAND   # Physical sweeper
        else
          return :CHOICESPECS  # Special sweeper
        end
        
      when :wall
        # Hohe Def/SpDef → Recovery
        return :LEFTOVERS
        
      when :tank
        # Hohe HP + Atk → Assault Vest or Life Orb
        return :ASSAULTVEST
        
      when :support
        # Status moves → Light Clay or Terrain Extender
        return :LIGHTCLAY
        
      when :wallbreaker
        # Extreme offense → Life Orb
        return :LIFEORB
        
      when :pivot
        # U-turn/Volt Switch → Heavy-Duty Boots
        return :HEAVYDUTYBOOTS
        
      when :lead
        # Hazards → Focus Sash
        return :FOCUSSASH
      end
      
      return nil
    end
    
  end
end

#===============================================================================
# API Wrapper
#===============================================================================
module AdvancedAI
  def self.choice_item?(item_id)
    ItemIntelligence.choice_item?(item_id)
  end
  
  def self.choice_locked?(battler)
    ItemIntelligence.choice_locked?(battler)
  end
  
  def self.blocks_status_moves?(battler)
    ItemIntelligence.blocks_status_moves?(battler)
  end
  
  def self.calculate_item_multiplier(battler, move)
    ItemIntelligence.calculate_item_multiplier(battler, move)
  end
  
  def self.get_item_threat_modifier(battler)
    ItemIntelligence.get_item_threat_modifier(battler)
  end
  
  def self.recommend_item_for_role(pokemon, role)
    ItemIntelligence.recommend_item_for_role(pokemon, role)
  end
end

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
      
      # Ability Shield (protects ability from being changed or suppressed)
      :ABILITYSHIELD => { ability_protection: true },
      
      # Shed Shell (guarantees switch-out from trapping)
      :SHEDSHELL    => { trap_escape: true },
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
      
      # Light Ball (Pikachu-exclusive: 2x Atk and SpAtk)
      if item == :LIGHTBALL
        species = battler.respond_to?(:species) ? battler.species : nil
        if species == :PIKACHU || species == :PIKACHUORIGINAL || 
           species == :PIKACHUHOENN || species == :PIKACHUSINNOH ||
           species == :PIKACHUUNOVA || species == :PIKACHUKALOS ||
           species == :PIKACHUALOLA || species == :PIKACHUPARTNER ||
           species == :PIKACHUCOSPLAY
          multiplier *= 2.0  # Doubles both Atk and SpAtk
        end
      end
      
      # Thick Club (Cubone/Marowak-exclusive: 2x Atk)
      if item == :THICKCLUB && move.physicalMove?
        species = battler.respond_to?(:species) ? battler.species : nil
        if [:CUBONE, :MAROWAK, :MAROWAKALOHA].include?(species)
          multiplier *= 2.0  # Doubles Attack stat
        end
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
      
      # Ability Shield = -0.3 threat (protects ability)
      modifier -= 0.3 if item == :ABILITYSHIELD
      
      # Light Ball = +0.8 threat (Pikachu doubles damage)
      modifier += 0.8 if item == :LIGHTBALL
      
      # Thick Club = +0.8 threat (Cubone/Marowak doubles Attack)
      modifier += 0.8 if item == :THICKCLUB
      
      # Shed Shell = -0.2 threat (can always escape trapping)
      modifier -= 0.2 if item == :SHEDSHELL
      
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

    #===========================================================================
    # #18: Additional Item Awareness
    #===========================================================================

    # Utility Umbrella: ignores weather effects on moves/abilities
    def self.has_utility_umbrella?(battler)
      return false unless battler
      item = battler.respond_to?(:item_id) ? battler.item_id : nil
      item == :UTILITYUMBRELLA
    end

    # Type Gems: consume for 1.3x type damage (Gen 5+ = 1.3x, not 1.5x)
    TYPE_GEMS = {
      :NORMALGEM   => :NORMAL,   :FIREGEM    => :FIRE,    :WATERGEM   => :WATER,
      :ELECTRICGEM => :ELECTRIC, :GRASSGEM   => :GRASS,   :ICEGEM     => :ICE,
      :FIGHTINGGEM => :FIGHTING, :POISONGEM  => :POISON,  :GROUNDGEM  => :GROUND,
      :FLYINGGEM   => :FLYING,   :PSYCHICGEM => :PSYCHIC, :BUGGEM     => :BUG,
      :ROCKGEM     => :ROCK,     :GHOSTGEM   => :GHOST,   :DRAGONGEM  => :DRAGON,
      :DARKGEM     => :DARK,     :STEELGEM   => :STEEL,   :FAIRYGEM   => :FAIRY,
    }

    def self.has_type_gem?(battler, move_type = nil)
      return false unless battler
      item = battler.respond_to?(:item_id) ? battler.item_id : nil
      return false unless item && TYPE_GEMS.key?(item)
      return true unless move_type
      TYPE_GEMS[item] == move_type
    end

    # Sticky Barb: damages holder, transfers on contact
    def self.has_sticky_barb?(battler)
      return false unless battler
      item = battler.respond_to?(:item_id) ? battler.item_id : nil
      item == :STICKYBARB
    end

    # Mental Herb: cures Taunt/Encore/Disable/Torment once
    def self.has_mental_herb?(battler)
      return false unless battler
      item = battler.respond_to?(:item_id) ? battler.item_id : nil
      item == :MENTALHERB
    end

    # Ability Shield: protects ability from being changed/suppressed
    def self.has_ability_shield?(battler)
      return false unless battler
      item = battler.respond_to?(:item_id) ? battler.item_id : nil
      item == :ABILITYSHIELD
    end

    # Shed Shell: guarantees switch-out from trapping
    def self.has_shed_shell?(battler)
      return false unless battler
      item = battler.respond_to?(:item_id) ? battler.item_id : nil
      item == :SHEDSHELL
    end

    # Weather extender evaluation: does holder extend weather?
    def self.extends_weather?(battler, weather_type = nil)
      return false unless battler
      item = battler.respond_to?(:item_id) ? battler.item_id : nil
      return false unless item && EXTENDER_ITEMS.key?(item)
      return true unless weather_type
      ext = EXTENDER_ITEMS[item]
      ext[:weather].to_s.downcase == weather_type.to_s.downcase
    end

    # Calculate gem bonus for move scoring
    def self.gem_damage_bonus(battler, move)
      return 0 unless battler && move && move.damagingMove?
      return 0 unless has_type_gem?(battler, move.type)
      # Gem gives 1.3x, translated to ~ +15 score points
      15
    end

    # Score penalty for attacking a Mental Herb holder with Taunt/Encore
    def self.mental_herb_penalty(target, move)
      return 0 unless target && move
      return 0 unless [:TAUNT, :ENCORE, :DISABLE, :TORMENT].include?(move.id)
      return 0 unless has_mental_herb?(target)
      -25  # They'll cure it immediately
    end

    # Score adjustment for Utility Umbrella (weather moves less effective)
    def self.utility_umbrella_penalty(target, move)
      return 0 unless target && move
      return 0 unless has_utility_umbrella?(target)
      # If our move relies on weather (Thunder/Hurricane in Rain, Solar Beam in Sun)
      weather_boosted = [:THUNDER, :HURRICANE, :SOLARBEAM, :SOLARBLADE, :WEATHERBALL, :BLIZZARD]
      return -20 if weather_boosted.include?(move.id)
      0
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

  def self.has_utility_umbrella?(battler)
    ItemIntelligence.has_utility_umbrella?(battler)
  end

  def self.has_type_gem?(battler, move_type = nil)
    ItemIntelligence.has_type_gem?(battler, move_type)
  end

  def self.has_sticky_barb?(battler)
    ItemIntelligence.has_sticky_barb?(battler)
  end

  def self.has_mental_herb?(battler)
    ItemIntelligence.has_mental_herb?(battler)
  end

  def self.has_ability_shield?(battler)
    ItemIntelligence.has_ability_shield?(battler)
  end

  def self.has_shed_shell?(battler)
    ItemIntelligence.has_shed_shell?(battler)
  end

  def self.gem_damage_bonus(battler, move)
    ItemIntelligence.gem_damage_bonus(battler, move)
  end

  def self.mental_herb_penalty(target, move)
    ItemIntelligence.mental_herb_penalty(target, move)
  end

  def self.utility_umbrella_penalty(target, move)
    ItemIntelligence.utility_umbrella_penalty(target, move)
  end
end

#===============================================================================
# Integration in Battle::AI - Wires item intelligence into scoring pipeline
#===============================================================================
class Battle::AI
  def apply_item_intelligence(score, move, user, target)
    return score unless move && user
    
    # Factor in our item's effect on move damage
    if move.damagingMove?
      real_user = user.respond_to?(:battler) ? user.battler : user
      multiplier = AdvancedAI.calculate_item_multiplier(real_user, move)
      if multiplier > 1.0
        # Boost score proportionally (e.g., Life Orb 1.3x → +15 points)
        bonus = ((multiplier - 1.0) * 50).to_i
        score += bonus
      end
    end
    
    # If choice-locked, penalize non-locked moves (they'll fail)
    if target
      real_user = user.respond_to?(:battler) ? user.battler : user
      if AdvancedAI.choice_locked?(real_user)
        last = real_user.lastMoveUsed rescue nil
        if last && move.id != last
          score -= 100  # Can't use this move while choice-locked
        end
      end
      
      # If target blocks status, penalize status moves
      real_target = target.respond_to?(:battler) ? target.battler : target
      if move.category == :Status && AdvancedAI.blocks_status_moves?(real_target)
        score -= 30
      end
    end

    #--- #18: Advanced Item Awareness ---
    real_user = user.respond_to?(:battler) ? user.battler : user

    # Gem damage bonus
    score += AdvancedAI.gem_damage_bonus(real_user, move)

    if target
      real_target = target.respond_to?(:battler) ? target.battler : target

      # Utility Umbrella on target: penalize weather-dependent moves
      score += AdvancedAI.utility_umbrella_penalty(real_target, move)

      # Mental Herb on target: penalize Taunt/Encore/Disable/Torment
      score += AdvancedAI.mental_herb_penalty(real_target, move)

      # Sticky Barb on target: penalize contact moves (barb transfers to us)
      if move.respond_to?(:contactMove?) && move.contactMove? && AdvancedAI.has_sticky_barb?(real_target)
        score -= 10  # Risk inheriting Sticky Barb
      end
    end

    # Weather extender: boost weather-setting moves if we hold extender
    if move.respond_to?(:id)
      weather_moves = {
        :RAINDANCE  => "rain",  :SUNNYDAY    => "sun",
        :SANDSTORM  => "sand",  :HAIL        => "hail",
        :SNOWSCAPE  => "hail",
      }
      wtype = weather_moves[move.id]
      if wtype && ItemIntelligence.extends_weather?(real_user, wtype)
        score += 10  # 8 turns instead of 5 is significant
      end
    end

    #--- Power Herb: instantly execute charge moves ---
    user_item = real_user.respond_to?(:item_id) ? real_user.item_id : nil
    charge_moves = [:SOLARBEAM, :SOLARBLADE, :METEORBEAM, :PHANTOMFORCE,
                    :SHADOWFORCE, :SKULLBASH, :SKYATTACK, :FLY, :DIG, :DIVE,
                    :BOUNCE, :GEOMANCY, :FREEZESHOCK, :ICEBURN, :RAZORWIND, :ELECTROSHOT]
    if user_item == :POWERHERB && charge_moves.include?(move.id)
      bonus = 35
      bonus += 15 if move.id == :METEORBEAM  # Also raises SpAtk
      bonus += 25 if move.id == :GEOMANCY    # +1 SpAtk/SpDef/Speed
      score += bonus
    end

    #--- Ability Shield: penalize ability-changing moves against holders ---
    if target
      real_target = target.respond_to?(:battler) ? target.battler : target
      target_item = real_target.respond_to?(:item_id) ? real_target.item_id : nil
      if target_item == :ABILITYSHIELD
        ability_change_moves = [:GASTROACID, :WORRYSEED, :SIMPLEBEAM, :ENTRAINMENT,
                                :SKILLSWAP, :ROLEPLAY, :DOODLE, :CORROSIVEGAS]
        if ability_change_moves.include?(move.id)
          score -= 40  # Move will fail against Ability Shield
          AdvancedAI.log("#{move.name} blocked by Ability Shield", "Item") rescue nil
        end
        # Also penalize Mummy/Lingering Aroma contact (won't change ability)
        if move.respond_to?(:contactMove?) && move.contactMove?
          if [:MUMMY, :LINGERINGAROMA, :WANDERINGSPIRIT].include?(real_target.ability_id)
            # Actually Ability Shield protects the HOLDER, so if target has it,
            # they keep their ability. No penalty needed for us attacking.
          end
        end
      end
      # If WE have Ability Shield, boost if our ability is critical
      if user_item == :ABILITYSHIELD
        critical_abilities = [:HUGEPOWER, :PUREPOWER, :SPEEDBOOST, :MAGICGUARD,
                              :WONDERGUARD, :PROTEAN, :LIBERO, :UNBURDEN, :POISONHEAL]
        if critical_abilities.include?(real_user.ability_id)
          # We benefit from protected ability — slightly prefer staying in
          score += 5 if move.damagingMove?
        end
      end
    end

    #--- White Herb: negate self-stat-drops ---
    stat_drop_moves = [:SHELLSMASH, :CLOSECOMBAT, :SUPERPOWER, :OVERHEAT,
                       :DRACOMETEOR, :LEAFSTORM, :FLEURCANNON, :PSYCHOBOOST, :VCREATE]
    if user_item == :WHITEHERB && stat_drop_moves.include?(move.id)
      bonus = move.id == :SHELLSMASH ? 35 : 15
      score += bonus
    end

    #--- Booster Energy: Paradox ability activation ---
    user_ability = real_user.respond_to?(:ability_id) ? real_user.ability_id : nil
    if user_item == :BOOSTERENERGY && [:PROTOSYNTHESIS, :QUARKDRIVE].include?(user_ability)
      # Stat already boosted — favor moves that match the boosted offensive stat
      if move.damagingMove?
        atk = real_user.respond_to?(:attack) ? real_user.attack : 0
        spa = real_user.respond_to?(:spatk) ? real_user.spatk : 0
        if atk > spa
          score += 10 if move.physicalMove?
        else
          score += 10 if move.specialMove?
        end
      end
    end

    return score
  end
end

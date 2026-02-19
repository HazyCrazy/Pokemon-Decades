#===============================================================================
# Advanced AI System - Centralized Utilities
# Common helper methods used across all AI modules to avoid duplication
#===============================================================================

module AdvancedAI
  module Utilities
    #===========================================================================
    # Type Effectiveness (Centralized)
    #===========================================================================
    
    # Get type effectiveness for a move or type against a target
    # Handles both Battler objects (.types) and Pokemon objects (.type1/.type2)
    def self.type_mod(attack_type, defender)
      return Effectiveness::NORMAL_EFFECTIVE unless defender
      
      type = attack_type.is_a?(Symbol) ? attack_type : attack_type.type
      
      # Handle both Battler (pbTypes method) and Pokemon (type1/type2)
      if defender.respond_to?(:pbTypes)
        types = defender.pbTypes(true)
        t1, t2 = types[0], types[1]
      elsif defender.respond_to?(:types)
        # Fallback for older API (deprecated)
        t1, t2 = defender.types[0], defender.types[1]
      else
        t1, t2 = defender.type1, defender.type2
      end
      
      Effectiveness.calculate(type, t1, t2)
    end
    
    def self.super_effective?(attack_type, defender)
      Effectiveness.super_effective?(type_mod(attack_type, defender))
    end
    
    def self.not_very_effective?(attack_type, defender)
      Effectiveness.not_very_effective?(type_mod(attack_type, defender))
    end
    
    def self.ineffective?(attack_type, defender)
      Effectiveness.ineffective?(type_mod(attack_type, defender))
    end
    
    #===========================================================================
    # Mold Breaker / Ability Ignoring (CRITICAL)
    #===========================================================================
    
    ABILITY_IGNORING = [:MOLDBREAKER, :TURBOBLAZE, :TERAVOLT, :MYCELIUMMIGHT]
    
    # Check if user ignores target's ability
    def self.ignores_ability?(user)
      return false unless user
      
      # Check method if available (Essentials built-in)
      return true if user.respond_to?(:hasMoldBreaker?) && user.hasMoldBreaker?
      
      # Manual check
      ABILITY_IGNORING.include?(user.ability_id)
    end
    
    # Check ability only if not ignored
    def self.target_has_ability?(user, target, *abilities)
      return false unless target
      return false if ignores_ability?(user)
      
      abilities.flatten.include?(target.ability_id)
    end
    
    #===========================================================================
    # Type-Absorbing Ability Immunities (CRITICAL FOR MOVE SCORING)
    #===========================================================================
    
    # Abilities that make a Pokemon IMMUNE to a type (and often boost a stat)
    TYPE_ABSORBING_ABILITIES = {
      # Type => [[abilities that absorb it], effect]
      WATER: [
        [:WATERABSORB, :heal],      # Heals 25% HP
        [:DRYSKIN, :heal],          # Heals 25% HP (also takes 25% extra Fire damage)
        [:STORMDRAIN, :boost_spa],  # +1 SpA
      ],
      ELECTRIC: [
        [:VOLTABSORB, :heal],       # Heals 25% HP
        [:LIGHTNINGROD, :boost_spa], # +1 SpA
        [:MOTORDRIVE, :boost_speed], # +1 Speed
      ],
      FIRE: [
        [:FLASHFIRE, :boost_fire],  # Boosts Fire moves 1.5x
        [:WELLBAKEDBODY, :boost_def], # +2 Defense (Gen 9)
      ],
      GRASS: [
        [:SAPSIPPER, :boost_atk],   # +1 Attack
      ],
      GROUND: [
        [:EARTHEATER, :heal],       # Heals 25% HP (Gen 9)
        [:LEVITATE, :immune],       # Complete immunity
      ],
    }
    
    # Check if target is immune to a move's type due to ability
    # Returns: nil if not immune, or a hash with { ability: X, effect: Y }
    def self.type_absorbing_immunity?(user, target, move_type)
      return nil unless target
      return nil if ignores_ability?(user)
      
      type_sym = move_type.to_sym rescue move_type
      absorbers = TYPE_ABSORBING_ABILITIES[type_sym]
      return nil unless absorbers
      
      absorbers.each do |ability, effect|
        ability = [ability] unless ability.is_a?(Array)
        ability.each do |ab|
          if target.ability_id == ab
            return { ability: ab, effect: effect }
          end
        end
      end
      
      nil
    end
    
    # Score penalty for attacking into a type-absorbing ability
    # Returns a NEGATIVE score (penalty) if bad, 0 if fine
    def self.score_type_absorption_penalty(user, target, move)
      return 0 unless move && move.damagingMove?
      
      move_type = move.type
      immunity = type_absorbing_immunity?(user, target, move_type)
      return 0 unless immunity
      
      # This move will be ABSORBED - heavy penalty!
      case immunity[:effect]
      when :heal
        return -150  # They heal, we waste turn
      when :boost_atk, :boost_spa, :boost_speed, :boost_def
        return -180  # They get STRONGER, terrible
      when :boost_fire
        return -160  # Flash Fire boost
      when :immune
        return -200  # Complete immunity (Levitate)
      else
        return -150  # Default heavy penalty
      end
    end
    
    # Additional single-ability type immunities (not stat-boosting)
    ADDITIONAL_TYPE_IMMUNITIES = {
      FIRE: [:FLASHFIRE, :WELLBAKEDBODY, :HEATPROOF],  # Heatproof is 50% not immunity but notable
      ELECTRIC: [:VOLTABSORB, :LIGHTNINGROD, :MOTORDRIVE],
      WATER: [:WATERABSORB, :DRYSKIN, :STORMDRAIN],
      GRASS: [:SAPSIPPER],
      GROUND: [:LEVITATE, :EARTHEATER],
      PSYCHIC: [],  # No full immunities
      DARK: [],
      GHOST: [],
      DRAGON: [],
      POISON: [:IMMUNITY],  # Immunity prevents poison status, not Poison moves
      FIGHTING: [],
      ROCK: [],
      STEEL: [],
      BUG: [],
      FLYING: [],
      ICE: [],
      FAIRY: [],
      NORMAL: [],
    }
    
    # Bulletproof immunity (ball/bomb moves)
    BALL_BOMB_MOVES = [
      :ACIDSPRAY, :AURASPHERE, :BARRAGE, :BEAKBLAST, :BULLETSEED,
      :EGGBOMB, :ELECTROBALL, :ENERGYBALL, :FOCUSBLAST, :GYROBALL,
      :ICEBALL, :MAGNETBOMB, :MISTBALL, :MUDBOMB, :OCTAZOOKA,
      :POLLENPUFF, :PYROBALL, :ROCKWRECKER, :SEEDBOMB, :SHADOWBALL,
      :SLUDGEBOMB, :WEATHERBALL, :ZAPCANNON
    ]
    
    def self.bulletproof_immune?(user, target, move)
      return false unless target
      return false if ignores_ability?(user)
      return false unless target.ability_id == :BULLETPROOF
      
      BALL_BOMB_MOVES.include?(move.id)
    end
    
    # Soundproof immunity
    SOUND_MOVES = [
      :BOOMBURST, :BUGBUZZ, :CHATTER, :CLANGOROUSSOUL, :CLANGINGSCALES,
      :CONFIDE, :DISARMINGVOICE, :ECHOEDVOICE, :EERIESPELL, :GRASSWHISTLE,
      :GROWL, :HEALBELL, :HYPERVOICE, :METALSOUND, :NOBLEROAR, :OVERDRIVE,
      :PARTINGSHOT, :PERISHSONG, :RELICSONG, :ROAR, :ROUND, :SCREAM,
      :SCREECH, :SHADOWPANIC, :SING, :SNARL, :SNORE, :SPARKLINGARIA,
      :SUPERSONIC, :TORCHSONG, :UPROAR
    ]
    
    def self.soundproof_immune?(user, target, move)
      return false unless target
      return false if ignores_ability?(user)
      return false unless target.ability_id == :SOUNDPROOF
      
      move.soundMove? rescue SOUND_MOVES.include?(move.id)
    end

    #===========================================================================
    # Grounded Check (Centralized)
    #===========================================================================
    
    # Full grounded check with all conditions
    # Handles both Battler and Pokemon objects
    def self.grounded?(battler, battle = nil)
      return true unless battler
      
      # Flying type - handle both Battler (pbHasType?) and Pokemon (hasType?)
      has_flying = battler.respond_to?(:pbHasType?) ? battler.pbHasType?(:FLYING) : battler.hasType?(:FLYING)
      return false if has_flying
      
      # Levitate (can be ignored by Mold Breaker in battle context)
      ability = battler.respond_to?(:ability_id) ? battler.ability_id : battler.ability_id
      return false if ability == :LEVITATE
      
      # Air Balloon
      item = battler.respond_to?(:item_id) ? battler.item_id : battler.item_id
      return false if item == :AIRBALLOON
      
      # Effects (need battler in battle)
      if battler.respond_to?(:effects)
        # Magnet Rise
        if battler.effects[PBEffects::MagnetRise] && battler.effects[PBEffects::MagnetRise] > 0
          return false
        end
        
        # Telekinesis
        if battler.effects[PBEffects::Telekinesis] && battler.effects[PBEffects::Telekinesis] > 0
          return false
        end
      end
      
      # Gravity grounds everything
      if battle && battle.field.effects[PBEffects::Gravity] && battle.field.effects[PBEffects::Gravity] > 0
        return true
      end
      
      # Iron Ball grounds
      return true if battler.item_id == :IRONBALL
      
      # Ingrain grounds
      if battler.respond_to?(:effects) && battler.effects[PBEffects::Ingrain]
        return true
      end
      
      true
    end
    
    #===========================================================================
    # Contact Move Punishment
    #===========================================================================
    
    CONTACT_PUNISH_ABILITIES = {
      ROUGHSKIN: { damage: 8, type: :fixed },      # 1/8 max HP
      IRONBARBS: { damage: 8, type: :fixed },
      FLAMEBODY: { damage: 0, type: :status, status: :BURN, chance: 30 },
      STATIC: { damage: 0, type: :status, status: :PARALYSIS, chance: 30 },
      POISONPOINT: { damage: 0, type: :status, status: :POISON, chance: 30 },
      EFFECTSPORE: { damage: 0, type: :status, chance: 30 },
      CUTECHARM: { damage: 0, type: :status, chance: 30 },
      GOOEY: { damage: 0, type: :stat, stat: :SPEED, stages: -1 },
      TANGLINGHAIR: { damage: 0, type: :stat, stat: :SPEED, stages: -1 },
      PERISHBODY: { damage: 0, type: :special },
      WANDERINGSPIRIT: { damage: 0, type: :special },
      MUMMY: { damage: 0, type: :special },
      LINGERINGAROMA: { damage: 0, type: :special },
      COTTONDOWN: { damage: 0, type: :stat, stat: :SPEED, stages: -1, aoe: true },
      STAMINA: { damage: 0, type: :self_boost, stat: :DEFENSE, stages: 1 },
      WEAKARMOR: { damage: 0, type: :self_mixed, speed_up: 2, def_down: 1 },
      ELECTROMORPHOSIS: { damage: 0, type: :charge },
      WINDPOWER: { damage: 0, type: :charge, condition: :wind_move },
      ANGERSHELL: { damage: 0, type: :conditional_boost, threshold: 0.5 },
    }
    
    # Calculate contact move punishment
    def self.contact_punishment(attacker, defender, move)
      return 0 unless move && move.contactMove?
      return 0 unless defender
      
      score_penalty = 0
      
      # Ability punishment (check Mold Breaker)
      unless ignores_ability?(attacker)
        ability_data = CONTACT_PUNISH_ABILITIES[defender.ability_id]
        if ability_data
          case ability_data[:type]
          when :fixed
            damage = attacker.totalhp / ability_data[:damage]
            score_penalty += (damage * 100 / [attacker.hp, 1].max) / 3
          when :status
            if attacker.status == :NONE
              score_penalty += 15 * (ability_data[:chance] / 100.0)
            end
          when :stat
            score_penalty += 10
          when :special
            score_penalty += 20
          when :self_boost
            # Target gets a DEF boost when hit — penalize physical attacks
            score_penalty += 12
          when :self_mixed
            # Weak Armor: -1 Def but +2 Speed — net threat increase
            score_penalty += 8
          when :charge
            # Electromorphosis/Wind Power: target gains Charge (2x electric)
            score_penalty += 10
          when :conditional_boost
            # Anger Shell: below 50% HP triggers multi-stat boost
            if defender.hp > defender.totalhp * (ability_data[:threshold] || 0.5)
              score_penalty += 15  # Could trigger the boost
            end
          end
        end
      end
      
      # Rocky Helmet
      if defender.item_id == :ROCKYHELMET
        damage = attacker.totalhp / 6
        score_penalty += (damage * 100 / [attacker.hp, 1].max) / 3
      end
      
      # Long Reach ability ignores contact
      if attacker.ability_id == :LONGREACH
        return 0
      end
      
      # Protective Pads ignores contact effects
      if attacker.item_id == :PROTECTIVEPADS
        return 0
      end
      
      score_penalty.to_i
    end
    
    #===========================================================================
    # Protect Stale Check
    #===========================================================================
    
    # Check if Protect is likely to fail
    def self.protect_likely_to_fail?(battler)
      return false unless battler
      return false unless battler.respond_to?(:effects)
      
      protect_rate = battler.effects[PBEffects::ProtectRate] || 1
      
      # At rate 4+, only 1/4096 chance of success
      protect_rate >= 4
    end
    
    # Get Protect success rate
    def self.protect_success_chance(battler)
      return 100 unless battler && battler.respond_to?(:effects)
      
      rate = battler.effects[PBEffects::ProtectRate] || 1
      (100.0 / rate).round
    end
    
    #===========================================================================
    # Multi-Hit Move Handling
    #===========================================================================
    
    # Calculate expected hits for multi-hit move
    def self.expected_multi_hits(attacker, move)
      return 1 unless move
      return 1 unless move.multiHitMove?
      
      # Fixed hit moves
      fixed_hits = {
        TRIPLEKICK: 3, TRIPLAXEL: 3, SURGINGSTRIKES: 3,
        DOUBLEHIT: 2, BONEMERANG: 2, DOUBLEIRONBASH: 2,
        DRAGONDARTSFIX: 2, TWINBEAM: 2
      }
      
      return fixed_hits[move.id] if fixed_hits[move.id]
      
      # Population Bomb
      if move.id == :POPULATIONBOMB
        return attacker.item_id == :LOADEDDICE ? 7 : 5
      end
      
      # Skill Link = always 5
      if attacker.ability_id == :SKILLLINK
        return 5
      end
      
      # Loaded Dice = 4-5 (average 4.5)
      if attacker.item_id == :LOADEDDICE
        return 4.5
      end
      
      # Default: 2-5 hits, average ~3.17
      3.17
    end
    
    # Check if multi-hit breaks Focus Sash / Sturdy
    def self.multi_hit_breaks_endure?(attacker, move, target)
      return false unless move && move.multiHitMove?
      return false unless target
      
      # Focus Sash
      return true if target.item_id == :FOCUSSASH && target.hp == target.totalhp
      
      # Sturdy
      return true if target.ability_id == :STURDY && target.hp == target.totalhp && !ignores_ability?(attacker)
      
      # Disguise / Ice Face (form abilities)
      return true if [:DISGUISE, :ICEFACE].include?(target.ability_id) && !ignores_ability?(attacker)
      
      false
    end
    
    #===========================================================================
    # Status Immunities (Comprehensive)
    #===========================================================================
    
    # Check if target is immune to a status condition
    # Handles both Battler and Pokemon objects
    def self.status_immune?(attacker, target, status, battle = nil)
      return true unless target
      return true if target.status != :NONE && status != :NONE  # Already has status
      
      # Helper for type checking
      has_type = lambda { |t| target.respond_to?(:pbHasType?) ? target.pbHasType?(t) : target.hasType?(t) }
      
      case status
      when :SLEEP
        # Type immunity
        return true if has_type.call(:GRASS) && [:SPORE, :SLEEPPOWDER, :STUNSPORE].include?(attacker&.lastMoveUsed)
        
        # Ability immunity (check Mold Breaker)
        unless ignores_ability?(attacker)
          return true if [:VITALSPIRIT, :INSOMNIA, :COMATOSE].include?(target.ability_id)
          
          # Sweet Veil (ally immunity) - would need battle context
          if battle
            allies = battle.allSameSideBattlers(target.index)
            return true if allies.any? { |a| a && a.ability_id == :SWEETVEIL }
          end
          
          # Leaf Guard in sun
          if target.ability_id == :LEAFGUARD && battle && [:Sun, :HarshSun].include?(battle.field.weather)
            return true
          end
        end
        
        # Terrain immunity
        if battle
          return true if battle.field.terrain == :Electric && grounded?(target, battle)
          return true if battle.field.terrain == :Misty && grounded?(target, battle)
        end
        
        # Item immunity
        return true if target.item_id == :SAFETYGOGGLES  # Powder moves
        
      when :POISON, :TOXIC
        return true if has_type.call(:POISON)
        return true if has_type.call(:STEEL)
        
        unless ignores_ability?(attacker)
          return true if target.ability_id == :IMMUNITY
          return true if target.ability_id == :PASTELVEIL
          return true if target.ability_id == :PURIFYINGSALT
        end
        
      when :BURN
        return true if has_type.call(:FIRE)
        
        unless ignores_ability?(attacker)
          return true if target.ability_id == :WATERVEIL
          return true if target.ability_id == :WATERBUBBLE
          return true if target.ability_id == :THERMALEXCHANGE
          return true if target.ability_id == :PURIFYINGSALT
        end
        
      when :PARALYSIS
        return true if has_type.call(:ELECTRIC)
        
        unless ignores_ability?(attacker)
          return true if target.ability_id == :LIMBER
          return true if target.ability_id == :PURIFYINGSALT
        end
        
      when :FREEZE
        return true if has_type.call(:ICE)
        
        unless ignores_ability?(attacker)
          return true if target.ability_id == :MAGMAARMOR
          return true if target.ability_id == :PURIFYINGSALT
        end
        
        # Sun prevents freeze
        if battle && [:Sun, :HarshSun].include?(battle.field.weather)
          return true
        end
      end
      
      # Good as Gold (immune to status moves)
      unless ignores_ability?(attacker)
        return true if target.ability_id == :GOODASGOLD
      end
      
      false
    end
    
    #===========================================================================
    # Weather Nullification
    #===========================================================================
    
    WEATHER_NULLIFIERS = [:AIRLOCK, :CLOUDNINE]
    
    def self.weather_active?(battle)
      return false unless battle
      return false if battle.field.weather == :None
      
      # Check for Air Lock / Cloud Nine
      battle.allBattlers.each do |b|
        next unless b && !b.fainted?
        return false if WEATHER_NULLIFIERS.include?(b.ability_id)
      end
      
      true
    end
    
    def self.current_weather(battle)
      return :None unless weather_active?(battle)
      battle.field.weather
    end
    
    #===========================================================================
    # Primordial Weather (Harsh Sun, Heavy Rain, Strong Winds)
    #===========================================================================
    
    def self.move_blocked_by_weather?(battle, move)
      return false unless battle && move && move.damagingMove?
      
      weather = current_weather(battle)
      
      case weather
      when :HarshSun
        return true if move.type == :WATER  # Water moves fail
      when :HeavyRain
        return true if move.type == :FIRE   # Fire moves fail
      end
      
      false
    end
    
    #===========================================================================
    # Gen 9 Ability Checks
    #===========================================================================
    
    GEN9_OFFENSIVE_ABILITIES = {
      SUPREMEOVERLORD: { boost: true, condition: :fainted_allies },
      ORICHALCUMPULSE: { boost: true, sets: :Sun },
      HADRONENGINE: { boost: true, sets: :Electric },  # Terrain
      TOXICCHAIN: { poison_chance: 30 },
      SHARPNESS: { boost: 1.5, condition: :slicing_move },
      ROCKYPAYLOAD: { boost: 1.5, type: :ROCK },
      WINDPOWER: { sets_charge: true, condition: :wind_move_hit },
      ELECTROMORPHOSIS: { sets_charge: true, condition: :any_hit },
      SWORDOFRUIN: { aura: true, reduces: :DEF, amount: 0.75 },
      BEADSOFRUIN: { aura: true, reduces: :SPDEF, amount: 0.75 },
      TOXICBOOST: { boost: 1.5, condition: :poisoned, category: :physical },
      FLAREBOOST: { boost: 1.5, condition: :burned, category: :special },
      ZEROTOHERO: { form_change: true, hero_form: 1 },
      POISONPUPPETEER: { poison_confuse: true },
      EMBODYASPECT: { boost_on_entry: true },
      ASONEGLASTRIER: { ko_boost: :ATK, includes: :UNNERVE },
      ASONESPECTRIER: { ko_boost: :SPATK, includes: :UNNERVE },
      MINDSEYE: { ignore_evasion: true, ghost_hit: true },
    }
    
    GEN9_DEFENSIVE_ABILITIES = {
      PURIFYINGSALT: { status_immune: true, ghost_resist: true },
      GOODASGOLD: { status_move_immune: true },
      ARMORTAIL: { priority_block: true },
      WINDRIDER: { wind_immune: true, attack_boost: true },
      GUARDDOG: { intimidate_immune: true, attack_boost: true },
      WELLBAKEDBODY: { fire_immune: true, defense_boost: true },
      EARTHEATER: { ground_immune: true, heal: true },
      HOSPITALITY: { heal_ally_on_entry: true },
      ICESCALES: { special_halved: true },
      STAMINA: { def_boost_on_hit: true },
      WEAKARMOR: { def_down_speed_up_on_physical: true },
      ANGERSHELL: { below_half_boost: true },
      COTTONDOWN: { speed_drop_all_on_hit: true },
      TABLETSOFRUIN: { aura: true, reduces: :ATK, amount: 0.75 },
      VESSELOFRUIN: { aura: true, reduces: :SPATK, amount: 0.75 },
      TERASHELL: { all_nve_at_full_hp: true },
      TERAFORMZERO: { removes_weather_terrain: true },
      TERASHIFT: { auto_transform: true },
      SUPERSWEETSYRUP: { evasion_drop_on_entry: true },
      SEEDSOWER: { sets_terrain: :Grassy, condition: :hit },
    }
    
    def self.has_gen9_offensive_ability?(battler)
      GEN9_OFFENSIVE_ABILITIES.key?(battler.ability_id)
    end
    
    def self.has_gen9_defensive_ability?(battler)
      GEN9_DEFENSIVE_ABILITIES.key?(battler.ability_id)
    end
    
    #===========================================================================
    # Priority Ability Awareness
    #===========================================================================
    
    # Check if Prankster move fails against Dark type
    def self.prankster_blocked?(user, target, move)
      return false unless user && target && move
      return false unless user.ability_id == :PRANKSTER
      return false unless move.statusMove?
      
      # Prankster status moves fail against Dark types
      has_dark = target.respond_to?(:pbHasType?) ? target.pbHasType?(:DARK) : target.hasType?(:DARK)
      has_dark
    end
    
    # Check Gale Wings priority (Flying moves at full HP)
    def self.gale_wings_active?(user)
      return false unless user
      return false unless user.ability_id == :GALEWINGS
      user.hp == user.totalhp
    end
    
    # Check Triage priority (healing moves)
    HEALING_MOVES = [
      :RECOVER, :SOFTBOILED, :ROOST, :SLACKOFF, :MOONLIGHT, :MORNINGSUN,
      :SYNTHESIS, :WISH, :SHOREUP, :LIFEDEW, :JUNGLEHEALING, :LUNARBLESSING,
      :LEECHLIFE, :DRAININGKISS, :DRAINPUNCH, :GIGADRAIN, :HORNLEECH,
      :LEECHSEED, :PARABOLICCHARGE, :OBLIVIONWING, :STRENGTHSAP,
      :ABSORB, :MEGADRAIN, :POLLENPUFF
    ]
    
    def self.triage_active?(user, move)
      return false unless user && move
      return false unless user.ability_id == :TRIAGE
      HEALING_MOVES.include?(move.id)
    end
    
    # Get effective priority including ability modifiers
    def self.effective_priority(user, move, battle = nil)
      return 0 unless move
      
      base_priority = move.priority rescue 0
      
      # Prankster
      if user.ability_id == :PRANKSTER && move.statusMove?
        base_priority += 1
      end
      
      # Gale Wings (full HP, Flying move)
      if gale_wings_active?(user) && move.type == :FLYING
        base_priority += 1
      end
      
      # Triage (+3 for healing moves)
      if triage_active?(user, move)
        base_priority += 3
      end
      
      # Grassy Glide in Grassy Terrain
      if move.id == :GRASSYGLIDE && battle && battle.field.terrain == :Grassy
        base_priority = 1
      end
      
      base_priority
    end
    
    #===========================================================================
    # Gen 9 Special Move Handling
    #===========================================================================
    
    # Rage Fist - power increases with hits taken
    def self.rage_fist_power(user)
      base_power = 50
      hits_taken = user.effects[PBEffects::RageFist] rescue 0
      # +50 power per hit, max 350
      [base_power + (hits_taken * 50), 350].min
    end
    
    # Last Respects - power increases per fainted ally
    def self.last_respects_power(battle, user)
      base_power = 50
      return base_power unless battle
      
      fainted_count = 0
      party = battle.pbParty(user.index)
      party.each do |p|
        next unless p
        fainted_count += 1 if p.fainted?
      end
      
      # +50 power per fainted ally
      base_power + (fainted_count * 50)
    end
    
    # Glaive Rush - makes user take double damage next turn
    def self.used_glaive_rush?(user)
      return false unless user
      user.lastMoveUsed == :GLAIVERUSH
    end
    
    # Collision Course / Electro Drift - boosted SE damage
    COLLISION_MOVES = [:COLLISIONCOURSE, :ELECTRODRIFT]
    
    def self.collision_move_boost?(move)
      COLLISION_MOVES.include?(move.id)
    end
    
    #===========================================================================
    # Gen 9 Item Tracking
    #===========================================================================
    
    # Eject Pack - forces switch when stats are lowered
    def self.eject_pack_active?(battler)
      return false unless battler
      battler.item_id == :EJECTPACK && battler.statsLoweredThisRound
    end
    
    # Throat Spray - +1 SpA after using sound move
    def self.throat_spray_active?(user, move)
      return false unless user && move
      user.item_id == :THROATSPRAY && (move.soundMove? rescue false)
    end
    
    # Blunder Policy - +2 Speed if move misses
    def self.blunder_policy_bonus(user)
      return 0 unless user
      return 0 unless user.item_id == :BLUNDERPOLICY
      return 0 unless user.lastMoveFailed
      2  # +2 Speed stages
    end
    
    #===========================================================================
    # Contrary / Simple Handling for Setup Scoring
    #===========================================================================
    
    # Get effective stat stages considering Contrary/Simple
    def self.effective_stat_change(user, stages)
      return stages unless user
      
      if user.ability_id == :CONTRARY
        return -stages  # Reversed
      elsif user.ability_id == :SIMPLE
        return stages * 2  # Doubled
      end
      
      stages
    end
    
    # Check if setup move is beneficial considering ability
    def self.setup_beneficial?(user, move_id)
      return true unless user
      
      # Moves that lower stats (Overheat, Draco Meteor, etc.)
      stat_lowering_moves = [:OVERHEAT, :DRACOMETEOR, :LEAFSTORM, :FLEURCANNON,
                             :PSYCHOBOOST, :CLOSECOMBAT, :SUPERPOWER, :HAMMERARM,
                             :VCREATE, :HEADCHARGE, :SHELSMASH]  # Shell Smash has both
      
      if user.ability_id == :CONTRARY
        # Contrary makes stat-lowering moves into boosts!
        return true if stat_lowering_moves.include?(move_id)
        # But regular setup moves become debuffs
        return false if ALL_SETUP_MOVES.include?(move_id)
      end
      
      true
    end
    
    #===========================================================================
    # Centralized Setup Move List
    #===========================================================================
    
    SETUP_MOVES = {
      physical: [:SWORDSDANCE, :DRAGONDANCE, :BELLYDRUM, :BULKUP, :HOWL, :COIL,
                 :VICTORYDANCE, :FILLETAWAY, :HONECLAWS, :CURSE],
      special: [:NASTYPLOT, :CALMMIND, :QUIVERDANCE, :TAILGLOW, :GEOMANCY,
                :TAKEHEART, :TORCHSONG],
      speed: [:AGILITY, :ROCKPOLISH, :AUTOTOMIZE, :SHIFTGEAR, :TAILWIND,
              :DRAGONDANCE],  # DD is both
      mixed: [:SHELLSMASH, :GROWTH, :WORKUP, :ANCIENTPOWER, :OMINOUSWIND,
              :SILVERWIND, :CLANGOROUSSOUL, :NORETREAT],
      defensive: [:IRONDEFENSE, :ACIDARMOR, :BARRIER, :COTTONGUARD,
                  :AMNESIA, :COSMICPOWER, :STOCKPILE, :SHELTER],
      special_types: [:FOCUSENERGY, :CHARGE, :MAGNETRISE, :AQUARING]
    }
    
    ALL_SETUP_MOVES = SETUP_MOVES.values.flatten.uniq
    
    def self.is_setup_move?(move)
      return false unless move
      ALL_SETUP_MOVES.include?(move.id)
    end
    
    def self.get_setup_type(move)
      return nil unless move
      
      SETUP_MOVES.each do |type, moves|
        return type if moves.include?(move.id)
      end
      
      nil
    end
  end
end

# Shorthand access
module AdvancedAI
  def self.type_mod(attack_type, defender)
    Utilities.type_mod(attack_type, defender)
  end
  
  def self.ignores_ability?(user)
    Utilities.ignores_ability?(user)
  end
  
  def self.target_has_ability?(user, target, *abilities)
    Utilities.target_has_ability?(user, target, *abilities)
  end
  
  def self.grounded?(battler, battle = nil)
    Utilities.grounded?(battler, battle)
  end
  
  def self.contact_punishment(attacker, defender, move)
    Utilities.contact_punishment(attacker, defender, move)
  end
  
  def self.protect_likely_to_fail?(battler)
    Utilities.protect_likely_to_fail?(battler)
  end
  
  def self.expected_multi_hits(attacker, move)
    Utilities.expected_multi_hits(attacker, move)
  end
  
  def self.multi_hit_breaks_endure?(attacker, move, target)
    Utilities.multi_hit_breaks_endure?(attacker, move, target)
  end
  
  def self.status_immune?(attacker, target, status, battle = nil)
    Utilities.status_immune?(attacker, target, status, battle)
  end
  
  def self.weather_active?(battle)
    Utilities.weather_active?(battle)
  end
  
  def self.move_blocked_by_weather?(battle, move)
    Utilities.move_blocked_by_weather?(battle, move)
  end
  
  def self.is_setup_move?(move)
    Utilities.is_setup_move?(move)
  end
  
  def self.type_absorbing_immunity?(user, target, move_type)
    Utilities.type_absorbing_immunity?(user, target, move_type)
  end
  
  def self.score_type_absorption_penalty(user, target, move)
    Utilities.score_type_absorption_penalty(user, target, move)
  end
  
  def self.bulletproof_immune?(user, target, move)
    Utilities.bulletproof_immune?(user, target, move)
  end
  
  def self.soundproof_immune?(user, target, move)
    Utilities.soundproof_immune?(user, target, move)
  end
  
  #===========================================================================
  # VGC Item Awareness
  #===========================================================================
  module Utilities
    # Type-resist berries that reduce SE damage
    TYPE_RESIST_BERRIES = {
      :OCCABERRY => :FIRE,      :PASSHOBERRY => :WATER,   :WACANBERRY => :ELECTRIC,
      :RINDOBERRY => :GRASS,    :YABORBERRY => :ICE,      :CHOPLEBERRY => :FIGHTING,
      :KEBIABERRY => :POISON,   :SHUCABERRY => :GROUND,   :COBABERRY => :FLYING,
      :PAYAPABERRY => :PSYCHIC, :TANGABERRY => :BUG,      :CHARTIBERRY => :ROCK,
      :KASIBBERRY => :GHOST,    :HABANBERRY => :DRAGON,   :COLBURBERRY => :DARK,
      :BABIRIBERRY => :STEEL,   :ROSELIBERRY => :FAIRY,   :CHILANBERRY => :NORMAL
    }
    
    # Check if target has a resist berry for move type
    def self.has_resist_berry?(target, move_type)
      return false unless target && target.item_id
      TYPE_RESIST_BERRIES[target.item_id] == move_type
    end
    
    # Get damage reduction from resist berry (0.5x when SE)
    def self.resist_berry_mod(target, move_type, type_effectiveness)
      return 1.0 unless Effectiveness.super_effective?(type_effectiveness)
      return 1.0 unless has_resist_berry?(target, move_type)
      0.5  # Halves SE damage
    end
    
    # Clear Amulet - immune to stat drops
    def self.has_clear_amulet?(battler)
      battler && battler.item_id == :CLEARAMULET
    end
    
    # Covert Cloak - immune to secondary effects
    def self.has_covert_cloak?(battler)
      battler && battler.item_id == :COVERTCLOAK
    end
    
    # Utility Umbrella - ignore weather effects
    def self.has_utility_umbrella?(battler)
      battler && battler.item_id == :UTILITYUMBRELLA
    end
    
    # Power Herb - skip charge turn
    def self.has_power_herb?(battler)
      battler && battler.item_id == :POWERHERB
    end
    
    # White Herb - restore lowered stats
    def self.has_white_herb?(battler)
      battler && battler.item_id == :WHITEHERB
    end
    
    #=========================================================================
    # Form Change Awareness
    #=========================================================================
    
    # Aegislash - Shield form (defensive) vs Blade form (offensive)
    def self.aegislash_in_shield_form?(battler)
      return false unless battler
      battler.isSpecies?(:AEGISLASH) && battler.form == 0
    end
    
    def self.aegislash_in_blade_form?(battler)
      return false unless battler
      battler.isSpecies?(:AEGISLASH) && battler.form == 1
    end
    
    # Darmanitan Zen Mode - below 50% HP changes form
    def self.darmanitan_can_zen?(battler)
      return false unless battler
      return false unless battler.isSpecies?(:DARMANITAN)
      battler.ability_id == :ZENMODE && battler.hp <= battler.totalhp / 2
    end
    
    # Palafin - Hero form after switching
    def self.palafin_hero_form?(battler)
      return false unless battler
      battler.isSpecies?(:PALAFIN) && battler.form == 1
    end
    
    # Wishiwashi - Schooling at 25%+ HP and level 20+
    def self.wishiwashi_schooling?(battler)
      return false unless battler
      return false unless battler.isSpecies?(:WISHIWASHI)
      battler.hp > battler.totalhp / 4 && battler.level >= 20
    end
    
    # Minior - Shields Down below 50% HP
    def self.minior_shields_down?(battler)
      return false unless battler
      return false unless battler.isSpecies?(:MINIOR)
      battler.hp <= battler.totalhp / 2
    end
    
    # Zygarde - Power Construct transforms at low HP
    def self.zygarde_can_transform?(battler)
      return false unless battler
      return false unless battler.isSpecies?(:ZYGARDE)
      battler.ability_id == :POWERCONSTRUCT && battler.hp <= battler.totalhp / 2
    end
  end
end

AdvancedAI.log("Centralized Utilities Module loaded", "Utils")
AdvancedAI.log("  - Type effectiveness helpers", "Utils")
AdvancedAI.log("  - Mold Breaker / ability ignoring", "Utils")
AdvancedAI.log("  - Grounded check (comprehensive)", "Utils")
AdvancedAI.log("  - Contact punishment calculation", "Utils")
AdvancedAI.log("  - Protect stale detection", "Utils")
AdvancedAI.log("  - Multi-hit move handling", "Utils")
AdvancedAI.log("  - Status immunity checks", "Utils")
AdvancedAI.log("  - Weather nullification (Air Lock/Cloud Nine)", "Utils")
AdvancedAI.log("  - Primordial weather move blocking", "Utils")
AdvancedAI.log("  - Gen 9 ability awareness", "Utils")
AdvancedAI.log("  - Centralized setup move list", "Utils")
AdvancedAI.log("  - Type-absorbing ability immunities", "Utils")
AdvancedAI.log("  - Bulletproof / Soundproof immunities", "Utils")

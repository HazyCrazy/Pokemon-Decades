#===============================================================================
# [013] Custom Content - Gen 1-9 Abilities & Type Recognition
#===============================================================================
# Recognizes and evaluates 267+ Abilities from Gen 1-9
# Categories:
# - Offensive Abilities (Huge Power, Adaptability, Technician, etc.)
# - Defensive Abilities (Multiscale, Fur Coat, Filter, etc.)
# - Speed Abilities (Speed Boost, Quick Feet, Unburden, etc.)
# - Support Abilities (Prankster, Magic Bounce, Regenerator, etc.)
# - Weather/Terrain Abilities (Drought, Drizzle, Electric Surge, etc.)
# - Ability Nullification (Mold Breaker, Teravolt, Turboblaze, etc.)
#===============================================================================

module AdvancedAI
  module CustomContent
    
    #===========================================================================
    # Offensive Abilities (increase Threat significantly)
    #===========================================================================
    OFFENSIVE_ABILITIES = {
      # Power-Boost (Threat +3.0)
      :HUGEPOWER          => 3.0,  # 2x Atk
      :PUREPOWER          => 3.0,  # 2x Atk
      :ADAPTABILITY       => 2.5,  # 2x STAB
      :SHEERFORCE         => 2.0,  # 1.3x Power (no secondary)
      :IRONFIST           => 1.5,  # 1.2x Punching moves
      :TOUGHCLAWS         => 1.8,  # 1.3x Contact moves
      :STRONGJAW          => 1.5,  # 1.5x Bite moves
      :MEGALAUNCHER       => 1.5,  # 1.5x Pulse/Aura moves
      
      # Type-Boost (Threat +1.5-2.0)
      :TECHNICIAN         => 2.0,  # 1.5x moves ≤60 BP
      :ANALYTIC           => 1.5,  # 1.3x if moving last
      :SNIPER             => 1.5,  # 1.5x on crit
      :TINTEDLENS         => 2.0,  # NVE → Neutral damage
      :SCRAPPY            => 1.5,  # Hit Ghost with Normal/Fighting
      
      # Crit-Boost (Threat +1.5)
      :SUPERLUCK          => 1.5,  # +1 Crit stage
      :MERCILESS          => 2.0,  # Auto-crit on poisoned targets
      
      # Multi-Hit (Threat +1.5)
      :SKILLLINK          => 2.0,  # Multi-hit = max hits
      :PARENTALBOND       => 2.5,  # 2 hits (1.0 + 0.25)
      
      # Stat-Based (Threat +1.0-2.0)
      :DOWNLOAD           => 1.5,  # +1 Atk or SpAtk
      :INTREPIDSWORD      => 2.0,  # +1 Atk on entry
      :DAUNTLESSSHIELD    => 1.0,  # +1 Def on entry (defensive)
      :BEASTBOOST         => 1.8,  # +1 highest stat on KO
      :MOXIE              => 1.8,  # +1 Atk on KO
      :SOULHEART          => 1.5,  # +1 SpAtk on any KO
      
      # Ability-Negation (Threat +1.5)
      :MOLDBREAKER        => 1.8,  # Ignore opponent abilities
      :TERAVOLT           => 1.8,  # Same as Mold Breaker
      :TURBOBLAZE         => 1.8,  # Same as Mold Breaker
      :NEUTRALIZINGGAS    => 2.0,  # Suppress all abilities
      
      # Gen 9 Abilities
      :ORICHALCUMPULSE    => 2.5,  # Sun + 1.3x Atk
      :HADRONENGINE       => 2.5,  # Electric Terrain + 1.3x SpAtk
      :SUPREMEOVERLORD    => 2.0,  # +10% per fainted ally
      :PROTOSYNTHESIS     => 1.8,  # Highest stat x1.3 in Sun
      :QUARKDRIVE         => 1.8,  # Highest stat x1.3 in Electric Terrain
      :TOXICDEBRIS        => 1.5,  # Sets Toxic Spikes on hit
      
      # Gen 9 Ruin Abilities (Treasures of Ruin)
      :SWORDOFRUIN        => 2.5,  # -25% Def to all others (Chien-Pao)
      :BEADSOFRUIN        => 2.5,  # -25% SpDef to all others (Chi-Yu)
      :TABLETSOFRUIN      => 1.5,  # -25% Atk to all others (Wo-Chien)
      :VESSELOFRUIN       => 1.5,  # -25% SpAtk to all others (Ting-Lu)
      
      # Status-Boost Offense
      :TOXICBOOST         => 2.0,  # 1.5x physical when poisoned
      :FLAREBOOST         => 2.0,  # 1.5x special when burned
      
      # Gen 9 DLC
      :POISONPUPPETEER    => 2.0,  # Poison also confuses (Pecharunt)
      :SUPERSWEETSYRUP    => 1.5,  # -1 Evasion to all opponents on entry
      :EMBODYASPECT       => 1.8,  # +1 stat on entry (Ogerpon)
      :ZEROTOHERO         => 2.5,  # Hero form Palafin = massive stats
      
      # As One (Calyrex fusions) - Unnerve + KO momentum
      :ASONEGLASTRIER     => 2.5,  # Unnerve + Chilling Neigh (+1 Atk on KO)
      :ASONESPECTRIER     => 2.5,  # Unnerve + Grim Neigh (+1 SpAtk on KO)
      
      # Mind's Eye - ignore evasion + hit Ghost with Normal/Fighting
      :MINDSEYE           => 1.5,  # Scrappy + accuracy bypass
      
      # Gorilla Tactics (Darmanitan-G) - 1.5x Atk but locked into one move
      :GORILLATACTICS     => 2.0,
    }
    
    #===========================================================================
    # Defensive Abilities (reduce Threat / increase Survival)
    #===========================================================================
    DEFENSIVE_ABILITIES = {
      # Damage Reduction (Threat -2.0)
      :MULTISCALE         => -2.5, # 50% damage at full HP
      :SHADOWSHIELD       => -2.5, # Same as Multiscale
      :FILTER             => -1.5, # 0.75x SE damage
      :SOLIDROCK          => -1.5, # Same as Filter
      :PRISMARMOR         => -1.8, # 0.75x SE damage (better)
      :FURCOAT            => -3.0, # 2x Defense (physical)
      :FLUFFY             => -2.0, # 50% contact damage (but 2x Fire)
      
      # Immunities (Threat -1.5)
      :WONDERGUARD        => -5.0, # Only SE damage (extreme)
      :LEVITATE           => -1.5, # Ground immunity
      :VOLTABSORB         => -1.5, # Electric immunity + heal
      :WATERABSORB        => -1.5, # Water immunity + heal
      :FLASHFIRE          => -1.5, # Fire immunity + boost
      :SAPSIPPER          => -1.5, # Grass immunity + Atk boost
      :STORMDRAIN         => -2.0, # Water immunity + SpAtk boost
      :LIGHTNINGROD       => -2.0, # Electric immunity + SpAtk boost
      :MOTORDRIVE         => -1.8, # Electric immunity + Speed boost
      :DRYSKIN            => -1.5, # Water heal, Fire weak
      :THICKFAT           => -1.5, # 50% Fire/Ice damage
      
      # Recovery (Threat -1.5)
      :REGENERATOR        => -2.0, # 33% HP on switch
      :POISONHEAL         => -2.0, # Heal from poison
      :ICEBODY            => -1.0, # Heal in Hail/Snow
      :RAINDISH           => -1.0, # Heal in Rain
      
      # Stat-Boost (Threat -1.0)
      :CONTRARY           => -1.5, # Reverse stat changes
      :UNAWARE            => -2.0, # Ignore opponent stat changes
      :CLEARBODY          => -1.0, # Prevent stat drops
      :WHITESMOKE         => -1.0, # Same as Clear Body
      :FULLMETALBODY      => -1.0, # Same as Clear Body
      :HYPERCUTTER        => -0.5, # Prevent Atk drops
      :KEENEYE            => -0.5, # Prevent Acc drops
      :BIGPECKS           => -0.5, # Prevent Def drops
      
      # Status Immunity (Threat -1.0)
      :IMMUNITY           => -1.0, # Poison immunity
      :WATERVEIL          => -0.8, # Burn immunity
      :MAGMAARMOR         => -0.8, # Freeze immunity
      :LIMBER             => -0.8, # Paralysis immunity
      :INSOMNIA           => -0.8, # Sleep immunity
      :VITALSPIRIT        => -0.8, # Sleep immunity
      :OBLIVIOUS          => -1.0, # Attract/Taunt immunity
      :INNERFOCUS         => -0.8, # Flinch immunity
      
      # Gen 9 Defensive
      :WELLBAKEDBODY      => -2.0, # Fire immunity + Def boost
      :EARTHEATER         => -2.0, # Ground immunity + heal
      :WINDRIDER          => -1.8, # Wind immunity + Atk boost
      :GUARDDOG           => -1.0, # Intimidate immunity + Atk boost
      :PURIFYINGSALT      => -2.0, # Ghost resist + status immunity
      
      # Ice Scales (Frosmoth) - halves special damage
      :ICESCALES          => -2.5, # 50% special damage taken
      
      # Reactive Defensive
      :STAMINA            => -1.5, # +1 Def when hit
      :COTTONDOWN         => -0.5, # -1 Speed to all when hit
      :WEAKARMOR          => -0.5, # Physical hit: -1 Def, +2 Speed (mixed)
      :ANGERSHELL         => -0.5, # Below 50%: +1 Atk/SpAtk/Speed, -1 Def/SpDef
      :ELECTROMORPHOSIS   => -0.5, # Gains Charge when hit
      :WINDPOWER          => -0.3, # Gains Charge from wind moves
      
      # Gen 9 DLC Defensive
      :TERASHELL          => -3.0, # All hits NVE at full HP (Terapagos)
      :TERAFORMZERO       => -1.0, # Removes weather/terrain (Terapagos)
      :TERASHIFT          => -0.5, # Auto-transform to Terastal (Terapagos)
      
      # Seed Sower (Arboliva) - sets Grassy Terrain when hit
      :SEEDSOWER          => -1.0, # Sets Grassy Terrain on contact (healing + Grass boost)
      
      # Good as Gold (Gholdengo) - immune to status moves
      :GOODASGOLD         => -2.5,
    }
    
    #===========================================================================
    # Speed Abilities (increase Speed Threat)
    #===========================================================================
    SPEED_ABILITIES = {
      # Speed-Boost (Threat +1.5)
      :SPEEDBOOST         => 2.0,  # +1 Speed per turn
      :MOTORDRIVE         => 1.5,  # +1 Speed on Electric hit
      :QUICKFEET          => 1.5,  # 1.5x Speed with status
      :UNBURDEN           => 2.5,  # 2x Speed after item use
      :CHLOROPHYLL        => 2.0,  # 2x Speed in Sun
      :SWIFTSWIM          => 2.0,  # 2x Speed in Rain
      :SANDRUSH           => 2.0,  # 2x Speed in Sandstorm
      :SLUSHRUSH          => 2.0,  # 2x Speed in Hail/Snow (Gen 9: also Snow)
      :PROTOSYNTHESIS     => 1.5,  # Highest stat x1.3 in Sun/Booster Energy (speed threat if Speed is highest)
      :QUARKDRIVE         => 1.5,  # Highest stat x1.3 in Elec Terrain/Booster Energy (speed threat)
      :SURGESURFER        => 2.0,  # 2x Speed in Electric Terrain
      
      # Priority (Threat +1.5)
      :PRANKSTER          => 2.5,  # +1 priority on status moves
      :GALEWINGS          => 2.0,  # +1 priority on Flying moves (full HP)
      :TANGLINGHAIR       => 1.0,  # Lower Speed on contact
      
      # Gen 9 Speed
    }
    
    #===========================================================================
    # Support Abilities (increase Team Utility)
    #===========================================================================
    SUPPORT_ABILITIES = {
      # Disruption (Threat +1.0)
      :INTIMIDATE         => 1.5,  # -1 Atk to opponents
      :DROUGHT            => 1.5,  # Sets Sun
      :DRIZZLE            => 1.5,  # Sets Rain
      :SANDSTREAM         => 1.5,  # Sets Sandstorm
      :SNOWWARNING        => 1.5,  # Sets Snow (Gen 9; previously Hail)
      :ELECTRICSURGE      => 1.5,  # Sets Electric Terrain
      :GRASSYSURGE        => 1.5,  # Sets Grassy Terrain
      :MISTYSURGE         => 1.5,  # Sets Misty Terrain
      :PSYCHICSURGE       => 1.5,  # Sets Psychic Terrain
      
      # Redirect (Threat +1.0)
      :LIGHTNINGROD       => 1.5,  # Redirect Electric
      :STORMDRAIN         => 1.5,  # Redirect Water
      
      # Reflection (Threat +1.5)
      :MAGICBOUNCE        => 2.0,  # Reflect status moves
      :MAGICGUARD         => 1.5,  # No indirect damage
      
      # Entry Hazards (Threat +1.0)
      :ROUGHSKIN          => 1.0,  # Damage on contact
      :IRONBARBS          => 1.0,  # Damage on contact
      :POISONPOINT        => 0.8,  # 30% Poison on contact
      :STATIC             => 0.8,  # 30% Paralyze on contact
      :FLAMEBODY          => 0.8,  # 30% Burn on contact
      
      # Gen 9 Support
      :COSTAR             => 1.5,  # Copy ally stat changes
      :OPPORTUNIST        => 1.8,  # Copy opponent stat boosts
      :COMMANDER          => 2.0,  # Dondozo synergy (Hidden)
      :HOSPITALITY        => 1.0,  # Heal ally on entry
    }
    
    #===========================================================================
    # Ability Recognition
    #===========================================================================
    
    # Returns Threat Modifier for Ability
    def self.get_ability_threat(ability_id)
      return 0.0 if !ability_id
      
      ability_id = ability_id.to_sym if ability_id.is_a?(String)
      
      # Combine threat from all categories (abilities can fill multiple roles)
      threat = 0.0
      threat += OFFENSIVE_ABILITIES[ability_id] if OFFENSIVE_ABILITIES.key?(ability_id)
      threat += DEFENSIVE_ABILITIES[ability_id] if DEFENSIVE_ABILITIES.key?(ability_id)
      threat += SPEED_ABILITIES[ability_id] if SPEED_ABILITIES.key?(ability_id)
      threat += SUPPORT_ABILITIES[ability_id] if SUPPORT_ABILITIES.key?(ability_id)
      
      return threat
    end
    
    # Checks if Ability is defensive
    def self.defensive_ability?(ability_id)
      return false if !ability_id
      ability_id = ability_id.to_sym if ability_id.is_a?(String)
      return DEFENSIVE_ABILITIES.key?(ability_id)
    end
    
    # Checks if Ability is offensive
    def self.offensive_ability?(ability_id)
      return false if !ability_id
      ability_id = ability_id.to_sym if ability_id.is_a?(String)
      return OFFENSIVE_ABILITIES.key?(ability_id)
    end
    
    # Checks if Ability boosts Speed
    def self.speed_ability?(ability_id)
      return false if !ability_id
      ability_id = ability_id.to_sym if ability_id.is_a?(String)
      return SPEED_ABILITIES.key?(ability_id)
    end
    
    # Checks if Ability has Support function
    def self.support_ability?(ability_id)
      return false if !ability_id
      ability_id = ability_id.to_sym if ability_id.is_a?(String)
      return SUPPORT_ABILITIES.key?(ability_id)
    end
    
    # Categorizes Ability
    def self.categorize_ability(ability_id)
      return :unknown if !ability_id
      ability_id = ability_id.to_sym if ability_id.is_a?(String)
      
      return :offensive if OFFENSIVE_ABILITIES.key?(ability_id)
      return :defensive if DEFENSIVE_ABILITIES.key?(ability_id)
      return :speed if SPEED_ABILITIES.key?(ability_id)
      return :support if SUPPORT_ABILITIES.key?(ability_id)
      
      return :unknown
    end
    
    #===========================================================================
    # Weather/Terrain Synergy Detection
    #===========================================================================
    
    # Checks if Ability benefits from current Weather
    def self.benefits_from_weather?(battler, weather)
      return false if !battler || !weather
      return false unless battler.respond_to?(:hasActiveAbility?)
      
      case weather
      when :Sun, :HarshSun
        return [:CHLOROPHYLL, :SOLARPOWER, :FLOWERGIFT, :LEAFGUARD, 
                :HARVEST, :PROTOSYNTHESIS, :ORICHALCUMPULSE].any? { |a| battler.hasActiveAbility?(a) }
      when :Rain, :HeavyRain
        return [:SWIFTSWIM, :RAINDISH, :DRYSKIN, :HYDRATION].any? { |a| battler.hasActiveAbility?(a) }
      when :Sandstorm
        return [:SANDRUSH, :SANDVEIL, :SANDFORCE].any? { |a| battler.hasActiveAbility?(a) }
      when :Hail, :Snow
        return [:SLUSHRUSH, :SNOWCLOAK, :ICEBODY, :ICEFACE].any? { |a| battler.hasActiveAbility?(a) }
      end
      
      return false
    end
    
    # Checks if Ability benefits from active Terrain
    def self.benefits_from_terrain?(battler, terrain)
      return false if !battler || !terrain
      return false unless battler.respond_to?(:hasActiveAbility?)
      
      case terrain
      when :Electric
        return [:SURGESURFER, :QUARKDRIVE, :HADRONENGINE].any? { |a| battler.hasActiveAbility?(a) }
      when :Grassy
        return battler.hasActiveAbility?(:GRASSPELT)
      when :Psychic
        return false  # No direct Ability synergies
      when :Misty
        return false  # No direct Ability synergies
      end
      
      return false
    end
    
    #===========================================================================
    # Ability Nullification Check
    #===========================================================================
    
    # Checks if Attacker ignores Abilities
    def self.ignores_abilities?(attacker)
      return false if !attacker
      return false unless attacker.respond_to?(:hasActiveAbility?)
      
      return [:MOLDBREAKER, :TERAVOLT, :TURBOBLAZE, 
              :NEUTRALIZINGGAS].any? { |a| attacker.hasActiveAbility?(a) }
    end
    
    # Checks if Target Ability is suppressed by Attacker
    def self.ability_suppressed?(attacker, target)
      return false if !attacker || !target
      return true if ignores_abilities?(attacker)
      return true if target.respond_to?(:effects) && target.effects[PBEffects::GastroAcid]  # Gastro Acid
      return false
    end
    
    #===========================================================================
    # Complex Ability Interactions
    #===========================================================================
    
    # Calculates final Damage Modifier from Abilities
    def self.calculate_ability_damage_modifier(attacker, target, move, battle)
      modifier = 1.0
      return modifier if !attacker || !target || !move
      
      # Use hasActiveAbility? for active battlers (handles all suppression: Gastro Acid,
      # Neutralizing Gas, etc.). Fall back to ability_id for party Pokemon.
      if attacker.respond_to?(:hasActiveAbility?)
        attacker_ability = attacker.ability_id
        attacker_suppressed = !attacker.hasActiveAbility?(attacker_ability)
      else
        attacker_ability = attacker.respond_to?(:ability_id) ? attacker.ability_id : nil
        attacker_suppressed = false
      end
      if target.respond_to?(:hasActiveAbility?)
        target_ability = target.ability_id
      else
        target_ability = target.respond_to?(:ability_id) ? target.ability_id : nil
      end
      if attacker_ability && !attacker_suppressed
        case attacker_ability
        when :HUGEPOWER, :PUREPOWER
          modifier *= 2.0 if move.physicalMove?
        when :ADAPTABILITY
          atk_types = attacker.respond_to?(:pbTypes) ? attacker.pbTypes(true) : (attacker.respond_to?(:types) ? attacker.types : [attacker.type1, attacker.type2].compact)
          resolved_type = AdvancedAI::CombatUtilities.resolve_move_type(attacker, move)
          modifier *= (4.0 / 3.0) if atk_types.include?(resolved_type)  # STAB upgrade: 2.0/1.5
        when :TOUGHCLAWS
          modifier *= 1.3 if move.contactMove?
        when :SHEERFORCE
          modifier *= 1.3 if move.addlEffect.to_i > 0
        when :TECHNICIAN
          modifier *= 1.5 if move.power <= 60
        when :IRONFIST
          modifier *= 1.2 if move.punchingMove?
        when :STRONGJAW
          modifier *= 1.5 if move.bitingMove?
        when :TINTEDLENS
          resolved_type = AdvancedAI::CombatUtilities.resolve_move_type(attacker, move)
          effectiveness = AdvancedAI::Utilities.type_mod(resolved_type, target)
          modifier *= 2.0 if Effectiveness.not_very_effective?(effectiveness)
        when :MINDSEYE
          # Ignore target evasion stages and hit Ghost with Normal/Fighting
          # This is handled in accuracy/type calcs, but bump modifier slightly
          # for coverage value (treats Ghost as hittable by Normal/Fighting)
          modifier *= 1.0  # No direct damage mod, but prevents immunity
        end
      end
      
      # Target Abilities (Defensive)
      if target_ability && !ability_suppressed?(attacker, target)
        case target_ability
        when :MULTISCALE, :SHADOWSHIELD
          modifier *= 0.5 if target.hp == target.totalhp
        when :FILTER, :SOLIDROCK, :PRISMARMOR
          resolved_type = AdvancedAI::CombatUtilities.resolve_move_type(attacker, move)
          effectiveness = AdvancedAI::Utilities.type_mod(resolved_type, target)
          modifier *= 0.75 if Effectiveness.super_effective?(effectiveness)
        when :FURCOAT
          modifier *= 0.5 if move.physicalMove?
        when :FLUFFY
          modifier *= 0.5 if move.contactMove?
          fluffy_type = AdvancedAI::CombatUtilities.resolve_move_type(attacker, move)
          modifier *= 2.0 if fluffy_type == :FIRE
        when :THICKFAT
          thick_fat_type = AdvancedAI::CombatUtilities.resolve_move_type(attacker, move)
          modifier *= 0.5 if [:FIRE, :ICE].include?(thick_fat_type)
        when :ICESCALES
          modifier *= 0.5 if move.specialMove?  # Halves special damage
        when :TERASHELL
          # All hits become NVE at full HP
          modifier *= 0.5 if target.hp == target.totalhp
        end
      end
      
      # Ruin Abilities (affect ALL other Pokemon on field)
      # These are field-wide auras, not target-specific
      # Attacker has Ruin ability: boosts our effective damage
      if attacker_ability && !attacker_suppressed
        if attacker_ability == :SWORDOFRUIN && move.physicalMove?
          modifier *= 4.0 / 3.0  # Target's Def is lowered by 25% → 1/0.75
        end
        if attacker_ability == :BEADSOFRUIN && move.specialMove?
          modifier *= 4.0 / 3.0  # Target's SpDef is lowered by 25% → 1/0.75
        end
        # Toxic Boost / Flare Boost
        if attacker_ability == :TOXICBOOST && attacker.respond_to?(:poisoned?) && attacker.poisoned? && move.physicalMove?
          modifier *= 1.5
        end
        if attacker_ability == :FLAREBOOST && attacker.respond_to?(:burned?) && attacker.burned? && move.specialMove?
          modifier *= 1.5
        end
      end
      # Opponent has Tablets of Ruin: our Atk is lowered
      if target_ability && !ability_suppressed?(attacker, target)
        if target_ability == :TABLETSOFRUIN && move.physicalMove?
          modifier *= 0.75  # Our Atk is lowered by 25%
        end
        # Opponent has Vessel of Ruin: our SpAtk is lowered
        if target_ability == :VESSELOFRUIN && move.specialMove?
          modifier *= 0.75  # Our SpAtk is lowered by 25%
        end
      end
      
      return modifier
    end
    
  end
end

#===============================================================================
# API Wrapper
#===============================================================================
module AdvancedAI
  def self.get_ability_threat(ability_id)
    CustomContent.get_ability_threat(ability_id)
  end
  
  def self.defensive_ability?(ability_id)
    CustomContent.defensive_ability?(ability_id)
  end
  
  def self.offensive_ability?(ability_id)
    CustomContent.offensive_ability?(ability_id)
  end
  
  def self.categorize_ability(ability_id)
    CustomContent.categorize_ability(ability_id)
  end
  
  def self.benefits_from_weather?(battler, weather)
    CustomContent.benefits_from_weather?(battler, weather)
  end
  
  def self.benefits_from_terrain?(battler, terrain)
    CustomContent.benefits_from_terrain?(battler, terrain)
  end
  
  def self.ignores_abilities?(attacker)
    CustomContent.ignores_abilities?(attacker)
  end
  
  def self.ability_suppressed?(attacker, target)
    CustomContent.ability_suppressed?(attacker, target)
  end
  
  def self.calculate_ability_damage_modifier(attacker, target, move, battle)
    CustomContent.calculate_ability_damage_modifier(attacker, target, move, battle)
  end
end

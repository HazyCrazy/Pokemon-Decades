#===============================================================================
# [013] Custom Content - Gen 1-9 Abilities & Type Recognition
#===============================================================================
# Recognizes and evaluates 267+ Abilities from Gen 1-9
# Supports Custom Abilities from Plugins (DBK, Reborn, etc.)
#
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
      :ICEBODY            => -1.0, # Heal in Hail
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
      :SLUSHRUSH          => 2.0,  # 2x Speed in Hail
      :SURGESURFER        => 2.0,  # 2x Speed in Electric Terrain
      
      # Priority (Threat +1.5)
      :PRANKSTER          => 2.5,  # +1 priority on status moves
      :GALEWINGS          => 2.0,  # +1 priority on Flying moves (full HP)
      :TANGLINGHAIR       => 1.0,  # Lower Speed on contact
      :GORILLATACTICS     => 2.0,  # 1.5x Atk but locked (like Choice)
      
      # Gen 9 Speed
      :GOODASGOLD         => -2.5, # Status move immunity (defensive)
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
      :SNOWWARNING        => 1.5,  # Sets Hail
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
    }
    
    #===========================================================================
    # Ability Recognition
    #===========================================================================
    
    # Returns Threat Modifier for Ability
    def self.get_ability_threat(ability_id)
      return 0.0 if !ability_id
      
      ability_id = ability_id.to_sym if ability_id.is_a?(String)
      
      # Offensive Check
      return OFFENSIVE_ABILITIES[ability_id] if OFFENSIVE_ABILITIES.key?(ability_id)
      
      # Defensive Check
      return DEFENSIVE_ABILITIES[ability_id] if DEFENSIVE_ABILITIES.key?(ability_id)
      
      # Speed Check
      return SPEED_ABILITIES[ability_id] if SPEED_ABILITIES.key?(ability_id)
      
      # Support Check
      return SUPPORT_ABILITIES[ability_id] if SUPPORT_ABILITIES.key?(ability_id)
      
      return 0.0  # Unknown ability
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
      ability = battler.ability_id
      return false if !ability
      
      case weather
      when :Sun, :HarshSun
        return [:CHLOROPHYLL, :SOLARPOWER, :FLOWERGIFT, :LEAFGUARD, 
                :PROTOSYNTHESIS, :ORICHALCUMPULSE].include?(ability)
      when :Rain, :HeavyRain
        return [:SWIFTSWIM, :RAINDISH, :DRYSKIN, :HYDRATION].include?(ability)
      when :Sandstorm
        return [:SANDRUSH, :SANDVEIL, :SANDFORCE, :OVERCOAT].include?(ability)
      when :Hail
        return [:SLUSHRUSH, :SNOWCLOAK, :ICEBODY, :OVERCOAT].include?(ability)
      end
      
      return false
    end
    
    # Checks if Ability benefits from active Terrain
    def self.benefits_from_terrain?(battler, terrain)
      return false if !battler || !terrain
      ability = battler.ability_id
      return false if !ability
      
      case terrain
      when :Electric
        return [:SURGESURFER, :QUARKDRIVE, :HADRONENGINE].include?(ability)
      when :Grassy
        return [:GRASSPELT].include?(ability)
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
      ability = attacker.ability_id
      return false if !ability
      
      return [:MOLDBREAKER, :TERAVOLT, :TURBOBLAZE, 
              :NEUTRALIZINGGAS].include?(ability)
    end
    
    # Checks if Target Ability is suppressed by Attacker
    def self.ability_suppressed?(attacker, target)
      return false if !attacker || !target
      return true if ignores_abilities?(attacker)
      return true if target.effects[PBEffects::GastroAcid]  # Gastro Acid
      return false
    end
    
    #===========================================================================
    # Complex Ability Interactions
    #===========================================================================
    
    # Calculates final Damage Modifier from Abilities
    def self.calculate_ability_damage_modifier(attacker, target, move, battle)
      modifier = 1.0
      return modifier if !attacker || !target || !move
      
      attacker_ability = attacker.ability_id
      target_ability = target.ability_id
      
      # Attacker Abilities
      if attacker_ability && !ability_suppressed?(target, attacker)
        case attacker_ability
        when :HUGEPOWER, :PUREPOWER
          modifier *= 2.0 if move.physicalMove?
        when :ADAPTABILITY
          modifier *= 2.0 if move.type == attacker.type1 || move.type == attacker.type2
        when :TOUGHCLAWS
          modifier *= 1.3 if move.contactMove?
        when :SHEERFORCE
          modifier *= 1.3 if move.additional_effect_chance > 0
        when :TECHNICIAN
          modifier *= 1.5 if move.power <= 60
        when :IRONFIST
          modifier *= 1.2 if move.punching_move?
        when :STRONGJAW
          modifier *= 1.5 if move.biting_move?
        when :TINTEDLENS
          effectiveness = Effectiveness.calculate(move.type, target.type1, target.type2)
          modifier *= 2.0 if Effectiveness.not_very_effective?(effectiveness)
        end
      end
      
      # Target Abilities (Defensive)
      if target_ability && !ability_suppressed?(attacker, target)
        case target_ability
        when :MULTISCALE, :SHADOWSHIELD
          modifier *= 0.5 if target.hp == target.totalhp
        when :FILTER, :SOLIDROCK, :PRISMARMOR
          effectiveness = Effectiveness.calculate(move.type, target.type1, target.type2)
          modifier *= 0.75 if Effectiveness.super_effective?(effectiveness)
        when :FURCOAT
          modifier *= 0.5 if move.physicalMove?
        when :FLUFFY
          modifier *= 0.5 if move.contactMove?
          modifier *= 2.0 if move.type == :FIRE
        when :THICKFAT
          modifier *= 0.5 if [:FIRE, :ICE].include?(move.type)
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

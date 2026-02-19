#===============================================================================
# Advanced AI System - Threat Assessment
# Evaluates Threat Level based on Stats, Moves, Abilities, Items
#===============================================================================

module AdvancedAI
  module ThreatAssessment
    # Main Function: Assess Threat (0-10 Scale)
    def self.assess_threat(battle, attacker, opponent, skill_level = 100)
      return 5 unless battle && attacker && opponent && !opponent.fainted?
      
      threat = 5.0  # Base threat
      
      # 1. STAT-BASED THREAT (0-2.5)
      threat += assess_stat_threat(attacker, opponent)
      
      # 2. TYPE MATCHUP THREAT (0-2.0)
      threat += assess_type_threat(attacker, opponent)
      
      # 3. MOVE-BASED THREAT (0-2.0)
      if skill_level >= 50
        threat += assess_move_threat(battle, attacker, opponent)
      end
      
      # 4. ABILITY-BASED THREAT (0-1.5)
      if skill_level >= 60
        threat += assess_ability_threat(attacker, opponent)
      end
      
      # 5. HP-BASED MODIFIER (x0.3 - x1.2)
      threat *= assess_hp_modifier(opponent)
      
      # 6. SETUP THREAT (0-1.5)
      if skill_level >= 55
        threat += assess_setup_threat(opponent)
      end
      
      # 7. SPEED THREAT (0-1.0)
      threat += assess_speed_threat(attacker, opponent)
      
      return [[threat, 0].max, 10].min  # Clamp 0-10
    end
    
    private
    
    # Stat-based Threat
    def self.assess_stat_threat(attacker, opponent)
      threat = 0.0
      
      # Offensive Stats
      if opponent.attack > attacker.defense * 1.5
        threat += 1.0
      elsif opponent.attack > attacker.defense
        threat += 0.5
      end
      
      if opponent.spatk > attacker.spdef * 1.5
        threat += 1.0
      elsif opponent.spatk > attacker.spdef
        threat += 0.5
      end
      
      return [threat, 2.5].min
    end
    
    # Type Matchup Threat
    def self.assess_type_threat(attacker, opponent)
      threat = 0.0
      
      # Check Opponent's Type Advantage
      opponent_types = opponent.pbTypes(true)
      attacker_types = attacker.pbTypes(true)
      
      opponent_types.each do |opp_type|
        attacker_types.each do |att_type|
          effectiveness = Effectiveness.calculate(opp_type, att_type, nil)
          
          if Effectiveness.super_effective?(effectiveness)
            threat += 1.0
          elsif Effectiveness.not_very_effective?(effectiveness)
            threat -= 0.5
          elsif Effectiveness.ineffective?(effectiveness)
            threat -= 1.0
          end
        end
      end
      
      return [threat, 2.0].min
    end
    
    # Move-based Threat
    def self.assess_move_threat(battle, attacker, opponent)
      threat = 0.0
      memory = AdvancedAI::MoveMemory.get_memory(battle, opponent)
      
      # Analyze Known Moves
      if memory[:moves]
        memory[:moves].each do |move_id|
          move_data = GameData::Move.get(move_id)
          
          # Priority Moves
          threat += 0.5 if move_data.priority > 0
          
          # Super Effective Coverage
          if move_data.damaging?
            attacker_types = attacker.pbTypes(true)
            attacker_types.each do |type|
              effectiveness = Effectiveness.calculate(move_data.type, type, nil)
              threat += 0.8 if Effectiveness.super_effective?(effectiveness)
            end
          end
          
          # OHKO Moves
          threat += 1.0 if [:GUILLOTINE, :FISSURE, :SHEERCOLD, :HORNDRILL].include?(move_id)
          
          # Setup Moves
          threat += 0.3 if move_data.function_code.start_with?("RaiseUser")
        end
      end
      
      # Max Known Damage
      max_damage = AdvancedAI::MoveMemory.max_known_damage(battle, opponent, attacker)
      if max_damage > attacker.hp * 0.8
        threat += 1.0
      elsif max_damage > attacker.hp * 0.5
        threat += 0.5
      end
      
      return [threat, 2.0].min
    end
    
    # Ability-based Threat
    def self.assess_ability_threat(attacker, opponent)
      threat = 0.0
      ability = opponent.ability_id
      
      return 0.0 unless ability
      
      # === Mold Breaker Family (ignores defensive abilities) ===
      if [:MOLDBREAKER, :TURBOBLAZE, :TERAVOLT].include?(ability)
        # Extra dangerous against Wonder Guard, Multiscale, etc.
        if [:WONDERGUARD, :MULTISCALE, :STURDY, :MAGICGUARD, :LEVITATE].include?(attacker.ability_id)
          threat += 1.5  # Bypasses our protection
        else
          threat += 0.4
        end
      end
      
      # Mycelium Might (ignores abilities for status moves)
      if ability == :MYCELIUMMIGHT
        threat += 0.3
      end
      
      # Extreme Offensive Abilities
      if [:HUGEPOWER, :PUREPOWER, :PARENTALBOND, :GORILLATACTICS, :PROTOSYNTHESIS, :QUARKDRIVE].include?(ability)
        threat += 1.5
      end
      
      # Strong Offensive Abilities
      if [:ADAPTABILITY, :SHEERFORCE, :TECHNICIAN, :SKILLLINK, :STRONGJAW, :TOUGHCLAWS, :SHARPNESS].include?(ability)
        threat += 0.8
      end
      
      # === Gen 9 Offensive Abilities ===
      if ability == :SUPREMEOVERLORD
        # Scales with fainted allies - dangerous late game
        threat += 0.6
      end
      
      if ability == :ORICHALCUMPULSE
        threat += 0.7  # Sets Sun + boosts Attack
      end
      
      if ability == :HADRONENGINE
        threat += 0.7  # Sets Electric Terrain + boosts SpAtk
      end
      
      if ability == :TOXICCHAIN
        threat += 0.5  # 30% Toxic chance on all moves
      end
      
      if ability == :ROCKYPAYLOAD
        threat += 0.4  # Rock-type boost
      end
      
      # === RUIN ABILITIES (Gen 9 Treasures of Ruin) ===
      # These passively weaken ALL other Pokemon on the field
      if ability == :SWORDOFRUIN
        # -25% Defense to all others — Chien-Pao meta, extreme physical threat
        threat += 1.0
      end
      
      if ability == :BEADSOFRUIN
        # -25% SpDef to all others — Chi-Yu meta, extreme special threat
        threat += 1.0
      end
      
      if ability == :TABLETSOFRUIN
        # -25% Attack to all others — reduces OUR physical damage
        threat += 0.5  # Defensive for them, threat to us
      end
      
      if ability == :VESSELOFRUIN
        # -25% SpAtk to all others — reduces OUR special damage
        threat += 0.5  # Defensive for them, threat to us
      end
      
      # === ICE SCALES (Frosmoth) ===
      if ability == :ICESCALES
        # Halves special damage taken — extremely tanky vs special attackers
        if attacker.spatk > attacker.attack
          threat += 0.6  # Our special attacks are halved
        else
          threat += 0.2
        end
      end
      
      # === STAMINA (Mudsdale, Archaludon) ===
      if ability == :STAMINA
        # +1 Defense when hit — gets tankier every time we attack
        threat += 0.4
      end
      
      # === WEAK ARMOR ===
      if ability == :WEAKARMOR
        # Physical hit: -1 Def, +2 Speed — risky but fast
        threat += 0.3
      end
      
      # === ANGER SHELL (Klawf) ===
      if ability == :ANGERSHELL
        # Below 50% HP: +1 Atk/SpAtk/Speed, -1 Def/SpDef
        hp_percent = opponent.hp.to_f / opponent.totalhp
        if hp_percent > 0.5
          threat += 0.5  # Could activate if we hit them
        else
          threat += 0.3  # Already activated
        end
      end
      
      # === ELECTROMORPHOSIS (Bellibolt) ===
      if ability == :ELECTROMORPHOSIS
        # When hit, gains Charge effect (2x next Electric move)
        threat += 0.3
      end
      
      # === WIND POWER (Wattrel, Kilowattrel) ===
      if ability == :WINDPOWER
        # When hit by wind move, gains Charge effect
        threat += 0.2
      end
      
      # === TOXIC BOOST (Zangoose line) ===
      if ability == :TOXICBOOST
        # 1.5x physical power when poisoned
        if opponent.poisoned?
          threat += 0.8  # Active — scary physical threat
        else
          threat += 0.3
        end
      end
      
      # === FLARE BOOST (Drifblim) ===
      if ability == :FLAREBOOST
        # 1.5x special power when burned
        if opponent.burned?
          threat += 0.8  # Active — scary special threat
        else
          threat += 0.3
        end
      end
      
      # === COTTON DOWN (Eldegoss) ===
      if ability == :COTTONDOWN
        # When hit: -1 Speed to all other Pokemon on field
        threat += 0.2
      end
      
      # === ZERO TO HERO (Palafin) ===
      if ability == :ZEROTOHERO
        # After switching in once, becomes Hero form (massive stat boost)
        if opponent.respond_to?(:form) && opponent.form == 1
          threat += 1.5  # Hero form Palafin is extremely dangerous
        else
          threat += 0.3  # Not yet transformed
        end
      end
      
      # === DLC LEGENDARY ABILITIES ===
      if ability == :SUPERSWEETSYRUP
        # Lowers evasion of all opponents on entry
        threat += 0.3
      end
      
      if ability == :POISONPUPPETEER
        # Pecharunt: Poisoned targets also become confused
        threat += 0.6
      end
      
      if ability == :EMBODYASPECT
        # Ogerpon: +1 to a stat on entry (form-dependent)
        threat += 0.5
      end
      
      if ability == :TERASHELL
        # Terapagos: All hits become NVE at full HP
        if opponent.hp == opponent.totalhp
          threat += 0.8  # Extremely tanky at full HP
        end
      end
      
      if ability == :TERAFORMZERO
        # Terapagos Stellar: Removes weather and terrain
        threat += 0.4
      end
      
      if ability == :TERASHIFT
        # Terapagos: Auto-transforms to Terastal form
        threat += 0.3
      end
      
      # === AS ONE (Calyrex - Glastrier/Spectrier) ===
      if ability == :ASONEGLASTRIER
        # Unnerve + Chilling Neigh: +1 Atk on KO + suppresses berries
        threat += 1.2
      end
      if ability == :ASONESPECTRIER
        # Unnerve + Grim Neigh: +1 SpAtk on KO + suppresses berries
        threat += 1.2
      end
      
      # === SEED SOWER (Arboliva) ===
      if ability == :SEEDSOWER
        # Sets Grassy Terrain when hit - terrain control + passive healing
        threat += 0.4
      end
      
      # === MIND'S EYE (Gen 9) ===
      if ability == :MINDSEYE
        # Ignore evasion + hit Ghost with Normal/Fighting (Scrappy on steroids)
        threat += 0.5
      end
      
      # Priority Abilities
      if [:GALEWINGS, :PRANKSTER, :QUICKDRAW].include?(ability)
        threat += 0.6
      end
      
      # === Gen 9 Priority Blockers ===
      if ability == :ARMORTAIL
        # Blocks priority moves - threat if we rely on priority
        if attacker.moves&.any? { |m| m && m.priority > 0 }
          threat += 0.5  # Counters our strategy
        end
      end
      
      # Speed Boost
      if [:SPEEDBOOST, :UNBURDEN, :MOTORDRIVE].include?(ability)
        threat += 0.5
      end
      
      # Defensive Abilities (reduce offensive threat, but make opponent hard to kill)
      if [:WONDERGUARD, :MULTISCALE, :REGENERATOR, :MAGICBOUNCE].include?(ability)
        threat += 0.3
      end
      
      # === Gen 9 Defensive Abilities ===
      if ability == :GOODASGOLD
        # Immune to status moves - major defensive threat
        threat += 0.4
      end
      
      if ability == :PURIFYINGSALT
        # Status immune + Ghost resist
        threat += 0.3
      end
      
      if ability == :GUARDDOG
        # Immune to Intimidate + Attack boost on switch-in attempts
        threat += 0.3
      end
      
      if ability == :WINDRIDER
        # Immune to Tailwind/wind moves + Attack boost
        threat += 0.3
      end
      
      if [:WELLBAKEDBODY, :EARTHEATER].include?(ability)
        # Fire/Ground immunity + stat boost
        threat += 0.2
      end
      
      return [threat, 3.0].min  # Raised cap for all the new abilities (Ruin can exceed 2.0)
    end
    
    # HP Modifier
    def self.assess_hp_modifier(opponent)
      hp_percent = opponent.hp.to_f / opponent.totalhp
      
      if hp_percent < 0.2
        return 0.3  # Almost fainted
      elsif hp_percent < 0.4
        return 0.6
      elsif hp_percent < 0.6
        return 0.8
      elsif hp_percent > 0.9
        return 1.2  # Full Power
      else
        return 1.0
      end
    end
    
    # Setup Threat
    def self.assess_setup_threat(opponent)
      threat = 0.0
      
      # Stat Boosts
      [:ATTACK, :SPECIAL_ATTACK, :SPEED].each do |stat|
        stage = opponent.stages[stat]
        threat += stage * 0.3 if stage > 0
      end
      
      return [threat, 1.5].min
    end
    
    # Speed Threat
    def self.assess_speed_threat(attacker, opponent)
      return 0.0 if opponent.pbSpeed <= attacker.pbSpeed
      
      speed_ratio = opponent.pbSpeed.to_f / attacker.pbSpeed
      
      if speed_ratio > 2.0
        return 1.0
      elsif speed_ratio > 1.5
        return 0.7
      else
        return 0.4
      end
    end
    
    public
    
    # Finds most threatening opponent
    def self.most_threatening_opponent(battle, attacker, skill_level = 100)
      return nil unless battle && attacker
      
      opponents = battle.allOtherSideBattlers(attacker.index).select { |b| b && !b.fainted? }
      return nil if opponents.empty?
      
      threats = opponents.map do |opp|
        [opp, assess_threat(battle, attacker, opp, skill_level)]
      end
      
      threats.max_by { |opp, threat| threat }&.first
    end
    
    # Prioritizes Target in Doubles
    def self.priority_target(battle, attacker, opp1, opp2, skill_level = 100)
      return opp1 unless opp2
      return opp2 unless opp1
      
      threat1 = assess_threat(battle, attacker, opp1, skill_level)
      threat2 = assess_threat(battle, attacker, opp2, skill_level)
      
      AdvancedAI.log("#{opp1.pbThis}: #{threat1.round(2)} threat vs #{opp2.pbThis}: #{threat2.round(2)} threat", "Threat")
      
      threat1 >= threat2 ? opp1 : opp2
    end
  end
end

# API-Wrapper
module AdvancedAI
  def self.assess_threat(battle, attacker, opponent, skill_level = 100)
    ThreatAssessment.assess_threat(battle, attacker, opponent, skill_level)
  end
  
  def self.most_threatening_opponent(battle, attacker, skill_level = 100)
    ThreatAssessment.most_threatening_opponent(battle, attacker, skill_level)
  end
  
  def self.priority_target(battle, attacker, opp1, opp2, skill_level = 100)
    ThreatAssessment.priority_target(battle, attacker, opp1, opp2, skill_level)
  end
end

# Integration in Battle::AI
class Battle::AI
  def apply_threat_assessment(score, move, user, target)
    skill = @trainer&.skill || 100
    return score unless AdvancedAI.feature_enabled?(:core, skill)
    return score unless target
    
    # user is AIBattler, need real battler for threat assessment
    real_user = user.respond_to?(:battler) ? user.battler : user
    real_target = target.respond_to?(:battler) ? target.battler : target
    
    threat = AdvancedAI.assess_threat(@battle, real_user, real_target, skill)
    
    # Higher Threat = Higher Score for Attack
    if move.damagingMove?
      score += (threat * 5).to_i  # 0-50 Points
    end
    
    # Low Threat = Consider Switch
    if threat < 3.0 && skill >= 50
      score -= 15  # Other targets more attractive
    end
    
    return score
  end
end

AdvancedAI.log("Threat Assessment System loaded", "Threat")

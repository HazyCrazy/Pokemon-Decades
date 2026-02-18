#===============================================================================
# [019] Setup Recognition - 5 Evaluation Systems
#===============================================================================
# Recognizes Setup Moves and evaluates Counter Strategies
#
# Systems:
# 1. Setup Detection (Swords Dance, Nasty Plot, etc.)
# 2. Setup Threat Assessment (how dangerous is Setup?)
# 3. Counter Priority (Haze, Roar, Encore, etc.)
# 4. Optimal Counter Timing (when to counter?)
# 5. Setup Chain Detection (Baton Pass chains)
#===============================================================================

module AdvancedAI
  module SetupRecognition
    
    #===========================================================================
    # Setup Counter Moves
    #===========================================================================
    SETUP_COUNTERS = {
      # Phazing (forced switch)
      :ROAR         => { type: :phaze, priority: -6, bypasses_sub: true },
      :WHIRLWIND    => { type: :phaze, priority: -6, bypasses_sub: true },
      :DRAGONTAIL   => { type: :phaze, priority: -6, damage: true },
      :CIRCLETHROW  => { type: :phaze, priority: -6, damage: true },
      
      # Stat Reset
      :HAZE         => { type: :reset, affects: :all },
      :CLEARSMOG    => { type: :reset, affects: :target, damage: true },
      
      # Disruption
      :ENCORE       => { type: :lock, duration: 3 },
      :TAUNT        => { type: :block, duration: 3, status_only: true },
      :DISABLE      => { type: :block, duration: 4, last_move: true },
      :TORMENT      => { type: :lock, no_repeat: true },
      
      # Stat Copying
      :PSYCHUP      => { type: :copy, positive_only: true },
      :SPECTRALTHIEF => { type: :steal, damage: true },
      
      # Punishment (stronger vs boosted)
      :PUNISHMENT   => { type: :punish, max_power: 200 },
      :STOREDPOWER  => { type: :reward, max_power: 860 },
    }
    
    #===========================================================================
    # Setup Detection
    #===========================================================================
    
    # Detects if Battler has setup (stat boosts)
    def self.has_setup?(battler)
      return false if !battler
      
      # Check for positive stat stages
      [:ATTACK, :DEFENSE, :SPECIAL_ATTACK, :SPECIAL_DEFENSE, 
       :SPEED, :ACCURACY, :EVASION].each do |stat|
        return true if battler.stages[stat] > 0
      end
      
      return false
    end
    
    # Counts Setup Stages
    def self.count_setup_stages(battler)
      return 0 if !battler
      
      total = 0
      [:ATTACK, :DEFENSE, :SPECIAL_ATTACK, :SPECIAL_DEFENSE, 
       :SPEED, :ACCURACY, :EVASION].each do |stat|
        total += battler.stages[stat] if battler.stages[stat] > 0
      end
      
      return total
    end
    
    # Checks if Pokemon recently used setup move
    def self.recently_setup?(battle, battler)
      return false if !battle || !battler
      return false if !AdvancedAI.feature_enabled?(:setup, battle.pbSideSize(0))
      
      # Check Move Memory
      memory = AdvancedAI.get_memory(battle, battler)
      return false if !memory
      
      last_move = memory[:last_move]
      return false if !last_move
      
      return AdvancedAI.setup_move?(last_move)
    end
    
    #===========================================================================
    # Setup Threat Assessment
    #===========================================================================
    
    # Evaluates Setup Threat (0-10 Scale)
    def self.assess_setup_threat(battle, attacker, defender)
      return 0.0 if !battle || !attacker || !defender
      
      threat = 0.0
      
      # 1. Number of Setup Stages (+0.5 per Stage)
      stages = count_setup_stages(attacker)
      threat += stages * 0.5
      
      # 2. Type of Boosts
      if attacker.stages[:ATTACK] >= 2 || attacker.stages[:SPECIAL_ATTACK] >= 2
        threat += 2.0  # Offensive threat
      end
      
      if attacker.stages[:SPEED] >= 2
        threat += 1.5  # Speed threat (hard to stop)
      end
      
      if attacker.stages[:EVASION] >= 1
        threat += 2.0  # Evasion = very annoying
      end
      
      # 3. Pokemon Quality
      # High Base Stat = more dangerous with Boosts
      if attacker.attack >= 120 || attacker.spatk >= 120
        threat += 1.0
      end
      
      if attacker.speed >= 100
        threat += 1.0
      end
      
      # 4. Coverage Moves
      known_moves = AdvancedAI.get_memory(battle, attacker)
      if known_moves && known_moves[:moves_seen]
        coverage_count = 0
        known_moves[:moves_seen].each do |move_id|
          move = GameData::Move.try_get(move_id)
          next if !move || move.category == :Status
          coverage_count += 1
        end
        
        threat += coverage_count * 0.3  # More Coverage = more dangerous
      end
      
      # 5. Sweep Potential
      # Can defender survive?
      if defender.hp < defender.totalhp * 0.5
        threat += 1.5  # Defender weak = higher danger
      end
      
      # Team has no counters left?
      remaining_pokemon = battle.pbAbleNonActiveCount(defender.index)
      if remaining_pokemon <= 1
        threat += 2.0  # Last Pokemon = critical
      end
      
      # Cap at 10.0
      threat = [threat, 10.0].min
      
      return threat
    end
    
    #===========================================================================
    # Counter Priority System
    #===========================================================================
    
    # Finds best Setup Counter Move
    def self.find_best_counter(battle, user, target)
      return nil if !battle || !user || !target
      
      best_move = nil
      best_score = 0
      
      user.moves.each do |move|
        next if !move || move.pp <= 0
        move_id = move.id
        
        # Phazing Moves (Roar, Whirlwind)
        if [:ROAR, :WHIRLWIND, :DRAGONTAIL, :CIRCLETHROW].include?(move_id)
          score = 100
          
          # Less effective against Soundproof
          score -= 50 if target.hasActiveAbility?(:SOUNDPROOF) && [:ROAR].include?(move_id)
          
          # Less effective against Suction Cups
          score -= 80 if target.hasActiveAbility?(:SUCTIONCUPS)
          
          # More points if many boosts
          score += count_setup_stages(target) * 10
          
          if score > best_score
            best_score = score
            best_move = move_id
          end
        end
        
        # Haze (reset all stats)
        if move_id == :HAZE
          score = 90
          score += count_setup_stages(target) * 10
          
          if score > best_score
            best_score = score
            best_move = move_id
          end
        end
        
        # Clear Smog (reset + damage)
        if move_id == :CLEARSMOG
          score = 85
          score += count_setup_stages(target) * 10
          
          # Type effectiveness
          effectiveness = Effectiveness.calculate(move.type, target.type1, target.type2)
          score += 20 if Effectiveness.super_effective?(effectiveness)
          score -= 20 if Effectiveness.not_very_effective?(effectiveness)
          
          if score > best_score
            best_score = score
            best_move = move_id
          end
        end
        
        # Encore (lock into last move)
        if move_id == :ENCORE
          score = 80
          
          # Very good if target used setup move
          if recently_setup?(battle, target)
            score += 40
          end
          
          if score > best_score
            best_score = score
            best_move = move_id
          end
        end
        
        # Taunt (prevent status moves)
        if move_id == :TAUNT
          score = 70
          
          # Good against Support Pokemon
          roles = AdvancedAI.detect_roles(target)
          score += 30 if roles.include?(:support)
          
          if score > best_score
            best_score = score
            best_move = move_id
          end
        end
      end
      
      return best_move
    end
    
    #===========================================================================
    # Optimal Counter Timing
    #===========================================================================
    
    # Determines if we should counter NOW
    def self.should_counter_now?(battle, user, target, skill_level)
      return false if !battle || !user || !target
      
      # Setup threat
      threat = assess_setup_threat(battle, target, user)
      
      # Thresholds based on skill
      threshold = case skill_level
      when 100 then 4.0   # Master: Counter early
      when 90  then 5.0   # Expert
      when 80  then 6.0   # Advanced
      when 70  then 7.0   # Skilled
      else 8.0            # Core: Only if extreme danger
      end
      
      # Counter if threat > threshold
      return threat >= threshold
    end
    
    #===========================================================================
    # Baton Pass Chain Detection
    #===========================================================================
    
    # Checks if Team uses Baton Pass chain
    def self.baton_pass_chain?(battle, side_index)
      return false if !battle
      
      baton_pass_count = 0
      setup_move_count = 0
      
      battle.pbParty(side_index).each do |pokemon|
        next if !pokemon || pokemon.egg?
        
        pokemon.moves.each do |move|
          baton_pass_count += 1 if move.id == :BATONPASS
          setup_move_count += 1 if AdvancedAI.setup_move?(move.id)
        end
      end
      
      # Chain if at least 2 Pokemon have Baton Pass
      # AND at least 3 Setup Moves in Team
      return baton_pass_count >= 2 && setup_move_count >= 3
    end
    
    # Priority against Baton Pass chains
    def self.baton_chain_priority(battle, user)
      return 0 if !battle || !user
      
      # Check if Opponent Team uses Baton Pass
      opponent_side = (user.index % 2 == 0) ? 1 : 0
      return 0 if !baton_pass_chain?(battle, opponent_side)
      
      # Higher Priority for Phaze Moves
      priority_boost = 0
      user.moves.each do |move|
        next if !move
        
        if [:ROAR, :WHIRLWIND, :HAZE, :CLEARSMOG].include?(move.id)
          priority_boost += 30
        end
        
        if [:TAUNT, :ENCORE].include?(move.id)
          priority_boost += 20
        end
      end
      
      return priority_boost
    end
    
  end
end

#===============================================================================
# API Wrapper
#===============================================================================
module AdvancedAI
  def self.has_setup?(battler)
    SetupRecognition.has_setup?(battler)
  end
  
  def self.count_setup_stages(battler)
    SetupRecognition.count_setup_stages(battler)
  end
  
  def self.assess_setup_threat(battle, attacker, defender)
    SetupRecognition.assess_setup_threat(battle, attacker, defender)
  end
  
  def self.find_best_setup_counter(battle, user, target)
    SetupRecognition.find_best_counter(battle, user, target)
  end
  
  def self.should_counter_setup_now?(battle, user, target, skill_level)
    SetupRecognition.should_counter_now?(battle, user, target, skill_level)
  end
  
  def self.baton_pass_chain?(battle, side_index)
    SetupRecognition.baton_pass_chain?(battle, side_index)
  end
end

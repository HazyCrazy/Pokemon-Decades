#===============================================================================
# [016] Prediction System - Switch & Move Prediction
#===============================================================================
# Prediction of opponent actions based on Move Memory and Patterns
#
# Features:
# - Switch Prediction (When will opponent switch?)
# - Move Prediction (Which move is coming?)
# - Pattern Recognition (Recognizes player patterns)
# - Double Switch Detection (Predict + Counter)
#===============================================================================

module AdvancedAI
  module PredictionSystem
    
    #===========================================================================
    # Switch Prediction
    #===========================================================================
    
    # Calculates probability that opponent switches (0-100%)
    def self.predict_switch_chance(battle, opponent)
      return 0 if !battle || !opponent
      
      chance = 0
      
      # 1. Type Disadvantage (+30%)
      user = battle.battlers[(opponent.index + 2) % 4]  # Opposite battler
      if user
        memory = AdvancedAI.get_memory(battle, user)
        if memory && memory[:moves_seen]
          memory[:moves_seen].each do |move_id|
            move = GameData::Move.try_get(move_id)
            next if !move
            
            effectiveness = Effectiveness.calculate(move.type, *opponent.pbTypes(true))
            if Effectiveness.super_effective?(effectiveness)
              chance += 30
              break
            end
          end
        end
      end
      
      # 2. Low HP (+25%)
      if opponent.hp < opponent.totalhp * 0.3
        chance += 25
      elsif opponent.hp < opponent.totalhp * 0.5
        chance += 15
      end
      
      # 3. Stat Drops (-2 or worse = +20%)
      if opponent.stages[:ATTACK] <= -2 || opponent.stages[:SPECIAL_ATTACK] <= -2
        chance += 20
      end
      
      if opponent.stages[:SPEED] <= -2
        chance += 15
      end
      
      # 4. Status Problems (+15%)
      if opponent.status == :BURN || opponent.status == :POISON || opponent.status == :TOXIC
        chance += 15
      end
      
      if opponent.status == :PARALYSIS
        chance += 10
      end
      
      # 5. No effective moves left (+20%)
      if opponent.moves.all? { |m| m && m.pp == 0 }
        chance += 50  # Struggle forced
      end
      
      # 6. Recently switched? (-30%)
      # (Player rarely switches back immediately)
      if opponent.turnCount <= 1
        chance -= 30
      end
      
      # Cap at 0-95%
      chance = [[chance, 95].min, 0].max
      
      return chance
    end
    
    # Returns most likely Switch Target
    def self.predict_switch_target(battle, opponent)
      return nil if !battle || !opponent
      
      # Find best counters in team
      party = battle.pbParty(opponent.index % 2)
      return nil if !party
      
      best_counter = nil
      best_score = 0
      
      user = battle.battlers[(opponent.index + 2) % 4]
      return nil if !user
      
      party.each_with_index do |pokemon, i|
        next if !pokemon || pokemon.fainted? || pokemon.egg?
        next if pokemon == opponent.pokemon  # Not current Pokemon
        
        score = 0
        
        # Type Matchup
        user.moves.each do |move|
          next if !move
          effectiveness = Effectiveness.calculate(move.type, *pokemon.types)
          
          if Effectiveness.not_very_effective?(effectiveness) || Effectiveness.ineffective?(effectiveness)
            score += 30
          elsif Effectiveness.super_effective?(effectiveness)
            score -= 20
          end
        end
        
        # Pokemon is uninjured? (+20)
        score += 20 if pokemon.hp == pokemon.totalhp
        
        # Pokemon is Wall/Tank? (+15)
        roles = AdvancedAI.detect_roles(pokemon)
        score += 15 if roles.include?(:wall) || roles.include?(:tank)
        
        if score > best_score
          best_score = score
          best_counter = pokemon
        end
      end
      
      return best_counter
    end
    
    #===========================================================================
    # Move Prediction
    #===========================================================================
    
    # Calculates most likely Move (based on Memory)
    def self.predict_next_move(battle, opponent)
      return nil if !battle || !opponent
      
      memory = AdvancedAI.get_memory(battle, opponent)
      return nil if !memory || !memory[:move_frequency]
      
      # Find most used Move
      most_used = nil
      highest_count = 0
      
      memory[:move_frequency].each do |move_id, count|
        if count > highest_count
          highest_count = count
          most_used = move_id
        end
      end
      
      # But: Last Move Repeat is unlikely
      if memory[:last_move] && most_used == memory[:last_move]
        # Find second most frequent
        second_most = nil
        second_count = 0
        
        memory[:move_frequency].each do |move_id, count|
          next if move_id == most_used
          if count > second_count
            second_count = count
            second_most = move_id
          end
        end
        
        most_used = second_most if second_most
      end
      
      return most_used
    end
    
    # Rates Move based on Prediction
    def self.score_prediction_bonus(battle, user, target, move, predicted_move)
      return 0 if !battle || !user || !target || !move || !predicted_move
      
      bonus = 0
      predicted_move_data = GameData::Move.try_get(predicted_move)
      return 0 if !predicted_move_data
      
      # 1. Protect against strong Attack (+40)
      if AdvancedAI.protect_move?(move.id)
        if predicted_move_data.power >= 80
          bonus += 40
        end
        
        # Extra Bonus against Setup
        if AdvancedAI.setup_move?(predicted_move)
          bonus += 20  # Block setup with Protect
        end
      end
      
      # 2. Resistance against predicted Move (+25)
      if move.category != :Status
        effectiveness = Effectiveness.calculate(predicted_move_data.type, user.type1, user.type2)
        if Effectiveness.not_very_effective?(effectiveness) || Effectiveness.ineffective?(effectiveness)
          bonus += 25
        end
      end
      
      # 3. Counter-Move (+35)
      # E.g. Opponent uses Physical Move → Burn
      if move.id == :WILLOWISP && predicted_move_data.physicalMove?
        bonus += 35
      end
      
      # Opponent uses Status Move → Taunt
      if move.id == :TAUNT && predicted_move_data.category == :Status
        bonus += 35
      end
      
      # 4. Switch on predicted OHKO (+50)
      if predicted_move_data.power >= 100
        damage = calculate_predicted_damage(target, user, predicted_move_data)
        if damage >= user.hp
          # Use Pivot move or Protect
          bonus += 50 if AdvancedAI.pivot_move?(move.id)
          bonus += 45 if AdvancedAI.protect_move?(move.id)
        end
      end
      
      return bonus
    end
    
    #===========================================================================
    # Pattern Recognition
    #===========================================================================
    
    # Recognizes Player Patterns
    @battle_patterns = {}
    
    def self.track_pattern(battle, trainer_name, action)
      return if !battle || !trainer_name || !action
      
      @battle_patterns[trainer_name] ||= []
      @battle_patterns[trainer_name] << {
        turn: battle.turnCount,
        action: action
      }
      
      # Keep only last 20 actions
      @battle_patterns[trainer_name] = @battle_patterns[trainer_name].last(20)
    end
    
    # Checks if Player shows Pattern
    def self.detect_pattern(trainer_name, pattern_type)
      return false if !trainer_name || !@battle_patterns[trainer_name]
      
      patterns = @battle_patterns[trainer_name]
      return false if patterns.size < 3
      
      case pattern_type
      when :always_setup_turn1
        # Checks if player always setups turn 1
        turn1_actions = patterns.select { |p| p[:turn] == 1 }
        return false if turn1_actions.empty?
        
        setup_count = turn1_actions.count { |p| p[:action] == :setup }
        return setup_count >= turn1_actions.size * 0.8
        
      when :switches_on_disadvantage
        # Checks if player switches on disadvantage
        disadvantage_switches = patterns.count { |p| p[:action] == :switch_on_disadvantage }
        return disadvantage_switches >= 3
        
      when :always_attack
        # Checks if player almost never uses status
        attack_count = patterns.count { |p| p[:action] == :attack }
        return attack_count >= patterns.size * 0.9
      end
      
      return false
    end
    
    #===========================================================================
    # Double Switch Detection
    #===========================================================================
    
    # Calculates if double switch makes sense
    def self.should_double_switch?(battle, user, predicted_switch)
      return false if !battle || !user || !predicted_switch
      
      # Double Switch: AI switches to Pokemon that counters predicted_switch
      
      # Find best counter for predicted_switch
      party = battle.pbParty(user.index % 2)
      return false if !party
      
      best_counter = nil
      best_score = 0
      
      party.each do |pokemon|
        next if !pokemon || pokemon.fainted? || pokemon.egg?
        next if pokemon == user.pokemon
        
        score = 0
        
        # Type Advantage
        pokemon.moves.each do |move|
          next if !move
          effectiveness = Effectiveness.calculate(move.type, *predicted_switch.types)
          score += 40 if Effectiveness.super_effective?(effectiveness)
        end
        
        # Resists predicted_switch moves?
        predicted_switch.moves.each do |move|
          next if !move
          effectiveness = Effectiveness.calculate(move.type, *pokemon.types)
          score += 20 if Effectiveness.not_very_effective?(effectiveness)
          score += 30 if Effectiveness.ineffective?(effectiveness)
        end
        
        if score > best_score
          best_score = score
          best_counter = pokemon
        end
      end
      
      # Double switch if Score > 60
      return best_score >= 60
    end
    
    #===========================================================================
    # Helper Methods
    #===========================================================================
    
    def self.calculate_predicted_damage(attacker, defender, move)
      return 0 if !attacker || !defender || !move
      
      attack = move.physicalMove? ? attacker.attack : attacker.spatk
      defense = move.physicalMove? ? defender.defense : defender.spdef
      
      effectiveness = Effectiveness.calculate(move.type, defender.type1, defender.type2)
      multiplier = Effectiveness.calculate_multiplier(effectiveness)
      
      damage = ((2 * attacker.level / 5 + 2) * move.power * attack / defense / 50 + 2) * multiplier
      return damage.to_i
    end
    
  end
end

#===============================================================================
# API Wrapper
#===============================================================================
module AdvancedAI
  def self.predict_switch_chance(battle, opponent)
    PredictionSystem.predict_switch_chance(battle, opponent)
  end
  
  def self.predict_switch_target(battle, opponent)
    PredictionSystem.predict_switch_target(battle, opponent)
  end
  
  def self.predict_next_move(battle, opponent)
    PredictionSystem.predict_next_move(battle, opponent)
  end
  
  def self.score_prediction_bonus(battle, user, target, move, predicted_move)
    PredictionSystem.score_prediction_bonus(battle, user, target, move, predicted_move)
  end
  
  def self.track_pattern(battle, trainer_name, action)
    PredictionSystem.track_pattern(battle, trainer_name, action)
  end
  
  def self.detect_pattern(trainer_name, pattern_type)
    PredictionSystem.detect_pattern(trainer_name, pattern_type)
  end
  
  def self.should_double_switch?(battle, user, predicted_switch)
    PredictionSystem.should_double_switch?(battle, user, predicted_switch)
  end
end

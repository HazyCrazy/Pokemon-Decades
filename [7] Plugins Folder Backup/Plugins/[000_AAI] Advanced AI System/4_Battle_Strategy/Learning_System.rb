#===============================================================================
# Advanced AI System - Learning System
# Pattern Recognition and Adaptive Behavior
#===============================================================================

module AdvancedAI
  module LearningSystem
    # Battle pattern data stored per opponent
    @opponent_patterns = {}
    
    # Reset learning data (called at battle start)
    def self.reset_learning_data(battle)
      @current_battle = battle
      @opponent_patterns = {}
      @turn_history = []
    end
    
    #===========================================================================
    # PATTERN TRACKING
    #===========================================================================
    
    # Record opponent action this turn
    def self.record_action(battler, action_type, action_data = nil)
      return unless battler
      return unless AdvancedAI.tier_feature(100, :learn_patterns)  # Only if enabled
      
      opponent_id = get_opponent_id(battler)
      @opponent_patterns[opponent_id] ||= {
        :actions => [],
        :switches => [],
        :protect_pattern => [],
        :move_preferences => Hash.new(0),
        :hp_thresholds => {},
        :switch_triggers => []
      }
      
      pattern = @opponent_patterns[opponent_id]
      
      case action_type
      when :move
        # Record move usage
        move_id = action_data
        pattern[:move_preferences][move_id] += 1
        pattern[:actions] << {:turn => @current_battle.turnCount, :type => :move, :move => move_id}
        
      when :switch
        # Record switch
        hp_percent = (battler.hp.to_f / battler.totalhp * 100).round
        pattern[:switches] << {:turn => @current_battle.turnCount, :hp_percent => hp_percent}
        pattern[:actions] << {:turn => @current_battle.turnCount, :type => :switch}
        
      when :protect
        # Track Protect usage pattern
        pattern[:protect_pattern] << @current_battle.turnCount
        
      when :hp_threshold
        # Record action at specific HP threshold
        hp_percent = action_data
        pattern[:hp_thresholds][hp_percent] ||= []
        pattern[:hp_thresholds][hp_percent] << action_type
      end
    end
    
    #===========================================================================
    # PATTERN ANALYSIS
    #===========================================================================
    
    # Predict if opponent will use Protect this turn
    def self.predict_protect_usage(battler, skill_level = 100)
      return 0.0 unless skill_level >= 85
      return 0.0 unless AdvancedAI.tier_feature(skill_level, :learn_patterns)
      
      opponent_id = get_opponent_id(battler)
      pattern = @opponent_patterns[opponent_id]
      return 0.0 unless pattern
      
      protect_history = pattern[:protect_pattern]
      return 0.0 if protect_history.empty?
      
      current_turn = @current_battle.turnCount
      
      # Check for alternating pattern (Protect every other turn)
      if protect_history.length >= 2
        intervals = protect_history.each_cons(2).map { |a, b| b - a }
        avg_interval = intervals.sum.to_f / intervals.length
        
        last_protect = protect_history.last
        turns_since = current_turn - last_protect
        
        # If avg interval is ~2 turns and it's been 2 turns since last Protect
        if avg_interval.between?(1.5, 2.5) && turns_since >= avg_interval.round
          return 0.8  # 80% chance they'll Protect
        end
      end
      
      # Check for Turn 1 Protect tendency
      turn1_protects = protect_history.count { |t| t == 1 }
      if turn1_protects >= 2 && current_turn == 1
        return 0.7  # 70% chance of Turn 1 Protect
      end
      
      # General frequency analysis
      total_turns = current_turn
      protect_frequency = protect_history.length.to_f / total_turns
      
      # If they Protect more than 30% of turns
      return protect_frequency if protect_frequency > 0.3
      
      0.0
    end
    
    # Predict if opponent will switch
    def self.predict_switch(battler, skill_level = 100)
      return 0.0 unless skill_level >= 85
      return 0.0 unless AdvancedAI.tier_feature(skill_level, :learn_patterns)
      
      opponent_id = get_opponent_id(battler)
      pattern = @opponent_patterns[opponent_id]
      return 0.0 unless pattern
      
      switch_history = pattern[:switches]
      return 0.0 if switch_history.empty?
      
      # Check current HP against historical switch thresholds
      current_hp_percent = (battler.hp.to_f / battler.totalhp * 100).round
      
      # Find switches at similar HP levels
      similar_hp_switches = switch_history.select do |s|
        (s[:hp_percent] - current_hp_percent).abs < 15  # Within 15% HP
      end
      
      if similar_hp_switches.length >= 2
        return 0.75  # They often switch at this HP range
      end
      
      # Check if they switched last time they were threatened
      # (More complex - requires threat tracking)
      
      0.0
    end
    
    # Get opponent's most used move
    def self.get_preferred_move(battler)
      opponent_id = get_opponent_id(battler)
      pattern = @opponent_patterns[opponent_id]
      return nil unless pattern
      
      move_prefs = pattern[:move_preferences]
      return nil if move_prefs.empty?
      
      # Return most frequently used move
      move_prefs.max_by { |move_id, count| count }&.first
    end
    
    # Check if opponent has predictable behavior
    def self.is_predictable?(battler)
      opponent_id = get_opponent_id(battler)
      pattern = @opponent_patterns[opponent_id]
      return false unless pattern
      
      actions = pattern[:actions]
      return false if actions.length < 5  # Need enough data
      
      # Check for repeated sequences
      last_5_actions = actions.last(5).map { |a| a[:type] }
      
      # If same action 4+ times in last 5 turns = very predictable
      most_common = last_5_actions.group_by(&:itself).values.max_by(&:size)&.size || 0
      return true if most_common >= 4
      
      false
    end
    
    #===========================================================================
    # ADAPTIVE SCORING
    #===========================================================================
    
    # Adjust move score based on learned patterns
    def self.adaptive_move_score(battle, user, move, target, base_score, skill_level = 100)
      return base_score unless skill_level >= 85
      return base_score unless AdvancedAI.tier_feature(skill_level, :learn_patterns)
      return base_score unless target
      
      bonus = 0
      
      # If opponent likely to Protect, avoid attacking
      protect_chance = predict_protect_usage(target, skill_level)
      if protect_chance > 0.5
        if move.damagingMove?
          bonus -= 30  # Don't waste attack on Protect
        elsif [:TOXIC, :WILLOWISP, :THUNDERWAVE].include?(move.id)
          bonus += 25  # Status moves work through Protect prediction
        end
      end
      
      # If opponent likely to switch, use setup/hazards
      switch_chance = predict_switch(target, skill_level)
      if switch_chance > 0.5
        if [:STEALTHROCK, :SPIKES, :TOXICSPIKES, :STICKYWEB].include?(move.id)
          bonus += 35  # Free hazard setup
        elsif is_setup_move?(move.id)
          bonus += 30  # Free setup turn
        elsif move.damagingMove? && move.power >= 90
          bonus -= 10  # Don't waste strong move on switch
        end
      end
      
      # If opponent is predictable, exploit it
      if is_predictable?(target)
        preferred_move = get_preferred_move(target)
        if preferred_move
          # Check if our move counters their preferred move
          # (Would need move matchup logic here)
          bonus += 10  # Small bonus for predictable opponent
        end
      end
      
      base_score + bonus
    end
    
    #===========================================================================
    # HELPER METHODS
    #===========================================================================
    
    private
    
    def self.get_opponent_id(battler)
      # Generate unique ID for opponent (species + index)
      "#{battler.species}_#{battler.index}"
    end
    
    def self.is_setup_move?(move_id)
      setup_moves = [
        :SWORDSDANCE, :DRAGONDANCE, :NASTYPLOT, :CALMMIND, :QUIVERDANCE,
        :BULKUP, :CURSE, :AGILITY, :ROCKPOLISH, :SHELLSMASH, :GEOMANCY
      ]
      setup_moves.include?(move_id)
    end
  end
end

# API Methods
module AdvancedAI
  def self.reset_learning_data(battle)
    LearningSystem.reset_learning_data(battle)
  end
  
  def self.record_action(battler, action_type, action_data = nil)
    LearningSystem.record_action(battler, action_type, action_data)
  end
  
  def self.predict_protect_usage(battler, skill_level = 100)
    LearningSystem.predict_protect_usage(battler, skill_level)
  end
  
  def self.predict_switch(battler, skill_level = 100)
    LearningSystem.predict_switch(battler, skill_level)
  end
  
  def self.adaptive_move_score(battle, user, move, target, base_score, skill_level = 100)
    LearningSystem.adaptive_move_score(battle, user, move, target, base_score, skill_level)
  end
  
  def self.is_predictable?(battler)
    LearningSystem.is_predictable?(battler)
  end
end

AdvancedAI.log("Learning System loaded", "Learn")
AdvancedAI.log("  - Pattern Recognition (Protect, Switch)", "Learn")
AdvancedAI.log("  - Move Preference Tracking", "Learn")
AdvancedAI.log("  - HP Threshold Analysis", "Learn")
AdvancedAI.log("  - Adaptive Move Scoring", "Learn")
AdvancedAI.log("  - Predictability Detection", "Learn")

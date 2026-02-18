#===============================================================================
# Advanced AI System - Debug Menu & Move Explanations
# Press F9 during battle to access debug controls
#===============================================================================

module AdvancedAI
  # ============================================================================
  # IN-GAME DEBUG MENU
  # ============================================================================
  
  class DebugMenu
    def self.open(battle)
      return unless $DEBUG || Input.press?(Input::F9)
      
      loop do
        commands = [
          _INTL("Change AI Skill Level (Current: {1})", get_current_skill(battle)),
          _INTL("Toggle Wild Pokemon AI ({1})", AdvancedAI::ENABLE_WILD_POKEMON_AI ? "ON" : "OFF"),
          _INTL("Toggle Move Explanations ({1})", AdvancedAI::SHOW_MOVE_EXPLANATIONS ? "ON" : "OFF"),
          _INTL("Toggle Logging ({1})", AdvancedAI::DEBUG_MODE ? "ON" : "OFF"),
          _INTL("Reset Learning System"),
          _INTL("Show AI Stats"),
          _INTL("Force AI Personality"),
          _INTL("Close Menu")
        ]
        
        choice = pbShowCommands(nil, commands, -1)
        
        case choice
        when 0 # Change Skill Level
          change_skill_level(battle)
        when 1 # Toggle Wild AI
          toggle_wild_ai
        when 2 # Toggle Move Explanations
          toggle_move_explanations
        when 3 # Toggle Logging
          toggle_logging
        when 4 # Reset Learning
          reset_learning_system
        when 5 # Show Stats
          show_ai_stats(battle)
        when 6 # Force Personality
          force_personality(battle)
        else
          break
        end
      end
    end
    
    def self.get_current_skill(battle)
      # Get skill of first opponent
      battle.battlers.each do |b|
        next unless b && !b.opposes?
        return battle.pbGetOwnerFromBattlerIndex(b.index).skill_level rescue 50
      end
      return 50
    end
    
    def self.change_skill_level(battle)
      params = ChooseNumberParams.new
      params.setRange(0, 100)
      params.setDefaultValue(get_current_skill(battle))
      new_skill = pbMessageChooseNumber(_INTL("Set AI skill level (0-100):"), params)
      
      # Apply to all opponent battlers
      battle.battlers.each do |b|
        next unless b && !b.opposes?
        owner = battle.pbGetOwnerFromBattlerIndex(b.index) rescue nil
        owner.skill_level = new_skill if owner
      end
      
      pbMessage(_INTL("AI skill set to {1}!", new_skill))
      AdvancedAI.log("Skill level changed to #{new_skill} via debug menu", "Debug")
    end
    
    def self.toggle_wild_ai
      current = AdvancedAI::ENABLE_WILD_POKEMON_AI
      AdvancedAI.const_set(:ENABLE_WILD_POKEMON_AI, !current)
      pbMessage(_INTL("Wild Pokemon AI: {1}", !current ? "ON" : "OFF"))
    end
    
    def self.toggle_move_explanations
      current = AdvancedAI::SHOW_MOVE_EXPLANATIONS
      AdvancedAI.const_set(:SHOW_MOVE_EXPLANATIONS, !current)
      pbMessage(_INTL("Move Explanations: {1}", !current ? "ON" : "OFF"))
    end
    
    def self.toggle_logging
      current = AdvancedAI::DEBUG_MODE
      AdvancedAI.const_set(:DEBUG_MODE, !current)
      pbMessage(_INTL("Debug Logging: {1}", !current ? "ON" : "OFF"))
    end
    
    def self.reset_learning_system
      if defined?(Battle::AI::LearningSystem)
        Battle::AI::LearningSystem.reset_all_patterns
        pbMessage(_INTL("Learning system reset! All patterns cleared."))
        AdvancedAI.log("Learning system reset via debug menu", "Debug")
      else
        pbMessage(_INTL("Learning system not loaded."))
      end
    end
    
    def self.show_ai_stats(battle)
      stats = []
      stats << "=== AI PERFORMANCE STATS ==="
      
      # Get learning system stats if available
      if defined?(Battle::AI::LearningSystem) && battle.ai
        learning = Battle::AI::LearningSystem
        stats << "Battles Analyzed: #{learning.total_battles || 0}"
        stats << "Patterns Learned: #{learning.pattern_count || 0}"
        stats << "Prediction Accuracy: #{learning.prediction_accuracy || 0}%"
      end
      
      # Get switch intelligence stats
      if battle.respond_to?(:ai_switch_count)
        stats << "Switches Made: #{battle.ai_switch_count || 0}"
        stats << "Successful Switches: #{battle.ai_switch_success || 0}"
      end
      
      # Memory stats
      if battle.respond_to?(:move_history)
        stats << "Moves Tracked: #{battle.move_history.length}"
      end
      
      stats << "Current Skill: #{get_current_skill(battle)}"
      stats << "=========================="
      
      pbMessage(stats.join("\n"))
    end
    
    def self.force_personality(battle)
      personalities = ["Aggressive", "Defensive", "Balanced", "Tactical", "Random"]
      choice = pbMessage(_INTL("Choose AI personality:"), personalities, -1)
      return if choice < 0
      
      personality = personalities[choice].downcase.to_sym
      
      battle.battlers.each do |b|
        next unless b && !b.opposes?
        b.battle_personality = personality if b.respond_to?(:battle_personality=)
      end
      
      pbMessage(_INTL("{1} personality activated!", personalities[choice]))
    end
  end
  
  # ============================================================================
  # MOVE EXPLANATION SYSTEM
  # ============================================================================
  
  class MoveExplanation
    # Store explanations for moves chosen this turn
    @current_explanations = {}
    
    def self.set_explanation(battler, move, reason)
      return unless AdvancedAI::SHOW_MOVE_EXPLANATIONS
      @current_explanations ||= {}
      @current_explanations[battler.index] = {
        move: move.name,
        reason: reason
      }
    end
    
    def self.get_explanation(battler)
      @current_explanations ||= {}
      return @current_explanations[battler.index]
    end
    
    def self.clear_explanation(battler)
      @current_explanations ||= {}
      @current_explanations.delete(battler.index)
    end
    
    def self.clear_all
      @current_explanations = {}
    end
    
    # Generate human-readable reason from score components
    def self.generate_reason(move, user, target, score, battle)
      reasons = []
      
      # Type effectiveness
      if move.damagingMove?
        type_mod = Effectiveness.calculate(move.type, *target.pbTypes(true))
        if Effectiveness.super_effective?(type_mod)
          reasons << "Super effective"
        elsif Effectiveness.not_very_effective?(type_mod)
          reasons << "Coverage"
        end
      end
      
      # Status moves
      if move.statusMove?
        case move.function_code
        when "RaiseUserAtk1", "RaiseUserSpAtk1"
          reasons << "Setup sweep"
        when "ParalyzeTarget"
          reasons << "Paralyze fast threat"
        when "BurnTarget"
          reasons << "Burn physical attacker"
        when "PoisonTarget", "BadPoisonTarget"
          reasons << "Toxic stall"
        when "SleepTarget"
          reasons << "Remove threat"
        end
      end
      
      # Healing
      if move.healingMove?
        hp_percent = user.hp.to_f / user.totalhp
        if hp_percent < 0.3
          reasons << "Emergency recovery"
        else
          reasons << "Sustain bulk"
        end
      end
      
      # Priority
      if move.priority > 0
        if target.hp < target.totalhp * 0.3
          reasons << "Revenge kill"
        else
          reasons << "Priority strike"
        end
      end
      
      # Switch moves
      if ["BatonPass", "VoltSwitch", "UTurn", "FlipTurn"].include?(move.function_code)
        reasons << "Gain momentum"
      end
      
      # High damage
      if score >= 120
        reasons << "KO threat"
      elsif score >= 100
        reasons << "High damage"
      end
      
      # Default
      reasons << "Best option" if reasons.empty?
      
      return reasons.join(" + ")
    end
  end
end

# ============================================================================
# HOOK INTO BATTLE SYSTEM
# ============================================================================

class Battle
  # Add debug menu shortcut
  alias aai_debug_pbCommandPhase pbCommandPhase
  def pbCommandPhase
    # Check for F9 press before processing commands
    if Input.trigger?(Input::F9) && ($DEBUG || AdvancedAI::DEBUG_MODE)
      AdvancedAI::DebugMenu.open(self)
    end
    aai_debug_pbCommandPhase
  end
end

# Hook into Battler class for move explanations
class Battle::Battler
  # Hook move usage to show explanation
  alias aai_explain_pbUseMove pbUseMove
  def pbUseMove(choice, specialUsage = false)
    # Show explanation for AI-controlled battlers
    if !pbOwnedByPlayer? && AdvancedAI::SHOW_MOVE_EXPLANATIONS
      explanation = AdvancedAI::MoveExplanation.get_explanation(self)
      if explanation
        @battle.pbDisplayPaused(_INTL("{1} ({2})", explanation[:move], explanation[:reason]))
        AdvancedAI::MoveExplanation.clear_explanation(self)
      end
    end
    
    aai_explain_pbUseMove(choice, specialUsage)
  end
end

# Initialization complete
echoln "[AAI Debug] Debug Menu & Move Explanations loaded ✅"
echoln "[AAI Debug] Note: AI explanation integration will be loaded after Move_Scorer"


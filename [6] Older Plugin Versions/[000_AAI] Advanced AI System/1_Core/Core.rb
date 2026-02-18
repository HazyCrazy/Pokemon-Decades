#===============================================================================
# Advanced AI System - Core Battle AI Integration
# Hooks into Pokemon Essentials v21.1 AI system
#===============================================================================

class Battle::AI
  attr_accessor :move_memory
  attr_accessor :threat_cache
  attr_accessor :switch_analyzer
  
  alias aai_initialize initialize
  def initialize(battle)
    aai_initialize(battle)
    @move_memory = {}      # Track opponent move usage
    @threat_cache = {}     # Cache threat assessments
    @switch_analyzer = {}  # Analyze switch opportunities
    @type_effectiveness_cache = {}  # Cache type effectiveness calculations for performance
  end
  
  # Clear caches when battle ends (memory management)
  def clear_caches
    @type_effectiveness_cache&.clear
    @threat_cache&.clear
  end
  
  # Enhanced move scoring with Advanced AI integration
  # Note: This hooks into the DBK AI scoring system which calls pbGetMoveScore
  # with different signatures depending on context
  alias aai_pbGetMoveScore pbGetMoveScore
  def pbGetMoveScore(*args)
    # Extract parameters based on what was passed
    # DBK calls this with 0 args (no target) or 1 arg ([target])
    target_array = args[0] if args.length > 0
    target = target_array&.first if target_array.is_a?(Array)
    
    # Get skill from trainer OR wild Pokemon setting
    if @trainer
      skill = @trainer.skill
    else
      # Wild Pokemon - check if AI is enabled
      return aai_pbGetMoveScore(*args) unless AdvancedAI::ENABLE_WILD_POKEMON_AI
      skill = AdvancedAI::WILD_POKEMON_SKILL_LEVEL
      # If skill is 0, use vanilla random behavior
      return aai_pbGetMoveScore(*args) if skill == 0
    end
    
    # Check qualification First
    unless AdvancedAI.qualifies_for_advanced_ai?(skill)
      return aai_pbGetMoveScore(*args)
    end

    # Need move context for advanced scoring
    return aai_pbGetMoveScore(*args) unless @move
    
    # Use Advanced AI Scoring if qualified
    # This replaces the vanilla base score with our intelligent scoring
    score = score_move_advanced(@move, @user, target, skill)
    
    # Apply Advanced AI enhancements (Layers on top of base advanced score)
    score = apply_advanced_modifiers(score, @move, @user, target, skill)
    
    return score
  end
  
  private
  
  def apply_advanced_modifiers(score, move, user, target, skill)
    # Core Systems (50+)
    if AdvancedAI.feature_enabled?(:core, skill)
      score = apply_move_memory(score, move, user, target) if target
      score = apply_threat_assessment(score, move, user, target) if target
      score = apply_field_effects(score, move, user, target) if target
      score = apply_doubles_coordination(score, move, user, target, skill) if @battle.pbSideSize(0) > 1 && target
    end
    
    # Setup Recognition (55+)
    if AdvancedAI.feature_enabled?(:setup, skill)
      score = apply_setup_evaluation(score, move, user, target)
    end
    
    # Endgame Scenarios (60+)
    if AdvancedAI.feature_enabled?(:endgame, skill)
      score = apply_endgame_logic(score, move, user, target)
    end
    
    # Battle Personalities (65+)
    if AdvancedAI.feature_enabled?(:personalities, skill)
      score = apply_personality_modifiers(score, move, user, target)
    end
    
    # Item Intelligence (85+)
    if AdvancedAI.feature_enabled?(:items, skill)
      score = apply_item_intelligence(score, move, user, target)
    end
    
    # Prediction System (85+)
    if AdvancedAI.feature_enabled?(:prediction, skill)
      score = apply_prediction_logic(score, move, user, target) if target
    end
    
    return score
  end
  
  # Placeholder methods (will be implemented in separate files)
  def apply_move_memory(score, move, user, target)
    return score  # Implemented in [007] Move_Memory.rb
  end
  
  def apply_threat_assessment(score, move, user, target)
    return score  # Implemented in [008] Threat_Assessment.rb
  end
  
  def apply_field_effects(score, move, user, target)
    return score  # Implemented in [010] Field_Effects.rb
  end
  
  def apply_doubles_coordination(score, move, user, target, skill = 100)
    return score  # Implemented in [009] Doubles_Coordination.rb
  end
  
  def apply_setup_evaluation(score, move, user, target)
    return score  # Implemented in [019] Setup_Recognition.rb
  end
  
  def apply_endgame_logic(score, move, user, target)
    return score  # Implemented in [020] Endgame_Scenarios.rb
  end
  
  def apply_personality_modifiers(score, move, user, target)
    return score  # Implemented in [021] Battle_Personalities.rb
  end
  
  def apply_item_intelligence(score, move, user, target)
    return score  # Implemented in [015] Item_Intelligence.rb
  end
  
  def apply_prediction_logic(score, move, user, target)
    return score  # Implemented in [016] Prediction_System.rb
  end
end

#===============================================================================
# Enhanced Switch Intelligence Integration
#===============================================================================
# Registers Advanced AI switch handler with Essentials AI system
# This gets checked FIRST before vanilla switch handlers
#===============================================================================

Battle::AI::Handlers::ShouldSwitch.add(:advanced_ai_switch_intelligence,
  proc { |battler, reserves, ai, battle|
    skill = ai.trainer&.skill || 100
    
    echoln "========================================"
    echoln "=== ADVANCED AI SWITCH ANALYSIS ==="
    echoln "  Pokemon: #{battler.name}"
    echoln "  Trainer Skill: #{skill}"
    echoln "  Reserves Available: #{reserves.length}"
    
    # DEBUG: Show which Pokemon are in reserves and which are filtered
    party = battle.pbParty(battler.index)
    echoln "  --- PARTY COMPOSITION DEBUG ---"
    party.each_with_index do |pkmn, i|
      next if !pkmn
      is_active = battle.pbFindBattler(i, battler.index)
      in_reserves = reserves.any? { |reserve_pkmn| reserve_pkmn == pkmn }
      can_switch = battle.pbCanSwitchIn?(battler.index, i)
      
      status = []
      status << "ACTIVE" if is_active
      status << "IN_RESERVES" if in_reserves
      status << "CANNOT_SWITCH (pbCanSwitchIn? = false)" if !can_switch
      status << "FAINTED" if pkmn.fainted?
      status << "EGG" if pkmn.egg?
      
      echoln "    [#{i}] #{pkmn.name}: #{status.join(', ')}"
    end
    
    # Check if Challenge Modes is filtering
    if defined?(ChallengeModes) && ChallengeModes.respond_to?(:on?)
      echoln "  --- CHALLENGE MODES STATUS ---"
      echoln "    Monotype Mode: #{ChallengeModes.on?(:MONOTYPE_MODE)}"
      echoln "    Randomizer Mode: #{ChallengeModes.on?(:RANDOMIZER_MODE)}"
    end
    echoln "  --- END DEBUG ---"
    
    qualifies = AdvancedAI.qualifies_for_advanced_ai?(skill)
    echoln "  Qualifies for Advanced AI? #{qualifies}"
    
    if !qualifies
      echoln "  >>> NOT qualified (need skill 50+)"
      echoln "=============================="
      next false
    end
    
    feature_enabled = AdvancedAI.feature_enabled?(:switch_intelligence, skill)
    echoln "  Switch Intelligence enabled? #{feature_enabled}"
    
    if !feature_enabled
      echoln "  >>> Feature not enabled for this skill level"
      echoln "=============================="
      next false
    end
    
    echoln "  >>> Checking switch logic..."
    echoln ""
    
    result = false
    begin
      # Call our Advanced AI switch logic from [012] Switch_Intelligence.rb
      # NOTE: battler is Battle::AI::AIBattler, need battler.battler for the real Battler
      if ai.respond_to?(:should_switch_advanced?)
        # Pass the real Battler object, not the AI wrapper
        real_battler = battler.respond_to?(:battler) ? battler.battler : battler
        result = ai.should_switch_advanced?(real_battler, skill)
        
        if result
          echoln ""
          echoln "  ✅ RESULT: SHOULD SWITCH!"
          echoln "=============================="
        else
          echoln ""
          echoln "  ❌ RESULT: Stay in battle"
          echoln "=============================="
        end
      else
        echoln "  ⚠️ ERROR: should_switch_advanced? not found"
        echoln "=============================="
      end
    rescue => e
      echoln "[AAI Core ERROR] #{e.class}: #{e.message}"
      echoln e.backtrace.first(3).join("\n")
      echoln "=============================="
      result = false
    end
    
    next result
  }
)

#===============================================================================
# Override replacement Pokemon selection to use Advanced AI logic
#===============================================================================
class Battle::AI
  alias aai_choose_best_replacement_pokemon choose_best_replacement_pokemon
  def choose_best_replacement_pokemon(idxBattler, terrible_moves = false)
    begin
      skill = @trainer&.skill || 100
      
      echoln "========================================"
      echoln "=== CHOOSING REPLACEMENT POKEMON ==="
      echoln "  Current: #{@user.name}"
      echoln "  Trainer Skill: #{skill}"
      echoln "  Forced Switch: #{terrible_moves}"
      
      # Debug: Check all conditions
      qualifies = AdvancedAI.qualifies_for_advanced_ai?(skill)
      feature_enabled = AdvancedAI.feature_enabled?(:switch_intelligence, skill)
      
      echoln "  Qualifies for Advanced AI? #{qualifies}"
      echoln "  Switch Intelligence enabled? #{feature_enabled}"
      echoln "  >>> Using send() to bypass visibility"
      
      # Use Advanced AI switch logic if qualified
      if qualifies && feature_enabled
        
        echoln "  >>> Using Advanced AI selection..."
        echoln ""
        
        # Call our advanced switch finder from [012] Switch_Intelligence.rb
        # Use send to bypass visibility restrictions
        # Returns party index directly
        best_idx = send(:find_best_switch_advanced, @user, skill)
        if best_idx && @battle.pbCanSwitchIn?(idxBattler, best_idx)
          party = @battle.pbParty(idxBattler)
          best_pkmn = party[best_idx]
          echoln ""
          echoln "  ✅ SELECTED: #{best_pkmn.name} (Party Index: #{best_idx})"
          echoln "=============================="
          return best_idx
        end
        echoln "  >>> No suitable switch found"
        echoln "  >>> Falling back to vanilla..."
      else
        echoln "  >>> Using vanilla selection..."
        if !qualifies
          echoln "      Reason: Skill too low (need 50+)"
        elsif !feature_enabled
          echoln "      Reason: Feature not enabled"
        elsif !has_method
          echoln "      Reason: Method not found"
        end
      end
      echoln "=============================="
    rescue => e
      echoln "[AAI ERROR] #{e.class}: #{e.message}"
      echoln e.backtrace.first(3).join("\n")
      echoln "=============================="
    end
    
    # Fall back to vanilla logic
    return aai_choose_best_replacement_pokemon(idxBattler, terrible_moves)
  end
end

# Initialization log moved to EventHandler to ensure AdvancedAI module is fully loaded
EventHandlers.add(:on_game_map_setup, :aai_core_loaded,
  proc {
    if defined?(AdvancedAI) && AdvancedAI.respond_to?(:log)
      AdvancedAI.log("Core AI integration loaded with switch intelligence handler", "Core")
    end
  }
)

echoln "[AAI Core] ✅ Switch Intelligence Handler registered!"
echoln "[AAI Core] ✅ Replacement selector override active!"
echoln "[AAI Core] Ready for battles with skill-based switch logic"


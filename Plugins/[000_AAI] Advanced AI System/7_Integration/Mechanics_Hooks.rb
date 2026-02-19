#===============================================================================
# Advanced AI System - Mechanics Hooks
# Connects Intelligence Modules to Battle System
#===============================================================================

class Battle::AI
  #-----------------------------------------------------------------------------
  # Main Hook: Register Enemy Special Actions
  # This is where the AI decides to use gimmicks (Mega, Z-Move, Dynamax, Tera)
  #-----------------------------------------------------------------------------
  # Check if the method already exists (from DBK or other plugins)
  # Use respond_to? on the class itself to avoid evaluation-time errors
  if Battle::AI.instance_methods.include?(:pbRegisterEnemySpecialAction)
    alias aai_pbRegisterEnemySpecialAction pbRegisterEnemySpecialAction 
    def pbRegisterEnemySpecialAction(idxBattler)
      # Check if this is a wild Pokemon with gimmick attributes
      # If so, DON'T call the original (which would auto-register gimmicks),
      # let AAI handle the decision intelligently
      battler = @battle.battlers[idxBattler]
      is_wild_with_gimmick = battler.wild? && (
        (battler.pokemon.respond_to?(:dynamax_lvl) && battler.pokemon.dynamax_lvl && battler.pokemon.dynamax_lvl > 0) ||
        (battler.pokemon.respond_to?(:tera_type) && battler.pokemon.tera_type && !battler.pokemon.tera_type.nil?)
      )
      
      if is_wild_with_gimmick
        AdvancedAI.log("Wild Pokemon with gimmick detected - skipping original hook to prevent auto-registration", "Hooks")
        # Skip original - go straight to AAI logic
        run_advanced_ai_special_actions(idxBattler)
      else
        # Normal path: call original (handles vanilla or other plugin logic)
        aai_pbRegisterEnemySpecialAction(idxBattler)
        # Then run AAI logic
        run_advanced_ai_special_actions(idxBattler)
      end
    end
  else
    # If method doesn't exist (vanilla Essentials v21.1),
    # we define it as a new method.
    # Note: This will be called by our hook in pbChooseEnemyAction
    def pbRegisterEnemySpecialAction(idxBattler)
      run_advanced_ai_special_actions(idxBattler)
    end
  end

  def run_advanced_ai_special_actions(idxBattler)
    
    # Get skill level - check if this is a wild battle first
    if @battle.wildBattle?
      # Wild Pokemon - use configured skill level if AI is enabled
      AdvancedAI.log("Wild Pokemon battle detected", "Hooks")
      
      # Check if this is a special wild battle mode (e.g., wilddynamax, wildterastallize)
      # If so, skip AAI processing and let DBK handle it
      if @battle.respond_to?(:wildBattleMode) && @battle.wildBattleMode
        AdvancedAI.log("Special wild battle mode detected (#{@battle.wildBattleMode}) - skipping AAI gimmick processing", "Hooks")
        return
      end
      
      unless AdvancedAI::ENABLE_WILD_POKEMON_AI
        AdvancedAI.log("Wild Pokemon AI is DISABLED", "Hooks")
        return
      end
      skill = AdvancedAI::WILD_POKEMON_SKILL_LEVEL
      AdvancedAI.log("Wild Pokemon - Using skill: #{skill}", "Hooks")
    elsif @trainer
      # Trainer battle - use trainer's skill
      skill = @trainer.skill
      AdvancedAI.log("Trainer battle - Skill: #{skill}", "Hooks")
    else
      # Fallback: no trainer and not wild - shouldn't happen, but default to 100
      skill = 100
      AdvancedAI.log("Unknown battle type - defaulting to skill 100", "Hooks")
    end
    
    return unless AdvancedAI.qualifies_for_advanced_ai?(skill)
    
    battler = @battle.battlers[idxBattler]
    AdvancedAI.log("Qualified for Advanced AI - checking gimmicks for #{battler.name}", "Hooks")
    
    # 3. Decision Pipeline
    # Priority: Mega > Z-Move > Dynamax > Tera
    # (Triggers are mutually exclusive usually per turn)
    
    # --- MEGA EVOLUTION ---
    AdvancedAI.log("Checking Mega Evolution...", "Hooks")
    if AdvancedAI.feature_enabled?(:mega_evolution, skill) && should_mega_evolve?(@user, skill)
      @battle.pbRegisterMegaEvolution(idxBattler)
      AdvancedAI.log("#{@user.name} registered Mega Evolution", "Hooks")
      return # Use one gimmick per turn decision to avoid conflicts
    end
    
    # --- Z-MOVES ---
    AdvancedAI.log("Checking Z-Moves...", "Hooks")
    if AdvancedAI.feature_enabled?(:z_moves, skill) && should_z_move?(@user, skill)
      @battle.pbRegisterZMove(idxBattler)
      AdvancedAI.log("#{@user.name} registered Z-Move", "Hooks")
      return
    end
    
    # --- DYNAMAX ---
    AdvancedAI.log("Checking Dynamax...", "Hooks")
    if AdvancedAI.feature_enabled?(:dynamax, skill) && should_dynamax?(@user, skill)
      @battle.pbRegisterDynamax(idxBattler)
      AdvancedAI.log("#{@user.name} registered Dynamax", "Hooks")
      return
    end
    
    # --- TERASTALLIZATION ---
    AdvancedAI.log("Checking Terastallization...", "Hooks")
    if AdvancedAI.feature_enabled?(:terastallization, skill) && should_terastallize?(@user, skill)
      @battle.pbRegisterTerastallize(idxBattler)
      AdvancedAI.log("#{@user.name} registered Terastallization", "Hooks")
      return
    end
  end
  
  #-----------------------------------------------------------------------------
  # Hook into pbChooseEnemyAction to trigger special action registration
  # This ensures gimmicks are considered even in vanilla Essentials v21.1
  # Only add this hook if the method exists (e.g., from DBK or other plugins)
  #-----------------------------------------------------------------------------
  if Battle::AI.instance_methods.include?(:pbChooseEnemyAction)
    alias aai_pbChooseEnemyAction pbChooseEnemyAction
    def pbChooseEnemyAction(idxBattler)
      # Register special actions (Mega, Z-Move, Dynamax, Tera) before choosing moves
      pbRegisterEnemySpecialAction(idxBattler) if respond_to?(:pbRegisterEnemySpecialAction)
      
      # Call original action selection
      aai_pbChooseEnemyAction(idxBattler)
    end
  end
end

AdvancedAI.log("Advanced AI Mechanics Hooks registered", "Hooks")

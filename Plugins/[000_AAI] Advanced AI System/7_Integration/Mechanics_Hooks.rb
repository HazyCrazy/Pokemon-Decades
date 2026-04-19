#===============================================================================
# Advanced AI System - Mechanics Hooks
# Connects Intelligence Modules to Battle System
#===============================================================================

class Battle::AI
  #-----------------------------------------------------------------------------
  # Main Hook: Register Enemy Special Actions
  # This is where the AI decides to use gimmicks (Mega, Z-Move, Dynamax, Tera)
  #-----------------------------------------------------------------------------
  # PROBLEM: [000_AAI] loads BEFORE [DBK_000]-[DBK_007] alphabetically.
  # DBK_000 defines `pbRegisterEnemySpecialAction` with a plain `def`, clobbering
  # any alias chain AAI tries to set up. DBK_005→DBK_006→DBK_007 then build
  # their own alias chain on top.
  #
  # SOLUTION: Use Module#prepend. A prepended module's methods are checked FIRST
  # in Ruby's method resolution order, even if the class's own method is later
  # overwritten by other plugins. `super` calls through to whatever the class
  # currently defines (the full DBK chain, or vanilla).
  #-----------------------------------------------------------------------------

  # Define AAI's intelligent gimmick logic (always available regardless of hooks)
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
    else
      # Trainer battle - derive trainer from battler index to avoid stale @trainer
      trainer = @battle.pbGetOwnerFromBattlerIndex(idxBattler) rescue @trainer
      if trainer
        skill = trainer.skill_level
        AdvancedAI.log("Trainer battle - Skill: #{skill}", "Hooks")
      else
        # Fallback: no trainer and not wild - shouldn't happen, but default to 100
        skill = 100
        AdvancedAI.log("Unknown battle type - defaulting to skill 100", "Hooks")
      end
    end
    
    return unless AdvancedAI.qualifies_for_advanced_ai?(skill)
    
    battler = @battle.battlers[idxBattler]
    AdvancedAI.log("Qualified for Advanced AI - checking gimmicks for #{battler.name}", "Hooks")
    
    # Wrap in AIBattler for gimmick methods (which expect AIBattler API)
    # @user may be nil or stale here — always use the fresh battler.
    ai_battler = Battle::AI::AIBattler.new(self, idxBattler) rescue battler
    
    # 3. Decision Pipeline
    # Priority: Mega > Z-Move > Dynamax > Tera
    # (Triggers are mutually exclusive usually per turn)
    
    # --- MEGA EVOLUTION ---
    AdvancedAI.log("Checking Mega Evolution...", "Hooks")
    if AdvancedAI.feature_enabled?(:mega_evolution, skill) && should_mega_evolve?(ai_battler, skill)
      @battle.pbRegisterMegaEvolution(idxBattler)
      AdvancedAI.log("#{battler.name} registered Mega Evolution", "Hooks")
      return # Use one gimmick per turn decision to avoid conflicts
    end
    
    # --- Z-MOVES ---
    AdvancedAI.log("Checking Z-Moves...", "Hooks")
    if AdvancedAI.feature_enabled?(:z_moves, skill) && should_z_move?(ai_battler, skill)
      @battle.pbRegisterZMove(idxBattler)
      AdvancedAI.log("#{battler.name} registered Z-Move", "Hooks")
      return
    end
    
    # --- DYNAMAX ---
    AdvancedAI.log("Checking Dynamax...", "Hooks")
    if AdvancedAI.feature_enabled?(:dynamax, skill) && should_dynamax?(ai_battler, skill)
      @battle.pbRegisterDynamax(idxBattler)
      AdvancedAI.log("#{battler.name} registered Dynamax", "Hooks")
      return
    end
    
    # --- TERASTALLIZATION ---
    AdvancedAI.log("Checking Terastallization...", "Hooks")
    if AdvancedAI.feature_enabled?(:terastallization, skill) && should_terastallize?(ai_battler, skill)
      @battle.pbRegisterTerastallize(idxBattler)
      AdvancedAI.log("#{battler.name} registered Terastallization", "Hooks")
      return
    end
  end
  
  #-----------------------------------------------------------------------------
  # Prepend-based hook: survives DBK overwriting pbRegisterEnemySpecialAction
  # Module#prepend inserts BEFORE the class in method resolution order, so our
  # method is always found first. `super` calls through to whatever the class
  # currently defines (DBK_007 → DBK_006 → DBK_005 → DBK_000, or vanilla).
  #-----------------------------------------------------------------------------
  module AAI_GimmickHook
    def pbRegisterEnemySpecialAction(idxBattler)
      # Recursion guard — Z-Power's alias cycles back into this prepended method
      return if @_aai_registering
      @_aai_registering = true
      begin
        battler = @battle.battlers[idxBattler]
        is_wild_with_gimmick = battler.wild? && (
          (battler.pokemon.respond_to?(:dynamax_lvl) && battler.pokemon.dynamax_lvl.to_i > 0) ||
          (battler.pokemon.respond_to?(:tera_type) && !battler.pokemon.tera_type.nil?)
        )

        if is_wild_with_gimmick
          AdvancedAI.log("Wild gimmick detected - skipping DBK auto-register for intelligent decision", "Hooks")
        else
          super if defined?(super)
        end

        run_advanced_ai_special_actions(idxBattler)
      ensure
        @_aai_registering = false
      end
    end
  end
  prepend AAI_GimmickHook
  
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

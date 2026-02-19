#===============================================================================
# Advanced AI System - Core Battle AI Integration
# Hooks into Pokemon Essentials v21.1 AI system
#===============================================================================

# RGSS Safety: Define Kernel#pp so it doesn't try to require the 'pp' library
# which doesn't exist in RGSS/mkxp. This prevents crashes when method
# resolution falls through to Kernel#pp on objects missing a 'pp' method.
module Kernel
  def pp(*args)
    return nil if args.empty?
    args.each { |a| p a }
    return args.length == 1 ? args[0] : args
  end
  module_function :pp
end

#===============================================================================
# AIMove Delegate Patches - Add missing method delegates from Battle::Move
# so that Advanced AI scorers can call move.pp, move.power, etc. on AIMove
#===============================================================================
class Battle::AI::AIMove
  def pp;            return @move.respond_to?(:pp) ? @move.pp : 0;                   end
  def total_pp;      return @move.respond_to?(:total_pp) ? @move.total_pp : 0;       end
  def power;         return @move.respond_to?(:power) ? @move.power : 0;             end
  def priority;      return @move.respond_to?(:priority) ? @move.priority : 0;       end
  def addlEffect;    return @move.respond_to?(:addlEffect) ? @move.addlEffect : 0;   end
  def accuracy;      return @move.respond_to?(:accuracy) ? @move.accuracy : 100;     end
  def category;      return @move.respond_to?(:category) ? @move.category : 0;       end
  def flags;         return @move.respond_to?(:flags) ? @move.flags : [];             end
  def contactMove?;  return @move.respond_to?(:contactMove?) ? @move.contactMove? : false;    end
  def soundMove?;    return @move.respond_to?(:soundMove?) ? @move.soundMove? : false;        end
  def flinchingMove?; return @move.respond_to?(:flinchingMove?) ? @move.flinchingMove? : false; end
  def multiHitMove?; return @move.respond_to?(:multiHitMove?) ? @move.multiHitMove? : false;  end
  def recoilMove?;   return @move.respond_to?(:recoilMove?) ? @move.recoilMove? : false;      end
  def pbNumHits(*args); return @move.respond_to?(:pbNumHits) ? @move.pbNumHits(*args) : 1;    end
end

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
    
    # CRITICAL FIX: Side/field-targeting moves (Stealth Rock, Reflect, Spikes,
    # Light Screen, etc.) have num_targets == 0, so vanilla calls pbGetMoveScore()
    # with NO target argument. We must pick a fallback opponent for scoring context,
    # otherwise score_move_advanced returns 0 and these moves are never chosen.
    if target.nil? && @user
      target = @battle.allOtherSideBattlers(@user.index).find { |b| b && !b.fainted? }
    end
    
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
    
    # === DEBUG: Per-factor move score breakdown ===
    if $DEBUG && @_score_factors && !@_score_factors.empty?
      move_name = @move.name rescue @move.id.to_s
      target_name = target.name rescue "???"
      user_name = @user.name rescue "???"
      echoln "  ┌─ MOVE SCORE: #{move_name} (#{user_name} vs #{target_name}) ─┐"
      echoln "    Base Score:                  100"
      @_score_factors.each do |name, value|
        next if value == 0
        sign = value >= 0 ? "+" : "-"
        padded_name = "#{sign} #{name}:".ljust(33)
        formatted_val = value >= 0 ? "+#{value}" : "#{value}"
        echoln "    #{padded_name}#{formatted_val}"
      end
      echoln "    ─────────────────────────────────"
      echoln "    = Final Score:               #{score}"
      echoln "  └───────────────────────────────────┘"
    end
    @_score_factors = nil
    
    return score
  end
  
  private
  
  def apply_advanced_modifiers(score, move, user, target, skill)
    factors = @_score_factors  # May be nil if not debugging
    
    # Core Systems (50+)
    if AdvancedAI.feature_enabled?(:core, skill)
      if target
        pre = score; score = apply_move_memory(score, move, user, target)
        factors["Move Memory"] = score - pre if factors && score != pre
        
        pre = score; score = apply_threat_assessment(score, move, user, target)
        factors["Threat Assessment"] = score - pre if factors && score != pre
        
        pre = score; score = apply_field_effects(score, move, user, target)
        factors["Field Effects"] = score - pre if factors && score != pre
      end
      if @battle.pbSideSize(0) > 1 && target
        pre = score; score = apply_doubles_coordination(score, move, user, target, skill)
        factors["Doubles Coordination"] = score - pre if factors && score != pre
      end
    end
    
    # Setup Recognition (55+)
    if AdvancedAI.feature_enabled?(:setup, skill)
      pre = score; score = apply_setup_evaluation(score, move, user, target)
      factors["Setup Recognition"] = score - pre if factors && score != pre
    end
    
    # Endgame Scenarios (60+)
    if AdvancedAI.feature_enabled?(:endgame, skill)
      pre = score; score = apply_endgame_logic(score, move, user, target)
      factors["Endgame Logic"] = score - pre if factors && score != pre
    end
    
    # Battle Personalities (65+)
    if AdvancedAI.feature_enabled?(:personalities, skill)
      pre = score; score = apply_personality_modifiers(score, move, user, target)
      factors["Personality"] = score - pre if factors && score != pre
    end
    
    # Strategic Awareness (70+) — archetype counters, win condition shifts,
    # coverage gaps, sacking, collective health, threat persistence, cores
    if skill >= 70
      pre = score; score = apply_strategic_awareness(score, move, user, target, skill)
      factors["Strategic Awareness"] = score - pre if factors && score != pre
    end
    
    # Tactical Enhancements (50+) — ability/item/move awareness, multi-turn planning
    if skill >= 50
      pre = score; score = apply_tactical_enhancements(score, move, user, target, skill)
      factors["Tactical Enhancements"] = score - pre if factors && score != pre
    end
    
    # Item Intelligence (85+)
    if AdvancedAI.feature_enabled?(:items, skill)
      pre = score; score = apply_item_intelligence(score, move, user, target)
      factors["Item Intelligence"] = score - pre if factors && score != pre
    end
    
    # Prediction System (85+)
    if AdvancedAI.feature_enabled?(:prediction, skill)
      if target
        pre = score; score = apply_prediction_logic(score, move, user, target)
        factors["Prediction"] = score - pre if factors && score != pre
      end
    end
    
    return score
  end
  
  # Placeholder methods — overridden by their respective module files
  # These stubs ensure the pipeline works even if a module isn't loaded
  def apply_move_memory(score, move, user, target)
    return score  # Overridden in Move_Memory.rb
  end
  
  def apply_threat_assessment(score, move, user, target)
    return score  # Overridden in Threat_Assessment.rb
  end
  
  def apply_field_effects(score, move, user, target)
    return score  # Overridden in Field_Effects.rb
  end
  
  def apply_doubles_coordination(score, move, user, target, skill = 100)
    return score  # Overridden in Doubles_Coordination.rb
  end
  
  def apply_setup_evaluation(score, move, user, target)
    return score  # Overridden in Setup_Recognition.rb
  end
  
  def apply_endgame_logic(score, move, user, target)
    return score  # Overridden in Endgame_Scenarios.rb
  end
  
  def apply_personality_modifiers(score, move, user, target)
    return score  # Overridden in Battle_Personalities.rb
  end
  
  def apply_strategic_awareness(score, move, user, target, skill = 100)
    return score  # Overridden in Strategic_Awareness.rb
  end
  
  def apply_tactical_enhancements(score, move, user, target, skill = 100)
    return score  # Overridden in Tactical_Enhancements.rb
  end
  
  def apply_item_intelligence(score, move, user, target)
    return score  # Overridden in Item_Intelligence.rb
  end
  
  def apply_prediction_logic(score, move, user, target)
    return score  # Overridden in Prediction_System.rb
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
      
      # Anti-ping-pong: If this Pokemon just switched in, don't switch out
      # due to "terrible moves". Stall teams have low-scoring moves that are
      # still strategically correct (Toxic, Protect, Recover, etc.).
      # This prevents Blissey <-> Toxapex infinite switching loops.
      if terrible_moves && @user.turnCount < 2 && !@user.fainted?
        echoln "  >>> Anti-ping-pong: #{@user.name} just switched in (turn #{@user.turnCount})"
        echoln "  >>> Staying to use available moves instead of switching"
        echoln "========================================"
        return -1
      end
      
      # Stall archetype protection: Stall mons should NOT switch out due to
      # "terrible moves" when their stall gameplan is active (Toxic/Burn ticking,
      # Leech Seed draining). Their moves ARE the strategy.
      if terrible_moves && !@user.fainted? && AdvancedAI.has_stall_moveset?(@user)
        # Check if stall gameplan is working (opponent has passive damage)
        stall_working = false
        @battle.allOtherSideBattlers(@user.index).each do |target|
          next unless target && !target.fainted?
          leech_seed_val = (target.effects[PBEffects::LeechSeed] rescue -1)
          if target.poisoned? || target.burned? ||
             (leech_seed_val.is_a?(Numeric) && leech_seed_val >= 0)
            stall_working = true
            break
          end
        end
        
        if stall_working
          echoln "  >>> Stall Archetype: #{@user.name} has active stall gameplan"
          echoln "  >>> Staying to continue stalling (passive damage ticking)"
          echoln "========================================"
          return -1
        end
        
        # Even without active status, stall mons with recovery should stay
        has_recovery = @user.battler.moves.any? do |m|
          m && AdvancedAI.healing_move?(m.id)
        end
        has_useful_status = @user.battler.moves.any? do |m|
          next false unless m
          [:TOXIC, :WILLOWISP, :THUNDERWAVE, :LEECHSEED, :SCALD].include?(m.id)
        end
        if has_recovery && has_useful_status
          echoln "  >>> Stall Archetype: #{@user.name} has recovery + status moves"
          echoln "  >>> Staying to execute stall strategy"
          echoln "========================================"
          return -1
        end
      end
      
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
        # Returns party index directly (pass terrible_moves as forced_switch)
        best_idx = send(:find_best_switch_advanced, @user, skill, terrible_moves)
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
        end
      end
      echoln "=============================="
    rescue => e
      begin
        msg = "[AAI ERROR] #{e.class}: #{e.message}".gsub('%', '%%')
        bt  = e.backtrace.first(3).join("\n").gsub('%', '%%')
        echoln msg
        echoln bt
      rescue
        echoln "[AAI ERROR] (could not format error message)"
      end
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


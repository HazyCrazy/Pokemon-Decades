#===============================================================================
# [000] Hotfixes - Compatibility Patches
#===============================================================================
# Fixes compatibility issues with DBK Plugins and Essentials Core
# This file is loaded BEFORE all other Advanced AI modules ([000])
#===============================================================================

#===============================================================================
# DBK Wonder Launcher Compatibility
#===============================================================================
# DBK Wonder Launcher checks if Battle is a "Launcher Battle"
# BOTH classes need the method: Battle AND Battle::AI
#===============================================================================

# Battle Class: Main Method (if not already defined)
class Battle
  def launcherBattle?
    # Check if Wonder Launcher is active
    return @launcherBattle if instance_variable_defined?(:@launcherBattle)
    return false
  end unless method_defined?(:launcherBattle?)
end

# Battle::AI Delegation - ALWAYS define (overrides if necessary)
class Battle::AI
  # This method is called by DBK Wonder Launcher in Line 11
  # BEFORE it converts to battle.battle in Line 27
  def launcherBattle?
    # @battle is the actual Battle object (from attr_reader :battle)
    return false unless @battle
    return @battle.launcherBattle? if @battle.respond_to?(:launcherBattle?)
    return false
  end
end

# Debug: Confirm method was defined
puts "[Advanced AI] Battle::AI.launcherBattle? defined: #{Battle::AI.method_defined?(:launcherBattle?)}"

#===============================================================================
# DBK Improved Item AI Hotfix
#===============================================================================
# Problem: NoMethodError 'battler' for nil:NilClass (AIMove)
# Solution: Nil-safe battler method
#===============================================================================

if defined?(Battle::AI::AIMove)
  class Battle::AI::AIMove
    attr_reader :move # Expose underlying move safely
    
    alias original_battler battler if method_defined?(:battler)
    
    def battler
      return original_battler if respond_to?(:original_battler)
      return @battler if instance_variable_defined?(:@battler)
      return nil
    end
    
    # Explicitly delegate common category checks to avoid method_missing weirdness
    # Use safe checks that work with all Battle::Move subclasses
    def physical?
      return @move.physicalMove? if @move && @move.respond_to?(:physicalMove?)
      return @move.physical? if @move && @move.respond_to?(:physical?)
      return false
    end
    
    def special?
      return @move.specialMove? if @move && @move.respond_to?(:specialMove?)
      return @move.special? if @move && @move.respond_to?(:special?)
      return false
    end
    
    def status?
      return @move.statusMove? if @move && @move.respond_to?(:statusMove?)
      return @move.status? if @move && @move.respond_to?(:status?)
      return false
    end
    
    def damagingMove?
      return @move.damagingMove? if @move && @move.respond_to?(:damagingMove?)
      return !status?
    end
    
    def statusMove?
      return @move.statusMove? if @move && @move.respond_to?(:statusMove?)
      return status?
    end

    # Delegate missing methods to the underlying @move object
    # This fixes NoMethodError for power, multiHitMove?, etc.
    def method_missing(method_name, *args, &block)
      if @move && @move.respond_to?(method_name)
        return @move.send(method_name, *args, &block)
      end
      super
    end

    def respond_to_missing?(method_name, include_private = false)
      (@move && @move.respond_to?(method_name, include_private)) || super
    end
  end
end

#===============================================================================
# AIBattler Compatibility
#===============================================================================
# Problem: AIBattler wrapper missing common battler methods
# Solution: Delegate to underlying @battler
#===============================================================================

if defined?(Battle::AI::AIBattler)
  class Battle::AI::AIBattler
    # Delegate ability/item checks to underlying battler
    def hasActiveAbility?(ability)
      return @battler.hasActiveAbility?(ability) if @battler
      return false
    end
    
    def hasActiveItem?(item)
      return @battler.hasActiveItem?(item) if @battler
      return false
    end
    
    #---------------------------------------------------------------------------
    # Delegate stat accessors to underlying battler
    # The AAI scoring code calls user.attack, user.speed, etc. directly,
    # but AIBattler only exposes stats through base_stat(:STAT) / rough_stat(:STAT).
    # Without these delegations, every stat access raises NoMethodError which
    # silently kills move scoring (caught by logonerr) and makes the AI think
    # ALL moves are terrible → endless switch loop.
    #---------------------------------------------------------------------------
    def attack;  return @battler.attack  if @battler; 0; end
    def defense; return @battler.defense if @battler; 0; end
    def spatk;   return @battler.spatk   if @battler; 0; end
    def spdef;   return @battler.spdef   if @battler; 0; end
    def speed;   return @battler.speed   if @battler; 0; end
    def pbSpeed; return @battler.pbSpeed if @battler; 0; end
    
    #---------------------------------------------------------------------------
    # Catch-all: Delegate any other missing methods to the underlying battler.
    # The AAI uses dozens of Battle::Battler methods on AIBattler objects
    # (poisoned?, burned?, affectedByTerrain?, lastMoveUsed, airborne?, etc.)
    # that aren't explicitly delegated. Instead of listing them all, we use
    # method_missing to transparently forward to @battler.
    #---------------------------------------------------------------------------
    def method_missing(method, *args, &block)
      if @battler && @battler.respond_to?(method)
        return @battler.send(method, *args, &block)
      end
      super
    end
    
    def respond_to_missing?(method, include_private = false)
      (@battler && @battler.respond_to?(method, include_private)) || super
    end
  end
end

#===============================================================================
# Essentials Core Effectiveness Hotfix
#===============================================================================
# Problem: SystemStackError in Type::calculate (Recursion)
# Solution: Recursion Guard (max depth 10)
#===============================================================================

module Effectiveness
  @recursion_depth = 0
  MAX_RECURSION_DEPTH = 10
  
  class << self
    alias original_calculate calculate if method_defined?(:calculate)
    
    def calculate(attack_type, *target_types)
      return NORMAL_EFFECTIVE_MULTIPLIER if !attack_type
      target_types = target_types.compact
      return NORMAL_EFFECTIVE_MULTIPLIER if target_types.empty?
      
      @recursion_depth ||= 0
      @recursion_depth += 1
      
      if @recursion_depth > MAX_RECURSION_DEPTH
        @recursion_depth = 0
        return NORMAL_EFFECTIVE_MULTIPLIER
      end
      
      result = original_calculate(attack_type, *target_types)
      @recursion_depth -= 1
      return result
    rescue StandardError => e
      @recursion_depth = 0
      echoln "[Advanced AI] Effectiveness calculation error: #{e.message}" if defined?(echoln)
      return NORMAL_EFFECTIVE_MULTIPLIER
    end
  end
end

# GameData::Type Recursion Guard
if defined?(GameData::Type)
  module GameData
    class Type
      @type_recursion_depth = 0
      MAX_TYPE_RECURSION = 10
      
      class << self
        alias original_type_calculate calculate if method_defined?(:calculate)
        
        def calculate(attack_type, *target_types)
          @type_recursion_depth ||= 0
          @type_recursion_depth += 1
          
          if @type_recursion_depth > MAX_TYPE_RECURSION
            @type_recursion_depth = 0
            return Effectiveness::NORMAL_EFFECTIVE_ONE
          end
          
          result = original_type_calculate(attack_type, *target_types)
          @type_recursion_depth -= 1
          return result
        rescue StandardError => e
          @type_recursion_depth = 0
          echoln "[Advanced AI] Type calculation error: #{e.message}" if defined?(echoln)
          return Effectiveness::NORMAL_EFFECTIVE_ONE
        end
      end
    end
  end
end

#===============================================================================
# Missing Method Shims
#===============================================================================
# Problem: AAI code calls Effectiveness.calculate_one, GameData::Move#physicalMove?,
#          and AdvancedAI::StrategicAwareness.battle_state — none of which exist
#          in Essentials v21.1. Every call raises NoMethodError, gets caught by
#          logonerr, and kills move scoring → "Terrible Moves" every turn.
# Solution: Add compatibility shims that delegate to the real API.
#===============================================================================

# --- Effectiveness.calculate_one(atk_type, def_type) --------------------------
# Returns a float multiplier (0.0 / 0.5 / 1.0 / 2.0) for a single type matchup.
# Used by Strategic_Awareness, 0_Move_Scorer, and Doubles_Coordination.
module Effectiveness
  module_function

  def calculate_one(attack_type, defend_type)
    get_type_effectiveness(attack_type, defend_type) / NORMAL_EFFECTIVE.to_f
  end
end

# --- GameData::Move#physicalMove? / #specialMove? -----------------------------
# GameData::Move stores category as :physical / :special / :status.
# Only Battle::Move has physicalMove?. The AAI's estimate_max_incoming calls
# physicalMove? on GameData::Move objects obtained via GameData::Move.try_get.
class GameData::Move
  def physicalMove?
    self.category == :physical
  end

  def specialMove?
    self.category == :special
  end
end

# --- AdvancedAI::StrategicAwareness.battle_state(battle) ----------------------
# The actual method is get_state(battle). Tactical_Enhancements.rb calls
# battle_state which doesn't exist.
module AdvancedAI
  module StrategicAwareness
    def self.battle_state(battle)
      get_state(battle)
    end
  end
end

puts "[Advanced AI] Hotfixes loaded: Wonder Launcher, Item AI, Type Effectiveness"

#===============================================================================
# Nil-Safe Comparisons for PBEffects
#===============================================================================
# Problem: Some PBEffects values may be nil. Code like `effects[X] > 0`
#          crashes with `NoMethodError: undefined method '>' for nil:NilClass`.
#
# OLD FIX (NilSafeEffects wrapper) was BROKEN:
#   It converted nil → 0, but 0 is TRUTHY in Ruby. Effects like ChoiceBand
#   store nil (not active) or a move Symbol (locked). Converting nil → 0
#   made EVERY battler appear choice-locked → every move scored -1000 →
#   "Terrible Moves" every turn → AI does nothing.
#
# NEW FIX: Monkey-patch NilClass to handle comparison operators safely.
#   nil stays nil (falsy), so `if effects[ChoiceBand]` correctly tests false.
#   But `nil > 0` returns false instead of crashing.
#===============================================================================
class NilClass
  def >(other);  false; end
  def <(other);  false; end
  def >=(other); other.nil?; end
  def <=(other); other.nil?; end
end

#===============================================================================
# ReserveLastPokemon: Opt-In Only
#===============================================================================
# Problem: Essentials v21.1 auto-adds "ReserveLastPokemon" to every trainer
#          with skill >= 100. This causes the AI to hard-block the last party
#          slot from being switched in — even when it's the perfect counter
#          (e.g. refusing to send Mega Houndoom against Psychic/Ice).
# Fix:     Strip the auto-added flag. Only keep it if the trainer's PBS data
#          explicitly includes "ReserveLastPokemon" in their Flags field.
#===============================================================================
class Battle::AI::AITrainer
  alias aai_set_up_skill_flags set_up_skill_flags
  def set_up_skill_flags
    aai_set_up_skill_flags
    # Remove auto-added ReserveLastPokemon UNLESS explicitly set in PBS trainer flags
    explicitly_set = @trainer && @trainer.flags.include?("ReserveLastPokemon")
    if !explicitly_set && @skill_flags.include?("ReserveLastPokemon")
      @skill_flags.delete("ReserveLastPokemon")
    end
  end
end

# Test echoln output
echoln "═══════════════════════════════════════════════════"
echoln "[AAI] Advanced AI System v3.0.0 - DEBUG MODE ACTIVE"
echoln "[AAI] Console output is working!"
echoln "[AAI] Switch Intelligence Handler will be registered by [002] Core.rb"
echoln "═══════════════════════════════════════════════════"


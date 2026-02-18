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

puts "[Advanced AI] Hotfixes loaded: Wonder Launcher, Item AI, Type Effectiveness"

# Test echoln output
echoln "═══════════════════════════════════════════════════"
echoln "[AAI] Advanced AI System v3.0.0 - DEBUG MODE ACTIVE"
echoln "[AAI] Console output is working!"
echoln "[AAI] Switch Intelligence Handler will be registered by [002] Core.rb"
echoln "═══════════════════════════════════════════════════"


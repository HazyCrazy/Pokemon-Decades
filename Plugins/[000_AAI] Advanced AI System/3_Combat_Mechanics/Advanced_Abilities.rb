#===============================================================================
# Advanced AI System - Advanced Ability Awareness
# Handles complex ability interactions and strategic implications
#===============================================================================

module AdvancedAI
  # Ability threat multipliers for strategic awareness
  SNOWBALL_ABILITIES = {
    :MOXIE         => 1.8,  # +1 Atk on KO - snowball threat
    :BEASTBOOST    => 1.8,  # +1 highest stat on KO
    :SOULDEVOURING => 1.8,  # +1 all stats on KO (custom)
    :CHILLINGNEIGH => 1.7,  # +1 Atk on KO (Ice)
    :GRIMNEIGH     => 1.7,  # +1 SpAtk on KO (Dark)
    :ASONEGLASTRIER => 1.9, # Unnerve + Chilling Neigh (+1 Atk on KO)
    :ASONESPECTRIER => 1.9, # Unnerve + Grim Neigh (+1 SpAtk on KO)
    :POWEROFALCHEMY => 1.5,  # Copies fainted ally's ability (could gain Moxie/Speed Boost)
    :RECEIVER       => 1.5,  # Same as Power of Alchemy (doubles variant)
  }
  
  SPEED_SHIFT_ABILITIES = {
    :UNBURDEN      => 2.5,  # 2x Speed after item consumed - MASSIVE threat
    :SLOWSTART     => 0.3,  # Half Atk/Speed for 5 turns - weakling
    :SPEEDBOOST    => 1.6,  # +1 Speed per turn
  }
  
  REVERSE_ABILITIES = {
    :CONTRARY      => 2.0,  # Inverts stat changes (Leaf Storm = +2 SpAtk)
    :DEFIANT       => 1.7,  # +2 Atk when stat lowered
    :COMPETITIVE   => 1.7,  # +2 SpAtk when stat lowered
  }
  
  SWITCH_ABILITIES = {
    :REGENERATOR   => 1.4,  # Heals 33% on switch-out - free recovery
    :NATURALCURE   => 1.3,  # Cures status on switch-out
    :SHEDSKIN      => 1.2,  # 33% chance to cure status per turn
  }
end

class Battle::AI
  # ============================================================================
  # SNOWBALL THREAT DETECTION (Moxie, Beast Boost)
  # ============================================================================
  
  alias advanced_abilities_pbRegisterMove pbRegisterMove
  def pbRegisterMove(user, move)
    score = advanced_abilities_pbRegisterMove(user, move)
    
    return score unless user && move
    
    # Check all targets for snowball abilities
    @battle.allOtherSideBattlers(user.index).each do |target|
      next unless target && !target.fainted?
      
      # SNOWBALL ABILITIES: Don't feed kills to Moxie/Beast Boost users
      snowball_key = AdvancedAI::SNOWBALL_ABILITIES.keys.find { |a| target.hasActiveAbility?(a) }
      if snowball_key
        score += evaluate_snowball_threat(user, move, target)
      end
      
      # REVERSE ABILITIES: Stat drops = stat boosts!
      reverse_key = AdvancedAI::REVERSE_ABILITIES.keys.find { |a| target.hasActiveAbility?(a) }
      if reverse_key
        score += evaluate_reverse_ability(user, move, target)
      end
      
      # SPEED SHIFT: Unburden activation warning
      if target.hasActiveAbility?(:UNBURDEN) && target.item
        score += evaluate_unburden_threat(user, move, target)
      end
    end
    
    # REGENERATOR: Penalty for forcing switch (they get free 33% heal)
    if ["SwitchOutTargetStatusMove", "SwitchOutTargetDamagingMove"].include?(move.function_code)
      # In doubles, only penalize once for the actual target (not all opponents)
      target_battler = @battle.allOtherSideBattlers(user.index).first
      if target_battler && target_battler.hasActiveAbility?(:REGENERATOR)
        score -= 15  # Penalty - they get free 33% heal
        AdvancedAI.log("  #{move.name} vs Regenerator: -15 (free heal on force-out)", "Abilities")
      end
    end
    
    return score
  end
  
  # Evaluate Moxie/Beast Boost snowball threat
  def evaluate_snowball_threat(user, move, target)
    return 0 unless move.damagingMove?
    
    score = 0
    ability_name = ""
    AdvancedAI::SNOWBALL_ABILITIES.each do |ab, _|
      if target.hasActiveAbility?(ab)
        ability_name = GameData::Ability.get(ab).name
        break
      end
    end
    
    # Check if this move would KO the target
    rough_damage = AdvancedAI::CombatUtilities.estimate_damage(user, move, target, as_percent: true)
    would_ko = (rough_damage >= target.hp.to_f / target.totalhp)
    
    if would_ko
      # KOing Moxie/Beast Boost user is GOOD (prevent snowball)
      score += 30
      AdvancedAI.log("  KO #{target.name} (#{ability_name}): +30 (prevent snowball)", "Abilities")
    else
      # DON'T leave them at low HP for easy snowball
      hp_percent = target.hp.to_f / target.totalhp
      if hp_percent < 0.35 && rough_damage > 0.2
        score -= 20  # They can easily KO us next turn and get +1
        AdvancedAI.log("  Damage to #{ability_name}: -20 (sets up snowball)", "Abilities")
      end
    end
    
    # If they already have +1 or more, URGENT to KO
    if target.stages[:ATTACK] >= 1 || target.stages[:SPECIAL_ATTACK] >= 1
      score += 25
      AdvancedAI.log("  #{ability_name} already boosted: +25 (stop snowball)", "Abilities")
    end
    
    return score
  end
  
  # Evaluate Contrary/Defiant/Competitive
  def evaluate_reverse_ability(user, move, target)
    score = 0
    ability_id = AdvancedAI::REVERSE_ABILITIES.keys.find { |a| target.hasActiveAbility?(a) }
    
    case ability_id
    when :CONTRARY
      # DON'T use stat-lowering moves on Contrary users (they become buffs!)
      # This includes both status moves AND damaging moves with stat-drop effects
      # (e.g., Snarl, Icy Wind, Moonblast, Psychic)
      # Check if move lowers target's stats (function_code is a CamelCase string)
      # Exclude LowerTargetHP (Endeavor) — it equalizes HP, doesn't lower stats
      stat_drops = move.function_code.include?("LowerTarget") &&
                   !move.function_code.include?("LowerTargetHP")
      
      if stat_drops
        score -= 50  # NEVER do this
        AdvancedAI.log("  #{move.name} vs Contrary: -50 (inverts to buff!)", "Abilities")
      end
      
      # Contrary users love Leaf Storm, Draco Meteor, Overheat (self-drops = boosts)
      # Prioritize KOing them
      if move.damagingMove?
        score += 15
        AdvancedAI.log("  Damage to Contrary: +15 (prevent reverse setup)", "Abilities")
      end
      
    when :DEFIANT, :COMPETITIVE
      # DON'T use Intimidate switch-ins or stat-lowering moves
      # Includes damaging moves with stat-drop effects (Snarl, Icy Wind, etc.)
      # Exclude LowerTargetHP (Endeavor) — it equalizes HP, doesn't lower stats
      stat_drops = move.function_code.include?("LowerTarget") &&
                   !move.function_code.include?("LowerTargetHP")
      if stat_drops
        score -= 40  # They get +2 Atk/SpAtk!
        AdvancedAI.log("  #{move.name} vs #{ability_id}: -40 (triggers +2)", "Abilities")
      end
      
      # NOTE: Intimidate+Baton Pass interaction removed — Intimidate triggers on
      # SWITCH-IN, not switch-out. The user's own Intimidate is irrelevant here.
    end
    
    return score
  end
  
  # Evaluate Unburden threat
  def evaluate_unburden_threat(user, move, target)
    return 0 unless target.item  # No item = no threat
    
    score = 0
    
    # If move removes item (Knock Off, Thief, Covet)
    if ["RemoveTargetItem", "UserTakesTargetItem"].include?(move.function_code)
      score -= 35  # DON'T trigger Unburden unless KO
      AdvancedAI.log("  #{move.name} vs Unburden: -35 (doubles speed!)", "Abilities")
      
      # Unless it KOs
      rough_damage = AdvancedAI::CombatUtilities.estimate_damage(user, move, target, as_percent: true)
      if rough_damage >= target.hp.to_f / target.totalhp
        score += 50  # KO is fine
        AdvancedAI.log("  But KOs: +50 (worth it)", "Abilities")
      end
    end
    
    # Warn if target has consumable item (Berry) that could trigger Unburden
    consumable_items = [:SITRUSBERRY, :LUMBERRY, :ORANBERRY, :AGUAVBERRY, 
                       :FIGYBERRY, :IAPAPABERRY, :MAGOBERRY, :WIKIBERRY]
    if consumable_items.include?(target.item_id)
      score -= 10  # Might trigger via damage
      AdvancedAI.log("  Unburden + Berry: -10 (might auto-trigger)", "Abilities")
    end
    
    return score
  end
  
  # ============================================================================
  # REGENERATOR SWITCH PREDICTION
  # ============================================================================
  
  def predict_regenerator_switch(target)
    return false unless target.hasActiveAbility?(:REGENERATOR)
    
    hp_percent = target.hp.to_f / target.totalhp
    
    # Regenerator users switch out at 40-60% HP for free recovery
    if hp_percent < 0.6 && hp_percent > 0.2
      AdvancedAI.log("  Regenerator switch predicted (#{(hp_percent * 100).to_i}% HP)", "Abilities")
      return true
    end
    
    return false
  end
  
  # ============================================================================
  # ABILITY-BASED THREAT ASSESSMENT
  # ============================================================================
  
  def calculate_ability_threat_modifier(battler)
    return 1.0 unless battler
    
    multiplier = 1.0
    
    # Snowball abilities
    snowball_key = AdvancedAI::SNOWBALL_ABILITIES.keys.find { |a| battler.hasActiveAbility?(a) }
    if snowball_key
      base = AdvancedAI::SNOWBALL_ABILITIES[snowball_key]
      # Higher if already boosted
      if battler.stages[:ATTACK] >= 1 || battler.stages[:SPECIAL_ATTACK] >= 1
        multiplier = base * 1.3
      else
        multiplier = base
      end
    end
    
    # Speed shift abilities
    speed_key = AdvancedAI::SPEED_SHIFT_ABILITIES.keys.find { |a| battler.hasActiveAbility?(a) }
    if speed_key
      multiplier = AdvancedAI::SPEED_SHIFT_ABILITIES[speed_key]
      
      # Unburden: Only threat if item consumed
      if speed_key == :UNBURDEN && battler.item
        multiplier = 1.0  # Not active yet
      elsif speed_key == :UNBURDEN && !battler.item
        multiplier = 2.5  # ACTIVE - extreme threat
      end
    end
    
    # Reverse abilities
    reverse_key = AdvancedAI::REVERSE_ABILITIES.keys.find { |a| battler.hasActiveAbility?(a) }
    if reverse_key
      multiplier = AdvancedAI::REVERSE_ABILITIES[reverse_key]
    end
    
    # Switch abilities
    switch_key = AdvancedAI::SWITCH_ABILITIES.keys.find { |a| battler.hasActiveAbility?(a) }
    if switch_key
      multiplier = AdvancedAI::SWITCH_ABILITIES[switch_key]
    end
    
    return multiplier
  end
end

AdvancedAI.log("Advanced Abilities System loaded", "Core")
AdvancedAI.log("  - Snowball detection (Moxie, Beast Boost)", "Abilities")
AdvancedAI.log("  - Reverse abilities (Contrary, Defiant, Competitive)", "Abilities")
AdvancedAI.log("  - Speed shift (Unburden, Speed Boost)", "Abilities")
AdvancedAI.log("  - Switch abilities (Regenerator, Natural Cure)", "Abilities")

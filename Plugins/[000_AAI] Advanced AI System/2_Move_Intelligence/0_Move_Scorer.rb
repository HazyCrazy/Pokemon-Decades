#===============================================================================
# Advanced AI System - Move Scorer
# Intelligent Move Scoring with 20+ Factors
#===============================================================================

#===============================================================================
# Priority Move Result - Explicit Auto-Select Flag
#===============================================================================
class PriorityMoveResult
  attr_reader :auto_select, :priority_boost
  
  def initialize(auto_select: false, priority_boost: 0)
    @auto_select = auto_select
    @priority_boost = priority_boost
  end
  
  # Check if this move should auto-select
  def auto_select?
    @auto_select
  end
  
  # Get the priority boost value (0 if auto-selecting)
  def boost_value
    @auto_select ? 0 : @priority_boost
  end
end

class Battle::AI
  #-----------------------------------------------------------------------------
  # Base method for AI move registration - provides hook point for all AI extensions
  # This is the foundation method that other AI files will alias to add their logic
  #-----------------------------------------------------------------------------
  def pbRegisterMove(user, move)
    return 0 unless move && user
    # Base scoring - delegates to the comprehensive move scorer
    # Choose first valid opponent as target (will be refined by score_move_advanced)
    target = @battle.allOtherSideBattlers(user.index).find { |b| b && !b.fainted? }
    return 0 unless target
    score_move_advanced(move, user, target, @battle.pbGetOwnerFromBattlerIndex(user.index))
  end

  # Enhanced Move Scoring Logic
  def score_move_advanced(move, user, target, skill)
    return 0 unless move && user
    
    # Side/field-targeting moves (Stealth Rock, Spikes, Reflect, Light Screen, etc.)
    # are called without a target. Pick a fallback opponent for scoring context.
    if target.nil?
      target = @battle.allOtherSideBattlers(user.index).find { |b| b && !b.fainted? }
      return 0 unless target
    end
    
    # === CRITICAL: PP CHECK ===
    # Don't try to use a move with 0 PP (unless it's Struggle, which is handled elsewhere)
    if move.pp == 0 && move.total_pp > 0
      return -1000
    end
    
    # === PRIORITY TIER SYSTEM ===
    # Check if this move should be auto-selected based on tactical role
    priority_result = check_priority_tier_moves(move, user, target, skill)
    
    # Auto-select if the priority system flags it
    if priority_result.is_a?(PriorityMoveResult) && priority_result.auto_select?
      # Return a very high score to ensure selection (but keep it reasonable for logging)
      final_score = 500 + priority_result.priority_boost
      AdvancedAI.log("#{move.name} AUTO-SELECTED (Tactical Priority): Score #{final_score}", "Priority")
      return final_score
    end
    
    # Extract priority boost for later addition to base score
    priority_boost = priority_result.is_a?(PriorityMoveResult) ? priority_result.boost_value : 0
    
    # === CRITICAL SELF-AWARENESS CHECKS ===
    # These return -1000 for moves that WILL FAIL due to our own status
    
    # Choice Lock: If we're locked, only the locked move can be used
    if user.effects[PBEffects::ChoiceBand] && user.effects[PBEffects::ChoiceBand] != move.id
      return -1000  # Can't use any other move when Choice-locked
    end
    
    # Encore: Must use the encored move
    if user.effects[PBEffects::Encore] > 0 && user.effects[PBEffects::EncoreMove]
      return -1000 if move.id != user.effects[PBEffects::EncoreMove]
    end
    
    # Disable: Can't use the disabled move
    if user.effects[PBEffects::Disable] > 0 && user.effects[PBEffects::DisableMove]
      return -1000 if move.id == user.effects[PBEffects::DisableMove]
    end
    
    # Taunt: Can't use status moves
    if user.effects[PBEffects::Taunt] > 0 && move.statusMove?
      return -1000
    end
    
    # Heal Block: Can't use healing moves
    if user.effects[PBEffects::HealBlock] > 0
      healing_moves = [:RECOVER, :SOFTBOILED, :ROOST, :SLACKOFF, :MOONLIGHT, :MORNINGSUN, 
                       :SYNTHESIS, :WISH, :SHOREUP, :LIFEDEW, :JUNGLEHEALING, :LUNARBLESSING]
      return -1000 if healing_moves.include?(move.id)
    end
    
    # Imprison: Can't use moves the opponent has imprisoned
    @battle.allOtherSideBattlers(user.index).each do |opp|
      next unless opp && !opp.fainted?
      if opp.effects[PBEffects::Imprison]
        opp.moves.each do |opp_move|
          return -1000 if opp_move && opp_move.id == move.id
        end
      end
    end
    
    # === CRITICAL: FALSE SWIPE IN PVP ===
    # FALSE SWIPE should NEVER be used against trainers/PVP
    if move.id == :FALSESWIPE && !@battle.wildBattle?
      return -999  # Terrible in PVP
    end
    
    # Torment: Can't use the same move twice in a row
    if user.effects[PBEffects::Torment] && user.battler.lastMoveUsed == move.id
      return -1000
    end
    
    # Fake Out / First Impression: Only work on first turn out
    if [:FAKEOUT, :FIRSTIMPRESSION].include?(move.id) && user.turnCount > 0
      return -1000  # These moves fail after turn 1
    end
    
    # Throat Chop: Can't use sound moves
    if user.effects[PBEffects::ThroatChop] > 0 && move.soundMove?
      return -1000
    end
    
    # Gravity: Can't use airborne moves
    if @battle.field.effects[PBEffects::Gravity] > 0
      gravity_blocked = [:FLY, :BOUNCE, :SKYDROP, :MAGNETRISE, :TELEKINESIS, :HIGHJUMPKICK, :JUMPKICK, :FLYINGPRESS]
      return -1000 if gravity_blocked.include?(move.id)
    end
    
    # Prankster vs Dark type: Status moves fail
    if AdvancedAI::Utilities.prankster_blocked?(user, target, move)
      return -1000  # Prankster status move blocked by Dark type
    end
    
    # === ABILITY IMMUNITY CHECKS ===
    
    # Magic Bounce: Reflects status/hazard moves back — avoid completely
    if target.hasActiveAbility?(:MAGICBOUNCE)
      # Check if user has Mold Breaker to bypass
      user_ability = user.respond_to?(:ability_id) ? user.ability_id : nil
      unless [:MOLDBREAKER, :TERAVOLT, :TURBOBLAZE].include?(user_ability)
        bounced_moves = [
          :STEALTHROCK, :SPIKES, :TOXICSPIKES, :STICKYWEB,
          :THUNDERWAVE, :WILLOWISP, :TOXIC, :POISONPOWDER, :STUNSPORE,
          :SLEEPPOWDER, :SPORE, :HYPNOSIS, :DARKVOID, :GLARE, :YAWN,
          :SING, :GRASSWHISTLE, :LOVELYKISS, :POISONGAS,
          :TAUNT, :ENCORE, :TORMENT, :DISABLE,
          :ROAR, :WHIRLWIND, :DEFOG,
          :LEECHSEED, :EMBARGO, :HEALBLOCK
        ]
        if bounced_moves.include?(move.id)
          AdvancedAI.log("#{move.name} bounced by Magic Bounce on #{target.name}", "Ability")
          return -1000  # Move reflects back to us!
        end
      end
    end
    
    # Good as Gold: Immune to ALL status moves
    if target.hasActiveAbility?(:GOODASGOLD) && move.statusMove?
      user_ability = user.respond_to?(:ability_id) ? user.ability_id : nil
      unless [:MOLDBREAKER, :TERAVOLT, :TURBOBLAZE].include?(user_ability)
        AdvancedAI.log("#{move.name} blocked by Good as Gold on #{target.name}", "Ability")
        return -1000  # Status move completely fails
      end
    end
    
    # === MOVE-SPECIFIC FAILURE CHECKS ===
    
    # Status-inflicting moves: Don't use if target already has a status condition
    status_moves = {
      :THUNDERWAVE => :PARALYSIS,
      :STUNSPORE => :PARALYSIS,
      :GLARE => :PARALYSIS,
      :NUZZLE => :PARALYSIS,
      :ZAPCANNON => :PARALYSIS,
      :BODYSLAM => :PARALYSIS,  # 30% chance but still counts
      :TOXIC => :POISON,
      :POISONPOWDER => :POISON,
      :POISONGAS => :POISON,
      :POISONFANG => :POISON,
      :TOXICSPIKES => :POISON,  # On grounded targets
      :WILLOWISP => :BURN,
      :SCALD => :BURN,
      :FLAREBLITZ => :BURN,
      :SACREDFIRE => :BURN,
      :SLEEPPOWDER => :SLEEP,
      :SPORE => :SLEEP,
      :HYPNOSIS => :SLEEP,
      :DARKVOID => :SLEEP,
      :GRASSWHISTLE => :SLEEP,
      :LOVELYKISS => :SLEEP,
      :SING => :SLEEP
    }
    
    if status_moves.key?(move.id)
      # Target already has ANY status condition
      if target.status != :NONE
        AdvancedAI.log("#{move.name} blocked: #{target.name} already has #{target.status}", "StatusSpam")
        return -1000  # Can't inflict status on already-statused Pokemon
      end
      
      # Safeguard protection
      if target.pbOwnSide.effects[PBEffects::Safeguard] > 0
        AdvancedAI.log("#{move.name} blocked: Safeguard active on #{target.name}'s side", "StatusSpam")
        return -1000  # Safeguard blocks status
      end
      
      # Misty Terrain blocks status (for grounded targets)
      if @battle.field.terrain == :Misty
        if !target.airborne? && !target.hasActiveAbility?(:LEVITATE)
          AdvancedAI.log("#{move.name} blocked: #{target.name} protected by Misty Terrain", "StatusSpam")
          return -1000  # Misty Terrain prevents status for grounded
        end
      end
    end
    
    # Leech Seed: Can't use on already seeded targets or Grass types
    if move.id == :LEECHSEED
      if target.effects[PBEffects::LeechSeed] >= 0
        AdvancedAI.log("Leech Seed blocked: #{target.name} already seeded", "RedundantMove")
        return -1000
      end
      return -1000 if target.pbHasType?(:GRASS)  # Grass types are immune
    end
    
    # Substitute: Don't use if we already have a substitute
    if move.id == :SUBSTITUTE
      if user.effects[PBEffects::Substitute] > 0
        AdvancedAI.log("Substitute blocked: #{user.name} already has Substitute", "RedundantMove")
        return -1000
      end
    end
    
    # Yawn: Don't use if target is already drowsy or asleep
    if move.id == :YAWN
      if target.effects[PBEffects::Yawn] > 0
        AdvancedAI.log("Yawn blocked: #{target.name} already drowsy", "RedundantMove")
        return -1000
      end
      if target.status == :SLEEP
        AdvancedAI.log("Yawn blocked: #{target.name} already asleep", "RedundantMove")
        return -1000
      end
    end
    
    # Taunt: Don't use if target is already taunted
    if move.id == :TAUNT
      if target.effects[PBEffects::Taunt] > 0
        AdvancedAI.log("Taunt blocked: #{target.name} already taunted", "RedundantMove")
        return -1000
      end
    end
    
    # Encore: Don't use if target is already encored
    if move.id == :ENCORE
      if target.effects[PBEffects::Encore] > 0
        AdvancedAI.log("Encore blocked: #{target.name} already encored", "RedundantMove")
        return -1000
      end
    end
    
    # Embargo: Don't use if target is already embargoed
    if move.id == :EMBARGO
      if target.effects[PBEffects::Embargo] > 0
        AdvancedAI.log("Embargo blocked: #{target.name} already embargoed", "RedundantMove")
        return -1000
      end
    end
    
    # Torment: Don't use if target is already tormented
    if move.id == :TORMENT
      if target.effects[PBEffects::Torment]
        AdvancedAI.log("Torment blocked: #{target.name} already tormented", "RedundantMove")
        return -1000
      end
    end
    
    # Ingrain: Don't use if we're already ingrained
    if move.id == :INGRAIN
      if user.effects[PBEffects::Ingrain]
        AdvancedAI.log("Ingrain blocked: #{user.name} already ingrained", "RedundantMove")
        return -1000
      end
    end
    
    # Aqua Ring: Don't use if we already have Aqua Ring
    if move.id == :AQUARING
      if user.effects[PBEffects::AquaRing]
        AdvancedAI.log("Aqua Ring blocked: #{user.name} already has Aqua Ring", "RedundantMove")
        return -1000
      end
    end
    
    # Screens: Don't use if already active on our side
    if move.id == :REFLECT
      if user.pbOwnSide.effects[PBEffects::Reflect] > 0
        AdvancedAI.log("Reflect blocked: already active", "ScreenSpam")
        return -1000
      end
    end
    
    if move.id == :LIGHTSCREEN
      if user.pbOwnSide.effects[PBEffects::LightScreen] > 0
        AdvancedAI.log("Light Screen blocked: already active", "ScreenSpam")
        return -1000
      end
    end
    
    if move.id == :AURORAVEIL
      if user.pbOwnSide.effects[PBEffects::AuroraVeil] > 0
        AdvancedAI.log("Aurora Veil blocked: already active", "ScreenSpam")
        return -1000
      end
    end
    
    # Hazards: Don't set if already at maximum layers
    if move.id == :STEALTHROCK
      if target.pbOwnSide.effects[PBEffects::StealthRock]
        AdvancedAI.log("Stealth Rock blocked: already active on opponent's side", "HazardSpam")
        return -1000
      end
    end
    
    if move.id == :SPIKES
      spikes_count = target.pbOwnSide.effects[PBEffects::Spikes]
      if spikes_count >= 3
        AdvancedAI.log("Spikes blocked: max 3 layers already active", "HazardSpam")
        return -1000  # Max 3 layers
      end
    end
    
    if move.id == :TOXICSPIKES
      toxic_spikes_count = target.pbOwnSide.effects[PBEffects::ToxicSpikes]
      if toxic_spikes_count >= 2
        AdvancedAI.log("Toxic Spikes blocked: max 2 layers already active", "HazardSpam")
        return -1000  # Max 2 layers
      end
    end
    
    if move.id == :STICKYWEB
      if target.pbOwnSide.effects[PBEffects::StickyWeb]
        AdvancedAI.log("Sticky Web blocked: already active on opponent's side", "HazardSpam")
        return -1000
      end
    end
    
    # Tailwind: Don't use if already active
    if move.id == :TAILWIND
      if user.pbOwnSide.effects[PBEffects::Tailwind] > 0
        AdvancedAI.log("Tailwind blocked: already active", "FieldSpam")
        return -1000
      end
    end
    
    # Trick Room: Don't use if already active (unless intentionally turning it off)
    if move.id == :TRICKROOM
      # Only penalty if we WANT Trick Room and it's already up
      # (Advanced users might want to turn it off, so this is skill-dependent)
      if @battle.field.effects[PBEffects::TrickRoom] > 0 && skill < 80
        AdvancedAI.log("Trick Room blocked: already active (low skill AI)", "FieldSpam")
        return -1000  # Low skill AI won't understand toggling
      end
    end
    
    # Wish: Don't use if we already have Wish coming
    if move.id == :WISH
      return -1000 if user.effects[PBEffects::Wish] > 0
    end
    
    base_score = 100  # Neutral Start
    
    # === DEBUG FACTOR TRACKING ===
    # Track individual factor contributions for debug output
    @_score_factors = nil
    factors = $DEBUG ? {} : nil

    # === STATUS VALUE SCALING ===
    # Apply global multiplier for status moves based on AI tier/skill
    # (e.g. Extreme AI values status moves 1.5x more)
    status_multiplier = 1.0
    if move.statusMove?
      status_multiplier = AdvancedAI.tier_feature(skill, :status_value) || 1.0
      # Boost base score for status moves to make them competitive with damage
      base_score = 120 * status_multiplier
    end
    
    # Apply priority boost from tactical role system (Tier 2)
    base_score += priority_boost
    
    # === TYPE-ABSORBING ABILITY CHECK ===
    # Don't attack into Water Absorb, Volt Absorb, Flash Fire, Sap Sipper, etc.
    if move.damagingMove?
      absorption_penalty = AdvancedAI::Utilities.score_type_absorption_penalty(user, target, move)
      if absorption_penalty < -100
        return absorption_penalty  # Heavy penalty - avoid this move
      end
      base_score += absorption_penalty
      
      # Bulletproof immunity
      if AdvancedAI::Utilities.bulletproof_immune?(user, target, move)
        return -200  # Ball/bomb move blocked
      end
      
      # Soundproof immunity
      if AdvancedAI::Utilities.soundproof_immune?(user, target, move)
        return -200  # Sound move blocked
      end
    end
    
    # === DAMAGE ANALYSIS ===
    if move.damagingMove?
      v = score_damage_potential(move, user, target, skill)
      base_score += v; factors["Damage Potential"] = v if factors && v != 0
      
      v = score_type_effectiveness(move, user, target)
      base_score += v; factors["Type Effectiveness"] = v if factors && v != 0
      
      v = score_stab_bonus(move, user)
      base_score += v; factors["STAB"] = v if factors && v != 0
      
      v = score_crit_potential(move, user, target)
      base_score += v; factors["Crit Potential"] = v if factors && v != 0
      
      # Contact Punishment (Rough Skin, Iron Barbs, Rocky Helmet)
      if move.contactMove?
        v = score_contact_punishment(move, user, target)
        base_score -= v; factors["Contact Punishment"] = -v if factors && v != 0
      end
    end
    
    # === STATUS ANALYSIS ===
    if move.statusMove?
      v = score_status_utility(move, user, target, skill, status_multiplier)
      base_score += v; factors["Status Utility"] = v if factors && v != 0
    end
    
    # === SETUP ANALYSIS ===
    if move.function_code.start_with?("RaiseUser") || AdvancedAI.setup_move?(move.id)
      v = score_setup_value(move, user, target, skill, status_multiplier)
      base_score += v; factors["Setup Value"] = v if factors && v != 0
      
      v = score_setup_vs_mirror_herb(move, user, target)
      base_score += v; factors["Mirror Herb Risk"] = v if factors && v != 0
    end
    
    # === SITUATIONAL FACTORS ===
    v = score_priority(move, user, target)
    base_score += v; factors["Priority"] = v if factors && v != 0
    
    v = score_accuracy(move, skill)
    base_score += v; factors["Accuracy"] = v if factors && v != 0
    
    v = score_recoil_risk(move, user)
    base_score += v; factors["Recoil Risk"] = v if factors && v != 0
    
    v = score_secondary_effects(move, user, target)
    base_score += v; factors["Secondary Effects"] = v if factors && v != 0
    
    v = score_moody_pressure(move, user, target)
    base_score += v; factors["Moody Pressure"] = v if factors && v != 0
    
    v = score_status_vs_berry(move, user, target)
    base_score += v; factors["Status vs Berry"] = v if factors && v != 0
    
    # === REPORTED ISSUES HANDLING ===
    v = score_protect_utility(move, user, target)
    base_score += v; factors["Protect Utility"] = v if factors && v != 0
    
    v = score_prankster_bonus(move, user)
    base_score += v; factors["Prankster Bonus"] = v if factors && v != 0
    
    v = score_pivot_utility(move, user, target, skill)
    base_score += v; factors["Pivot Utility"] = v if factors && v != 0
    
    # === STALL SYNERGY ===
    v = score_stall_synergy(move, user, target)
    base_score += v; factors["Stall Synergy"] = v if factors && v != 0
    
    # === ROLE SYNERGY ===
    v = score_role_synergy(move, user, target, skill)
    base_score += v; factors["Role Synergy"] = v if factors && v != 0
    
    # === MOVE REPETITION PENALTY ===
    v = score_move_repetition_penalty(move, user)
    base_score += v; factors["Repetition Penalty"] = v if factors && v != 0
    
    # === ADVANCED SITUATIONAL AWARENESS ===
    v = score_destiny_bond_awareness(move, user, target)
    base_score += v; factors["Destiny Bond Awareness"] = v if factors && v != 0
    
    v = score_sucker_punch_risk(move, user, target, skill)
    base_score += v; factors["Sucker Punch Risk"] = v if factors && v != 0
    
    v = score_forced_switch_items(move, user, target)
    base_score += v; factors["Forced Switch Items"] = v if factors && v != 0
    
    v = score_item_disruption(move, user, target)
    base_score += v; factors["Item Disruption"] = v if factors && v != 0
    
    # === TACTICAL ENHANCEMENTS ===
    v = score_trapping_moves(move, user, target, skill)
    base_score += v; factors["Trapping"] = v if factors && v != 0
    
    v = score_choice_prelock(move, user, target)
    base_score += v; factors["Choice Pre-lock"] = v if factors && v != 0
    
    v = score_cleric_urgency(move, user)
    base_score += v; factors["Cleric Urgency"] = v if factors && v != 0
    
    v = score_user_destiny_bond(move, user, target)
    base_score += v; factors["Destiny Bond"] = v if factors && v != 0
    
    v = score_ghost_curse(move, user, target)
    base_score += v; factors["Ghost Curse"] = v if factors && v != 0
    
    v = score_counter_mirror_coat(move, user, target)
    base_score += v; factors["Counter/Mirror Coat"] = v if factors && v != 0
    
    v = score_disable_optimization(move, user, target)
    base_score += v; factors["Disable"] = v if factors && v != 0
    
    v = score_healing_wish_target(move, user)
    base_score += v; factors["Healing Wish"] = v if factors && v != 0
    
    v = score_mixed_attacker(move, user, target)
    base_score += v; factors["Mixed Attacker"] = v if factors && v != 0
    
    v = score_transform_ditto(move, user, target)
    base_score += v; factors["Transform"] = v if factors && v != 0
    
    # === TOPSY-TURVY (Gen 6 - Malamar) ===
    # Inverts all target's stat changes
    if move.id == :TOPSYTURVY
      total_boosts = 0
      total_drops = 0
      GameData::Stat.each_battle do |stat|
        stage = target.stages[stat.id] rescue 0
        total_boosts += stage if stage > 0
        total_drops += stage.abs if stage < 0
      end
      if total_boosts >= 4
        base_score += 80  # Massive payoff — inverts +4 or more boosts
        AdvancedAI.log("  Topsy-Turvy: inverting #{total_boosts} boost stages (+80)", "Tactic")
      elsif total_boosts >= 2
        base_score += 50  # Good payoff
      elsif total_boosts == 1
        base_score += 15  # Minor benefit
      elsif total_boosts == 0 && total_drops > 0
        base_score -= 40  # Would invert their drops into boosts!
      else
        base_score -= 20  # No stat changes to invert
      end
      factors["Topsy-Turvy"] = base_score if factors
    end
    
    # === ARMOR CANNON (Gen 9 - Ceruledge) ===
    # 120 BP Fire/Steel, drops user's Def and SpDef by 1 each
    if move.id == :ARMORCANNON
      # Penalty for self-stat drops (similar to Close Combat logic)
      if user.hp > user.totalhp * 0.5
        base_score -= 10  # Def/SpDef drops are risky but manageable at high HP
      else
        base_score -= 25  # At low HP, defensive drops are very dangerous
      end
      # But if this KOs the target, the drops don't matter
      rough_damage = calculate_rough_damage(move, user, target)
      if rough_damage >= target.hp
        base_score += 20  # KO negates the drawback
      end
      factors["Armor Cannon"] = -10 if factors
    end
    
    # === BITTER BLADE (Gen 9 - Ceruledge) ===
    # 90 BP Fire, drains 50% of damage dealt (like Drain Punch but Fire-type)
    if move.id == :BITTERBLADE
      hp_pct = user.hp.to_f / user.totalhp
      if hp_pct < 0.5
        base_score += 25  # Great when at low HP, heals while dealing damage
      elsif hp_pct < 0.75
        base_score += 15  # Useful sustain
      else
        base_score += 5   # Minor benefit at high HP
      end
      factors["Bitter Blade Drain"] = 15 if factors
    end
    
    # === GLAIVE RUSH SELF-RISK ===
    # If using Glaive Rush, AI takes 2x damage next turn - factor this risk
    if move.id == :GLAIVERUSH
      # Estimate incoming damage if we survive
      expected_retaliation = estimate_incoming_damage(user, target)
      doubled_damage = expected_retaliation * 2
      
      if doubled_damage >= user.hp
        base_score -= 80  # High chance of dying next turn
      elsif doubled_damage >= user.hp * 0.7
        base_score -= 40  # Significant risk
      elsif doubled_damage >= user.hp * 0.4
        base_score -= 20  # Moderate risk
      else
        base_score -= 5   # Minor risk
      end
      
      # But if this will KO the target, the risk doesn't matter
      rough_damage = calculate_rough_damage(move, user, target)
      if rough_damage >= target.hp
        base_score += 50  # KO negates the drawback
      end
    end
    
    # Store factor breakdown for debug output in pbGetMoveScore
    @_score_factors = factors
    
    return base_score
  end
  
  private
  
  # Damage Potential
  def score_damage_potential(move, user, target, skill)
    score = 0
    
    # Effective Base Power (Factors in Multi-Hits, Skill Link, etc.)
    bp = calculate_effective_power(move, user, target)
    
    # Base Power Bonus
    score += (bp / 10.0) if bp > 0
    
    # KO Potential
    if skill >= 60
      # Use effective BP for damage calc
      rough_damage = calculate_rough_damage(move, user, target, bp)
      if rough_damage >= target.hp
        score += 100  # Guaranteed KO
      elsif rough_damage >= target.hp * 0.7
        score += 50   # Likely KO
      elsif rough_damage >= target.hp * 0.4
        score += 25
      end
    end
    
    # Multi-Target Bonus
    score += 30 if move.pbTarget(user).num_targets > 1 && @battle.pbSideSize(0) > 1
    
    return score
  end
  
  # Type Effectiveness
  def score_type_effectiveness(move, user, target)
    type_mod = Effectiveness.calculate(move.type, target.types[0], target.types[1])
    
    if Effectiveness.super_effective?(type_mod)
      return 40
    elsif Effectiveness.not_very_effective?(type_mod)
      return -30
    elsif Effectiveness.ineffective?(type_mod)
      return -200
    end
    
    return 0
  end
  
  # STAB Bonus
  def score_stab_bonus(move, user)
    return 20 if user.pbHasType?(move.type)
    return 0
  end
  
  # Critical Hit Potential
  def score_crit_potential(move, user, target)
    score = 0
    
    # 1. Critical Immunity Check
    # If target has Battle Armor, Shell Armor, or Lucky Chant, crits are impossible/unlikely
    return 0 if target.hasActiveAbility?(:BATTLEARMOR) || target.hasActiveAbility?(:SHELLARMOR)
    return 0 if target.pbOwnSide.effects[PBEffects::LuckyChant] > 0
    
    # Check for High Crit Rate Move
    is_high_crit = (move.function_code == "HighCriticalHitRate")
    is_always_crit = move.function_code.include?("AlwaysCriticalHit")
    
    # 2. Synergy: Focus Energy + High Crit Move
    # Focus Energy (+2 stages) + High Crit Move (+1 stage) = +3 stages (100% Crit)
    # NOTE: Do NOT give a synergy bonus for AlwaysCriticalHit moves, because Focus Energy
    # adds nothing to them (they already crit).
    if user.effects[PBEffects::FocusEnergy] > 0
      if is_high_crit
        score += 50  # Massive bonus for correctly using the combo
      elsif !is_always_crit
        # Focus Energy alone gives 50% crit rate (Stage 2)
        # Still good for normal moves, but useless for AlwaysCrit moves
        score += 20
      end
    elsif is_high_crit
      # High Crit Move alone is 1/8 chance (Stage 1), decent but not reliable
      score += 15
    end
    
    # 3. Ignore Stat Changes
    # Critical hits ignore the target's positive defense stages...
    ignore_target_def = (target.stages[:DEFENSE] > 0 && move.physicalMove?) || 
                        (target.stages[:SPECIAL_DEFENSE] > 0 && move.specialMove?)
    
    # ...AND they ignore the user's negative attack stages!
    ignore_user_debuff = (user.stages[:ATTACK] < 0 && move.physicalMove?) || 
                         (user.stages[:SPECIAL_ATTACK] < 0 && move.specialMove?)
    
    if ignore_target_def || ignore_user_debuff
      # Only apply this bonus if we have a RELIABLE crit chance
      # (Focus Energy active OR Move always crits)
      if user.effects[PBEffects::FocusEnergy] > 0 || move.function_code.include?("AlwaysCriticalHit")
        score += 30 # Value bypassing the stats
      end
    end
    
    return score
  end
  
  # Status Move Utility
  def score_status_utility(move, user, target, skill, status_multiplier = 1.0)
    score = 0
    
    # Determine opponent side (for hazards)
    opponent_side = @battle.pbOwnedByPlayer?(target.index) ? @battle.sides[1] : @battle.sides[0]
    
    case move.function_code
    # Hazards
    when "AddSpikesToFoeSide"
      score += 60 if opponent_side.effects[PBEffects::Spikes] < 3
    when "AddStealthRocksToFoeSide"
      unless opponent_side.effects[PBEffects::StealthRock]
        score += 100 * status_multiplier
        # High priority early game or if healthy
        score += 60 if @battle.turnCount <= 1  # Verify turn 1
        score += 40 if user.hp > user.totalhp * 0.8
      end
    when "AddToxicSpikesToFoeSide"
      score += 50 if opponent_side.effects[PBEffects::ToxicSpikes] < 2
    when "AddStickyWebToFoeSide"
      # Score high if opponent side has no sticky web and we aren't faster
      score += 60 unless opponent_side.effects[PBEffects::StickyWeb]
    # Screens
    when "StartWeakenPhysicalDamageAgainstUserSide" # Reflect
      if user.pbOwnSide.effects[PBEffects::Reflect] == 0
        score += 80 * status_multiplier
        # Priority on turn 1
        score += 50 if @battle.turnCount <= 1 
        # Bonus if opponent's last move was Physical
        if target.lastRegularMoveUsed
          move_data = GameData::Move.try_get(target.lastRegularMoveUsed)
          score += 40 if move_data&.physical?
        end
      end
    when "StartWeakenSpecialDamageAgainstUserSide" # Light Screen
      if user.pbOwnSide.effects[PBEffects::LightScreen] == 0
        score += 80 * status_multiplier
        # Priority on turn 1
        score += 50 if @battle.turnCount <= 1
        # Bonus if opponent's last move was Special
        if target.lastRegularMoveUsed
          move_data = GameData::Move.try_get(target.lastRegularMoveUsed)
          score += 40 if move_data&.special?
        end
      end
    when "StartWeakenDamageAgainstUserSideIfHail" # Aurora Veil
      if (@battle.pbWeather == :Hail || @battle.pbWeather == :Snow) && user.pbOwnSide.effects[PBEffects::AuroraVeil] == 0
        score += 60
        # Bonus if opponent's last move was Damaging
        if target.lastRegularMoveUsed
          move_data = GameData::Move.try_get(target.lastRegularMoveUsed)
          score += 40 if move_data&.damaging?
        end
      end
      
    # Recovery
    when "HealUserHalfOfTotalHP", "HealUserDependingOnWeather"
      hp_percent = user.hp.to_f / user.totalhp
      if hp_percent < 0.3
        score += 150  # Critical urgency
      elsif hp_percent < 0.5
        score += 100  # Strong urgency
      elsif hp_percent < 0.7
        score += 40   # Maintenance
      end
      
      # Boost if faster
      score += 30 if user.pbSpeed > target.pbSpeed
      
    # Status Infliction
    when "ParalyzeTarget"
      # Thunder Wave - CRITICAL vs faster targets
      if target.pbSpeed > user.pbSpeed && target.status == :NONE
        score += 80  # Massive bonus - cripple faster threats
        # Extra bonus if we can KO after paralyze
        target_speed_after = target.pbSpeed / 2
        if user.pbSpeed > target_speed_after
          score += 30  # Now we outspeed and can KO
        end
      elsif target.status == :NONE
        score += 25  # Still useful vs slower targets
      end
      
    when "BurnTarget"
      # Will-O-Wisp - CRITICAL vs physical attackers
      if target.attack > target.spatk && target.status == :NONE
        score += 100  # Massive bonus - nerf physical attackers
        # Extra bonus if we resist their attacks
        if target.lastRegularMoveUsed
          last_move = GameData::Move.try_get(target.lastRegularMoveUsed)
          if last_move && last_move.physicalMove?
            score += 40  # They're locked into physical damage
          end
        end
      elsif target.status == :NONE
        score += 30  # Still useful for passive damage
      end
      
    when "PoisonTarget"
      # Basic Poison - good chip damage
      if target.status == :NONE && target.hp > target.totalhp * 0.7
        score += 35
        # Bonus vs bulky targets
        if target.defense + target.spdef > 200
          score += 25  # Walls hate poison
        end
      end
      
    when "BadPoisonTarget"
      # Toxic - CRITICAL vs walls and stall
      if target.status == :NONE
        score += 60  # Strong base value
        # HUGE bonus vs bulky/recovery Pokemon
        if target.defense + target.spdef > 200
          score += 70  # Toxic destroys walls
        end
        # Bonus vs regenerator/recovery moves
        if target.hasActiveAbility?(:REGENERATOR)
          score += 50  # Counter regenerator stalling
        end
        # Bonus if we have stall tactics (Protect, recovery)
        stall_moves = [:PROTECT, :DETECT, :RECOVER, :ROOST, :SOFTBOILED, :WISH, :REST]
        user_knows_stall = user.battler.moves.any? { |m| stall_moves.include?(m.id) }
        if user_knows_stall
          score += 40  # Can stall out Toxic damage
        end
      end
      
    when "SleepTarget"
      # Sleep - CRITICAL control move
      if target.status == :NONE
        score += 90  # Sleep is incredibly powerful
        # Bonus if we can setup during sleep
        setup_moves = user.battler.moves.any? { |m| AdvancedAI.setup_move?(m.id) }
        if setup_moves
          score += 60  # Free setup turns!
        end
        # Bonus vs offensive threats
        if target.attack > 120 || target.spatk > 120
          score += 40  # Neutralize sweepers
        end
      end
      
    # Stat Drops
    when "LowerTargetAttack1", "LowerTargetAttack2",
         "LowerTargetSpeed1", "LowerTargetSpeed2",
         "LowerTargetDefense1", "LowerTargetDefense2",
         "LowerTargetSpAtk1", "LowerTargetSpAtk2",
         "LowerTargetSpDef1", "LowerTargetSpDef2",
         "LowerTargetAtkDef1", "LowerTargetEvasion1", "LowerTargetEvasion2"
      # Stat-drop immunity: Clear Body, White Smoke, Full Metal Body, Clear Amulet
      stat_drop_blocked = false
      if !AdvancedAI::Utilities.ignores_ability?(user)
        if [:CLEARBODY, :WHITESMOKE, :FULLMETALBODY].include?(target.ability_id)
          score -= 200  # Move will completely fail
          stat_drop_blocked = true
        end
      end
      if !stat_drop_blocked && AdvancedAI::Utilities.has_clear_amulet?(target)
        score -= 200  # Move will completely fail
        stat_drop_blocked = true
      end
      # Stat-specific scoring (only if not blocked by immunity)
      if !stat_drop_blocked
        case move.function_code
        when "LowerTargetAttack1", "LowerTargetAttack2"
          score -= 200 if target.stages[:ATTACK] <= -6
          score += 30 if target.attack > target.spatk
        when "LowerTargetSpeed1", "LowerTargetSpeed2"
          score -= 200 if target.stages[:SPEED] <= -6
          score += 35 if target.pbSpeed > user.pbSpeed
        when "LowerTargetDefense1", "LowerTargetDefense2"
          score -= 200 if target.stages[:DEFENSE] <= -6
          score += 25 if user.attack > user.spatk
        when "LowerTargetSpAtk1", "LowerTargetSpAtk2"
          score -= 200 if target.stages[:SPECIAL_ATTACK] <= -6
          score += 30 if target.spatk > target.attack
        when "LowerTargetSpDef1", "LowerTargetSpDef2"
          score -= 200 if target.stages[:SPECIAL_DEFENSE] <= -6
          score += 25 if user.spatk > user.attack
        when "LowerTargetEvasion1", "LowerTargetEvasion2"
          score -= 200 if target.stages[:EVASION] <= -6
          score += 20
        when "LowerTargetAtkDef1"
          score += 35
        end
      end
    end
    
    return score
  end
  
  # Setup Value
  def score_setup_value(move, user, target, skill, status_multiplier = 1.0)
    return 0 unless skill >= 55
    score = 0
    
    # === HARD COUNTERS: Abilities that negate stat boosts entirely ===
    # Unaware: Target ignores ALL of our stat changes when taking/dealing damage
    if target.ability_id == :UNAWARE && !AdvancedAI::Utilities.ignores_ability?(user)
      return -60  # Setting up is literally pointless
    end
    
    # === ANTI-SETUP THREAT DETECTION ===
    # Check if the opponent has moves that punish or negate setup
    anti_setup_penalty = 0
    
    target.moves.each do |tmove|
      next unless tmove
      move_id = tmove.id rescue (tmove.respond_to?(:id) ? tmove.id : nil)
      next unless move_id
      
      case move_id
      # Phazing: Forces switch, ALL boosts are lost
      when :ROAR, :WHIRLWIND, :DRAGONTAIL, :CIRCLETHROW
        anti_setup_penalty -= 80
      # Stat Reset: Directly removes all stat changes
      when :HAZE
        anti_setup_penalty -= 90
      when :CLEARSMOG
        anti_setup_penalty -= 70  # Damaging but also resets stats
      # Boost Theft/Reversal
      when :SPECTRALTHIEF
        anti_setup_penalty -= 80  # Steals your boosts AND damages
      when :TOPSYTURVY
        anti_setup_penalty -= 90  # Turns +6 into -6
      # Encore: Locks you into the setup move, wasting turns
      when :ENCORE
        anti_setup_penalty -= 60
      # Yawn: You'll fall asleep before benefiting from boosts
      when :YAWN
        anti_setup_penalty -= 50
      # Perish Song: You'll be forced out or die, boosts wasted
      when :PERISHSONG
        anti_setup_penalty -= 40
      # Trick/Switcheroo with Choice item: Locks you into setup move
      when :TRICK, :SWITCHEROO
        anti_setup_penalty -= 30
      # Taunt: Will prevent further setup
      when :TAUNT
        anti_setup_penalty -= 25
      # Disable: Can lock you out of your boosted attack
      when :DISABLE
        anti_setup_penalty -= 20
      end
    end
    
    # Cap the anti-setup penalty (one hard counter is enough to discourage)
    anti_setup_penalty = [anti_setup_penalty, -100].max
    
    # If opponent has major anti-setup tools, return the penalty directly
    if anti_setup_penalty <= -60
      return anti_setup_penalty
    end
    
    # Safe to setup?
    safe_to_setup = is_safe_to_setup?(user, target)
    
    if safe_to_setup

      # Boost Strength
      total_boosts = 0
      
      # Try to get data from MoveCategories
      setup_data = AdvancedAI.get_setup_data(move.id)
      if setup_data
        total_boosts = setup_data[:stages] || 1
      elsif move.function_code.start_with?("RaiseUser")
        # Extract boost amount from function code (e.g., "RaiseUserAttack1" -> 1)
        total_boosts = move.function_code.scan(/\d+/).last.to_i
        total_boosts = 1 if total_boosts == 0
      else
        total_boosts = 1
      end
      
      score += total_boosts * 40 * status_multiplier
      
      # Sweep Potential
      if user.hp > user.totalhp * 0.7
        score += 30
      end
      
      # Apply the (milder) anti-setup penalty even when "safe"
      score += anti_setup_penalty
    else
      score -= 40  # Dangerous to setup
    end
    
    return score
  end
  
  # Priority
  def score_priority(move, user, target)
    return 0 if move.priority <= 0
    
    score = move.priority * 15
    
    # 1. Desperation Logic: User Low HP & Slower
    if user.hp <= user.totalhp * 0.33 && target.pbSpeed > user.pbSpeed
      score += 40 
    end

    # 2. Priority Blockers
    if move.priority > 0
      # Psychic Terrain (blocks priority against grounded targets)
      if @battle.field.terrain == :Psychic && target.affectedByTerrain?
        return -100
      end
      
      # Ability Blockers (Dazzling, Queenly Majesty, Armor Tail)
      # These abilities block priority moves targeting the user
      blocking_abilities = [:DAZZLING, :QUEENLYMAJESTY, :ARMORTAIL]
      if blocking_abilities.include?(target.ability_id) && !user.hasMoldBreaker?
        return -100
      end
    end
    
    # Extra Bonus if slower
    score += 30 if target.pbSpeed > user.pbSpeed
    
    # Extra Bonus if KO possible
    if move.damagingMove?
      rough_damage = calculate_rough_damage(move, user, target)
      score += 40 if rough_damage >= target.hp
    end
    
    return score
  end
  
  # Accuracy
  def score_accuracy(move, skill)
    # Use raw accuracy to avoid AIMove#accuracy crash (needs battler which might be nil)
    # If move is AIMove (wrapper), get inner move. If regular Move, use it directly.
    accuracy = move.respond_to?(:move) ? move.move.accuracy : move.accuracy
    return 0 if accuracy == 0  # Never-miss moves
    
    if accuracy < 70
      return -40
    elsif accuracy < 85
      return -20
    elsif accuracy < 95
      return -10
    end
    
    return 0
  end
  
  # Recoil Risk
  def score_recoil_risk(move, user)
    return 0 unless move.recoilMove?
    
    hp_percent = user.hp.to_f / user.totalhp
    
    if hp_percent < 0.3
      return -50  # Dangerous at low HP
    elsif hp_percent < 0.5
      return -25
    else
      return -10  # Acceptable risk
    end
  end
  
  # Secondary Effects
  def score_secondary_effects(move, user, target)
    score = 0
    
    # Covert Cloak blocks secondary effects
    if AdvancedAI::Utilities.has_covert_cloak?(target)
      return 0  # No secondary effect value
    end
    
    # Shield Dust blocks secondary effects
    if target.ability_id == :SHIELDDUST
      return 0
    end
    
    # Flinch
    if move.flinchingMove?
      # Inner Focus / Scrappy / Own Tempo etc. prevent flinch
      unless [:INNERFOCUS, :OWNTEMPO, :OBLIVIOUS].include?(target.ability_id)
        score += 20 if user.pbSpeed > target.pbSpeed
      end
    end
    
    # Stat Drops on Target (secondary effect on damaging moves)
    if move.function_code.start_with?("LowerTarget")
      # Clear Amulet / Clear Body / White Smoke prevent stat drops
      if AdvancedAI::Utilities.has_clear_amulet?(target)
        score -= 30  # Secondary stat-drop wasted
      elsif !AdvancedAI::Utilities.ignores_ability?(user) &&
            [:CLEARBODY, :WHITESMOKE, :FULLMETALBODY].include?(target.ability_id)
        score -= 30  # Secondary stat-drop wasted
      else
        score += 20
      end
    end
    
    # Status Chance
    if ["ParalyzeTarget", "BurnTarget", "PoisonTarget", "SleepTarget", "FreezeTarget"].any? {|code| move.function_code.include?(code)}
      score += move.addlEffect / 2
    end
    
    return score
  end
  
  # Contact Move Punishment
  # Accounts for Rough Skin, Iron Barbs, Rocky Helmet, etc.
  def score_contact_punishment(move, user, target)
    return 0 unless move && move.contactMove?
    return 0 unless target
    
    # Long Reach ignores contact entirely
    return 0 if user.hasActiveAbility?(:LONGREACH)
    
    # Protective Pads prevents contact damage
    return 0 if user.hasActiveItem?(:PROTECTIVEPADS)
    
    score_penalty = 0
    mold_breaker = AdvancedAI::Utilities.ignores_ability?(user)
    
    # === Damage Abilities ===
    unless mold_breaker
      # Rough Skin / Iron Barbs (1/8 max HP)
      if target.hasActiveAbility?(:ROUGHSKIN) || target.hasActiveAbility?(:IRONBARBS)
        recoil_damage = user.totalhp / 8
        hp_percent_lost = (recoil_damage * 100.0 / [user.hp, 1].max)
        
        if hp_percent_lost >= 100
          score_penalty += 80  # Would KO self
        elsif hp_percent_lost >= 50
          score_penalty += 40  # Major damage
        elsif hp_percent_lost >= 25
          score_penalty += 20
        else
          score_penalty += 10
        end
      end
      
      # === Status Abilities ===
      if user.status == :NONE
        # Flame Body (30% Burn)
        if target.hasActiveAbility?(:FLAMEBODY)
          # Physical attackers hurt more by burn
          if user.attack > user.spatk
            score_penalty += 25
          else
            score_penalty += 10
          end
        end
        
        # Static (30% Paralysis)
        if target.hasActiveAbility?(:STATIC)
          # Fast Pokemon hurt more by paralysis
          if user.pbSpeed >= 100
            score_penalty += 20
          else
            score_penalty += 8
          end
        end
        
        # Poison Point (30% Poison)
        if target.hasActiveAbility?(:POISONPOINT)
          score_penalty += 10
        end
        
        # Effect Spore (30% sleep/para/poison)
        if target.hasActiveAbility?(:EFFECTSPORE)
          # Safety Goggles protects
          score_penalty += 15 unless user.hasActiveItem?(:SAFETYGOGGLES)
        end
      end
      
      # === Speed Drop Abilities ===
      # Gooey / Tangling Hair (-1 Speed)
      if target.hasActiveAbility?(:GOOEY) || target.hasActiveAbility?(:TANGLINGHAIR)
        # Only matters if we care about speed
        if user.pbSpeed >= target.pbSpeed
          score_penalty += 15  # Could lose speed advantage
        else
          score_penalty += 5   # Already slower
        end
      end
      
      # === Special Abilities ===
      # Perish Body (both get Perish Song)
      if target.hasActiveAbility?(:PERISHBODY)
        score_penalty += 30 unless user.effects[PBEffects::PerishSong] > 0
      end
      
      # Mummy / Lingering Aroma (changes ability)
      if target.hasActiveAbility?(:MUMMY) || target.hasActiveAbility?(:LINGERINGAROMA)
        # Only penalize if user has a good ability
        good_abilities = [:HUGEPOWER, :PUREPOWER, :SPEEDBOOST, :PROTEAN, :LIBERO,
                          :WONDERGUARD, :MAGICGUARD, :MULTISCALE, :SHADOWSHIELD]
        score_penalty += 25 if good_abilities.include?(user.ability_id)
      end
      
      # Wandering Spirit (swaps abilities)
      if target.hasActiveAbility?(:WANDERINGSPIRIT)
        score_penalty += 15  # Usually undesirable
      end
    end
    
    # === Rocky Helmet (not an ability) ===
    if target.hasActiveItem?(:ROCKYHELMET)
      recoil_damage = user.totalhp / 6
      hp_percent_lost = (recoil_damage * 100.0 / [user.hp, 1].max)
      
      if hp_percent_lost >= 100
        score_penalty += 100  # Would KO self
      elsif hp_percent_lost >= 50
        score_penalty += 50
      elsif hp_percent_lost >= 25
        score_penalty += 25
      else
        score_penalty += 12
      end
    end
    
    return score_penalty
  end
  
  # === HELPER METHODS ===
  
  def calculate_rough_damage(move, user, target, override_bp = nil)
    return 0 unless move.damagingMove?
    
    # Very Simplified Damage Calculation
    bp = override_bp || move.power
    return 0 if bp == 0
    
    # === GEN 9 VARIABLE POWER MOVES ===
    # Last Respects - 50 + 50 per fainted ally
    if move.id == :LASTRESPECTS && @battle
      bp = AdvancedAI::Utilities.last_respects_power(@battle, user)
    end
    
    # Rage Fist - 50 + 50 per hit taken
    if move.id == :RAGEFIST
      bp = AdvancedAI::Utilities.rage_fist_power(user)
    end
    
    # Collision Course / Electro Drift - 1.33x if SE
    if AdvancedAI::Utilities.collision_move_boost?(move)
      type_check = Effectiveness.calculate(move.type, target.types[0], target.types[1])
      bp = (bp * 1.33).to_i if Effectiveness.super_effective?(type_check)
    end
    
    # === FUSION MOVES (Gen 5 - Reshiram/Zekrom) ===
    # Fusion Flare: 2x power if Fusion Bolt was used this turn
    if move.id == :FUSIONFLARE
      # In doubles, if ally just used Fusion Bolt, power doubles
      if @battle && @battle.pbSideSize(0) > 1
        bp *= 2  # Assume combo in doubles for AI scoring
      end
    end
    
    # Fusion Bolt: 2x power if Fusion Flare was used this turn
    if move.id == :FUSIONBOLT
      if @battle && @battle.pbSideSize(0) > 1
        bp *= 2  # Assume combo in doubles for AI scoring
      end
    end
    
    # === HYDRO STEAM (Gen 9) ===
    # Water move that gets 1.5x BOOST in Sun instead of being weakened
    if move.id == :HYDROSTEAM && @battle
      weather = @battle.pbWeather rescue :None
      if [:Sun, :HarshSun].include?(weather)
        bp = (bp * 1.5).to_i  # Boosted in Sun!
      end
    end
    
    # === PSYBLADE (Gen 9) ===
    # 1.5x power in Electric Terrain
    if move.id == :PSYBLADE && @battle
      terrain = @battle.field.terrain rescue nil
      if terrain == :Electric
        bp = (bp * 1.5).to_i
      end
    end
    
    # === PLEDGE MOVES (Gen 5 - Starter Combos) ===
    # In doubles, pledge combos create field effects
    if [:FIREPLEDGE, :WATERPLEDGE, :GRASSPLEDGE].include?(move.id)
      if @battle && @battle.pbSideSize(0) > 1
        # Check if ally has a complementary pledge
        allies = @battle.allSameSideBattlers(user.index).select { |b| b && b != user && !b.fainted? }
        has_combo = allies.any? do |ally|
          ally.moves.any? do |m|
            next false unless m
            case move.id
            when :FIREPLEDGE
              [:WATERPLEDGE, :GRASSPLEDGE].include?(m.id)
            when :WATERPLEDGE
              [:FIREPLEDGE, :GRASSPLEDGE].include?(m.id)
            when :GRASSPLEDGE
              [:FIREPLEDGE, :WATERPLEDGE].include?(m.id)
            else
              false
            end
          end
        end
        bp = 150 if has_combo  # Combined pledge = 150 BP + field effect
      end
    end
    
    # === TERRAIN PULSE (Gen 8) ===
    # Type changes with terrain, 2x power when grounded in active terrain
    if move.id == :TERRAINPULSE && @battle
      terrain = @battle.field.terrain rescue nil
      if terrain && user.affectedByTerrain?
        bp *= 2  # Doubles in active terrain
      end
    end
    
    # === WEIGHT-BASED MOVES ===
    # Heavy Slam / Heat Crash - damage based on user weight vs target weight ratio
    if [:HEAVYSLAM, :HEATCRASH].include?(move.id)
      user_weight = user.pbWeight rescue 100
      target_weight = target.pbWeight rescue 100
      ratio = user_weight.to_f / [target_weight, 1].max
      if ratio >= 5
        bp = 120
      elsif ratio >= 4
        bp = 100
      elsif ratio >= 3
        bp = 80
      elsif ratio >= 2
        bp = 60
      else
        bp = 40
      end
    end
    
    # Low Kick / Grass Knot - damage based on target weight
    if [:LOWKICK, :GRASSKNOT].include?(move.id)
      target_weight = target.pbWeight rescue 100
      if target_weight >= 200
        bp = 120
      elsif target_weight >= 100
        bp = 100
      elsif target_weight >= 50
        bp = 80
      elsif target_weight >= 25
        bp = 60
      elsif target_weight >= 10
        bp = 40
      else
        bp = 20
      end
    end
    
    # === SPECIAL MOVE BASE POWER SCALING ===
    # Facade doubles when statused
    if move.id == :FACADE && user.status != :NONE
      bp *= 2
    end
    
    # Hex doubles vs statused target
    if move.id == :HEX && target.status != :NONE
      bp *= 2
    end
    
    # Venoshock doubles vs poisoned target
    if move.id == :VENOSHOCK && [:POISON, :TOXIC].include?(target.status)
      bp *= 2
    end
    
    # Brine doubles at <50% HP
    if move.id == :BRINE && target.hp < target.totalhp / 2
      bp *= 2
    end
    
    # Avalanche / Revenge double if hit first
    if [:AVALANCHE, :REVENGE].include?(move.id) && user.lastHPLost > 0
      bp *= 2
    end
    
    # Stored Power / Power Trip - 20 BP per positive stat stage
    if [:STOREDPOWER, :POWERTRIP].include?(move.id)
      stat_boosts = 0
      GameData::Stat.each_battle do |stat|
        stage = user.stages[stat.id] rescue 0
        stat_boosts += stage if stage > 0
      end
      bp = 20 + (20 * stat_boosts)
    end
    
    # Knock Off - 1.5x damage if target has item
    if move.id == :KNOCKOFF && target.item && target.item != :NONE
      bp = (bp * 1.5).to_i
    end
    
    # Acrobatics - 2x damage without item
    if move.id == :ACROBATICS && (!user.item || user.item == :NONE)
      bp *= 2
    end
    
    # Poltergeist - fails if no item
    if move.id == :POLTERGEIST && (!target.item || target.item == :NONE)
      return 0  # Move fails
    end
    
    # === STAT CALCULATION ===
    atk = move.physicalMove? ? user.attack : user.spatk
    defense = move.physicalMove? ? target.defense : target.spdef
    
    # === SPECIAL STAT-USING MOVES ===
    # Foul Play - uses target's Attack stat
    if move.id == :FOULPLAY
      atk = target.attack
    end
    
    # Body Press - uses user's Defense instead of Attack
    if move.id == :BODYPRESS
      atk = user.defense
    end
    
    # Psyshock / Psystrike / Secret Sword - special attack vs physical Defense
    if [:PSYSHOCK, :PSYSTRIKE, :SECRETSWORD].include?(move.id)
      defense = target.defense  # Use Defense instead of SpDef
    end
    
    # Photon Geyser / Light That Burns the Sky - uses higher attacking stat
    if [:PHOTONGEYSER, :LIGHTTHATBURNSTHESKY].include?(move.id)
      atk = [user.attack, user.spatk].max
    end
    
    # === FIXED DAMAGE MOVES (bypass normal calc) ===
    # Seismic Toss / Night Shade - level-based fixed damage
    if [:SEISMICTOSS, :NIGHTSHADE].include?(move.id)
      return user.level
    end
    
    # Super Fang / Nature's Madness - 50% current HP
    if [:SUPERFANG, :NATURESMADNESS].include?(move.id)
      return [target.hp / 2, 1].max
    end
    
    # Ruination - 50% current HP (Gen 9 Treasures of Ruin signature)
    if move.id == :RUINATION
      return [target.hp / 2, 1].max
    end
    
    # Final Gambit - user's remaining HP
    if move.id == :FINALGAMBIT
      return user.hp
    end
    
    # Dragon Rage - fixed 40 damage
    if move.id == :DRAGONRAGE
      return 40
    end
    
    # Sonic Boom - fixed 20 damage
    if move.id == :SONICBOOM
      return 20
    end
    
    # Endeavor - reduce to user's HP
    if move.id == :ENDEAVOR
      return [target.hp - user.hp, 0].max
    end
    
    # === UNAWARE HANDLING ===
    # If target has Unaware, ignore user's offensive stat boosts
    if target.ability_id == :UNAWARE && !AdvancedAI::Utilities.ignores_ability?(user)
      # Use base stat instead of boosted stat
      if move.physicalMove?
        atk = user.pokemon.attack rescue user.attack
      else
        atk = user.pokemon.spatk rescue user.spatk
      end
    end
    
    # If user has Unaware, ignore target's defensive stat boosts
    if user.ability_id == :UNAWARE
      if move.physicalMove?
        defense = target.pokemon.defense rescue target.defense
      else
        defense = target.pokemon.spdef rescue target.spdef
      end
    end
    
    # === BURN PHYSICAL DAMAGE REDUCTION ===
    burn_mod = 1.0
    if user.status == :BURN && move.physicalMove?
      # Guts ignores burn penalty AND gets 1.5x boost
      if user.ability_id == :GUTS
        burn_mod = 1.5
      # Flare Boost for special moves (but this is physical so skip)
      else
        burn_mod = 0.5  # Burn halves physical damage
      end
    end
    
    # Guts boost for other statuses too
    if user.ability_id == :GUTS && user.status != :NONE && user.status != :BURN
      burn_mod = 1.5
    end
    
    # Toxic Boost (1.5x physical when poisoned)
    if user.ability_id == :TOXICBOOST && user.poisoned? && move.physicalMove?
      burn_mod = [burn_mod, 1.5].max  # Don't stack, take the higher
    end
    
    # Flare Boost (1.5x special when burned)
    if user.ability_id == :FLAREBOOST && user.burned? && move.specialMove?
      burn_mod = 1.5  # Override burn penalty for special moves
    end
    
    # === TYPE EFFECTIVENESS ===
    type_mod = Effectiveness.calculate(move.type, target.types[0], target.types[1])
    stab = user.pbHasType?(move.type) ? 1.5 : 1.0
    
    # Adaptability STAB boost
    if user.ability_id == :ADAPTABILITY && user.pbHasType?(move.type)
      stab = 2.0
    end
    
    # === ABILITY DAMAGE MODIFIERS ===
    ability_mod = 1.0
    
    # Huge Power / Pure Power
    if [:HUGEPOWER, :PUREPOWER].include?(user.ability_id) && move.physicalMove?
      ability_mod *= 2.0
    end
    
    # Hustle (physical +50%, accuracy penalty handled elsewhere)
    if user.ability_id == :HUSTLE && move.physicalMove?
      ability_mod *= 1.5
    end
    
    # Gorilla Tactics (physical +50% but locked)
    if user.ability_id == :GORILLATACTICS && move.physicalMove?
      ability_mod *= 1.5
    end
    
    # Transistor (Electric +50%)
    if user.ability_id == :TRANSISTOR && move.type == :ELECTRIC
      ability_mod *= 1.5
    end
    
    # Dragons Maw (Dragon +50%)
    if user.ability_id == :DRAGONSMAW && move.type == :DRAGON
      ability_mod *= 1.5
    end
    
    # === RUIN ABILITY DAMAGE MODIFIERS ===
    # Sword of Ruin (user has it): target's Def is -25%
    if user.ability_id == :SWORDOFRUIN && move.physicalMove?
      ability_mod *= 1.25  # Effectively 25% more physical damage
    end
    # Beads of Ruin (user has it): target's SpDef is -25%
    if user.ability_id == :BEADSOFRUIN && move.specialMove?
      ability_mod *= 1.25  # Effectively 25% more special damage
    end
    # Tablets of Ruin (target has it): our Atk is -25%
    if target.ability_id == :TABLETSOFRUIN && move.physicalMove? && !AdvancedAI::Utilities.ignores_ability?(user)
      ability_mod *= 0.75
    end
    # Vessel of Ruin (target has it): our SpAtk is -25%
    if target.ability_id == :VESSELOFRUIN && move.specialMove? && !AdvancedAI::Utilities.ignores_ability?(user)
      ability_mod *= 0.75
    end
    
    # Ice Scales (target has it): special damage halved
    if target.ability_id == :ICESCALES && move.specialMove? && !AdvancedAI::Utilities.ignores_ability?(user)
      ability_mod *= 0.5
    end
    
    # === ITEM DAMAGE MODIFIERS ===
    item_mod = 1.0
    
    if user.item_id == :LIFEORB
      item_mod *= 1.3
    elsif user.item_id == :CHOICEBAND && move.physicalMove?
      item_mod *= 1.5
    elsif user.item_id == :CHOICESPECS && move.specialMove?
      item_mod *= 1.5
    elsif user.item_id == :EXPERTBELT && Effectiveness.super_effective?(type_mod)
      item_mod *= 1.2
    end
    
    # Type-boosting items
    type_items = {
      :SILKSCARF => :NORMAL, :BLACKBELT => :FIGHTING, :SHARPBEAK => :FLYING,
      :POISONBARB => :POISON, :SOFTSAND => :GROUND, :HARDSTONE => :ROCK,
      :SILVERPOWDER => :BUG, :SPELLTAG => :GHOST, :METALCOAT => :STEEL,
      :CHARCOAL => :FIRE, :MYSTICWATER => :WATER, :MIRACLESEED => :GRASS,
      :MAGNET => :ELECTRIC, :TWISTEDSPOON => :PSYCHIC, :NEVERMELTICE => :ICE,
      :DRAGONFANG => :DRAGON, :BLACKGLASSES => :DARK, :FAIRYFEATHER => :FAIRY
    }
    if type_items.key?(user.item_id) && move.type == type_items[user.item_id]
      item_mod *= 1.2
    end
    
    # Plates
    plate_types = {
      :FISTPLATE => :FIGHTING, :SKYPLATE => :FLYING, :TOXICPLATE => :POISON,
      :EARTHPLATE => :GROUND, :STONEPLATE => :ROCK, :INSECTPLATE => :BUG,
      :SPOOKYPLATE => :GHOST, :IRONPLATE => :STEEL, :FLAMEPLATE => :FIRE,
      :SPLASHPLATE => :WATER, :MEADOWPLATE => :GRASS, :ZAPPLATE => :ELECTRIC,
      :MINDPLATE => :PSYCHIC, :ICICLEPLATE => :ICE, :DRACOPLATE => :DRAGON,
      :DREADPLATE => :DARK, :PIXIEPLATE => :FAIRY
    }
    if plate_types.key?(user.item_id) && move.type == plate_types[user.item_id]
      item_mod *= 1.2
    end
    
    # === TARGET STATE MODIFIERS ===
    target_mod = 1.0
    
    # Glaive Rush vulnerability (target takes 2x damage)
    if defined?(PBEffects::GlaiveRush) && target.effects[PBEffects::GlaiveRush] > 0
      target_mod *= 2.0
    end
    
    # Type-resist berries (halve SE damage)
    if AdvancedAI::Utilities.has_resist_berry?(target, move.type) && 
       Effectiveness.super_effective?(type_mod)
      target_mod *= 0.5
    end
    
    # Assault Vest (1.5x SpDef vs special moves)
    if target.item_id == :ASSAULTVEST && move.specialMove?
      # Already factored into spdef stat, but note for consideration
    end
    
    # === FINAL CALCULATION ===
    damage = ((2 * user.level / 5.0 + 2) * bp * atk / [defense, 1].max / 50 + 2)
    damage *= type_mod / Effectiveness::NORMAL_EFFECTIVE.to_f
    damage *= stab
    damage *= burn_mod
    damage *= ability_mod
    damage *= item_mod
    damage *= target_mod
    
    return [damage.to_i, 1].max
  end
  
  def is_safe_to_setup?(user, target)
    # HP Check
    return false if user.hp < user.totalhp * 0.5
    
    # Already drowsy from Yawn — will fall asleep, no time to setup
    yawn_val = (user.effects[PBEffects::Yawn] rescue 0)
    return false if yawn_val.is_a?(Numeric) && yawn_val > 0
    
    # Perish count active — will be forced out or die
    perish_val = (user.effects[PBEffects::PerishSong] rescue 0)
    return false if perish_val.is_a?(Numeric) && perish_val > 0
    
    # Already confused — may hit ourselves instead of benefiting
    confusion_val = (user.effects[PBEffects::Confusion] rescue 0)
    return false if confusion_val.is_a?(Numeric) && confusion_val > 0
    
    # Encored — locked into the setup move, can't use boosted attacks
    encore_val = (user.effects[PBEffects::Encore] rescue 0)
    return false if encore_val.is_a?(Numeric) && encore_val > 0
    
    # Speed Check — opponent outspeeds by a lot, likely KOs before we benefit
    return false if target.pbSpeed > user.pbSpeed * 1.5
    
    # Type Matchup Check — opponent has super-effective moves
    target.moves.each do |move|
      next unless move && move.damagingMove?
      type_mod = Effectiveness.calculate(move.type, user.types[0], user.types[1])
      return false if Effectiveness.super_effective?(type_mod)
    end
    
    # Incoming damage check — if opponent can 2HKO us, setup is risky
    max_incoming = 0
    target.moves.each do |move|
      next unless move && move.damagingMove?
      dmg = (calculate_rough_damage(move, target, user) rescue 0)
      max_incoming = dmg if dmg > max_incoming
    end
    return false if max_incoming > user.hp * 0.55  # Would 2HKO us
    
    return true
  end
  
  # Calculates effective base power including multi-hit factors
  def calculate_effective_power(move, user, target)
    bp = move.power
    return 0 if bp == 0
    
    # Always Critical Hit Logic (e.g. Flower Trick, Frost Breath)
    if move.function_code.include?("AlwaysCriticalHit")
      # Check immunity
      is_immune = target.hasActiveAbility?(:BATTLEARMOR) || 
                  target.hasActiveAbility?(:SHELLARMOR) ||
                  target.pbOwnSide.effects[PBEffects::LuckyChant] > 0
      
      unless is_immune
        bp = (bp * 1.5).to_i
      end
    end
    
    return bp unless move.multiHitMove? || move.function_code == "HitTwoTimes"
    
    if move.multiHitMove?
      if user.hasActiveAbility?(:SKILLLINK)
        return bp * 5
      elsif user.hasActiveItem?(:LOADEDDICE)
        return bp * 4 # Average 4-5 hits
      else
        # Safely get number of hits - some moves like Beat Up require pbMoveFailed?
        # to be called first to initialize state (e.g., @beatUpList)
        begin
          num_hits = move.pbNumHits(user, [target])
          return bp * 2 if num_hits == 2  # Fixed 2-hit moves
          return bp * num_hits if num_hits > 0
        rescue NoMethodError, StandardError
          # If pbNumHits fails (uninitialized state), estimate based on function code
          case move.function_code
          when "HitOncePerUserTeamMember"  # Beat Up - estimate party size
            party = @battle.pbParty(user.index)
            able_count = party.count { |p| p && p.able? && p.status == :NONE }
            return bp * [able_count, 1].max
          when "HitTenTimes"  # Population Bomb
            return bp * 7  # Average hits
          else
            return bp * 3  # Default average for 2-5 hit moves
          end
        end
        return bp * 3 # Average for 2-5 hit moves
      end
    elsif move.function_code == "HitTwoTimes"
       return bp * 2
    end
    
    return bp
  end
  
  #=============================================================================
  # Advanced Situational Awareness Methods
  #=============================================================================
  
  # Destiny Bond Awareness - don't KO if we die too
  def score_destiny_bond_awareness(move, user, target)
    return 0 unless move.damagingMove?
    return 0 unless target.effects[PBEffects::DestinyBond]
    
    # Would we KO them?
    rough_damage = calculate_rough_damage(move, user, target, move.power)
    return 0 if rough_damage < target.hp  # Won't trigger
    
    # We would trigger Destiny Bond!
    hp_percent = user.hp.to_f / user.totalhp
    
    if hp_percent <= 0.3
      return -100  # We're low HP, absolutely not worth dying
    elsif hp_percent <= 0.5
      return -60   # Risky trade
    else
      return -20   # We're healthy, might be worth the trade
    end
  end
  
  # Sucker Punch Risk - fails if target uses non-damaging move
  def score_sucker_punch_risk(move, user, target, skill)
    return 0 unless move.id == :SUCKERPUNCH
    return 0 unless skill >= 60
    
    score = 0
    
    # Count target's status moves
    status_move_count = target.moves.count { |m| m && m.statusMove? }
    total_moves = target.moves.count { |m| m }
    
    return 0 if total_moves == 0
    
    status_ratio = status_move_count.to_f / total_moves
    
    # High status move ratio = risky
    if status_ratio >= 0.5
      score -= 40  # Very likely to fail
    elsif status_ratio >= 0.25
      score -= 20  # Some risk
    end
    
    # Low HP target is more likely to attack
    if target.hp < target.totalhp * 0.3
      score += 25  # They'll probably try to attack
    end
    
    # Check if target has Protect (might use it)
    has_protect = target.moves.any? { |m| m && AdvancedAI.protect_move?(m.id) }
    if has_protect
      score -= 15  # Risk of Protect
    end
    
    # Target just used an attacking move? More likely to attack again
    if target.battler.lastMoveUsed
      last_move_data = GameData::Move.try_get(target.battler.lastMoveUsed)
      if last_move_data && last_move_data.damaging?
        score += 15  # Pattern suggests attacking
      end
    end
    
    score
  end
  
  # Eject Button / Red Card awareness
  def score_forced_switch_items(move, user, target)
    return 0 unless move.damagingMove?
    score = 0
    
    # Eject Button on target - hitting them forces THEIR switch
    if target.item_id == :EJECTBUTTON
      # This is often good - forces them to switch out
      # But check if we WANT them to switch
      if target.stages[:ATTACK] >= 2 || target.stages[:SPECIAL_ATTACK] >= 2
        score += 30  # Force out a setup sweeper = great!
      else
        score += 10  # Neutral to slightly good
      end
    end
    
    # Red Card on target - hitting them forces OUR switch
    if target.item_id == :REDCARD
      # Check if switching is bad for us
      if user.stages[:ATTACK] >= 2 || user.stages[:SPECIAL_ATTACK] >= 2
        score -= 40  # Don't lose our boosts!
      elsif user.effects[PBEffects::Substitute] && user.effects[PBEffects::Substitute] > 0
        score -= 30  # Don't lose our Sub!
      else
        score -= 10  # Generally don't want forced switch
      end
    end
    
    score
  end
  
  # Estimate incoming damage from opponent's strongest move
  def estimate_incoming_damage(defender, attacker)
    return 0 unless attacker && attacker.moves
    
    max_damage = 0
    attacker.moves.each do |move|
      next unless move && move.power > 0
      
      # Simple damage estimate
      atk = move.physicalMove? ? attacker.attack : attacker.spatk
      defense = move.physicalMove? ? defender.defense : defender.spdef
      defense = [defense, 1].max
      
      type_mod = Effectiveness.calculate(move.type, defender.types[0], defender.types[1])
      type_mult = type_mod.to_f / Effectiveness::NORMAL_EFFECTIVE.to_f
      
      stab = attacker.pbHasType?(move.type) ? 1.5 : 1.0
      
      damage = ((2 * attacker.level / 5.0 + 2) * move.power * atk / defense / 50 + 2)
      damage *= type_mult * stab
      
      max_damage = [max_damage, damage.to_i].max
    end
    
    max_damage
  end
  
  # Item Disruption Moves (Trick, Switcheroo, Knock Off, Thief, Covet)
  def score_item_disruption(move, user, target)
    score = 0
    
    # Trick / Switcheroo - swap items
    if [:TRICK, :SWITCHEROO].include?(move.id)
      # Can't swap if target has Sticky Hold
      return -50 if target.ability_id == :STICKYHOLD
      
      # Can't swap if we have no item to give
      return -30 if !user.item || user.item == :NONE
      
      # Swapping Choice items to non-Choice mons is great
      if [:CHOICEBAND, :CHOICESPECS, :CHOICESCARF].include?(user.item_id)
        score += 50  # Cripple their moveset
        # Even better if they rely on status moves
        status_count = target.moves.count { |m| m && m.statusMove? }
        score += status_count * 15
      end
      
      # Swapping Flame Orb / Toxic Orb
      if [:FLAMEORB, :TOXICORB].include?(user.item_id)
        return -50 if target.status != :NONE  # Already statused
        score += 40  # Inflict status
      end
      
      # Swapping Lagging Tail / Iron Ball to fast mons
      if [:LAGGINGTAIL, :IRONBALL].include?(user.item_id) && target.pbSpeed > 100
        score += 30  # Slow them down
      end
      
      # Getting a good item from target
      good_items = [:LEFTOVERS, :LIFEORB, :FOCUSSASH, :CHOICEBAND, :CHOICESPECS,
                    :CHOICESCARF, :ASSAULTVEST, :ROCKYHELMET, :EVIOLITE]
      if good_items.include?(target.item_id)
        score += 25  # We get a good item
      end
    end
    
    # Knock Off bonus (already handled in damage calc, but add strategic value)
    if move.id == :KNOCKOFF && target.item && target.item != :NONE
      # Removing key items is valuable
      valuable_items = [:LEFTOVERS, :EVIOLITE, :FOCUSSASH, :ASSAULTVEST,
                        :LIFEORB, :CHOICEBAND, :CHOICESPECS, :CHOICESCARF,
                        :ROCKYHELMET, :HEAVYDUTYBOOTS]
      if valuable_items.include?(target.item_id)
        score += 25
      else
        score += 10
      end
    end
    
    # Thief / Covet - steal item
    if [:THIEF, :COVET].include?(move.id)
      return -30 if user.item && user.item != :NONE  # We already have item
      return -30 if !target.item || target.item == :NONE  # Nothing to steal
      score += 20  # Steal their item
    end
    
    # Corrosive Gas - remove item from all adjacent
    if move.id == :CORROSIVEGAS
      score += 15 if target.item && target.item != :NONE
    end
    
    # Incinerate - destroy berry
    if move.id == :INCINERATE
      berry_items = AdvancedAI::Utilities::TYPE_RESIST_BERRIES.keys + 
                    [:SITRUSBERRY, :LUMBERRY, :AGUAVBERRY, :FIGYBERRY, :IAPAPABERRY,
                     :MAGOBERRY, :WIKIBERRY, :LIECHIBERRY, :PETAYABERRY, :SALACBERRY]
      if berry_items.include?(target.item_id)
        score += 20  # Destroy their berry
      end
    end
    
    score
  end
  
  #=============================================================================
  # MOODY PRESSURE - Prioritize attacking Moody Pokemon
  #=============================================================================
  def score_moody_pressure(move, user, target)
    return 0 unless target && target.ability_id == :MOODY
    
    bonus = 0
    
    # Prioritize attacking Moody Pokemon - don't let them accumulate boosts
    if move.damagingMove?
      bonus += 20  # Pressure Moody before they scale
      
      # Even higher if they already have boosts
      total_boosts = 0
      GameData::Stat.each_battle do |stat|
        stage = target.stages[stat.id] rescue 0
        total_boosts += stage if stage > 0
      end
      bonus += total_boosts * 8
    end
    
    # Haze/Clear Smog are excellent vs Moody
    if [:HAZE, :CLEARSMOG].include?(move.id)
      total_boosts = 0
      GameData::Stat.each_battle do |stat|
        stage = target.stages[stat.id] rescue 0
        total_boosts += stage if stage > 0
      end
      bonus += total_boosts * 15
    end
    
    # Taunt prevents Protect stalling for Moody boosts
    if move.id == :TAUNT
      bonus += 15
    end
    
    bonus
  end
  
  #=============================================================================
  # MIRROR HERB - Don't boost if opponent will copy
  #=============================================================================
  def score_setup_vs_mirror_herb(move, user, target)
    return 0 unless AdvancedAI.setup_move?(move.id)
    
    penalty = 0
    
    # Check if any opponent has Mirror Herb
    @battle.allOtherSideBattlers(user.index).each do |opp|
      next unless opp && !opp.fainted?
      
      if opp.item_id == :MIRRORHERB
        # They will copy our stat boosts!
        penalty -= 35  # Significant penalty
        
        # Worse if they're a physical attacker and we're boosting Atk
        if move.function_code.include?("Attack") && opp.attack > opp.spatk
          penalty -= 15
        end
      end
      
      # Also check Opportunist ability
      if opp.ability_id == :OPPORTUNIST
        penalty -= 25
      end
    end
    
    penalty
  end
  
  #=============================================================================
  # LUM BERRY TIMING - Don't status if they have Lum Berry
  #=============================================================================
  def score_status_vs_berry(move, user, target)
    return 0 unless move.statusMove?
    return 0 unless target
    
    # Status-inflicting function codes
    status_codes = ["Poison", "Paralyze", "Burn", "Sleep", "Freeze", "Confuse"]
    is_status_move = status_codes.any? { |code| move.function_code.include?(code) }
    
    # Direct status moves
    status_move_ids = [:WILLOWISP, :THUNDERWAVE, :TOXIC, :POISONPOWDER,
                       :STUNSPORE, :SLEEPPOWDER, :SPORE, :NUZZLE,
                       :GLARE, :HYPNOSIS, :DARKVOID, :YAWN, :CONFUSERAY]
    is_status_move ||= status_move_ids.include?(move.id)
    
    return 0 unless is_status_move
    
    penalty = 0
    
    # Lum Berry cures any status
    if target.item_id == :LUMBERRY
      penalty -= 60  # Status will be immediately cured - waste of turn!
    end
    
    # Chesto Berry specifically for Sleep
    if target.item_id == :CHESTOBERRY
      if move.function_code.include?("Sleep") || 
         [:SPORE, :SLEEPPOWDER, :HYPNOSIS, :DARKVOID, :YAWN].include?(move.id)
        penalty -= 50
      end
    end
    
    # Other status berries
    case target.item_id
    when :RAWSTBERRY
      penalty -= 40 if move.function_code.include?("Burn") || move.id == :WILLOWISP
    when :PECHABERRY
      penalty -= 40 if move.function_code.include?("Poison") || [:TOXIC, :POISONPOWDER].include?(move.id)
    when :CHERIBERRY
      penalty -= 40 if move.function_code.include?("Paralyze") || [:THUNDERWAVE, :STUNSPORE, :NUZZLE, :GLARE].include?(move.id)
    when :ASPEARBERRY
      penalty -= 40 if move.function_code.include?("Freeze")
    when :PERSIMBERRY
      penalty -= 40 if move.function_code.include?("Confuse") || move.id == :CONFUSERAY
    end
    
    # Own Tempo / Oblivious - confusion immunity
    if [:OWNTEMPO, :OBLIVIOUS].include?(target.ability_id)
      if move.function_code.include?("Confuse") || move.id == :CONFUSERAY || move.id == :SWAGGER
        penalty -= 50
      end
    end
    
    penalty
  end
  
  #=============================================================================
  # PROTECT / DETECT SCORING (Stall Strategies)
  #=============================================================================
  def score_protect_utility(move, user, target)
    return 0 unless AdvancedAI.protect_move?(move.id)
    protect_rate = user.effects[PBEffects::ProtectRate] rescue 0
    return -100 if (protect_rate || 0) > 1  # Don't spam Protect
    
    score = 0
    
    # 1. Self-Recovery / Stat Boost Stall
    # Leftovers / Black Sludge / Ingrain / Aqua Ring / Poison Heal
    passive_recovery = (user.hasActiveItem?(:LEFTOVERS) || user.hasActiveItem?(:BLACKSLUDGE)) ||
                       user.effects[PBEffects::Ingrain] || user.effects[PBEffects::AquaRing] || 
                       (user.hasActiveAbility?(:POISONHEAL) && user.poisoned?) ||
                       (user.hasActiveAbility?([:DRYSKIN, :RAINDISH]) && [:Rain, :HeavyRain].include?(@battle.pbWeather)) ||
                       (user.hasActiveAbility?(:ICEBODY) && [:Hail, :Snow].include?(@battle.pbWeather)) ||
                       (@battle.field.terrain == :Grassy && user.battler.affectedByTerrain?)
                       
    if passive_recovery
      hp_percent = user.hp.to_f / user.totalhp
      if hp_percent < 0.9
        score += 40  # Heal up safely
        score += 20 if hp_percent < 0.5  # Critical heal
      end
    end

    # Speed Boost / Moody (Stall for stats)
    if user.hasActiveAbility?(:SPEEDBOOST) || user.hasActiveAbility?(:MOODY)
      score += 50  # Free boost
    end
    
    # Wish active? (Receive healing)
    wish_turns = user.effects[PBEffects::Wish] rescue 0
    if wish_turns.is_a?(Numeric) && wish_turns > 0
      score += 80  # Protect to receive Wish is standard play
    end

    # 2. Opponent Damage Stall
    # Poison / Burn / Leech Seed / Curse / Salt Cure
    if target
      leech_seed_val = (target.effects[PBEffects::LeechSeed] rescue -1)
      curse_val      = (target.effects[PBEffects::Curse] rescue false)
      salt_cure_val  = (defined?(PBEffects::SaltCure) ? (target.effects[PBEffects::SaltCure] rescue false) : false)
      passive_damage = target.poisoned? || target.burned? || 
                       (leech_seed_val.is_a?(Numeric) && leech_seed_val >= 0) ||
                       curse_val ||
                       salt_cure_val
                       
      if passive_damage
        score += 45  # Let them rot
        score += 20 if target.hp < target.totalhp * 0.25 # Finish them off
      end
      
      # Perish Song stalling
      perish_val = (target.effects[PBEffects::PerishSong] rescue 0)
      if perish_val.is_a?(Numeric) && perish_val > 0
        score += 60  # Stall out Perish turns
      end
    end
    
    # 3. Double Battle Scouting (Simple)
    if @battle.pbSideSize(0) > 1 && @battle.turnCount == 0
      score += 20  # Protect turn 1 in doubles is common
    end
    
    return score
  end

  #=============================================================================
  # PRANKSTER BONUS (Priority Status)
  #=============================================================================
  def score_prankster_bonus(move, user)
    return 0 unless user.hasActiveAbility?(:PRANKSTER)
    return 0 unless move.statusMove?
    
    score = 40  # Base bonus for having priority status
    
    # High value Prankster moves
    high_value_moves = [:THUNDERWAVE, :WILLOWISP, :TOXIC, :REFLECT, :LIGHTSCREEN, 
                        :AURORAVEIL, :TAILWIND, :TAUNT, :ENCORE, :DISABLE, :SUBSTITUTE,
                        :SPIKES, :STEALTHROCK, :TOXICSPIKES, :SPORE, :SLEEPPOWDER]
                        
    if high_value_moves.include?(move.id)
      score += 25  # Priority disable/hazards/screens are GODLY
    end
    
    return score
  end
  
  #=============================================================================
  # PIVOT UTILITY (Parting Shot, U-turn, etc.)
  #=============================================================================
  def score_pivot_utility(move, user, target, skill)
    return 0 unless AdvancedAI::PivotMoves::ALL_PIVOTS.include?(move.id)
    
    # Delegate to the specialized Pivot module
    # We add this score to the move's base damage/status score
    return AdvancedAI::PivotMoves.evaluate_pivot(@battle, user, move, target, skill)
  end
  
  #=============================================================================
  # MOVE REPETITION PENALTY (Prevents spamming the same move)
  #=============================================================================
  def score_move_repetition_penalty(move, user)
    score = 0
    
    # Check if this is the last move used
    last_move = user.battler.lastMoveUsed
    return 0 unless last_move  # No previous move
    
    # Penalize using the same move consecutively
    if move.id == last_move
      # Moves that SHOULD be spammed (setup sweepers, Protect stalling)
      spam_allowed = [:PROTECT, :DETECT, :KINGSSHIELD, :SPIKYSHIELD, :BANEFULBUNKER,
                      :OBSTRUCT, :SILKTRAP, :BURNINGBULWARK,  # Protect variants
                      :SWORDSDANCE, :NASTYPLOT, :DRAGONDANCE, :QUIVERDANCE,  # Setup
                      :CALMMIND, :IRONDEFENSE, :AMNESIA, :AGILITY,  # More setup
                      :SHELLSMASH, :GEOMANCY, :VICTORYDANCE]  # Ultra setup
      
      # Also allow spamming moves that CHANGE effect on repeat (Rollout, Fury Cutter)
      escalating_moves = [:ROLLOUT, :ICEBALL, :FURYCUTTER, :ECHOEDVOICE]
      
      return 0 if spam_allowed.include?(move.id)
      return 0 if escalating_moves.include?(move.id)
      
      # Attacking moves: Small penalty (variety is good, but not critical)
      if move.damagingMove?
        score -= 15
        AdvancedAI.log("#{move.name}: -15 for repetition (attacking move)", "MoveSpam")
      end
      
      # Status moves: LARGE penalty (Taunt spam, Thunder Wave spam, etc.)
      if move.statusMove?
        score -= 40
        AdvancedAI.log("#{move.name}: -40 for repetition (status move spam prevention)", "MoveSpam")
      end
    end
    
    # Additional penalty if move was used multiple times recently (via Move Memory)
    if defined?(AdvancedAI::MoveMemory)
      frequency = AdvancedAI::MoveMemory.move_frequency(@battle, user, move.id)
      
      # If used 2+ times, add stacking penalty
      if frequency >= 3
        score -= 20  # Used 3+ times = major spam
        AdvancedAI.log("#{move.name}: -20 for frequency spam (used #{frequency} times)", "MoveSpam")
      elsif frequency >= 2
        score -= 10  # Used 2 times = minor spam
        AdvancedAI.log("#{move.name}: -10 for repeated use (used #{frequency} times)", "MoveSpam")
      end
    end
    
    return score
  end
  
  #=============================================================================
  # PRIORITY TIER SYSTEM - Role-Based Status Move Selection
  #=============================================================================
  def check_priority_tier_moves(move, user, target, skill)
    # Only status moves get priority
    return PriorityMoveResult.new unless move.statusMove?
    
    hp_percent = user.hp.to_f / user.totalhp
    turn = @battle.turnCount
    
    # === TIER 1: AUTO-SELECT (1000+) ===
    # These moves bypass normal scoring and are used immediately
    
    # 1. HAZARDS (Turn 1-3, healthy user)
    if [:STEALTHROCK, :SPIKES, :TOXICSPIKES, :STICKYWEB].include?(move.id)
      opponent_side = target.pbOwnSide
      
      # Stealth Rock - highest priority hazard
      if move.id == :STEALTHROCK && !opponent_side.effects[PBEffects::StealthRock]
        if turn <= 3 && hp_percent > 0.7
          return PriorityMoveResult.new(auto_select: true, priority_boost: 100)
        elsif turn <= 5 && hp_percent > 0.6
          return PriorityMoveResult.new(priority_boost: 250)
        end
      end
      
      # Spikes - layer 1 is critical
      if move.id == :SPIKES && opponent_side.effects[PBEffects::Spikes] < 3
        layers = opponent_side.effects[PBEffects::Spikes]
        if layers == 0 && turn <= 2 && hp_percent > 0.7
          return PriorityMoveResult.new(auto_select: true, priority_boost: 50)
        elsif layers < 3 && turn <= 4 && hp_percent > 0.6
          return PriorityMoveResult.new(priority_boost: 200)
        end
      end
      
      # Toxic Spikes
      if move.id == :TOXICSPIKES && opponent_side.effects[PBEffects::ToxicSpikes] < 2
        if opponent_side.effects[PBEffects::ToxicSpikes] == 0 && turn <= 3 && hp_percent > 0.7
          return PriorityMoveResult.new(auto_select: true, priority_boost: 40)
        end
      end
      
      # Sticky Web
      if move.id == :STICKYWEB && !opponent_side.effects[PBEffects::StickyWeb]
        if turn <= 2 && hp_percent > 0.7
          return PriorityMoveResult.new(auto_select: true, priority_boost: 60)
        end
      end
    end
    
    # 2. RECOVERY (Critical HP)
    if move.function_code.start_with?("HealUser")
      if hp_percent < 0.35
        # Check if we're not at immediate OHKO risk
        incoming_damage_estimate = 0
        if target && target.moves
          target.moves.each do |opp_move|
            next unless opp_move && opp_move.damagingMove?
            rough_dmg = calculate_rough_damage(opp_move, target, user) rescue 0
            incoming_damage_estimate = [incoming_damage_estimate, rough_dmg].max
          end
        end
        
        # If we won't get OHKO'd, heal is critical
        if incoming_damage_estimate < user.hp * 0.9
          return PriorityMoveResult.new(auto_select: true, priority_boost: 200)
        end
      elsif hp_percent < 0.5
        return PriorityMoveResult.new(priority_boost: 200)
      elsif hp_percent < 0.7
        return PriorityMoveResult.new(priority_boost: 120)
      end
    end
    
    # 3. SCREENS (Turn 1-2, healthy user)
    if [:REFLECT, :LIGHTSCREEN, :AURORAVEIL].include?(move.id)
      user_side = user.pbOwnSide
      
      # Reflect
      if move.id == :REFLECT && user_side.effects[PBEffects::Reflect] == 0
        if turn <= 2 && hp_percent > 0.6
          # Check if opponent has physical moves
          has_physical_threat = target.moves.any? { |m| m && m.physicalMove? }
          return PriorityMoveResult.new(auto_select: true, priority_boost: 80) if has_physical_threat
        elsif turn <= 4 && hp_percent > 0.5
          return PriorityMoveResult.new(priority_boost: 180)
        end
      end
      
      # Light Screen
      if move.id == :LIGHTSCREEN && user_side.effects[PBEffects::LightScreen] == 0
        if turn <= 2 && hp_percent > 0.6
          # Check if opponent has special moves
          has_special_threat = target.moves.any? { |m| m && m.specialMove? }
          return PriorityMoveResult.new(auto_select: true, priority_boost: 80) if has_special_threat
        elsif turn <= 4 && hp_percent > 0.5
          return PriorityMoveResult.new(priority_boost: 180)
        end
      end
      
      # Aurora Veil (requires Hail/Snow)
      if move.id == :AURORAVEIL && user_side.effects[PBEffects::AuroraVeil] == 0
        if [:Hail, :Snow].include?(@battle.pbWeather) && turn <= 2 && hp_percent > 0.6
          return PriorityMoveResult.new(auto_select: true, priority_boost: 90)
        end
      end
    end
    
    # === TIER 2: HIGH PRIORITY BOOST (100-300) ===
    # These moves get massive score boosts to compete with damage moves
    
    # 4. SETUP MOVES (when safe)
    if AdvancedAI.setup_move?(move.id) || move.function_code.start_with?("RaiseUser")
      if is_safe_to_setup?(user, target)
        # Determine setup value based on move
        setup_value = 200  # Base high priority
        
        # Extra value for sweep-enabling moves
        if [:SWORDSDANCE, :NASTYPLOT, :DRAGONDANCE, :QUIVERDANCE, :SHELLSMASH].include?(move.id)
          setup_value = 250  # Sweep enablers
        end
        
        # Bonus if user is healthy and can sweep
        if hp_percent > 0.7
          setup_value += 50
        end
        
        return PriorityMoveResult.new(priority_boost: setup_value)
      end
    end
    
    # 5. STATUS INFLICTION (tactical value)
    if [:THUNDERWAVE, :WILLOWISP, :TOXIC, :SLEEPPOWDER, :SPORE].include?(move.id)
      if target.status == :NONE
        # Thunder Wave - cripple faster threats
        if move.id == :THUNDERWAVE && target.pbSpeed > user.pbSpeed
          return PriorityMoveResult.new(priority_boost: 180)
        end
        
        # Will-O-Wisp - nerf physical attackers
        if move.id == :WILLOWISP && target.attack > target.spatk
          return PriorityMoveResult.new(priority_boost: 180)
        end
        
        # Toxic - destroy walls
        if move.id == :TOXIC
          if target.defense + target.spdef > 200
            return PriorityMoveResult.new(priority_boost: 200)
          else
            return PriorityMoveResult.new(priority_boost: 140)
          end
        end
        
        # Sleep - ultimate control
        if [:SLEEPPOWDER, :SPORE].include?(move.id)
          return PriorityMoveResult.new(priority_boost: 220)
        end
      end
    end
    
    # 6. TAILWIND (speed control)
    if move.id == :TAILWIND && user.pbOwnSide.effects[PBEffects::Tailwind] == 0
      if turn <= 3
        return PriorityMoveResult.new(priority_boost: 160)
      end
    end
    
    # Default: no priority
    return PriorityMoveResult.new
  end
  
  #=============================================================================
  # ROLE SYNERGY SCORING
  #=============================================================================
  # Adjusts move scores based on the user's detected role.
  # Sweepers prefer setup/priority, Walls prefer recovery/status, etc.
  # This ensures each role actually PLAYS like its archetype.
  #=============================================================================
  def score_role_synergy(move, user, target, skill)
    return 0 unless user && target && move
    return 0 unless skill >= 55  # Only for mid+ skill trainers
    
    # Get role from the full detection system
    primary_role, secondary_role = AdvancedAI.detect_roles(user)
    return 0 if primary_role == :balanced && secondary_role.nil?
    
    score = 0
    move_id = move.id
    
    # === SWEEPER: Setup + Priority + Coverage ===
    if primary_role == :sweeper || secondary_role == :sweeper
      # Sweepers love setup moves (Swords Dance, Dragon Dance, Nasty Plot)
      if AdvancedAI.setup_move?(move_id)
        score += 20
        # Even more valuable early game (not yet boosted)
        user_boosts = user.stages.values.count { |s| s > 0 }
        score += 15 if user_boosts == 0 && user.hp > user.totalhp * 0.7
      end
      
      # Priority moves are the sweeper's insurance policy
      if AdvancedAI.priority_move?(move_id) && move.damagingMove?
        score += 15
        # Extra value when low HP (clean up before going down)
        score += 10 if user.hp < user.totalhp * 0.4
      end
      
      # Coverage moves (super-effective) are key for sweeping
      if move.damagingMove?
        type_mod = Effectiveness.calculate(move.type, *target.pbTypes(true))
        score += 10 if Effectiveness.super_effective?(type_mod)
      end
      
      # Sweepers should avoid non-damaging utility (except setup)
      if move.statusMove? && !AdvancedAI.setup_move?(move_id)
        score -= 10 unless [:SUBSTITUTE, :TAUNT].include?(move_id)
      end
    end
    
    # === WALL: Recovery + Status + Phazing ===
    if primary_role == :wall || secondary_role == :wall
      # Walls need recovery to do their job
      if AdvancedAI.healing_move?(move_id)
        score += 20
        hp_percent = user.hp.to_f / user.totalhp
        score += 15 if hp_percent < 0.65  # More urgent when damaged
      end
      
      # Status moves are the wall's way to threaten
      if AdvancedAI.status_move?(move_id) || [:TOXIC, :WILLOWISP, :THUNDERWAVE].include?(move_id)
        score += 15 if target.status == :NONE
      end
      
      # Phazing racks up hazard damage
      if [:WHIRLWIND, :ROAR, :DRAGONTAIL, :CIRCLETHROW].include?(move_id)
        score += 15
      end
      
      # Walls don't benefit much from setup (except Iron Defense / Calm Mind on some)
      if AdvancedAI.setup_move?(move_id)
        setup_data = AdvancedAI::MoveCategories.get_setup_data(move_id)
        unless setup_data && (setup_data[:stat] == :DEFENSE || setup_data[:stat] == :SPECIAL_DEFENSE)
          score -= 10  # Offensive setup is suboptimal for walls
        end
      end
    end
    
    # === TANK: Bulky Offense — reliable STAB + Recovery ===
    if primary_role == :tank || secondary_role == :tank
      # Tanks want strong reliable STAB moves
      if move.damagingMove? && user.pbHasType?(move.type)
        score += 10  # STAB reliability matters for tanks
        score += 10 if move.power >= 80  # Prefer solid power
      end
      
      # Tanks also value recovery (they have the bulk to use it)
      if AdvancedAI.healing_move?(move_id)
        score += 15
        hp_percent = user.hp.to_f / user.totalhp
        score += 10 if hp_percent < 0.55
      end
      
      # Coverage for tanks
      if move.damagingMove?
        type_mod = Effectiveness.calculate(move.type, *target.pbTypes(true))
        score += 10 if Effectiveness.super_effective?(type_mod)
      end
    end
    
    # === SUPPORT: Screens + Hazards + Status ===
    if primary_role == :support || secondary_role == :support
      # Screens are high priority for support
      if AdvancedAI.screen_move?(move_id)
        score += 25
        # Check if screen is already active (don't re-set)
        own_side = user.index.even? ? @battle.sides[0] : @battle.sides[1]
        if move_id == :REFLECT && own_side.effects[PBEffects::Reflect] > 0
          score -= 40  # Already active
        elsif move_id == :LIGHTSCREEN && own_side.effects[PBEffects::LightScreen] > 0
          score -= 40  # Already active
        elsif move_id == :AURORAVEIL && own_side.effects[PBEffects::AuroraVeil] > 0
          score -= 40  # Already active
        end
      end
      
      # Hazards are the support's primary job
      if AdvancedAI.hazard_move?(move_id)
        score += 25
        # Boost early game, penalty if already set
        score += 15 if @battle.turnCount <= 3
        opponent_side = user.index.even? ? @battle.sides[1] : @battle.sides[0]
        if move_id == :STEALTHROCK && opponent_side.effects[PBEffects::StealthRock]
          score -= 50  # Already up — DON'T use again
        end
        if [:SPIKES, :TOXICSPIKES].include?(move_id)
          max_layers = move_id == :SPIKES ? 3 : 2
          current = move_id == :SPIKES ? opponent_side.effects[PBEffects::Spikes] : opponent_side.effects[PBEffects::ToxicSpikes]
          score -= 50 if current >= max_layers  # Maxed out
        end
      end
      
      # Status infliction is key for support
      if [:TOXIC, :WILLOWISP, :THUNDERWAVE, :TAUNT, :ENCORE].include?(move_id)
        score += 20 if target.status == :NONE || [:TAUNT, :ENCORE].include?(move_id)
      end
      
      # Healing support (Wish, Heal Bell, Aromatherapy)
      if [:WISH, :HEALBELL, :AROMATHERAPY].include?(move_id)
        score += 20
      end
      
      # Support mons should deprioritize weak attacks once their job is done
      if move.damagingMove? && move.power < 70
        score -= 10  # Weak attacks are not the support's focus
      end
    end
    
    # === WALLBREAKER: Raw Power + Coverage ===
    if primary_role == :wallbreaker || secondary_role == :wallbreaker
      if move.damagingMove?
        # Wallbreakers want maximum damage output
        score += 15 if move.power >= 100
        score += 10 if move.power >= 80 && move.power < 100
        
        # Coverage is king for wallbreakers
        type_mod = Effectiveness.calculate(move.type, *target.pbTypes(true))
        score += 15 if Effectiveness.super_effective?(type_mod)
        
        # STAB bonus stacks
        score += 10 if user.pbHasType?(move.type)
        
        # Mixed coverage: wallbreakers should pick the move that hits harder
        if move.physicalMove? && user.attack > user.spatk
          score += 5  # Using better offensive stat
        elsif move.specialMove? && user.spatk > user.attack
          score += 5
        end
      end
      
      # Wallbreakers mostly ignore utility
      if move.statusMove? && ![:SWORDSDANCE, :NASTYPLOT, :CLOSECOMBAT].include?(move_id)
        score -= 15 unless AdvancedAI.setup_move?(move_id)  # One setup move is OK
      end
    end
    
    # === PIVOT: U-turn/Volt Switch optimization ===
    if primary_role == :pivot || secondary_role == :pivot
      if AdvancedAI.pivot_move?(move_id)
        # Pivots should use their pivot moves in bad matchups
        has_type_disadvantage = false
        target.moves.each do |t_move|
          next unless t_move && t_move.damagingMove? && t_move.type
          type_mod = Effectiveness.calculate(t_move.type, *user.pbTypes(true))
          has_type_disadvantage = true if Effectiveness.super_effective?(type_mod)
        end
        score += 25 if has_type_disadvantage  # GET OUT with momentum
        score += 10 unless has_type_disadvantage  # Still good for scouting
      end
      
      # Pivots should avoid committing to non-pivot moves in bad matchups
      if !AdvancedAI.pivot_move?(move_id) && move.damagingMove?
        has_type_disadvantage = false
        target.moves.each do |t_move|
          next unless t_move && t_move.damagingMove? && t_move.type
          type_mod = Effectiveness.calculate(t_move.type, *user.pbTypes(true))
          has_type_disadvantage = true if Effectiveness.super_effective?(type_mod)
        end
        score -= 10 if has_type_disadvantage  # Should be pivoting out, not attacking
      end
    end
    
    # === LEAD: Turn 1 Hazards + Taunt ===
    if primary_role == :lead || secondary_role == :lead
      if @battle.turnCount <= 1
        # Turn 1: Leads should set up hazards ASAP
        if AdvancedAI.hazard_move?(move_id)
          score += 30  # Top priority on turn 1
          # Stealth Rock is the most universally valuable
          score += 10 if move_id == :STEALTHROCK
        end
        
        # Taunt opposing leads/supports
        if move_id == :TAUNT
          score += 25
          opp_role, _ = AdvancedAI.detect_roles(target)
          score += 15 if [:lead, :support, :wall, :stall].include?(opp_role)
        end
        
        # Fake Out for free chip + flinch
        score += 20 if move_id == :FAKEOUT
      end
      
      # After hazards are set, leads should pivot out or attack
      if @battle.turnCount > 2
        opponent_side = user.index.even? ? @battle.sides[1] : @battle.sides[0]
        hazards_set = opponent_side.effects[PBEffects::StealthRock] ||
                      opponent_side.effects[PBEffects::Spikes] > 0 ||
                      opponent_side.effects[PBEffects::ToxicSpikes] > 0
        if hazards_set
          # Job done — prefer pivot moves to bring in a sweeper
          score += 20 if AdvancedAI.pivot_move?(move_id)
          # Hazard moves become useless (already set)
          score -= 20 if AdvancedAI.hazard_move?(move_id)
        end
      end
    end
    
    return score
  end
  
  #=============================================================================
  # STALL SYNERGY SCORING
  #=============================================================================
  # Boosts stall-relevant moves when the user has a stall moveset.
  # This prevents the AI from seeing stall moves as "terrible" and wanting
  # to switch endlessly (Blissey <-> Toxapex loop).
  #=============================================================================
  def score_stall_synergy(move, user, target)
    return 0 unless user && target && move
    
    # Only activate if user has a stall moveset
    return 0 unless AdvancedAI.has_stall_moveset?(user)
    
    stall_data = AdvancedAI.get_stall_data(move.id)
    return 0 unless stall_data
    
    score = 0
    
    # === BASE STALL IDENTITY BONUS ===
    # Stall moves ARE the gameplan — don't penalize them for being "low damage"
    score += 30  # Baseline: stall moves are always valuable for stall mons
    
    case stall_data[:role]
    when :passive_damage
      # === TOXIC / LEECH SEED / WILL-O-WISP ===
      # These are the WIN CONDITION for stall teams
      if target.status == :NONE
        score += 40  # Applying status IS the stall gameplan
        
        # Extra value if user has Protect (can stall out damage)
        has_protect = user.battler.moves.any? { |m| m && AdvancedAI.protect_move?(m.id) }
        score += 25 if has_protect
        
        # Extra value if user has recovery (can outlast)
        has_recovery = user.battler.moves.any? { |m| m && AdvancedAI.healing_move?(m.id) }
        score += 20 if has_recovery
      end
      
      # Leech Seed specific: extra value for self-healing component
      if move.id == :LEECHSEED
        leech_seed_val = (target.effects[PBEffects::LeechSeed] rescue -1)
        if leech_seed_val.is_a?(Numeric) && leech_seed_val < 0
          # Not yet seeded — high priority
          score += 35
          # Bonus vs bulky targets (more HP to drain)
          score += 20 if target.totalhp > 300
        end
      end
      
    when :recovery
      # === RECOVER / SOFTBOILED / WISH / ROOST ===
      # Enhanced recovery scoring for stall mons
      hp_percent = user.hp.to_f / user.totalhp
      
      # Stall mons should recover EARLIER than offensive mons
      if hp_percent < 0.75
        score += 30  # Stall mons want to stay near full HP
      end
      
      # Extra value when opponent has passive damage ticking
      leech_seed_val = (target.effects[PBEffects::LeechSeed] rescue -1)
      target_has_passive = target.poisoned? || target.burned? ||
                           (leech_seed_val.is_a?(Numeric) && leech_seed_val >= 0)
      if target_has_passive
        score += 35  # We're winning the long game, just stay alive
      end
      
      # Wish-specific: plan ahead
      if move.id == :WISH
        wish_turns = user.effects[PBEffects::Wish] rescue 0
        if wish_turns.is_a?(Numeric) && wish_turns == 0 && hp_percent < 0.85
          score += 25  # Set up future healing proactively
        end
      end
      
    when :protection
      # === PROTECT / BANEFUL BUNKER / etc. ===
      # Already handled well by score_protect_utility, but add stall identity bonus
      leech_seed_val = (target.effects[PBEffects::LeechSeed] rescue -1)
      target_has_passive = target.poisoned? || target.burned? ||
                           (leech_seed_val.is_a?(Numeric) && leech_seed_val >= 0)
      if target_has_passive
        score += 20  # Protect is the core of the Toxic stall loop
      end
      
    when :utility
      # === SCALD / KNOCK OFF / HAZE / PHAZE ===
      if move.id == :SCALD && target.status == :NONE && target.attack > target.spatk
        score += 25  # Scald burn chance is the stall gameplan vs physical mons
      end
      
      if [:WHIRLWIND, :ROAR].include?(move.id)
        # Phazing is key for stall — rack up hazard damage
        opponent_side = user.index.even? ? @battle.sides[1] : @battle.sides[0]
        if opponent_side.effects[PBEffects::StealthRock] ||
           opponent_side.effects[PBEffects::Spikes] > 0
          score += 30  # Phaze into hazards
        end
        # Phaze setup sweepers
        target_boosts = target.stages.values.count { |s| s > 0 }
        score += 25 if target_boosts >= 2
      end
      
    when :hazard
      # Hazards already have good scoring, just add stall identity bonus
      score += 15  # Stall teams rely on chip damage
    end
    
    return score
  end

  #=============================================================================
  # TACTICAL ENHANCEMENTS (#6-#17)
  #=============================================================================

  # #6: Trapping moves in singles (Mean Look, Block, Spirit Shackle, etc.)
  TRAPPING_MOVES = [
    :MEANLOOK, :BLOCK, :SPIRITSHACKLE, :ANCHORSHOT, :JAWLOCK,
    :THOUSANDWAVES, :OCTOLOCK, :BIND, :WRAP,
    :FIRESPIN, :WHIRLPOOL, :SANDTOMB, :CLAMP, :MAGMASTORM,
    :INFESTATION, :THUNDERCAGE, :SNAPTRAP
  ]

  def score_trapping_moves(move, user, target, skill)
    return 0 unless target
    return 0 unless TRAPPING_MOVES.include?(move.id)
    score = 0

    # Shed Shell allows guaranteed escape from trapping
    if AdvancedAI.has_shed_shell?(target)
      AdvancedAI.log("  Trapping #{target.name}: -30 (has Shed Shell)", "Tactic")
      return -30  # Trapping is nearly useless against Shed Shell holders
    end

    # Don't trap if target is Ghost (can escape Mean Look/Block)
    if [:MEANLOOK, :BLOCK].include?(move.id)
      target_types = target.respond_to?(:pbTypes) ? target.pbTypes : [target.type1, target.type2].compact rescue [:NORMAL]
      return -30 if target_types.include?(:GHOST)
    end

    # High value: trap a bad matchup for the opponent
    incoming = estimate_incoming_damage(user, target)
    if incoming < user.totalhp * 0.2
      score += 40  # They can't break us, we win this 1v1
      AdvancedAI.log("  Trapping #{target.name}: +40 (favorable)", "Tactic")
    elsif incoming < user.totalhp * 0.35
      score += 20
    elsif incoming > user.totalhp * 0.5
      score -= 20  # Don't trap what kills us
    end

    # Trap + Toxic/Perish Song = great combo
    user.moves.each do |m|
      next unless m
      score += 15 if m.id == :TOXIC
      score += 10 if m.id == :PERISHSONG
    end if user.respond_to?(:moves)

    score += 10 if skill >= 80
    score
  end

  # #8: Choice pre-lock logic — pick the best move to lock into
  def score_choice_prelock(move, user, target)
    return 0 unless target
    user_battler = user.respond_to?(:battler) ? user.battler : user
    item = user_battler.item_id rescue nil
    return 0 unless [:CHOICEBAND, :CHOICESPECS, :CHOICESCARF].include?(item)

    # Only matters if not yet locked
    last = user_battler.lastMoveUsed rescue nil
    return 0 if last  # Already locked

    score = 0

    # Pivot moves = premium on Choice (maintain flexibility)
    if AdvancedAI.pivot_move?(move.id)
      score += 25
      AdvancedAI.log("  Choice pre-lock: +25 pivot", "Tactic")
    end

    # Lock into broadest-coverage damaging move
    if move.damagingMove?
      neutral_or_better = 0
      @battle.allOtherSideBattlers(user.index).each do |opp|
        next if !opp || opp.fainted?
        opp_types = opp.respond_to?(:pbTypes) ? opp.pbTypes : [opp.type1, opp.type2].compact rescue [:NORMAL]
        eff = 1.0
        opp_types.each { |t| eff *= Effectiveness.calculate_one(move.type, t) rescue 1.0 }
        neutral_or_better += 1 if eff >= 1.0
      end
      score += 15 if neutral_or_better >= 2
    end

    # Status on Choice = locked into uselessness
    if move.category == :Status && !AdvancedAI.pivot_move?(move.id)
      score -= 40
      AdvancedAI.log("  Choice pre-lock: -40 (status on Choice)", "Tactic")
    end

    score
  end

  # #9: Cleric urgency scaling (Heal Bell / Aromatherapy)
  def score_cleric_urgency(move, user)
    return 0 unless [:HEALBELL, :AROMATHERAPY].include?(move.id)
    score = 0
    statused_count = 0
    critical_statused = 0

    party = @battle.pbParty(user.index)
    party.each do |pkmn|
      next if !pkmn || pkmn.fainted? || pkmn.egg?
      if pkmn.status != :NONE
        statused_count += 1
        critical_statused += 1 if pkmn.attack >= 100 || pkmn.spatk >= 100 || pkmn.speed >= 100
      end
    end

    if statused_count == 0
      score -= 80  # Nobody needs cleansing
    elsif statused_count == 1
      score += 15
    elsif statused_count == 2
      score += 35
    else
      score += 55  # Multiple teammates cured
    end
    score += critical_statused * 15

    AdvancedAI.log("  Cleric: #{statused_count} statused, bonus=#{score}", "Tactic") if statused_count > 0
    score
  end

  # #10a: User Destiny Bond — proactive at low HP
  def score_user_destiny_bond(move, user, target)
    return 0 unless move.id == :DESTINYBOND
    return 0 unless target
    score = 0

    user_hp_pct = user.hp.to_f / user.totalhp
    user_spd = user.respond_to?(:pbSpeed) ? user.pbSpeed : (user.speed rescue 80)
    target_spd = target.respond_to?(:pbSpeed) ? target.pbSpeed : (target.speed rescue 80)

    if user_hp_pct <= 0.25
      score += 60  # About to die — take them with us
      score += 20 if user_spd < target_spd   # Slower = they attack into DB
      score -= 10 if user_spd >= target_spd   # Faster = DB fades before they move
    elsif user_hp_pct <= 0.40
      score += 30
    else
      score -= 40  # Too healthy
    end

    # High value target (boosted threat)
    target_boosts = target.stages.values.sum rescue 0
    score += 15 if target_boosts >= 3

    AdvancedAI.log("  User Destiny Bond: #{score} (HP=#{(user_hp_pct*100).to_i}%)", "Tactic") if score > 0
    score
  end

  # #10b: Ghost-type Curse (sacrifice 50% HP for 1/4 chip per turn)
  def score_ghost_curse(move, user, target)
    return 0 unless move.id == :CURSE
    return 0 unless target

    user_types = user.respond_to?(:pbTypes) ? user.pbTypes : [user.type1, user.type2].compact rescue [:NORMAL]
    return 0 unless user_types.include?(:GHOST)  # Only Ghost Curse is different

    score = 0
    user_hp_pct = user.hp.to_f / user.totalhp

    # Need >50% HP to survive the cost
    if user_hp_pct <= 0.3
      score -= 50
    elsif user_hp_pct <= 0.55
      score += 10
    else
      score += 40
    end

    # Great against recovery users (25% chip overwhelms most healing)
    if AdvancedAI.has_healing_move?(@battle, target)
      score += 20
    end

    # Excellent against stall/walls
    target_roles = AdvancedAI.detect_roles(target) rescue [:balanced]
    if target_roles.include?(:stall) || target_roles.include?(:wall)
      score += 25
      AdvancedAI.log("  Ghost Curse vs stall: +25", "Tactic")
    end

    # Penalize if target can pivot out easily
    target_memory = AdvancedAI.get_memory(@battle, target) rescue nil
    if target_memory && target_memory[:moves]
      score -= 20 if target_memory[:moves].any? { |m| AdvancedAI.pivot_move?(m) }
    end

    score
  end

  # #11: Counter / Mirror Coat intelligence
  def score_counter_mirror_coat(move, user, target)
    return 0 unless [:COUNTER, :MIRRORCOAT, :METALBURST].include?(move.id)
    return 0 unless target
    score = 0

    # Must survive the incoming hit
    incoming = estimate_incoming_damage(user, target)
    if incoming >= user.hp
      return -60  # Dead before reflecting
    end

    # Predict physical vs special
    predicted_move = AdvancedAI.predict_next_move(@battle, target) rescue nil
    if predicted_move
      pred_data = GameData::Move.try_get(predicted_move)
      if pred_data
        if move.id == :COUNTER && pred_data.physicalMove?
          score += 50
          AdvancedAI.log("  Counter vs predicted physical: +50", "Tactic")
        elsif move.id == :MIRRORCOAT && pred_data.specialMove?
          score += 50
          AdvancedAI.log("  Mirror Coat vs predicted special: +50", "Tactic")
        elsif move.id == :METALBURST && pred_data.power > 0
          score += 35  # Metal Burst reflects both
        elsif move.id == :COUNTER && !pred_data.physicalMove?
          score -= 40  # Wrong type
        elsif move.id == :MIRRORCOAT && !pred_data.specialMove?
          score -= 40
        end
      end
    else
      # Heuristic: physical attacker → Counter, special → Mirror Coat
      if move.id == :COUNTER && target.attack > target.spatk
        score += 25
      elsif move.id == :MIRRORCOAT && target.spatk > target.attack
        score += 25
      elsif move.id == :METALBURST
        score += 20  # Works against either
      end
    end

    score += 10 if user.hp > user.totalhp * 0.7  # More HP = bigger reflect
    score
  end

  # #14: Disable target optimization
  def score_disable_optimization(move, user, target)
    return 0 unless move.id == :DISABLE
    return 0 unless target
    score = 0

    last_used = target.respond_to?(:lastMoveUsed) ? target.lastMoveUsed : nil
    last_used ||= AdvancedAI.last_move(@battle, target) rescue nil
    return -30 unless last_used  # Can't Disable without target using a move

    last_data = GameData::Move.try_get(last_used)
    return -20 unless last_data

    if last_data.power >= 100
      score += 40  # Disabling a nuke
    elsif last_data.power >= 70
      score += 25
    elsif AdvancedAI.setup_move?(last_used)
      score += 35
    elsif AdvancedAI.healing_move?(last_used)
      score += 30
    elsif last_data.category == :Status
      score += 15
    else
      score += 10
    end

    # More impactful with limited moveset
    memory = AdvancedAI.get_memory(@battle, target) rescue nil
    if memory && memory[:moves] && memory[:moves].length <= 2
      score += 15
    end

    AdvancedAI.log("  Disable #{last_used}: +#{score}", "Tactic") if score > 0
    score
  end

  # #15: Healing Wish / Lunar Dance improved teammate evaluation
  def score_healing_wish_target(move, user)
    return 0 unless [:HEALINGWISH, :LUNARDANCE].include?(move.id)

    user_hp_pct = user.hp.to_f / user.totalhp
    return 0 if user_hp_pct > 0.45  # Already handled in Special_Moves

    best_value = 0
    party = @battle.pbParty(user.index)
    party.each do |pkmn|
      next if !pkmn || pkmn.fainted? || pkmn.egg?
      next if pkmn == (user.respond_to?(:pokemon) ? user.pokemon : user)

      hp_pct = pkmn.hp.to_f / pkmn.totalhp
      next if hp_pct > 0.8

      value = 0
      bst = pkmn.attack + pkmn.spatk + pkmn.speed
      value += ((1.0 - hp_pct) * 30).to_i
      value += 20 if bst >= 300
      value += 15 if pkmn.status != :NONE
      value += 10 if move.id == :LUNARDANCE && pkmn.moves.any? { |m| m && m.pp < m.total_pp / 2 }

      best_value = value if value > best_value
    end

    AdvancedAI.log("  #{move.name} teammate value: #{best_value}", "Tactic") if best_value > 0
    best_value.to_i
  end

  # #16: Mixed attacker modeling — exploit weaker defensive stat
  def score_mixed_attacker(move, user, target)
    return 0 unless target && move.damagingMove?
    score = 0

    if move.physicalMove? && target.spdef < target.defense * 0.75
      score -= 5  # A special move would hit harder
    elsif move.specialMove? && target.defense < target.spdef * 0.75
      score -= 5  # A physical move would hit harder
    end

    # Psyshock/Psystrike/Secret Sword hit the target's Defense with special attack
    if [:PSYSHOCK, :PSYSTRIKE, :SECRETSWORD].include?(move.id)
      if target.defense < target.spdef
        score += 15  # Exploiting lower Def
        AdvancedAI.log("  Mixed: #{move.name} exploits lower Def (+15)", "Tactic")
      end
    end

    score
  end

  # #17: Transform / Ditto handling
  def score_transform_ditto(move, user, target)
    return 0 unless move.id == :TRANSFORM
    return 0 unless target
    score = 0

    target_bst = (target.attack + target.defense + target.spatk + target.spdef + target.speed) rescue 300
    score += 30 if target_bst >= 500
    score += 15 if target_bst >= 400 && target_bst < 500

    # Copy boosts = huge value
    target_boosts = target.stages.values.sum rescue 0
    if target_boosts >= 3
      score += 40
      AdvancedAI.log("  Transform copies +#{target_boosts} boosts! (+40)", "Tactic")
    elsif target_boosts >= 1
      score += 15
    elsif target_boosts < 0
      score -= 20
    end

    score -= 10 if target.moves.count { |m| m && m.power > 0 } <= 2
    score
  end
end

AdvancedAI.log("Move Scorer loaded", "Scorer")
AdvancedAI.log("  - Moody pressure logic", "Scorer")
AdvancedAI.log("  - Mirror Herb awareness", "Scorer")
AdvancedAI.log("  - Lum Berry timing", "Scorer")

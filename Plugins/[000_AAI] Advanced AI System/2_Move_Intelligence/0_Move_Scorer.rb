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
  # Helper: Get the user's Tera type if they are or will be Terastallized this turn.
  # Returns the Tera type symbol (e.g. :FIRE) or nil if not Tera-active.
  #-----------------------------------------------------------------------------
  def get_tera_type_for_move(user)
    battler = user.respond_to?(:battler) ? user.battler : user
    # Already Terastallized
    if battler.respond_to?(:tera?) && battler.tera?
      return battler.pokemon.tera_type if battler.pokemon.respond_to?(:tera_type) && battler.pokemon.tera_type
    end
    # Registered to Terastallize this turn
    if @battle.respond_to?(:pbRegisteredTerastallize?) && @battle.pbRegisteredTerastallize?(user.index)
      return battler.pokemon.tera_type if battler.pokemon.respond_to?(:tera_type) && battler.pokemon.tera_type
    end
    nil
  end
  
  #-----------------------------------------------------------------------------
  # Base method for AI move registration - provides hook point for all AI extensions
  # This is the foundation method that other AI files will alias to add their logic
  #-----------------------------------------------------------------------------
  def pbRegisterMove(user, move)
    return 0 unless move && user
    # Use pre-resolved target/skill from pbGetMoveScore pipeline if available,
    # otherwise fall back to finding first valid opponent and default skill.
    target = @_resolved_target || @battle.allOtherSideBattlers(user.index).find { |b| b && !b.fainted? }
    return 0 unless target
    skill = @_resolved_skill || 100
    score_move_advanced(move, user, target, skill)
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
                       :SYNTHESIS, :WISH, :SHOREUP, :LIFEDEW, :JUNGLEHEALING, :LUNARBLESSING,
                       :PURIFY, :MILKDRINK, :HEALORDER, :REST, :STRENGTHSAP, :FLORALHEALING]
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
    if user.effects[PBEffects::Torment] && user.lastMoveUsed == move.id
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
    
    # === PHAZING MOVE FAILURE CHECK ===
    # Roar/Whirlwind/Dragon Tail/Circle Throw fail when the opponent has no
    # other Pokemon to switch to (single-mon remaining)
    phazing_moves = [:ROAR, :WHIRLWIND, :DRAGONTAIL, :CIRCLETHROW]
    if phazing_moves.include?(move.id) && target
      target_reserve = @battle.pbAbleNonActiveCount(target.index & 1)
      if target_reserve == 0
        return -1000  # Phazing fails — no reserve Pokemon on target's side
      end
    end
    
    # === ALLY-ONLY SUPPORT MOVES TARGETING CHECK ===
    # Moves like Heal Pulse, After You, Pollen Puff (heal), Life Dew should
    # only be used on allies, never on opponents
    ally_only_moves = [:HEALPULSE, :AFTERYOU, :POLLENPUFF, :AROMATICMIST,
                       :HELPINGHAND, :COACHING, :FLORALHEALING]
    if ally_only_moves.include?(move.id) && target
      same_side = (user.index & 1) == (target.index & 1)
      unless same_side
        return -1000  # Never use ally-support moves on opponents
      end
    end
    
    # Prankster vs Dark type: Status moves fail
    if AdvancedAI::Utilities.prankster_blocked?(user, target, move)
      return -1000  # Prankster status move blocked by Dark type
    end
    
    # === ABILITY IMMUNITY CHECKS ===
    
    # Magic Bounce: Reflects status/hazard moves back — avoid completely
    if target.hasActiveAbility?(:MAGICBOUNCE)
      # Check if user has Mold Breaker to bypass
      unless user.hasActiveAbility?(:MOLDBREAKER) || user.hasActiveAbility?(:TERAVOLT) || user.hasActiveAbility?(:TURBOBLAZE)
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
      unless user.hasActiveAbility?(:MOLDBREAKER) || user.hasActiveAbility?(:TERAVOLT) || user.hasActiveAbility?(:TURBOBLAZE)
        AdvancedAI.log("#{move.name} blocked by Good as Gold on #{target.name}", "Ability")
        return -1000  # Status move completely fails
      end
    end
    
    # === MOVE-SPECIFIC FAILURE CHECKS ===
    
    # Status-inflicting moves: Don't use if target already has a status condition
    # Only pure status moves belong here — damaging moves with side-effect status
    # (Scald, Flare Blitz, Body Slam, etc.) should not be penalized -1000
    status_moves = {
      :THUNDERWAVE => :PARALYSIS,
      :STUNSPORE => :PARALYSIS,
      :GLARE => :PARALYSIS,
      :TOXIC => :POISON,
      :POISONPOWDER => :POISON,
      :POISONGAS => :POISON,
      :TOXICSPIKES => :POISON,  # On grounded targets
      :WILLOWISP => :BURN,
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

      # Electric Terrain blocks sleep (for grounded targets)
      if @battle.field.terrain == :Electric && status_moves[move.id] == :SLEEP
        if !target.airborne? && !target.hasActiveAbility?(:LEVITATE)
          AdvancedAI.log("#{move.name} blocked: #{target.name} protected by Electric Terrain", "StatusSpam")
          return -1000  # Electric Terrain prevents sleep for grounded
        end
      end

      # Ability immunities for sleep (Insomnia, Vital Spirit, Comatose, Sweet Veil)
      if status_moves[move.id] == :SLEEP && !AdvancedAI::Utilities.ignores_ability?(user)
        sleep_immune = [:INSOMNIA, :VITALSPIRIT, :COMATOSE]
        if sleep_immune.any? { |a| target.hasActiveAbility?(a) }
          AdvancedAI.log("#{move.name} blocked: #{target.name} has #{target.ability_id} (sleep immune)", "StatusSpam")
          return -1000  # Sleep move will fail — ability prevents sleep
        end
        if @battle.allSameSideBattlers(target.index).any? { |b|
             b && !b.fainted? && b.hasActiveAbility?(:SWEETVEIL) }
          AdvancedAI.log("#{move.name} blocked: Sweet Veil protects #{target.name}'s side", "StatusSpam")
          return -1000  # Sweet Veil prevents sleep on the entire side
        end
      end

      # Ability immunities for paralysis (Limber, Electric type)
      if status_moves[move.id] == :PARALYSIS
        if target.hasActiveAbility?(:LIMBER) && !AdvancedAI::Utilities.ignores_ability?(user)
          AdvancedAI.log("#{move.name} blocked: #{target.name} has Limber", "StatusSpam")
          return -1000
        end
        if target.pbHasType?(:ELECTRIC)
          AdvancedAI.log("#{move.name} blocked: #{target.name} is Electric type (para immune)", "StatusSpam")
          return -1000
        end
      end

      # Ability immunities for burn (Water Bubble, Water Veil, Thermal Exchange, Fire type)
      if status_moves[move.id] == :BURN
        if target.pbHasType?(:FIRE)
          AdvancedAI.log("#{move.name} blocked: #{target.name} is Fire type (burn immune)", "StatusSpam")
          return -1000
        end
        burn_immune = [:WATERBUBBLE, :WATERVEIL, :THERMALEXCHANGE]
        if burn_immune.any? { |a| target.hasActiveAbility?(a) } && !AdvancedAI::Utilities.ignores_ability?(user)
          AdvancedAI.log("#{move.name} blocked: #{target.name} has #{target.ability_id} (burn immune)", "StatusSpam")
          return -1000
        end
      end

      # Ability immunities for poison (Immunity, Poison/Steel type)
      if status_moves[move.id] == :POISON
        if (target.pbHasType?(:POISON) || target.pbHasType?(:STEEL)) && !user.hasActiveAbility?(:CORROSION)
          AdvancedAI.log("#{move.name} blocked: #{target.name} is Poison/Steel type (poison immune)", "StatusSpam")
          return -1000
        end
        if target.hasActiveAbility?(:IMMUNITY) && !AdvancedAI::Utilities.ignores_ability?(user)
          AdvancedAI.log("#{move.name} blocked: #{target.name} has Immunity", "StatusSpam")
          return -1000
        end
      end

      # Leaf Guard in Sun blocks all status
      if target.hasActiveAbility?(:LEAFGUARD) && !AdvancedAI::Utilities.ignores_ability?(user) &&
         @battle && [:Sun, :HarshSun].include?(@battle.pbWeather)
        AdvancedAI.log("#{move.name} blocked: #{target.name} has Leaf Guard in Sun", "StatusSpam")
        return -1000
      end

      # Powder moves blocked by Grass type, Overcoat, Safety Goggles
      powder_moves = [:SLEEPPOWDER, :SPORE, :STUNSPORE, :POISONPOWDER]
      if powder_moves.include?(move.id)
        if target.pbHasType?(:GRASS)
          AdvancedAI.log("#{move.name} blocked: #{target.name} is Grass type (powder immune)", "StatusSpam")
          return -1000
        end
        if target.hasActiveAbility?(:OVERCOAT) && !AdvancedAI::Utilities.ignores_ability?(user)
          AdvancedAI.log("#{move.name} blocked: #{target.name} has Overcoat (powder immune)", "StatusSpam")
          return -1000
        end
        if target.hasActiveItem?(:SAFETYGOGGLES)
          AdvancedAI.log("#{move.name} blocked: #{target.name} has Safety Goggles (powder immune)", "StatusSpam")
          return -1000
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
    
    # Taunt: Don't use if target is already taunted or has Mental Herb
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
    
    # Mental Herb: Taunt/Encore/Disable will be cured once — reduce value
    if [:TAUNT, :ENCORE, :DISABLE, :TORMENT].include?(move.id)
      if target.hasActiveItem?(:MENTALHERB)
        AdvancedAI.log("#{move.name} reduced value: #{target.name} has Mental Herb", "Item")
        return -50  # Not totally useless (consumes the herb) but far less valuable
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
      unless [:Hail, :Snow].include?(@battle.pbWeather)
        AdvancedAI.log("Aurora Veil blocked: no Hail/Snow weather", "ScreenSpam")
        return -1000  # Aurora Veil fails without Hail or Snow
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
    # Wish is stored in position effects, not battler effects
    if move.id == :WISH
      wish_val = (@battle.positions[user.index].effects[PBEffects::Wish] rescue 0)
      return -1000 if wish_val.is_a?(Numeric) && wish_val > 0
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
      # Resolve effective type (handles -ate abilities, Weather Ball, Terrain Pulse)
      effective_move_type = AdvancedAI::CombatUtilities.resolve_move_type(user, move)
      if move.id == :TERABLAST
        tera_type = get_tera_type_for_move(user)
        effective_move_type = tera_type if tera_type
      end
      absorption_penalty = AdvancedAI::Utilities.score_type_absorption_penalty(user, target, move, effective_move_type)
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
    
    v = score_accuracy(move, skill, user)
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
    
    v = score_prankster_bonus(move, user, target)
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
      topsy_start = base_score
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
      factors["Topsy-Turvy"] = base_score - topsy_start if factors
    end
    
    # === ARMOR CANNON (Gen 9 - Ceruledge) ===
    # 120 BP Fire/Steel, drops user's Def and SpDef by 1 each
    if move.id == :ARMORCANNON
      if user.hasActiveAbility?(:CONTRARY)
        # Contrary inverts: Def/SpDef drops become +1 boosts!
        base_score += 30
      else
        # Penalty for self-stat drops (similar to Close Combat logic)
        if user.hp > user.totalhp * 0.5
          base_score -= 10  # Def/SpDef drops are risky but manageable at high HP
        else
          base_score -= 25  # At low HP, defensive drops are very dangerous
        end
      end
      # But if this KOs the target, the drops don't matter
      rough_damage = calculate_rough_damage(move, user, target)
      if rough_damage >= target.hp
        base_score += 20  # KO negates the drawback
      end
      factors["Armor Cannon"] = -10 if factors
    end
    
    # === CONTRARY: Self-stat-drop moves become boosts ===
    # Overheat, Draco Meteor, Leaf Storm, Psycho Boost, Fleur Cannon (-2 SpAtk → +2 SpAtk)
    # Superpower (-1 Atk/-1 Def → +1 each), Close Combat/Headlong Rush/Dragon Ascent (-1 Def/-1 SpDef → +1 each)
    # V-Create (-1 Def/SpDef/Speed → +1 each), Hammer Arm/Ice Hammer (-1 Speed → +1 Speed)
    # Spin Out (-2 Speed → +2 Speed), Clanging Scales (-1 Def → +1 Def)
    # Hyperspace Fury (-1 Def → +1 Def), Make It Rain (-1 SpAtk → +1 SpAtk)
    if user.hasActiveAbility?(:CONTRARY)
      contrary_boost_moves = [:OVERHEAT, :DRACOMETEOR, :LEAFSTORM, :PSYCHOBOOST,
                              :SUPERPOWER, :CLOSECOMBAT, :VCREATE, :HAMMERARM,
                              :FLEURCANNON, :MAKEITRAIN, :HEADLONGRUSH,
                              :ICEHAMMER, :SPINOUT, :CLANGINGSCALES,
                              :DRAGONASCENT, :HYPERSPACEFURY]
      if contrary_boost_moves.include?(move.id)
        base_score += 50  # Self-stat drops become boosts — massive advantage
      end
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
      
      # Emergency Exit / Wimp Out: bonus for pushing target below 50% HP
      if (target.hasActiveAbility?(:EMERGENCYEXIT) || target.hasActiveAbility?(:WIMPOUT)) && 
         !AdvancedAI::Utilities.ignores_ability?(user) &&
         target.hp > target.totalhp / 2  # Currently above 50%
        if rough_damage >= target.hp - (target.totalhp / 2)
          score += 20  # Will trigger forced switch-out — free momentum
        end
      end
      
      # Berserk: penalty for pushing target below 50% without KOing
      # (gives them +1 SpA — dangerous on special attackers like Drampa)
      if target.hasActiveAbility?(:BERSERK) && !AdvancedAI::Utilities.ignores_ability?(user) &&
         target.hp > target.totalhp / 2  # Currently above 50%
        would_trigger = rough_damage >= target.hp - (target.totalhp / 2)
        would_ko = rough_damage >= target.hp
        if would_trigger && !would_ko
          score -= 20  # Triggering Berserk without KO is bad
          score -= 10 if target.spatk > target.attack  # Even worse on special attackers
        end
      end
    end
    
    # Multi-Target Bonus
    score += 30 if move.pbTarget(user).num_targets > 1 && @battle.pbSideSize(0) > 1
    
    return score
  end
  
  # Type Effectiveness
  def score_type_effectiveness(move, user, target)
    # Resolve effective type (handles -ate abilities, Weather Ball, Terrain Pulse)
    effective_type = AdvancedAI::CombatUtilities.resolve_move_type(user, move)
    
    # Tera Blast: becomes the user's Tera type when Terastallized
    if move.id == :TERABLAST
      tera_type = get_tera_type_for_move(user)
      effective_type = tera_type if tera_type
    end
    
    type_mod = AdvancedAI::CombatUtilities.scrappy_effectiveness(effective_type, user, target.pbTypes(true))
    
    # Freeze-Dry: always SE against Water regardless of type chart
    if move.id == :FREEZEDRY && target.pbHasType?(:WATER)
      # Override: if Water is one of target's types, force at least SE
      type_mod = Effectiveness::SUPER_EFFECTIVE_MULTIPLIER if !Effectiveness.super_effective?(type_mod)
    end
    
    # Wonder Guard: non-SE moves are effectively immune
    if target.hasActiveAbility?(:WONDERGUARD) && !AdvancedAI::Utilities.ignores_ability?(user)
      return Effectiveness.super_effective?(type_mod) ? 40 : -200
    end
    
    if Effectiveness.super_effective?(type_mod)
      return 40
    elsif Effectiveness.not_very_effective?(type_mod)
      # Tinted Lens doubles NVE damage, so NVE penalty is much less relevant
      return user.hasActiveAbility?(:TINTEDLENS) ? -5 : -30
    elsif Effectiveness.ineffective?(type_mod)
      return -200
    end
    
    return 0
  end
  
  # STAB Bonus
  def score_stab_bonus(move, user)
    # Resolve effective type (handles -ate abilities, Weather Ball, Terrain Pulse)
    effective_type = AdvancedAI::CombatUtilities.resolve_move_type(user, move)
    
    # Tera Blast: becomes the user's Tera type when Terastallized
    if move.id == :TERABLAST
      tera_type_override = get_tera_type_for_move(user)
      effective_type = tera_type_override if tera_type_override
    end
    
    # Check if Terastallization is registered — if so, also consider Tera type for STAB
    tera_registered = false
    tera_type = nil
    if @battle.respond_to?(:pbRegisteredTerastallize?) && @battle.pbRegisteredTerastallize?(user.index)
      battler = user.respond_to?(:battler) ? user.battler : user
      if battler.pokemon.respond_to?(:tera_type) && battler.pokemon.tera_type
        tera_registered = true
        tera_type = battler.pokemon.tera_type
      end
    end
    
    # If Tera registered and move matches Tera type, give Tera STAB bonus
    if tera_registered && tera_type
      if effective_type == tera_type
        # Tera STAB: 2x if same as original type, 1.5x otherwise
        return 25 if user.pbHasType?(effective_type)  # Double STAB with Tera
        return 20  # New STAB from Tera type
      elsif user.pbHasType?(effective_type)
        return 15  # Original STAB but no longer boosted by Tera
      end
    else
      return 20 if user.pbHasType?(effective_type)
    end
    
    # Protean / Libero: every move gets STAB
    return 15 if user.hasActiveAbility?(:PROTEAN) || user.hasActiveAbility?(:LIBERO)
    return 0
  end
  
  # Critical Hit Potential
  def score_crit_potential(move, user, target)
    score = 0
    
    # 1. Critical Immunity Check
    # If target has Battle Armor, Shell Armor, or Lucky Chant, crits are impossible/unlikely
    unless AdvancedAI::Utilities.ignores_ability?(user)
      return 0 if target.hasActiveAbility?(:BATTLEARMOR) || target.hasActiveAbility?(:SHELLARMOR)
    end
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
    
    # Sniper: crits deal 2.25x instead of 1.5x — huge crit strategy boost
    if user.hasActiveAbility?(:SNIPER)
      score = (score * 1.5).to_i
    end
    
    # Merciless: auto-crit on poisoned targets
    if user.hasActiveAbility?(:MERCILESS) && (target.poisoned? rescue false)
      score += 40  # Guaranteed crit on every hit
    end
    
    return score
  end
  
  # Status Move Utility
  def score_status_utility(move, user, target, skill, status_multiplier = 1.0)
    score = 0
    
    # Determine opponent side (for hazards)
    opponent_side = target.pbOwnSide
    
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
          score += 40 if move_data&.category == 0  # Physical move
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
          score += 40 if move_data&.category == 1  # Special move
        end
      end
    when "StartWeakenDamageAgainstUserSideIfHail" # Aurora Veil
      if (@battle.pbWeather == :Hail || @battle.pbWeather == :Snow) && user.pbOwnSide.effects[PBEffects::AuroraVeil] == 0
        score += 60
        # Bonus if opponent's last move was Damaging
        if target.lastRegularMoveUsed
          move_data = GameData::Move.try_get(target.lastRegularMoveUsed)
          score += 40 if move_data&.power.to_i > 0  # Damaging move (GameData::Move has no .damaging?)
        end
      end
    end

    # Light Clay bonus: screens last 8 turns instead of 5
    if ["StartWeakenPhysicalDamageAgainstUserSide",
        "StartWeakenSpecialDamageAgainstUserSide",
        "StartWeakenDamageAgainstUserSideIfHail"].include?(move.function_code)
      if user.hasActiveItem?(:LIGHTCLAY)
        score += 25  # Extended screen duration is very valuable
      end
    end

    case move.function_code
      
    # Recovery
    when "HealUserHalfOfTotalHP", "HealUserDependingOnWeather",
         "HealUserHalfOfTotalHPLoseFlyingTypeThisTurn",  # Roost
         "HealUserDependingOnSandstorm",                  # Shore Up
         "CureTargetStatusHealUserHalfOfTotalHP"           # Purify
      hp_percent = user.hp.to_f / user.totalhp
      if hp_percent < 0.3
        score += 150  # Critical urgency
      elsif hp_percent < 0.5
        score += 100  # Strong urgency
      elsif hp_percent < 0.7
        score += 40   # Maintenance
      end
      
      # Boost if faster (heal before getting hit)
      trick_room = (@battle.field.effects[PBEffects::TrickRoom] > 0 rescue false)
      moves_first = trick_room ? (user.pbSpeed < target.pbSpeed) : (user.pbSpeed > target.pbSpeed)
      score += 30 if moves_first
      
      # Shore Up heals 2/3 in sandstorm instead of 1/2
      if move.function_code == "HealUserDependingOnSandstorm"
        weather = @battle.pbWeather rescue nil
        score += 25 if weather == :Sandstorm
      end
      
      # Purify only works if target has a status condition
      if move.function_code == "CureTargetStatusHealUserHalfOfTotalHP"
        if !target || target.status == :NONE
          score -= 200  # Will fail — target needs a status
        else
          # Curing the enemy's status is a COST, not a benefit
          score -= 30  # Penalty for removing opponent's status condition
          score -= 20 if target.burned? && target.attack > target.spatk  # Restoring physical attacker
          score -= 20 if target.poisoned?  # Removing chip damage
        end
      end

    # Strength Sap — heals user by target's Attack, lowers target's Atk by 1
    when "HealUserByTargetAttackLowerTargetAttack1"
      hp_percent = user.hp.to_f / user.totalhp
      target_atk = target.attack
      heal_ratio = target_atk.to_f / user.totalhp

      # Base score from healing urgency
      if hp_percent < 0.3
        score += 130
      elsif hp_percent < 0.5
        score += 90
      elsif hp_percent < 0.7
        score += 40
      end

      # Bonus if target is a physical attacker (Attack drop is very valuable)
      score += 40 if target_atk > target.spatk

      # Extra value when target's Attack heals a large chunk of our HP
      if heal_ratio > 0.5
        score += 30
      elsif heal_ratio > 0.3
        score += 15
      end

      # Boost if faster (heal before getting hit)
      trick_room = (@battle.field.effects[PBEffects::TrickRoom] > 0 rescue false)
      moves_first = trick_room ? (user.pbSpeed < target.pbSpeed) : (user.pbSpeed > target.pbSpeed)
      score += 20 if moves_first

    # Revival Blessing — revives a fainted party member to half HP
    when "RevivePokemonHalfHP"
      party = @battle.pbParty(user.index & 1)
      fainted_count = party.count { |pkmn| pkmn && pkmn.fainted? }
      if fainted_count == 0
        score -= 200  # Will fail — no fainted Pokemon
      else
        score += 70  # Base value for reviving
        score += 15 * (fainted_count - 1)  # More fainted = more valuable
        # Bonus for reviving high-BST Pokemon
        party.each do |pkmn|
          next unless pkmn && pkmn.fainted?
          bst = pkmn.baseStats.values.sum
          if bst > 500
            score += 30
            break
          end
        end
        # More valuable in endgame (few Pokemon remaining alive)
        alive = party.count { |pkmn| pkmn && !pkmn.fainted? }
        score += 25 if alive <= 2
      end

    # Status Infliction
    when "ParalyzeTarget"
      # Type immunity: Electric-types can't be paralyzed
      if target.pbHasType?(:ELECTRIC)
        score -= 200  # Will fail
      # Ground-types are immune to Electric-type moves (Thunder Wave)
      elsif target.pbHasType?(:GROUND) && move.type == :ELECTRIC
        score -= 200  # Will fail
      # Grass-types are immune to powder moves (Stun Spore)
      elsif target.pbHasType?(:GRASS) && [:STUNSPORE].include?(move.id)
        score -= 200  # Powder move blocked
      # Overcoat / Safety Goggles block powder moves
      elsif [:STUNSPORE].include?(move.id) &&
            (target.hasActiveAbility?(:OVERCOAT) || target.hasActiveItem?(:SAFETYGOGGLES))
        score -= 200  # Powder move blocked by Overcoat/Safety Goggles
      # Limber: immune to paralysis
      elsif target.hasActiveAbility?(:LIMBER) && !AdvancedAI::Utilities.ignores_ability?(user)
        score -= 200  # Will fail
      # Leaf Guard in Sun: prevents status
      elsif target.hasActiveAbility?(:LEAFGUARD) && !AdvancedAI::Utilities.ignores_ability?(user) &&
            @battle && [:Sun, :HarshSun].include?(@battle.pbWeather)
        score -= 200  # Will fail
      # Thunder Wave - CRITICAL vs targets that move before us
      elsif target.status == :NONE
        trick_room_active = (@battle.field.effects[PBEffects::TrickRoom] > 0 rescue false)
        target_moves_first = trick_room_active ? (target.pbSpeed < user.pbSpeed) : (target.pbSpeed > user.pbSpeed)
        if target_moves_first
          score += 80  # Massive bonus - cripple threats that outspeed us
          # Extra bonus if we can KO after paralyze
          target_speed_after = target.pbSpeed / 2
          user_moves_first_after = trick_room_active ? (user.pbSpeed < target_speed_after) : (user.pbSpeed > target_speed_after)
          if user_moves_first_after
            score += 30  # Now we outspeed and can KO
          end
        else
          score += 25  # Still useful vs targets we already outspeed
        end
      end
      
    when "BurnTarget"
      # Type immunity: Fire-types can't be burned
      if target.pbHasType?(:FIRE)
        score -= 200  # Will fail
      # Water Bubble: immune to burn
      elsif target.hasActiveAbility?(:WATERBUBBLE) && !AdvancedAI::Utilities.ignores_ability?(user)
        score -= 200  # Will fail
      # Water Veil / Thermal Exchange: immune to burn
      elsif (target.hasActiveAbility?(:WATERVEIL) || target.hasActiveAbility?(:THERMALEXCHANGE)) && !AdvancedAI::Utilities.ignores_ability?(user)
        score -= 200  # Will fail
      # Leaf Guard in Sun: prevents status
      elsif target.hasActiveAbility?(:LEAFGUARD) && !AdvancedAI::Utilities.ignores_ability?(user) &&
            @battle && [:Sun, :HarshSun].include?(@battle.pbWeather)
        score -= 200  # Will fail
      # Will-O-Wisp - CRITICAL vs physical attackers
      elsif target.attack > target.spatk && target.status == :NONE
        score += 100  # Massive bonus - nerf physical attackers
        # Extra bonus if we resist their attacks
        if target.lastRegularMoveUsed
          last_move = GameData::Move.try_get(target.lastRegularMoveUsed)
          if last_move && last_move.category == 0  # Physical move (GameData::Move has no .physical?)
            score += 40  # They're locked into physical damage
          end
        end
      elsif target.status == :NONE
        score += 30  # Still useful for passive damage
      end
      
    when "PoisonTarget"
      # Grass-type + Overcoat + Safety Goggles immunity for PoisonPowder (powder move)
      if move.id == :POISONPOWDER
        if target.pbHasType?(:GRASS)
          score -= 200  # Powder move blocked by Grass type
        elsif target.hasActiveAbility?(:OVERCOAT) || target.hasActiveItem?(:SAFETYGOGGLES)
          score -= 200  # Powder move blocked by Overcoat/Safety Goggles
        end
      end
      # Type immunity: Poison/Steel-types can't be poisoned (Corrosion bypasses)
      if (target.pbHasType?(:POISON) || target.pbHasType?(:STEEL)) && !user.hasActiveAbility?(:CORROSION)
        score -= 200  # Will fail
      # Immunity: immune to poison
      elsif target.hasActiveAbility?(:IMMUNITY) && !AdvancedAI::Utilities.ignores_ability?(user)
        score -= 200  # Will fail
      # Pastel Veil: immune to poison (also protects ally)
      elsif target.hasActiveAbility?(:PASTELVEIL) && !AdvancedAI::Utilities.ignores_ability?(user)
        score -= 200  # Will fail
      elsif @battle && @battle.allSameSideBattlers(target.index).any? { |b| 
            b && !b.fainted? && b.hasActiveAbility?(:PASTELVEIL) } &&
            !AdvancedAI::Utilities.ignores_ability?(user)
        score -= 200  # Will fail — Pastel Veil on their side
      # Leaf Guard in Sun: prevents status
      elsif target.hasActiveAbility?(:LEAFGUARD) && !AdvancedAI::Utilities.ignores_ability?(user) &&
            @battle && [:Sun, :HarshSun].include?(@battle.pbWeather)
        score -= 200  # Will fail
      # Basic Poison - good chip damage
      elsif target.status == :NONE && target.hp > target.totalhp * 0.7
        score += 35
        # Bonus vs bulky targets
        if target.defense + target.spdef > 200
          score += 25  # Walls hate poison
        end
      end
      
    when "BadPoisonTarget"
      # Type immunity: Poison/Steel-types can't be poisoned (Corrosion bypasses)
      if (target.pbHasType?(:POISON) || target.pbHasType?(:STEEL)) && !user.hasActiveAbility?(:CORROSION)
        score -= 200  # Will fail
      # Immunity: immune to poison
      elsif target.hasActiveAbility?(:IMMUNITY) && !AdvancedAI::Utilities.ignores_ability?(user)
        score -= 200  # Will fail
      # Pastel Veil: immune to poison
      elsif target.hasActiveAbility?(:PASTELVEIL) && !AdvancedAI::Utilities.ignores_ability?(user)
        score -= 200  # Will fail
      elsif @battle && @battle.allSameSideBattlers(target.index).any? { |b| 
            b && !b.fainted? && b.hasActiveAbility?(:PASTELVEIL) } &&
            !AdvancedAI::Utilities.ignores_ability?(user)
        score -= 200  # Will fail — Pastel Veil on their side
      # Leaf Guard in Sun: prevents status
      elsif target.hasActiveAbility?(:LEAFGUARD) && !AdvancedAI::Utilities.ignores_ability?(user) &&
            @battle && [:Sun, :HarshSun].include?(@battle.pbWeather)
        score -= 200  # Will fail
      # Toxic - CRITICAL vs walls and stall
      elsif target.status == :NONE
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
        stall_moves = [:PROTECT, :DETECT, :KINGSSHIELD, :SPIKYSHIELD, :BANEFULBUNKER,
                      :OBSTRUCT, :SILKTRAP, :BURNINGBULWARK,
                      :RECOVER, :ROOST, :SOFTBOILED, :SLACKOFF, :WISH, :REST,
                      :MOONLIGHT, :MORNINGSUN, :SYNTHESIS, :SHOREUP, :STRENGTHSAP,
                      :MILKDRINK, :HEALORDER, :LIFEDEW, :JUNGLEHEALING, :LUNARBLESSING]
        user_knows_stall = user.battler.moves.any? { |m| stall_moves.include?(m.id) }
        if user_knows_stall
          score += 40  # Can stall out Toxic damage
        end
      end
      
    when "SleepTarget"
      # Grass-types are immune to powder sleep moves (Sleep Powder, Spore)
      if [:SLEEPPOWDER, :SPORE].include?(move.id) && target.pbHasType?(:GRASS)
        score -= 200  # Powder move blocked by Grass type
      # Overcoat / Safety Goggles block powder moves (Sleep Powder, Spore)
      elsif [:SLEEPPOWDER, :SPORE].include?(move.id) &&
            (target.hasActiveAbility?(:OVERCOAT) || target.hasActiveItem?(:SAFETYGOGGLES))
        score -= 200  # Powder move blocked by Overcoat/Safety Goggles
      # Sleep immunity abilities
      elsif (target.hasActiveAbility?(:INSOMNIA) || target.hasActiveAbility?(:VITALSPIRIT) || target.hasActiveAbility?(:COMATOSE)) && 
            !AdvancedAI::Utilities.ignores_ability?(user)
        score -= 200  # Will fail — ability prevents sleep
      # Sweet Veil: ally's ability prevents sleep on target's side
      elsif @battle && @battle.allSameSideBattlers(target.index).any? { |b| 
            b && !b.fainted? && b.hasActiveAbility?(:SWEETVEIL) } &&
            !AdvancedAI::Utilities.ignores_ability?(user)
        score -= 200  # Will fail — Sweet Veil on their side
      # Leaf Guard in Sun: prevents status
      elsif target.hasActiveAbility?(:LEAFGUARD) && !AdvancedAI::Utilities.ignores_ability?(user) &&
            @battle && [:Sun, :HarshSun].include?(@battle.pbWeather)
        score -= 200  # Will fail — Leaf Guard active in Sun
      # Sleep - CRITICAL control move
      elsif target.status == :NONE
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
      # Stat-drop immunity: Clear Body, White Smoke, Full Metal Body, Clear Amulet, Mirror Armor
      stat_drop_blocked = false
      if !AdvancedAI::Utilities.ignores_ability?(user)
        if (target.hasActiveAbility?(:CLEARBODY) || target.hasActiveAbility?(:WHITESMOKE) || target.hasActiveAbility?(:FULLMETALBODY))
          score -= 200  # Move will completely fail
          stat_drop_blocked = true
        elsif target.hasActiveAbility?(:MIRRORARMOR)
          score -= 200  # Stat drop reflects back onto us!
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
          tr_active = (@battle.field.effects[PBEffects::TrickRoom] > 0 rescue false)
          target_moves_first = tr_active ? (target.pbSpeed < user.pbSpeed) : (target.pbSpeed > user.pbSpeed)
          score += 35 if target_moves_first
        when "LowerTargetDefense1", "LowerTargetDefense2"
          score -= 200 if target.stages[:DEFENSE] <= -6
          score += 25 if target.defense > target.spdef
        when "LowerTargetSpAtk1", "LowerTargetSpAtk2"
          score -= 200 if target.stages[:SPECIAL_ATTACK] <= -6
          score += 30 if target.spatk > target.attack
        when "LowerTargetSpDef1", "LowerTargetSpDef2"
          score -= 200 if target.stages[:SPECIAL_DEFENSE] <= -6
          score += 25 if target.spdef > target.defense
        when "LowerTargetEvasion1", "LowerTargetEvasion2"
          score -= 200 if target.stages[:EVASION] <= -6
          score += 20
        when "LowerTargetAtkDef1"
          score += 35
        end
      end
    end
    
    # Natural Cure: status is cured on switch-out, so status moves are less valuable
    if target.hasActiveAbility?(:NATURALCURE) && !AdvancedAI::Utilities.ignores_ability?(user)
      if ["ParalyzeTarget", "BurnTarget", "PoisonTarget", "BadPoisonTarget", "SleepTarget"].include?(move.function_code)
        score -= 30  # Will be cured when they switch — still useful to force the switch
      end
    end
    
    # Synchronize: passes Burn/Poison/Paralysis back to the attacker
    if target.hasActiveAbility?(:SYNCHRONIZE) && !AdvancedAI::Utilities.ignores_ability?(user)
      case move.function_code
      when "BurnTarget"
        if user.status == :NONE
          score -= 50  # We'll get burned too — very bad for physical attackers
          score -= 20 if user.attack > user.spatk  # Extra penalty for physical users
        end
      when "PoisonTarget", "BadPoisonTarget"
        if user.status == :NONE
          score -= 40  # We'll get poisoned too
          score -= 20 if move.function_code == "BadPoisonTarget"  # Toxic is worse for us
        end
      when "ParalyzeTarget"
        if user.status == :NONE
          score -= 45  # We'll get paralyzed too — speed loss is devastating
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
    if target.hasActiveAbility?(:UNAWARE) && !AdvancedAI::Utilities.ignores_ability?(user)
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
    
    # Simple: stat changes are doubled, so setup is twice as valuable
    simple_mult = 1.0
    if user.hasActiveAbility?(:SIMPLE)
      simple_mult = 2.0
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
        # Weather-conditional boosts (e.g., Growth raises +2 in Sun instead of +1)
        if setup_data[:sun_stages] && @battle &&
           [:Sun, :HarshSun].include?(@battle.pbWeather)
          total_boosts = setup_data[:sun_stages]
        end
        # Belly Drum special handling: costs 50% HP — only use when safe
        if setup_data[:hp_cost]
          hp_threshold = setup_data[:hp_cost]  # e.g., 0.5 for Belly Drum
          if user.hp <= user.totalhp * hp_threshold
            return -100  # Would faint or leave at 1 HP — too dangerous
          end
          # Must have recovery item (Sitrus Berry) or high HP to justify
          has_recovery = [:SITRUSBERRY, :ORANBERRY, :AGUAVBERRY, :FIGYBERRY,
                          :IAPAPABERRY, :MAGOBERRY, :WIKIBERRY].include?(user.item_id)
          if has_recovery
            score += 80  # Belly Drum + Sitrus = devastating combo
          elsif user.hp > user.totalhp * 0.8
            score += 20  # Risky but we have the HP
          else
            score -= 40  # Too risky without recovery item
          end
        end
      elsif move.function_code.start_with?("RaiseUser")
        # Extract boost amount from function code (e.g., "RaiseUserAttack1" -> 1)
        # Use first digit found — last digit can be misleading for conditional codes
        # (e.g., "RaiseUserAtkSpAtk1Or2InSun" → first=1 base, last=2 is sun bonus)
        total_boosts = move.function_code.scan(/\d+/).first.to_i
        total_boosts = 1 if total_boosts == 0
      else
        total_boosts = 1
      end
      
      score += (total_boosts * 40 * status_multiplier * simple_mult).to_i
      
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
    
    # 1. Desperation Logic: User Low HP & Slower (priority helps move first)
    trick_room = (@battle.field.effects[PBEffects::TrickRoom] > 0 rescue false)
    user_is_slower = trick_room ? (user.pbSpeed > target.pbSpeed) : (user.pbSpeed < target.pbSpeed)
    if user.hp <= user.totalhp * 0.33 && user_is_slower
      score += 40 
    end

    # 2. Priority Blockers
    if move.priority > 0
      # Psychic Terrain (blocks priority against grounded targets)
      if @battle.field.terrain == :Psychic && target.affectedByTerrain?
        return -100
      end
      
      # Ability Blockers (Dazzling, Queenly Majesty, Armor Tail)
      # These abilities block priority moves targeting ANY ally on that side
      blocking_abilities = [:DAZZLING, :QUEENLYMAJESTY, :ARMORTAIL]
      unless user.hasMoldBreaker?
        # Check target itself
        if blocking_abilities.any? { |a| target.hasActiveAbility?(a) }
          return -100
        end
        # Check target's allies (these abilities protect the whole side)
        if @battle.pbSideSize(target.index) > 1
          @battle.allSameSideBattlers(target.index).each do |ally|
            next if ally == target || ally.fainted?
            if blocking_abilities.any? { |a| ally.hasActiveAbility?(a) }
              return -100
            end
          end
        end
      end
    end
    
    # Extra Bonus if slower (priority lets us move first when we otherwise wouldn't)
    score += 30 if user_is_slower
    
    # Extra Bonus if KO possible
    if move.damagingMove?
      rough_damage = calculate_rough_damage(move, user, target)
      score += 40 if rough_damage >= target.hp
    end
    
    return score
  end
  
  # Accuracy
  def score_accuracy(move, skill, user = nil)
    # Use raw accuracy to avoid AIMove#accuracy crash (needs battler which might be nil)
    # If move is AIMove (wrapper), get inner move. If regular Move, use it directly.
    accuracy = move.respond_to?(:move) ? move.move.accuracy : move.accuracy
    return 0 if accuracy == 0  # Never-miss moves
    
    # No Guard: all moves always hit — no accuracy penalty
    if user && user.hasActiveAbility?(:NOGUARD)
      # Low-accuracy moves become 100% — actually reward them
      return accuracy < 70 ? 15 : 0
    end
    
    # Compound Eyes: 1.3x accuracy
    if user && user.hasActiveAbility?(:COMPOUNDEYES)
      accuracy = [accuracy * 1.3, 100].min.to_i
    end
    
    # Victory Star: 1.1x accuracy
    if user && user.hasActiveAbility?(:VICTORYSTAR)
      accuracy = [accuracy * 1.1, 100].min.to_i
    end
    
    # Hustle: 0.8x accuracy on physical moves
    if user && user.hasActiveAbility?(:HUSTLE)
      raw_move = move.respond_to?(:move) ? move.move : move
      if raw_move.respond_to?(:physicalMove?) && raw_move.physicalMove?
        accuracy = (accuracy * 0.8).to_i
      end
    end
    
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
    
    # Magic Guard takes no recoil damage
    return 0 if user.hasActiveAbility?(:MAGICGUARD)
    
    # Rock Head negates inherent move recoil (but NOT Life Orb)
    return 0 if user.hasActiveAbility?(:ROCKHEAD)
    
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
    if target.hasActiveAbility?(:SHIELDDUST)
      return 0
    end
    
    # Poison Touch: 30% poison chance on contact moves
    if user.hasActiveAbility?(:POISONTOUCH) && move.contactMove?
      target_types = target.pbTypes(true)
      unless target_types.include?(:POISON) || target_types.include?(:STEEL)
        unless target.hasActiveAbility?(:IMMUNITY) || target.hasActiveAbility?(:PASTELVEIL) ||
               target.hasActiveAbility?(:PURIFYINGSALT) || target.hasActiveAbility?(:COMATOSE)
          score += 10  # 30% poison chance is a nice bonus
          score += 5 if user.hasActiveAbility?(:SERENEGRACE)  # 60% with Serene Grace
        end
      end
    end
    
    # Flinch
    has_innate_flinch = move.flinchingMove?
    # Stench: 10% flinch on all damaging moves that don't already flinch
    has_stench_flinch = !has_innate_flinch && move.damagingMove? && user.hasActiveAbility?(:STENCH)
    # King's Rock / Razor Fang: 10% flinch on non-flinching damaging moves
    has_item_flinch = !has_innate_flinch && move.damagingMove? && [:KINGSROCK, :RAZORFANG].include?(user.item_id)
    if has_innate_flinch || has_stench_flinch || has_item_flinch
      # Inner Focus prevents flinch; Shield Dust blocks secondary effects
      unless target.hasActiveAbility?(:INNERFOCUS) || target.hasActiveAbility?(:SHIELDDUST)
        flinch_bonus = has_innate_flinch ? 20 : 8  # Lower bonus for 10% chance
        # Serene Grace doubles secondary effect chances (30% flinch → 60%)
        flinch_bonus = (flinch_bonus * 1.8).to_i if user.hasActiveAbility?(:SERENEGRACE)
        # Flinch only matters if user moves first — account for Trick Room
        trick_room = @battle && @battle.field.effects[PBEffects::TrickRoom] > 0
        moves_first = trick_room ? (user.pbSpeed < target.pbSpeed) : (user.pbSpeed > target.pbSpeed)
        score += flinch_bonus if moves_first
      end
    end
    
    # Stat Drops on Target (secondary effect on damaging moves only)
    if move.function_code.start_with?("LowerTarget") && move.damagingMove?
      # Clear Amulet / Clear Body / White Smoke / Mirror Armor prevent stat drops
      if AdvancedAI::Utilities.has_clear_amulet?(target)
        score -= 30  # Secondary stat-drop wasted
      elsif !AdvancedAI::Utilities.ignores_ability?(user) &&
            (target.hasActiveAbility?(:CLEARBODY) || target.hasActiveAbility?(:WHITESMOKE) || 
             target.hasActiveAbility?(:FULLMETALBODY) || target.hasActiveAbility?(:MIRRORARMOR))
        score -= 30  # Secondary stat-drop wasted (Mirror Armor reflects it back!)
      else
        stat_drop_bonus = 20
        # Serene Grace doubles secondary effect chances
        stat_drop_bonus = (stat_drop_bonus * 1.5).to_i if user.hasActiveAbility?(:SERENEGRACE)
        score += stat_drop_bonus
      end
    end
    
    # Status Chance
    if ["ParalyzeTarget", "BurnTarget", "PoisonTarget", "SleepTarget", "FreezeTarget"].any? {|code| move.function_code.include?(code)}
      status_bonus = move.addlEffect / 2
      # Serene Grace doubles secondary effect chances (e.g., 30% → 60%)
      status_bonus = (status_bonus * 1.8).to_i if user.hasActiveAbility?(:SERENEGRACE)
      score += status_bonus
    end
    
    # Damaging moves with hazard side effects (Ceaseless Edge, Stone Axe)
    case move.function_code
    when "SplintersTargetGen8AddSpikesGen9"
      # Ceaseless Edge — deals damage AND sets Spikes on opponent's side
      opp_side = target.pbOwnSide
      if opp_side.effects[PBEffects::Spikes] < 3
        score += 30 + (15 * (3 - opp_side.effects[PBEffects::Spikes]))
      end
    when "SplintersTargetGen8AddStealthRocksGen9"
      # Stone Axe — deals damage AND sets Stealth Rock on opponent's side
      opp_side = target.pbOwnSide
      unless opp_side.effects[PBEffects::StealthRock]
        score += 60
        score += 25 if @battle.turnCount <= 1
      end
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
        # Only matters if we care about speed advantage
        tr_active = (@battle.field.effects[PBEffects::TrickRoom] > 0 rescue false)
        user_moves_first = tr_active ? (user.pbSpeed < target.pbSpeed) : (user.pbSpeed >= target.pbSpeed)
        if user_moves_first
          score_penalty += 15  # Could lose speed advantage
        else
          score_penalty += 5   # Already slower (in current context)
        end
      end
      
      # === Defense Boost Abilities ===
      # Stamina (+1 Defense when hit) - makes repeated physical attacks weaker
      if target.hasActiveAbility?(:STAMINA) && move.physicalMove?
        score_penalty += 15  # Each hit makes next hit weaker
        # Extra penalty if we rely on physical attacks
        physical_moves = user.battler.moves.count { |m| m && m.physicalMove? && m.damagingMove? } rescue 0
        score_penalty += 10 if physical_moves >= 3  # Mostly physical = Stamina is devastating
      end
      
      # Weak Armor (-1 Def, +2 Speed when hit by physical) - mixed threat
      if target.hasActiveAbility?(:WEAKARMOR) && move.physicalMove?
        # Speed boost is often worse for us than Def drop is good
        if target.pbSpeed < user.pbSpeed
          score_penalty += 10  # They might outspeed us after the boost
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
        score_penalty += 25 if user.hasActiveAbility?(good_abilities)
      end
      
      # Wandering Spirit (swaps abilities)
      if target.hasActiveAbility?(:WANDERINGSPIRIT)
        score_penalty += 15  # Usually undesirable
      end
      
      # Cute Charm (30% infatuation on contact, opposite gender only)
      if target.hasActiveAbility?(:CUTECHARM) && user.status == :NONE
        if user.gender != 2 && target.gender != 2 && user.gender != target.gender
          score_penalty += 12  # Infatuation = 50% chance of doing nothing each turn
        end
      end
      
      # Cotton Down (-1 Speed to all when hit)
      if target.hasActiveAbility?(:COTTONDOWN)
        tr_active = (@battle.field.effects[PBEffects::TrickRoom] > 0 rescue false)
        user_moves_first = tr_active ? (user.pbSpeed < target.pbSpeed) : (user.pbSpeed >= target.pbSpeed)
        score_penalty += 8 if user_moves_first
      end
      
      # Electromorphosis (gains Charge when hit — doubles next Electric move)
      if target.hasActiveAbility?(:ELECTROMORPHOSIS)
        has_electric = target.moves.any? { |m| m && m.type == :ELECTRIC && m.damagingMove? }
        score_penalty += 15 if has_electric
      end
      
      # Anger Shell (below 50%: +1 Atk/SpAtk/Speed, -1 Def/SpDef)
      if target.hasActiveAbility?(:ANGERSHELL) && target.hp > target.totalhp / 2
        score_penalty += 15  # Could trigger dangerous stat boosts
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
    
    # === AIR BALLOON CHECK ===
    # Air Balloon grants Ground immunity until popped
    if target.respond_to?(:item_id) && target.item_id == :AIRBALLOON
      # Resolve effective type (handles -ate abilities, Weather Ball, Terrain Pulse)
      effective_type = AdvancedAI::CombatUtilities.resolve_move_type(user, move)
      # Tera Blast type override
      if move.id == :TERABLAST
        tera_type = get_tera_type_for_move(user)
        effective_type = tera_type if tera_type
      end
      return 0 if effective_type == :GROUND
    end

    # === WONDER GUARD CHECK ===
    # Wonder Guard: only super-effective moves deal damage
    if target.hasActiveAbility?(:WONDERGUARD) && !AdvancedAI::Utilities.ignores_ability?(user)
      check_type = AdvancedAI::CombatUtilities.resolve_move_type(user, move)
      # Also handle Tera Blast with registration check (get_tera_type_for_move includes pbRegisteredTerastallize?)
      if move.id == :TERABLAST
        tera_type = get_tera_type_for_move(user)
        check_type = tera_type if tera_type
      end
      type_check = AdvancedAI::CombatUtilities.scrappy_effectiveness(check_type, user, target.pbTypes(true))
      return 0 unless Effectiveness.super_effective?(type_check)
    end
    
    # === TYPE-ABSORBING ABILITY IMMUNITY CHECK ===
    # Levitate, Water Absorb, Volt Absorb, Flash Fire, Sap Sipper, Earth Eater, etc.
    # Resolve effective type for -ate abilities, Tera Blast, Weather Ball, Terrain Pulse
    if !AdvancedAI::Utilities.ignores_ability?(user)
      eff_type_check = AdvancedAI::CombatUtilities.resolve_move_type(user, move)
      if move.id == :TERABLAST
        tera_type = get_tera_type_for_move(user)
        eff_type_check = tera_type if tera_type
      end
      immunity = AdvancedAI::Utilities.type_absorbing_immunity?(user, target, eff_type_check)
      return 0 if immunity
    end
    
    # Very Simplified Damage Calculation
    bp = override_bp || move.power
    return 0 if bp == 0
    
    # === HP-BASED VARIABLE POWER MOVES ===
    # Eruption / Water Spout / Dragon Energy - power = 150 * current_hp / max_hp
    if [:ERUPTION, :WATERSPOUT, :DRAGONENERGY].include?(move.id)
      bp = [150 * user.hp / [user.totalhp, 1].max, 1].max
    end
    
    # Flail / Reversal - power increases as HP decreases
    if [:FLAIL, :REVERSAL].include?(move.id)
      n = 48 * user.hp / [user.totalhp, 1].max
      if n < 2
        bp = 200
      elsif n < 5
        bp = 150
      elsif n < 10
        bp = 100
      elsif n < 17
        bp = 80
      elsif n < 33
        bp = 40
      else
        bp = 20
      end
    end
    
    # Crush Grip / Wring Out - power = 120 * target_hp / target_max_hp
    if [:CRUSHGRIP, :WRINGOUT].include?(move.id)
      bp = [120 * target.hp / [target.totalhp, 1].max, 1].max
    end
    
    # === SPEED-BASED VARIABLE POWER MOVES ===
    # Gyro Ball - power = 25 * target_speed / user_speed (cap 150)
    if move.id == :GYROBALL
      user_speed = [user.pbSpeed, 1].max
      target_speed = [target.pbSpeed, 1].max
      bp = [(25 * target_speed / user_speed), 150].min
      bp = [bp, 1].max
    end
    
    # Electro Ball - power based on speed ratio (user_speed / target_speed)
    if move.id == :ELECTROBALL
      user_speed = [user.pbSpeed, 1].max
      target_speed = [target.pbSpeed, 1].max
      ratio = user_speed / target_speed
      if ratio >= 4
        bp = 150
      elsif ratio >= 3
        bp = 120
      elsif ratio >= 2
        bp = 80
      elsif ratio >= 1
        bp = 60
      else
        bp = 40
      end
    end
    
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
      resolved_cc_type = AdvancedAI::CombatUtilities.resolve_move_type(user, move)
      type_check = Effectiveness.calculate(resolved_cc_type, *target.pbTypes(true))
      bp = (bp * 1.33).to_i if Effectiveness.super_effective?(type_check)
    end
    
    # === FUSION MOVES (Gen 5 - Reshiram/Zekrom) ===
    # Fusion Flare: 2x power if Fusion Bolt was used by an ally this turn
    if move.id == :FUSIONFLARE
      if @battle && @battle.pbSideSize(0) > 1
        allies = @battle.allSameSideBattlers(user.index).select { |b| b && b != user && !b.fainted? }
        has_fusion_bolt_user = allies.any? { |ally| ally.moves.any? { |m| m && m.id == :FUSIONBOLT } }
        bp *= 2 if has_fusion_bolt_user
      end
    end
    
    # Fusion Bolt: 2x power if Fusion Flare was used by an ally this turn
    if move.id == :FUSIONBOLT
      if @battle && @battle.pbSideSize(0) > 1
        allies = @battle.allSameSideBattlers(user.index).select { |b| b && b != user && !b.fainted? }
        has_fusion_flare_user = allies.any? { |ally| ally.moves.any? { |m| m && m.id == :FUSIONFLARE } }
        bp *= 2 if has_fusion_flare_user
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
    
    # === RISING VOLTAGE (Gen 8) ===
    # 2x power when TARGET is grounded in Electric Terrain
    if move.id == :RISINGVOLTAGE && @battle
      terrain = @battle.field.terrain rescue nil
      if terrain == :Electric && target.respond_to?(:affectedByTerrain?) && target.affectedByTerrain?
        bp *= 2
      end
    end
    
    # === EXPANDING FORCE (Gen 8) ===
    # 1.5x power when USER is grounded in Psychic Terrain
    if move.id == :EXPANDINGFORCE && @battle
      terrain = @battle.field.terrain rescue nil
      if terrain == :Psychic && user.respond_to?(:affectedByTerrain?) && user.affectedByTerrain?
        bp = (bp * 1.5).to_i
      end
    end
    
    # === MISTY EXPLOSION (Gen 8) ===
    # 1.5x power when USER is grounded in Misty Terrain
    if move.id == :MISTYEXPLOSION && @battle
      terrain = @battle.field.terrain rescue nil
      if terrain == :Misty && user.respond_to?(:affectedByTerrain?) && user.affectedByTerrain?
        bp = (bp * 1.5).to_i
      end
    end
    
    # === SOLAR BEAM / SOLAR BLADE WEATHER PENALTY ===
    # Halved power in non-Sun weather (Rain, Sandstorm, Hail, Snow)
    if [:SOLARBEAM, :SOLARBLADE].include?(move.id) && @battle
      weather = @battle.pbWeather rescue :None
      if [:Rain, :HeavyRain, :Sandstorm, :Hail, :Snow].include?(weather)
        bp = (bp / 2.0).to_i
        bp = [bp, 1].max
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
        # Type changes based on terrain
        case terrain
        when :Electric then effective_type = :ELECTRIC
        when :Grassy   then effective_type = :GRASS
        when :Psychic  then effective_type = :PSYCHIC
        when :Misty    then effective_type = :FAIRY
        end
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
    
    # Venoshock doubles vs poisoned/badly-poisoned target
    if move.id == :VENOSHOCK && (target.status == :POISON || target.status == :TOXIC)
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
    
    # Knock Off extra value vs Harvest (removes berry permanently, shutting down regeneration)
    # Note: This is a scoring bonus handled later, not a BP change
    
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
    
    # Tera Blast - uses higher Attack/SpAtk when Terastallized (becomes physical if Atk > SpAtk)
    if move.id == :TERABLAST && get_tera_type_for_move(user)
      if user.attack > user.spatk
        atk = user.attack
        defense = target.defense
      else
        atk = user.spatk
        defense = target.spdef
      end
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
    if target.hasActiveAbility?(:UNAWARE) && !AdvancedAI::Utilities.ignores_ability?(user)
      # Use base stat instead of boosted stat
      if move.physicalMove?
        atk = user.pokemon.attack rescue user.attack
      else
        atk = user.pokemon.spatk rescue user.spatk
      end
    end
    
    # If user has Unaware, ignore target's defensive stat boosts
    if user.hasActiveAbility?(:UNAWARE)
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
      if user.hasActiveAbility?(:GUTS)
        burn_mod = 1.5
      elsif move.id == :FACADE
        burn_mod = 1.0  # Facade ignores burn penalty (Gen 5+)
      else
        burn_mod = 0.5  # Burn halves physical damage
      end
    end
    
    # Guts boost for other statuses too
    if user.hasActiveAbility?(:GUTS) && user.status != :NONE && user.status != :BURN
      burn_mod = 1.5
    end
    
    # Toxic Boost (1.5x physical when poisoned)
    if user.hasActiveAbility?(:TOXICBOOST) && user.poisoned? && move.physicalMove?
      burn_mod = [burn_mod, 1.5].max  # Don't stack, take the higher
    end
    
    # Flare Boost (1.5x special when burned)
    if user.hasActiveAbility?(:FLAREBOOST) && user.burned? && move.specialMove?
      burn_mod = 1.5  # Override burn penalty for special moves
    end
    
    # === TYPE EFFECTIVENESS ===
    # Pixilate / Refrigerate / Aerilate / Galvanize: Normal moves become typed + 1.2x
    effective_type = move.type
    ate_boost = 1.0
    if move.type == :NORMAL
      ate_map = {
        :PIXILATE => :FAIRY, :REFRIGERATE => :ICE,
        :AERILATE => :FLYING, :GALVANIZE => :ELECTRIC
      }
      ate_ability = ate_map.keys.find { |a| user.hasActiveAbility?(a) }
      if ate_ability
        effective_type = ate_map[ate_ability]
        ate_boost = 1.2
      end
    end
    
    # Weather Ball: changes type and doubles BP in weather
    if move.id == :WEATHERBALL && @battle
      weather = @battle.pbWeather rescue :None
      case weather
      when :Sun, :HarshSun
        effective_type = :FIRE
        bp = 100
      when :Rain, :HeavyRain
        effective_type = :WATER
        bp = 100
      when :Sandstorm
        effective_type = :ROCK
        bp = 100
      when :Hail, :Snow
        effective_type = :ICE
        bp = 100
      end
    end

    # Tera Blast: becomes the user's Tera type when Terastallized
    if move.id == :TERABLAST
      tera_type = get_tera_type_for_move(user)
      effective_type = tera_type if tera_type
    end

    type_mod = AdvancedAI::CombatUtilities.scrappy_effectiveness(effective_type, user, target.pbTypes(true))
    
    # Freeze-Dry: always SE against Water regardless of type chart
    if move.id == :FREEZEDRY && target.pbHasType?(:WATER)
      type_mod = Effectiveness::SUPER_EFFECTIVE_MULTIPLIER if !Effectiveness.super_effective?(type_mod)
    end
    
    stab = user.pbHasType?(effective_type) ? 1.5 : 1.0
    
    # Protean / Libero: every move gets STAB (type changes before attacking)
    if user.hasActiveAbility?(:PROTEAN) || user.hasActiveAbility?(:LIBERO)
      stab = [stab, 1.5].max
    end

    # Adaptability STAB boost
    if user.hasActiveAbility?(:ADAPTABILITY) && user.pbHasType?(effective_type)
      stab = 2.0
    end
    
    # === ABILITY DAMAGE MODIFIERS ===
    ability_mod = 1.0
    
    # Huge Power / Pure Power
    if (user.hasActiveAbility?(:HUGEPOWER) || user.hasActiveAbility?(:PUREPOWER)) && move.physicalMove?
      ability_mod *= 2.0
    end
    
    # Hustle (physical +50%, accuracy penalty applied in score_accuracy)
    if user.hasActiveAbility?(:HUSTLE) && move.physicalMove?
      ability_mod *= 1.5
    end
    
    # Gorilla Tactics (physical +50% but locked)
    if user.hasActiveAbility?(:GORILLATACTICS) && move.physicalMove?
      ability_mod *= 1.5
    end
    
    # Transistor (Electric +50%)
    if user.hasActiveAbility?(:TRANSISTOR) && effective_type == :ELECTRIC
      ability_mod *= 1.5
    end
    
    # Dragons Maw (Dragon +50%)
    if user.hasActiveAbility?(:DRAGONSMAW) && effective_type == :DRAGON
      ability_mod *= 1.5
    end
    
    # === RUIN ABILITY DAMAGE MODIFIERS ===
    # Sword of Ruin (user has it): target's Def is -25%
    if user.hasActiveAbility?(:SWORDOFRUIN) && move.physicalMove?
      ability_mod *= 1.25  # Effectively 25% more physical damage
    end
    # Beads of Ruin (user has it): target's SpDef is -25%
    if user.hasActiveAbility?(:BEADSOFRUIN) && move.specialMove?
      ability_mod *= 1.25  # Effectively 25% more special damage
    end
    # Tablets of Ruin (target has it): our Atk is -25%
    if target.hasActiveAbility?(:TABLETSOFRUIN) && move.physicalMove? && !AdvancedAI::Utilities.ignores_ability?(user)
      ability_mod *= 0.75
    end
    # Vessel of Ruin (target has it): our SpAtk is -25%
    if target.hasActiveAbility?(:VESSELOFRUIN) && move.specialMove? && !AdvancedAI::Utilities.ignores_ability?(user)
      ability_mod *= 0.75
    end
    
    # Ice Scales (target has it): special damage halved
    if target.hasActiveAbility?(:ICESCALES) && move.specialMove? && !AdvancedAI::Utilities.ignores_ability?(user)
      ability_mod *= 0.5
    end

    # Fur Coat (target has it): physical damage halved
    if target.hasActiveAbility?(:FURCOAT) && move.physicalMove? && !AdvancedAI::Utilities.ignores_ability?(user)
      ability_mod *= 0.5
    end

    # Fluffy (target has it): contact halved, Fire doubled
    if target.hasActiveAbility?(:FLUFFY) && !AdvancedAI::Utilities.ignores_ability?(user)
      ability_mod *= 0.5 if move.contactMove?
      ability_mod *= 2.0 if effective_type == :FIRE
    end

    # Filter / Solid Rock / Prism Armor (target has it): SE damage reduced 25%
    if (target.hasActiveAbility?(:FILTER) || target.hasActiveAbility?(:SOLIDROCK) || target.hasActiveAbility?(:PRISMARMOR)) &&
       Effectiveness.super_effective?(type_mod) && !AdvancedAI::Utilities.ignores_ability?(user)
      ability_mod *= 0.75
    end

    # Tinted Lens (user has it): NVE damage doubled
    if user.hasActiveAbility?(:TINTEDLENS) && Effectiveness.not_very_effective?(type_mod)
      ability_mod *= 2.0
    end

    # Sheer Force (user has it): moves with secondary effects get 1.3x
    if user.hasActiveAbility?(:SHEERFORCE) && move.addlEffect.to_i > 0
      ability_mod *= 1.3
    end

    # Tough Claws (user has it): contact moves get 1.3x
    if user.hasActiveAbility?(:TOUGHCLAWS) && move.contactMove?
      ability_mod *= 1.3
    end

    # Strong Jaw (user has it): bite moves get 1.5x
    if user.hasActiveAbility?(:STRONGJAW) && move.respond_to?(:bitingMove?) && move.bitingMove?
      ability_mod *= 1.5
    end

    # Iron Fist (user has it): punching moves get 1.2x
    if user.hasActiveAbility?(:IRONFIST) && move.respond_to?(:punchingMove?) && move.punchingMove?
      ability_mod *= 1.2
    end

    # Technician (user has it): moves with BP ≤ 60 get 1.5x
    # Use resolved bp (not move.baseDamage) so variable-power moves like
    # Gyro Ball / Low Kick aren't wrongly boosted when their effective BP > 60
    if user.hasActiveAbility?(:TECHNICIAN) && bp <= 60 && bp > 0
      ability_mod *= 1.5
    end

    # Water Bubble (user): Water moves 2x; (target): Fire damage halved
    if user.hasActiveAbility?(:WATERBUBBLE) && effective_type == :WATER
      ability_mod *= 2.0
    end
    if target.hasActiveAbility?(:WATERBUBBLE) && effective_type == :FIRE && !AdvancedAI::Utilities.ignores_ability?(user)
      ability_mod *= 0.5
    end

    # Steelworker (user): Steel moves +50%
    if user.hasActiveAbility?(:STEELWORKER) && effective_type == :STEEL
      ability_mod *= 1.5
    end

    # Sand Force (user): Ground/Rock/Steel moves 1.3x in Sandstorm
    if user.hasActiveAbility?(:SANDFORCE) && @battle && @battle.pbWeather == :Sandstorm
      if [:GROUND, :ROCK, :STEEL].include?(effective_type)
        ability_mod *= 1.3
      end
    end

    # Solar Power (user): 1.5x special in Sun
    if user.hasActiveAbility?(:SOLARPOWER) && move.specialMove?
      if @battle && [:Sun, :HarshSun].include?(@battle.pbWeather)
        ability_mod *= 1.5
      end
    end

    # Analytic (user): 1.3x if moving last — account for Trick Room
    if user.hasActiveAbility?(:ANALYTIC)
      trick_room = @battle && @battle.field.effects[PBEffects::TrickRoom] > 0
      moves_last = trick_room ? (user.pbSpeed > target.pbSpeed) : (user.pbSpeed < target.pbSpeed)
      ability_mod *= 1.3 if moves_last
    end

    # Neuroforce (user): SE moves +25%
    if user.hasActiveAbility?(:NEUROFORCE) && Effectiveness.super_effective?(type_mod)
      ability_mod *= 1.25
    end

    # Parental Bond (user): effectively ~1.25x total damage (hits twice)
    if user.hasActiveAbility?(:PARENTALBOND)
      is_multi = move.respond_to?(:multiHitMove?) && move.multiHitMove?
      ability_mod *= 1.25 unless is_multi
    end

    # Mega Launcher (user): Pulse/Aura moves 1.5x
    if user.hasActiveAbility?(:MEGALAUNCHER) && move.respond_to?(:pulseMove?) && move.pulseMove?
      ability_mod *= 1.5
    end

    # Dark Aura / Fairy Aura (field-wide) + Aura Break
    if @battle
      aura_break = @battle.allBattlers.any? { |b| b && !b.fainted? && b.hasActiveAbility?(:AURABREAK) }
      if @battle.allBattlers.any? { |b| b && !b.fainted? && b.hasActiveAbility?(:DARKAURA) }
        if effective_type == :DARK
          ability_mod *= aura_break ? 0.75 : 1.33
        end
      end
      if @battle.allBattlers.any? { |b| b && !b.fainted? && b.hasActiveAbility?(:FAIRYAURA) }
        if effective_type == :FAIRY
          ability_mod *= aura_break ? 0.75 : 1.33
        end
      end
    end

    # Thick Fat (target): Fire/Ice damage halved
    if target.hasActiveAbility?(:THICKFAT) && [:FIRE, :ICE].include?(effective_type) && !AdvancedAI::Utilities.ignores_ability?(user)
      ability_mod *= 0.5
    end

    # Heatproof (target): Fire damage halved
    if target.hasActiveAbility?(:HEATPROOF) && effective_type == :FIRE && !AdvancedAI::Utilities.ignores_ability?(user)
      ability_mod *= 0.5
    end

    # Multiscale / Shadow Shield (target): damage halved at full HP
    if (target.hasActiveAbility?(:MULTISCALE) || target.hasActiveAbility?(:SHADOWSHIELD)) && target.hp == target.totalhp && !AdvancedAI::Utilities.ignores_ability?(user)
      ability_mod *= 0.5
    end

    # Pixilate / Refrigerate / Aerilate / Galvanize boost
    ability_mod *= ate_boost
    
    # Punk Rock (user): sound moves 1.3x; (target): sound damage halved
    if move.respond_to?(:soundMove?) && move.soundMove?
      if user.hasActiveAbility?(:PUNKROCK)
        ability_mod *= 1.3
      end
      if target.hasActiveAbility?(:PUNKROCK) && !AdvancedAI::Utilities.ignores_ability?(user)
        ability_mod *= 0.5
      end
    end

    # Reckless (user): recoil moves 1.2x
    if user.hasActiveAbility?(:RECKLESS) && move.respond_to?(:recoilMove?) && move.recoilMove?
      ability_mod *= 1.2
    end

    # Pinch Abilities: 1.5x at ≤1/3 HP
    if user.hp <= user.totalhp / 3
      pinch_map = {
        :BLAZE => :FIRE, :TORRENT => :WATER, :OVERGROW => :GRASS, :SWARM => :BUG
      }
      pinch_ability = pinch_map.keys.find { |a| user.hasActiveAbility?(a) }
      if pinch_ability && effective_type == pinch_map[pinch_ability]
        ability_mod *= 1.5
      end
    end

    # Supreme Overlord (user): +10% per fainted ally (max +50%)
    if user.hasActiveAbility?(:SUPREMEOVERLORD) && @battle
      fainted_allies = @battle.allSameSideBattlers(user.index).count { |b| b && b.fainted? } rescue 0
      fainted_party = 0
      begin
        party = @battle.pbParty(user.index & 1)
        fainted_party = party.count { |p| p && p.fainted? } rescue 0
      rescue
        fainted_party = 0
      end
      fainted_count = [fainted_party, 5].min
      ability_mod *= (1.0 + fainted_count * 0.1) if fainted_count > 0
    end

    # Stakeout (user): 2x damage vs switching-in target
    # (Hard to detect in AI, but if target just switched in this turn, bonus)
    if user.hasActiveAbility?(:STAKEOUT)
      if target.turnCount == 0  # Just switched in
        ability_mod *= 2.0
      end
    end

    # Orichalcum Pulse (user): 1.33x physical in Sun (also sets Sun)
    if user.hasActiveAbility?(:ORICHALCUMPULSE) && move.physicalMove?
      if @battle && [:Sun, :HarshSun].include?(@battle.pbWeather)
        ability_mod *= 1.33
      end
    end

    # Hadron Engine (user): 1.33x special in Electric Terrain (also sets terrain)
    if user.hasActiveAbility?(:HADRONENGINE) && move.specialMove?
      if @battle && (@battle.field.terrain == :Electric rescue false)
        ability_mod *= 1.33
      end
    end

    # Sharpness (user): 1.5x slicing moves (Sacred Sword, Leaf Blade, etc.)
    if user.hasActiveAbility?(:SHARPNESS) && move.respond_to?(:slicingMove?) && move.slicingMove?
      ability_mod *= 1.5
    end

    # Rocky Payload (user): 1.5x Rock moves (Garganacl, etc.)
    if user.hasActiveAbility?(:ROCKYPAYLOAD) && effective_type == :ROCK
      ability_mod *= 1.5
    end

    # Flash Fire active boost (user): 1.5x Fire when Flash Fire has been triggered
    if user.hasActiveAbility?(:FLASHFIRE) && effective_type == :FIRE
      if defined?(PBEffects::FlashFire) && (user.effects[PBEffects::FlashFire] rescue false)
        ability_mod *= 1.5
      end
    end

    # Charge state (Electromorphosis/Wind Power/Charge move): 2x Electric
    if effective_type == :ELECTRIC
      if defined?(PBEffects::Charge) && (user.effects[PBEffects::Charge].to_i > 0 rescue false)
        ability_mod *= 2.0
      end
    end

    # Dry Skin (target): Fire moves deal 1.25x damage
    if target.hasActiveAbility?(:DRYSKIN) && effective_type == :FIRE && !AdvancedAI::Utilities.ignores_ability?(user)
      ability_mod *= 1.25
    end

    # Purifying Salt (target): Ghost damage halved
    if target.hasActiveAbility?(:PURIFYINGSALT) && effective_type == :GHOST && !AdvancedAI::Utilities.ignores_ability?(user)
      ability_mod *= 0.5
    end

    # Marvel Scale (target): +50% Defense when statused
    if target.hasActiveAbility?(:MARVELSCALE) && target.status != :NONE && 
       move.physicalMove? && !AdvancedAI::Utilities.ignores_ability?(user)
      ability_mod *= 0.67  # Effective 1/1.5 damage reduction
    end
    
    # === WEATHER DAMAGE MODIFIERS ===
    weather_mod = 1.0
    if @battle
      weather = @battle.pbWeather rescue :None
      # Check if target has Utility Umbrella (negates weather effects on moves)
      target_umbrella = target.respond_to?(:item_id) && target.item_id == :UTILITYUMBRELLA
      user_umbrella = user.respond_to?(:item_id) && user.item_id == :UTILITYUMBRELLA
      unless target_umbrella || user_umbrella
        case weather
        when :Sun, :HarshSun
          weather_mod *= 1.5 if effective_type == :FIRE
          weather_mod *= 0.5 if effective_type == :WATER && move.id != :HYDROSTEAM
        when :Rain, :HeavyRain
          weather_mod *= 1.5 if effective_type == :WATER
          weather_mod *= 0.5 if effective_type == :FIRE
        end
      end
    end
    
    # === WEATHER DEFENSE BOOSTS ===
    # Sandstorm: Rock-types get 1.5x SpDef
    if @battle && move.specialMove?
      weather = @battle.pbWeather rescue :None
      if weather == :Sandstorm && target.pbHasType?(:ROCK)
        defense = (defense * 1.5).to_i
      end
    end
    # Snow (Gen 9): Ice-types get 1.5x Def
    if @battle && move.physicalMove?
      weather = @battle.pbWeather rescue :None
      if weather == :Snow && target.pbHasType?(:ICE)
        defense = (defense * 1.5).to_i
      end
    end
    
    # === SCREEN MODIFIERS ===
    screen_mod = 1.0
    if @battle
      target_side = target.pbOwnSide rescue nil
      if target_side
        is_doubles = @battle.pbSideSize(0) > 1 rescue false
        screen_mult = is_doubles ? 0.67 : 0.5  # 2/3 in doubles, 1/2 in singles
        has_aurora = target_side.effects[PBEffects::AuroraVeil] > 0 rescue false
        if has_aurora
          screen_mod *= screen_mult
        else
          if move.physicalMove? && (target_side.effects[PBEffects::Reflect] > 0 rescue false)
            screen_mod *= screen_mult
          elsif move.specialMove? && (target_side.effects[PBEffects::LightScreen] > 0 rescue false)
            screen_mod *= screen_mult
          end
        end
      end
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
    
    # Type-boosting items (use effective_type to account for -ate abilities)
    type_items = {
      :SILKSCARF => :NORMAL, :BLACKBELT => :FIGHTING, :SHARPBEAK => :FLYING,
      :POISONBARB => :POISON, :SOFTSAND => :GROUND, :HARDSTONE => :ROCK,
      :SILVERPOWDER => :BUG, :SPELLTAG => :GHOST, :METALCOAT => :STEEL,
      :CHARCOAL => :FIRE, :MYSTICWATER => :WATER, :MIRACLESEED => :GRASS,
      :MAGNET => :ELECTRIC, :TWISTEDSPOON => :PSYCHIC, :NEVERMELTICE => :ICE,
      :DRAGONFANG => :DRAGON, :BLACKGLASSES => :DARK, :FAIRYFEATHER => :FAIRY
    }
    if type_items.key?(user.item_id) && effective_type == type_items[user.item_id]
      item_mod *= 1.2
    end
    
    # Plates (use effective_type to account for -ate abilities)
    plate_types = {
      :FISTPLATE => :FIGHTING, :SKYPLATE => :FLYING, :TOXICPLATE => :POISON,
      :EARTHPLATE => :GROUND, :STONEPLATE => :ROCK, :INSECTPLATE => :BUG,
      :SPOOKYPLATE => :GHOST, :IRONPLATE => :STEEL, :FLAMEPLATE => :FIRE,
      :SPLASHPLATE => :WATER, :MEADOWPLATE => :GRASS, :ZAPPLATE => :ELECTRIC,
      :MINDPLATE => :PSYCHIC, :ICICLEPLATE => :ICE, :DRACOPLATE => :DRAGON,
      :DREADPLATE => :DARK, :PIXIEPLATE => :FAIRY
    }
    if plate_types.key?(user.item_id) && effective_type == plate_types[user.item_id]
      item_mod *= 1.2
    end
    
    # Muscle Band / Wise Glasses (1.1x category boost)
    if user.item_id == :MUSCLEBAND && move.physicalMove?
      item_mod *= 1.1
    elsif user.item_id == :WISEGLASSES && move.specialMove?
      item_mod *= 1.1
    end
    
    # Species-specific items
    # Thick Club (Cubone/Marowak 2x Atk)
    if user.item_id == :THICKCLUB && move.physicalMove?
      species = (user.species rescue nil)
      if [:CUBONE, :MAROWAK, :MAROWAKALOLA].include?(species)
        item_mod *= 2.0
      end
    end
    # Light Ball (Pikachu 2x Atk & SpAtk)
    if user.item_id == :LIGHTBALL
      species = (user.species rescue nil)
      if [:PIKACHU, :PIKACHUCOSPLAY, :PIKACHUROCKSTAR, :PIKACHUBELLE, 
          :PIKACHUPOPSTAR, :PIKACHUPHD, :PIKACHULIBRE, :PIKACHUORIGINAL,
          :PIKACHUHOENN, :PIKACHUSINNOH, :PIKACHUUNOVA, :PIKACHUKALOS,
          :PIKACHUALOLA, :PIKACHUPARTNER, :PIKACHUWORLD].include?(species)
        item_mod *= 2.0
      end
    end
    # Deep Sea Tooth (Clamperl 2x SpAtk)
    if user.item_id == :DEEPSEATOOTH && move.specialMove?
      species = (user.species rescue nil)
      item_mod *= 2.0 if species == :CLAMPERL
    end
    
    # Legend Orbs (1.2x on matching STAB types)
    if user.item_id == :ADAMANTORB && [:DRAGON, :STEEL].include?(effective_type)
      species = (user.species rescue nil)
      item_mod *= 1.2 if [:DIALGA, :DIALGAORIGIN].include?(species)
    elsif user.item_id == :LUSTROUSORB && [:DRAGON, :WATER].include?(effective_type)
      species = (user.species rescue nil)
      item_mod *= 1.2 if [:PALKIA, :PALKIAORIGIN].include?(species)
    elsif user.item_id == :GRISEOUSORB && [:DRAGON, :GHOST].include?(effective_type)
      species = (user.species rescue nil)
      item_mod *= 1.2 if [:GIRATINA, :GIRATINAORIGIN].include?(species)
    elsif user.item_id == :SOULDEW && [:DRAGON, :PSYCHIC].include?(effective_type)
      species = (user.species rescue nil)
      item_mod *= 1.2 if [:LATIOS, :LATIAS].include?(species)
    end
    
    # === TARGET STATE MODIFIERS ===
    target_mod = 1.0
    
    # Eviolite (target): 1.5x Def & SpDef for NFE Pokemon
    if target.item_id == :EVIOLITE
      # Eviolite check: target must not be fully evolved
      # If we can't determine evolution, skip (safe default)
      species_data = (GameData::Species.get(target.species) rescue nil)
      if species_data
        evos = species_data.get_evolutions rescue []
        if evos && evos.length > 0  # Has evolutions → NFE → Eviolite active
          if move.physicalMove?
            target_mod *= 0.67  # ~1/1.5 = 0.67 (Def boosted)
          elsif move.specialMove?
            target_mod *= 0.67  # SpDef boosted
          end
        end
      end
    end
    
    # Deep Sea Scale (Clamperl 2x SpDef)
    if target.item_id == :DEEPSEASCALE && move.specialMove?
      species = (target.species rescue nil)
      target_mod *= 0.5 if species == :CLAMPERL
    end
    
    # Glaive Rush vulnerability (target takes 2x damage)
    if defined?(PBEffects::GlaiveRush) && target.effects[PBEffects::GlaiveRush] > 0
      target_mod *= 2.0
    end
    
    # Type-resist berries (halve SE damage)
    if AdvancedAI::Utilities.has_resist_berry?(target, effective_type) && 
       Effectiveness.super_effective?(type_mod)
      target_mod *= 0.5
    end
    
    # Assault Vest (1.5x SpDef vs special moves)
    if target.item_id == :ASSAULTVEST && move.specialMove?
      target_mod *= 0.67  # 1/1.5 = 0.67 (SpDef boosted by AV)
    end
    
    # === TERRAIN DAMAGE MODIFIERS ===
    terrain_mod = 1.0
    if @battle
      terrain = @battle.field.terrain rescue nil
      if terrain && user.respond_to?(:affectedByTerrain?) && user.affectedByTerrain?
        case terrain
        when :Electric
          terrain_mod *= 1.3 if effective_type == :ELECTRIC
        when :Grassy
          terrain_mod *= 1.3 if effective_type == :GRASS
        when :Psychic
          terrain_mod *= 1.3 if effective_type == :PSYCHIC
        end
      end
      # Misty Terrain: Dragon moves halved against grounded targets
      if terrain == :Misty && effective_type == :DRAGON
        if target.respond_to?(:affectedByTerrain?) && target.affectedByTerrain?
          terrain_mod *= 0.5
        end
      end
      # Grassy Terrain: Earthquake/Bulldoze/Magnitude halved against grounded targets
      if terrain == :Grassy && [:EARTHQUAKE, :BULLDOZE, :MAGNITUDE].include?(move.id)
        if target.respond_to?(:affectedByTerrain?) && target.affectedByTerrain?
          terrain_mod *= 0.5
        end
      end
    end
    
    # === FINAL CALCULATION ===
    damage = ((2 * user.level / 5.0 + 2) * bp * atk / [defense, 1].max / 50 + 2)
    damage *= type_mod / Effectiveness::NORMAL_EFFECTIVE_MULTIPLIER
    damage *= stab
    damage *= burn_mod
    damage *= ability_mod
    damage *= weather_mod
    damage *= terrain_mod
    damage *= screen_mod
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
    trick_room = (@battle.field.effects[PBEffects::TrickRoom] > 0 rescue false)
    if trick_room
      return false if user.pbSpeed > target.pbSpeed * 1.5  # In TR, faster raw speed = moves last
    else
      return false if target.pbSpeed > user.pbSpeed * 1.5
    end
    
    # Type Matchup Check — opponent has super-effective moves
    target.moves.each do |move|
      next unless move && move.damagingMove?
      resolved_type = AdvancedAI::CombatUtilities.resolve_move_type(target, move)
      type_mod = Effectiveness.calculate(resolved_type, *user.pbTypes(true))
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
    bp = AdvancedAI::CombatUtilities.resolve_move_power(move)
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
            party = @battle.pbParty(user.index & 1)
            able_count = party.count { |p| p && p.able? && p.status == :NONE }
            return bp * [able_count, 1].max
          when "HitTenTimes"  # Population Bomb
            return bp * 7  # Average hits
          else
            return bp * 3  # Default average for 2-5 hit moves
          end
        end
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
    rough_damage = calculate_rough_damage(move, user, target)
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
      # Sucker Punch ALWAYS fails when target uses Protect (a non-attacking move),
      # regardless of Unseen Fist — the failure is because target didn't select
      # an attacking move, NOT because of the Protect barrier.
      score -= 15  # Risk of Protect (Sucker Punch auto-fails vs non-attacks)
    end
    
    # Target just used an attacking move? More likely to attack again
    if target.lastMoveUsed
      last_move_data = GameData::Move.try_get(target.lastMoveUsed)
      if last_move_data && last_move_data.power > 0
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
      
      # Resolve effective type and power via shared helpers
      effective_type = AdvancedAI::CombatUtilities.resolve_move_type(attacker, move)
      power = AdvancedAI::CombatUtilities.resolve_move_power(move)
      next if power == 0
      
      # Simple damage estimate
      atk = move.physicalMove? ? attacker.attack : attacker.spatk
      defense = move.physicalMove? ? defender.defense : defender.spdef
      defense = [defense, 1].max
      
      type_mod = Effectiveness.calculate(effective_type, *defender.pbTypes(true))
      type_mult = type_mod.to_f / Effectiveness::NORMAL_EFFECTIVE_MULTIPLIER
      
      stab = attacker.pbHasType?(effective_type) ? 1.5 : 1.0
      stab = 2.0 if stab == 1.5 && attacker.hasActiveAbility?(:ADAPTABILITY)
      
      # Huge Power / Pure Power (2x Attack for physical moves)
      atk_mod = (move.physicalMove? && (attacker.hasActiveAbility?(:HUGEPOWER) || attacker.hasActiveAbility?(:PUREPOWER))) ? 2 : 1
      
      damage = ((2 * attacker.level / 5.0 + 2) * power * (atk * atk_mod) / defense / 50 + 2)
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
      return -50 if target.hasActiveAbility?(:STICKYHOLD)
      
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
    return 0 unless target && target.hasActiveAbility?(:MOODY)
    
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
      if opp.hasActiveAbility?(:OPPORTUNIST)
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
    if target.hasActiveAbility?(:OWNTEMPO) || target.hasActiveAbility?(:OBLIVIOUS)
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
    passive_recovery =
      (user.hasActiveItem?(:LEFTOVERS) ||
       (user.hasActiveItem?(:BLACKSLUDGE) && user.pbHasType?(:POISON)) ||
       user.effects[PBEffects::Ingrain] ||
       user.effects[PBEffects::AquaRing] ||
       (user.hasActiveAbility?(:POISONHEAL) && user.poisoned?) ||
       ((user.hasActiveAbility?(:DRYSKIN) || user.hasActiveAbility?(:RAINDISH)) &&
         [:Rain, :HeavyRain].include?(@battle.pbWeather)) ||
       (user.hasActiveAbility?(:ICEBODY) && [:Hail, :Snow].include?(@battle.pbWeather)) ||
       (@battle.field.terrain == :Grassy && user.battler.affectedByTerrain?))
                       
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
    # Wish is stored in position effects, not battler effects
    wish_turns = (@battle.positions[user.index].effects[PBEffects::Wish] rescue 0)
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
  def score_prankster_bonus(move, user, target = nil)
    return 0 unless user.hasActiveAbility?(:PRANKSTER)
    return 0 unless move.statusMove?
    
    # Prankster status moves fail against Dark-type targets
    if target
      target_types = target.pbTypes(true) rescue (target.respond_to?(:types) ? target.types : [:NORMAL])
      return 0 if target_types.include?(:DARK)
    end
    
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
        # === TYPE IMMUNITY CHECKS ===
        # Fire-types can't be burned
        if move.id == :WILLOWISP && target.pbHasType?(:FIRE)
          return PriorityMoveResult.new  # Will fail — no boost
        end
        # Electric-types can't be paralyzed; Ground-types are immune to T-Wave
        if move.id == :THUNDERWAVE
          if target.pbHasType?(:ELECTRIC) || target.pbHasType?(:GROUND)
            return PriorityMoveResult.new  # Will fail — no boost
          end
        end
        # Poison/Steel-types can't be poisoned
        if move.id == :TOXIC
          if target.pbHasType?(:POISON) || target.pbHasType?(:STEEL)
            return PriorityMoveResult.new  # Will fail — no boost
          end
        end
        # Grass-types are immune to powder moves
        if [:SLEEPPOWDER, :SPORE].include?(move.id) && target.pbHasType?(:GRASS)
          return PriorityMoveResult.new  # Will fail — no boost
        end
        
        # Thunder Wave - cripple threats that move before us
        if move.id == :THUNDERWAVE
          tr_active = (@battle.field.effects[PBEffects::TrickRoom] > 0 rescue false)
          target_moves_first = tr_active ? (target.pbSpeed < user.pbSpeed) : (target.pbSpeed > user.pbSpeed)
          if target_moves_first
            return PriorityMoveResult.new(priority_boost: 180)
          end
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
    
    # Resolve effective move type once (handles -ate abilities + Tera Blast)
    resolved_type = AdvancedAI::CombatUtilities.resolve_move_type(user, move)
    
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
        type_mod = Effectiveness.calculate(resolved_type, *target.pbTypes(true))
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
        if target.status == :NONE
          # Don't boost status moves the target is immune to
          immune = false
          immune = true if move_id == :TOXIC && (target.pbHasType?(:POISON) || target.pbHasType?(:STEEL))
          immune = true if move_id == :WILLOWISP && target.pbHasType?(:FIRE)
          immune = true if move_id == :THUNDERWAVE && (target.pbHasType?(:ELECTRIC) || target.pbHasType?(:GROUND))
          score += 15 unless immune
        end
      end
      
      # Phazing racks up hazard damage
      if [:WHIRLWIND, :ROAR, :DRAGONTAIL, :CIRCLETHROW].include?(move_id)
        score += 15
      end
      
      # Walls don't benefit much from setup (except Iron Defense / Calm Mind on some)
      if AdvancedAI.setup_move?(move_id)
        setup_data = AdvancedAI::MoveCategories.get_setup_data(move_id)
        unless setup_data && [:defense, :defense_spdef, :spdef, :spatk_spdef].include?(setup_data[:stat])
          score -= 10  # Offensive setup is suboptimal for walls
        end
      end
    end
    
    # === TANK: Bulky Offense — reliable STAB + Recovery ===
    if primary_role == :tank || secondary_role == :tank
      # Tanks want strong reliable STAB moves
      if move.damagingMove? && user.pbHasType?(resolved_type)
        score += 10  # STAB reliability matters for tanks
        score += 10 if AdvancedAI::CombatUtilities.resolve_move_power(move) >= 80  # Prefer solid power
      end
      
      # Tanks also value recovery (they have the bulk to use it)
      if AdvancedAI.healing_move?(move_id)
        score += 15
        hp_percent = user.hp.to_f / user.totalhp
        score += 10 if hp_percent < 0.55
      end
      
      # Coverage for tanks
      if move.damagingMove?
        type_mod = Effectiveness.calculate(resolved_type, *target.pbTypes(true))
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
      if move.damagingMove? && AdvancedAI::CombatUtilities.resolve_move_power(move) < 70
        score -= 10  # Weak attacks are not the support's focus
      end
    end
    
    # === WALLBREAKER: Raw Power + Coverage ===
    if primary_role == :wallbreaker || secondary_role == :wallbreaker
      if move.damagingMove?
        # Wallbreakers want maximum damage output
        eff_power = AdvancedAI::CombatUtilities.resolve_move_power(move)
        score += 15 if eff_power >= 100
        score += 10 if eff_power >= 80 && eff_power < 100
        
        # Coverage is king for wallbreakers
        type_mod = Effectiveness.calculate(resolved_type, *target.pbTypes(true))
        score += 15 if Effectiveness.super_effective?(type_mod)
        
        # STAB bonus stacks
        score += 10 if user.pbHasType?(resolved_type)
        
        # Mixed coverage: wallbreakers should pick the move that hits harder
        if move.physicalMove? && user.attack > user.spatk
          score += 5  # Using better offensive stat
        elsif move.specialMove? && user.spatk > user.attack
          score += 5
        end
      end
      
      # Wallbreakers mostly ignore utility
      if move.statusMove? && ![:SWORDSDANCE, :NASTYPLOT].include?(move_id)
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
          resolved_t_type = AdvancedAI::CombatUtilities.resolve_move_type(target, t_move)
          type_mod = Effectiveness.calculate(resolved_t_type, *user.pbTypes(true))
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
          resolved_t_type = AdvancedAI::CombatUtilities.resolve_move_type(target, t_move)
          type_mod = Effectiveness.calculate(resolved_t_type, *user.pbTypes(true))
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
      # But only if the target can actually be affected
      if [:TOXIC, :WILLOWISP, :THUNDERWAVE].include?(move.id)
        # Check type immunity before boosting status moves
        if move.id == :TOXIC && (target.pbHasType?(:POISON) || target.pbHasType?(:STEEL))
          return 0  # Poison/Steel immune to Toxic — no stall synergy
        elsif move.id == :WILLOWISP && target.pbHasType?(:FIRE)
          return 0  # Fire immune to burn — no stall synergy
        elsif move.id == :THUNDERWAVE && target.pbHasType?(:ELECTRIC)
          return 0  # Electric immune to paralysis — no stall synergy
        elsif move.id == :THUNDERWAVE && target.pbHasType?(:GROUND)
          return 0  # Ground immune to Thunder Wave — no stall synergy
        end
      end
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
        # Wish is stored in position effects, not battler effects
        wish_turns = (@battle.positions[user.index].effects[PBEffects::Wish] rescue 0)
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
    :MEANLOOK, :BLOCK, :SPIDERWEB, :SPIRITSHACKLE, :ANCHORSHOT, :JAWLOCK,
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
      target_types = target.respond_to?(:pbTypes) ? target.pbTypes(true) : target.types rescue [:NORMAL]
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
      choice_resolved_type = AdvancedAI::CombatUtilities.resolve_move_type(user, move)
      @battle.allOtherSideBattlers(user.index).each do |opp|
        next if !opp || opp.fainted?
        opp_types = opp.respond_to?(:pbTypes) ? opp.pbTypes(true) : opp.types rescue [:NORMAL]
        eff = Effectiveness.calculate(choice_resolved_type, *opp_types) rescue Effectiveness::NORMAL_EFFECTIVE_MULTIPLIER
        neutral_or_better += 1 if eff >= Effectiveness::NORMAL_EFFECTIVE_MULTIPLIER
      end
      score += 15 if neutral_or_better >= 2
    end

    # Status on Choice = locked into uselessness
    if move.statusMove? && !AdvancedAI.pivot_move?(move.id)
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

    party = @battle.pbParty(user.index & 1)
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
    trick_room = (@battle.field.effects[PBEffects::TrickRoom] > 0 rescue false)
    # In Trick Room, slower Pokemon move first — flip speed comparison
    user_moves_last = trick_room ? (user_spd < target_spd) : (user_spd > target_spd)

    if user_hp_pct <= 0.25
      score += 60  # About to die — take them with us
      score += 20 if user_moves_last   # Moves last = they attack into DB
      score -= 10 unless user_moves_last  # Moves first = DB fades before they move
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

    user_types = user.respond_to?(:pbTypes) ? user.pbTypes(true) : user.types rescue [:NORMAL]
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
        if move.id == :COUNTER && pred_data.category == 0  # Physical
          score += 50
          AdvancedAI.log("  Counter vs predicted physical: +50", "Tactic")
        elsif move.id == :MIRRORCOAT && pred_data.category == 1  # Special
          score += 50
          AdvancedAI.log("  Mirror Coat vs predicted special: +50", "Tactic")
        elsif move.id == :METALBURST && pred_data.power > 0
          score += 35  # Metal Burst reflects both
        elsif move.id == :COUNTER && pred_data.category != 0  # Not physical
          score -= 40  # Wrong type
        elsif move.id == :MIRRORCOAT && pred_data.category != 1  # Not special
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

    resolved_power = AdvancedAI::CombatUtilities.resolve_move_power(last_data)
    if resolved_power >= 100
      score += 40  # Disabling a nuke
    elsif resolved_power >= 70
      score += 25
    elsif AdvancedAI.setup_move?(last_used)
      score += 35
    elsif AdvancedAI.healing_move?(last_used)
      score += 30
    elsif last_data.power == 0  # Status move (GameData::Move has no .statusMove?)
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
    party = @battle.pbParty(user.index & 1)
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

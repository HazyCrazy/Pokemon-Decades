#===============================================================================
# Advanced AI System - Disruption Move Intelligence
# Handles Taunt, Encore, Knock Off, Trick, and other disruption strategies
#===============================================================================

class Battle::AI
  # ============================================================================
  # TAUNT STRATEGY
  # ============================================================================
  
  alias disruption_pbRegisterMove pbRegisterMove
  def pbRegisterMove(user, move)
    score = disruption_pbRegisterMove(user, move)
    
    return score unless user && move
    
    targets = @battle.allOtherSideBattlers(user.index)
    viable_targets = targets.select { |t| t && !t.fainted? }
    
    # Single-target disruption: use best (max) target score, not sum
    if move.id == :TAUNT
      best = viable_targets.map { |t| evaluate_taunt_value(user, t) }.max || 0
      score += best
    end
    
    if move.id == :ENCORE
      best = viable_targets.map { |t| evaluate_encore_value(user, t) }.max || 0
      score += best
    end
    
    if move.id == :KNOCKOFF
      best = viable_targets.map { |t| evaluate_knockoff_value(user, t) }.max || 0
      score += best
    end
    
    if [:TRICK, :SWITCHEROO].include?(move.id)
      best = viable_targets.map { |t| evaluate_trick_value(user, t) }.max || 0
      score += best
    end
    
    return score
  end
  
  # ============================================================================
  # TAUNT EVALUATION
  # ============================================================================
  
  def evaluate_taunt_value(user, target)
    score = 0
    
    # Don't use if target already taunted
    if target.effects[PBEffects::Taunt] > 0
      AdvancedAI.log("  Taunt blocked: Already taunted", "Disruption")
      return -90
    end
    
    # Count status/support moves on target
    status_moves = target.moves.count { |m| m && m.statusMove? }
    
    if status_moves == 0
      score -= 50  # Useless
      AdvancedAI.log("  Taunt: -50 (no status moves)", "Disruption")
      return score
    end
    
    # HIGH VALUE: Setup sweepers
    setup_moves = [:SWORDSDANCE, :NASTYPLOT, :DRAGONDANCE, :QUIVERDANCE, :CALMMIND,
                   :SHELLSMASH, :COIL, :BULKUP, :AGILITY, :ROCKPOLISH,
                   :VICTORYDANCE, :FILLETAWAY, :TIDYUP, :SHIFTGEAR, :NORETREAT,
                   :CLANGOROUSSOUL, :GEOMANCY]
    has_setup = target.moves.any? { |m| m && setup_moves.include?(m.id) }
    
    if has_setup
      score += 60
      AdvancedAI.log("  Taunt vs setup: +60 (blocks sweep)", "Disruption")
      
      # URGENT if they're setting up right now
      if target.stages.values.any? { |stage| stage > 0 }
        score += 40
        AdvancedAI.log("  Already boosted: +40 (stop snowball)", "Disruption")
      end
    end
    
    # HIGH VALUE: Walls (recovery/support)
    recovery_moves = [:RECOVER, :ROOST, :SOFTBOILED, :WISH, :REST, :SLACKOFF, 
                     :MOONLIGHT, :SYNTHESIS, :MORNINGSUN, :SHOREUP, :STRENGTHSAP,
                     :LIFEDEW, :MILKDRINK, :HEALORDER, :JUNGLEHEALING, :LUNARBLESSING]
    has_recovery = target.moves.any? { |m| m && recovery_moves.include?(m.id) }
    
    if has_recovery
      score += 45
      AdvancedAI.log("  Taunt vs wall: +45 (blocks recovery)", "Disruption")
    end
    
    # MEDIUM VALUE: Entry hazard users
    hazard_moves = [:STEALTHROCK, :SPIKES, :TOXICSPIKES, :STICKYWEB]
    has_hazards = target.moves.any? { |m| m && hazard_moves.include?(m.id) }
    
    if has_hazards
      score += 35
      AdvancedAI.log("  Taunt vs hazard setter: +35", "Disruption")
    end
    
    # MEDIUM VALUE: Substitute users
    if target.moves.any? { |m| m && m.id == :SUBSTITUTE }
      score += 30
      AdvancedAI.log("  Taunt vs Substitute: +30", "Disruption")
    end
    
    # LOW VALUE: Status spammers (Thunder Wave, Will-O-Wisp)
    status_inflict = [:THUNDERWAVE, :WILLOWISP, :TOXIC, :SLEEPPOWDER, :SPORE]
    has_status = target.moves.any? { |m| m && status_inflict.include?(m.id) }
    
    if has_status
      score += 20
      AdvancedAI.log("  Taunt vs status: +20", "Disruption")
    end
    
    # BONUS: If we move before target (can prevent their next move)
    tr_active = (@battle.field.effects[PBEffects::TrickRoom] > 0 rescue false)
    user_moves_first = tr_active ? (user.pbSpeed < target.pbSpeed * 1.3) : (user.pbSpeed > target.pbSpeed * 1.3)
    if user_moves_first
      score += 15
      AdvancedAI.log("  Outspeeds: +15 (locks them in)", "Disruption")
    end
    
    return score
  end
  
  # ============================================================================
  # ENCORE EVALUATION
  # ============================================================================
  
  def evaluate_encore_value(user, target)
    score = 0
    
    # Don't use if target already Encored
    if target.effects[PBEffects::Encore] > 0
      AdvancedAI.log("  Encore blocked: Already encored", "Disruption")
      return -90
    end
    
    # Can only Encore if target just used a move
    last_move = target.lastMoveUsed
    return -80 unless last_move  # No move used yet
    
    # Get the move they just used
    last_move_data = GameData::Move.try_get(last_move)
    return -80 unless last_move_data
    
    # HIGH VALUE: Lock into setup moves — but only if opponent is near max boosts
    # Encoring an opponent at low boost stages lets them reach +6 and sweep!
    setup_moves = [:SWORDSDANCE, :NASTYPLOT, :DRAGONDANCE, :SHELLSMASH, :CALMMIND,
                   :QUIVERDANCE, :BULKUP, :AGILITY, :ROCKPOLISH, :COIL,
                   :VICTORYDANCE, :FILLETAWAY, :TIDYUP, :SHIFTGEAR, :NORETREAT,
                   :CLANGOROUSSOUL, :GEOMANCY]
    if setup_moves.include?(last_move)
      # Check opponent's current boost stages to decide if Encore is actually good
      opp_atk_stage  = (target.stages[:ATTACK] || 0)
      opp_spatk_stage = (target.stages[:SPECIAL_ATTACK] || 0)
      opp_max_off_stage = [opp_atk_stage, opp_spatk_stage].max
      
      if opp_max_off_stage >= 5
        # Near max boosts — Encore truly wastes turns
        score += 80
        AdvancedAI.log("  Encore setup move at max boosts: +80 (waste turns)", "Disruption")
      elsif opp_max_off_stage >= 3
        # Already dangerous — Encore is risky, small bonus only if we can phaze
        if user.moves.any? { |m| m && [:ROAR, :WHIRLWIND, :DRAGONTAIL, :CIRCLETHROW, :HAZE].include?(m.id) }
          score += 50
          AdvancedAI.log("  Encore setup at +#{opp_max_off_stage} with phaze: +50", "Disruption")
        else
          score -= 20
          AdvancedAI.log("  Encore setup at +#{opp_max_off_stage} no phaze: -20 (lets them max out!)", "Disruption")
        end
      else
        # Low boosts (+0 to +2) — Encore lets them boost to dangerous levels!
        score -= 40
        AdvancedAI.log("  Encore setup at +#{opp_max_off_stage}: -40 (lets them sweep!)", "Disruption")
      end
      
      # Counter-setup bonus only if opponent is near max (won't benefit from more boosts)
      if opp_max_off_stage >= 5 && user.moves.any? { |m| m && setup_moves.include?(m.id) }
        score += 30
        AdvancedAI.log("  Can counter-setup while they're capped: +30", "Disruption")
      end
    # HIGH VALUE: Lock into non-damaging moves (only if not already counted as setup)
    elsif last_move_data.power == 0  # status move (GameData::Move has no .statusMove?)
      score += 50
      AdvancedAI.log("  Encore status move: +50 (free turns)", "Disruption")
    end
    
    # MEDIUM VALUE: Lock into resisted moves
    # Resolve type for -ate abilities (target is the one who used the move)
    encore_resolved_type = AdvancedAI::CombatUtilities.resolve_move_type(target, last_move_data)
    if last_move_data.power > 0  # damaging move (GameData::Move has no .damagingMove?)
      type_mod = Effectiveness.calculate(encore_resolved_type, *user.pbTypes(true))
      if Effectiveness.not_very_effective?(type_mod)
        score += 40
        AdvancedAI.log("  Encore resisted move: +40", "Disruption")
      elsif Effectiveness.ineffective?(type_mod)
        score += 70
        AdvancedAI.log("  Encore immune move: +70 (free turns!)", "Disruption")
      end
    end
    
    # LOW VALUE: Lock into weak moves (Splash, etc.)
    weak_moves = [:SPLASH, :CELEBRATE, :TELEPORT]
    if weak_moves.include?(last_move)
      score += 90
      AdvancedAI.log("  Encore useless move: +90 (jackpot!)", "Disruption")
    end
    
    # PENALTY: Don't Encore strong super-effective moves
    if last_move_data.power > 0  # damaging move — use .power > 0 (GameData::Move has no .damagingMove?)
      type_mod = Effectiveness.calculate(encore_resolved_type, *user.pbTypes(true))
      if Effectiveness.super_effective?(type_mod)
        score -= 40
        AdvancedAI.log("  Encore SE move: -40 (bad idea)", "Disruption")
      end
    end
    
    return score
  end
  
  # ============================================================================
  # KNOCK OFF EVALUATION
  # ============================================================================
  
  def evaluate_knockoff_value(user, target)
    score = 0
    
    # No item = no bonus (but still decent damage)
    unless target.item
      AdvancedAI.log("  Knock Off: No item (still 65 BP)", "Disruption")
      return 0  # Base damage is fine
    end
    
    item_id = target.item_id
    
    # Check if item is unlosable (Mega Stones, Z-Crystals, etc.)
    # Knock Off CANNOT remove unlosable items!
    item_data = GameData::Item.get(item_id)
    if item_data.unlosable?(target.species, target.ability)
      AdvancedAI.log("  Knock Off: Item is unlosable (damage boost only)", "Disruption")
      return 20  # 1.5x damage boost still applies
    end
    
    # Sticky Hold prevents item removal (but 1.5x damage still applies)
    if target.hasActiveAbility?(:STICKYHOLD)
      AdvancedAI.log("  Knock Off: Sticky Hold (damage boost only)", "Disruption")
      return 20  # 1.5x damage boost still applies
    end
    
    # CRITICAL VALUE: Remove mega stones (prevents Mega Evolution)
    # NOTE: This should never trigger since Mega Stones are unlosable,
    # but keeping for compatibility with custom implementations
    #if item_data.is_mega_stone?
      #score += 100
      #AdvancedAI.log("  Knock Off Mega Stone: +100 (prevents Mega!)", "Disruption")
    #end
    
    # VERY HIGH VALUE: Choiced items (unlocks them)
    choice_items = [:CHOICEBAND, :CHOICESCARF, :CHOICESPECS]
    if choice_items.include?(item_id)
      score += 70
      AdvancedAI.log("  Knock Off Choice item: +70 (unlocks moves)", "Disruption")
    end
    
    # HIGH VALUE: Defensive items
    defensive_items = [:LEFTOVERS, :ASSAULTVEST, :ROCKYHELMET, :EVIOLITE, :HEAVYDUTYBOOTS]
    if defensive_items.include?(item_id)
      score += 50
      AdvancedAI.log("  Knock Off defensive item: +50", "Disruption")
      
      # Eviolite on NFE Pokemon is CRITICAL
      if item_id == :EVIOLITE
        score += 30
        AdvancedAI.log("  Eviolite removal: +30 (cuts bulk)", "Disruption")
      end
      
      # Heavy-Duty Boots if hazards are up
      if item_id == :HEAVYDUTYBOOTS
        target_side = target.pbOwnSide
        if target_side.effects[PBEffects::StealthRock] || target_side.effects[PBEffects::Spikes] > 0
          score += 40
          AdvancedAI.log("  Boots removal (hazards up): +40", "Disruption")
        end
      end
    end
    
    # HIGH VALUE: Offensive items
    offensive_items = [:LIFEORB, :EXPERTBELT, :WISEGLASSES, :MUSCLEBAND]
    if offensive_items.include?(item_id)
      score += 45
      AdvancedAI.log("  Knock Off offensive item: +45", "Disruption")
    end
    
    # MEDIUM VALUE: Focus Sash (removes survival)
    if item_id == :FOCUSSASH && target.hp == target.totalhp
      score += 60
      AdvancedAI.log("  Knock Off Focus Sash: +60 (removes survival)", "Disruption")
    end
    
    # MEDIUM VALUE: Weakness Policy
    if item_id == :WEAKNESSPOLICY
      score += 35
      AdvancedAI.log("  Knock Off Weakness Policy: +35", "Disruption")
    end
    
    # LOW VALUE: Berries
    if GameData::Item.get(item_id).is_berry?
      score += 25
      AdvancedAI.log("  Knock Off Berry: +25", "Disruption")
    end
    
    # BONUS: 1.5x damage multiplier when target has item
    score += 20  # Damage boost
    AdvancedAI.log("  Knock Off damage boost: +20 (97.5 BP)", "Disruption")
    
    return score
  end
  
  # ============================================================================
  # TRICK/SWITCHEROO EVALUATION
  # ============================================================================
  
  def evaluate_trick_value(user, target)
    score = 0
    user_item = user.item_id
    target_item = target.item_id
    
    # Can't Trick if the USER has no item to give
    # (Target having no item is fine — we give ours away without receiving one)
    return -80 unless user_item
    
    # Sticky Hold blocks Trick/Switcheroo entirely
    if target.hasActiveAbility?(:STICKYHOLD)
      AdvancedAI.log("  Trick blocked: Sticky Hold", "Disruption")
      return -90
    end
    
    # BEST CASE: Give Choice item to status-move user
    choice_items = [:CHOICEBAND, :CHOICESCARF, :CHOICESPECS]
    if choice_items.include?(user_item)
      # Count status moves on target
      status_moves = target.moves.count { |m| m && m.statusMove? }
      
      if status_moves >= 2
        score += 80
        AdvancedAI.log("  Trick Choice item: +80 (cripples support)", "Disruption")
      elsif status_moves >= 1
        score += 50
        AdvancedAI.log("  Trick Choice item: +50", "Disruption")
      end
      
      # BONUS: Lock walls into defensive moves
      recovery_moves = [:RECOVER, :ROOST, :SOFTBOILED, :WISH, :REST, :SLACKOFF,
                       :MOONLIGHT, :SYNTHESIS, :MORNINGSUN, :SHOREUP, :STRENGTHSAP,
                       :LIFEDEW, :MILKDRINK, :HEALORDER, :JUNGLEHEALING, :LUNARBLESSING]
      if target.moves.any? { |m| m && recovery_moves.include?(m.id) }
        score += 40
        AdvancedAI.log("  Trick vs wall: +40 (limits options)", "Disruption")
      end
    end
    
    # GOOD CASE: Give Lagging Tail / Iron Ball (speed reduction)
    if [:LAGGINGTAIL, :IRONBALL].include?(user_item)
      score += 60
      AdvancedAI.log("  Trick speed item: +60 (cripples speed)", "Disruption")
    end
    
    # GOOD CASE: Steal valuable items
    if target_item
      valuable_items = [:LEFTOVERS, :LIFEORB, :CHOICEBAND, :CHOICESCARF, :CHOICESPECS,
                       :ASSAULTVEST, :FOCUSSASH, :WEAKNESSPOLICY]
      if valuable_items.include?(target_item)
        score += 50
        AdvancedAI.log("  Trick steal valuable: +50", "Disruption")
      end
    end
    
    # PENALTY: Don't give away our own valuable items
    if user_item && !choice_items.include?(user_item)
      valuable_items = [:LEFTOVERS, :LIFEORB, :ASSAULTVEST, :FOCUSSASH]
      if valuable_items.include?(user_item)
        score -= 40
        AdvancedAI.log("  Trick lose valuable: -40", "Disruption")
      end
    end
    
    return score
  end
end

AdvancedAI.log("Disruption Move Intelligence loaded", "Core")
AdvancedAI.log("  - Taunt (blocks setup/support)", "Disruption")
AdvancedAI.log("  - Encore (locks into moves)", "Disruption")
AdvancedAI.log("  - Knock Off (item removal)", "Disruption")
AdvancedAI.log("  - Trick/Switcheroo (item swap)", "Disruption")

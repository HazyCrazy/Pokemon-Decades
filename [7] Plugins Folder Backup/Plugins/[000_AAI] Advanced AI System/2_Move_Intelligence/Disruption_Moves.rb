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
    targets.each do |target|
      next unless target && !target.fainted?
      
      # TAUNT: Block setup/support moves
      if move.id == :TAUNT
        score += evaluate_taunt_value(user, target)
      end
      
      # ENCORE: Lock into last move
      if move.id == :ENCORE
        score += evaluate_encore_value(user, target)
      end
      
      # KNOCK OFF: Remove item + damage
      if move.id == :KNOCKOFF
        score += evaluate_knockoff_value(user, target)
      end
      
      # TRICK/SWITCHEROO: Swap items
      if [:TRICK, :SWITCHEROO].include?(move.id)
        score += evaluate_trick_value(user, target)
      end
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
                   :SHELLSMASH, :COIL, :BULKUP, :AGILITY, :ROCKPOLISH]
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
                     :MOONLIGHT, :SYNTHESIS, :MORNINGSUN]
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
    
    # BONUS: If target is slow (can't switch out easily)
    if user.battler.pbSpeed > target.pbSpeed * 1.3
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
    
    # HIGH VALUE: Lock into setup moves
    setup_moves = [:SWORDSDANCE, :NASTYPLOT, :DRAGONDANCE, :SHELLSMASH, :CALMMIND]
    if setup_moves.include?(last_move)
      score += 80
      AdvancedAI.log("  Encore setup move: +80 (waste turns)", "Disruption")
      
      # Even better if we can set up while they're locked
      if user.moves.any? { |m| m && setup_moves.include?(m.id) }
        score += 30
        AdvancedAI.log("  Can counter-setup: +30", "Disruption")
      end
    end
    
    # HIGH VALUE: Lock into non-damaging moves
    if last_move_data.statusMove?
      score += 50
      AdvancedAI.log("  Encore status move: +50 (free turns)", "Disruption")
    end
    
    # MEDIUM VALUE: Lock into resisted moves
    if last_move_data.damagingMove?
      type_mod = Effectiveness.calculate(last_move_data.type, *user.battler.pbTypes(true))
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
    if last_move_data.damagingMove?
      type_mod = Effectiveness.calculate(last_move_data.type, *user.battler.pbTypes(true))
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
    if item_data.unlosable?
      AdvancedAI.log("  Knock Off: Item is unlosable (no bonus)", "Disruption")
      return 0  # Base damage only, can't remove item
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
        our_side = @battle.pbOwnedByPlayer?(user.index) ? @battle.sides[0] : @battle.sides[1]
        if our_side.effects[PBEffects::StealthRock] || our_side.effects[PBEffects::Spikes] > 0
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
    user_item = user.battler.item_id
    target_item = target.item_id
    
    # Can't Trick if either has no item
    return -80 unless user_item || target_item
    
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
      recovery_moves = [:RECOVER, :ROOST, :WISH, :REST, :PROTECT]
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

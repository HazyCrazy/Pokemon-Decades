#===============================================================================
# Advanced AI System - Special Sacrifice & Utility Moves
# Handles Pain Split, Healing Wish, Final Gambit, Memento, etc.
#===============================================================================

class Battle::AI
  # ============================================================================
  # SPECIAL MOVE EVALUATION
  # ============================================================================
  
  alias special_moves_pbRegisterMove pbRegisterMove
  def pbRegisterMove(user, move)
    score = special_moves_pbRegisterMove(user, move)
    
    return score unless user && move
    
    case move.id
    when :PAINSPLIT
      score += evaluate_pain_split(user, move)
    when :HEALINGWISH, :LUNARDANCE
      score += evaluate_healing_wish(user, move)
    when :FINALGAMBIT
      score += evaluate_final_gambit(user, move)
    when :MEMENTO, :MISTYEXPLOSION
      score += evaluate_sacrifice_moves(user, move)
    when :RAPIDSPIN, :DEFOG
      score += evaluate_hazard_removal(user, move)
    when :ENDEAVOR
      score += evaluate_endeavor(user, move)
    end
    
    return score
  end
  
  # ============================================================================
  # PAIN SPLIT EVALUATION
  # ============================================================================
  
  def evaluate_pain_split(user, move)
    score = 0
    
    targets = @battle.allOtherSideBattlers(user.index).select { |t| t && !t.fainted? }
    return 0 if targets.empty?
    
    best = targets.map { |target|
      tscore = 0
      
      # Pain Split averages RAW HP values (not percentages!)
      # e.g., 50/100 user vs 200/400 target → average = 125, user gains 75 HP
      average_hp = (user.hp + target.hp) / 2.0
      user_gain = average_hp - user.hp
      user_gain_pct = user_gain / user.totalhp.to_f
      user_hp_percent = user.hp.to_f / user.totalhp
      
      # HIGH VALUE: We gain a significant chunk of HP
      if user_gain_pct > 0.30 && user_hp_percent < 0.35
        tscore += 80
        AdvancedAI.log("  Pain Split (#{user.hp}/#{user.totalhp} vs #{target.hp}/#{target.totalhp}): +80 (huge heal)", "Special")
        
        # CRITICAL: Could save us from KO
        if user_hp_percent < 0.2
          tscore += 40
          AdvancedAI.log("  Emergency heal: +40", "Special")
        end
      elsif user_gain_pct > 0.15
        # MEDIUM VALUE
        tscore += 50
        AdvancedAI.log("  Pain Split: +50 (good heal, +#{(user_gain_pct * 100).to_i}% HP)", "Special")
      elsif user_gain_pct <= 0
        # BAD: We lose HP or gain nothing
        tscore -= 40
        AdvancedAI.log("  Pain Split: -40 (we lose HP)", "Special")
      else
        # Minimal benefit
        tscore += 10
        AdvancedAI.log("  Pain Split: +10 (slight benefit)", "Special")
      end
      
      # BONUS: High max HP target (more raw HP to average from)
      if target.totalhp > user.totalhp * 1.3
        tscore += 20
        AdvancedAI.log("  High HP target: +20", "Special")
      end
      
      tscore
    }.max || 0
    
    return best
  end
  
  # ============================================================================
  # HEALING WISH / LUNAR DANCE EVALUATION
  # ============================================================================
  
  def evaluate_healing_wish(user, move)
    score = 0
    
    # User faints to fully heal next Pokemon
    # Only use if:
    # 1. We're about to die anyway
    # 2. We have a valuable teammate to heal
    
    user_hp_percent = user.hp.to_f / user.totalhp
    
    # Don't sacrifice if healthy
    if user_hp_percent > 0.4
      AdvancedAI.log("  #{move.name}: -70 (too healthy to sacrifice)", "Special")
      return -70
    end
    
    # Check party for valuable teammates
    party = @battle.pbParty(user.index & 1)  # side index (0/1), not battler slot
    valuable_teammates = 0
    injured_sweepers = 0
    
    party.each do |pkmn|
      next if !pkmn || pkmn.fainted? || pkmn.egg?
      next if pkmn == user.battler.pokemon  # Skip self
      
      hp_percent = pkmn.hp.to_f / pkmn.totalhp
      
      # Valuable if injured and has high stats
      if hp_percent < 0.6 && (pkmn.attack > 100 || pkmn.spatk > 100)
        injured_sweepers += 1
      end
      
      # Valuable if status'd — both Healing Wish (Gen 5+) and Lunar Dance cure status
      if pkmn.status != :NONE
        valuable_teammates += 1
      end
    end
    
    if injured_sweepers > 0
      score += injured_sweepers * 50
      AdvancedAI.log("  #{move.name}: +#{injured_sweepers * 50} (heal sweeper)", "Special")
      
      # CRITICAL: Last Pokemon standing, sacrifice for win condition
      alive_count = party.count { |p| p && !p.fainted? }
      if alive_count == 2 && user_hp_percent < 0.25
        score += 60
        AdvancedAI.log("  Last hope sacrifice: +60", "Special")
      end
    else
      # No good targets
      score -= 50
      AdvancedAI.log("  #{move.name}: -50 (no valuable teammates)", "Special")
    end
    
    # Both Healing Wish and Lunar Dance cure status (Gen 5+)
    if valuable_teammates > 0
      score += 30
      AdvancedAI.log("  #{move.name} cures status: +30", "Special")
    end
    
    # Lunar Dance extra: also fully restores PP
    if move.id == :LUNARDANCE
      score += 10
      AdvancedAI.log("  Lunar Dance restores PP: +10", "Special")
    end
    
    return score
  end
  
  # ============================================================================
  # FINAL GAMBIT EVALUATION
  # ============================================================================
  
  def evaluate_final_gambit(user, move)
    score = 0
    
    targets = @battle.allOtherSideBattlers(user.index).select { |t| t && !t.fainted? }
    return 0 if targets.empty?
    
    best = targets.map { |target|
      tscore = 0
      
      # Final Gambit: Deals damage equal to user's current HP, user faints
      damage = user.hp
      target_hp = target.hp
      
      # BEST CASE: KO high-value target
      if damage >= target_hp
        tscore += 100
        AdvancedAI.log("  Final Gambit: +100 (KOs target)", "Special")
        
        # BONUS: Target is a sweeper
        if target.stages.values.sum >= 2
          tscore += 50
          AdvancedAI.log("  KOs boosted sweeper: +50", "Special")
        end
        
        # BONUS: Target is last Pokemon
        enemy_count = @battle.allOtherSideBattlers(user.index).count { |b| b && !b.fainted? }
        if enemy_count == 1
          tscore += 80
          AdvancedAI.log("  KOs last Pokemon: +80 (wins game!)", "Special")
        end
      else
        # Doesn't KO - check if worth it
        damage_percent = damage.to_f / target.totalhp
        
        if damage_percent > 0.6
          tscore += 40
          AdvancedAI.log("  Final Gambit: +40 (big damage)", "Special")
        elsif damage_percent > 0.4
          tscore += 20
          AdvancedAI.log("  Final Gambit: +20 (decent damage)", "Special")
        else
          tscore -= 60
          AdvancedAI.log("  Final Gambit: -60 (waste)", "Special")
        end
      end
      
      # PENALTY: We're valuable
      user_hp_percent = user.hp.to_f / user.totalhp
      if user_hp_percent > 0.5
        tscore -= 50
        AdvancedAI.log("  Too healthy: -50", "Special")
      end
      
      tscore
    }.max || 0
    
    return best
  end
  
  # ============================================================================
  # SACRIFICE MOVES (Memento, Misty Explosion, etc.)
  # ============================================================================
  
  def evaluate_sacrifice_moves(user, move)
    score = 0
    user_hp_percent = user.hp.to_f / user.totalhp
    
    # Memento: -2 Atk/SpAtk to target, user faints
    # Misty Explosion: 2x power on Misty Terrain, user faints
    
    if move.id == :MEMENTO
      targets = @battle.allOtherSideBattlers(user.index).select { |t| t && !t.fainted? }
      
      best = targets.map { |target|
        tscore = 0
        
        # HIGH VALUE: Cripple setup sweeper
        if target.stages[:ATTACK] >= 1 || target.stages[:SPECIAL_ATTACK] >= 1
          tscore += 70
          AdvancedAI.log("  Memento vs boosted: +70 (cripple)", "Special")
        elsif target.attack > 120 || target.spatk > 120
          tscore += 50
          AdvancedAI.log("  Memento vs strong: +50", "Special")
        else
          tscore += 20
          AdvancedAI.log("  Memento: +20", "Special")
        end
        
        tscore
      }.max || 0
      
      score += best
      
      # Only if we're dying anyway
      if user_hp_percent > 0.3
        score -= 60
        AdvancedAI.log("  Too healthy to Memento: -60", "Special")
      end
    end
    
    if move.id == :MISTYEXPLOSION
      # 2x power on Misty Terrain
      if @battle.field.terrain == :Misty
        score += 40
        AdvancedAI.log("  Misty Explosion (terrain): +40", "Special")
      end
    end
    
    return score
  end
  
  # ============================================================================
  # HAZARD REMOVAL (Rapid Spin, Defog)
  # ============================================================================
  
  def evaluate_hazard_removal(user, move)
    score = 0
    
    # Check our side for hazards
    our_side = @battle.sides[user.index & 1]  # Fixed: pbOwnedByPlayer? doesn't exist on Battle
    
    hazard_count = 0
    hazard_count += 1 if our_side.effects[PBEffects::StealthRock]
    hazard_count += our_side.effects[PBEffects::Spikes]
    hazard_count += our_side.effects[PBEffects::ToxicSpikes]
    hazard_count += 1 if our_side.effects[PBEffects::StickyWeb]
    
    if hazard_count == 0
      AdvancedAI.log("  #{move.name}: -70 (no hazards)", "Special")
      return -70
    end
    
    # HIGH VALUE: Remove hazards
    score += hazard_count * 30
    AdvancedAI.log("  #{move.name}: +#{hazard_count * 30} (remove #{hazard_count} hazards)", "Special")
    
    # BONUS: Stealth Rock is critical
    if our_side.effects[PBEffects::StealthRock]
      score += 25
      AdvancedAI.log("  Remove Stealth Rock: +25", "Special")
    end
    
    # BONUS: We have Pokemon weak to hazards
    party = @battle.pbParty(user.index & 1)  # side index (0/1), not battler slot
    weak_to_rocks = party.count do |pkmn|
      next false if !pkmn || pkmn.fainted?
      type_mod = Effectiveness.calculate(:ROCK, *pkmn.types)
      Effectiveness.super_effective?(type_mod)
    end
    
    if weak_to_rocks > 0
      score += weak_to_rocks * 15
      AdvancedAI.log("  Protect weak teammates: +#{weak_to_rocks * 15}", "Special")
    end
    
    # Defog ALSO removes opponent's hazards and screens
    if move.id == :DEFOG
      opp_side = @battle.sides[1 - (user.index & 1)]  # Fixed: pbOwnedByPlayer? doesn't exist on Battle
      
      # Remove opponent screens (bad for us usually)
      if opp_side.effects[PBEffects::Reflect] > 0 || opp_side.effects[PBEffects::LightScreen] > 0
        score += 40
        AdvancedAI.log("  Remove opponent screens: +40", "Special")
      end
      
      # Remove opponent hazards (gives them benefit)
      opp_hazards = 0
      opp_hazards += 1 if opp_side.effects[PBEffects::StealthRock]
      opp_hazards += opp_side.effects[PBEffects::Spikes]
      opp_hazards += opp_side.effects[PBEffects::ToxicSpikes] || 0
      opp_hazards += 1 if opp_side.effects[PBEffects::StickyWeb]
      if opp_hazards > 0
        score -= opp_hazards * 15
        AdvancedAI.log("  Also removes our hazards: -#{opp_hazards * 15}", "Special")
      end
    end
    
    return score
  end
  
  # ============================================================================
  # ENDEAVOR EVALUATION
  # ============================================================================
  
  def evaluate_endeavor(user, move)
    score = 0
    
    targets = @battle.allOtherSideBattlers(user.index).select { |t| t && !t.fainted? }
    return 0 if targets.empty?
    
    # Endeavor: Set target HP to user's current HP
    # Only good if we're low HP
    user_hp_percent = user.hp.to_f / user.totalhp
    
    if user_hp_percent > 0.5
      AdvancedAI.log("  Endeavor: -60 (too healthy)", "Special")
      return -60
    end
    
    best = targets.map { |target|
      tscore = 0
      user_hp = user.hp
      target_hp = target.hp
      
      # HIGH VALUE: Target at high HP, we're low
      if target_hp > user_hp * 2
        damage = target_hp - user_hp
        damage_percent = damage.to_f / target.totalhp
        
        tscore += 60
        AdvancedAI.log("  Endeavor: +60 (#{(damage_percent * 100).to_i}% damage)", "Special")
        
        # COMBO: Follow up with priority move
        priority_moves = user.moves.select { |m| m && m.priority > 0 }
        if priority_moves.any?
          tscore += 40
          AdvancedAI.log("  Have priority follow-up: +40", "Special")
        end
      else
        tscore -= 40
        AdvancedAI.log("  Endeavor: -40 (target too low)", "Special")
      end
      
      tscore
    }.max || 0
    
    return best
  end
end

AdvancedAI.log("Special Sacrifice & Utility Moves loaded", "Core")
AdvancedAI.log("  - Pain Split (HP averaging)", "Special")
AdvancedAI.log("  - Healing Wish/Lunar Dance (sacrifice heal)", "Special")
AdvancedAI.log("  - Final Gambit (sacrifice damage)", "Special")
AdvancedAI.log("  - Memento/Misty Explosion", "Special")
AdvancedAI.log("  - Rapid Spin/Defog (hazard removal)", "Special")
AdvancedAI.log("  - Endeavor (HP matching)", "Special")
AdvancedAI.log("  - False Swipe = -999 in PVP (already in Move_Scorer)", "Special")

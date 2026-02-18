#===============================================================================
# Advanced AI System - Terastallization Intelligence (DBK_006 Integration)
# Strategic Tera Timing and Type Advantage Analysis
#===============================================================================

class Battle::AI
  # Checks if Terastallize should be used
  def should_terastallize?(user, skill)
    AdvancedAI.log("should_terastallize? called for #{user.battler.name} (skill #{skill})", "Tera")
    
    unless skill >= 100
      AdvancedAI.log("  ❌ Skill too low (#{skill} < 100)", "Tera")
      return false
    end
    
    unless AdvancedAI.dbk_enabled?(:terastallization)
      AdvancedAI.log("  ❌ Terastallization not enabled", "Tera")
      return false
    end
    
    # Note: user is an AIBattler, so we use the battle's method with the index
    unless @battle.pbCanTerastallize?(user.index)
      AdvancedAI.log("  ❌ @battle.pbCanTerastallize? returned false", "Tera")
      return false
    end
    
    if user.tera?
      AdvancedAI.log("  ❌ Already Terastallized", "Tera")
      return false
    end
    
    score = calculate_tera_score(user, skill)
    
    # Wild Pokemon bonus (for testing/balance)
    if @battle.wildBattle?
      score += 10
      AdvancedAI.log("  Wild Pokemon Tera bonus: +10", "Tera")
    end
    
    AdvancedAI.log("Tera score for #{user.pbThis}: #{score}", "Tera")
    
    # Thresholds
    return true if score >= 80   # Emergency/Guaranteed value
    return true if score >= 60   # Strong Situation
    return true if score >= 40 && remaining_pokemon_count(user) <= 2  # Good + few remaining
    
    return false
  end
  
  private
  
  def calculate_tera_score(user, skill)
    score = 0
    
    # 1. TIMING CONTEXT (0-30)
    score += evaluate_tera_timing(user, skill)
    
    # 2. TYPE ADVANTAGE (0-40)
    score += evaluate_tera_type_advantage(user, skill)
    
    # 3. SWEEP POTENTIAL (0-35)
    score += evaluate_tera_sweep(user, skill)
    
    # 4. SURVIVAL NECESSITY (0-45)
    score += evaluate_tera_survival(user, skill)
    
    # 5. PARTY COMPARISON (0 bis -25)
    score += evaluate_tera_party(user, skill)
    
    # 6. BATTLE MOMENTUM (0-25)
    score += evaluate_tera_momentum(user, skill)
    
    return score
  end
  
  # 1. Timing Context
  def evaluate_tera_timing(user, skill)
    score = 0
    turn = @battle.turnCount
    
    if turn <= 2
      # Early Game: Only with strong advantage
      score += 10
    elsif turn <= 6
      # Mid Game: Optimal for Sweep Setup
      score += 20
    else
      # Late Game: Cleanup or Emergency
      score += 15
    end
    
    # Team State
    alive = remaining_pokemon_count(user)
    score -= 10 if alive >= 5  # Too early
    score += 10 if alive <= 2  # Critical
    
    return score
  end
  
  # 2. Type Advantage
  def evaluate_tera_type_advantage(user, skill)
    score = 0
    tera_type = user.tera_type
    
    return 0 unless tera_type
    
    # Offensive Synergy
    user.moves.each do |move|
      next unless move && move.damagingMove?
      
      if move.type == tera_type
        # STAB Bonus after Tera
        score += 15
        
        # Coverage against active opponents
        @battle.allOtherSideBattlers(user.index).each do |target|
          next unless target && !target.fainted?
          
          type_mod = Effectiveness.calculate(tera_type, *target.pbTypes(true))
          score += 10 if Effectiveness.super_effective?(type_mod)
        end
      end
    end
    
    # Defensive Coverage
    @battle.allOtherSideBattlers(user.index).each do |target|
      next unless target && !target.fainted?
      
      target.moves.each do |move|
        next unless move && move.damagingMove?
        
        # Resistance after Tera
        current_mod = Effectiveness.calculate(move.type, *user.pbTypes(true))
        tera_mod = Effectiveness.calculate(move.type, tera_type)
        
        if Effectiveness.super_effective?(current_mod) && Effectiveness.not_very_effective?(tera_mod)
          score += 25  # Turns Weakness into Resistance
        elsif Effectiveness.super_effective?(current_mod) && tera_mod == Effectiveness::NORMAL_EFFECTIVE
          score += 15  # Neutralizes Weakness
        end
      end
    end
    
    return [score, 40].min
  end
  
  # 3. Sweep Potential
  def evaluate_tera_sweep(user, skill)
    score = 0
    
    # Setup Boosts
    positive_boosts = user.stages.values.count { |stage| stage > 0 }
    if positive_boosts >= 3
      score += 20
    elsif positive_boosts >= 1
      score += 10
    end
    
    # HP for Sweep
    hp_percent = user.hp.to_f / user.totalhp
    score += 15 if hp_percent > 0.7
    score += 10 if hp_percent > 0.5
    
    # Opponent Team Analysis
    weak_to_tera = @battle.allOtherSideBattlers(user.index).count do |target|
      next false unless target && !target.fainted?
      
      tera_type = user.tera_type
      next false unless tera_type
      
      type_mod = Effectiveness.calculate(tera_type, *target.pbTypes(true))
      Effectiveness.super_effective?(type_mod)
    end
    score += weak_to_tera * 8
    
    # Win Condition
    alive_enemies = alive_enemies_count(user)
    if alive_enemies <= 2 && positive_boosts >= 2
      score += 15  # Can end game
    end
    
    return [score, 35].min
  end
  
  # 4. Survival Necessity
  def evaluate_tera_survival(user, skill)
    score = 0
    hp_percent = user.hp.to_f / user.totalhp
    tera_type = user.tera_type
    
    return 0 unless tera_type
    
    # Emergency Situation
    if hp_percent < 0.3
      score += 30
    elsif hp_percent < 0.5
      score += 15
    end
    
    # Type Coverage Need
    imminent_ko = false
    @battle.allOtherSideBattlers(user.index).each do |target|
      next unless target && !target.fainted?
      
      target.moves.each do |move|
        next unless move && move.damagingMove?
        
        # Note: target is attacking user here, so target=attacker, user=defender
        current_damage = calculate_rough_damage(move, target, user)
        if current_damage >= user.hp
          # Would be KO without Tera
          tera_mod = Effectiveness.calculate(move.type, tera_type, nil)
          if Effectiveness.not_very_effective?(tera_mod) || Effectiveness.ineffective?(tera_mod)
            score += 45  # Tera saves
            imminent_ko = true
            break
          end
        end
      end
      break if imminent_ko
    end
    
    # Survival Priority
    if remaining_pokemon_count(user) == 1
      score += 20  # Last Pokemon
    end
    
    return [score, 45].min
  end
  
  # 5. Party Comparison
  def evaluate_tera_party(user, skill)
    score = 0
    party = @battle.pbParty(user.index)
    
    # Better Tera Candidates?
    better_candidates = party.count do |pkmn|
      next false if !pkmn || pkmn.fainted? || pkmn.egg?
      next false unless pkmn.tera_type
      
      # Higher Offense or better Tera Synergy
      pkmn.attack > user.attack || pkmn.spatk > user.spatk
    end
    
    if better_candidates > 0
      score -= [better_candidates * 10, 25].min
    end
    
    # Last Pokemon Bonus
    alive = remaining_pokemon_count(user)
    score += 15 if alive == 1
    
    return score
  end
  
  # 6. Battle Momentum
  def evaluate_tera_momentum(user, skill)
    score = 0
    
    # Current Advantage
    if user_has_momentum?(user)
      score += 10
    end
    
    # Maintain Pressure
    @battle.allOtherSideBattlers(user.index).each do |target|
      next unless target && !target.fainted?
      
      if target.hp < target.totalhp * 0.4
        score += 8  # Finishing blow
      end
    end
    
    # Comeback Potential
    hp_disadvantage = user.hp.to_f / user.totalhp < 0.5
    enemy_advantage = @battle.allOtherSideBattlers(user.index).all? { |b| 
      b && !b.fainted? && b.hp > b.totalhp * 0.6 
    }
    
    score += 15 if hp_disadvantage && enemy_advantage
    
    return [score, 25].min
  end
end

# Extended Battler Methods for Terastallization
class Battle::Battler
  def can_terastallize?
    return false unless defined?(Settings::TERASTALLIZE_TRIGGER_KEY)
    return false unless @battle.pbCanTerastallize?(@index)
    return true
  end
  
  def tera?
    return false unless defined?(Settings::TERASTALLIZE_TRIGGER_KEY)
    # Check the pokemon's tera status, not self (would cause infinite recursion)
    return @pokemon&.tera? || false
  end
  
  def tera_type
    return nil unless defined?(Settings::TERASTALLIZE_TRIGGER_KEY)
    return @pokemon.tera_type if @pokemon
    return nil
  end
end

# Extended AIBattler Methods for Terastallization
class Battle::AI::AIBattler
  def tera?
    return @battler.tera? if @battler.respond_to?(:tera?)
    return false
  end
  
  def tera_type
    return @battler.tera_type if @battler.respond_to?(:tera_type)
    return nil
  end
end

AdvancedAI.log("Terastallization Intelligence loaded (DBK_006)", "Tera")

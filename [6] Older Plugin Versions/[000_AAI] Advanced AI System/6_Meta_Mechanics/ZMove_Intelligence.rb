#===============================================================================
# Advanced AI System - Z-Move Intelligence (DBK_004 Integration)
# Logic for optimal Z-Move usage
#===============================================================================

class Battle::AI
  # Main entry point for checking Z-Moves usage
  def should_z_move?(user, skill)
    return false unless AdvancedAI.dbk_enabled?(:z_moves)
    # Check if user can use Z-Moves (handled by DBK check mostly, but good to be safe)
    return false unless user.can_z_move?
    
    score = 0
    
    # 1. Damage Potential (OHKO check)
    score += evaluate_z_move_damage(user, skill)
    
    # 2. Status Z-Move Value
    score += evaluate_z_move_status(user)
    
    AdvancedAI.log("Z-Move Eval for #{user.pbThis}: Score #{score}", "Z-Move")
    
    # Thresholds
    return true if score >= 40   # Excellent opportunity (OHKO)
    return true if score >= 20 && user.hp <= user.totalhp * 0.3 # Desperation
    
    return false
  end
  
  private
  
  def evaluate_z_move_damage(user, skill)
    score = 0
    best_move = nil
    max_damage = 0
    
    # Find best offensive Z-Move
    user.moves.each_with_index do |move, i|
      next unless move.damagingMove?
      # Assuming logic exists to get Z-Move equivalent or calculating roughly based on power
      # DBK_004 handles the actual conversion, but for AI we approximate:
      # Z-Moves are usually high power (100-200 BP).
      
      # Simplified: Assume the Z-Move is available and super-strong
      # Check coverage against targets
      @battle.allOtherSideBattlers(user.index).each do |target|
        next unless target && !target.fainted?
        
        # Calculate rough damage with a "Z-Boost" (approx 1.5x - 2.0x normal max power)
        rough_dmg = calculate_rough_damage(move, user, target) * 1.8
        
        if rough_dmg >= target.hp
          score = 50 # Guaranteed KO found!
          AdvancedAI.log("Z-Move KO predicted vs #{target.name}", "Z-Move")
          return score # Return immediately if we found a kill
        end
        
        if rough_dmg > max_damage
          max_damage = rough_dmg 
        end
      end
    end
    
    # If no KO, but high damage
    if max_damage > 0
      score += 15
    end
    
    return score
  end
  
  def evaluate_z_move_status(user)
    score = 0
    user.moves.each do |move|
      next unless move.statusMove?
      # Check for specific high-value Status Z-Moves
      # Z-Splash (Attack +3)
      if move.id == :SPLASH
        score += 30 
      end
      
      # Z-Belly Drum (Full Heal + Max Attack)
      if move.id == :BELLYDRUM
        score += 30
      end
      
      # Omniboosting Z-Moves (Z-Celebrate, Z-Happy Hour, etc.)
      if [:CELEBRATE, :HAPPYHOUR, :CONVERSION, :GEOMANCY].include?(move.id)
        score += 25
      end
    end
    return score
  end
end

class Battle::Battler
  def can_z_move?
    return false unless defined?(Settings::ZMOVE_TRIGGER_KEY)
    # Check if we have a Z-Crystal held and appropriate move
    # DBK method: pbCanZMove?(idxBattler)
    return @battle.pbCanZMove?(@index)
  end
end

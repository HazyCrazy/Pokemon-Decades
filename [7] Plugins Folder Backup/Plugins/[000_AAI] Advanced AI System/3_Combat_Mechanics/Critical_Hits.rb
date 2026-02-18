#===============================================================================
# Advanced AI System - Critical Hit Strategies
# Super Luck, Sniper, high crit moves, Focus Energy builds
#===============================================================================

module AdvancedAI
  module CriticalHits
    #===========================================================================
    # Critical Hit Move Lists
    #===========================================================================
    
    HIGH_CRIT_MOVES = [
      :AEROBLAST, :AIRCUTTER, :ATTACKORDER, :BLAZEKICK, :CRABHAMMER,
      :CROSSCHOP, :CROSSPOISON, :DRILLRUN, :KARATECHOP, :LEAFBLADE,
      :NIGHTSLASH, :POISONTAIL, :PSYCHOCUT, :RAZORLEAF, :RAZORWIND,
      :SHADOWCLAW, :SLASH, :SPACIALREND, :STONEEDGE
      # Note: STORMTHROW, FLOWERTRICK, WICKEDBLOW, SURGINGSTRIKES are ALWAYS_CRIT
    ]
    
    ALWAYS_CRIT_MOVES = [
      :FROSTBREATH, :STORMTHROW, :WICKEDBLOW, :SURGINGSTRIKES, :FLOWERTRICK
    ]
    
    #===========================================================================
    # Critical Hit Rate Calculation
    #===========================================================================
    
    # Calculate crit stage and rate
    def self.get_crit_stage(attacker, move)
      stage = 0
      
      # Move's inherent crit ratio
      if move && HIGH_CRIT_MOVES.include?(move.id)
        stage += 1
      end
      
      # Always crit moves
      if move && ALWAYS_CRIT_MOVES.include?(move.id)
        return { stage: 99, rate: 100 }
      end
      
      # Super Luck ability
      if attacker.ability_id == :SUPERLUCK
        stage += 1
      end
      
      # Focus Energy
      if attacker.effects[PBEffects::FocusEnergy] && attacker.effects[PBEffects::FocusEnergy] > 0
        stage += 2
      end
      
      # Lansat Berry (eaten)
      # Note: Need to track if consumed
      
      # Items
      case attacker.item_id
      when :SCOPELENS, :RAZORCLAW
        stage += 1
      when :LUCKYPUNCH  # Chansey only
        if attacker.species == :CHANSEY
          stage += 2
        end
      when :LEEK, :STICK  # Farfetch'd / Sirfetch'd only
        if [:FARFETCHD, :SIRFETCHD, :FARFETCHDGALAR].include?(attacker.species)
          stage += 2
        end
      end
      
      # Convert stage to rate
      rate = case stage
             when 0 then 4.17   # 1/24
             when 1 then 12.5   # 1/8
             when 2 then 50     # 1/2
             else 100           # Always crit at stage 3+
             end
      
      { stage: [stage, 3].min, rate: rate }
    end
    
    #===========================================================================
    # Sniper Ability
    #===========================================================================
    
    # Sniper boosts crit damage from 1.5x to 2.25x
    def self.evaluate_sniper_build(battle, attacker, move, skill_level = 100)
      return 0 unless skill_level >= 70
      return 0 unless attacker.ability_id == :SNIPER
      return 0 unless move && move.damagingMove?
      
      score = 0
      crit_data = get_crit_stage(attacker, move)
      
      # Sniper makes high crit builds very strong
      if crit_data[:rate] >= 50
        score += 40  # 2.25x damage on half hits
      elsif crit_data[:rate] >= 12.5
        score += 20
      end
      
      # Always crit = 2.25x every time
      if ALWAYS_CRIT_MOVES.include?(move.id)
        score += 60
      end
      
      score
    end
    
    #===========================================================================
    # Focus Energy Evaluation
    #===========================================================================
    
    def self.evaluate_focus_energy(battle, attacker, move, skill_level = 100)
      return 0 unless skill_level >= 60
      return 0 unless move.id == :FOCUSENERGY
      
      score = 0
      
      # Already have Focus Energy?
      if attacker.effects[PBEffects::FocusEnergy] && attacker.effects[PBEffects::FocusEnergy] > 0
        return -80
      end
      
      # Check if we have high crit moves
      high_crit_count = attacker.moves.count { |m| m && HIGH_CRIT_MOVES.include?(m.id) }
      score += high_crit_count * 20
      
      # Super Luck makes Focus Energy = 100% crits
      if attacker.ability_id == :SUPERLUCK
        score += 50
      end
      
      # Scope Lens also stacks
      if attacker.item_id == :SCOPELENS
        score += 30
      end
      
      # Sniper makes crits devastating
      if attacker.ability_id == :SNIPER
        score += 40
      end
      
      # Kingambit special: Kowtow Cleave always crits + high attack
      if attacker.species == :KINGAMBIT
        score += 35
      end
      
      score
    end
    
    #===========================================================================
    # Critical Hit Build Synergy
    #===========================================================================
    
    # Evaluate high crit move usage
    def self.evaluate_high_crit_move(battle, attacker, move, target, skill_level = 100)
      return 0 unless skill_level >= 55
      return 0 unless move && HIGH_CRIT_MOVES.include?(move.id)
      
      score = 0
      crit_data = get_crit_stage(attacker, move)
      
      # Base bonus for crit potential
      score += (crit_data[:rate] / 5).to_i
      
      # Crits ignore defense boosts
      if target && target.stages[:DEFENSE] > 0 && move.physicalMove?
        score += target.stages[:DEFENSE] * 10  # Bypass their bulk
      end
      if target && target.stages[:SPECIAL_DEFENSE] > 0 && move.specialMove?
        score += target.stages[:SPECIAL_DEFENSE] * 10
      end
      
      # Crits ignore Reflect/Light Screen
      our_opp_side = battle.sides[(attacker.index + 1) % 2]
      if move.physicalMove? && our_opp_side.effects[PBEffects::Reflect] && our_opp_side.effects[PBEffects::Reflect] > 0
        score += 15
      end
      if move.specialMove? && our_opp_side.effects[PBEffects::LightScreen] && our_opp_side.effects[PBEffects::LightScreen] > 0
        score += 15
      end
      
      score
    end
    
    # Always crit moves are premium
    def self.evaluate_always_crit_move(battle, attacker, move, skill_level = 100)
      return 0 unless skill_level >= 50
      return 0 unless move && ALWAYS_CRIT_MOVES.include?(move.id)
      
      score = 20  # Base bonus for guaranteed crit
      
      # Sniper makes these amazing
      if attacker.ability_id == :SNIPER
        score += 35
      end
      
      score
    end
    
    #===========================================================================
    # Counter-Play: Battle Armor / Shell Armor
    #===========================================================================
    
    def self.check_crit_immunity(battle, target, move, skill_level = 100)
      return 0 unless skill_level >= 50
      return 0 unless target
      return 0 unless move && move.damagingMove?
      
      crit_immune = [:BATTLEARMOR, :SHELLARMOR]
      
      if crit_immune.include?(target.ability_id)
        # Reduce value of crit builds
        # Use battle parameter, not @battle (this is a module method)
        attacker = battle&.battlers&.find { |b| b && !b.fainted? }
        crit_data = get_crit_stage(attacker, move)
        
        if HIGH_CRIT_MOVES.include?(move.id) || ALWAYS_CRIT_MOVES.include?(move.id)
          return -20  # Our crit advantage is nullified
        end
      end
      
      0
    end
    
    #===========================================================================
    # Lucky Chant Awareness
    #===========================================================================
    
    def self.check_lucky_chant(battle, attacker, move, skill_level = 100)
      return 0 unless skill_level >= 60
      
      opp_side = battle.sides[(attacker.index + 1) % 2]
      
      # Lucky Chant prevents crits
      if opp_side.effects[PBEffects::LuckyChant] && opp_side.effects[PBEffects::LuckyChant] > 0
        if HIGH_CRIT_MOVES.include?(move.id) || ALWAYS_CRIT_MOVES.include?(move.id)
          return -25  # Crit advantage nullified
        end
      end
      
      0
    end
    
    #===========================================================================
    # Dire Hit Item Usage (for future implementation)
    #===========================================================================
    
    def self.should_use_dire_hit?(battle, battler, skill_level = 100)
      return false unless skill_level >= 70
      
      # Would Focus Energy be better?
      return false if battler.effects[PBEffects::FocusEnergy] && battler.effects[PBEffects::FocusEnergy] > 0
      
      # Check crit build potential
      has_high_crit = battler.moves.any? { |m| m && HIGH_CRIT_MOVES.include?(m.id) }
      has_sniper = battler.ability_id == :SNIPER
      
      (has_high_crit || has_sniper) && battler.hp > battler.totalhp * 0.5
    end
  end
end

# API Methods
module AdvancedAI
  def self.get_crit_stage(attacker, move)
    CriticalHits.get_crit_stage(attacker, move)
  end
  
  def self.evaluate_sniper_build(battle, attacker, move, skill_level = 100)
    CriticalHits.evaluate_sniper_build(battle, attacker, move, skill_level)
  end
  
  def self.evaluate_focus_energy(battle, attacker, move, skill_level = 100)
    CriticalHits.evaluate_focus_energy(battle, attacker, move, skill_level)
  end
  
  def self.evaluate_high_crit_move(battle, attacker, move, target, skill_level = 100)
    CriticalHits.evaluate_high_crit_move(battle, attacker, move, target, skill_level)
  end
  
  def self.evaluate_always_crit_move(battle, attacker, move, skill_level = 100)
    CriticalHits.evaluate_always_crit_move(battle, attacker, move, skill_level)
  end
  
  def self.check_crit_immunity(battle, target, move, skill_level = 100)
    CriticalHits.check_crit_immunity(battle, target, move, skill_level)
  end
  
  def self.is_high_crit_move?(move)
    return false unless move
    CriticalHits::HIGH_CRIT_MOVES.include?(move.id) || CriticalHits::ALWAYS_CRIT_MOVES.include?(move.id)
  end
end

AdvancedAI.log("Critical Hit Strategies loaded", "Crit")
AdvancedAI.log("  - Crit stage calculation", "Crit")
AdvancedAI.log("  - Super Luck awareness", "Crit")
AdvancedAI.log("  - Sniper build optimization", "Crit")
AdvancedAI.log("  - Focus Energy evaluation", "Crit")
AdvancedAI.log("  - Always-crit moves (Wicked Blow, etc.)", "Crit")
AdvancedAI.log("  - Battle Armor / Shell Armor counter-play", "Crit")
AdvancedAI.log("  - Lucky Chant awareness", "Crit")

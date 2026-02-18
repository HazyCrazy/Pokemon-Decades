#===============================================================================
# Advanced AI System - Role Detection
# Detects 7 Pokemon Roles: Sweeper, Wall, Tank, Support, Wallbreaker, Pivot, Lead
#===============================================================================

module AdvancedAI
  module RoleDetection
    # Pokemon Roles
    ROLES = {
      :sweeper     => "Fast offensive Pokemon (Speed 100+, Atk/SpAtk 100+)",
      :wall        => "Defensive Pokemon (HP/Def/SpDef 100+, Speed <70)",
      :tank        => "Bulky offensive (HP 90+, Atk/SpAtk 100+)",
      :support     => "Support moves (Screens, Hazards, Status)",
      :wallbreaker => "High power breaker (Atk/SpAtk 120+)",
      :pivot       => "U-turn, Volt Switch, Flip Turn user",
      :lead        => "Hazard setter, Fast Taunt user"
    }
    
    # Detects primary and secondary role
    def self.detect_roles(battler)
      return [:balanced, nil] unless battler
      
      roles = []
      
      # Analyze stats
      stats = {
        hp: battler.totalhp,
        attack: battler.attack,
        defense: battler.defense,
        spatk: battler.spatk,
        spdef: battler.spdef,
        speed: battler.speed
      }
      
      # === SWEEPER ===
      if stats[:speed] >= 100 && (stats[:attack] >= 100 || stats[:spatk] >= 100)
        roles << :sweeper
      end
      
      # === WALL ===
      defensive_total = stats[:hp] + stats[:defense] + stats[:spdef]
      if defensive_total >= 300 && stats[:speed] < 70
        roles << :wall
      end
      
      # === TANK ===
      if stats[:hp] >= 90 && (stats[:attack] >= 100 || stats[:spatk] >= 100) && stats[:speed] < 90
        roles << :tank
      end
      
      # === WALLBREAKER ===
      if stats[:attack] >= 120 || stats[:spatk] >= 120
        roles << :wallbreaker
      end
      
      # === SUPPORT ===
      if has_support_moves?(battler)
        roles << :support
      end
      
      # === PIVOT ===
      if has_pivot_moves?(battler)
        roles << :pivot
      end
      
      # === LEAD ===
      if has_lead_moves?(battler)
        roles << :lead
      end
      
      # Fallback
      roles << :balanced if roles.empty?
      
      [roles.first, roles[1]]
    end
    
    # Checks if Pokemon has role
    def self.has_role?(battler, role)
      primary, secondary = detect_roles(battler)
      primary == role || secondary == role
    end
    
    # Finds best Pokemon for role
    def self.best_for_role(battle, side_index, role)
      party = battle.pbParty(side_index)
      
      candidates = party.select do |pkmn|
        next false if !pkmn || pkmn.fainted? || pkmn.egg?
        next false if battle.pbFindBattler(pkmn.index, side_index)
        has_role?(pkmn, role)
      end
      
      return nil if candidates.empty?
      
      # Rate candidates
      best = candidates.max_by { |pkmn| rate_role_effectiveness(pkmn, role) }
      party.index(best)
    end
    
    # Recommends role for situation
    def self.recommend_role_for_situation(battle, fainted_index, opponent, skill_level = 100)
      return nil unless skill_level >= 55
      return nil unless opponent
      
      # Analyze opponent role
      opp_role, _ = detect_roles(opponent)
      
      # Counter-Pick
      case opp_role
      when :sweeper
        return :wall  # Wall stops Sweeper
      when :wall
        return :wallbreaker  # Wallbreaker breaks Wall
      when :wallbreaker
        return :sweeper  # Outspeed Wallbreaker
      when :support
        return :sweeper  # Pressure Support
      when :tank
        return :wallbreaker  # Break Tank
      else
        return :balanced
      end
    end
    
    private
    
    # Support Moves Check
    def self.has_support_moves?(battler)
      return false unless battler.moves
      
      support_moves = [
        :REFLECT, :LIGHTSCREEN, :AURORAVEIL,
        :STEALTHROCK, :SPIKES, :TOXICSPIKES, :STICKYWEB,
        :HEALBELL, :AROMATHERAPY, :WISH,
        :TAILWIND, :TRICKROOM,
        :WILLOWISP, :TOXIC, :THUNDERWAVE, :TAUNT
      ]
      
      battler.moves.any? { |m| m && support_moves.include?(m.id) }
    end
    
    # Pivot Moves Check
    def self.has_pivot_moves?(battler)
      return false unless battler.moves
      
      pivot_moves = [:UTURN, :VOLTSWITCH, :FLIPTURN, :PARTINGSHOT, :TELEPORT, :BATONPASS]
      battler.moves.any? { |m| m && pivot_moves.include?(m.id) }
    end
    
    # Lead Moves Check
    def self.has_lead_moves?(battler)
      return false unless battler.moves
      
      lead_moves = [
        :STEALTHROCK, :SPIKES, :STICKYWEB,
        :TAUNT, :FAKEOUT, :QUICKGUARD
      ]
      
      has_lead_move = battler.moves.any? { |m| m && lead_moves.include?(m.id) }
      fast_taunt = battler.speed >= 90 && battler.moves.any? { |m| m && m.id == :TAUNT }
      
      has_lead_move || fast_taunt
    end
    
    # Rates Role Effectiveness
    def self.rate_role_effectiveness(pkmn, role)
      score = 50
      
      case role
      when :sweeper
        score += pkmn.speed / 2
        score += [pkmn.attack, pkmn.spatk].max / 2
      when :wall
        score += pkmn.totalhp / 3
        score += pkmn.defense / 3
        score += pkmn.spdef / 3
      when :wallbreaker
        score += [pkmn.attack, pkmn.spatk].max
      when :tank
        score += pkmn.totalhp / 2
        score += [pkmn.attack, pkmn.spatk].max / 2
      when :support
        score += 100 if has_support_moves?(pkmn)
      when :pivot
        score += 100 if has_pivot_moves?(pkmn)
      when :lead
        score += 100 if has_lead_moves?(pkmn)
      end
      
      score
    end
  end
end

# API-Wrapper
module AdvancedAI
  def self.detect_roles(battler)
    RoleDetection.detect_roles(battler)
  end
  
  def self.has_role?(battler, role)
    RoleDetection.has_role?(battler, role)
  end
  
  def self.best_for_role(battle, side_index, role)
    RoleDetection.best_for_role(battle, side_index, role)
  end
  
  def self.recommend_role_for_situation(battle, fainted_index, opponent, skill_level = 100)
    RoleDetection.recommend_role_for_situation(battle, fainted_index, opponent, skill_level)
  end
end

# Integration in Switch Intelligence
class Battle::AI
  def evaluate_switch_with_roles(user, opponent, skill_level)
    return [] unless skill_level >= 55
    
    # Analyze Situation
    situation = analyze_situation(user, opponent)
    recommended_role = AdvancedAI.recommend_role_for_situation(@battle, user.index, opponent, skill_level)
    
    # Find Pokemon with recommended role
    best_index = AdvancedAI.best_for_role(@battle, user.index, recommended_role)
    
    AdvancedAI.log("Recommended role: #{recommended_role} for situation vs #{opponent.pbThis}", "Role")
    
    best_index ? [best_index, 100] : []
  end
  
  private
  
  def analyze_situation(user, opponent)
    {
      hp_disadvantage: user.hp < user.totalhp * 0.5,
      type_disadvantage: type_disadvantage?(user, opponent),
      speed_disadvantage: opponent.pbSpeed > user.pbSpeed,
      threat_level: AdvancedAI.assess_threat(@battle, user, opponent, 100)
    }
  end
  
  def type_disadvantage?(user, opponent)
    opponent.moves.any? do |move|
      next false unless move && move.damagingMove?
      type_mod = Effectiveness.calculate(move.type, user.pbTypes[0], user.pbTypes[1])
      Effectiveness.super_effective?(type_mod)
    end
  end
end

AdvancedAI.log("Role Detection System loaded (7 roles)", "Role")

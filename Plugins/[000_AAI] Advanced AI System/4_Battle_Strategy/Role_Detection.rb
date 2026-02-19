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
      :stall       => "Defensive Pokemon with stall moveset (Toxic/Protect/Recovery)",
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
      
      # === STALL ===
      # Stall is a Wall with stall-specific moveset (Toxic/Protect/Recovery combos)
      if AdvancedAI::MoveCategories.has_stall_moveset?(battler)
        # Prioritize :stall over :wall if they have the right moves
        if roles.include?(:wall)
          roles.delete(:wall)
          roles.unshift(:stall)  # Stall becomes primary role
        else
          # Can be a stall mon even without pure wall stats (e.g., Toxapex)
          roles << :stall
        end
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
      
      # Counter-Pick: each role has a natural counter
      case opp_role
      when :sweeper
        return :wall           # Wall stops Sweeper
      when :wall, :stall
        return :wallbreaker    # Wallbreaker breaks Wall/Stall
      when :wallbreaker
        return :sweeper        # Outspeed Wallbreaker
      when :support
        return :lead           # Lead (Taunt/Hazards) shuts down Support
      when :tank
        return :wallbreaker    # Break through Tank's bulk
      when :pivot
        return :tank           # Tank facetanks pivots and doesn't mind chip
      when :lead
        return :lead           # Mirror lead: Taunt their hazards
      else
        return :sweeper        # Default: bring offense
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
      when :wall, :stall
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
        score += pkmn.totalhp / 4  # Bulk helps supports survive to do their job
      when :pivot
        score += 100 if has_pivot_moves?(pkmn)
        score += pkmn.speed / 3    # Speed matters for momentum
      when :lead
        score += 100 if has_lead_moves?(pkmn)
        score += pkmn.speed / 3    # Fast leads set up first
      when :balanced
        # Balanced mons are generalists — rate by overall stat total
        score += (pkmn.totalhp + pkmn.attack + pkmn.defense +
                  pkmn.spatk + pkmn.spdef + pkmn.speed) / 10
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

# Integration in Switch Intelligence — Role Counter-Pick Bonus
# Used by find_best_switch_advanced to boost candidates that counter the opponent's role.
class Battle::AI
  # Returns a score bonus (0-30) for how well a bench Pokemon counters the opponent
  def role_counter_pick_bonus(pkmn, user, skill_level)
    return 0 unless skill_level >= 55
    
    opponent = @battle.allOtherSideBattlers(get_battler_index(user)).find { |b| b && !b.fainted? }
    return 0 unless opponent
    
    recommended_role = AdvancedAI.recommend_role_for_situation(@battle, user.index, opponent, skill_level)
    return 0 unless recommended_role
    
    # Check if this bench Pokemon fills the recommended role
    pkmn_role, pkmn_secondary = AdvancedAI.detect_roles(pkmn)
    
    bonus = 0
    if pkmn_role == recommended_role
      bonus += 25  # Perfect counter-pick
    elsif pkmn_secondary == recommended_role
      bonus += 15  # Secondary role matches
    end
    
    AdvancedAI.log("Role counter-pick: #{pkmn.name} (#{pkmn_role}) vs recommended #{recommended_role} → +#{bonus}", "Role") if bonus > 0
    
    return bonus
  end
end

AdvancedAI.log("Role Detection System loaded (9 roles)", "Role")

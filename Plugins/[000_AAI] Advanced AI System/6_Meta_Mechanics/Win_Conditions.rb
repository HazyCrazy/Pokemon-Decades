#===============================================================================
# Advanced AI System - Win Condition Identification
# Tracks and identifies how the AI can win the battle
#===============================================================================

module AdvancedAI
  module WinConditions
    #===========================================================================
    # Win Condition Types
    #===========================================================================
    WIN_CONDITIONS = {
      sweep: {
        description: "A single Pokemon can KO all remaining opponents",
        priority: 10
      },
      attrition: {
        description: "Chip damage + hazards will secure victory",
        priority: 7
      },
      stall: {
        description: "PP stall or Toxic stall will win",
        priority: 5
      },
      trade: {
        description: "Trading 1-for-1 leads to numerical advantage",
        priority: 6
      },
      setup: {
        description: "One safe setup turn wins the game",
        priority: 9
      },
      revenge: {
        description: "Revenge killing with priority/faster mon wins",
        priority: 8
      },
      speed_control: {
        description: "Speed advantage + faster attackers win",
        priority: 7
      }
    }
    
    #===========================================================================
    # Main Win Condition Analyzer
    #===========================================================================
    def self.identify_win_condition(battle, user, skill_level = 100)
      return nil unless skill_level >= 70
      
      conditions = []
      
      # Gather battle state info
      our_side = get_side_pokemon(battle, user, own_side: true)
      opp_side = get_side_pokemon(battle, user, own_side: false)
      
      return nil if our_side.empty? || opp_side.empty?
      
      # Check each win condition type
      conditions << check_sweep_condition(battle, our_side, opp_side, skill_level)
      conditions << check_attrition_condition(battle, our_side, opp_side, skill_level)
      conditions << check_stall_condition(battle, our_side, opp_side, skill_level)
      conditions << check_trade_condition(battle, our_side, opp_side, skill_level)
      conditions << check_setup_condition(battle, our_side, opp_side, skill_level)
      conditions << check_revenge_condition(battle, our_side, opp_side, skill_level)
      conditions << check_speed_control_condition(battle, our_side, opp_side, skill_level)
      
      # Return highest priority valid condition
      conditions.compact.max_by { |c| c[:score] }
    end
    
    #===========================================================================
    # Individual Win Condition Checks
    #===========================================================================
    
    # Sweep: One Pokemon can OHKO or 2HKO all remaining opponents
    def self.check_sweep_condition(battle, our_side, opp_side, skill_level)
      our_side.each do |mon|
        next unless mon && !mon.fainted?
        
        can_sweep = true
        sweep_score = 0
        
        opp_side.each do |opp|
          next unless opp && !opp.fainted?
          
          # Check if we can KO this opponent
          best_move = find_best_attacking_move(mon, opp)
          if best_move
            damage_percent = estimate_damage_percent(mon, opp, best_move)
            if damage_percent >= 100
              sweep_score += 30  # OHKO
            elsif damage_percent >= 50
              sweep_score += 15  # 2HKO
            else
              can_sweep = false
              break
            end
          else
            can_sweep = false
            break
          end
          
          # Check if we outspeed or have priority
          unless outspeeds?(mon, opp) || has_priority_ko?(mon, opp)
            # Can we survive a hit?
            opp_damage = estimate_max_damage_from(opp, mon)
            if opp_damage >= mon.hp
              can_sweep = false
              break
            end
          end
        end
        
        if can_sweep && sweep_score > 0
          return {
            type: :sweep,
            pokemon: mon,
            score: sweep_score + 50,
            description: "#{mon.name} can sweep remaining opponents"
          }
        end
      end
      
      nil
    end
    
    # Attrition: Hazards + Chip will win over time
    def self.check_attrition_condition(battle, our_side, opp_side, skill_level)
      return nil unless skill_level >= 75
      
      score = 0
      
      # Check hazards on opponent's side
      opp_effects = battle.sides[1].effects
      
      if opp_effects[PBEffects::StealthRock]
        opp_side.each do |opp|
          next unless opp
          effectiveness = Effectiveness.calculate(:ROCK, opp.types[0], opp.types[1])
          if Effectiveness.super_effective?(effectiveness)
            score += 20  # SR hurts them
          end
        end
      end
      
      spikes = opp_effects[PBEffects::Spikes] || 0
      score += spikes * 10
      
      toxic_spikes = opp_effects[PBEffects::ToxicSpikes] || 0
      score += toxic_spikes * 8
      
      # Check if we have hazard setters
      our_side.each do |mon|
        next unless mon && !mon.fainted?
        if mon.moves.any? { |m| m && [:STEALTHROCK, :SPIKES, :TOXICSPIKES].include?(m.id) }
          score += 15
        end
      end
      
      # Check if we have recovery
      our_side.each do |mon|
        next unless mon && !mon.fainted?
        if mon.moves.any? { |m| m && [:RECOVER, :ROOST, :SOFTBOILED, :MOONLIGHT, :SYNTHESIS, :MORNINGSUN].include?(m.id) }
          score += 20
        end
      end
      
      return nil if score < 30
      
      {
        type: :attrition,
        pokemon: nil,
        score: score,
        description: "Hazard chip damage will win over time"
      }
    end
    
    # Stall: PP stall or Toxic stall
    def self.check_stall_condition(battle, our_side, opp_side, skill_level)
      return nil unless skill_level >= 80
      
      score = 0
      stall_mon = nil
      
      our_side.each do |mon|
        next unless mon && !mon.fainted?
        
        mon_score = 0
        
        # High defenses
        if mon.defense >= 120 || mon.spdef >= 120
          mon_score += 20
        end
        
        # Recovery moves
        if mon.moves.any? { |m| m && [:RECOVER, :ROOST, :SOFTBOILED, :SLACKOFF, :MOONLIGHT, :SYNTHESIS].include?(m.id) }
          mon_score += 30
        end
        
        # Toxic for stall
        if mon.moves.any? { |m| m && m.id == :TOXIC }
          mon_score += 25
        end
        
        # Protect for Toxic stall
        if mon.moves.any? { |m| m && [:PROTECT, :DETECT, :BANEFULBUNKER, :SPIKYSHIELD].include?(m.id) }
          mon_score += 15
        end
        
        # Wish + Protect
        if mon.moves.any? { |m| m && m.id == :WISH }
          mon_score += 20
        end
        
        if mon_score > score
          score = mon_score
          stall_mon = mon
        end
      end
      
      return nil if score < 40
      
      {
        type: :stall,
        pokemon: stall_mon,
        score: score,
        description: "#{stall_mon&.name || 'Team'} can stall out opponents"
      }
    end
    
    # Trade: Numerical advantage from 1-for-1 trades
    def self.check_trade_condition(battle, our_side, opp_side, skill_level)
      our_count = our_side.count { |p| p && !p.fainted? }
      opp_count = opp_side.count { |p| p && !p.fainted? }
      
      if our_count > opp_count
        advantage = our_count - opp_count
        {
          type: :trade,
          pokemon: nil,
          score: advantage * 25 + 20,
          description: "#{advantage} Pokemon advantage - trading wins"
        }
      else
        nil
      end
    end
    
    # Setup: One setup turn wins
    def self.check_setup_condition(battle, our_side, opp_side, skill_level)
      return nil unless skill_level >= 70
      
      our_side.each do |mon|
        next unless mon && !mon.fainted?
        
        # Check for setup moves
        setup_moves = mon.moves.select do |m|
          m && [:SWORDSDANCE, :NASTYPLOT, :DRAGONDANCE, :QUIVERDANCE, :CALMMIND,
                :BULKUP, :IRONDEFENSE, :SHELLSMASH, :SHIFTGEAR, :COIL,
                :VICTORYDANCE, :FILLETAWAY, :BELLYDRUM, :AGILITY].include?(m.id)
        end
        
        next if setup_moves.empty?
        
        # Check if setup would enable sweep
        mon_stages = mon.respond_to?(:stages) ? mon.stages : {}
        current_stages = (mon_stages[:ATTACK] || 0) + (mon_stages[:SPECIAL_ATTACK] || 0)
        
        if current_stages >= 2
          # Already set up - can we sweep?
          can_clean = opp_side.all? do |opp|
            next true unless opp && !opp.fainted?
            best = find_best_attacking_move(mon, opp)
            best && estimate_damage_percent(mon, opp, best) >= 50
          end
          
          if can_clean
            return {
              type: :setup,
              pokemon: mon,
              score: 70 + (current_stages * 10),
              description: "#{mon.name} is set up and can clean"
            }
          end
        else
          # Need to set up - is there opportunity?
          return {
            type: :setup,
            pokemon: mon,
            score: 50,
            description: "#{mon.name} needs setup opportunity"
          }
        end
      end
      
      nil
    end
    
    # Revenge: Priority or faster revenge kills
    def self.check_revenge_condition(battle, our_side, opp_side, skill_level)
      return nil unless skill_level >= 65
      
      score = 0
      revenge_mons = []
      
      our_side.each do |mon|
        next unless mon && !mon.fainted?
        
        priority_moves = mon.moves.map { |m| resolve_move(m) }.compact.select do |rm|
          rm.priority > 0 && rm.damagingMove?
        end
        
        next if priority_moves.empty?
        
        # Check if priority can KO weakened opponents
        opp_side.each do |opp|
          next unless opp && !opp.fainted?
          next unless opp.hp < opp.totalhp * 0.5  # Weakened
          
          priority_moves.each do |pm|
            damage = estimate_damage_percent(mon, opp, pm)
            if damage >= (opp.hp.to_f / opp.totalhp * 100)
              score += 20
              revenge_mons << mon unless revenge_mons.include?(mon)
            end
          end
        end
      end
      
      return nil if score < 20
      
      {
        type: :revenge,
        pokemon: revenge_mons.first,
        score: score + 30,
        description: "Priority moves can secure KOs"
      }
    end
    
    # Speed Control: Win via speed advantage
    def self.check_speed_control_condition(battle, our_side, opp_side, skill_level)
      return nil unless skill_level >= 70
      
      # Check speed control active
      our_effects = battle.sides[0].effects
      
      score = 0
      
      if our_effects[PBEffects::Tailwind] && our_effects[PBEffects::Tailwind] > 0
        score += 40
      end
      
      if battle.field.effects[PBEffects::TrickRoom] && battle.field.effects[PBEffects::TrickRoom] > 0
        # Check if we benefit from TR
        our_slow = our_side.count { |m| m && !m.fainted? && m.speed < 80 }
        opp_slow = opp_side.count { |m| m && !m.fainted? && m.speed < 80 }
        
        if our_slow > opp_slow
          score += 35
        else
          score -= 20
        end
      end
      
      # Natural speed advantage
      our_fast = our_side.count { |m| m && !m.fainted? && m.speed >= 100 }
      opp_fast = opp_side.count { |m| m && !m.fainted? && m.speed >= 100 }
      
      if our_fast > opp_fast
        score += (our_fast - opp_fast) * 15
      end
      
      return nil if score < 25
      
      {
        type: :speed_control,
        pokemon: nil,
        score: score,
        description: "Speed advantage enables favorable trades"
      }
    end
    
    #===========================================================================
    # Score Modification Based on Win Condition
    #===========================================================================
    def self.apply_win_condition_bonus(battle, user, move, target, skill_level = 100)
      return 0 unless skill_level >= 70
      
      win_con = identify_win_condition(battle, user, skill_level)
      return 0 unless win_con
      
      score = 0
      
      case win_con[:type]
      when :sweep
        # Protect the sweeper, boost its moves
        if win_con[:pokemon] == user
          score += 30 if move.damagingMove?  # Attack with sweeper
        elsif win_con[:pokemon]
          # Support the sweeper
          if move.id == :HELPINGHAND
            score += 25
          end
          # Redirect attacks away from sweeper
          if [:FOLLOWME, :RAGEPOWDER].include?(move.id)
            score += 20
          end
        end
        
      when :attrition
        # Prioritize hazards
        if [:STEALTHROCK, :SPIKES, :TOXICSPIKES, :STICKYWEB].include?(move.id)
          score += 25
        end
        # Value recovery
        if [:RECOVER, :ROOST, :SOFTBOILED, :SYNTHESIS].include?(move.id)
          score += 20 if user.hp < user.totalhp * 0.6
        end
        
      when :stall
        # Prioritize status
        if move.id == :TOXIC
          score += 30 if target && !target.poisoned?
        end
        # Protect for stall
        if [:PROTECT, :DETECT].include?(move.id)
          score += 15 if user.effects[PBEffects::Toxic] && user.effects[PBEffects::Toxic] > 0
        end
        # Recovery high priority
        if [:RECOVER, :ROOST, :SOFTBOILED].include?(move.id)
          score += 25 if user.hp < user.totalhp * 0.7
        end
        
      when :trade
        # Aggressive plays
        if move.damagingMove?
          score += 15
        end
        # Don't overvalue setup when ahead
        if [:SWORDSDANCE, :NASTYPLOT, :CALMMIND].include?(move.id)
          score -= 10
        end
        
      when :setup
        # Boost setup moves for the setup mon
        if win_con[:pokemon] == user
          if [:SWORDSDANCE, :NASTYPLOT, :DRAGONDANCE, :QUIVERDANCE, :CALMMIND,
              :SHELLSMASH, :AGILITY].include?(move.id)
            user_stg = user.respond_to?(:stages) ? user.stages : {}
            score += 35 if (user_stg[:ATTACK] || 0) < 2 && (user_stg[:SPECIAL_ATTACK] || 0) < 2
          end
        end
        
      when :revenge
        # Priority moves valuable
        if move.priority > 0 && move.damagingMove?
          if target && target.hp < target.totalhp * 0.5
            score += 25
          end
        end
        
      when :speed_control
        # Maintain speed advantage
        if [:TAILWIND, :TRICKROOM].include?(move.id)
          score += 20
        end
        # Speed control attacks
        if [:ICYWIND, :ELECTROWEB, :BULLDOZE, :ROCKTOMB].include?(move.id)
          score += 15
        end
      end
      
      score
    end
    
    #===========================================================================
    # Helper Methods
    #===========================================================================
    private
    
    def self.get_side_pokemon(battle, user, own_side: true)
      if own_side
        battle.pbParty(user.index).select { |p| p && !p.fainted? }
      else
        # Get opponent's party
        opp_index = (user.index + 1) % 2
        battle.pbParty(opp_index).select { |p| p && !p.fainted? }
      end
    end
    
    def self.find_best_attacking_move(user, target)
      return nil unless user.moves
      
      best_move = nil
      best_damage = 0
      
      user.moves.each do |move|
        resolved = resolve_move(move)
        next unless resolved && resolved.damagingMove?
        
        damage = estimate_damage_percent(user, target, resolved)
        if damage > best_damage
          best_damage = damage
          best_move = resolved
        end
      end
      
      best_move
    end
    
    def self.estimate_damage_percent(user, target, move)
      move = resolve_move(move) unless move.respond_to?(:damagingMove?)
      return 0 unless move && move.damagingMove?
      
      # Get attacking stat - handle both Battler and Pokemon objects
      user_stages = user.respond_to?(:stages) ? user.stages : {}
      target_stages = target.respond_to?(:stages) ? target.stages : {}
      
      if move.physicalMove?
        atk = user.attack * stage_multiplier(user_stages[:ATTACK] || 0)
        dfn = target.defense * stage_multiplier(target_stages[:DEFENSE] || 0)
      else  # Special
        atk = user.spatk * stage_multiplier(user_stages[:SPECIAL_ATTACK] || 0)
        dfn = target.spdef * stage_multiplier(target_stages[:SPECIAL_DEFENSE] || 0)
      end
      
      dfn = [dfn, 1].max  # Prevent division by zero
      
      # Base damage calculation
      power = move.power
      return 0 if power == 0
      
      damage = ((2 * user.level / 5 + 2) * power * atk / dfn / 50 + 2)
      
      # STAB - handle both Battler (pbHasType?) and Pokemon (hasType?)
      has_stab = user.respond_to?(:pbHasType?) ? user.pbHasType?(move.type) : user.hasType?(move.type)
      if has_stab
        damage *= 1.5
      end
      
      # Type effectiveness - handle both Battler (types) and Pokemon (type1/type2)
      t1 = target.respond_to?(:types) ? target.types[0] : target.type1
      t2 = target.respond_to?(:types) ? target.types[1] : target.type2
      type_mod = Effectiveness.calculate(move.type, t1, t2)
      damage *= type_mod / Effectiveness::NORMAL_EFFECTIVE
      
      # Convert to percentage
      (damage / target.totalhp.to_f) * 100
    end
    
    def self.estimate_max_damage_from(attacker, defender)
      max_damage = 0
      
      return 0 unless attacker.moves
      
      attacker.moves.each do |move|
        resolved = resolve_move(move)
        next unless resolved && resolved.damagingMove?
        damage = estimate_damage_percent(attacker, defender, resolved)
        damage_hp = (damage / 100.0) * defender.totalhp
        max_damage = damage_hp if damage_hp > max_damage
      end
      
      max_damage
    end
    
    def self.outspeeds?(user, target)
      user_stage  = (user.respond_to?(:stages)   ? (user.stages[:SPEED]   || 0) : 0)
      target_stage = (target.respond_to?(:stages) ? (target.stages[:SPEED] || 0) : 0)
      user_speed   = user.speed * stage_multiplier(user_stage)
      target_speed = target.speed * stage_multiplier(target_stage)
      
      user_speed > target_speed
    end
    
    def self.has_priority_ko?(user, target)
      return false unless user.moves
      
      user.moves.any? do |move|
        resolved = resolve_move(move)
        next false unless resolved && resolved.priority > 0 && resolved.damagingMove?
        estimate_damage_percent(user, target, resolved) >= (target.hp.to_f / target.totalhp * 100)
      end
    end
    
    def self.stage_multiplier(stage)
      stage = stage.clamp(-6, 6)
      if stage >= 0
        (2 + stage) / 2.0
      else
        2.0 / (2 - stage)
      end
    end

    #=========================================================================
    # Move Data Resolver
    # Pokemon::Move only stores :id / :pp / :ppup — it does NOT have
    # damagingMove?, physicalMove?, type, power, or priority.
    # Battle::Move DOES, but party mons hold Pokemon::Move objects.
    # This struct bridges the gap for any code that needs those fields.
    #=========================================================================
    MoveProxy = Struct.new(:id, :type, :power, :priority, :category, keyword_init: true) do
      def damagingMove?; category == 0 || category == 1; end
      def physicalMove?; category == 0; end
      def specialMove?;  category == 1; end
      def statusMove?;   category == 2; end
    end

    # Wraps a Pokemon::Move (or Battle::Move) so callers always get the full
    # set of query methods.  Returns nil if the move data can't be resolved.
    def self.resolve_move(move)
      return move if move.respond_to?(:damagingMove?)  # Already a Battle::Move

      data = GameData::Move.get(move.id) rescue nil
      return nil unless data

      MoveProxy.new(
        id:       data.id,
        type:     data.type,
        power:    data.power || 0,
        priority: data.priority || 0,
        category: data.category  # 0 = Physical, 1 = Special, 2 = Status
      )
    end
  end
end

# API Methods
module AdvancedAI
  def self.identify_win_condition(battle, user, skill_level = 100)
    WinConditions.identify_win_condition(battle, user, skill_level)
  end
  
  def self.apply_win_condition_bonus(battle, user, move, target, skill_level = 100)
    WinConditions.apply_win_condition_bonus(battle, user, move, target, skill_level)
  end
end

AdvancedAI.log("Win Condition Identification System loaded", "WinCon")
AdvancedAI.log("  - Sweep detection", "WinCon")
AdvancedAI.log("  - Attrition/Hazard win paths", "WinCon")
AdvancedAI.log("  - Stall condition tracking", "WinCon")
AdvancedAI.log("  - Trade advantage awareness", "WinCon")
AdvancedAI.log("  - Setup sweeper protection", "WinCon")
AdvancedAI.log("  - Revenge kill opportunities", "WinCon")
AdvancedAI.log("  - Speed control advantage", "WinCon")

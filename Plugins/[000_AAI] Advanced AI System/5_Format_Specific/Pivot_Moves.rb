#===============================================================================
# Advanced AI System - Pivot Moves
# U-turn, Volt Switch, Flip Turn, Parting Shot, Teleport coordination
#===============================================================================

module AdvancedAI
  module PivotMoves
    #===========================================================================
    # Pivot Move Definitions
    #===========================================================================
    
    OFFENSIVE_PIVOTS = [:UTURN, :VOLTSWITCH, :FLIPTURN]
    DEFENSIVE_PIVOTS = [:PARTINGSHOT, :TELEPORT, :BATONPASS, :CHILLYRECEPTION]
    SLOW_PIVOTS = [:TELEPORT]  # Move last for safe switch
    
    ALL_PIVOTS = OFFENSIVE_PIVOTS + DEFENSIVE_PIVOTS
    
    #===========================================================================
    # Pivot Decision Making
    #===========================================================================
    
    # Should we pivot or stay in?
    def self.evaluate_pivot(battle, attacker, move, target, skill_level = 100)
      return 0 unless skill_level >= 60
      return 0 unless ALL_PIVOTS.include?(move.id)
      
      score = 0
      
      # Offensive pivot evaluation
      if OFFENSIVE_PIVOTS.include?(move.id)
        score += evaluate_offensive_pivot(battle, attacker, move, target, skill_level)
      end
      
      # Defensive pivot evaluation
      if DEFENSIVE_PIVOTS.include?(move.id)
        score += evaluate_defensive_pivot(battle, attacker, move, target, skill_level)
      end
      
      # Slow pivot bonus
      if SLOW_PIVOTS.include?(move.id)
        score += evaluate_slow_pivot(battle, attacker, skill_level)
      end
      
      score
    end
    
    #===========================================================================
    # Offensive Pivots (U-turn, Volt Switch, Flip Turn)
    #===========================================================================
    
    def self.evaluate_offensive_pivot(battle, attacker, move, target, skill_level)
      score = 0
      
      # === SUBSTITUTE AWARENESS ===
      # Pivot moves still switch the user out even when the target has a Sub,
      # but the damage is absorbed by the Sub instead of the target's HP.
      target_has_sub = target && target.effects[PBEffects::Substitute] &&
                       target.effects[PBEffects::Substitute] > 0
      
      # Check type effectiveness
      if target
        resolved_type = AdvancedAI::CombatUtilities.resolve_move_type(attacker, move)
        type_mod = Effectiveness.calculate(resolved_type, *target.pbTypes(true))
        
        if Effectiveness.ineffective?(type_mod)
          return -50  # Volt Switch blocked by Ground
        elsif Effectiveness.super_effective?(type_mod)
          # Reduced damage bonus when hitting into a Sub
          score += target_has_sub ? 10 : 20
        elsif Effectiveness.not_very_effective?(type_mod)
          score -= 10
        end
      end
      
      # When target has a Sub, pivoting is still valuable for the switch-out
      # even though damage is reduced — we escape a bad matchup for free
      if target_has_sub
        score += 15  # Switch-out value despite Sub absorbing damage
      end
      
      # Do we have a better switch-in available?
      switch_in = find_best_switch_in(battle, attacker, target, skill_level)
      if switch_in
        score += 25
      else
        score -= 15  # No good switch target
      end
      
      # Are we at a disadvantage?
      if target && at_type_disadvantage?(attacker, target)
        score += 30  # Get out while dealing damage
      end
      
      # Do we have momentum?
      # Pivoting maintains offensive pressure
      if is_offensive_team?(battle, attacker)
        score += 15
      end
      
      # Hazards on their side = pivot is good
      opp_side = battle.sides[1 - (attacker.index & 1)]  # opponent side (safe in doubles)
      if opp_side.effects[PBEffects::StealthRock]
        score += 10  # They take rocks on switch
      end
      
      # Hazards on our side = pivot is risky
      our_side = battle.sides[attacker.index & 1]  # own side (& 1 is safe in doubles)
      if our_side.effects[PBEffects::StealthRock]
        score -= 10  # Our switch takes rocks
      end
      
      # Check if opponent is locked into bad move
      if target && target.effects[PBEffects::ChoiceBand]
        if target.lastMoveUsed
          last_move = GameData::Move.try_get(target.lastMoveUsed)
          if last_move
            # They're locked - bring in a counter
            resolved_type = AdvancedAI::CombatUtilities.resolve_move_type(target, last_move)
            type_mod = Effectiveness.calculate(resolved_type, *attacker.pbTypes(true))
            if Effectiveness.not_very_effective?(type_mod)
              score += 20  # Pivot to something that resists better
            end
          end
        end
      end
      
      score
    end
    
    #===========================================================================
    # Defensive Pivots (Parting Shot, Teleport, Baton Pass)
    #===========================================================================
    
    def self.evaluate_defensive_pivot(battle, attacker, move, target, skill_level)
      score = 0
      
      case move.id
      when :PARTINGSHOT
        score += evaluate_parting_shot(battle, attacker, target, skill_level)
      when :TELEPORT
        score += evaluate_teleport(battle, attacker, skill_level)
      when :BATONPASS
        score += evaluate_baton_pass(battle, attacker, skill_level)
      when :CHILLYRECEPTION
        score += evaluate_chilly_reception(battle, attacker, skill_level)
      end
      
      score
    end
    
    # Parting Shot: Lower Attack + SpAtk, then switch
    def self.evaluate_parting_shot(battle, attacker, target, skill_level)
      score = 0
      
      opponents = battle.allOtherSideBattlers(attacker.index).select { |b| b && !b.fainted? }
      
      # Evaluate the actual target when provided, otherwise pick best
      targets_to_eval = target ? [target] : opponents
      
      best_target_score = targets_to_eval.map do |opp|
        ts = 0
        ts += 15 if opp.attack >= 100 || opp.spatk >= 100
        if opp.stages[:ATTACK] > -6 || opp.stages[:SPECIAL_ATTACK] > -6
          ts += 20
        else
          ts -= 30  # Already at -6
        end
        # Clear Body / White Smoke / etc. block
        if opp.hasActiveAbility?(:CLEARBODY) || opp.hasActiveAbility?(:WHITESMOKE) || opp.hasActiveAbility?(:FULLMETALBODY)
          ts -= 40
        end
        # Competitive / Defiant punish stat drops with +2 boost — NEVER use
        # Parting Shot against these; the net result buffs the opponent
        if opp.hasActiveAbility?(:COMPETITIVE) || opp.hasActiveAbility?(:DEFIANT)
          ts -= 200
        end
        # Contrary inverts drops into boosts — even worse
        if opp.hasActiveAbility?(:CONTRARY)
          ts -= 200
        end
        # Mirror Armor reflects stat drops back
        if opp.hasActiveAbility?(:MIRRORARMOR)
          ts -= 40
        end
        ts
      end.max || 0
      score += best_target_score
      
      # Need switch target
      switch_in = find_best_switch_in(battle, attacker, opponents.first, skill_level)
      if switch_in
        score += 20
      else
        score -= 25
      end
      
      score
    end
    
    # Teleport: Always moves last, safe switch
    def self.evaluate_teleport(battle, attacker, skill_level)
      score = 0
      
      # Teleport is -6 priority - we move last
      # Perfect for bringing in frail sweepers
      
      party = battle.pbParty(attacker.index & 1)
      frail_sweepers = party.count do |pkmn|
        next false unless pkmn && !pkmn.fainted? && pkmn != attacker.pokemon
        # Frail but strong
        (pkmn.attack >= 120 || pkmn.spatk >= 120) && 
        (pkmn.defense < 80 || pkmn.spdef < 80)
      end
      
      score += frail_sweepers * 20
      
      # Good if we're not doing much damage anyway
      opponents = battle.allOtherSideBattlers(attacker.index).select { |b| b && !b.fainted? }
      can_damage = opponents.any? do |opp|
        attacker.moves.any? do |m|
          next false unless m && m.damagingMove?
          resolved_type = AdvancedAI::CombatUtilities.resolve_move_type(attacker, m)
          type_mod = Effectiveness.calculate(resolved_type, *opp.pbTypes(true))
          Effectiveness.super_effective?(type_mod) || type_mod >= Effectiveness::NORMAL_EFFECTIVE_MULTIPLIER
        end
      end
      
      unless can_damage
        score += 30  # We're not threatening anyway
      end
      
      # Wish + Teleport combo
      # Wish is stored in position effects, not battler effects
      wish_val = (battle.positions[attacker.index].effects[PBEffects::Wish] rescue 0)
      if wish_val.is_a?(Numeric) && wish_val > 0
        # Wish will heal next turn - Teleport passes it
        score += 35
      end
      
      score
    end
    
    # Baton Pass: Pass stat boosts
    def self.evaluate_baton_pass(battle, attacker, skill_level)
      score = 0
      
      # Check if we have boosts to pass
      total_boosts = 0
      attacker.stages.each do |stat, stage|
        total_boosts += stage if stage > 0
      end
      
      score += total_boosts * 15
      
      # Substitute to pass?
      if attacker.effects[PBEffects::Substitute] && attacker.effects[PBEffects::Substitute] > 0
        score += 35
      end
      
      # Aqua Ring, Magnet Rise, etc.
      if attacker.effects[PBEffects::AquaRing]
        score += 20
      end
      if attacker.effects[PBEffects::MagnetRise] && attacker.effects[PBEffects::MagnetRise] > 0
        score += 25
      end
      if attacker.effects[PBEffects::Ingrain]
        score += 15
      end
      
      # Need recipient
      party = battle.pbParty(attacker.index & 1)
      recipients = party.count do |pkmn|
        next false unless pkmn && !pkmn.fainted? && pkmn != attacker.pokemon
        # Can make use of boosts
        pkmn.attack >= 100 || pkmn.spatk >= 100
      end
      
      if recipients > 0
        score += 20
      else
        score -= 30  # No one to pass to
      end
      
      score
    end
    
    # Chilly Reception: Sets Snow + switches
    def self.evaluate_chilly_reception(battle, attacker, skill_level)
      score = 0
      
      # Sets Snow weather
      effective_weather = AdvancedAI::Utilities.current_weather(battle)
      if effective_weather == :Snow || effective_weather == :Hail
        score -= 30  # Already snowy
      end
      
      # Check if team benefits from Snow
      party = battle.pbParty(attacker.index & 1)
      ice_types = party.count { |p| p && !p.fainted? && p.hasType?(:ICE) }
      score += ice_types * 15
      
      # Slush Rush users
      slush_rush = party.count { |p| p && !p.fainted? && p.ability_id == :SLUSHRUSH }
      score += slush_rush * 25
      
      # Aurora Veil enabler
      score += 20  # Snow allows Aurora Veil
      
      score
    end
    
    #===========================================================================
    # Slow Pivot Evaluation
    #===========================================================================
    
    def self.evaluate_slow_pivot(battle, attacker, skill_level)
      score = 0
      
      # Slow pivots are great for bringing in frail mons safely
      # The current mon takes the hit, then switches out
      
      # Good if we're bulky
      if attacker.defense >= 100 || attacker.spdef >= 100
        score += 20  # We can tank a hit
      end
      
      # Good if low HP (gonna faint anyway, might as well switch safely)
      hp_percent = attacker.hp.to_f / attacker.totalhp
      if hp_percent < 0.3
        score += 25
      end
      
      score
    end
    
    #===========================================================================
    # Pivot Target Selection
    #===========================================================================
    
    # Find the best Pokemon to pivot into
    def self.find_best_switch_in(battle, attacker, opponent, skill_level)
      return nil unless skill_level >= 60
      
      party = battle.pbParty(attacker.index & 1)
      
      candidates = []
      party.each do |pkmn|
        next unless pkmn && !pkmn.fainted? && pkmn != attacker.pokemon
        
        candidate_score = 0
        
        if opponent
          # Type advantage (pkmn is party Pokemon, use .types)
          pkmn_types = pkmn.types.compact
          
          # Resists opponent's STAB
          opp_stab = opponent.pbTypes(true).compact
          opp_stab.each do |opp_type|
            type_mod = Effectiveness.calculate(opp_type, *pkmn_types)
            if Effectiveness.not_very_effective?(type_mod)
              candidate_score += 20
            elsif Effectiveness.ineffective?(type_mod)
              candidate_score += 40
            end
          end
          
          # Can threaten opponent
          pkmn.moves.each do |move|
            next unless move && move.is_a?(Pokemon::Move)
            move_data = GameData::Move.try_get(move.id)
            next unless move_data
            if move_data.power > 0  # Physical or Special
              resolved_type = AdvancedAI::CombatUtilities.resolve_move_type(pkmn, move_data)
              type_mod = Effectiveness.calculate(resolved_type, *opponent.pbTypes(true))
              if Effectiveness.super_effective?(type_mod)
                candidate_score += 25
              end
            end
          end
        end
        
        # HP remaining
        hp_percent = pkmn.hp.to_f / pkmn.totalhp
        candidate_score += (hp_percent * 30).to_i
        
        candidates << { pokemon: pkmn, score: candidate_score }
      end
      
      best = candidates.max_by { |c| c[:score] }
      best && best[:score] > 20 ? best[:pokemon] : nil
    end
    
    #===========================================================================
    # Pivot vs Attack Decision
    #===========================================================================
    
    # Should we pivot or just attack?
    def self.pivot_vs_attack(battle, attacker, pivot_move, attack_move, target, skill_level = 100)
      return :attack unless skill_level >= 65
      return :pivot unless attack_move
      return :attack unless pivot_move
      
      pivot_score = evaluate_pivot(battle, attacker, pivot_move, target, skill_level)
      
      # Calculate attack value
      attack_score = 0
      if attack_move.damagingMove? && target
        resolved_type = AdvancedAI::CombatUtilities.resolve_move_type(attacker, attack_move)
        type_mod = Effectiveness.calculate(resolved_type, *target.pbTypes(true))
        
        if Effectiveness.super_effective?(type_mod)
          attack_score += 40
        end
        
        if AdvancedAI::CombatUtilities.resolve_move_power(attack_move) >= 100
          attack_score += 20
        end
        
        # Can we KO?
        estimated_damage = estimate_damage_percent(attacker, target, attack_move)
        if estimated_damage >= 100
          attack_score += 50  # KO is high value
        end
      end
      
      pivot_score > attack_score ? :pivot : :attack
    end
    
    #===========================================================================
    # Helper Methods
    #===========================================================================
    private
    
    def self.at_type_disadvantage?(user, target)
      return false unless target
      
      # Check if opponent's STAB is super effective
      target_stab = target.pbTypes(true).compact
      
      target_stab.any? do |type|
        type_mod = Effectiveness.calculate(type, *user.pbTypes(true))
        Effectiveness.super_effective?(type_mod)
      end
    end
    
    def self.is_offensive_team?(battle, attacker)
      # Heuristic: Check team composition
      party = battle.pbParty(attacker.index & 1)
      
      offensive = party.count do |pkmn|
        next false unless pkmn && !pkmn.fainted?
        pkmn.attack >= 100 || pkmn.spatk >= 100
      end
      
      offensive >= 3
    end
    
    def self.estimate_damage_percent(attacker, target, move)
      return 0 unless move && move.damagingMove?
      
      # Resolve power and type via shared helpers
      power = AdvancedAI::CombatUtilities.resolve_move_power(move)
      return 0 if power == 0
      
      effective_type = AdvancedAI::CombatUtilities.resolve_move_type(attacker, move)
      
      if move.physicalMove?
        atk = attacker.attack
        dfn = target.defense
      else
        atk = attacker.spatk
        dfn = target.spdef
      end
      
      dfn = [dfn, 1].max  # Prevent division by zero
      
      damage = ((2 * attacker.level / 5.0 + 2) * power * atk / dfn / 50 + 2)
      
      # STAB
      if attacker.pbHasType?(effective_type)
        damage *= attacker.hasActiveAbility?(:ADAPTABILITY) ? 2.0 : 1.5
      end
      
      # Huge Power / Pure Power (2x Attack for physical moves)
      if move.physicalMove? && (attacker.hasActiveAbility?(:HUGEPOWER) || attacker.hasActiveAbility?(:PUREPOWER))
        damage *= 2
      end
      
      # Type effectiveness (Scrappy/Mind's Eye: Normal/Fighting hits Ghost)
      type_mod = AdvancedAI::CombatUtilities.scrappy_effectiveness(effective_type, attacker, target.pbTypes(true))
      damage *= type_mod / Effectiveness::NORMAL_EFFECTIVE_MULTIPLIER
      
      # Field & context modifiers (weather, terrain, items, burn)
      damage *= AdvancedAI::CombatUtilities.field_modifier(nil, attacker, effective_type, move, move.physicalMove?, target)
      
      # Defender modifiers (Assault Vest, Eviolite, weather defense)
      damage *= AdvancedAI::CombatUtilities.defender_modifier(nil, target, move.physicalMove?)
      
      # Screen modifiers (Reflect / Light Screen / Aurora Veil)
      damage *= AdvancedAI::CombatUtilities.screen_modifier(nil, attacker, target, move.physicalMove?)
      
      # Parental Bond (1.25x — two hits: 100% + 25%)
      if !move.multiHitMove? && attacker.hasActiveAbility?(:PARENTALBOND)
        damage *= 1.25
      end
      
      # Ability damage modifiers (Fur Coat, Ice Scales, Multiscale, Tinted Lens, etc.)
      damage *= AdvancedAI::CombatUtilities.ability_damage_modifier(attacker, target, effective_type, move.physicalMove?, type_mod)
      
      (damage / target.totalhp.to_f) * 100
    end
  end
end

# API Methods
module AdvancedAI
  def self.evaluate_pivot(battle, attacker, move, target, skill_level = 100)
    PivotMoves.evaluate_pivot(battle, attacker, move, target, skill_level)
  end
  
  def self.find_best_switch_in(battle, attacker, opponent, skill_level = 100)
    PivotMoves.find_best_switch_in(battle, attacker, opponent, skill_level)
  end
  
  def self.pivot_vs_attack(battle, attacker, pivot_move, attack_move, target, skill_level = 100)
    PivotMoves.pivot_vs_attack(battle, attacker, pivot_move, attack_move, target, skill_level)
  end
  
  def self.is_pivot_move?(move)
    return false unless move
    PivotMoves::ALL_PIVOTS.include?(move.id)
  end
end

AdvancedAI.log("Pivot Moves System loaded", "Pivot")
AdvancedAI.log("  - U-turn / Volt Switch / Flip Turn", "Pivot")
AdvancedAI.log("  - Parting Shot evaluation", "Pivot")
AdvancedAI.log("  - Teleport (slow pivot)", "Pivot")
AdvancedAI.log("  - Baton Pass optimization", "Pivot")
AdvancedAI.log("  - Chilly Reception (Snow + pivot)", "Pivot")
AdvancedAI.log("  - Switch-in target selection", "Pivot")
AdvancedAI.log("  - Pivot vs Attack decision making", "Pivot")

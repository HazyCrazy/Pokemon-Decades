#===============================================================================
# Advanced AI System - Substitute Logic
# Sub strategies, Sub + setup combos, breaking subs
#===============================================================================

module AdvancedAI
  module SubstituteLogic
    #===========================================================================
    # When to Use Substitute
    #===========================================================================
    
    # Evaluate using Substitute
    def self.evaluate_substitute(battle, attacker, move, skill_level = 100)
      return 0 unless skill_level >= 65
      return 0 unless move.id == :SUBSTITUTE
      
      score = 0
      
      # Can we afford to make a Sub?
      if attacker.hp <= attacker.totalhp / 4
        return -100  # Can't make Sub
      end
      
      if attacker.hp <= attacker.totalhp / 2
        score -= 20  # Risky
      end
      
      # Check if we already have a Sub
      if attacker.effects[PBEffects::Substitute] && attacker.effects[PBEffects::Substitute] > 0
        return -100  # Already have Sub
      end
      
      # Good reasons to Sub
      opponents = battle.allOtherSideBattlers(attacker.index).select { |b| b && !b.fainted? }
      
      # Sub on predicted switch
      opponents.each do |opp|
        # Weak matchup for them = likely switch
        our_stab_types = get_stab_types(attacker)
        weak_to_us = our_stab_types.any? do |type|
          type_mod = Effectiveness.calculate(type, *opp.pbTypes(true))
          Effectiveness.super_effective?(type_mod)
        end
        
        if weak_to_us
          score += 30  # They might switch, free Sub
        end
      end
      
      # Sub blocks status
      status_threats = opponents.count do |opp|
        opp.moves.any? { |m| m && [:THUNDERWAVE, :WILLOWISP, :TOXIC, :SPORE, :SLEEPPOWDER, :GLARE].include?(m.id) }
      end
      if status_threats > 0 && !attacker.status
        score += 25
      end
      
      # Sub + Setup combos
      has_setup = attacker.moves.any? do |m|
        m && [:SWORDSDANCE, :NASTYPLOT, :CALMMIND, :DRAGONDANCE, :QUIVERDANCE,
              :BULKUP, :AGILITY].include?(m.id)
      end
      if has_setup
        score += 30
      end
      
      # Sub + Focus Punch
      has_focus_punch = attacker.moves.any? { |m| m && m.id == :FOCUSPUNCH }
      if has_focus_punch
        score += 40
      end
      
      # Sub + Leech Seed
      has_leech_seed = attacker.moves.any? { |m| m && m.id == :LEECHSEED }
      if has_leech_seed
        score += 25
      end
      
      # Sub + Disable/Encore
      has_disable = attacker.moves.any? { |m| m && [:DISABLE, :ENCORE].include?(m.id) }
      if has_disable
        score += 20
      end
      
      # Leftovers recovery
      if attacker.item_id == :LEFTOVERS
        score += 15
      end
      
      # Sub + Baton Pass
      has_baton = attacker.moves.any? { |m| m && m.id == :BATONPASS }
      if has_baton
        score += 35  # Pass the Sub to a sweeper
      end
      
      # Punish sound-based moves (they bypass Sub) 
      sound_users = opponents.count do |opp|
        opp.moves.any? do |m| 
          m && [:HYPERVOICE, :BOOMBURST, :BUGBUZZ, :DISARMINGVOICE, :ROUND, 
                :SNARL, :UPROAR, :CHATTER, :OVERDRIVE].include?(m.id)
        end
      end
      if sound_users > 0
        score -= 20  # They can hit through Sub
      end
      
      # Infiltrator bypasses Sub
      infiltrators = opponents.count { |opp| opp.ability_id == :INFILTRATOR }
      if infiltrators > 0
        score -= 30
      end
      
      score
    end
    
    #===========================================================================
    # Breaking Opponent's Substitute
    #===========================================================================
    
    # Evaluate moves that break Sub efficiently
    def self.evaluate_sub_breaking(battle, attacker, move, target, skill_level = 100)
      return 0 unless skill_level >= 55
      return 0 unless target
      return 0 unless target.effects[PBEffects::Substitute] && target.effects[PBEffects::Substitute] > 0
      
      score = 0
      sub_hp = target.effects[PBEffects::Substitute]
      
      # === MULTI-HIT MOVES ===
      if move.multiHitMove?
        score += 50
        
        # Skill Link guarantees 5 hits = maximum Sub breaking value
        if attacker.ability_id == :SKILLLINK
          score += 15  # 5 guaranteed hits
        end
        
        # Loaded Dice increases minimum hits
        if attacker.item_id == :LOADEDDICE
          score += 10  # More consistent multi-hits
        end
        
        # Parent Bond hits twice (breaks Sub + damages)
        if attacker.ability_id == :PARENTALBOND
          score += 20
        end
        
        return score
      end
      
      # === SOUND MOVES ===
      # Sound moves BYPASS Sub completely (no breaking needed!)
      sound_moves = [:HYPERVOICE, :BOOMBURST, :BUGBUZZ, :DISARMINGVOICE, :ROUND,
                     :SNARL, :UPROAR, :CHATTER, :OVERDRIVE, :RELICSONG, :SPARKLINGARIA,
                     :ECHOEDVOICE, :GRASSYGLIDE, :CLANGINGSCALES, :CLANGOROUSSOUL,
                     :PERISHSONG, :SING, :SUPERSONIC]
      if sound_moves.include?(move.id)
        score += 60  # Bypasses Sub entirely!
        
        # Soundproof blocks this (opponent immune)
        if target.ability_id == :SOUNDPROOF
          score -= 100  # Move fails
        end
        
        return score
      end
      
      # === INFILTRATOR ABILITY ===
      # Infiltrator bypasses Sub, screens, etc.
      if attacker.ability_id == :INFILTRATOR
        score += 55  # Bypasses Sub
        return score
      end
      
      # === SPECIFIC MOVES THAT IGNORE SUB ===
      # These moves hit through Substitute
      bypass_sub_moves = [:CURSE, :NIGHTMARE, :PAINSPLIT]
      if bypass_sub_moves.include?(move.id)
        score += 40
        return score
      end
      
      # === POWERFUL SINGLE-HIT MOVES ===
      # Check if move can break the Sub in one hit
      if move.damagingMove?
        estimated_damage = estimate_move_damage(attacker, target, move)
        
        if estimated_damage >= sub_hp * 1.5
          score += 30  # Will break Sub + deal damage to target
        elsif estimated_damage >= sub_hp
          score += 20  # Will barely break Sub
        elsif estimated_damage >= sub_hp * 0.7
          score += 5   # Might break Sub with crit/roll
        else
          score -= 15  # Won't break Sub, wasted turn
        end
      end
      
      # === STATUS MOVES ===
      # Status moves FAIL against Sub (except sound-based or specific moves)
      if move.statusMove? && !sound_moves.include?(move.id) && !bypass_sub_moves.include?(move.id)
        score -= 60  # Will fail against Sub
      end
      
      # === FEINT ===
      # Feint hits through Protect/Sub (but doesn't break it)
      if move.id == :FEINT
        score += 10  # Can chip Sub
      end
      
      # === PRIORITIZE BREAKING SUB ===
      # If Sub is low HP, breaking it is high priority
      if sub_hp < target.totalhp / 8  # Less than 12.5% HP left
        score += 15  # Easy break, high value
      end
      
      score
    end
    
    #===========================================================================
    # Specific Sub Combo Evaluations
    #===========================================================================
    
    # Sub + Focus Punch
    def self.evaluate_focus_punch(battle, attacker, move, skill_level = 100)
      return 0 unless skill_level >= 70
      return 0 unless move.id == :FOCUSPUNCH
      
      score = 0
      
      # Have Sub up = Focus Punch guaranteed
      if attacker.effects[PBEffects::Substitute] && attacker.effects[PBEffects::Substitute] > 0
        score += 60  # Safe to use Focus Punch
      else
        # Risky without Sub
        opponents = battle.allOtherSideBattlers(attacker.index).select { |b| b && !b.fainted? }
        
        # Only use if opponent will likely use status/switch
        will_attack = opponents.any? do |opp|
          opp.moves.any? { |m| m && m.damagingMove? && m.priority >= 0 }
        end
        
        if will_attack
          score -= 40  # Likely to be hit first
        else
          score += 20  # They have no damaging moves?
        end
      end
      
      score
    end
    
    # Sub + Leech Seed stall
    def self.evaluate_leech_seed_stall(battle, attacker, move, target, skill_level = 100)
      return 0 unless skill_level >= 65
      return 0 unless move.id == :LEECHSEED
      return 0 unless target
      
      score = 0
      
      # Already seeded?
      if target.effects[PBEffects::LeechSeed] && target.effects[PBEffects::LeechSeed] >= 0
        return -50  # Already seeded
      end
      
      # Grass types immune
      if target.pbHasType?(:GRASS)
        return -80  # Immune
      end
      
      # Sub + Seed combo
      if attacker.effects[PBEffects::Substitute] && attacker.effects[PBEffects::Substitute] > 0
        score += 35  # Safe behind Sub
      end
      
      # Have Sub move?
      has_sub = attacker.moves.any? { |m| m && m.id == :SUBSTITUTE }
      if has_sub
        score += 20
      end
      
      # Have Protect for stall?
      has_protect = attacker.moves.any? { |m| m && [:PROTECT, :DETECT].include?(m.id) }
      if has_protect
        score += 25
      end
      
      # Big root boosts healing
      if attacker.item_id == :BIGROOT
        score += 15
      end
      
      score
    end
    
    # Sub + Disable
    def self.evaluate_disable_combo(battle, attacker, move, target, skill_level = 100)
      return 0 unless skill_level >= 75
      return 0 unless move.id == :DISABLE
      return 0 unless target
      
      score = 0
      
      # Need to know their last move
      return 0 unless target.lastMoveUsed
      
      # Behind Sub is safer
      if attacker.effects[PBEffects::Substitute] && attacker.effects[PBEffects::Substitute] > 0
        score += 25
      end
      
      # Check what move we'd disable
      last_move = GameData::Move.try_get(target.lastMoveUsed)
      return 0 unless last_move
      
      # Disable their only SE move against us
      type_mod = Effectiveness.calculate(last_move.type, attacker.types[0], attacker.types[1])
      if Effectiveness.super_effective?(type_mod)
        score += 40  # Disable their best move vs us
      end
      
      # Disable high power move
      if last_move.power >= 100
        score += 30
      end
      
      # Count their attacking moves
      attacking_moves = target.moves.count { |m| m && m.damagingMove? }
      if attacking_moves <= 2
        score += 25  # Limiting their options significantly
      end
      
      score
    end
    
    # Sub + Baton Pass
    def self.evaluate_sub_pass(battle, attacker, move, skill_level = 100)
      return 0 unless skill_level >= 70
      return 0 unless move.id == :BATONPASS
      
      score = 0
      
      # Check if we have a Sub to pass
      if attacker.effects[PBEffects::Substitute] && attacker.effects[PBEffects::Substitute] > 0
        score += 45
        
        # Extra value if we also have stat boosts
        total_boosts = 0
        attacker.stages.each { |stat, stage| total_boosts += stage if stage > 0 }
        
        score += total_boosts * 10
      end
      
      # Check if we have recipients who want the Sub
      party = battle.pbParty(attacker.index)
      sweeper_waiting = party.any? do |pkmn|
        next false unless pkmn && !pkmn.fainted? && pkmn != attacker.pokemon
        # Frail sweepers love receiving Subs
        pkmn.hp > 0 && (pkmn.attack >= 120 || pkmn.spatk >= 120)
      end
      
      if sweeper_waiting
        score += 20
      end
      
      score
    end
    
    #===========================================================================
    # Substitute HP Management
    #===========================================================================
    
    # Track HP quarters for Sub usage
    def self.can_make_sub?(battler)
      return false unless battler
      battler.hp > battler.totalhp / 4
    end
    
    def self.subs_remaining(battler)
      return 0 unless battler
      (battler.hp / (battler.totalhp / 4)).floor
    end
    
    # Calculate if we can make Sub + survive
    def self.safe_to_sub?(battle, battler, skill_level = 100)
      return false unless can_make_sub?(battler)
      return true if skill_level < 60
      
      hp_after_sub = battler.hp - (battler.totalhp / 4)
      
      # Check if we can survive a hit after making Sub
      opponents = battle.allOtherSideBattlers(battler.index).select { |b| b && !b.fainted? }
      
      max_incoming = 0
      opponents.each do |opp|
        opp.moves.each do |move|
          next unless move && move.damagingMove?
          damage = estimate_move_damage(opp, battler, move)
          max_incoming = damage if damage > max_incoming
        end
      end
      
      hp_after_sub > max_incoming
    end
    
    #===========================================================================
    # Private Helpers
    #===========================================================================
    private
    
    def self.get_stab_types(battler)
      types = []
      types << battler.types[0] if battler.types[0]
      types << battler.types[1] if battler.types[1]
      types.compact.uniq
    end
    
    def self.estimate_move_damage(attacker, target, move)
      return 0 unless move && move.damagingMove?
      
      power = move.power
      return 0 if power == 0
      
      if move.physicalMove?
        atk = attacker.attack
        dfn = target.defense
      else
        atk = attacker.spatk
        dfn = target.spdef
      end
      
      damage = ((2 * attacker.level / 5 + 2) * power * atk / dfn / 50 + 2)
      
      # STAB
      if attacker.pbHasType?(move.type)
        damage *= 1.5
      end
      
      # Type effectiveness
      type_mod = Effectiveness.calculate(move.type, target.types[0], target.types[1])
      damage *= type_mod / Effectiveness::NORMAL_EFFECTIVE
      
      damage.to_i
    end
  end
end

# API Methods
module AdvancedAI
  def self.evaluate_substitute(battle, attacker, move, skill_level = 100)
    SubstituteLogic.evaluate_substitute(battle, attacker, move, skill_level)
  end
  
  def self.evaluate_sub_breaking(battle, attacker, move, target, skill_level = 100)
    SubstituteLogic.evaluate_sub_breaking(battle, attacker, move, target, skill_level)
  end
  
  def self.evaluate_focus_punch(battle, attacker, move, skill_level = 100)
    SubstituteLogic.evaluate_focus_punch(battle, attacker, move, skill_level)
  end
  
  def self.evaluate_leech_seed_stall(battle, attacker, move, target, skill_level = 100)
    SubstituteLogic.evaluate_leech_seed_stall(battle, attacker, move, target, skill_level)
  end
  
  def self.evaluate_sub_pass(battle, attacker, move, skill_level = 100)
    SubstituteLogic.evaluate_sub_pass(battle, attacker, move, skill_level)
  end
  
  def self.can_make_sub?(battler)
    SubstituteLogic.can_make_sub?(battler)
  end
  
  def self.safe_to_sub?(battle, battler, skill_level = 100)
    SubstituteLogic.safe_to_sub?(battle, battler, skill_level)
  end
end

AdvancedAI.log("Substitute Logic System loaded", "Sub")
AdvancedAI.log("  - Sub timing optimization", "Sub")
AdvancedAI.log("  - Sub + Focus Punch combo", "Sub")
AdvancedAI.log("  - Sub + Leech Seed stall", "Sub")
AdvancedAI.log("  - Sub + Disable/Encore", "Sub")
AdvancedAI.log("  - Sub + Baton Pass", "Sub")
AdvancedAI.log("  - Sub breaking strategies", "Sub")
AdvancedAI.log("  - Sound move / Infiltrator awareness", "Sub")

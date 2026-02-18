#===============================================================================
# Advanced AI System - Sleep Clause
# Sleep clause awareness and enforcement
#===============================================================================

module AdvancedAI
  module SleepClause
    #===========================================================================
    # Sleep Clause Logic
    #===========================================================================
    
    # Check if using a sleep move would violate sleep clause
    def self.would_violate_sleep_clause?(battle, attacker, target)
      return false unless target
      
      # Check if opponent already has a sleeping Pokemon
      opp_party = battle.pbParty((attacker.index + 1) % 2)
      
      already_asleep = opp_party.count do |pkmn|
        next false unless pkmn && !pkmn.fainted?
        # Check if asleep (not from Rest)
        pkmn.status == :SLEEP && !is_rest_sleep?(pkmn)
      end
      
      # If opponent already has a sleeping mon, don't sleep another
      already_asleep > 0
    end
    
    # Check if sleep is from Rest (Rest sleep doesn't count for clause)
    def self.is_rest_sleep?(pokemon)
      # In Essentials, Rest sets a specific sleep counter
      # If sleepCount is exactly 3, it's likely from Rest
      # This is a heuristic - actual implementation may vary
      return false unless pokemon.status == :SLEEP
      
      # Check if statusCount matches Rest's 2-turn sleep
      pokemon.statusCount == 2 || pokemon.statusCount == 3
    end
    
    # Evaluate sleep moves with clause awareness
    def self.evaluate_sleep_move(battle, attacker, move, target, skill_level = 100)
      return 0 unless skill_level >= 50
      return 0 unless target
      
      sleep_moves = [:SPORE, :SLEEPPOWDER, :HYPNOSIS, :SING, :GRASSWHISTLE,
                     :LOVELYKISS, :DARKVOID, :YAWN, :RELICSONG]
      
      return 0 unless sleep_moves.include?(move.id)
      
      score = 0
      
      # Check sleep clause
      if would_violate_sleep_clause?(battle, attacker, target)
        return -100  # Would violate clause
      end
      
      # Already asleep?
      if target.status == :SLEEP
        return -80
      end
      
      # Immune to sleep?
      if target.status != :NONE  # Already has status
        return -70
      end
      
      # Check for Vital Spirit / Insomnia / Sweet Veil / Comatose
      sleep_immune = [:VITALSPIRIT, :INSOMNIA, :SWEETVEIL, :COMATOSE]
      if sleep_immune.include?(target.ability_id)
        return -80
      end
      
      # Electric Terrain prevents sleep
      if battle.field.terrain == :Electric && target.affectedByTerrain?
        return -80
      end
      
      # Misty Terrain prevents sleep
      if battle.field.terrain == :Misty && target.affectedByTerrain?
        return -80
      end
      
      # Safety Goggles blocks powder moves
      powder_moves = [:SPORE, :SLEEPPOWDER]
      if powder_moves.include?(move.id) && target.item_id == :SAFETYGOGGLES
        return -80
      end
      
      # Grass types immune to powder
      if powder_moves.include?(move.id) && target.pbHasType?(:GRASS)
        return -80
      end
      
      # Overcoat blocks powder
      if powder_moves.include?(move.id) && target.ability_id == :OVERCOAT
        return -80
      end
      
      # Sleep is very strong - base value
      score += 60
      
      # Accuracy considerations
      case move.id
      when :SPORE
        score += 40  # 100% accuracy, best sleep move
      when :SLEEPPOWDER
        score += 15  # 75% accuracy
      when :HYPNOSIS
        score += 0   # 60% accuracy - risky
      when :SING
        score -= 10  # 55% accuracy
      when :DARKVOID
        score += 20  # Hits multiple (when legal)
      when :YAWN
        score += 10  # Delayed but guaranteed
      end
      
      # Bonus if target is a threat
      if target.attack >= 120 || target.spatk >= 120
        score += 20  # Sleep the sweeper
      end
      
      # Bonus in doubles for removing a target temporarily
      if battle.pbSideSize(0) > 1
        score += 15
      end
      
      score
    end
    
    #===========================================================================
    # Yawn Specific Logic
    #===========================================================================
    
    def self.evaluate_yawn(battle, attacker, move, target, skill_level = 100)
      return 0 unless skill_level >= 60
      return 0 unless move.id == :YAWN
      return 0 unless target
      
      score = 0
      
      # Yawn sets up forced switch or sleep
      # Check if target already drowsy
      if target.effects[PBEffects::Yawn] && target.effects[PBEffects::Yawn] > 0
        return -80  # Already drowsy
      end
      
      # Sleep clause check
      if would_violate_sleep_clause?(battle, attacker, target)
        # Yawn still forces switch even if they'd violate clause
        score += 30  # Forces switch
      else
        score += 50  # Will cause sleep or switch
      end
      
      # Yawn + Protect/hazards is strong
      has_protect = attacker.moves.any? { |m| m && [:PROTECT, :DETECT].include?(m.id) }
      if has_protect
        score += 20
      end
      
      # Hazards up means switch is punished
      opp_side = battle.sides[(attacker.index + 1) % 2]
      if opp_side.effects[PBEffects::StealthRock]
        score += 15
      end
      
      spikes = opp_side.effects[PBEffects::Spikes] || 0
      score += spikes * 5
      
      score
    end
    
    #===========================================================================
    # Anti-Sleep Strategies
    #===========================================================================
    
    # Evaluate switching to avoid sleep
    def self.evaluate_sleep_switch_in(battle, battler, skill_level = 100)
      return 0 unless skill_level >= 65
      return 0 unless battler
      
      score = 0
      
      # Check for sleep immunity
      sleep_immune = [:VITALSPIRIT, :INSOMNIA, :SWEETVEIL, :COMATOSE]
      if sleep_immune.include?(battler.ability_id)
        score += 40
      end
      
      # Safety Goggles
      if battler.item_id == :SAFETYGOGGLES
        score += 25
      end
      
      # Grass type (powder immunity)
      if battler.pbHasType?(:GRASS)
        score += 20
      end
      
      # Overcoat
      if battler.ability_id == :OVERCOAT
        score += 20
      end
      
      # Magic Bounce reflects sleep
      if battler.ability_id == :MAGICBOUNCE
        score += 35
      end
      
      score
    end
    
    # Value of Sleep Talk when asleep
    def self.evaluate_sleep_talk(battle, attacker, move, skill_level = 100)
      return 0 unless move.id == :SLEEPTALK
      
      score = 0
      
      # Sleep Talk only works when asleep
      if attacker.status == :SLEEP
        score += 50  # Can act while asleep
        
        # Better if we have good moves to call
        good_moves = attacker.moves.count do |m|
          m && m.id != :SLEEPTALK && m.damagingMove? && m.power >= 80
        end
        score += good_moves * 15
      else
        score -= 80  # Not asleep, Sleep Talk fails
      end
      
      score
    end
    
    # Rest + Sleep Talk combo
    def self.evaluate_rest_talk_combo(battle, attacker, move, skill_level = 100)
      return 0 unless skill_level >= 65
      
      score = 0
      
      if move.id == :REST
        # Check if we have Sleep Talk
        has_sleep_talk = attacker.moves.any? { |m| m && m.id == :SLEEPTALK }
        
        if has_sleep_talk
          score += 30  # RestTalk combo
          
          # Value based on HP
          hp_percent = attacker.hp.to_f / attacker.totalhp
          if hp_percent < 0.5
            score += 40
          elsif hp_percent < 0.3
            score += 60
          end
        end
      end
      
      score
    end
    
    #===========================================================================
    # Early Wake Detection
    #===========================================================================
    
    # Predict when opponent will wake up
    def self.predict_wake_turn(battler)
      return 0 unless battler && battler.status == :SLEEP
      
      # statusCount is turns remaining
      battler.statusCount
    end
    
    # Should we set up on sleeping target or attack?
    def self.evaluate_setup_on_sleeper(battle, attacker, move, target, skill_level = 100)
      return 0 unless skill_level >= 70
      return 0 unless target && target.status == :SLEEP
      
      turns_left = predict_wake_turn(target)
      
      # Setup moves while they sleep
      setup_moves = [:SWORDSDANCE, :NASTYPLOT, :DRAGONDANCE, :CALMMIND,
                     :QUIVERDANCE, :BULKUP, :AGILITY, :SHELLSMASH]
      
      if setup_moves.include?(move.id)
        if turns_left >= 2
          return 40  # Safe to set up
        elsif turns_left == 1
          return 15  # Risky
        end
      end
      
      0
    end
  end
end

# API Methods
module AdvancedAI
  def self.would_violate_sleep_clause?(battle, attacker, target)
    SleepClause.would_violate_sleep_clause?(battle, attacker, target)
  end
  
  def self.evaluate_sleep_move(battle, attacker, move, target, skill_level = 100)
    SleepClause.evaluate_sleep_move(battle, attacker, move, target, skill_level)
  end
  
  def self.evaluate_yawn(battle, attacker, move, target, skill_level = 100)
    SleepClause.evaluate_yawn(battle, attacker, move, target, skill_level)
  end
  
  def self.evaluate_sleep_switch_in(battle, battler, skill_level = 100)
    SleepClause.evaluate_sleep_switch_in(battle, battler, skill_level)
  end
  
  def self.evaluate_sleep_talk(battle, attacker, move, skill_level = 100)
    SleepClause.evaluate_sleep_talk(battle, attacker, move, skill_level)
  end
  
  def self.evaluate_rest_talk_combo(battle, attacker, move, skill_level = 100)
    SleepClause.evaluate_rest_talk_combo(battle, attacker, move, skill_level)
  end
  
  def self.predict_wake_turn(battler)
    SleepClause.predict_wake_turn(battler)
  end
  
  def self.evaluate_setup_on_sleeper(battle, attacker, move, target, skill_level = 100)
    SleepClause.evaluate_setup_on_sleeper(battle, attacker, move, target, skill_level)
  end
end

AdvancedAI.log("Sleep Clause System loaded", "Sleep")
AdvancedAI.log("  - Sleep clause enforcement", "Sleep")
AdvancedAI.log("  - Sleep move evaluation", "Sleep")
AdvancedAI.log("  - Yawn strategy", "Sleep")
AdvancedAI.log("  - Sleep immunity awareness", "Sleep")
AdvancedAI.log("  - Sleep Talk / RestTalk combos", "Sleep")
AdvancedAI.log("  - Wake prediction", "Sleep")

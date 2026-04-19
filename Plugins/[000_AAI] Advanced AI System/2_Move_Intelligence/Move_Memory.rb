#===============================================================================
# Advanced AI System - Move Memory
# Tracks all opponent moves for intelligent predictions (Reborn-inspired)
#===============================================================================

module AdvancedAI
  module MoveMemory
    # Cache for Move Memory per Battle
    @battle_memory = {}
    
    # Initializes Move Memory for a Battle
    def self.initialize_battle(battle)
      @battle_memory[battle.object_id] ||= {}
    end
    
    # Remembers a Move
    def self.remember_move(battle, battler, move)
      return unless battle && battler && move
      initialize_battle(battle)
      
      battler_key = "#{battler.index}_#{battler.pokemon.personalID}"
      @battle_memory[battle.object_id][battler_key] ||= {
        moves: [],
        move_counts: Hash.new(0),
        last_move: nil,
        priority_moves: [],
        healing_moves: [],
        setup_moves: [],
        status_moves: [],
        max_power: 0
      }
      
      memory = @battle_memory[battle.object_id][battler_key]
      move_id = move.id
      
      # Save Move
      memory[:moves] << move_id unless memory[:moves].include?(move_id)
      memory[:move_counts][move_id] += 1
      memory[:last_move] = move_id
      
      # Categorize Move (move is a Battle::Move object)
      memory[:priority_moves] << move_id if move.priority > 0 && !memory[:priority_moves].include?(move_id)
      memory[:healing_moves] << move_id if move.healingMove? && !memory[:healing_moves].include?(move_id)
      
      # Check for setup moves (stat raising)
      is_setup = move.function_code.start_with?("RaiseUser")
      memory[:setup_moves] << move_id if is_setup && !memory[:setup_moves].include?(move_id)
      
      memory[:status_moves] << move_id if move.statusMove? && !memory[:status_moves].include?(move_id)
      memory[:max_power] = [memory[:max_power], AdvancedAI::CombatUtilities.resolve_move_power(move)].max
      
      # Enhanced logging with move details
      move_type = if move.damagingMove?
                    "Damaging (#{move.power} BP)"
                  elsif move.statusMove?
                    "Status"
                  else
                    "Other"
                  end
      AdvancedAI.log("Move Memory: #{battler.name} used #{move.name} (#{move_type}) - Total uses: #{memory[:move_counts][move_id]}", "Memory")
    end
    
    # Gets Memory for a Battler
    def self.get_memory(battle, battler)
      return {} unless battle && battler
      initialize_battle(battle)
      
      # Handle both Battler/AIBattler (have .index) and Pokemon (no .index)
      if battler.respond_to?(:index)
        pkmn = battler.respond_to?(:pokemon) ? battler.pokemon : battler
        battler_key = "#{battler.index}_#{pkmn.personalID}"
      elsif battler.respond_to?(:personalID)
        # Pokemon object — search all keys for matching personalID
        pid = battler.personalID
        store = @battle_memory[battle.object_id]
        store.each do |key, val|
          return val if key.end_with?("_#{pid}")
        end
        return {}
      else
        return {}
      end
      @battle_memory[battle.object_id][battler_key] || {}
    end
    
    # Checks if Move is known
    def self.knows_move?(battle, battler, move_id)
      memory = get_memory(battle, battler)
      memory[:moves]&.include?(move_id) || false
    end
    
    # Checks if Battler has Priority Moves
    def self.has_priority_move?(battle, battler)
      memory = get_memory(battle, battler)
      !memory[:priority_moves].nil? && memory[:priority_moves].any?
    end
    
    # Checks if Battler has Healing Moves
    def self.has_healing_move?(battle, battler)
      memory = get_memory(battle, battler)
      !memory[:healing_moves].nil? && memory[:healing_moves].any?
    end
    
    # Checks if Battler has Setup Moves
    def self.has_setup_move?(battle, battler)
      memory = get_memory(battle, battler)
      !memory[:setup_moves].nil? && memory[:setup_moves].any?
    end
    
    # Gets strongest known Move
    def self.strongest_known_move(battle, battler)
      memory = get_memory(battle, battler)
      return nil if memory[:moves].nil? || memory[:moves].empty?
      
      memory[:moves].max_by do |move_id|
        data = GameData::Move.try_get(move_id)
        data ? data.power : 0
      end
    end
    
    # Estimates max damage
    def self.max_known_damage(battle, attacker, defender)
      return 0 unless attacker && defender
      memory = get_memory(battle, attacker)
      return 0 if memory[:moves].nil? || memory[:moves].empty?
      
      max_damage = 0
      
      memory[:moves].each do |move_id|
        move_data = GameData::Move.try_get(move_id)
        next unless move_data && move_data.power > 0
        
        # Simplified Damage Calculation
        bp = AdvancedAI::CombatUtilities.resolve_move_power(move_data)
        resolved_type = AdvancedAI::CombatUtilities.resolve_move_type(attacker, move_data)
        type_mod = AdvancedAI::CombatUtilities.scrappy_effectiveness(resolved_type, attacker, defender.pbTypes(true))
        stab = attacker.pbHasType?(resolved_type) ? 1.5 : 1.0
        # Adaptability: 2.0 STAB instead of 1.5
        stab = 2.0 if stab == 1.5 && attacker.hasActiveAbility?(:ADAPTABILITY)
        
        atk = move_data.category == 0 ? attacker.attack : attacker.spatk
        # Huge Power / Pure Power (2x Attack for physical moves)
        atk *= 2 if move_data.category == 0 && (attacker.hasActiveAbility?(:HUGEPOWER) || attacker.hasActiveAbility?(:PUREPOWER))
        defense = move_data.category == 0 ? defender.defense : defender.spdef
        
        damage = ((2 * attacker.level / 5.0 + 2) * bp * atk / [defense, 1].max / 50 + 2)
        damage *= type_mod * stab
        
        # Field & context modifiers (weather, terrain, items, burn)
        is_physical = move_data.category == 0
        damage *= AdvancedAI::CombatUtilities.field_modifier(battle, attacker, resolved_type, move_data, is_physical, defender)
        
        # Defender modifiers (Assault Vest, Eviolite, weather defense)
        damage *= AdvancedAI::CombatUtilities.defender_modifier(battle, defender, is_physical)
        
        # Screen modifiers (Reflect / Light Screen / Aurora Veil)
        damage *= AdvancedAI::CombatUtilities.screen_modifier(battle, attacker, defender, is_physical)
        
        # Parental Bond (1.25x — two hits: 100% + 25%)
        if attacker.hasActiveAbility?(:PARENTALBOND)
          damage *= 1.25
        end
        
        # Ability damage modifiers (Fur Coat, Ice Scales, Multiscale, Tinted Lens, etc.)
        damage *= AdvancedAI::CombatUtilities.ability_damage_modifier(attacker, defender, resolved_type, is_physical, type_mod)
        
        max_damage = [max_damage, damage.to_i].max
      end
      
      max_damage
    end
    
    # Gets last Move
    def self.last_move(battle, battler)
      memory = get_memory(battle, battler)
      memory[:last_move]
    end
    
    # Gets Move Frequency
    def self.move_frequency(battle, battler, move_id)
      memory = get_memory(battle, battler)
      memory[:move_counts]&.[](move_id) || 0
    end
    
    # Cleanup after Battle
    def self.cleanup_battle(battle)
      @battle_memory.delete(battle.object_id) if battle
    end
  end
end

# Integration in Battle
class Battle
  alias aai_memory_pbEndOfBattle pbEndOfBattle
  def pbEndOfBattle
    AdvancedAI::MoveMemory.cleanup_battle(self)
    aai_memory_pbEndOfBattle
  end
end

# Integration in Move Usage
class Battle::Battler
  # Hook pbUseMoveSimple for called/copied moves (Metronome, Mirror Move, etc.)
  alias aai_memory_pbUseMoveSimple pbUseMoveSimple
  def pbUseMoveSimple(move_id, target = -1, idx = -1, specialUsage = true)
    # Remember Move for ALL battlers (player AND AI)
    # This is needed for move repetition penalties and advanced AI strategies
    actual_move = (idx >= 0 && @moves[idx]) ? @moves[idx] : @moves.find { |m| m&.id == move_id }
    # For called moves not in moveset, create a temporary move object
    if !actual_move
      actual_move = Battle::Move.from_pokemon_move(@battle, Pokemon::Move.new(move_id)) rescue nil
    end
    AdvancedAI::MoveMemory.remember_move(@battle, self, actual_move) if actual_move
    
    aai_memory_pbUseMoveSimple(move_id, target, idx, specialUsage)
  end
  
  # Hook pbUseMove for normal battle moves (the main move execution path)
  alias aai_memory_pbUseMove pbUseMove
  def pbUseMove(choice, specialUsage = false)
    move = choice[2]
    AdvancedAI::MoveMemory.remember_move(@battle, self, move) if move
    aai_memory_pbUseMove(choice, specialUsage)
  end
end

# API Wrapper for simple access
module AdvancedAI
  def self.get_memory(battle, battler)
    MoveMemory.get_memory(battle, battler)
  end
  
  def self.knows_move?(battle, battler, move_id)
    MoveMemory.knows_move?(battle, battler, move_id)
  end
  
  def self.has_priority_move?(battle, battler)
    MoveMemory.has_priority_move?(battle, battler)
  end
  
  def self.has_healing_move?(battle, battler)
    MoveMemory.has_healing_move?(battle, battler)
  end
  
  def self.has_setup_move?(battle, battler)
    MoveMemory.has_setup_move?(battle, battler)
  end
  
  def self.strongest_known_move(battle, battler)
    MoveMemory.strongest_known_move(battle, battler)
  end
  
  def self.max_known_damage(battle, attacker, defender)
    MoveMemory.max_known_damage(battle, attacker, defender)
  end
  
  def self.last_move(battle, battler)
    MoveMemory.last_move(battle, battler)
  end
  
  def self.move_frequency(battle, battler, move_id)
    MoveMemory.move_frequency(battle, battler, move_id)
  end
end

AdvancedAI.log("Move Memory System loaded (Reborn-inspired)", "Memory")

#===============================================================================
# Integration in Battle::AI - Wires move memory into scoring pipeline
#===============================================================================
class Battle::AI
  def apply_move_memory(score, move, user, target)
    return score unless move && target
    
    # Penalize overly repetitive moves (predictable play)
    freq = AdvancedAI.move_frequency(@battle, user, move.id)
    if freq >= 3
      score -= 10  # Slight penalty for using same move 3+ times
    end
    
    # If we know the opponent has a priority move, slight boost to bulky plays
    if AdvancedAI.has_priority_move?(@battle, target)
      if AdvancedAI.protect_move?(move.id)
        score += 10  # Protect is good against priority users
      end
    end
    
    # If opponent has healing, boost status/setup over weak attacks
    if AdvancedAI.has_healing_move?(@battle, target)
      if move.damagingMove? && AdvancedAI::CombatUtilities.resolve_move_power(move) < 60
        score -= 10  # Weak attacks get outhealed
      end
      if AdvancedAI.setup_move?(move.id)
        score += 5  # Setup to overpower healing
      end
    end
    
    return score
  end
end

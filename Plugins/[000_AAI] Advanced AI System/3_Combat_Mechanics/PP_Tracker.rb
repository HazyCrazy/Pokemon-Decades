#===============================================================================
# Advanced AI System - PP Tracker
# Tracks PP usage, Pressure ability, and Struggle prediction
#===============================================================================

module AdvancedAI
  module PPTracker
    # PP tracking cache per battle
    @pp_cache = {}
    @battle_id = nil
    
    #===========================================================================
    # PP Tracking Core
    #===========================================================================
    
    # Initialize PP tracking for a new battle
    def self.init_tracking(battle)
      battle_hash = battle.object_id
      return if @battle_id == battle_hash
      
      @battle_id = battle_hash
      @pp_cache = {}
      
      # Initialize all battlers
      battle.allBattlers.each do |battler|
        next unless battler
        init_battler_pp(battler)
      end
    end
    
    # Initialize PP for a battler
    def self.init_battler_pp(battler)
      return unless battler && battler.pokemon
      
      key = battler_key(battler)
      @pp_cache[key] ||= {}
      
      battler.moves.each do |move|
        next unless move
        # Assume max PP unless we've tracked usage
        @pp_cache[key][move.id] ||= {
          max_pp: move.total_pp,
          current_pp: move.total_pp,
          times_used: 0
        }
      end
    end
    
    # Record a move being used
    def self.record_move_use(battle, battler, move)
      return unless battler && move
      
      init_tracking(battle)
      init_battler_pp(battler)
      
      key = battler_key(battler)
      return unless @pp_cache[key]
      
      # Calculate PP drain
      drain = 1
      
      # Check for Pressure ability on opponents
      battle.allOtherSideBattlers(battler.index).each do |opp|
        next unless opp && !opp.fainted?
        if opp.ability_id == :PRESSURE
          drain += 1  # Pressure doubles PP usage
        end
      end
      
      # Update PP
      if @pp_cache[key][move.id]
        @pp_cache[key][move.id][:times_used] += 1
        @pp_cache[key][move.id][:current_pp] = 
          [@pp_cache[key][move.id][:current_pp] - drain, 0].max
      else
        # New move we haven't seen
        move_data = GameData::Move.try_get(move.id)
        max_pp = move_data ? move_data.total_pp : 10
        @pp_cache[key][move.id] = {
          max_pp: max_pp,
          current_pp: [max_pp - drain, 0].max,
          times_used: 1
        }
      end
    end
    
    # Get estimated remaining PP for a move
    def self.get_remaining_pp(battler, move_id)
      return nil unless battler
      
      key = battler_key(battler)
      return nil unless @pp_cache[key] && @pp_cache[key][move_id]
      
      @pp_cache[key][move_id][:current_pp]
    end
    
    # Check if move is likely out of PP
    def self.move_out_of_pp?(battler, move_id)
      pp = get_remaining_pp(battler, move_id)
      pp && pp <= 0
    end
    
    # Get all moves that are low on PP
    def self.get_low_pp_moves(battler, threshold = 2)
      return [] unless battler
      
      key = battler_key(battler)
      return [] unless @pp_cache[key]
      
      low_pp = []
      @pp_cache[key].each do |move_id, data|
        if data[:current_pp] <= threshold
          low_pp << { move_id: move_id, pp: data[:current_pp] }
        end
      end
      
      low_pp
    end
    
    # Check if battler is likely to Struggle soon
    def self.will_struggle_soon?(battler, turns = 3)
      return false unless battler
      
      key = battler_key(battler)
      return false unless @pp_cache[key]
      
      total_remaining_pp = 0
      @pp_cache[key].each do |move_id, data|
        total_remaining_pp += data[:current_pp]
      end
      
      total_remaining_pp <= turns
    end
    
    # Check if battler is currently forced to Struggle
    def self.must_struggle?(battler)
      return false unless battler
      
      key = battler_key(battler)
      return false unless @pp_cache[key]
      
      @pp_cache[key].all? { |move_id, data| data[:current_pp] <= 0 }
    end
    
    #===========================================================================
    # Pressure Ability Awareness
    #===========================================================================
    
    # Calculate effective PP drain rate
    def self.get_pp_drain_rate(battle, battler)
      drain = 1
      
      battle.allOtherSideBattlers(battler.index).each do |opp|
        next unless opp && !opp.fainted?
        if opp.ability_id == :PRESSURE
          drain += 1
        end
      end
      
      drain
    end
    
    # Calculate turns until move runs out
    def self.turns_until_pp_out(battle, battler, move_id)
      pp = get_remaining_pp(battler, move_id)
      return 999 unless pp
      
      drain = get_pp_drain_rate(battle, battler)
      return 999 if drain <= 0  # Guard against division by zero
      (pp / drain.to_f).ceil
    end
    
    # Pressure stall strategy - target low PP moves
    def self.evaluate_pressure_stall(battle, attacker, target, skill_level = 100)
      return 0 unless skill_level >= 75
      return 0 unless target
      
      score = 0
      
      # Check if we have Pressure
      if attacker.ability_id == :PRESSURE
        low_pp = get_low_pp_moves(target, 5)
        score += low_pp.length * 10
        
        # Bonus if they have low PP threats
        low_pp.each do |lp|
          move_data = GameData::Move.try_get(lp[:move_id])
          if move_data && move_data.power >= 80
            score += 15  # Their strong moves are running low
          end
        end
        
        # Extra bonus if they'll Struggle soon
        if will_struggle_soon?(target, 5)
          score += 30
        end
      end
      
      # Check if opponent has Pressure (we need to conserve PP)
      if target.ability_id == :PRESSURE
        # Prefer high PP moves
        attacker.moves.each_with_index do |move, i|
          next unless move
          pp = get_remaining_pp(attacker, move.id)
          if pp && pp <= 3
            score -= 20  # We're running low on this move
          end
        end
      end
      
      score
    end
    
    #===========================================================================
    # PP Conservation Strategies
    #===========================================================================
    
    # Should we conserve PP on this move?
    def self.should_conserve_pp?(battle, attacker, move, skill_level = 100)
      return false unless skill_level >= 65
      return false unless move
      
      remaining = get_remaining_pp(attacker, move.id)
      return false unless remaining
      
      # Low PP moves need conservation
      if remaining <= 3
        # Exception: If it's the only move that can hit the target
        return false if only_viable_move?(attacker, move)
        return true
      end
      
      # Check Pressure impact
      drain = get_pp_drain_rate(battle, attacker)
      if drain >= 2 && remaining <= 6
        return true  # Pressure draining fast
      end
      
      false
    end
    
    # Penalty for using low PP moves unnecessarily
    def self.apply_pp_conservation_penalty(battle, attacker, move, skill_level = 100)
      return 0 unless skill_level >= 65
      return 0 unless move
      
      remaining = get_remaining_pp(attacker, move.id)
      return 0 unless remaining
      
      penalty = 0
      
      if remaining <= 2
        penalty -= 40  # Very low - save for critical moment
      elsif remaining <= 5
        penalty -= 15  # Getting low
      end
      
      # Adjust by move importance
      if move.power >= 100
        penalty /= 2  # Strong moves are worth using
      end
      
      penalty
    end
    
    #===========================================================================
    # Move Selection Based on PP
    #===========================================================================
    
    # Boost high PP alternatives when low on main move
    def self.suggest_pp_alternative(battle, attacker, move, skill_level = 100)
      return 0 unless skill_level >= 60
      return 0 unless move
      
      main_pp = get_remaining_pp(attacker, move.id)
      return 0 unless main_pp && main_pp <= 3
      
      # Look for alternatives
      alternatives = []
      attacker.moves.each do |alt_move|
        next unless alt_move && alt_move.id != move.id
        next unless alt_move.damagingMove? == move.damagingMove?
        
        alt_pp = get_remaining_pp(attacker, alt_move.id)
        next unless alt_pp && alt_pp > 5
        
        # Same type/similar function
        if alt_move.type == move.type
          alternatives << alt_move
        end
      end
      
      alternatives.empty? ? 0 : 15
    end
    
    #===========================================================================
    # Low PP Move Detection (inherently scarce moves)
    #===========================================================================
    
    LOW_PP_MOVES = {
      # 5 PP moves
      FOCUSBLAST: 5, STONEEDGE: 5, FIREBLAST: 5, HYDROPUMP: 5, BLIZZARD: 5,
      THUNDER: 5, MEGAHORN: 5, DRAGONPULSE: 5, METEORMASH: 5, CLOSECOMBAT: 5,
      OUTRAGE: 5, PETALBLIZZARD: 5, OVERHEAT: 5, LEAFSTORM: 5, DRACOMETEOR: 5,
      PSYCHOBOOST: 5, FLEURCANNON: 5, CLANGINGSCALES: 5,
      # 8 PP moves
      EARTHQUAKE: 10, ICEBEAM: 10, THUNDERBOLT: 10, FLAMETHROWER: 10
    }
    
    def self.is_low_pp_move?(move)
      return false unless move
      move_data = GameData::Move.try_get(move.id)
      return false unless move_data
      
      move_data.total_pp <= 8
    end
    
    #===========================================================================
    # Prediction: What move will they use if low on PP?
    #===========================================================================
    
    def self.predict_forced_move(battle, battler, skill_level = 100)
      return nil unless skill_level >= 80
      return nil unless battler
      
      key = battler_key(battler)
      return nil unless @pp_cache[key]
      
      # Find moves with PP remaining
      usable_moves = []
      @pp_cache[key].each do |move_id, data|
        if data[:current_pp] > 0
          usable_moves << move_id
        end
      end
      
      # If only one usable move, we know what they'll use
      if usable_moves.length == 1
        return usable_moves.first
      end
      
      nil
    end
    
    #===========================================================================
    # Private Helpers
    #===========================================================================
    private
    
    def self.battler_key(battler)
      # Unique key combining side and species
      "#{battler.index}_#{battler.species}"
    end
    
    def self.only_viable_move?(attacker, move)
      return true unless attacker.moves
      
      attacker.moves.count do |m|
        m && m.id != move.id && get_remaining_pp(attacker, m.id).to_i > 0
      end == 0
    end
  end
end

# API Methods
module AdvancedAI
  def self.init_pp_tracking(battle)
    PPTracker.init_tracking(battle)
  end
  
  def self.record_pp_use(battle, battler, move)
    PPTracker.record_move_use(battle, battler, move)
  end
  
  def self.get_remaining_pp(battler, move_id)
    PPTracker.get_remaining_pp(battler, move_id)
  end
  
  def self.will_struggle_soon?(battler, turns = 3)
    PPTracker.will_struggle_soon?(battler, turns)
  end
  
  def self.must_struggle?(battler)
    PPTracker.must_struggle?(battler)
  end
  
  def self.evaluate_pressure_stall(battle, attacker, target, skill_level = 100)
    PPTracker.evaluate_pressure_stall(battle, attacker, target, skill_level)
  end
  
  def self.apply_pp_conservation(battle, attacker, move, skill_level = 100)
    PPTracker.apply_pp_conservation_penalty(battle, attacker, move, skill_level)
  end
  
  def self.predict_forced_move(battle, battler, skill_level = 100)
    PPTracker.predict_forced_move(battle, battler, skill_level)
  end
end

AdvancedAI.log("PP Tracker System loaded", "PP")
AdvancedAI.log("  - Move PP usage tracking", "PP")
AdvancedAI.log("  - Pressure ability awareness", "PP")
AdvancedAI.log("  - Struggle prediction", "PP")
AdvancedAI.log("  - PP conservation strategies", "PP")
AdvancedAI.log("  - Low PP move detection", "PP")

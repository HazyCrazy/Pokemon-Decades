#===============================================================================
# [021] Battle Personalities - 4 AI Playstyles
#===============================================================================
# Defines 4 different Battle Personalities for diversified AI
#
# Personalities:
# 1. AGGRESSIVE - Max Damage, Risky Plays
# 2. DEFENSIVE - Stalling, Walls, Recovery
# 3. BALANCED - Mix of Offense/Defense
# 4. HYPER_OFFENSIVE - Setup Sweeps, All-or-Nothing
#===============================================================================

module AdvancedAI
  module BattlePersonalities
    
    #===========================================================================
    # Personality Definitions
    #===========================================================================
    
    PERSONALITIES = {
      :aggressive => {
        name: "Aggressive",
        description: "Prefers max damage and risky plays",
        modifiers: {
          damage_bonus: 25,          # +25 for Damage Moves
          setup_penalty: -20,        # -20 for Setup (too slow)
          healing_penalty: -30,      # -30 for Healing (defensive = bad)
          priority_bonus: 15,        # +15 for Priority Moves
          ohko_bonus: 40,            # +40 for OHKO Moves (risky but strong)
          switch_threshold: 55,      # Higher threshold = fewer Switches
        }
      },
      
      :defensive => {
        name: "Defensive",
        description: "Prefers Stalling, Walls and Recovery",
        modifiers: {
          damage_bonus: -10,         # -10 for Damage (not priority)
          setup_bonus: 20,           # +20 for Setup (play for time)
          healing_bonus: 40,         # +40 for Healing
          status_bonus: 30,          # +30 for Status Moves (Burn/Para)
          protect_bonus: 35,         # +35 for Protect (stalling)
          hazard_bonus: 25,          # +25 for Hazards
          switch_threshold: 35,      # Low threshold = more Switches
        }
      },
      
      :balanced => {
        name: "Balanced",
        description: "Balanced mix of Offense and Defense",
        modifiers: {
          damage_bonus: 10,          # +10 for Damage
          setup_bonus: 10,           # +10 for Setup
          healing_bonus: 15,         # +15 for Healing
          status_bonus: 15,          # +15 for Status
          switch_threshold: 45,      # Medium
        }
      },
      
      :hyper_offensive => {
        name: "Hyper Offensive",
        description: "Setup Sweeps, All-or-Nothing strategy",
        modifiers: {
          damage_bonus: 15,          # +15 for Damage
          setup_bonus: 50,           # +50 for Setup (extreme priority)
          healing_penalty: -40,      # -40 for Healing (waste of time)
          protect_bonus: 30,         # +30 for Protect (secure Setup)
          spread_bonus: 20,          # +20 for Spread Moves (Doubles sweep)
          ohko_penalty: -20,         # -20 for OHKO (Setup better)
          switch_threshold: 60,      # Very high = almost never switch
        }
      }
    }
    
    #===========================================================================
    # Personality Detection (based on Pokemon Team)
    #===========================================================================
    
    # Detects best Personality for Trainer
    def self.detect_personality(battle, trainer_index)
      return :balanced if !battle
      
      party = battle.pbParty(trainer_index)
      return :balanced if !party || party.empty?
      
      # Count Pokemon Roles
      sweeper_count = 0
      wall_count = 0
      tank_count = 0
      support_count = 0
      
      party.each do |pokemon|
        next if !pokemon || pokemon.egg?
        
        roles = AdvancedAI.detect_roles(pokemon)
        next if !roles
        
        sweeper_count += 1 if roles.include?(:sweeper)
        wall_count += 1 if roles.include?(:wall)
        tank_count += 1 if roles.include?(:tank)
        support_count += 1 if roles.include?(:support)
      end
      
      total = party.count { |p| p && !p.egg? }
      
      # Hyper Offensive: Many Sweepers + Setup
      if sweeper_count >= total * 0.6
        setup_count = 0
        party.each do |pokemon|
          next if !pokemon
          pokemon.moves.each do |move|
            setup_count += 1 if AdvancedAI.setup_move?(move.id)
          end
        end
        return :hyper_offensive if setup_count >= 4
      end
      
      # Defensive: Many Walls + Recovery
      if wall_count >= total * 0.5
        return :defensive
      end
      
      # Aggressive: High Damage, little Setup
      if sweeper_count >= total * 0.4 && wall_count <= 1
        return :aggressive
      end
      
      # Default: Balanced
      return :balanced
    end
    
    #===========================================================================
    # Apply Personality Modifiers
    #===========================================================================
    
    #===========================================================================
    # Apply Personality Modifiers
    #===========================================================================
    
    # Applies Personality to Move Score
    def self.apply_personality(score, move, personality)
      return score if !move || !personality
      return score if !PERSONALITIES.key?(personality)
      
      modifiers = PERSONALITIES[personality][:modifiers]
      return score if !modifiers
      
      # Damage Moves
      if move.category == :Physical || move.category == :Special
        score += modifiers[:damage_bonus] if modifiers[:damage_bonus]
      end
      
      # Setup Moves
      if AdvancedAI.setup_move?(move.id)
        score += modifiers[:setup_bonus] if modifiers[:setup_bonus]
        score += modifiers[:setup_penalty] if modifiers[:setup_penalty]
      end
      
      # Healing Moves
      if AdvancedAI.healing_move?(move.id)
        score += modifiers[:healing_bonus] if modifiers[:healing_bonus]
        score += modifiers[:healing_penalty] if modifiers[:healing_penalty]
      end
      
      # Status Moves
      if move.category == :Status && !AdvancedAI.setup_move?(move.id) && !AdvancedAI.healing_move?(move.id)
        score += modifiers[:status_bonus] if modifiers[:status_bonus]
      end
      
      # Priority Moves
      if move.priority > 0
        score += modifiers[:priority_bonus] if modifiers[:priority_bonus]
      end
      
      # OHKO Moves
      if AdvancedAI.ohko_move?(move.id)
        score += modifiers[:ohko_bonus] if modifiers[:ohko_bonus]
        score += modifiers[:ohko_penalty] if modifiers[:ohko_penalty]
      end
      
      # Protect Moves
      if AdvancedAI.protect_move?(move.id)
        score += modifiers[:protect_bonus] if modifiers[:protect_bonus]
      end
      
      # Hazard Moves
      if AdvancedAI.hazard_move?(move.id)
        score += modifiers[:hazard_bonus] if modifiers[:hazard_bonus]
      end
      
      # Spread Moves
      if AdvancedAI.spread_move?(move.id)
        score += modifiers[:spread_bonus] if modifiers[:spread_bonus]
      end
      
      return score
    end
    
    # Returns Switch Threshold for Personality
    def self.get_switch_threshold(personality)
      return 45 if !personality || !PERSONALITIES.key?(personality)
      
      modifiers = PERSONALITIES[personality][:modifiers]
      return modifiers[:switch_threshold] || 45
    end
    
    #===========================================================================
    # Personality Descriptions
    #===========================================================================
    
    # Returns Personality Name
    def self.get_name(personality)
      return "Balanced" if !personality || !PERSONALITIES.key?(personality)
      return PERSONALITIES[personality][:name]
    end
    
    # Returns Personality Description
    def self.get_description(personality)
      return "" if !personality || !PERSONALITIES.key?(personality)
      return PERSONALITIES[personality][:description]
    end
    
    #===========================================================================
    # Personality Override (for Event Battles)
    #===========================================================================
    
    # Manual Personality Assignment
    @personality_overrides = {}
    
    def self.set_personality(trainer_name, personality)
      return if !trainer_name || !personality
      return if !PERSONALITIES.key?(personality)
      
      @personality_overrides[trainer_name] = personality
      AdvancedAI.log("[Personality] Set #{trainer_name} to #{get_name(personality)}", :personality)
    end
    
    def self.get_personality(battle, trainer_index)
      return :balanced if !battle
      
      # Check override
      trainer = battle.pbGetOwnerFromBattlerIndex(trainer_index)
      if trainer && @personality_overrides[trainer.name]
        return @personality_overrides[trainer.name]
      end
      
      # Auto-detect
      return detect_personality(battle, trainer_index)
    end
    
  end
end

#===============================================================================
# API Wrapper
#===============================================================================
module AdvancedAI
  def self.detect_personality(battle, trainer_index)
    BattlePersonalities.detect_personality(battle, trainer_index)
  end
  
  def self.apply_personality(score, move, personality)
    BattlePersonalities.apply_personality(score, move, personality)
  end
  
  def self.get_personality(battle, trainer_index)
    BattlePersonalities.get_personality(battle, trainer_index)
  end
  
  def self.set_personality(trainer_name, personality)
    BattlePersonalities.set_personality(trainer_name, personality)
  end
  
  def self.get_personality_switch_threshold(personality)
    BattlePersonalities.get_switch_threshold(personality)
  end
end

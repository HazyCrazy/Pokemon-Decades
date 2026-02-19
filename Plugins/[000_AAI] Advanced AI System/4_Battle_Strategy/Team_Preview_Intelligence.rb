#===============================================================================
# [017] Team Preview Intelligence - Optimal Lead Selection
#===============================================================================
# Selects optimal Lead based on Opponent Team (Team Preview)
#
# Features:
# - Lead Role Detection (Hazards, Fast Attacker, Weather Setter, etc.)
# - Matchup Analysis (which Lead is best?)
# - Anti-Lead Counter (Opponent has Fake Out? → Ghost Lead)
# - Team Synergy (Does Lead fit the rest of the team?)
#===============================================================================

module AdvancedAI
  module TeamPreviewIntelligence
    
    #===========================================================================
    # Lead Role Detection
    #===========================================================================
    
    LEAD_ROLES = {
      :hazard_lead => {
        description: "Sets Stealth Rock/Spikes",
        priority: 80,
        requires: [:hazard_moves, :decent_speed_or_focus_sash]
      },
      
      :weather_lead => {
        description: "Sets Weather for Team",
        priority: 85,
        requires: [:weather_ability_or_move, :team_benefits_from_weather]
      },
      
      :terrain_lead => {
        description: "Sets Terrain for Team",
        priority: 85,
        requires: [:terrain_ability_or_move, :team_benefits_from_terrain]
      },
      
      :fast_attacker => {
        description: "Fast Attacker for early pressure",
        priority: 70,
        requires: [:high_speed, :high_attack_or_spatk]
      },
      
      :fake_out_lead => {
        description: "Fake Out for Momentum",
        priority: 75,
        requires: [:fake_out_move]
      },
      
      :anti_lead => {
        description: "Counters typical Leads (Taunt, etc.)",
        priority: 75,
        requires: [:taunt_or_fast_attack, :high_speed]
      },
      
      :screen_setter => {
        description: "Sets Screens for Setup Sweepers",
        priority: 70,
        requires: [:screen_moves, :team_has_setup_sweepers]
      },
      
      :suicide_lead => {
        description: "Explosion/Hazards then dies",
        priority: 60,
        requires: [:explosion_or_hazards, :focus_sash_or_sturdy]
      }
    }
    
    #===========================================================================
    # Lead Selection
    #===========================================================================
    
    # Selects best Lead for Team
    def self.select_best_lead(battle, party, opponent_party)
      return 0 if !battle || !party || party.empty?
      
      best_lead_index = 0
      best_score = 0
      
      party.each_with_index do |pokemon, i|
        next if !pokemon || pokemon.fainted? || pokemon.egg?
        
        score = evaluate_lead(battle, pokemon, party, opponent_party)
        
        if score > best_score
          best_score = score
          best_lead_index = i
        end
      end
      
      AdvancedAI.log("[Team Preview] Best lead: #{party[best_lead_index].name} (Score: #{best_score})", :team_preview)
      return best_lead_index
    end
    
    # Evaluates Pokemon as Lead
    def self.evaluate_lead(battle, pokemon, party, opponent_party)
      return 0 if !pokemon
      
      score = 50  # Base score
      
      # 1. Lead Role Detection
      roles = detect_lead_roles(pokemon, party)
      roles.each do |role|
        score += LEAD_ROLES[role][:priority] if LEAD_ROLES.key?(role)
      end
      
      # 2. Matchup vs Opponent Team
      if opponent_party
        matchup_score = analyze_matchups(pokemon, opponent_party)
        score += matchup_score
      end
      
      # 3. Speed Tier (faster = better as Lead)
      if pokemon.speed >= 100
        score += 20
      elsif pokemon.speed >= 80
        score += 10
      elsif pokemon.speed < 50
        score -= 15  # Slow = worse Lead
      end
      
      # 4. Item Synergy
      item = pokemon.item_id
      if item
        score += 15 if item == :FOCUSSASH      # Survivability
        score += 10 if item == :HEATROCK       # Weather extend
        score += 10 if item == :DAMPROCK
        score += 10 if item == :SMOOTHROCK
        score += 10 if item == :ICYROCK
        score += 12 if item == :LIGHTCLAY      # Screen extend
        score -= 10 if item == :CHOICEBAND     # Locked = risky as Lead
        score -= 10 if item == :CHOICESPECS
      end
      
      # 5. Hazard Immunity (party Pokemon uses ability_id)
      if pokemon.hasType?(:FLYING) || pokemon.ability_id == :LEVITATE
        score += 8  # Partially immune to Stealth Rock/Spikes
      end
      
      if pokemon.item_id == :HEAVYDUTYBOOTS
        score += 12  # Full Hazard Immunity
      end
      
      # 6. Anti-Lead Capabilities
      pokemon.moves.each do |move|
        next if !move
        
        case move.id
        when :TAUNT
          score += 25  # Stops Hazard Leads
        when :FAKEOUT
          score += 20  # Momentum control
        when :MAGICCOAT
          score += 15  # Reflects hazards
        when :RAPIDSPIN, :DEFOG
          score += 10  # Can remove Hazards
        end
      end
      
      return score
    end
    
    #===========================================================================
    # Lead Role Detection for Pokemon
    #===========================================================================
    
    def self.detect_lead_roles(pokemon, party)
      return [] if !pokemon
      
      roles = []
      
      # Hazard Lead
      has_hazards = pokemon.moves.any? { |m| m && AdvancedAI.hazard_move?(m.id) }
      if has_hazards
        roles << :hazard_lead
      end
      
      # Weather Lead
      weather_ability = [:DROUGHT, :DRIZZLE, :SANDSTREAM, :SNOWWARNING].include?(pokemon.ability)
      weather_move = pokemon.moves.any? { |m| m && [:SUNNYDAY, :RAINDANCE, :SANDSTORM, :HAIL, :SNOWSCAPE].include?(m.id) }
      if weather_ability || weather_move
        # Check if team benefits
        team_benefits = party.any? { |p| p && AdvancedAI.benefits_from_weather?(p, get_weather_type(pokemon)) }
        roles << :weather_lead if team_benefits
      end
      
      # Terrain Lead
      terrain_ability = [:ELECTRICSURGE, :GRASSYSURGE, :MISTYSURGE, :PSYCHICSURGE].include?(pokemon.ability)
      terrain_move = pokemon.moves.any? { |m| m && [:ELECTRICTERRAIN, :GRASSYTERRAIN, :MISTYTERRAIN, :PSYCHICTERRAIN].include?(m.id) }
      if terrain_ability || terrain_move
        team_benefits = party.any? { |p| p && AdvancedAI.benefits_from_terrain?(p, get_terrain_type(pokemon)) }
        roles << :terrain_lead if team_benefits
      end
      
      # Fast Attacker
      if pokemon.speed >= 100 && (pokemon.attack >= 100 || pokemon.spatk >= 100)
        roles << :fast_attacker
      end
      
      # Fake Out Lead
      if pokemon.moves.any? { |m| m && m.id == :FAKEOUT }
        roles << :fake_out_lead
      end
      
      # Anti-Lead
      has_taunt = pokemon.moves.any? { |m| m && m.id == :TAUNT }
      if has_taunt && pokemon.speed >= 90
        roles << :anti_lead
      end
      
      # Screen Setter
      has_screens = pokemon.moves.any? { |m| m && [:LIGHTSCREEN, :REFLECT, :AURORAVEIL].include?(m.id) }
      team_has_sweepers = party.any? { |p| p && AdvancedAI.detect_roles(p).include?(:sweeper) }
      if has_screens && team_has_sweepers
        roles << :screen_setter
      end
      
      # Suicide Lead (party Pokemon uses ability_id)
      has_explosion = pokemon.moves.any? { |m| m && [:EXPLOSION, :SELFDESTRUCT].include?(m.id) }
      has_sturdy = pokemon.ability_id == :STURDY || pokemon.item_id == :FOCUSSASH
      if (has_explosion || has_hazards) && has_sturdy
        roles << :suicide_lead
      end
      
      return roles
    end
    
    #===========================================================================
    # Matchup Analysis
    #===========================================================================
    
    # Analyzes Matchups against Opponent Team
    def self.analyze_matchups(pokemon, opponent_party)
      return 0 if !pokemon || !opponent_party
      
      score = 0
      favorable_matchups = 0
      unfavorable_matchups = 0
      
      opponent_party.each do |opp|
        next if !opp || opp.egg?
        
        # Type Matchup
        matchup = calculate_type_matchup(pokemon, opp)
        
        if matchup > 1.2
          favorable_matchups += 1
          score += 15
        elsif matchup < 0.8
          unfavorable_matchups += 1
          score -= 10
        end
      end
      
      # Bonus if many favorable
      score += 20 if favorable_matchups >= 3
      
      # Penalty if many unfavorable
      score -= 15 if unfavorable_matchups >= 3
      
      return score
    end
    
    # Calculates Type-Matchup Score
    def self.calculate_type_matchup(attacker, defender)
      return 1.0 if !attacker || !defender
      
      total_multiplier = 1.0
      move_count = 0
      
      attacker.moves.each do |move|
        next if !move || move.category == :Status
        
        effectiveness = Effectiveness.calculate(move.type, defender.type1, defender.type2)
        # Effectiveness.calculate already returns the multiplier directly
        multiplier = effectiveness.to_f / Effectiveness::NORMAL_EFFECTIVE_MULTIPLIER.to_f
        
        total_multiplier += multiplier
        move_count += 1
      end
      
      return move_count > 0 ? total_multiplier / move_count : 1.0
    end
    
    #===========================================================================
    # Anti-Lead Logic
    #===========================================================================
    
    # Counters typical Hazard Leads
    def self.counter_hazard_lead(pokemon, opponent_party)
      return 0 if !pokemon || !opponent_party
      
      # Check if opponent likely has Hazard Lead
      opponent_has_hazard_lead = opponent_party.any? do |opp|
        next false if !opp
        opp.moves.any? { |m| m && AdvancedAI.hazard_move?(m.id) }
      end
      
      return 0 if !opponent_has_hazard_lead
      
      score = 0
      
      # Taunt = perfect Counter (+40)
      if pokemon.moves.any? { |m| m && m.id == :TAUNT }
        score += 40
      end
      
      # Magic Coat (+35)
      if pokemon.moves.any? { |m| m && m.id == :MAGICCOAT }
        score += 35
      end
      
      # Fast Attack (+20)
      if pokemon.speed >= 100
        score += 20
      end
      
      # Magic Bounce Ability (+45)
      if pokemon.ability == :MAGICBOUNCE
        score += 45
      end
      
      return score
    end
    
    #===========================================================================
    # Helper Methods
    #===========================================================================
    
    def self.get_weather_type(pokemon)
      return nil if !pokemon
      
      # Party Pokemon uses ability_id
      case pokemon.ability_id
      when :DROUGHT then return :sun
      when :DRIZZLE then return :rain
      when :SANDSTREAM then return :sandstorm
      when :SNOWWARNING then return :hail
      end
      
      pokemon.moves.each do |move|
        next if !move
        case move.id
        when :SUNNYDAY then return :sun
        when :RAINDANCE then return :rain
        when :SANDSTORM then return :sandstorm
        when :HAIL, :SNOWSCAPE then return :hail
        end
      end
      
      return nil
    end
    
    def self.get_terrain_type(pokemon)
      return nil if !pokemon
      
      case pokemon.ability
      when :ELECTRICSURGE then return :electric
      when :GRASSYSURGE then return :grassy
      when :MISTYSURGE then return :misty
      when :PSYCHICSURGE then return :psychic
      end
      
      pokemon.moves.each do |move|
        next if !move
        case move.id
        when :ELECTRICTERRAIN then return :electric
        when :GRASSYTERRAIN then return :grassy
        when :MISTYTERRAIN then return :misty
        when :PSYCHICTERRAIN then return :psychic
        end
      end
      
      return nil
    end
    
  end
end

#===============================================================================
# API Wrapper
#===============================================================================
module AdvancedAI
  def self.select_best_lead(battle, party, opponent_party = nil)
    TeamPreviewIntelligence.select_best_lead(battle, party, opponent_party)
  end
  
  def self.detect_lead_roles(pokemon, party)
    TeamPreviewIntelligence.detect_lead_roles(pokemon, party)
  end
end

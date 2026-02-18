#===============================================================================
# Advanced AI System - Switch Intelligence
# Intelligent Switching Decisions with Type Matchup and Momentum Control
#===============================================================================

class Battle::AI
  #=============================================================================
  # SWITCH ANALYZER - Evaluates switch opportunities
  #=============================================================================
  
  # Helper method to safely get battler index from either Battler or Integer
  def get_battler_index(battler_or_index)
    return battler_or_index.to_i if battler_or_index.is_a?(Integer)
    return battler_or_index.index if battler_or_index.respond_to?(:index)
    battler_or_index.to_i
  end
  
  # Initialize caches
  def initialize_switch_caches
    @type_effectiveness_cache ||= {}
    @setup_move_cache ||= {}
  end
  
  # Analyzes if AI should switch (advanced version)
  def should_switch_advanced?(user, skill = 100)
    return false unless user && !user.fainted?
    return false if user.trappedInBattle?
    return false unless AdvancedAI.feature_enabled?(:core, skill)
    
    # Initialize caches
    initialize_switch_caches
    
    # Initialize switch analysis cache
    @switch_analyzer[user.index] ||= {}
    cache = @switch_analyzer[user.index]
    
    # Calculate Switch Score
    switch_score = calculate_switch_score(user, skill)
    
    # Cache result
    cache[:last_score] = switch_score
    cache[:last_turn] = @battle.turnCount
    
    AdvancedAI.log("Switch score for #{user.pbThis}: #{switch_score}", "Switch")
    
    # Thresholds based on skill
    tier = AdvancedAI.get_ai_tier(skill)
    threshold = AdvancedAI::SWITCH_THRESHOLDS[tier] || 50
    
    return switch_score >= threshold
  end
  
  private # All methods below are private helper methods
  
  # Calculates Switch Score (0-100+)
  def calculate_switch_score(user, skill)
    echoln "  ┌─────────────────────────────────────┐"
    echoln "  │ SWITCH SCORE CALCULATION            │"
    echoln "  └─────────────────────────────────────┘"
    score = 0
    
    # 1. TYPE MATCHUP ANALYSIS (0-40 Points)
    type_score = evaluate_type_disadvantage(user, skill)
    score += type_score
    echoln("  [1/8] Type Disadvantage: +#{type_score}") if type_score > 0
    
    # 2. HP & STATUS ANALYSIS (0-30 Points)
    survival_score = evaluate_survival_concerns(user, skill)
    score += survival_score
    echoln("  [2/8] Survival Concerns: +#{survival_score}") if survival_score > 0
    
    # 3. STAT STAGE ANALYSIS (0-25 Points)
    stat_score = evaluate_stat_stages(user, skill)
    score += stat_score
    echoln("  [3/8] Stat Stage Loss: +#{stat_score}") if stat_score > 0
    
    # 4. BETTER OPTION AVAILABLE (0-35 Points)
    better_score = evaluate_better_options(user, skill)
    score += better_score
    echoln("  [4/8] Better Options: +#{better_score}") if better_score > 0
    
    # 5. MOMENTUM CONTROL (0-20 Points)
    if AdvancedAI.get_setting(:momentum_control) > 0
      momentum_score = evaluate_momentum(user, skill)
      score += momentum_score
      echoln("  [5/8] Momentum Control: +#{momentum_score}") if momentum_score > 0
    end
    
    # 6. PREDICTION BONUS (0-15 Points)
    if skill >= 85
      prediction_score = evaluate_prediction_advantage(user, skill)
      score += prediction_score
      echoln("  [6/8] Prediction: +#{prediction_score}") if prediction_score > 0
    end
    
    # 7. PENALTY: Losing Momentum (-20 Points)
    if user_has_advantage?(user)
      score -= 20
      echoln("  [7/12] Has Advantage (malus): -20")
    end
    
    # 8. BONUS: Pivot Move Available (+25 Points)
    # Prefer using pivot moves (U-turn, Volt Switch, etc.) over hard switches
    pivot_bonus = evaluate_pivot_move_option(user, skill)
    if pivot_bonus > 0
      score -= pivot_bonus  # REDUCE switch score if pivot available (prefer pivot over switch!)
      echoln("  [8/12] Pivot Move Available (reduces hard switch need): -#{pivot_bonus}")
    end
    
    # 9. PENALTY: Wasting Setup (-30 Points)
    if user.stages.values.any? { |stage| stage > 0 }
      total_boosts = user.stages.values.sum
      malus = [total_boosts * 10, 30].min
      score -= malus
      echoln("  [9/12] Wasting Setup +#{total_boosts} (malus): -#{malus}")
    end
    
    # 10. PENALTY: Switching too soon (-40 Points)
    if user.turnCount < 2
      score -= 40
      echoln("  [10/12] Just Switched In (malus): -40")
    end
    
    # 11. PENALTY: No better option (-15 Points)
    # If better_score is 0, it means either no switches exist OR the best switch isn't significantly better
    if better_score <= 0
      score -= 15
      echoln("  [11/12] No Better Option (malus): -15")
    end
    
    # 12. PENALTY: Can KO Opponent (-60 Points)
    if can_ko_opponent?(user)
      score -= 60
      echoln("  [12/12] Can Secure KO (malus): -60")
    end
    
    echoln "  ─────────────────────────────────────"
    echoln "  TOTAL SWITCH SCORE: #{score}"
    
    # Show Threshold
    tier = AdvancedAI.get_ai_tier(skill)
    threshold = AdvancedAI::SWITCH_THRESHOLDS[tier] || 50
    echoln "  Threshold (#{tier}): #{threshold}"
    echoln "  Decision: #{score >= threshold ? 'SWITCH' : 'STAY'}"
    
    return score
  end
  
  #=============================================================================
  # EVALUATION METHODS
  #=============================================================================
  
  # 1. Type Disadvantage Evaluation
  def evaluate_type_disadvantage(user, skill)
    score = 0
    
    # Use real types (ignoring Illusion) for defensive calculation
    my_types = get_real_types(user)
    
    @battle.allOtherSideBattlers(user.index).each do |target|
      next unless target && !target.fainted?
      
      echoln("    → Analyzing vs #{target.name} [#{target.pbTypes(true).join('/')}]")
      
      # Offensive Threat (Opponent can hit User super effectively)
      target.moves.each do |move|
        next unless move
        next unless move.damagingMove?  # Skip status moves like Hypnosis
        next unless move.type # Fix ArgumentError
        type_mod = Effectiveness.calculate(move.type, *my_types)
        if Effectiveness.super_effective?(type_mod)
          score += 20  # Super effective move!
          echoln("      • #{move.name} [#{move.type}] → SUPER EFFECTIVE! (+20)")
        end
      end
      
      # Defensive Weakness (User cannot hit Opponent effectively)
      user_offensive = user.moves.map do |move|
        next 0 unless move
        next 0 unless move.type # Fix ArgumentError
        type_mod = Effectiveness.calculate(move.type, *target.pbTypes(true))
        Effectiveness.not_very_effective?(type_mod) ? 1.0 : 0.0
      end.count { |x| x > 0 }
      
      score += 10 if user_offensive >= 3  # Most moves not very effective
      
      # STAB Disadvantage
      target.moves.each do |move|
        next unless move
        next unless move.damagingMove?  # Skip status moves
        next unless move.type # Fix ArgumentError
        if target.pbHasType?(move.type)  # STAB
          type_mod = Effectiveness.calculate(move.type, *my_types)
          score += 15 if Effectiveness.super_effective?(type_mod)
        end
      end
    end
    
    return [score, 40].min  # Cap at 40
  end
  
  # 2. Survival Concerns
  def evaluate_survival_concerns(user, skill)
    score = 0
    hp_percent = user.hp.to_f / user.totalhp
    
    # Low HP
    if hp_percent < 0.25
      score += 30
    elsif hp_percent < 0.40
      score += 20
    elsif hp_percent < 0.55
      score += 10
    end
    
    # No Recovery Options
    has_recovery = user.moves.any? do |m|
      next false unless m
      move_data = GameData::Move.try_get(m.id)
      next false unless move_data
      move_data.function_code.start_with?("HealUser") || 
        ["Roost", "Synthesis", "MorningSun", "Moonlight", "Recover", "Softboiled", "Wish", "Rest"].include?(move_data.real_name)
    end
    score += 10 if !has_recovery && hp_percent < 0.5
    
    # Bad Status
    if user.status != :NONE
      case user.status
      when :POISON, :BURN
        score += 15
      when :TOXIC
        score += 20
      when :SLEEP, :FROZEN
        score += 10
      when :PARALYSIS
        score += 5
      end
    end
    
    # OHKO Danger
    my_types = get_real_types(user)
    
    @battle.allOtherSideBattlers(user.index).each do |target|
      next unless target && !target.fainted?
      
      # Faster Opponent with high Attack
      if target.pbSpeed > user.pbSpeed
        target.moves.each do |move|
          next unless move && move.damagingMove?
          next unless move.type
          
          type_mod = Effectiveness.calculate(move.type, *my_types)
          
          # Rough Damage Estimate
          if Effectiveness.super_effective?(type_mod)
            # Use safer base damage retrieval for v21.1 compatibility
            base_dmg = move.power
            estimated_damage = (target.attack * base_dmg * 2.0) / [user.defense, 1].max
            score += 15 if estimated_damage >= user.hp
          end
        end
      end
    end
    
    return [score, 30].min
  end
  
  # 3. Stat Stage Analysis
  def evaluate_stat_stages(user, skill)
    score = 0
    
    # Negative Stat Stages
    negative_stages = user.stages.values.count { |stage| stage < 0 }
    score += negative_stages * 8
    
    # Critical Drops
    score += 10 if user.stages[:ATTACK] <= -2 && user.attack > user.spatk
    score += 10 if user.stages[:SPECIAL_ATTACK] <= -2 && user.spatk > user.attack
    score += 12 if user.stages[:SPEED] <= -2
    
    # Opponent with many Boosts
    @battle.allOtherSideBattlers(user.index).each do |target|
      next unless target && !target.fainted?
      
      positive_stages = target.stages.values.count { |stage| stage > 0 }
      score += 5 if positive_stages >= 2
      score += 10 if positive_stages >= 4
    end
    
    return [score, 25].min
  end
  
  # 4. Better Available Options
  def evaluate_better_options(user, skill)
    score = 0
    
    party = @battle.pbParty(user.index)
    available_switches = party.select.with_index do |pkmn, i|
      pkmn && !pkmn.fainted? && !pkmn.egg? && !@battle.pbFindBattler(i, user.index)
    end
    
    # Handle ReserveLastPokemon
    # Robust trainer retrieval
    ai_trainer = @trainer
    if !ai_trainer
      # Try to get trainer from battler
      ai_trainer = @battle.pbGetOwnerFromBattlerIndex(user.index)
    end

    if AdvancedAI::RESPECT_RESERVE_LAST_POKEMON && ai_trainer && ai_trainer.has_skill_flag?("ReserveLastPokemon")
      reserved_idx = party.length - 1
      echoln "[AAI DEBUG] ReserveLastPokemon Active! Reserved Index: #{reserved_idx}"
      
      # Only filter if we have more than 1 option (never restrict the last available mon)
      if available_switches.length > 1
        available_switches.reject! do |pkmn| 
          is_reserved = (party.index(pkmn) == reserved_idx)
          echoln "[AAI DEBUG] Filtering #{pkmn.name} (Index #{party.index(pkmn)})? #{is_reserved}" if is_reserved
          is_reserved
        end
      end
    else
      echoln "[AAI DEBUG] ReserveLastPokemon skipped. Enabled: #{AdvancedAI::RESPECT_RESERVE_LAST_POKEMON}, Trainer Found: #{!!ai_trainer}"
      if ai_trainer
         echoln "[AAI DEBUG] Has Flag? #{ai_trainer.has_skill_flag?("ReserveLastPokemon")}"
      end
    end
    
    return 0 if available_switches.empty?
    
    # Find best alternative
    best_matchup_score = -100
    best_switch = nil
    
    available_switches.each do |switch_mon|
      matchup = evaluate_switch_matchup(switch_mon, user)
      if matchup > best_matchup_score
        best_matchup_score = matchup
        best_switch = switch_mon
      end
    end
    
    return 0 unless best_switch
    
    # Calculate current pokemon's matchup for comparison
    # Pass user.pokemon (real Pokemon object) to evaluate current type effectiveness IGNORING Illusion
    current_matchup_score = evaluate_switch_matchup(user.pokemon, user)
    
    # Calculate improvement
    improvement = best_matchup_score - current_matchup_score
    
    echoln("[AAI Switch] Current: #{current_matchup_score} vs Best: #{best_matchup_score} (Diff: #{improvement})")
    
    # Bonus only if SIGNIFICANT improvement
    if improvement > 25
      score += 35
      echoln("[AAI Switch] Best Option: #{best_switch.name} (Matchup +#{best_matchup_score}, Improvement +#{improvement})")
    elsif improvement > 15
      score += 25
      echoln("[AAI Switch] Good Option: #{best_switch.name} (Matchup +#{best_matchup_score}, Improvement +#{improvement})")
    elsif improvement > 5 && best_matchup_score > 40
      # Only switch for small improvement if the matchup is absolutely excellent (Score > 40)
      score += 15
      echoln("[AAI Switch] Solid Option: #{best_switch.name} (Matchup +#{best_matchup_score}, Improvement +#{improvement})")
    end
    
    return score
  end
  
  # 5. Momentum Control
  def evaluate_momentum(user, skill)
    score = 0
    
    # Force Momentum Shift if behind
    alive_user = @battle.pbParty(user.index).count { |p| p && !p.fainted? }
    alive_enemy = @battle.allOtherSideBattlers(user.index).count { |b| 
      b && !b.fainted? && @battle.pbParty(b.index).count { |p| p && !p.fainted? } > 0
    }
    
    if alive_user < alive_enemy
      score += 10  # Attempt Momentum Shift
    end
    
    # Predict Switch if opponent wants to setup
    @battle.allOtherSideBattlers(user.index).each do |target|
      next unless target && !target.fainted?
      
      # Opponent has Setup Moves (check function codes)
      has_setup = target.moves.any? do |m|
        next false unless m && m.is_a?(Battle::Move) && m.statusMove?
        move_data = GameData::Move.try_get(m.id)
        next false unless move_data
        # Setup moves have function codes like RaiseUserAttack2, RaiseMultipleStats, etc.
        move_data.function_code.to_s.include?("RaiseUser") || move_data.function_code.to_s.include?("RaiseMulti")
      end
      score += 15 if has_setup && user_has_type_disadvantage?(user, target)
    end
    
    return [score, 20].min
  end
  
  # 6. Prediction Advantage (Skill 85+)
  def evaluate_prediction_advantage(user, skill)
    return 0 unless skill >= 85
    score = 0
    
    # If opponent likely switches, stay in
    # If opponent likely setups, switch out
    
    @battle.allOtherSideBattlers(user.index).each do |target|
      next unless target && !target.fainted?
      
      # Analyze last moves
      if @move_memory[target.index]
        last_moves = @move_memory[target.index][:moves] || []
        
        # Pattern: Repeated Setup Moves
        setup_count = last_moves.count do |m|
          next false unless m
          move_data = GameData::Move.try_get(m)
          next false unless move_data
          move_data.function_code.to_s.include?("RaiseUser") || move_data.function_code.to_s.include?("RaiseMulti")
        end
        score += 10 if setup_count >= 2
        
        # Pattern: Predict Opponent Switch (if low HP)
        if target.hp < target.totalhp * 0.35
          score -= 15  # Stay in, opponent likely switches
        end
      end
    end
    
    return [score, 15].min
  end
  
  #=============================================================================
  # FIND BEST SWITCH OPTION
  #=============================================================================
  
  # Detailed Switch Candidate Evaluation
  def evaluate_switch_candidate_detailed(pkmn, current_user, skill)
    score = 50  # Base score
    
    # 1. TYPE MATCHUP (0-50 Points)
    score += evaluate_switch_matchup(pkmn, current_user)
    
    # 2. HP & STATUS (0-20 Points)
    hp_percent = pkmn.hp.to_f / pkmn.totalhp
    score += (hp_percent * 20).to_i
    score -= 20 if pkmn.status != :NONE
    
    # 3. SPEED (0-15 Points)
    # Note: pkmn is Pokemon (not Battler), need to calculate speed properly
    @battle.allOtherSideBattlers(get_battler_index(current_user)).each do |target|
      next unless target && !target.fainted?
      # Use base speed stat for Pokemon comparison (pkmn doesn't have pbSpeed)
      pkmn_speed = pkmn.speed
      target_speed = target.speed  # Use base speed for fair comparison
      score += 15 if pkmn_speed > target_speed
    end
    
    # 4. ROLE ANALYSIS (0-25 Points)
    role_bonus = evaluate_switch_role(pkmn, current_user, skill)
    score += role_bonus
    
    # 5. ENTRY HAZARDS RESISTANCE (0-15 Points)
    if @battle.pbOwnedByPlayer?(get_battler_index(current_user))
      opponent_side = @battle.sides[1]
    else
      opponent_side = @battle.sides[0]
    end
    
    # Stealth Rock Resistance
    if opponent_side.effects[PBEffects::StealthRock]
      effectiveness = Effectiveness.calculate(:ROCK, *pkmn.types)
      if Effectiveness.ineffective?(effectiveness)
        score += 15
      elsif Effectiveness.not_very_effective?(effectiveness)
        score += 10
      elsif Effectiveness.super_effective?(effectiveness)
        score -= 15
      end
    end
    
    # Spikes
    if opponent_side.effects[PBEffects::Spikes] > 0
      # Safe ability check with nil guard
      has_levitate = false
      begin
        has_levitate = pkmn.hasAbility?(:LEVITATE) if pkmn.respond_to?(:hasAbility?)
      rescue
        has_levitate = false
      end
      score += 10 if pkmn.hasType?(:FLYING) || has_levitate
    end
    
    # 6. ABILITY SYNERGY (0-20 Points)
    # Use ability_id instead of ability to avoid Gen9 Pack recursion
    ability_id = nil
    begin
      ability_id = pkmn.ability_id if pkmn.respond_to?(:ability_id)
    rescue StandardError => e
      AdvancedAI.log("Error getting ability_id: #{e.message}", "Switch")
    end
    
    if ability_id
      # Intimidate on Switch-In
      score += 20 if ability_id == :INTIMIDATE
      
      # Weather/Terrain abilities
      score += 15 if [:DRIZZLE, :DROUGHT, :SANDSTREAM, :SNOWWARNING].include?(ability_id)
      
      # Defensive abilities
      score += 10 if [:REGENERATOR, :NATURALCURE, :IMMUNITY].include?(ability_id)
    end
    
    return score
  end
  
  # Matchup Evaluation for Switch
  def evaluate_switch_matchup(switch_mon, current_user)
    score = 0
    
    # Validate types
    # Validate types - normalize input to types array
    switch_types = []
    
    if switch_mon.is_a?(Battle::Battler)
       # Use real types helper if it's a battler (Illusion bypass)
       switch_types = get_real_types(switch_mon)
    elsif switch_mon.respond_to?(:types)
       # Pokemon object
       switch_types = switch_mon.types.compact
    end
    
    return 0 if switch_types.empty?
    
    @battle.allOtherSideBattlers(get_battler_index(current_user)).each do |target|
      next unless target && !target.fainted?
      
      # Offensive Type Advantage
      switch_mon_types = switch_types.uniq
      return 0 if switch_mon_types.empty?
      
      target_types = target.pbTypes(true).compact
      next if target_types.empty?
      
      switch_mon_types.each do |type|
        next unless type  # Skip nil
        effectiveness = Effectiveness.calculate(type, *target_types)
        if Effectiveness.super_effective?(effectiveness)
          score += 20
        elsif Effectiveness.not_very_effective?(effectiveness)
          score -= 10
        elsif Effectiveness.ineffective?(effectiveness)
          score -= 40  # STAB ineffective (Immunity)
        end
      end
      
      # Defensive Type Advantage
      target.moves.each do |move|
        next unless move && move.damagingMove?
        next unless move.type  # Skip nil types
        # Use duck-typing for switch_mon (could be Battler or Pokemon)
        switch_types = switch_mon.is_a?(Battle::Battler) ? 
          switch_mon.pbTypes(true).compact :
          switch_mon.types.compact
        next if switch_types.empty?
        effectiveness = Effectiveness.calculate(move.type, *switch_types)
        if Effectiveness.ineffective?(effectiveness)
          score += 40  # IMMUNITY is extremely valuable!
        elsif Effectiveness.not_very_effective?(effectiveness)
          score += 15  # Resistance is good
        elsif Effectiveness.super_effective?(effectiveness)
          score -= 25  # Weakness is bad
        end
      end
    end
    
    return score
  end
  
  # Role-based Switch Evaluation
  def evaluate_switch_role(pkmn, current_user, skill)
    return 0 unless skill >= 55
    score = 0
    
    # Determine Role of current Pokemon
    current_role = determine_pokemon_role(current_user)
    switch_role = determine_pokemon_role_from_stats(pkmn)
    
    # Prefer Complementary Roles
    case current_role
    when :sweeper
      score += 15 if [:wall, :tank].include?(switch_role)
    when :wall
      score += 15 if [:sweeper, :wallbreaker].include?(switch_role)
    when :support
      score += 20 if [:sweeper, :wallbreaker].include?(switch_role)
    end
    
    return score
  end
  
  # Find best switch Pokemon (public for Core.rb integration)
  def find_best_switch_advanced(user, skill)
    echoln "  ┌─────────────────────────────────────┐"
    echoln "  │ FINDING BEST REPLACEMENT            │"
    echoln "  └─────────────────────────────────────┘"
    
    party = @battle.pbParty(user.index)
    available_switches = []
    
    reserved_idx = -1
    if AdvancedAI::RESPECT_RESERVE_LAST_POKEMON && @trainer && @trainer.has_skill_flag?("ReserveLastPokemon")
      reserved_idx = party.length - 1
    end
    
    party.each_with_index do |pkmn, i|
      next unless pkmn && !pkmn.fainted? && !pkmn.egg?
      next if @battle.pbFindBattler(i, user.index) # Already in battle
      next unless @battle.pbCanSwitchIn?(user.index, i)
      
      matchup_score = evaluate_switch_matchup_detailed(pkmn, user)
      available_switches.push([pkmn, matchup_score, i])
      
      echoln "  • #{pkmn.name}: Matchup = #{matchup_score}"
    end
    
    # Filter reserved Pokemon
    # 1. If we have multiple options, always save the Ace
    # 2. If we only have the Ace left:
    #    - If VOLUNTARY switch (user not fainted), save the Ace (stay in and die)
    #    - If FORCED switch (user fainted), we must use the Ace (no choice)
    
    is_voluntary_switch = user && !user.fainted?
    
    if reserved_idx >= 0
      should_filter = false
      
      if available_switches.length > 1
        should_filter = true
      elsif is_voluntary_switch && available_switches.length == 1
        # Strict Mode: Don't bring out Ace to save a dying mon
        should_filter = true
        echoln "  [AAI] ReserveLastPokemon: Blocking voluntary switch to Ace"
      end
      
      if should_filter
        available_switches.reject! { |item| item[2] == reserved_idx }
        if available_switches.empty?
          echoln "  [AAI] Reserved Pokemon at index #{reserved_idx} excluded (No other options)"
        else
          echoln "  [AAI] Reserved Pokemon at index #{reserved_idx} excluded from options"
        end
      end
    end
    
    if available_switches.empty?
      echoln "  >>> No valid switches available!"
      return nil
    end
    
    # Sort by matchup score (highest first)
    available_switches.sort_by! { |_, score, _| -score }
    best_pkmn, best_score, best_idx = available_switches.first
    
    echoln "  ─────────────────────────────────────"
    echoln "  ✅ BEST OPTION: #{best_pkmn.name}"
    echoln "  Matchup Score: #{best_score}"
    
    # Return party index directly (Core.rb expects integer)
    return best_idx
  end
  
  private
  
  # Constants for damage calculation
  DAMAGE_RANDOM_MULTIPLIER = 0.925  # Average of random damage roll (85-100%)
  STAB_MULTIPLIER = 1.5
  BURN_PHYSICAL_MODIFIER = 0.5
  WEATHER_BOOST = 1.5
  WEATHER_NERF = 0.5
  
  # Calculate estimated incoming damage from a move
  # Returns damage as a percentage of switch_pkmn's total HP (0.0 to 1.0+)
  def calculate_incoming_damage(switch_pkmn, move, attacker)
    return 0.0 unless switch_pkmn && move && attacker
    return 0.0 unless move.damagingMove?
    return 0.0 unless move.power && move.power > 0
    
    # Get move type (handle Move objects vs data)
    move_type = move.pbCalcType(attacker) rescue move.type
    return 0.0 unless move_type
    
    # Get types for effectiveness calculation (switch_pkmn is party Pokemon)
    switch_types = switch_pkmn.types.compact
    return 0.0 if switch_types.empty?
    
    # === ABILITY CHECKS ===
    # Check defender abilities that grant immunities
    defender_ability = switch_pkmn.ability_id
    if defender_ability
      # Levitate makes Ground immune
      return 0.0 if defender_ability == :LEVITATE && move_type == :GROUND
      # Volt Absorb, Lightning Rod, Motor Drive - Electric immunity
      return 0.0 if [:VOLTABSORB, :LIGHTNINGROD, :MOTORDRIVE].include?(defender_ability) && move_type == :ELECTRIC
      # Water Absorb, Storm Drain, Dry Skin - Water immunity
      return 0.0 if [:WATERABSORB, :STORMDRAIN, :DRYSKIN].include?(defender_ability) && move_type == :WATER
      # Flash Fire - Fire immunity
      return 0.0 if defender_ability == :FLASHFIRE && move_type == :FIRE
      # Sap Sipper - Grass immunity
      return 0.0 if defender_ability == :SAPSIPPER && move_type == :GRASS
      # Thick Fat - Fire/Ice resistance
      # Wonder Guard - only super effective hits
    end
    
    # Type effectiveness (Effectiveness.calculate returns multiplier like 8=2x, 4=1x, 2=0.5x)
    effectiveness = Effectiveness.calculate(move_type, *switch_types)
    return 0.0 if Effectiveness.ineffective?(effectiveness)
    
    # Wonder Guard - only allows super effective moves
    if defender_ability == :WONDERGUARD
      return 0.0 unless Effectiveness.super_effective?(effectiveness)
    end
    
    # Convert Essentials effectiveness value to actual multiplier (divide by NORMAL_EFFECTIVE)
    effectiveness_multiplier = effectiveness.to_f / Effectiveness::NORMAL_EFFECTIVE_MULTIPLIER
    
    # Thick Fat halves Fire/Ice damage
    if defender_ability == :THICKFAT && [:FIRE, :ICE].include?(move_type)
      effectiveness_multiplier *= 0.5
    end
    
    # Filter reduces super effective damage
    if defender_ability == :FILTER && Effectiveness.super_effective?(effectiveness)
      effectiveness_multiplier *= 0.75
    end
    
    # Solid Rock reduces super effective damage
    if defender_ability == :SOLIDROCK && Effectiveness.super_effective?(effectiveness)
      effectiveness_multiplier *= 0.75
    end
    
    # === STAB CALCULATION ===
    stab = attacker.pbHasType?(move_type) ? STAB_MULTIPLIER : 1.0
    
    # Adaptability boosts STAB to 2.0
    attacker_ability = attacker.ability_id rescue nil
    if attacker_ability == :ADAPTABILITY && stab > 1.0
      stab = 2.0
    end
    
    # === STAT CALCULATION ===
    # Select correct offensive/defensive stats based on move category
    if move.physicalMove?
      atk_stat = attacker.attack
      def_stat = switch_pkmn.defense
      
      # === STAT STAGE MODIFIERS (Attacker) ===
      # Attacker is Battle::Battler, has stat stages
      atk_stage = attacker.stages[:ATTACK] || 0
      if atk_stage != 0
        stage_multiplier = [2.0, 2.0/1.5, 2.0/2.0, 2.0/2.5, 2.0/3.0, 2.0/3.5, 2.0/4.0,
                            1.0,
                            4.0/2.0, 3.5/2.0, 3.0/2.0, 2.5/2.0, 2.0/2.0, 1.5/2.0][atk_stage + 6]
        atk_stat = (atk_stat * stage_multiplier).floor
      end
      
      # Guts boosts Attack when statused (attacker is Battler, has status)
      if attacker_ability == :GUTS && attacker.status != :NONE
        atk_stat = (atk_stat * 1.5).floor
      end
      
      # Huge Power / Pure Power doubles Attack
      if [:HUGEPOWER, :PUREPOWER].include?(attacker_ability)
        atk_stat = (atk_stat * 2).floor
      end
      
    elsif move.specialMove?
      atk_stat = attacker.spatk
      def_stat = switch_pkmn.spdef
      
      # === STAT STAGE MODIFIERS (Attacker) ===
      spatk_stage = attacker.stages[:SPECIAL_ATTACK] || 0
      if spatk_stage != 0
        stage_multiplier = [2.0, 2.0/1.5, 2.0/2.0, 2.0/2.5, 2.0/3.0, 2.0/3.5, 2.0/4.0,
                            1.0,
                            4.0/2.0, 3.5/2.0, 3.0/2.0, 2.5/2.0, 2.0/2.0, 1.5/2.0][spatk_stage + 6]
        atk_stat = (atk_stat * stage_multiplier).floor
      end
      
      # Solar Power boosts Sp.Atk in sun
      if attacker_ability == :SOLARPOWER && @battle.pbWeather == :Sun
        atk_stat = (atk_stat * 1.5).floor
      end
      
    else
      return 0.0  # Status move or unknown category
    end
    
    # === DEFENDER STAT STAGES (switch_pkmn is party Pokemon, no stages yet) ===
    # Note: Can't apply defender stat stages for party Pokemon (not in battle yet)
    # This is intentional - we're predicting damage on switch-in before stat changes
    
    # Marvel Scale boosts Defense when statused (switch_pkmn is party Pokemon)
    if move.physicalMove? && defender_ability == :MARVELSCALE && switch_pkmn.status != :NONE
      def_stat = (def_stat * 1.5).floor
    end
    
    # === ITEM MODIFIERS ===
    # Attacker items
    attacker_item = attacker.item_id rescue nil
    if attacker_item
      # Choice Band boosts physical moves
      if move.physicalMove? && attacker_item == :CHOICEBAND
        atk_stat = (atk_stat * 1.5).floor
      end
      # Choice Specs boosts special moves
      if move.specialMove? && attacker_item == :CHOICESPECS
        atk_stat = (atk_stat * 1.5).floor
      end
      # Life Orb boosts all moves
      if [:LIFEORB].include?(attacker_item)
        atk_stat = (atk_stat * 1.3).floor
      end
    end
    
    # Defender items
    defender_item = switch_pkmn.item_id
    if defender_item
      # Assault Vest boosts Sp.Def
      if move.specialMove? && defender_item == :ASSAULTVEST
        def_stat = (def_stat * 1.5).floor
      end
      # Eviolite boosts both defenses for non-fully evolved
      if defender_item == :EVIOLITE && !switch_pkmn.species_data.get_evolutions(true).empty?
        def_stat = (def_stat * 1.5).floor
      end
    end
    
    # === WEATHER MODIFIERS ===
    weather = @battle.pbWeather rescue nil
    if weather
      # Sun boosts Fire, nerfs Water
      if weather == :Sun
        effectiveness_multiplier *= WEATHER_BOOST if move_type == :FIRE
        effectiveness_multiplier *= WEATHER_NERF if move_type == :WATER
      end
      # Rain boosts Water, nerfs Fire
      if weather == :Rain
        effectiveness_multiplier *= WEATHER_BOOST if move_type == :WATER
        effectiveness_multiplier *= WEATHER_NERF if move_type == :FIRE
      end
      # Sandstorm boosts Rock Sp.Def (already in stats for Battler, not party Pokemon)
    end
    
    # === TERRAIN MODIFIERS ===
    terrain = @battle.field.terrain rescue nil
    if terrain
      # Electric Terrain boosts Electric moves by 1.3x
      if terrain == :Electric && move_type == :ELECTRIC
        effectiveness_multiplier *= 1.3
      end
      # Grassy Terrain boosts Grass moves by 1.3x
      if terrain == :Grassy && move_type == :GRASS
        effectiveness_multiplier *= 1.3
      end
      # Psychic Terrain boosts Psychic moves by 1.3x
      if terrain == :Psychic && move_type == :PSYCHIC
        effectiveness_multiplier *= 1.3
      end
      # Misty Terrain reduces Dragon moves by 0.5x
      if terrain == :Misty && move_type == :DRAGON
        effectiveness_multiplier *= 0.5
      end
      
      # Grassy Terrain reduces Earthquake/Bulldoze/Magnitude damage
      if terrain == :Grassy && [:EARTHQUAKE, :BULLDOZE, :MAGNITUDE].include?(move.id)
        effectiveness_multiplier *= 0.5
      end
    end
    
    # === BURN MODIFIER ===
    # Burn halves physical damage (unless attacker has Guts which we already handled)
    if move.physicalMove? && attacker.status == :BURN && attacker_ability != :GUTS
      atk_stat = (atk_stat * BURN_PHYSICAL_MODIFIER).floor
    end
    
    # Prevent division by zero
    def_stat = [def_stat, 1].max
    
    # === DAMAGE FORMULA ===
    # Pokemon damage formula: ((2*Level/5 + 2) * Power * Atk/Def / 50 + 2) * Modifiers
    level = attacker.level
    base_damage = ((2.0 * level / 5 + 2) * move.power * atk_stat / def_stat / 50 + 2)
    
    # === MULTI-HIT MOVE ADJUSTMENT ===
    # Multi-hit moves hit multiple times (2-5 or fixed)
    if move.multiHitMove?
      # Skill Link: Always 5 hits
      if attacker_ability == :SKILLLINK
        base_damage *= 5
      # Loaded Dice: 4-5 hits (average 4.5)
      elsif attacker.hasActiveItem?(:LOADEDDICE)
        base_damage *= 4.5
      # Parental Bond: 2 hits (second is 25%)
      elsif attacker_ability == :PARENTALBOND
        base_damage *= 1.25
      # Population Bomb: 10 hits (each 20 BP = 200 total)
      elsif move.id == :POPULATIONBOMB
        if attacker_ability == :SKILLLINK
          base_damage = ((2.0 * level / 5 + 2) * 200 * atk_stat / def_stat / 50 + 2)  # 10 guaranteed hits
        else
          base_damage = ((2.0 * level / 5 + 2) * 140 * atk_stat / def_stat / 50 + 2)  # Average 7 hits
        end
      # Triple Kick: 3 hits (10, 20, 30 BP = 60 total)
      elsif move.id == :TRIPLEKICK
        base_damage = ((2.0 * level / 5 + 2) * 60 * atk_stat / def_stat / 50 + 2)
      # Triple Axel: 3 hits (20, 40, 60 BP = 120 total)
      elsif move.id == :TRIPLEAXEL
        base_damage = ((2.0 * level / 5 + 2) * 120 * atk_stat / def_stat / 50 + 2)
      # Standard multi-hit: 2-5 hits (average 3)
      else
        base_damage *= 3
      end
    end
    
    # === CRITICAL HIT ADJUSTMENT ===
    # Factor in crit rates for damage expectation
    if move.damagingMove?
      crit_stage = 0
      
      # High crit moves (Slash, Stone Edge, etc.)
      high_crit_moves = [:AEROBLAST, :AIRCUTTER, :ATTACKORDER, :BLAZEKICK, :CRABHAMMER,
                         :CROSSCHOP, :CROSSPOISON, :DRILLRUN, :KARATECHOP, :LEAFBLADE,
                         :NIGHTSLASH, :POISONTAIL, :PSYCHOCUT, :RAZORLEAF, :RAZORWIND,
                         :SHADOWCLAW, :SLASH, :SPACIALREND, :STONEEDGE]
      crit_stage += 1 if high_crit_moves.include?(move.id)
      
      # Always crit moves (Frost Breath, Storm Throw, etc.)
      always_crit_moves = [:FROSTBREATH, :STORMTHROW, :WICKEDBLOW, :SURGINGSTRIKES, :FLOWERTRICK]
      if always_crit_moves.include?(move.id)
        crit_stage = 99  # Guaranteed crit
      end
      
      # Super Luck ability
      crit_stage += 1 if attacker_ability == :SUPERLUCK
      
      # Focus Energy (if tracked)
      if attacker.effects[PBEffects::FocusEnergy] && attacker.effects[PBEffects::FocusEnergy] > 0
        crit_stage += 2
      end
      
      # Items (Scope Lens, Razor Claw)
      attacker_item_safe = (attacker.item_id rescue nil)
      if [:SCOPELENS, :RAZORCLAW].include?(attacker_item_safe)
        crit_stage += 1
      end
      
      # Calculate crit rate
      crit_rate = case crit_stage
                  when 0 then 0.0417  # 1/24 (4.17%)
                  when 1 then 0.125   # 1/8 (12.5%)
                  when 2 then 0.5     # 1/2 (50%)
                  else 1.0            # Always crit at stage 3+
                  end
      
      # Crit multiplier (1.5x damage, ignores defensive stat boosts)
      # Note: We can't model defensive drops here since we're predicting on party Pokemon
      # So we apply a conservative crit bonus as weighted average
      if crit_rate >= 1.0
        # Always crit: Apply full 1.5x multiplier
        base_damage *= 1.5
      elsif crit_rate > 0
        # Probabilistic crit: Apply weighted average
        # E.g., 50% crit rate = (0.5 * 1.5x) + (0.5 * 1.0x) = 1.25x average
        base_damage *= (1.0 + crit_rate * 0.5)
      end
      
      # Sniper ability boosts crit damage from 1.5x to 2.25x
      if attacker_ability == :SNIPER && crit_rate > 0
        # Adjust multiplier from 1.5x to 2.25x (additional 0.75x on crit portion)
        additional_sniper_mult = crit_rate * 0.75
        base_damage *= (1.0 + additional_sniper_mult)
      end
    end
    
    # Apply modifiers (STAB, Type Effectiveness, Random roll average)
    estimated_damage = base_damage * stab * effectiveness_multiplier * DAMAGE_RANDOM_MULTIPLIER
    
    # Return as percentage of switch_pkmn's HP
    damage_percent = estimated_damage / [switch_pkmn.totalhp, 1].max
    
    # Log damage calculation in debug mode
    if AdvancedAI::DEBUG_SWITCH_INTELLIGENCE
      PBDebug.log("[DAMAGE CALC] #{move.name} vs #{switch_pkmn.name}: #{(damage_percent * 100).round(1)}% " +
                  "(Base: #{base_damage.round(1)}, STAB: #{stab}x, Eff: #{effectiveness_multiplier}x)")
    end
    
    return damage_percent
  end
  
  # Detailed Matchup Evaluation for Switch Selection
  def evaluate_switch_matchup_detailed(switch_pkmn, current_user)
    score = 0
    
    # Validate switch_pkmn has types
    return 0 unless switch_pkmn
    switch_types = switch_pkmn.types.compact
    return 0 if switch_types.empty? || switch_types.any?(&:nil?)
    
    # === ENTRY HAZARD DAMAGE PENALTY ===
    hazard_damage = calculate_entry_hazard_damage(switch_pkmn, current_user)
    if hazard_damage > 0
      hazard_penalty = (hazard_damage * 100).to_i  # Scale: 50% hazard damage = -50 points
      score -= hazard_penalty
      echoln "[HAZARD] #{(hazard_damage * 100).round(1)}% HP on switch-in [-#{hazard_penalty}]"
      
      # Extra penalty if hazards would faint us immediately
      if hazard_damage >= 1.0
        score -= 100  # FATAL - would faint on switch-in!
        echoln "FATAL] Hazards would KO on switch-in! [-100]"
      elsif hazard_damage >= 0.50
        score -= 30   # Massive damage = very risky switch
        echoln "[CRITICAL] 50%+ hazard damage! [-30]"
      end
    end
    
    # Check if current user is "already doomed" (will faint next turn)
    # If so, we should minimize damage on switch-in rather than avoid all OHKOs
    current_is_doomed = false
    if current_user && current_user.respond_to?(:fainted?) && !current_user.fainted?
      @battle.allOtherSideBattlers(get_battler_index(current_user)).each do |target|
        next unless target && !target.fainted?
        # Doomed if: Low HP AND slower than opponent
        hp_percent = current_user.hp.to_f / current_user.totalhp
        if hp_percent < 0.30 && target.pbSpeed > current_user.pbSpeed
          current_is_doomed = true
          break
        end
      end
    end
    
    # Analyze against all opponents
    @battle.allOtherSideBattlers(get_battler_index(current_user)).each do |target|
      next unless target && !target.fainted?
      
      target_types = target.pbTypes(true).compact
      next if target_types.empty? || target_types.any?(&:nil?)
      
      # Defensive Matchup (Incoming Moves)
      target.moves.each do |move|
        next unless move && move.damagingMove?
        next unless move.type  # Skip if move has no type
        
        move_type = move.pbCalcType(target)  # target is already a Battle::Battler
        next unless move_type  # Skip if calculated type is nil
        
        # Additional safety: ensure all switch types are valid
        next if switch_types.any? { |t| t.nil? }
        
        eff = Effectiveness.calculate(move_type, *switch_types)
        
        # Calculate actual damage to properly assess safety
        damage_percent = calculate_incoming_damage(switch_pkmn, move, target)
        
        # Type effectiveness scoring (base scoring)
        if Effectiveness.ineffective?(eff)
          score += 40
        elsif Effectiveness.not_very_effective?(eff)
          score += 15
        elsif Effectiveness.super_effective?(eff)
          score -= 25
        end
        
        # Damage-based penalties (critical for survival)
        # If current user is already doomed, we want to MINIMIZE damage, not avoid all OHKOs
        if current_is_doomed
          # In "doomed" scenario: Pick the switch that takes LEAST damage
          # Convert damage to a penalty (higher damage = worse score)
          damage_penalty = (damage_percent * 50).to_i  # Scale: 100% damage = -50 points
          score -= damage_penalty
          echoln "    [DAMAGE] #{move.name} (~#{(damage_percent * 100).to_i}% HP) [-#{damage_penalty}]"
        else
          # Normal scenario: Penalize based on OHKO/2HKO thresholds
          if damage_percent >= 0.85
            # Likely OHKO - this is a FATAL switch!
            score -= 60
            echoln "    [OHKO RISK] #{move.name} (~#{(damage_percent * 100).to_i}% HP) [-60]"
          elsif damage_percent >= 0.45
            # Likely 2HKO - risky switch
            score -= 30
            echoln "    [2HKO RISK] #{move.name} (~#{(damage_percent * 100).to_i}% HP) [-30]"
          elsif damage_percent >= 0.30
            # Moderate damage - somewhat risky
            score -= 10
          end
        end
      end
      
      # Offensive Matchup (Outgoing Moves)
      switch_pkmn.moves.each do |move|
        next unless move && move.id
        move_data = GameData::Move.try_get(move.id)
        next unless move_data
        next if move_data.category == 2  # Skip status moves (0=Physical, 1=Special, 2=Status)
        next unless move_data.type  # Skip if move has no type
        
        # Additional safety: ensure all target types are valid
        next if target_types.any? { |t| t.nil? }
        
        eff = Effectiveness.calculate(move_data.type, *target_types)
        
        if Effectiveness.super_effective?(eff)
          score += 20
        elsif Effectiveness.ineffective?(eff)
          score -= 40  # Useless move
        end
      end
    end
    
    return score
  end

  #=============================================================================
  # HELPER METHODS
  #=============================================================================
  
  def user_has_advantage?(user)
    my_types = get_real_types(user)
    
    @battle.allOtherSideBattlers(user.index).all? do |target|
      next true unless target && !target.fainted?
      
      # Type advantage
      user.moves.any? do |move|
        next false unless move && move.damagingMove?
        next false unless move.type
        type_mod = Effectiveness.calculate(move.type, *target.pbTypes(true))
        Effectiveness.super_effective?(type_mod)
      end
    end
  end
  
  def user_has_type_disadvantage?(user, target)
    my_types = get_real_types(user)
    
    target.moves.any? do |move|
      next false unless move && move.damagingMove?
      next false unless move.type
      type_mod = Effectiveness.calculate(move.type, *my_types)
      Effectiveness.super_effective?(type_mod)
    end
  end
  
  def determine_pokemon_role(battler)
    # Simplified role detection (will be expanded in [011])
    if battler.attack > battler.spatk && battler.speed > 100
      return :sweeper
    elsif battler.defense > 100 || battler.spdef > 100
      return :wall
    else
      return :balanced
    end
  end
  
  # Helper to get REAL types (ignoring Illusion)
  def get_real_types(battler)
    # If Illusion is active (effects[PBEffects::Illusion] is truthy/Pokemon object),
    # return the types of the underlying Pokemon
    if battler.effects[PBEffects::Illusion]
      illusion_species = battler.effects[PBEffects::Illusion].species
      return GameData::Species.get(illusion_species).types.clone
    end
    
    # Otherwise return current effective types (includes Soak etc)
    return battler.pbTypes(true)
  end
  
  def determine_pokemon_role_from_stats(pkmn)
    # Simplified role detection
    if pkmn.attack > pkmn.spatk && pkmn.speed > 100
      return :sweeper
    elsif pkmn.defense > 100 || pkmn.spdef > 100
      return :wall
    else
      return :balanced
    end
  end
  
  # Check if current Pokemon can KO any opponent
  # Enhanced: Also considers if user can strike FIRST (speed/priority)
  def can_ko_opponent?(user)
    return false unless user && !user.fainted?
    
    @battle.allOtherSideBattlers(user.index).each do |target|
      next unless target && !target.fainted?
      
      user.moves.each do |move|
        next unless move && move.damagingMove?
        next unless move.type
        
        # Check type effectiveness
        type_mod = Effectiveness.calculate(move.type, *target.pbTypes(true))
        next if Effectiveness.ineffective?(type_mod)  # Can't KO with immune move
        
        # STAB bonus
        stab = user.pbHasType?(move.type) ? 1.5 : 1.0
        
        # Choose attack stat based on move category
        if move.physicalMove?
          atk = user.attack
          def_stat = target.defense
        else
          atk = user.spatk
          def_stat = target.spdef
        end
        
        # Simplified damage formula (conservative estimate)
        # Real formula: ((2*Level/5 + 2) * Power * A/D / 50 + 2) * Modifiers
        # Simplified: (A * Power / D) * STAB * Effectiveness / 100
        base_damage = (atk * move.power) / [def_stat, 1].max
        effectiveness_multiplier = Effectiveness.super_effective?(type_mod) ? 2.0 : 
                                   Effectiveness.not_very_effective?(type_mod) ? 0.5 : 1.0
        estimated_damage = (base_damage * stab * effectiveness_multiplier) / 100
        
        # Can KO? Add small buffer for random damage rolls
        if estimated_damage >= target.hp * 0.85
          # Additional check: Can we strike FIRST?
          # This is critical when both Pokemon are in KO range
          move_priority = move.priority || 0
          
          # If we have priority advantage, we can KO first
          return true if move_priority > 0
          
          # If equal priority, check speed
          if move_priority == 0
            # We can KO first if we're faster
            return true if user.pbSpeed > target.pbSpeed
            
            # Even if slower, if opponent CAN'T KO us back, still worth staying
            # (This handles the "I can 2HKO them but they can't touch me" scenario)
            opponent_can_ko_us = target.moves.any? do |opp_move|
              next false unless opp_move && opp_move.damagingMove?
              opp_type_mod = Effectiveness.calculate(opp_move.type, *user.pbTypes(true)) rescue 1.0
              next false if Effectiveness.ineffective?(opp_type_mod)
              
              opp_stab = target.pbHasType?(opp_move.type) ? 1.5 : 1.0
              opp_atk = opp_move.physicalMove? ? target.attack : target.spatk
              our_def = opp_move.physicalMove? ? user.defense : user.spdef
              
              opp_damage = (opp_atk * opp_move.power) / [our_def, 1].max
              opp_eff_mult = Effectiveness.super_effective?(opp_type_mod) ? 2.0 :
                             Effectiveness.not_very_effective?(opp_type_mod) ? 0.5 : 1.0
              opp_estimated = (opp_damage * opp_stab * opp_eff_mult) / 100
              
              opp_estimated >= user.hp * 0.85
            end
            
            return true unless opponent_can_ko_us
          end
        end
      end
    end
    
    return false
  end
  
  #=============================================================================
  # SACRIFICE PLAY LOGIC - Intentional sacs for momentum
  #=============================================================================
  
  def evaluate_sacrifice_value(user, skill)
    return 0 unless skill >= 80
    score = 0
    
    # Is current mon "doomed"? (Will die this turn regardless)
    hp_percent = user.hp.to_f / user.totalhp
    is_doomed = false
    
    @battle.allOtherSideBattlers(user.index).each do |target|
      next unless target && !target.fainted?
      
      # Check if opponent can OHKO us with priority or outspeeds us
      target.moves.each do |move|
        next unless move && move.damagingMove?
        
        # Rough damage estimate
        rough_damage = estimate_sac_damage_percent(user, move, target)
        
        if rough_damage >= hp_percent * 100
          if move.priority > 0 || target.pbSpeed > user.pbSpeed
            is_doomed = true
            break
          end
        end
      end
      break if is_doomed
    end
    
    return 0 unless is_doomed
    
    # Doomed mon has sacrifice value - what can we accomplish?
    sac_value = 0
    
    # 1. Can we get a free switch to a sweeper?
    party = @battle.pbParty(user.index)
    sweepers = party.select do |pkmn|
      next false unless pkmn && !pkmn.fainted? && !pkmn.egg?
      next false if @battle.pbFindBattler(party.index(pkmn), user.index)
      # Is it a setup sweeper?
      pkmn.moves.any? { |m| m && AdvancedAI.setup_move?(m.id) }
    end
    
    sac_value += 20 if sweepers.any?
    
    # 2. Can we burn opponent's Dynamax turn by dying?
    @battle.allOtherSideBattlers(user.index).each do |target|
      if target.respond_to?(:dynamax?) && target.dynamax?
        sac_value += 30  # They waste Dynamax damage on fodder
      end
      if target.respond_to?(:tera?) && target.tera?
        sac_value += 15  # Less valuable but still good
      end
    end
    
    # 3. Can we use Explosion/Self-Destruct/Final Gambit to trade?
    trade_moves = user.moves.select { |m| m && [:EXPLOSION, :SELFDESTRUCT, :FINALGAMBIT, :MISTYEXPLOSION].include?(m.id) }
    if trade_moves.any?
      sac_value += 25  # Can at least trade
    end
    
    # 4. Entry hazards - dying sets up rocks
    if user.moves.any? { |m| m && [:STEALTHROCK, :SPIKES, :TOXICSPIKES].include?(m.id) }
      opp_side = @battle.sides[(user.index + 1) % 2]
      unless opp_side.effects[PBEffects::StealthRock]
        sac_value += 15  # Can set rocks before dying
      end
    end
    
    sac_value
  end
  
  def estimate_sac_damage_percent(defender, move, attacker)
    return 0 unless move && move.power && move.power > 0
    
    atk = move.physicalMove? ? attacker.attack : attacker.spatk
    defense = move.physicalMove? ? defender.defense : defender.spdef
    defense = [defense, 1].max
    
    type_mod = Effectiveness.calculate(move.type, defender.types[0], defender.types[1])
    type_mult = type_mod.to_f / Effectiveness::NORMAL_EFFECTIVE.to_f
    stab = attacker.pbHasType?(move.type) ? 1.5 : 1.0
    
    damage = ((2 * attacker.level / 5.0 + 2) * move.power * atk / defense / 50 + 2)
    damage *= type_mult * stab
    
    (damage / defender.totalhp.to_f * 100).to_i
  end
  
  #=============================================================================
  # ENTRY HAZARD DAMAGE CALCULATION
  #=============================================================================
  
  # Calculate total damage from entry hazards on switch-in
  # Returns damage as percentage of total HP (0.0 to 1.0+)
  def calculate_entry_hazard_damage(switch_pkmn, current_user)
    return 0.0 unless switch_pkmn && current_user
    
    total_damage = 0.0
    # Handle current_user being either a Battler or an index integer
    user_index = get_battler_index(current_user)
    opponent_side = @battle.sides[(user_index + 1) % 2]
    our_side = @battle.sides[user_index % 2]
    
    # === STEALTH ROCK ===
    if our_side.effects[PBEffects::StealthRock]
      # Stealth Rock damage based on Rock-type effectiveness
      sr_effectiveness = Effectiveness.calculate(:ROCK, *switch_pkmn.types.compact)
      sr_multiplier = sr_effectiveness.to_f / Effectiveness::NORMAL_EFFECTIVE_MULTIPLIER
      
      # Base damage is 12.5% (1/8 of max HP)
      sr_damage = 0.125 * sr_multiplier
      total_damage += sr_damage
      
      if AdvancedAI::DEBUG_SWITCH_INTELLIGENCE
        PBDebug.log("[HAZARD] Stealth Rock: #{(sr_damage * 100).round(1)}% (#{sr_multiplier}x effective)", "Switch")
      end
    end
    
    # === SPIKES ===
    spikes_layers = our_side.effects[PBEffects::Spikes]
    if spikes_layers && spikes_layers > 0
      # Spikes don't affect Flying types or Levitate
      grounded = !switch_pkmn.types.include?(:FLYING)
      grounded = grounded && switch_pkmn.ability_id != :LEVITATE
      
      if grounded
        # 1 layer = 12.5%, 2 layers = 16.67%, 3 layers = 25%
        spikes_damage = case spikes_layers
                        when 1 then 0.125   # 1/8
                        when 2 then 0.16667 # 1/6
                        else 0.25           # 1/4
                        end
        total_damage += spikes_damage
        
        if AdvancedAI::DEBUG_SWITCH_INTELLIGENCE
          PBDebug.log("[HAZARD] Spikes (#{spikes_layers} layers): #{(spikes_damage * 100).round(1)}%", "Switch")
        end
      end
    end
    
    # === TOXIC SPIKES ===
    toxic_spikes_layers = our_side.effects[PBEffects::ToxicSpikes]
    if toxic_spikes_layers && toxic_spikes_layers > 0
      # Toxic Spikes don't affect Flying, Poison, or Steel types
      grounded = !switch_pkmn.types.include?(:FLYING)
      grounded = grounded && switch_pkmn.ability_id != :LEVITATE
      immune = switch_pkmn.types.include?(:POISON) || switch_pkmn.types.include?(:STEEL)
      
      if grounded && !immune
        # No immediate damage, but inflicts poison/bad poison
        # We should penalize this in a different way (status condition value)
        # For now, assign a moderate penalty value
        total_damage += 0.10  # 10% "value" for getting poisoned
        
        if AdvancedAI::DEBUG_SWITCH_INTELLIGENCE
          status_type = toxic_spikes_layers >= 2 ? "Badly Poisoned" : "Poisoned"
          PBDebug.log("[HAZARD] Toxic Spikes: #{status_type} on switch-in", "Switch")
        end
      end
    end
    
    # === STICKY WEB ===
    if our_side.effects[PBEffects::StickyWeb]
      # Sticky Web lowers Speed by 1 stage (no immediate damage)
      # Flying types and Levitate are immune
      grounded = !switch_pkmn.types.include?(:FLYING)
      grounded = grounded && switch_pkmn.ability_id != :LEVITATE
      
      if grounded
        # Assign a penalty for speed drop (especially bad for fast Pokemon)
        # Speed-oriented Pokemon (high speed stat) should value this more
        speed_ratio = switch_pkmn.speed.to_f / 130.0  # Normalize to common max speed
        sticky_web_penalty = [0.05 * speed_ratio, 0.15].min  # 5-15% penalty
        total_damage += sticky_web_penalty
        
        if AdvancedAI::DEBUG_SWITCH_INTELLIGENCE
          PBDebug.log("[HAZARD] Sticky Web: Speed -1 stage (~#{(sticky_web_penalty * 100).round(1)}% penalty)", "Switch")
        end
      end
    end
    
    # === HEAVY-DUTY BOOTS CHECK ===
    # If Pokemon has Heavy-Duty Boots, it ignores all entry hazards
    if switch_pkmn.item_id == :HEAVYDUTYBOOTS
      if AdvancedAI::DEBUG_SWITCH_INTELLIGENCE && total_damage > 0
        PBDebug.log("[ITEM] Heavy-Duty Boots: Hazard damage negated!", "Switch")
      end
      return 0.0
    end
    
    # === MAGIC GUARD CHECK ===
    # Magic Guard prevents indirect damage
    if switch_pkmn.ability_id == :MAGICGUARD
      if AdvancedAI::DEBUG_SWITCH_INTELLIGENCE && total_damage > 0
        PBDebug.log("[ABILITY] Magic Guard: Hazard damage negated!", "Switch")
      end
      # Still suffer from Sticky Web speed drop and Toxic Spikes status
      # Return only the non-damage hazard penalties
      non_damage_penalty = 0.0
      non_damage_penalty += 0.10 if toxic_spikes_layers && toxic_spikes_layers > 0  # Poison penalty
      if our_side.effects[PBEffects::StickyWeb]
        speed_ratio = switch_pkmn.speed.to_f / 130.0
        non_damage_penalty += [0.05 * speed_ratio, 0.15].min
      end
      return non_damage_penalty
    end
    
    total_damage
  end
  
  #=============================================================================
  # SETUP MOVE DETECTION
  #=============================================================================
  
  # Detect if opponent is setting up (stat boosts)
  def opponent_is_setting_up?(opponent)
    return false unless opponent
    
    # Check if opponent has positive stat stages
    positive_stages = opponent.stages.values.count { |stage| stage > 0 }
    return true if positive_stages >= 2  # +2 or more boosts = setup threat
    
    # Check if opponent used setup move last turn
    last_move = opponent.battler.lastMoveUsed rescue nil
    return true if last_move && is_setup_move?(last_move)
    
    false
  end
  
  # Check if move is a setup move
  def is_setup_move?(move_id)
    @setup_move_cache ||= {}
    return @setup_move_cache[move_id] if @setup_move_cache.key?(move_id)
    
    setup_moves = [
      :SWORDSDANCE, :DRAGONDANCE, :NASTYPLOT, :CALMMIND, :QUIVERDANCE,
      :BULKUP, :CURSE, :AGILITY, :ROCKPOLISH, :AUTOTOMIZE,
      :TAILWIND, :TRICKROOM, :SHELLSMASH, :GEOMANCY, :GROWTH,
      :HONECLAWS, :WORKUP, :MEDITATE, :SHARPEN, :DEFENSECURL,
      :WITHDRAW, :HARDENPOKEMON, :ACIDARMOR, :BARRIER, :IRONDEFENSE,
      :AMNESIA, :COSMICPOWER, :STOCKPILE, :COIL, :VICTORYDANCE
    ]
    
    result = setup_moves.include?(move_id)
    @setup_move_cache[move_id] = result
    result
  end
  
  # Evaluate setup threat level
  def evaluate_setup_threat(opponent)
    return 0 unless opponent
    
    threat = 0
    
    # Count positive stat stages
    offensive_boosts = [opponent.stages[:ATTACK], opponent.stages[:SPECIAL_ATTACK]].max
    speed_boosts = opponent.stages[:SPEED]
    
    # High offensive boosts = big threat
    threat += offensive_boosts * 20 if offensive_boosts > 0
    threat += speed_boosts * 15 if speed_boosts > 0
    
    # Check if opponent has setup moves in their moveset
    opponent.moves.each do |move|
      next unless move
      if is_setup_move?(move.id)
        threat += 10  # Has setup potential
      end
    end
    
    threat
  end
  
  #=============================================================================
  # SPEED TIER AWARENESS
  #=============================================================================
  
  # Check if switch-in can outspeed opponent
  def can_outspeed?(switch_pkmn, opponent)
    return false unless switch_pkmn && opponent
    
    # Get base speeds (party Pokemon doesn't have pbSpeed, calculate manually)
    switch_speed = calculate_party_speed(switch_pkmn)
    opponent_speed = opponent.pbSpeed
    
    # Account for priority moves (always "outspeed")
    # This is checked elsewhere, but good to know
    
    switch_speed > opponent_speed
  end
  
  # Calculate speed for party Pokemon (not in battle yet)
  def calculate_party_speed(pkmn)
    return 0 unless pkmn
    
    # Basic stat calculation (no stages since not in battle)
    base_speed = pkmn.speed
    
    # Nature modifier
    nature = pkmn.nature_id
    if nature
      nature_data = GameData::Nature.get(nature)
      if nature_data.stat_changes[:SPEED] == 10
        base_speed = (base_speed * 1.1).floor
      elsif nature_data.stat_changes[:SPEED] == -10
        base_speed = (base_speed * 0.9).floor
      end
    end
    
    # Item modifiers
    if pkmn.item_id == :CHOICESCARF
      base_speed = (base_speed * 1.5).floor
    elsif pkmn.item_id == :IRONBALL
      base_speed = (base_speed * 0.5).floor
    end
    
    # Ability modifiers (basic ones)
    case pkmn.ability_id
    when :SWIFTSWIM
      base_speed = (base_speed * 2).floor if @battle.pbWeather == :Rain
    when :CHLOROPHYLL
      base_speed = (base_speed * 2).floor if @battle.pbWeather == :Sun
    when :SANDRUSH
      base_speed = (base_speed * 2).floor if @battle.pbWeather == :Sandstorm
    when :SLUSHRUSH
      base_speed = (base_speed * 2).floor if @battle.pbWeather == :Hail
    when :SPEEDBOOST
      # Can't account for this pre-switch
    end
    
    base_speed
  end
  
  # Evaluate speed advantage for switch decision
  def evaluate_speed_advantage(switch_pkmn, current_user)
    score = 0
    
    @battle.allOtherSideBattlers(get_battler_index(current_user)).each do |opponent|
      next unless opponent && !opponent.fainted?
      
      if can_outspeed?(switch_pkmn, opponent)
        score += 15  # Outspeeding is valuable
        
        # Extra value if we can OHKO while outspeeding
        switch_pkmn.moves.each do |move|
          next unless move && move.damagingMove?
          
          # Rough damage check (would need full calc for accuracy)
          move_type = move.type
          opp_types = opponent.pbTypes(true)
          effectiveness = Effectiveness.calculate(move_type, *opp_types)
          
          if Effectiveness.super_effective?(effectiveness)
            score += 10  # Can hit hard while faster
            break
          end
        end
      else
        # Slower = need to tank a hit
        score -= 5
      end
    end
    
    score
  end
  
  #=============================================================================
  # PIVOT MOVE EVALUATION
  #=============================================================================
  
  # Evaluate if pivot move is available and better than hard switch
  # Returns bonus to REDUCE switch score (prefer pivot over switch)
  def evaluate_pivot_move_option(user, skill)
    return 0 unless user && skill >= 50
    
    pivot_moves = [:UTURN, :VOLTSWITCH, :FLIPTURN, :PARTINGSHOT, :TELEPORT, 
                   :BATONPASS, :SHEDTAIL, :CHILLYRECEPTION]
    
    bonus = 0
    
    user.moves.each do |move|
      next unless move && pivot_moves.include?(move.id)
      
      # Base bonus for having a pivot move
      bonus += 25
      
      # Extra bonus if pivot move is damaging and super effective
      if [:UTURN, :VOLTSWITCH, :FLIPTURN].include?(move.id)
        @battle.allOtherSideBattlers(user.index).each do |target|
          next unless target && !target.fainted?
          
          move_type = GameData::Move.get(move.id).type
          effectiveness = Effectiveness.calculate(move_type, *target.pbTypes(true))
          
          if Effectiveness.super_effective?(effectiveness)
            bonus += 10  # Can deal damage + switch safely
            break
          end
        end
      end
      
      # Parting Shot is especially valuable (debuff + safe switch)
      bonus += 15 if move.id == :PARTINGSHOT
      
      # Only count first pivot move found
      break
    end
    
    bonus
  end
  
  #=============================================================================
  # RECOVERY MOVE TIMING
  #=============================================================================
  
  # Determine if recovery move should be used instead of attacking/switching
  # Called from Move_Scorer when evaluating recovery moves
  def should_use_recovery_move?(user, recovery_move, skill)
    return false unless user && recovery_move
    return false if skill < 50  # Low skill AI doesn't optimize recovery
    
    hp_percent = user.hp.to_f / user.totalhp
    
    # Don't heal if healthy (>75% HP)
    return false if hp_percent > 0.75
    
    # Always heal if critical (<25% HP) and not slower than opponent
    if hp_percent < 0.25
      @battle.allOtherSideBattlers(user.index).each do |opponent|
        next unless opponent && !opponent.fainted?
        
        # If opponent outspeeds us and can OHKO, don't waste turn healing
        if opponent.pbSpeed > user.pbSpeed
          opponent.moves.each do |move|
            next unless move && move.damagingMove?
            
            # Rough damage estimate
            damage_percent = estimate_incoming_damage_percent(user, move, opponent)
            return false if damage_percent >= hp_percent * 100  # Would die anyway
          end
        end
      end
      
      # Safe to heal - no immediate OHKO threat or we're faster
      return true
    end
    
    # Moderate HP (25-50%) - heal if opponent can 2HKO
    if hp_percent < 0.50
      can_2hko = false
      
      @battle.allOtherSideBattlers(user.index).each do |opponent|
        next unless opponent && !opponent.fainted?
        
        opponent.moves.each do |move|
          next unless move && move.damagingMove?
          
          damage_percent = estimate_incoming_damage_percent(user, move, opponent)
          if damage_percent >= 45  # Would be 2HKO'd
            can_2hko = true
            break
          end
        end
        break if can_2hko
      end
      
      return true if can_2hko  # Heal to avoid 2HKO range
    end
    
    # Moderate HP (50-75%) - heal if we're stalling (status damage, weather, etc.)
    if hp_percent < 0.75
      # Check if we're benefiting from stall tactics
      stall_benefits = 0
      
      # Toxic/Burn on opponent
      @battle.allOtherSideBattlers(user.index).each do |opponent|
        next unless opponent && !opponent.fainted?
        stall_benefits += 1 if [:BURN, :POISON].include?(opponent.status)
      end
      
      # Leech Seed
      stall_benefits += 1 if user.effects[PBEffects::LeechSeed] >= 0
      
      # Leftovers
      stall_benefits += 1 if user.item_id == :LEFTOVERS
      
      # Weather damage to opponent
      weather = @battle.pbWeather
      if [:Sandstorm, :Hail].include?(weather)
        @battle.allOtherSideBattlers(user.index).each do |opponent|
          next unless opponent && !opponent.fainted?
          # Opponent takes weather damage, we might not
          stall_benefits += 1
        end
      end
      
      return true if stall_benefits >= 2  # Multiple stall advantages
    end
    
    false  # Don't heal by default
  end
  
  # Quick damage estimate for recovery timing (simpler than full calc)
  def estimate_incoming_damage_percent(defender, move, attacker)
    return 0 unless move && move.power && move.power > 0
    
    atk = move.physicalMove? ? attacker.attack : attacker.spatk
    defense = move.physicalMove? ? defender.defense : defender.spdef
    defense = [defense, 1].max
    
    move_type = move.pbCalcType(attacker) rescue move.type
    defender_types = defender.pbTypes(true)
    effectiveness = Effectiveness.calculate(move_type, *defender_types)
    type_mult = effectiveness.to_f / Effectiveness::NORMAL_EFFECTIVE_MULTIPLIER
    
    stab = attacker.pbHasType?(move_type) ? STAB_MULTIPLIER : 1.0
    
    level = attacker.level
    base_damage = ((2.0 * level / 5 + 2) * move.power * atk / defense / 50 + 2)
    estimated_damage = base_damage * stab * type_mult * DAMAGE_RANDOM_MULTIPLIER
    
    (estimated_damage / defender.totalhp.to_f * 100).round
  end
  
  #=============================================================================
  # DEBUG TOOLS
  #=============================================================================
  
  # Enhanced damage calculation with debug output
  def debug_damage_calculation(switch_pkmn, move, attacker, show_breakdown: false)
    damage = calculate_incoming_damage(switch_pkmn, move, attacker)
    
    if show_breakdown && AdvancedAI::DEBUG_SWITCH_INTELLIGENCE
      PBDebug.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━", "Damage Calc")
      PBDebug.log("DAMAGE BREAKDOWN: #{move.name} → #{switch_pkmn.name}", "Damage Calc")
      PBDebug.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━", "Damage Calc")
      
      # Move info
      move_type = move.pbCalcType(attacker) rescue move.type
      PBDebug.log("Move: #{move.name} (#{move_type}, #{move.power} BP)", "Damage Calc")
      
      # Type effectiveness
      effectiveness = Effectiveness.calculate(move_type, *switch_pkmn.types.compact)
      eff_mult = effectiveness.to_f / Effectiveness::NORMAL_EFFECTIVE_MULTIPLIER
      PBDebug.log("Effectiveness: #{eff_mult}x (#{switch_pkmn.types.join('/')} vs #{move_type})", "Damage Calc")
      
      # Stats
      if move.physicalMove?
        PBDebug.log("Physical: #{attacker.attack} Atk vs #{switch_pkmn.defense} Def", "Damage Calc")
      else
        PBDebug.log("Special: #{attacker.spatk} SpA vs #{switch_pkmn.spdef} SpD", "Damage Calc")
      end
      
      # Abilities
      PBDebug.log("Attacker Ability: #{attacker.ability_id}", "Damage Calc") if attacker.ability_id
      PBDebug.log("Defender Ability: #{switch_pkmn.ability_id}", "Damage Calc") if switch_pkmn.ability_id
      
      # Final damage
      PBDebug.log("RESULT: #{(damage * 100).round(1)}% damage", "Damage Calc")
      PBDebug.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━", "Damage Calc")
    end
    
    damage
  end
  
  # Log switch decision reasoning
  def log_switch_decision(user, should_switch, best_switch_idx = nil)
    return unless AdvancedAI::DEBUG_SWITCH_INTELLIGENCE
    
    PBDebug.log("", "Switch Decision")
    PBDebug.log("═══════════════════════════════════════", "Switch Decision")
    PBDebug.log("SWITCH DECISION SUMMARY", "Switch Decision")
    PBDebug.log("═══════════════════════════════════════", "Switch Decision")
    PBDebug.log("Current: #{user.name} (#{user.hp}/#{user.totalhp} HP)", "Switch Decision")
    
    if should_switch && best_switch_idx
      party = @battle.pbParty(user.index)
      best_mon = party[best_switch_idx]
      PBDebug.log("DECISION: ✅ SWITCH to #{best_mon.name}", "Switch Decision")
      PBDebug.log("Reason: Better matchup / Strategic advantage", "Switch Decision")
    else
      PBDebug.log("DECISION: ❌ STAY with #{user.name}", "Switch Decision")
      reasons = []
      reasons << "No better matchup" unless should_switch
      reasons << "Can secure KO" if can_ko_opponent?(user)
      reasons << "Has stat boosts" if user.stages.values.any? { |s| s > 0 }
      reasons << "Just switched in" if user.turnCount < 2
      PBDebug.log("Reason: #{reasons.join(', ')}", "Switch Decision")
    end
    
    PBDebug.log("═══════════════════════════════════════", "Switch Decision")
    PBDebug.log("", "Switch Decision")
  end
end

AdvancedAI.log("Switch Intelligence loaded", "Switch")
AdvancedAI.log("  - Sacrifice play logic", "Switch")
AdvancedAI.log("  - Setup move detection", "Switch")
AdvancedAI.log("  - Speed tier awareness", "Switch")
AdvancedAI.log("  - Ability/Item-aware damage calc", "Switch")
AdvancedAI.log("  - Debug tools enabled", "Switch")

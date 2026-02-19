#===============================================================================
# Advanced AI System - Strategic Awareness
# Features: Opponent Archetype Recognition, Opponent Win Condition Counter-Play,
# Dynamic Win Condition Shifting, Type Coverage Gap Mapping,
# Collective Health Tracking, Opponent Threat Persistence,
# Proactive Sacking, Defensive Core Recognition
#===============================================================================

module AdvancedAI
  module StrategicAwareness
    #===========================================================================
    # Battle State — persists across turns within a single battle
    #===========================================================================
    @battle_states = {}

    def self.get_state(battle)
      @battle_states[battle.object_id] ||= {
        previous_win_condition: nil,
        win_condition_history:  [],
        eliminated_threats:     [],
        remaining_threats:      [],
        opponent_archetype:     nil,
        archetype_confidence:   0,
        health_trajectory:      [],     # [{turn, our_pct, opp_pct}]
        coverage_gaps:          [],
        critical_pokemon:       [],     # Pokemon that must be preserved
      }
    end

    def self.cleanup(battle)
      @battle_states.delete(battle.object_id) if battle
    end

    #===========================================================================
    # 1. OPPONENT TEAM ARCHETYPE RECOGNITION
    #===========================================================================
    ARCHETYPE_DEFINITIONS = {
      hyper_offense: {
        min_fast_attackers: 4,     # ≥100 speed AND ≥100 attack/spatk
        max_walls: 1,
        hazard_setters: 1,
        description: "All-out attack, minimal defensive backbone"
      },
      balance: {
        min_fast_attackers: 2,
        min_walls: 1,
        min_pivots: 1,
        description: "Mix of offense and defense with pivoting"
      },
      stall: {
        min_walls: 3,
        min_recovery_users: 3,
        max_fast_attackers: 1,
        description: "Passive damage, recovery, and walling"
      },
      rain: { weather: :Rain, description: "Rain-boosted sweepers" },
      sun:  { weather: :Sun,  description: "Sun-boosted sweepers" },
      sand: { weather: :Sandstorm, description: "Sand + Rock/Ground/Steel bulk" },
      hail: { weather: :Hail, description: "Hail/Snow + Aurora Veil" },
      trick_room: {
        min_slow_pokemon: 3,     # ≤50 speed
        has_tr_setter: true,
        description: "Slow Pokemon + Trick Room reversals"
      },
      volt_turn: {
        min_pivots: 3,
        description: "U-turn / Volt Switch / Flip Turn cycling"
      }
    }

    # Rain/Sun/Sand/Hail weather setter abilities
    WEATHER_ABILITIES = {
      :DRIZZLE => :Rain, :PRIMORDIALSEA => :Rain,
      :DROUGHT => :Sun,  :DESOLATELAND => :Sun,
      :SANDSTREAM => :Sandstorm, :SANDSPIT => :Sandstorm,
      :SNOWWARNING => :Hail, :ORICHALCUMPULSE => :Sun,
    }

    RAIN_ABUSERS  = [:SWIFTSWIM, :RAINDISH, :DRYSKIN, :HYDRATION]
    SUN_ABUSERS   = [:CHLOROPHYLL, :SOLARPOWER, :LEAFGUARD, :FLOWERGIFT, :HARVEST]
    SAND_ABUSERS  = [:SANDRUSH, :SANDFORCE, :SANDVEIL]
    HAIL_ABUSERS  = [:SLUSHRUSH, :ICEBODY, :SNOWCLOAK, :ICEFACE]

    PIVOT_MOVES = [:UTURN, :VOLTSWITCH, :FLIPTURN, :PARTINGSHOT, :TELEPORT, :BATONPASS]
    TR_MOVES    = [:TRICKROOM]

    def self.identify_opponent_archetype(battle, user_index)
      state = get_state(battle)
      return state[:opponent_archetype] if state[:opponent_archetype] && state[:archetype_confidence] >= 80

      opp_pokemon = []
      # Gather all known opponent Pokemon (active + revealed in team preview/prior switches)
      battle.allOtherSideBattlers(user_index).each do |b|
        opp_pokemon << b if b && !b.fainted?
      end
      # Also check party for fainted but revealed mons
      opp_party = battle.pbParty(user_index.even? ? 1 : 0) rescue []
      opp_party.each do |pkmn|
        next if !pkmn || pkmn.egg?
        opp_pokemon << pkmn unless opp_pokemon.any? { |p|
          (p.respond_to?(:pokemon) ? p.pokemon : p) == pkmn
        }
      end

      return :unknown if opp_pokemon.empty?

      # Classify each Pokemon
      fast_attackers = 0
      walls = 0
      recovery_users = 0
      pivots = 0
      slow_pokemon = 0
      weather_setters = {}
      weather_abusers = {}
      has_tr_setter = false

      opp_pokemon.each do |mon|
        spd = get_stat(mon, :speed)
        atk = [get_stat(mon, :attack), get_stat(mon, :spatk)].max
        dfn = [get_stat(mon, :defense), get_stat(mon, :spdef)].max
        hp  = get_stat(mon, :hp)

        fast_attackers += 1 if spd >= 95 && atk >= 95
        walls += 1 if dfn >= 90 && hp >= 80 && atk < 90
        slow_pokemon += 1 if spd <= 55

        # Check ability
        ability_id = get_ability(mon)
        if WEATHER_ABILITIES[ability_id]
          w = WEATHER_ABILITIES[ability_id]
          weather_setters[w] = (weather_setters[w] || 0) + 1
        end
        RAIN_ABUSERS.each  { |a| weather_abusers[:Rain] = (weather_abusers[:Rain] || 0) + 1 if ability_id == a }
        SUN_ABUSERS.each   { |a| weather_abusers[:Sun]  = (weather_abusers[:Sun]  || 0) + 1 if ability_id == a }
        SAND_ABUSERS.each  { |a| weather_abusers[:Sandstorm] = (weather_abusers[:Sandstorm] || 0) + 1 if ability_id == a }
        HAIL_ABUSERS.each  { |a| weather_abusers[:Hail] = (weather_abusers[:Hail] || 0) + 1 if ability_id == a }

        # Check moves for pivots / TR / recovery
        moves = get_known_moves(battle, mon)
        moves.each do |mid|
          pivots += 1 if PIVOT_MOVES.include?(mid)
          has_tr_setter = true if TR_MOVES.include?(mid)
          if AdvancedAI.healing_move?(mid)
            recovery_users += 1
          end
        end if moves
      end

      # Score each archetype
      scores = {}

      # Weather teams
      [:Rain, :Sun, :Sandstorm, :Hail].each do |w|
        key = { Rain: :rain, Sun: :sun, Sandstorm: :sand, Hail: :hail }[w]
        if weather_setters[w] && weather_setters[w] >= 1
          scores[key] = 50 + (weather_abusers[w] || 0) * 20
        end
      end

      # Trick Room
      if has_tr_setter && slow_pokemon >= 3
        scores[:trick_room] = 60 + slow_pokemon * 10
      end

      # Volt-Turn
      scores[:volt_turn] = pivots * 25 if pivots >= 3

      # Stall
      if walls >= 3 && recovery_users >= 2
        scores[:stall] = 40 + walls * 15 + recovery_users * 10
      end

      # Hyper Offense
      if fast_attackers >= 4 && walls <= 1
        scores[:hyper_offense] = 40 + fast_attackers * 15
      end

      # Balance (default-ish)
      if fast_attackers >= 2 && walls >= 1
        scores[:balance] = 30 + fast_attackers * 8 + walls * 8 + pivots * 5
      end

      if scores.empty?
        archetype = :balance
        confidence = 30
      else
        archetype = scores.max_by { |_, v| v }.first
        confidence = [scores.values.max, 100].min
      end

      state[:opponent_archetype] = archetype
      state[:archetype_confidence] = confidence
      AdvancedAI.log("[Strategy] Opponent archetype: #{archetype} (#{confidence}%)", "Strategy")
      archetype
    end

    #===========================================================================
    # 2. OPPONENT WIN CONDITION COUNTER-PLAY
    #===========================================================================
    def self.opponent_win_condition_counter(battle, user, move, target)
      return 0 unless target
      archetype = identify_opponent_archetype(battle, user.index) rescue :balance
      bonus = 0

      case archetype
      when :stall
        # Counter stall: Taunt their healers, setup to overpower, Knock Off
        if move.id == :TAUNT
          bonus += 30  # Shut down recovery/status
        end
        if AdvancedAI.setup_move?(move.id)
          bonus += 15  # Setup to break through stall
        end
        if move.id == :KNOCKOFF
          bonus += 20  # Remove Leftovers/Black Sludge
        end
        # Don't play slow vs stall
        if AdvancedAI.stall_move?(move.id)
          bonus -= 20  # They're better at stalling than us
        end

      when :hyper_offense
        # Counter HO: priority, bulk, screens
        if move.priority > 0 && move.damagingMove?
          bonus += 20  # Priority stops their fast mons
        end
        if AdvancedAI.screen_move?(move.id)
          bonus += 15  # Screens blunt their offense
        end
        if AdvancedAI.healing_move?(move.id) && user.hp < user.totalhp * 0.5
          bonus -= 15  # Don't try to heal vs overwhelming offense
        end

      when :rain, :sun, :sand, :hail
        # Counter weather: change weather or use your own weather advantage
        weather_setting_moves = {
          rain: [:SUNNYDAY, :SANDSTORM, :SNOWSCAPE, :HAIL],
          sun:  [:RAINDANCE, :SANDSTORM, :SNOWSCAPE, :HAIL],
          sand: [:RAINDANCE, :SUNNYDAY, :SNOWSCAPE, :HAIL],
          hail: [:RAINDANCE, :SUNNYDAY, :SANDSTORM],
        }
        if weather_setting_moves[archetype]&.include?(move.id)
          bonus += 25  # Override their weather
        end

      when :trick_room
        # Counter TR: set up your own speed control, priority, Taunt the setter
        if move.id == :TAUNT
          bonus += 25  # Block Trick Room
        end
        if move.priority > 0 && move.damagingMove?
          bonus += 15  # Priority ignores speed under TR
        end
        # Our own Trick Room can undo theirs
        if move.id == :TRICKROOM
          bonus += 20
        end

      when :volt_turn
        # Counter pivot chains: trapping, Pursuit, prediction
        if move.id == :PURSUIT
          bonus += 30  # Punish switches
        end
        # Hazards punish constant switching
        if AdvancedAI.hazard_move?(move.id)
          bonus += 20
        end
      end

      bonus
    end

    #===========================================================================
    # 3. DYNAMIC WIN CONDITION SHIFTING
    #===========================================================================
    def self.update_win_condition(battle, user, current_win_con)
      state = get_state(battle)
      prev = state[:previous_win_condition]

      if current_win_con
        state[:win_condition_history] << {
          turn: battle.turnCount,
          type: current_win_con[:type],
          score: current_win_con[:score]
        }
      end

      shift_bonus = 0

      # Detect if our win condition changed (plan failed, adapt)
      if prev && current_win_con && prev != current_win_con[:type]
        AdvancedAI.log("[Strategy] Win condition shifted: #{prev} → #{current_win_con[:type]}", "Strategy")

        # Transitional bonuses to help the AI adapt
        case current_win_con[:type]
        when :attrition
          # Shifted to attrition — boost hazards and recovery
          shift_bonus = 10
        when :stall
          # Shifted to stall — play very conservatively
          shift_bonus = 15
        when :trade
          # Forced into trading — be aggressive
          shift_bonus = 5
        end
      end

      state[:previous_win_condition] = current_win_con ? current_win_con[:type] : nil
      shift_bonus
    end

    # Returns a bonus for moves that align with the shifted strategy
    def self.win_condition_shift_bonus(battle, user, move, current_win_con)
      state = get_state(battle)
      history = state[:win_condition_history]
      return 0 if history.length < 2

      prev_type = history[-2][:type] rescue nil
      curr_type = current_win_con ? current_win_con[:type] : nil
      return 0 unless prev_type && curr_type && prev_type != curr_type

      bonus = 0
      # Sweep attempt failed → adapt
      if prev_type == :sweep && curr_type != :sweep
        # Our sweeper died; pivot to attrition/trade
        bonus += 10 if AdvancedAI.hazard_move?(move.id)
        bonus += 10 if move.damagingMove? && move.power >= 80
      end

      # Attrition not working → go aggressive
      if prev_type == :attrition && [:trade, :sweep].include?(curr_type)
        bonus += 10 if move.damagingMove?
        bonus -= 10 if AdvancedAI.healing_move?(move.id)
      end

      # Stall failing → last resort aggression
      if prev_type == :stall && curr_type != :stall
        bonus += 15 if move.damagingMove?
        bonus -= 15 if AdvancedAI.stall_move?(move.id)
      end

      bonus
    end

    #===========================================================================
    # 4. TYPE COVERAGE GAP MAPPING
    #===========================================================================
    ALL_TYPES = [:NORMAL, :FIRE, :WATER, :ELECTRIC, :GRASS, :ICE,
                 :FIGHTING, :POISON, :GROUND, :FLYING, :PSYCHIC, :BUG,
                 :ROCK, :GHOST, :DRAGON, :DARK, :STEEL, :FAIRY]

    # Returns types our team can't effectively handle
    def self.identify_coverage_gaps(battle, user_index)
      state = get_state(battle)
      return state[:coverage_gaps] unless state[:coverage_gaps].empty?

      our_party = battle.pbParty(user_index.even? ? 0 : 1) rescue []
      return [] if our_party.empty?

      # For each type, check if at least one teammate resists AND can threaten
      gaps = []
      ALL_TYPES.each do |atk_type|
        can_handle = false

        our_party.each do |pkmn|
          next if !pkmn || pkmn.fainted? || pkmn.egg?

          types = get_pokemon_types(pkmn)
          # Check if this Pokemon resists/is immune to this type
          eff = type_effectiveness_against(atk_type, types)
          resists = eff < 1.0

          # Check if this Pokemon can threaten back (has SE coverage)
          has_coverage = false
          pkmn.moves.each do |m|
            next if !m || m.pp <= 0
            move_data = GameData::Move.try_get(m.id)
            next if !move_data || move_data.power == 0
            # Does this move hit the attacking type's common Pokemon?
            has_coverage = true  # Simplified: can attack back
            break
          end if pkmn.moves

          if resists && has_coverage
            can_handle = true
            break
          end
        end

        gaps << atk_type unless can_handle
      end

      state[:coverage_gaps] = gaps
      if gaps.any?
        AdvancedAI.log("[Strategy] Coverage gaps: #{gaps.join(', ')}", "Strategy")
      end
      gaps
    end

    # Identifies Pokemon that are the SOLE answer to an opponent threat
    def self.identify_critical_pokemon(battle, user_index)
      state = get_state(battle)
      return state[:critical_pokemon] unless state[:critical_pokemon].empty?

      our_party = battle.pbParty(user_index.even? ? 0 : 1) rescue []
      opp_pokemon = []
      battle.allOtherSideBattlers(user_index).each do |b|
        opp_pokemon << b if b && !b.fainted?
      end

      critical = []

      opp_pokemon.each do |opp|
        opp_types = get_pokemon_types(opp)
        # Find which of our Pokemon can handle this opponent
        handlers = []
        our_party.each do |pkmn|
          next if !pkmn || pkmn.fainted? || pkmn.egg?
          my_types = get_pokemon_types(pkmn)
          # Can resist their STAB and hit back?
          resists_stab = opp_types.all? { |t| type_effectiveness_against(t, my_types) <= 1.0 }
          handlers << pkmn if resists_stab
        end

        # If only ONE handler → that Pokemon is critical
        if handlers.length == 1
          critical << handlers.first unless critical.include?(handlers.first)
          AdvancedAI.log("[Strategy] #{handlers.first.name} is sole answer to #{get_name(opp)}", "Strategy")
        end
      end

      state[:critical_pokemon] = critical
      critical
    end

    # Bonus for preserving critical Pokemon (penalty for risky plays on them)
    def self.preservation_bonus(battle, user, move, target)
      critical = identify_critical_pokemon(battle, user.index)
      return 0 if critical.empty?

      user_pkmn = user.respond_to?(:pokemon) ? user.pokemon : user
      is_critical = critical.any? { |p| p == user_pkmn }
      return 0 unless is_critical

      bonus = 0
      # Critical Pokemon should avoid risky plays
      if move.respond_to?(:recoilMove?) && move.recoilMove?
        bonus -= 15  # Avoid recoil on critical mon
      end
      if [:EXPLOSION, :SELFDESTRUCT, :MISTYEXPLOSION, :FINALGAMBIT, :HEALINGWISH, :LUNARDANCE, :MEMENTO].include?(move.id)
        bonus -= 50  # Never sacrifice the sole answer
      end
      # Conservative play: boost healing
      if AdvancedAI.healing_move?(move.id) && user.hp < user.totalhp * 0.6
        bonus += 15
      end
      bonus
    end

    #===========================================================================
    # 5. COLLECTIVE HEALTH TRACKING
    #===========================================================================
    def self.track_health(battle, user_index)
      state = get_state(battle)

      our_total = 0; our_max = 0
      opp_total = 0; opp_max = 0

      our_party = battle.pbParty(user_index.even? ? 0 : 1) rescue []
      opp_party = battle.pbParty(user_index.even? ? 1 : 0) rescue []

      our_party.each do |p|
        next if !p || p.egg?
        our_max += p.totalhp
        our_total += [p.hp, 0].max
      end

      opp_party.each do |p|
        next if !p || p.egg?
        opp_max += p.totalhp
        opp_total += [p.hp, 0].max
      end

      our_pct = our_max > 0 ? (our_total.to_f / our_max * 100).round : 0
      opp_pct = opp_max > 0 ? (opp_total.to_f / opp_max * 100).round : 0

      state[:health_trajectory] << {
        turn: battle.turnCount,
        our_pct: our_pct,
        opp_pct: opp_pct
      }

      { our_pct: our_pct, opp_pct: opp_pct, advantage: our_pct - opp_pct }
    end

    # Returns a strategic bonus based on resource advantage
    def self.health_advantage_bonus(battle, user, move)
      health = track_health(battle, user.index)
      advantage = health[:advantage]  # positive = we're ahead

      bonus = 0
      if advantage > 30
        # Winning big: play safe, don't take risks
        bonus -= 10 if move.respond_to?(:recoilMove?) && move.recoilMove?
        bonus += 10 if AdvancedAI.healing_move?(move.id)
        bonus -= 15 if [:EXPLOSION, :SELFDESTRUCT].include?(move.id)
      elsif advantage < -30
        # Losing big: be aggressive, take risks
        bonus += 10 if move.damagingMove? && move.power >= 80
        bonus -= 10 if AdvancedAI.healing_move?(move.id) && move.id != :WISH
        bonus += 15 if AdvancedAI.setup_move?(move.id)  # Hail Mary setup
      end
      # Neutral: no adjustment
      bonus
    end

    #===========================================================================
    # 6. OPPONENT THREAT PERSISTENCE
    #===========================================================================
    def self.update_threats(battle, user_index)
      state = get_state(battle)
      current_threats = []

      battle.allOtherSideBattlers(user_index).each do |opp|
        next if !opp || opp.fainted?
        threat_level = AdvancedAI.assess_threat(battle, opp, nil, 100) rescue 5.0
        current_threats << { pokemon: get_name(opp), level: threat_level, alive: true }
      end

      # Check for newly eliminated threats
      prev_names = state[:remaining_threats].map { |t| t[:pokemon] }
      curr_names = current_threats.map { |t| t[:pokemon] }

      eliminated = prev_names - curr_names
      eliminated.each do |name|
        old_entry = state[:remaining_threats].find { |t| t[:pokemon] == name }
        if old_entry
          state[:eliminated_threats] << old_entry.merge(alive: false, turn_eliminated: battle.turnCount)
          AdvancedAI.log("[Strategy] Threat eliminated: #{name} (was #{old_entry[:level].round(1)} threat)", "Strategy")
        end
      end

      state[:remaining_threats] = current_threats

      # Return summary
      {
        remaining: current_threats,
        eliminated: state[:eliminated_threats],
        biggest_threat: current_threats.max_by { |t| t[:level] },
        threats_cleared: state[:eliminated_threats].length
      }
    end

    # Mode shift: if opponent's biggest threat is gone, we can play looser
    def self.threat_persistence_bonus(battle, user, move)
      state = get_state(battle)
      eliminated = state[:eliminated_threats] || []
      return 0 if eliminated.empty?

      # If we eliminated a high-threat mon, be more aggressive
      high_threats_killed = eliminated.count { |t| t[:level] >= 7.0 }
      bonus = 0
      if high_threats_killed >= 1
        bonus += 5 if move.damagingMove?  # Play more aggressively
        bonus += 5 if AdvancedAI.setup_move?(move.id)  # Safer to setup
      end
      bonus
    end

    #===========================================================================
    # 7. PROACTIVE SACKING
    #===========================================================================
    def self.should_sack?(battle, user, target)
      return false unless user && target

      # Conditions for a strategic sack:
      # 1. Current mon is low value (wall that can't wall this threat)
      # 2. A high-value teammate needs a free switch
      # 3. Current mon is going to die this turn anyway

      user_hp_pct = user.hp.to_f / user.totalhp
      user_roles = AdvancedAI.detect_roles(user) rescue [:balanced]

      # If we're going to die anyway, check if dying gets a good switch
      likely_dies = false
      incoming = estimate_max_incoming(battle, user, target)
      likely_dies = true if incoming >= user.hp

      if likely_dies
        # Check if a teammate benefits from free switch
        party = battle.pbParty(user.index)
        party.each do |pkmn|
          next if !pkmn || pkmn.fainted? || pkmn.egg?
          next if pkmn == (user.respond_to?(:pokemon) ? user.pokemon : user)
          pkmn_roles = AdvancedAI.detect_roles(pkmn) rescue [:balanced]
          # Sweeper/wallbreaker wanting a free switch = sack is good
          if (pkmn_roles.include?(:sweeper) || pkmn_roles.include?(:wallbreaker)) && pkmn.hp > pkmn.totalhp * 0.7
            return true
          end
        end
      end

      # Sack a low-value mon to get sweeper in
      if user_roles.include?(:wall) || user_roles.include?(:support)
        if user_hp_pct < 0.25  # Low HP wall = expendable
          party = battle.pbParty(user.index)
          party.each do |pkmn|
            next if !pkmn || pkmn.fainted? || pkmn.egg?
            next if pkmn == (user.respond_to?(:pokemon) ? user.pokemon : user)
            pkmn_roles = AdvancedAI.detect_roles(pkmn) rescue [:balanced]
            if pkmn_roles.include?(:sweeper) && pkmn.hp > pkmn.totalhp * 0.8
              return true
            end
          end
        end
      end

      false
    end

    # If sacking, boost the most damaging move (go down swinging)
    def self.sack_bonus(battle, user, move, target)
      return 0 unless should_sack?(battle, user, target)
      bonus = 0
      if move.damagingMove?
        bonus += 20  # Get value before dying
        bonus += 20 if move.power >= 100  # Heavy hit
      end
      # Pivot out instead of dying for free
      if AdvancedAI.pivot_move?(move.id)
        bonus += 40  # Pivot to the sweeper safely
      end
      bonus
    end

    #===========================================================================
    # 8. DEFENSIVE CORE RECOGNITION
    #===========================================================================
    CLASSIC_CORES = {
      fwg: { types: [:FIRE, :WATER, :GRASS], name: "Fire/Water/Grass" },
      steel_fairy_dragon: { types: [:STEEL, :FAIRY, :DRAGON], name: "Steel/Fairy/Dragon" },
      dark_fairy_fighting: { types: [:DARK, :FAIRY, :FIGHTING], name: "Dark/Fairy/Fighting" },
      ground_steel_flying: { types: [:GROUND, :STEEL, :FLYING], name: "Ground/Steel/Flying" },
      ghost_dark_fighting: { types: [:GHOST, :DARK, :FIGHTING], name: "Ghost/Dark/Fighting" },
    }

    def self.identify_defensive_cores(battle, side_index)
      party = battle.pbParty(side_index.even? ? 0 : 1) rescue []
      return [] if party.length < 3

      team_types = []
      party.each do |pkmn|
        next if !pkmn || pkmn.fainted? || pkmn.egg?
        types = get_pokemon_types(pkmn)
        team_types.concat(types)
      end
      team_types.uniq!

      found_cores = []
      CLASSIC_CORES.each do |key, core_data|
        if (core_data[:types] - team_types).empty?
          found_cores << core_data[:name]
        end
      end

      # Log detected cores
      found_cores.each do |core_name|
        AdvancedAI.log("[Strategy] Defensive core detected: #{core_name}", "Strategy")
      end

      found_cores
    end

    # If opponent has a defensive core, adjust targeting
    def self.core_breaking_bonus(battle, user, move, target)
      opp_cores = identify_defensive_cores(battle, user.index.even? ? 1 : 0) rescue []
      return 0 if opp_cores.empty?

      bonus = 0
      # Wallbreaking moves are more valuable against defensive cores
      if move.damagingMove? && move.power >= 90
        bonus += 10  # High-power moves break cores
      end
      if move.id == :KNOCKOFF
        bonus += 10  # Item removal weakens defensive Pokemon
      end
      if move.id == :TAUNT
        bonus += 10  # Stop recovery
      end
      if bonus > 0
        move_name = move.respond_to?(:name) ? move.name : move.id.to_s
        AdvancedAI.log("[Strategy] Core-breaking move bonus: +#{bonus} for #{move_name}", "Strategy")
      end
      bonus
    end

    #===========================================================================
    # COMBINED STRATEGIC SCORE — called from scoring pipeline
    #===========================================================================
    def self.strategic_score(battle, user, move, target, skill = 100)
      return 0 unless skill >= 65
      total = 0

      begin
        # 1. Counter opponent archetype
        total += opponent_win_condition_counter(battle, user, move, target)

        # 2. Win condition shifting
        win_con = AdvancedAI.identify_win_condition(battle, user, skill) rescue nil
        total += update_win_condition(battle, user, win_con)
        total += win_condition_shift_bonus(battle, user, move, win_con)

        # 3. Preservation (coverage gaps)
        total += preservation_bonus(battle, user, move, target)

        # 4. Health advantage
        total += health_advantage_bonus(battle, user, move)

        # 5. Threat persistence
        update_threats(battle, user.index)
        total += threat_persistence_bonus(battle, user, move)

        # 6. Sacking
        total += sack_bonus(battle, user, move, target) if target

        # 7. Core breaking
        total += core_breaking_bonus(battle, user, move, target) if target
      rescue => e
        AdvancedAI.log("[Strategy] Error: #{e.message}", "Strategy")
      end

      total
    end

    #===========================================================================
    # HELPERS
    #===========================================================================
    private

    def self.get_stat(mon, stat)
      case stat
      when :hp      then mon.respond_to?(:totalhp) ? mon.totalhp : (mon.respond_to?(:hp) ? mon.hp : 80)
      when :attack  then mon.respond_to?(:attack)  ? mon.attack  : 80
      when :defense then mon.respond_to?(:defense) ? mon.defense : 80
      when :spatk   then mon.respond_to?(:spatk)   ? mon.spatk   : 80
      when :spdef   then mon.respond_to?(:spdef)   ? mon.spdef   : 80
      when :speed   then mon.respond_to?(:speed)   ? mon.speed   : 80
      else 80
      end
    end

    def self.get_ability(mon)
      if mon.respond_to?(:ability_id)
        mon.ability_id
      elsif mon.respond_to?(:ability)
        mon.ability.is_a?(Symbol) ? mon.ability : (mon.ability.id rescue nil)
      else
        nil
      end
    end

    def self.get_pokemon_types(mon)
      if mon.respond_to?(:pbTypes)
        mon.pbTypes
      elsif mon.respond_to?(:types)
        mon.types
      elsif mon.respond_to?(:type1)
        types = [mon.type1]
        types << mon.type2 if mon.respond_to?(:type2) && mon.type2 && mon.type2 != mon.type1
        types
      else
        [:NORMAL]
      end
    end

    def self.get_name(mon)
      if mon.respond_to?(:name)
        mon.name
      elsif mon.respond_to?(:pokemon)
        mon.pokemon.name rescue "???"
      else
        "???"
      end
    end

    def self.get_known_moves(battle, mon)
      # Try move memory first
      memory = AdvancedAI.get_memory(battle, mon) rescue nil
      if memory && memory[:moves] && !memory[:moves].empty?
        return memory[:moves]
      end
      # Fall back to actual moves (for AI's own Pokemon, or party mons)
      if mon.respond_to?(:moves) && mon.moves
        return mon.moves.map { |m| m.id rescue nil }.compact
      end
      []
    end

    def self.type_effectiveness_against(atk_type, defender_types)
      mult = 1.0
      defender_types.each do |def_type|
        eff = Effectiveness.calculate_one(atk_type, def_type) rescue 1.0
        mult *= eff
      end
      mult
    end

    def self.estimate_max_incoming(battle, user, target)
      return 0 unless target
      max_dmg = 0
      # Estimate from target's known moves
      moves = get_known_moves(battle, target)
      moves.each do |mid|
        move_data = GameData::Move.try_get(mid)
        next if !move_data || move_data.power == 0
        # Very rough estimation
        types = get_pokemon_types(user)
        eff = type_effectiveness_against(move_data.type, types)
        base = move_data.power * eff
        atk_stat = move_data.physicalMove? ? get_stat(target, :attack) : get_stat(target, :spatk)
        def_stat = move_data.physicalMove? ? get_stat(user, :defense) : get_stat(user, :spdef)
        rough = (base * atk_stat.to_f / [def_stat, 1].max * 0.5).to_i
        max_dmg = rough if rough > max_dmg
      end if moves
      max_dmg
    end
  end
end

#===============================================================================
# API Wrapper
#===============================================================================
module AdvancedAI
  def self.identify_opponent_archetype(battle, user_index)
    StrategicAwareness.identify_opponent_archetype(battle, user_index)
  end

  def self.identify_coverage_gaps(battle, user_index)
    StrategicAwareness.identify_coverage_gaps(battle, user_index)
  end

  def self.identify_critical_pokemon(battle, user_index)
    StrategicAwareness.identify_critical_pokemon(battle, user_index)
  end

  def self.track_health(battle, user_index)
    StrategicAwareness.track_health(battle, user_index)
  end

  def self.update_threats(battle, user_index)
    StrategicAwareness.update_threats(battle, user_index)
  end

  def self.should_sack?(battle, user, target)
    StrategicAwareness.should_sack?(battle, user, target)
  end

  def self.strategic_score(battle, user, move, target, skill = 100)
    StrategicAwareness.strategic_score(battle, user, move, target, skill)
  end

  def self.identify_defensive_cores(battle, side_index)
    StrategicAwareness.identify_defensive_cores(battle, side_index)
  end
end

#===============================================================================
# Integration in Battle::AI — Wires strategic awareness into scoring pipeline
#===============================================================================
class Battle::AI
  def apply_strategic_awareness(score, move, user, target, skill = 100)
    return score unless move && user
    begin
      real_user = user.respond_to?(:battler) ? user.battler : user
      real_target = target ? (target.respond_to?(:battler) ? target.battler : target) : nil
      bonus = AdvancedAI.strategic_score(@battle, real_user, move, real_target, skill)
      score += bonus if bonus && bonus != 0
    rescue => e
      AdvancedAI.log("[Strategy] Pipeline error: #{e.message}", "Strategy")
    end
    return score
  end
end

# Cleanup hook
class Battle
  alias aai_strategy_cleanup_pbEndOfBattle pbEndOfBattle
  def pbEndOfBattle
    AdvancedAI::StrategicAwareness.cleanup(self)
    aai_strategy_cleanup_pbEndOfBattle
  end
end

AdvancedAI.log("Strategic Awareness System loaded", "Strategy")
AdvancedAI.log("  - Opponent team archetype recognition", "Strategy")
AdvancedAI.log("  - Opponent win condition counter-play", "Strategy")
AdvancedAI.log("  - Dynamic win condition shifting", "Strategy")
AdvancedAI.log("  - Type coverage gap mapping", "Strategy")
AdvancedAI.log("  - Collective health tracking", "Strategy")
AdvancedAI.log("  - Opponent threat persistence", "Strategy")
AdvancedAI.log("  - Proactive sacking logic", "Strategy")
AdvancedAI.log("  - Defensive core recognition", "Strategy")

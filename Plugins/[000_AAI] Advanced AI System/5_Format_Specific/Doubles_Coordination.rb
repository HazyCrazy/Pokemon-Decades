#===============================================================================
# Advanced AI System - Doubles Coordination
# Partner Synergy, Overkill Prevention, Spread Move Optimization
#===============================================================================

module AdvancedAI
  module DoublesCoordination
    # Prevents Overkill (both partners attack weak target)
    def self.prevent_overkill(battle, attacker, target, skill_level = 100)
      return 0 unless skill_level >= 50
      return 0 unless battle.pbSideSize(0) > 1  # Doubles/Triples only
      return 0 unless target
      
      partner = find_partner(battle, attacker)
      return 0 unless partner
      
      # Check if partner is also targeting this battler
      partner_targeting_same = partner_targets?(battle, partner, target)
      return 0 unless partner_targeting_same
      
      # If target is already weak
      hp_percent = target.hp.to_f / target.totalhp
      if hp_percent < 0.3
        return -40  # Switch target to avoid overkill
      elsif hp_percent < 0.5
        return -20
      end
      
      0
    end
    
    # Prevents Move Conflicts (both use same Setup/Support Move)
    def self.prevent_move_conflicts(battle, attacker, move, skill_level = 100)
      return 0 unless skill_level >= 50
      return 0 unless battle.pbSideSize(0) > 1
      
      partner = find_partner(battle, attacker)
      return 0 unless partner
      
      # Both want to set Screens
      if [:REFLECT, :LIGHTSCREEN, :AURORAVEIL].include?(move.id)
        return -60  # One is enough
      end
      
      # Both want to set Hazards
      if [:STEALTHROCK, :SPIKES, :TOXICSPIKES, :STICKYWEB].include?(move.id)
        return -50
      end
      
      # Both want to set Weather
      if [:SUNNYDAY, :RAINDANCE, :SANDSTORM, :HAIL, :SNOWSCAPE].include?(move.id)
        return -40
      end
      
      0
    end
    
    # Optimizes Spread Moves (Earthquake, etc.)
    def self.optimize_spread_moves(battle, attacker, move, skill_level = 100)
      return 0 unless skill_level >= 60
      return 0 unless battle.pbSideSize(0) > 1
      return 0 unless move.pbTarget(attacker).num_targets > 1
      
      score = 0
      partner = find_partner(battle, attacker)
      
      # === SPREAD MOVE DAMAGE REDUCTION ===
      # In doubles, spread moves deal 75% damage to each target
      # This makes single-target moves relatively more valuable per target
      score -= 8  # Small penalty for reduced damage per target
      
      # Penalty if Partner is hit
      if partner && hits_partner?(move, attacker, partner)
        # Check Immunity/Resistance
        type_mod = Effectiveness.calculate(move.type, *partner.pbTypes(true))
        
        if Effectiveness.ineffective?(type_mod)
          score += 30  # Partner immune → very good!
        elsif Effectiveness.not_very_effective?(type_mod)
          score += 15  # Partner resists
        else
          score -= 40  # Hits Partner hard
        end
      end
      
      # Bonus if multiple enemies are hit
      enemies_hit = count_enemies_hit(battle, attacker, move)
      score += enemies_hit * 20
      
      score
    end
    
    # Coordinates Field Effects (no Weather override)
    def self.coordinate_field_effects(battle, attacker, move, skill_level = 100)
      return 0 unless skill_level >= 70
      return 0 unless battle.pbSideSize(0) > 1
      
      score = 0
      partner = find_partner(battle, attacker)
      return 0 unless partner
      
      # Weather Coordination
      if move.function_code.include?("Weather")
        # Check Partner Ability
        partner_ability = partner.ability_id
        
        if move.id == :RAINDANCE && [:SWIFTSWIM, :DRIZZLE].include?(partner_ability)
          score += 40  # Partner benefits
        elsif move.id == :SUNNYDAY && [:CHLOROPHYLL, :DROUGHT].include?(partner_ability)
          score += 40
        elsif move.id == :SANDSTORM && [:SANDRUSH, :SANDSTREAM].include?(partner_ability)
          score += 40
        elsif move.id == :HAIL && [:SLUSHRUSH, :SNOWWARNING].include?(partner_ability)
          score += 40
        end
      end
      
      # Terrain Coordination
      if move.function_code.include?("Terrain")
        partner_ability = partner.ability_id
        
        if move.id == :ELECTRICTERRAIN && [:SURGESURFER].include?(partner_ability)
          score += 35
        elsif move.id == :GRASSYTERRAIN && partner.pbHasType?(:GRASS)
          score += 25
        elsif move.id == :PSYCHICTERRAIN && [:PSYCHICSURGE].include?(partner_ability)
          score += 35
        end
      end
      
      score
    end
    
    # Protect + Setup Combo
    def self.protect_setup_combo(battle, attacker, move, skill_level = 100)
      return 0 unless skill_level >= 65
      return 0 unless battle.pbSideSize(0) > 1
      
      partner = find_partner(battle, attacker)
      return 0 unless partner
      
      # If Partner is setting up, use Protect
      if move.id == :PROTECT || move.id == :DETECT
        partner_setup = partner.moves.any? { |m| m && m.stat_up.any? }
        return 50 if partner_setup && partner.hp > partner.totalhp * 0.7
      end
      
      0
    end
    
    #===========================================================================
    # Protective Moves for Doubles (Wide Guard, Quick Guard)
    #===========================================================================
    module ProtectiveMovesDoubles
      # List of common spread moves that hit multiple targets
      SPREAD_MOVES = [
        :EARTHQUAKE, :SURF, :ROCKSLIDE, :DISCHARGE, :LAVAPLUME,
        :BLIZZARD, :HEATWAVE, :MUDDYWATER, :RAZORLEAF, :ICICLESPEAR,
        :BULLDOZE, :SNARL, :GLACIATE, :ORIGINPULSE, :PRECIPICEBLADES,
        :DIAMONDSTORM, :PARABOLICCHARGE, :DAZZLINGGLEAM, :EXPLOSION,
        :SELFDESTRUCT, :MAGNITUDE, :BOOMBURST, :HYPERVOICE, :SLUDGEWAVE
      ]
      
      # List of priority moves that Quick Guard blocks
      PRIORITY_MOVES = [
        :FAKEOUT, :AQUAJET, :MACHPUNCH, :BULLETPUNCH, :ICESHARD,
        :SHADOWSNEAK, :VACUUMWAVE, :QUICKATTACK, :EXTREMESPEED,
        :ACCELEROCK, :FIRSTIMPRESSION, :WATERSHURIKEN, :SUCKERPUNCH,
        :JETPUNCH, :GRASSYGLIDE, :THUNDERCLAP
      ]
      
      # Predicts if opponent is likely to use a spread move
      def self.predict_spread_moves(battle, attacker)
        return [] unless battle.pbSideSize(0) > 1
        
        predicted_moves = []
        battle.allOtherSideBattlers(attacker.index).each do |opponent|
          next unless opponent && !opponent.fainted?
          
          opponent.moves.each do |move|
            next unless move
            # Check if move is a known spread move
            if SPREAD_MOVES.include?(move.id)
              predicted_moves << move.id
            # Or check if move targets multiple Pokémon
            elsif move.pbTarget(opponent).num_targets > 1
              predicted_moves << move.id
            end
          end
        end
        
        predicted_moves.uniq
      end
      
      # Predicts if opponent is likely to use a priority move
      def self.predict_priority_moves(battle, attacker)
        return [] unless battle.pbSideSize(0) > 1
        
        predicted_moves = []
        battle.allOtherSideBattlers(attacker.index).each do |opponent|
          next unless opponent && !opponent.fainted?
          
          opponent.moves.each do |move|
            next unless move
            if PRIORITY_MOVES.include?(move.id) || move.priority > 0
              predicted_moves << move.id
            end
          end
        end
        
        predicted_moves.uniq
      end
      
      # Evaluates Wide Guard usage
      def self.evaluate_wide_guard(battle, attacker, move, skill_level = 100)
        return 0 unless skill_level >= 70
        return 0 unless battle.pbSideSize(0) > 1
        return 0 unless move.id == :WIDEGUARD
        
        score = 0
        partner = DoublesCoordination.find_partner(battle, attacker)
        
        # Predict if opponents have spread moves
        predicted_spread = predict_spread_moves(battle, attacker)
        
        if predicted_spread.empty?
          return -30  # No spread moves predicted, don't waste turn
        end
        
        # Base bonus for having spread moves
        score += 40
        
        # Check if partner is weak to predicted spread moves
        if partner
          predicted_spread.each do |move_id|
            move_data = GameData::Move.try_get(move_id)
            next unless move_data
            
            type_mod = Effectiveness.calculate(move_data.type, partner.types[0], partner.types[1])
            
            if Effectiveness.super_effective?(type_mod)
              score += 30  # Partner is weak to this spread move!
            elsif Effectiveness.not_very_effective?(type_mod)
              score += 10  # Still good to protect
            end
          end
        end
        
        # Bonus if multiple allies present (Triples)
        allies_count = battle.allSameSideBattlers(attacker.index).count { |b| b && !b.fainted? }
        score += (allies_count - 1) * 15
        
        # Check if Wide Guard was recently used (avoid spamming)
        if attacker.effects[PBEffects::ProtectRate] > 1
          score -= 40  # Protect-like moves have diminishing returns
        end
        
        score
      end
      
      # Evaluates Quick Guard usage
      def self.evaluate_quick_guard(battle, attacker, move, skill_level = 100)
        return 0 unless skill_level >= 70
        return 0 unless battle.pbSideSize(0) > 1
        return 0 unless move.id == :QUICKGUARD
        
        score = 0
        partner = DoublesCoordination.find_partner(battle, attacker)
        
        # Predict if opponents have priority moves
        predicted_priority = predict_priority_moves(battle, attacker)
        
        if predicted_priority.empty?
          return -30  # No priority moves predicted
        end
        
        # Base bonus
        score += 35
        
        # Higher priority if partner is low HP (vulnerable to priority)
        if partner && partner.hp < partner.totalhp * 0.4
          score += 40
        end
        
        # Fake Out is especially dangerous Turn 1
        if battle.turnCount == 0 && predicted_priority.include?(:FAKEOUT)
          score += 50
        end
        
        # Check protect rate
        if attacker.effects[PBEffects::ProtectRate] > 1
          score -= 35
        end
        
        score
      end
    end
    
    #===========================================================================
    # Redirection Strategies (Follow Me, Rage Powder)
    #===========================================================================
    module RedirectionStrategies
      # Detects if partner is using a setup move
      def self.partner_is_setting_up?(partner)
        return false unless partner
        
        # Check if partner has setup moves
        setup_moves = [:SWORDSDANCE, :NASTYPLOT, :DRAGONDANCE, :CALMMIND,
                       :BULKUP, :AGILITY, :ROCKPOLISH, :QUIVERDANCE,
                       :SHELLSMASH, :GEOMANCY, :GROWTH, :WORKUP]
        
        partner.moves.any? { |m| m && setup_moves.include?(m.id) }
      end
      
      # Checks if user is a good redirector (high defenses)
      def self.good_redirector?(attacker)
        return false unless attacker
        
        # Check defensive stats
        def_stat = attacker.defense
        spdef_stat = attacker.spdef
        hp_stat = attacker.hp
        
        # Good redirector has high HP and defenses
        total_bulk = def_stat + spdef_stat + (hp_stat / 2)
        return total_bulk > 300  # Arbitrary threshold
      end
      
      # Evaluates Follow Me usage
      def self.evaluate_follow_me(battle, attacker, move, skill_level = 100)
        return 0 unless skill_level >= 75
        return 0 unless battle.pbSideSize(0) > 1
        return 0 unless move.id == :FOLLOWME || move.id == :RAGEPOWDER
        
        score = 0
        partner = DoublesCoordination.find_partner(battle, attacker)
        return 0 unless partner

        # === CONFLICT GUARD ===
        # If partner is using Helping Hand / another redirect / Protect,
        # redirecting serves no purpose — nobody is attacking.
        partner_move = DoublesCoordination.partner_planned_move_id(battle, partner)
        if partner_move
          if partner_move == :HELPINGHAND
            score -= 200  # Redirect + Helping Hand = zero offense
          end
          if DoublesCoordination::REDIRECT_MOVE_IDS.include?(partner_move)
            score -= 150  # Both redirecting = wasted
          end
          if DoublesCoordination::PROTECT_MOVE_IDS.include?(partner_move)
            score -= 100  # Redirect + Protect = partner is safe already
          end
        end
        
        # Check for Ghost-type opponents (Follow Me doesn't work on them)
        if move.id == :FOLLOWME
          ghost_opponents = battle.allOtherSideBattlers(attacker.index).any? do |opp|
            opp && !opp.fainted? && opp.pbHasType?(:GHOST)
          end
          score -= 50 if ghost_opponents
        end
        
        # High priority if partner is setting up
        if partner_is_setting_up?(partner)
          score += 70
          # Even higher if partner is healthy
          if partner.hp > partner.totalhp * 0.7
            score += 20
          end
        end
        
        # Protect low HP partner
        if partner.hp < partner.totalhp * 0.3
          score += 60
        elsif partner.hp < partner.totalhp * 0.5
          score += 30
        end
        
        # Bonus if user is bulky (good redirector)
        if good_redirector?(attacker)
          score += 25
        end
        
        # Bonus if user has high HP
        if attacker.hp > attacker.totalhp * 0.8
          score += 20
        end
        
        # Penalty if already used recently (can't spam)
        if attacker.effects[PBEffects::FollowMe] > 0
          score -= 80
        end
        
        score
      end
      
      # Evaluates Rage Powder usage (similar to Follow Me but Grass-type)
      def self.evaluate_rage_powder(battle, attacker, move, skill_level = 100)
        # Rage Powder is essentially Follow Me for Grass-types
        # Use the same logic but check for Grass immunities
        return 0 unless move.id == :RAGEPOWDER
        
        score = evaluate_follow_me(battle, attacker, move, skill_level)
        
        # Check for Grass-type opponents or Overcoat ability (immune to powder)
        immune_opponents = battle.allOtherSideBattlers(attacker.index).any? do |opp|
          next false unless opp && !opp.fainted?
          opp.pbHasType?(:GRASS) || opp.ability_id == :OVERCOAT
        end
        
        score -= 40 if immune_opponents
        
        score
      end
      
      # Determines if partner should be protected
      def self.should_protect_partner?(battle, attacker, partner)
        return false unless partner
        
        # Protect if partner is setting up
        return true if partner_is_setting_up?(partner)
        
        # Protect if partner is low HP
        return true if partner.hp < partner.totalhp * 0.4
        
        # Protect if partner is a sweeper (high offensive stats)
        if partner.attack > 120 || partner.spatk > 120
          return true
        end
        
        false
      end
    end
    
    #===========================================================================
    # Fake Out & Protect Coordination
    #===========================================================================
    
    # Evaluates Fake Out in doubles context
    def self.evaluate_fake_out(battle, attacker, move, target, skill_level = 100)
      return 0 unless skill_level >= 60
      return 0 unless battle.pbSideSize(0) > 1
      return 0 unless move.id == :FAKEOUT
      
      score = 0
      
      # Fake Out only works on Turn 1 or when just switched in
      if battle.turnCount == 0 || attacker.turnCount == 0
        score += 50  # Strong bonus for Turn 1
      else
        return -80  # Fake Out fails if not Turn 1
      end
      
      # Target threats to partner
      partner = find_partner(battle, attacker)
      if partner && target
        # Check if target is a threat to partner
        target.moves.each do |target_move|
          next unless target_move
          
          type_mod = Effectiveness.calculate(target_move.type, partner.types[0], partner.types[1])
          if Effectiveness.super_effective?(type_mod)
            score += 30  # Target threatens partner!
          end
        end
        
        # Prioritize disrupting setup sweepers
        setup_moves = [:SWORDSDANCE, :NASTYPLOT, :DRAGONDANCE, :SHELLSMASH]
        if target.moves.any? { |m| m && setup_moves.include?(m.id) }
          score += 40
        end
      end
      
      # Avoid if partner is also using Fake Out (coordination)
      if partner && partner.moves.any? { |m| m && m.id == :FAKEOUT }
        score -= 30  # Don't both use Fake Out
      end
      
      score
    end
    
    # Enhanced Protect evaluation for doubles
    def self.evaluate_protect_doubles(battle, attacker, move, skill_level = 100)
      return 0 unless skill_level >= 65
      return 0 unless battle.pbSideSize(0) > 1
      return 0 unless [:PROTECT, :DETECT, :KINGSSHIELD, :SPIKYSHIELD, :BANEFULBUNKER].include?(move.id)
      
      score = 0
      partner = find_partner(battle, attacker)
      
      # Protect while partner uses spread move that hits allies
      if partner
        partner.moves.each do |partner_move|
          next unless partner_move
          
          # Check if partner's move hits allies
          if hits_partner?(partner_move, partner, attacker)
            # Check if we're weak to it
            type_mod = Effectiveness.calculate(partner_move.type, attacker.types[0], attacker.types[1])
            
            if !Effectiveness.ineffective?(type_mod)
              score += 55  # Protect from partner's spread move!
            end
          end
        end
        
        # Protect while partner sets up
        if RedirectionStrategies.partner_is_setting_up?(partner)
          score += 50
        end
      end
      
      # Alternate Protect usage (don't spam)
      if attacker.effects[PBEffects::ProtectRate] > 1
        score -= 60  # Diminishing returns
      end
      
      # Protect when predicting opponent's spread move
      predicted_spread = ProtectiveMovesDoubles.predict_spread_moves(battle, attacker)
      if !predicted_spread.empty?
        score += 25
      end
      
      score
    end
    
    #===========================================================================
    # Speed Control Strategies (Tailwind, Trick Room, Icy Wind)
    #===========================================================================
    module SpeedControlDoubles
      # Slow Pokemon that benefit from Trick Room
      TRICK_ROOM_THRESHOLD = 60  # Base speed threshold
      
      # Fast Pokemon that benefit from Tailwind
      TAILWIND_THRESHOLD = 80  # Base speed threshold
      
      # Speed-lowering moves
      SPEED_CONTROL_MOVES = [:ICYWIND, :ELECTROWEBS, :STRINGSHOT, :BULLDOZE, :ROCKSLIDE]
      
      # Evaluates Tailwind usage
      def self.evaluate_tailwind(battle, attacker, move, skill_level = 100)
        return 0 unless skill_level >= 70
        return 0 unless battle.pbSideSize(0) > 1
        return 0 unless move.id == :TAILWIND
        
        score = 0
        
        # Check if Tailwind is already active
        if attacker.pbOwnSide.effects[PBEffects::Tailwind] > 0
          return -80  # Already have Tailwind
        end
        
        # Calculate team speed benefits
        allies = battle.allSameSideBattlers(attacker.index).select { |b| b && !b.fainted? }
        fast_allies = allies.count { |b| b.speed >= TAILWIND_THRESHOLD }
        
        # More fast allies = more benefit
        score += fast_allies * 25
        
        # Check if we're currently slower than opponents
        opponents = battle.allOtherSideBattlers(attacker.index).select { |b| b && !b.fainted? }
        slower_count = 0
        allies.each do |ally|
          opponents.each do |opp|
            slower_count += 1 if ally.speed < opp.speed
          end
        end
        
        # Bonus if we're currently outsped
        score += slower_count * 15
        
        # Penalty if Trick Room is active (speed control conflict)
        if battle.field.effects[PBEffects::TrickRoom] > 0
          score -= 70
        end
        
        # Bonus on Turn 1 (set up speed advantage early)
        if battle.turnCount == 0
          score += 30
        end
        
        # Check if partner can sweep with speed boost
        partner = DoublesCoordination.find_partner(battle, attacker)
        if partner
          if partner.attack > 120 || partner.spatk > 120
            score += 25  # Partner is offensive
          end
        end
        
        score
      end
      
      # Evaluates Trick Room usage
      def self.evaluate_trick_room(battle, attacker, move, skill_level = 100)
        return 0 unless skill_level >= 75
        return 0 unless battle.pbSideSize(0) > 1
        return 0 unless move.id == :TRICKROOM
        
        score = 0
        
        # Trick Room toggles on/off
        trick_room_active = battle.field.effects[PBEffects::TrickRoom] > 0
        
        if trick_room_active
          # Check if WE benefit from current Trick Room
          allies = battle.allSameSideBattlers(attacker.index).select { |b| b && !b.fainted? }
          slow_allies = allies.count { |b| b.speed < TRICK_ROOM_THRESHOLD }
          
          if slow_allies >= allies.length / 2
            return -60  # Don't turn OFF our own Trick Room
          else
            score += 40  # Turn off opponent's Trick Room
          end
        else
          # Set up Trick Room
          allies = battle.allSameSideBattlers(attacker.index).select { |b| b && !b.fainted? }
          slow_allies = allies.count { |b| b.speed < TRICK_ROOM_THRESHOLD }
          
          # Need slow allies to benefit
          if slow_allies == 0
            return -50  # No slow Pokemon to benefit
          end
          
          score += slow_allies * 30
          
          # Bonus if opponents are fast
          opponents = battle.allOtherSideBattlers(attacker.index).select { |b| b && !b.fainted? }
          fast_opponents = opponents.count { |b| b.speed >= TAILWIND_THRESHOLD }
          score += fast_opponents * 20
          
          # Penalty if Tailwind is active (speed control conflict)
          if attacker.pbOwnSide.effects[PBEffects::Tailwind] > 0
            score -= 50
          end
          
          # Turn 1 bonus
          if battle.turnCount == 0
            score += 25
          end
        end
        
        score
      end
      
      # Evaluates Icy Wind / speed-lowering spread moves
      def self.evaluate_speed_control_attack(battle, attacker, move, skill_level = 100)
        return 0 unless skill_level >= 65
        return 0 unless battle.pbSideSize(0) > 1
        return 0 unless SPEED_CONTROL_MOVES.include?(move.id)
        
        score = 0
        
        # Check if we're currently slower
        opponents = battle.allOtherSideBattlers(attacker.index).select { |b| b && !b.fainted? }
        allies = battle.allSameSideBattlers(attacker.index).select { |b| b && !b.fainted? }
        
        outsped = 0
        allies.each do |ally|
          opponents.each do |opp|
            outsped += 1 if ally.speed < opp.speed
          end
        end
        
        # Bonus for each speed tie we can fix
        score += outsped * 15
        
        # Extra bonus for Icy Wind (spread move + speed drop)
        if move.id == :ICYWIND
          score += opponents.count * 10
        end
        
        # Penalty if Trick Room is active (we WANT to be slower)
        if battle.field.effects[PBEffects::TrickRoom] > 0
          score -= 40
        end
        
        score
      end
      
      # Checks if team benefits from Trick Room
      def self.team_benefits_from_trick_room?(battle, side)
        battlers = []
        battle.allSameSideBattlers(side).each { |b| battlers << b if b && !b.fainted? }
        
        slow_count = battlers.count { |b| b.speed < TRICK_ROOM_THRESHOLD }
        slow_count >= battlers.length / 2
      end
    end
    
    #===========================================================================
    # Enhanced Weather Coordination for Doubles
    #===========================================================================
    module WeatherCoordinationDoubles
      # Weather abilities
      WEATHER_ABILITIES = {
        :Sun  => [:DROUGHT, :ORICHALCUMPULSE],
        :Rain => [:DRIZZLE, :PRIMORDIALSEA],
        :Sand => [:SANDSTREAM],
        :Hail => [:SNOWWARNING],
        :Snow => [:SNOWWARNING]
      }
      
      # Abilities that benefit from weather
      WEATHER_SYNERGY = {
        :Sun  => [:CHLOROPHYLL, :SOLARPOWER, :FLOWERGIFT, :LEAFGUARD, :HARVEST, :PROTOSYNTHESIS],
        :Rain => [:SWIFTSWIM, :RAINDISH, :DRYSKIN, :HYDRATION],
        :Sand => [:SANDRUSH, :SANDFORCE, :SANDVEIL],
        :Hail => [:SLUSHRUSH, :ICEBODY, :SNOWCLOAK],
        :Snow => [:SLUSHRUSH, :ICEBODY, :SNOWCLOAK]
      }
      
      # Move types boosted by weather
      WEATHER_MOVE_BOOST = {
        :Sun  => :FIRE,
        :Rain => :WATER,
        :Sand => :ROCK,  # Sand boosts SpDef of Rock-types
        :Hail => :ICE,
        :Snow => :ICE
      }
      
      # Evaluates weather move in doubles context
      def self.evaluate_weather_move(battle, attacker, move, skill_level = 100)
        return 0 unless skill_level >= 70
        return 0 unless battle.pbSideSize(0) > 1
        
        weather_moves = {
          :SUNNYDAY => :Sun,
          :RAINDANCE => :Rain,
          :SANDSTORM => :Sand,
          :HAIL => :Hail,
          :SNOWSCAPE => :Snow,
          :CHILLYRECEPTION => :Snow
        }
        
        target_weather = weather_moves[move.id]
        return 0 unless target_weather
        
        score = 0
        
        # Check current weather
        current_weather = battle.field.weather
        if current_weather == target_weather
          return -60  # Already have this weather
        end
        
        # Count allies that benefit
        allies = battle.allSameSideBattlers(attacker.index).select { |b| b && !b.fainted? }
        synergy_abilities = WEATHER_SYNERGY[target_weather] || []
        
        allies.each do |ally|
          # Ability synergy
          if synergy_abilities.include?(ally.ability_id)
            score += 40
          end
          
          # Move type synergy
          boost_type = WEATHER_MOVE_BOOST[target_weather]
          if boost_type
            stab_moves = ally.moves.count { |m| m && m.type == boost_type }
            score += stab_moves * 15
          end
        end
        
        # Penalty if opponents also benefit
        opponents = battle.allOtherSideBattlers(attacker.index).select { |b| b && !b.fainted? }
        opponents.each do |opp|
          if synergy_abilities.include?(opp.ability_id)
            score -= 35
          end
        end
        
        # Turn 1 bonus for early setup
        if battle.turnCount == 0
          score += 20
        end
        
        # Check partner's ability for auto-weather (don't override)
        partner = DoublesCoordination.find_partner(battle, attacker)
        if partner
          WEATHER_ABILITIES.each do |weather_type, abilities|
            if abilities.include?(partner.ability_id)
              if weather_type == target_weather
                score -= 30  # Partner already sets this weather
              else
                score -= 20  # Weather conflict with partner
              end
            end
          end
        end
        
        score
      end
      
      # Evaluates moves that benefit from current weather
      def self.evaluate_weather_boosted_move(battle, attacker, move, skill_level = 100)
        return 0 unless skill_level >= 60
        return 0 unless battle.pbSideSize(0) > 1
        
        score = 0
        current_weather = battle.field.weather
        
        # Sun boosts Fire, weakens Water
        if current_weather == :Sun
          score += 25 if move.type == :FIRE
          score -= 20 if move.type == :WATER
          # Solar Beam / Solar Blade don't need charging
          score += 30 if [:SOLARBEAM, :SOLARBLADE].include?(move.id)
        end
        
        # Rain boosts Water, weakens Fire
        if current_weather == :Rain
          score += 25 if move.type == :WATER
          score -= 20 if move.type == :FIRE
          # Thunder / Hurricane don't miss
          score += 20 if [:THUNDER, :HURRICANE].include?(move.id)
        end
        
        # Hail/Snow enables Blizzard accuracy
        if [:Hail, :Snow].include?(current_weather)
          score += 20 if move.id == :BLIZZARD
          # Aurora Veil can be used
          score += 30 if move.id == :AURORAVEIL
        end
        
        # Sand boosts Rock-type SpDef, Sandstorm damage to non-immune
        if current_weather == :Sand
          score += 15 if move.type == :GROUND  # Often paired with Sand teams
        end
        
        # Weather Ball changes type
        if move.id == :WEATHERBALL && current_weather != :None
          score += 25
        end
        
        score
      end
    end
    
    #===========================================================================
    # Ally Protection & Synergy Moves
    #===========================================================================
    module AllySynergyDoubles
      # Moves that help allies
      ALLY_BOOST_MOVES = [:HELPINGHAND, :COACHING, :DECORATE, :AROMATHERAPY, 
                          :HEALBELL, :LIFEDEW, :POLLENPUFF, :HEALPULSE]
      
      # Evaluates Helping Hand
      def self.evaluate_helping_hand(battle, attacker, move, skill_level = 100)
        return 0 unless skill_level >= 65
        return 0 unless battle.pbSideSize(0) > 1
        return 0 unless move.id == :HELPINGHAND
        
        score = 0
        partner = DoublesCoordination.find_partner(battle, attacker)
        return -50 unless partner  # No partner to help

        # === CONFLICT GUARD ===
        # If partner is using Follow Me / Rage Powder / Protect / Helping Hand,
        # Helping Hand produces zero offensive value — both mons do nothing.
        partner_move = DoublesCoordination.partner_planned_move_id(battle, partner)
        if partner_move
          if DoublesCoordination::REDIRECT_MOVE_IDS.include?(partner_move)
            return -200  # Redirect + Helping Hand = wasted turn
          end
          if DoublesCoordination::PROTECT_MOVE_IDS.include?(partner_move)
            return -150  # Protect + Helping Hand = wasted turn
          end
          if partner_move == :HELPINGHAND
            return -100  # Both using Helping Hand = no attacks
          end
        end
        
        # Partner has high-damage moves
        if partner.attack > 120 || partner.spatk > 120
          score += 40
        end
        
        # Partner is faster than opponents (will attack this turn)
        opponents = battle.allOtherSideBattlers(attacker.index).select { |b| b && !b.fainted? }
        faster_than_all = opponents.all? { |opp| partner.speed > opp.speed }
        score += 25 if faster_than_all
        
        # Partner has spread move (Helping Hand affects all hits)
        has_spread = partner.moves.any? do |m| 
          m && m.pbTarget(partner).num_targets > 1
        end
        score += 30 if has_spread
        
        # Penalty if partner is using non-damaging move
        # (Helping Hand only boosts damage)
        score -= 20 if RedirectionStrategies.partner_is_setting_up?(partner)
        
        score
      end
      
      # Evaluates Coaching
      def self.evaluate_coaching(battle, attacker, move, skill_level = 100)
        return 0 unless skill_level >= 65
        return 0 unless battle.pbSideSize(0) > 1
        return 0 unless move.id == :COACHING
        
        score = 0
        partner = DoublesCoordination.find_partner(battle, attacker)
        return -50 unless partner
        
        # Partner is physical attacker
        if partner.attack > partner.spatk
          score += 35
          # Partner doesn't have +6 Atk already
          if partner.stages[:ATTACK] < 6
            score += 20
          end
        end
        
        # Partner is healthy (can make use of boost)
        if partner.hp > partner.totalhp * 0.6
          score += 20
        end
        
        score
      end
      
      # Evaluates ally healing moves
      def self.evaluate_ally_heal(battle, attacker, move, skill_level = 100)
        return 0 unless skill_level >= 60
        return 0 unless battle.pbSideSize(0) > 1
        return 0 unless [:LIFEDEW, :HEALPULSE, :POLLENPUFF].include?(move.id)
        
        score = 0
        partner = DoublesCoordination.find_partner(battle, attacker)
        return -30 unless partner
        
        hp_percent = partner.hp.to_f / partner.totalhp
        
        # More valuable when partner is hurt
        if hp_percent < 0.3
          score += 60
        elsif hp_percent < 0.5
          score += 40
        elsif hp_percent < 0.7
          score += 20
        else
          score -= 30  # Partner is healthy
        end
        
        # Pollen Puff does damage to enemies
        if move.id == :POLLENPUFF
          score += 15  # Versatile move
        end
        
        score
      end
      
      # Evaluates Ally Switch
      def self.evaluate_ally_switch(battle, attacker, move, skill_level = 100)
        return 0 unless skill_level >= 80
        return 0 unless battle.pbSideSize(0) > 1
        return 0 unless move.id == :ALLYSWITCH
        
        score = 0
        partner = DoublesCoordination.find_partner(battle, attacker)
        return -30 unless partner
        
        # Predict incoming super effective attack on partner
        opponents = battle.allOtherSideBattlers(attacker.index).select { |b| b && !b.fainted? }
        
        partner_threatened = false
        attacker_resists = false
        
        opponents.each do |opp|
          opp.moves.each do |opp_move|
            next unless opp_move && opp_move.damagingMove?
            
            # Check if partner is weak
            partner_mod = Effectiveness.calculate(opp_move.type, partner.types[0], partner.types[1])
            attacker_mod = Effectiveness.calculate(opp_move.type, attacker.types[0], attacker.types[1])
            
            if Effectiveness.super_effective?(partner_mod)
              partner_threatened = true
              if Effectiveness.not_very_effective?(attacker_mod) || Effectiveness.ineffective?(attacker_mod)
                attacker_resists = true
              end
            end
          end
        end
        
        if partner_threatened && attacker_resists
          score += 60  # Swap to take resisted hit
        elsif partner_threatened
          score += 25  # At least swap positions
        end
        
        # Don't spam (becomes predictable)
        if attacker.effects[PBEffects::AllySwitch]
          score -= 40
        end
        
        score
      end
    end
    
    #===========================================================================
    # Combo Detection & Setup Coordination
    #===========================================================================
    module ComboCoordinationDoubles
      # Classic doubles combos
      CLASSIC_COMBOS = {
        # [Move, Partner Ability/Move that synergizes]
        :EARTHQUAKE => [:LEVITATE, :FLYINGTYPE, :AIRBALLOON, :TELEKINESIS],
        :SURF => [:WATERABSORB, :DRYSKIN, :STORMDRAIN],
        :DISCHARGE => [:LIGHTNINGROD, :VOLTABSORB, :MOTORDRIVE],
        :HEATWAVE => [:FLASHFIRE, :WELLBAKEDBODY],
        :BEATUP => [:JUSTIFIED],  # Beat Up + Justified combo
        :SWAGGER => [:OWNTEMPO],  # Swagger + Own Tempo combo
      }
      
      # Checks for combo potential
      def self.check_combo_potential(battle, attacker, move)
        return 0 unless battle.pbSideSize(0) > 1
        
        partner = DoublesCoordination.find_partner(battle, attacker)
        return 0 unless partner
        
        combo_synergy = CLASSIC_COMBOS[move.id]
        return 0 unless combo_synergy
        
        score = 0
        
        combo_synergy.each do |synergy|
          case synergy
          when :FLYINGTYPE
            score += 50 if partner.pbHasType?(:FLYING)
          when :AIRBALLOON
            score += 40 if partner.item_id == :AIRBALLOON
          else
            # Check ability
            score += 45 if partner.ability_id == synergy
          end
        end
        
        score
      end
      
      # Detects if move sets up partner
      def self.evaluate_setup_for_partner(battle, attacker, move, skill_level = 100)
        return 0 unless skill_level >= 70
        return 0 unless battle.pbSideSize(0) > 1
        
        score = 0
        partner = DoublesCoordination.find_partner(battle, attacker)
        return 0 unless partner
        
        # Screens help partner survive
        if [:REFLECT, :LIGHTSCREEN, :AURORAVEIL].include?(move.id)
          # More valuable if partner is offensive (wants to survive to attack)
          if partner.attack > 100 || partner.spatk > 100
            score += 25
          end
        end
        
        # Check for Beat Up + Justified combo
        if move.id == :BEATUP && partner.ability_id == :JUSTIFIED
          score += 80  # Classic combo!
        end
        
        # Decorate specifically boosts ally
        if move.id == :DECORATE
          score += 60
        end
        
        score
      end
    end
    
    #===========================================================================
    # Turn Order Manipulation (After You, Quash, Instruct)
    #===========================================================================
    module TurnOrderDoubles
      # Evaluates After You (makes ally move next)
      def self.evaluate_after_you(battle, attacker, move, skill_level = 100)
        return 0 unless skill_level >= 70
        return 0 unless battle.pbSideSize(0) > 1
        return 0 unless move.id == :AFTERYOU
        
        score = 0
        partner = DoublesCoordination.find_partner(battle, attacker)
        return -50 unless partner
        
        # Useful if partner is slower but has priority needs
        opponents = battle.allOtherSideBattlers(attacker.index).select { |b| b && !b.fainted? }
        
        # Partner is slower than opponents
        partner_outsped = opponents.any? { |opp| partner.speed < opp.speed }
        
        if partner_outsped
          score += 35
          
          # Partner has setup move (wants to set up before being attacked)
          if RedirectionStrategies.partner_is_setting_up?(partner)
            score += 40
          end
          
          # Partner is a sweeper
          if partner.attack > 120 || partner.spatk > 120
            score += 25
          end
          
          # Partner is low HP (needs to attack before KO'd)
          if partner.hp < partner.totalhp * 0.4
            score += 30
          end
        else
          score -= 30  # Partner already faster, After You less useful
        end
        
        score
      end
      
      # Evaluates Quash (makes opponent move last)
      def self.evaluate_quash(battle, attacker, move, target, skill_level = 100)
        return 0 unless skill_level >= 70
        return 0 unless battle.pbSideSize(0) > 1
        return 0 unless move.id == :QUASH
        return 0 unless target
        
        score = 0
        partner = DoublesCoordination.find_partner(battle, attacker)
        
        # Target is faster than our team
        allies = battle.allSameSideBattlers(attacker.index).select { |b| b && !b.fainted? }
        target_faster_than_allies = allies.any? { |ally| target.speed > ally.speed }
        
        if target_faster_than_allies
          score += 40
          
          # Target is a setup sweeper (delay their setup)
          setup_moves = [:SWORDSDANCE, :NASTYPLOT, :DRAGONDANCE, :SHELLSMASH, :QUIVERDANCE]
          if target.moves.any? { |m| m && setup_moves.include?(m.id) }
            score += 35
          end
          
          # Target has priority moves (Quash still makes them go last)
          if target.moves.any? { |m| m && m.priority > 0 }
            score += 25
          end
        else
          score -= 25  # Target already slow
        end
        
        score
      end
      
      # Evaluates Instruct (makes ally repeat their move)
      def self.evaluate_instruct(battle, attacker, move, skill_level = 100)
        return 0 unless skill_level >= 75
        return 0 unless battle.pbSideSize(0) > 1
        return 0 unless move.id == :INSTRUCT
        
        score = 0
        partner = DoublesCoordination.find_partner(battle, attacker)
        return -50 unless partner
        
        # Instruct works best with high-damage moves
        # Check partner's last used move (if we can track it)
        if partner.lastMoveUsed
          last_move = GameData::Move.try_get(partner.lastMoveUsed)
          if last_move
            # High power move = good target for Instruct
            if last_move.power >= 100
              score += 50
            elsif last_move.power >= 70
              score += 30
            elsif last_move.power == 0
              score -= 30  # Status move, less value
            end
            
            # Spread move = extra value (hits multiple)
            if last_move.target && last_move.target.num_targets > 1
              score += 25
            end
          end
        else
          # No last move tracked, moderate score
          if partner.attack > 120 || partner.spatk > 120
            score += 25  # Offensive partner likely used strong move
          end
        end
        
        score
      end
    end
    
    #===========================================================================
    # Additional Protection Moves (Mat Block, Crafty Shield, Spotlight)
    #===========================================================================
    module AdditionalProtectionDoubles
      # Evaluates Mat Block (Riolu/Lucario's team protection, Turn 1 only)
      def self.evaluate_mat_block(battle, attacker, move, skill_level = 100)
        return 0 unless skill_level >= 70
        return 0 unless battle.pbSideSize(0) > 1
        return 0 unless move.id == :MATBLOCK
        
        score = 0
        
        # Mat Block only works on Turn 1
        if attacker.turnCount != 0
          return -100  # Fails if not first turn out
        end
        
        # Protects entire team from damaging moves
        score += 60
        
        # Check if partner is setting up
        partner = DoublesCoordination.find_partner(battle, attacker)
        if partner && RedirectionStrategies.partner_is_setting_up?(partner)
          score += 40
        end
        
        # Bonus if opponents have strong attackers
        opponents = battle.allOtherSideBattlers(attacker.index).select { |b| b && !b.fainted? }
        high_offense = opponents.count { |opp| opp.attack > 100 || opp.spatk > 100 }
        score += high_offense * 20
        
        score
      end
      
      # Evaluates Crafty Shield (blocks status moves for team)
      def self.evaluate_crafty_shield(battle, attacker, move, skill_level = 100)
        return 0 unless skill_level >= 70
        return 0 unless battle.pbSideSize(0) > 1
        return 0 unless move.id == :CRAFTYSHIELD
        
        score = 0
        
        # Check if opponents have status moves
        opponents = battle.allOtherSideBattlers(attacker.index).select { |b| b && !b.fainted? }
        status_moves = 0
        dangerous_status = [:SPORE, :DARKVOIDE, :THUNDERWAVE, :WILLOWISP, :TOXIC, 
                            :TAUNT, :ENCORE, :DISABLE, :SWAGGER]
        
        opponents.each do |opp|
          opp.moves.each do |opp_move|
            next unless opp_move
            if opp_move.category == 2 || dangerous_status.include?(opp_move.id)
              status_moves += 1
            end
          end
        end
        
        if status_moves == 0
          return -40  # No status moves to block
        end
        
        score += status_moves * 15
        
        # Extra value if partner is vulnerable to status
        partner = DoublesCoordination.find_partner(battle, attacker)
        if partner
          # Physical attacker vulnerable to burn
          if partner.attack > partner.spatk
            score += 15
          end
          # Fast Pokemon vulnerable to paralysis
          if partner.speed > 100
            score += 15
          end
        end
        
        # Protect rate penalty
        if attacker.effects[PBEffects::ProtectRate] > 1
          score -= 40
        end
        
        score
      end
      
      # Evaluates Spotlight (makes opponent the center of attention)
      def self.evaluate_spotlight(battle, attacker, move, target, skill_level = 100)
        return 0 unless skill_level >= 75
        return 0 unless battle.pbSideSize(0) > 1
        return 0 unless move.id == :SPOTLIGHT
        return 0 unless target
        
        score = 0
        partner = DoublesCoordination.find_partner(battle, attacker)
        return 0 unless partner
        
        # Spotlight redirects attacks TO the target
        # Useful when target has ability that punishes contact or is bulky
        
        # Target has Rough Skin, Iron Barbs, etc.
        punishing_abilities = [:ROUGHSKIN, :IRONBARBS, :FLAMEBODY, :STATIC, :POISONPOINT]
        if punishing_abilities.include?(target.ability_id)
          score += 40
        end
        
        # Target is bulky (can take hits)
        if target.defense > 100 || target.spdef > 100
          score += 25
        end
        
        # Target has Rocky Helmet
        if target.item_id == :ROCKYHELMET
          score += 30
        end
        
        score
      end
    end
    
    #===========================================================================
    # Gen 9 Specific Moves & Abilities
    #===========================================================================
    module Gen9DoublesStrategies
      # Evaluates Revival Blessing (revive fainted ally)
      def self.evaluate_revival_blessing(battle, attacker, move, skill_level = 100)
        return 0 unless skill_level >= 75
        return 0 unless battle.pbSideSize(0) > 1
        return 0 unless move.id == :REVIVALBLESSING
        
        score = 0
        
        # Check for fainted party members
        party = battle.pbParty(attacker.index)
        fainted_count = party.count { |pkmn| pkmn && pkmn.fainted? }
        
        if fainted_count == 0
          return -100  # No one to revive
        end
        
        score += 70  # Strong move to bring back ally
        
        # Extra value if key Pokemon is fainted
        # (Check for high BST or key roles)
        party.each do |pkmn|
          next unless pkmn && pkmn.fainted?
          bst = pkmn.baseStats.values.sum
          if bst > 500
            score += 30  # Strong Pokemon worth reviving
            break
          end
        end
        
        score
      end
      
      # Evaluates Shed Tail (create substitute for switch-in)
      def self.evaluate_shed_tail(battle, attacker, move, skill_level = 100)
        return 0 unless skill_level >= 75
        return 0 unless battle.pbSideSize(0) > 1
        return 0 unless move.id == :SHEDTAIL
        
        score = 0
        
        # Need HP to sacrifice
        if attacker.hp <= attacker.totalhp / 2
          return -50  # Too low HP to use
        end
        
        # Check for good switch-in candidates
        party = battle.pbParty(attacker.index)
        available = party.count { |pkmn| pkmn && !pkmn.fainted? && pkmn != attacker.pokemon }
        
        if available == 0
          return -100  # No one to switch in
        end
        
        score += 50
        
        # Extra value if we have setup sweepers in back
        party.each do |pkmn|
          next unless pkmn && !pkmn.fainted? && pkmn != attacker.pokemon
          # Check for setup move in moveset
          pkmn.moves.each do |m|
            next unless m
            if [:SWORDSDANCE, :NASTYPLOT, :DRAGONDANCE, :SHELLSMASH, :QUIVERDANCE, :CALMMIND].include?(m.id)
              score += 35
              break
            end
          end
        end
        
        score
      end
      
      # Evaluates Doodle (copy ability to partner)
      def self.evaluate_doodle(battle, attacker, move, target, skill_level = 100)
        return 0 unless skill_level >= 75
        return 0 unless battle.pbSideSize(0) > 1
        return 0 unless move.id == :DOODLE
        return 0 unless target
        
        score = 0
        partner = DoublesCoordination.find_partner(battle, attacker)
        return 0 unless partner
        
        # Good abilities to copy
        good_abilities = [:INTIMIDATE, :HUGEPOWER, :PUREPOWER, :SPEEDBOOST, :PROTEAN, 
                          :LIBERO, :ADAPTABILITY, :CONTRARY, :MOODY, :UNAWARE,
                          :MAGICGUARD, :MULTISCALE, :STURDY, :LEVITATE]
        
        if good_abilities.include?(target.ability_id)
          score += 50
          
          # Synergy check - does partner benefit?
          case target.ability_id
          when :HUGEPOWER, :PUREPOWER
            score += 30 if partner.attack > partner.spatk
          when :SPEEDBOOST
            score += 25 if partner.speed < 100
          when :INTIMIDATE
            score += 20  # Always useful
          end
        end
        
        score
      end
      
      # Checks for Commander ability combo (Tatsugiri + Dondozo)
      def self.check_commander_combo(battle, attacker)
        return 0 unless battle.pbSideSize(0) > 1
        
        partner = DoublesCoordination.find_partner(battle, attacker)
        return 0 unless partner
        
        # Check for Commander ability and Dondozo
        if attacker.ability_id == :COMMANDER && partner.species == :DONDOZO
          return 100  # Massive bonus for this combo
        elsif partner.ability_id == :COMMANDER && attacker.species == :DONDOZO
          return 80  # Bonus for being the Dondozo
        end
        
        0
      end
      
      # Evaluates Tidy Up (removes hazards and substitutes)
      def self.evaluate_tidy_up(battle, attacker, move, skill_level = 100)
        return 0 unless skill_level >= 65
        return 0 unless move.id == :TIDYUP
        
        score = 0
        
        # Check for hazards on our side
        own_side = attacker.pbOwnSide
        hazard_count = 0
        hazard_count += 1 if own_side.effects[PBEffects::StealthRock]
        hazard_count += own_side.effects[PBEffects::Spikes] if own_side.effects[PBEffects::Spikes]
        hazard_count += own_side.effects[PBEffects::ToxicSpikes] if own_side.effects[PBEffects::ToxicSpikes]
        hazard_count += 1 if own_side.effects[PBEffects::StickyWeb]
        
        score += hazard_count * 20
        
        # Also removes substitutes (can be useful against opponent subs)
        opponents = battle.allOtherSideBattlers(attacker.index).select { |b| b && !b.fainted? }
        subs = opponents.count { |opp| opp.effects[PBEffects::Substitute] > 0 }
        score += subs * 25
        
        # Bonus: Also boosts Attack and Speed
        if attacker.stages[:ATTACK] < 6
          score += 20
        end
        if attacker.stages[:SPEED] < 6
          score += 15
        end
        
        score
      end
      
      # Evaluates Psychic Terrain synergy (blocks priority)
      def self.evaluate_psychic_terrain_doubles(battle, attacker, move, skill_level = 100)
        return 0 unless skill_level >= 70
        return 0 unless battle.pbSideSize(0) > 1
        return 0 unless move.id == :PSYCHICTERRAIN
        
        score = 0
        
        # Already active?
        if battle.field.terrain == :Psychic
          return -60
        end
        
        # Blocks priority moves - check if opponents have them
        opponents = battle.allOtherSideBattlers(attacker.index).select { |b| b && !b.fainted? }
        priority_count = 0
        opponents.each do |opp|
          opp.moves.each do |m|
            next unless m
            priority_count += 1 if m.priority > 0
          end
        end
        
        score += priority_count * 20
        
        # Boosts Psychic moves
        allies = battle.allSameSideBattlers(attacker.index).select { |b| b && !b.fainted? }
        psychic_users = allies.count do |ally|
          ally.moves.any? { |m| m && m.type == :PSYCHIC && m.damagingMove? }
        end
        score += psychic_users * 25
        
        # Synergy with Expanding Force (becomes spread move)
        expanding_force_users = allies.count do |ally|
          ally.moves.any? { |m| m && m.id == :EXPANDINGFORCE }
        end
        score += expanding_force_users * 40
        
        score
      end
      
      # Evaluates Electromorphosis / Wind Rider ability synergy
      def self.check_ability_synergy(battle, attacker, move)
        return 0 unless battle.pbSideSize(0) > 1
        
        partner = DoublesCoordination.find_partner(battle, attacker)
        return 0 unless partner
        
        score = 0
        
        # Wind Rider: Boosted by wind moves from partner
        wind_moves = [:TAILWIND, :BLEAKWINDSTORM, :SPRINGTIDESTORM, :WILDSTORMWIND]
        if partner.ability_id == :WINDRIDER && wind_moves.include?(move.id)
          score += 45  # Partner gets Attack boost
        end
        
        # Electromorphosis: Takes Electric hit to charge
        # (Less relevant for AI using move, but check for partner)
        
        # Steam Engine: Speed boost from Fire/Water
        if partner.ability_id == :STEAMENGINE
          if move.type == :FIRE || move.type == :WATER
            # Only if move hits partner
            if DoublesCoordination.hits_partner?(move, attacker, partner)
              score += 35
            end
          end
        end
        
        # Anger Point: Critical hit triggers max Attack
        # (Hard to control, but Frost Breath/Storm Throw always crit)
        if partner.ability_id == :ANGERPOINT
          if [:FROSTBREATH, :STORMTHROW].include?(move.id)
            if DoublesCoordination.hits_partner?(move, attacker, partner)
              score += 60  # Guaranteed max Attack!
            end
          end
        end
        
        score
      end
      
      # Evaluates Hospitality ability (heals partner on switch-in)
      def self.check_hospitality_synergy(battle, attacker)
        return 0 unless battle.pbSideSize(0) > 1
        return 0 unless attacker.ability_id == :HOSPITALITY
        
        partner = DoublesCoordination.find_partner(battle, attacker)
        return 0 unless partner
        
        # Hospitality already triggered on switch, but useful context
        if partner.hp < partner.totalhp * 0.75
          return 20  # Partner appreciates the heal
        end
        
        0
      end
    end
    
    #===========================================================================
    # Gen 8 Dynamax Coordination for Doubles
    #===========================================================================
    module DynamaxDoublesStrategies
      # Max Moves that benefit the whole team
      MAX_TEAM_MOVES = {
        :MAXAIRSTREAM => :SPEED,      # +1 Speed to all allies
        :MAXSTEELSPIKE => :DEFENSE,   # +1 Defense to all allies
        :MAXQUAKE => :SPDEF,          # +1 SpDef to all allies
        :MAXOOZE => :SPATK,           # +1 SpAtk to all allies
        :MAXKNUCKLE => :ATTACK,       # +1 Attack to all allies
      }
      
      # Max Moves that set weather
      MAX_WEATHER_MOVES = {
        :MAXFLARE => :Sun,
        :MAXGEYSER => :Rain,
        :MAXROCKFALL => :Sandstorm,
        :MAXHAILSTORM => :Hail
      }
      
      # Max Moves that set terrain
      MAX_TERRAIN_MOVES = {
        :MAXLIGHTNING => :Electric,
        :MAXOVERGROWTH => :Grassy,
        :MAXMINDSTORM => :Psychic,
        :MAXSTARFALL => :Misty
      }
      
      # Evaluates Max Guard usage (Protect while Dynamaxed)
      def self.evaluate_max_guard(battle, attacker, move, skill_level = 100)
        return 0 unless skill_level >= 70
        return 0 unless battle.pbSideSize(0) > 1
        return 0 unless move.id == :MAXGUARD
        
        score = 0
        partner = DoublesCoordination.find_partner(battle, attacker)
        
        # Max Guard blocks Max Moves (important in Dynamax mirrors)
        opponents = battle.allOtherSideBattlers(attacker.index).select { |b| b && !b.fainted? }
        dynamaxed_opponents = opponents.count { |opp| opp.dynamax? rescue false }
        
        score += dynamaxed_opponents * 30
        
        # Similar to normal Protect logic
        if partner && RedirectionStrategies.partner_is_setting_up?(partner)
          score += 45
        end
        
        # Protect rate penalty
        if attacker.effects[PBEffects::ProtectRate] > 1
          score -= 50
        end
        
        score
      end
      
      # Evaluates team-boosting Max Moves
      def self.evaluate_max_team_move(battle, attacker, move, skill_level = 100)
        return 0 unless skill_level >= 65
        return 0 unless battle.pbSideSize(0) > 1
        
        stat_boost = MAX_TEAM_MOVES[move.id]
        return 0 unless stat_boost
        
        score = 0
        allies = battle.allSameSideBattlers(attacker.index).select { |b| b && !b.fainted? }
        
        case stat_boost
        when :SPEED
          # Max Airstream - Speed boost is huge in doubles
          slow_allies = allies.count { |a| a.stages[:SPEED] < 6 }
          score += slow_allies * 25
          
          # Extra value if outsped by opponents
          opponents = battle.allOtherSideBattlers(attacker.index).select { |b| b && !b.fainted? }
          outsped = allies.count { |a| opponents.any? { |o| o.speed > a.speed } }
          score += outsped * 15
          
        when :ATTACK
          # Max Knuckle - boost physical attackers
          phys_attackers = allies.count { |a| a.attack > a.spatk && a.stages[:ATTACK] < 6 }
          score += phys_attackers * 20
          
        when :SPATK
          # Max Ooze - boost special attackers
          spec_attackers = allies.count { |a| a.spatk > a.attack && a.stages[:SPECIAL_ATTACK] < 6 }
          score += spec_attackers * 20
          
        when :DEFENSE
          # Max Steelspike - boost team defense
          score += allies.count * 15
          # Extra if facing physical threats
          opponents = battle.allOtherSideBattlers(attacker.index).select { |b| b && !b.fainted? }
          phys_threats = opponents.count { |o| o.attack > o.spatk }
          score += phys_threats * 10
          
        when :SPDEF
          # Max Quake - boost team SpDef
          score += allies.count * 15
          opponents = battle.allOtherSideBattlers(attacker.index).select { |b| b && !b.fainted? }
          spec_threats = opponents.count { |o| o.spatk > o.attack }
          score += spec_threats * 10
        end
        
        score
      end
      
      # Evaluates weather-setting Max Moves
      def self.evaluate_max_weather_move(battle, attacker, move, skill_level = 100)
        return 0 unless skill_level >= 65
        return 0 unless battle.pbSideSize(0) > 1
        
        weather_type = MAX_WEATHER_MOVES[move.id]
        return 0 unless weather_type
        
        # Use existing weather coordination logic
        score = WeatherCoordinationDoubles.evaluate_weather_move(battle, attacker, move, skill_level)
        
        # Bonus for Max Move (more damage than regular weather move)
        score += 15
        
        score
      end
      
      # Evaluates terrain-setting Max Moves
      def self.evaluate_max_terrain_move(battle, attacker, move, skill_level = 100)
        return 0 unless skill_level >= 65
        return 0 unless battle.pbSideSize(0) > 1
        
        terrain_type = MAX_TERRAIN_MOVES[move.id]
        return 0 unless terrain_type
        
        # Use existing terrain coordination logic
        score = TerrainSynergyDoubles.evaluate_terrain_doubles(battle, attacker, move, skill_level)
        
        # Bonus for Max Move
        score += 15
        
        score
      end
      
      # Evaluates when to Dynamax in doubles
      def self.evaluate_dynamax_timing(battle, attacker, skill_level = 100)
        return 0 unless skill_level >= 70
        return 0 unless battle.pbSideSize(0) > 1
        
        score = 0
        partner = DoublesCoordination.find_partner(battle, attacker)
        
        # Don't both Dynamax at the same time
        if partner && (partner.dynamax? rescue false)
          score -= 60  # Partner already Dynamaxed
        end
        
        # Dynamax when you're the main threat
        if attacker.attack > 130 || attacker.spatk > 130
          score += 30
        end
        
        # Dynamax for survivability when low
        if attacker.hp < attacker.totalhp * 0.5
          score += 25
        end
        
        # Dynamax if partner can support (Helping Hand, Follow Me)
        if partner
          support_moves = [:HELPINGHAND, :FOLLOWME, :RAGEPOWDER, :ALLYSWITCH]
          has_support = partner.moves.any? { |m| m && support_moves.include?(m.id) }
          score += 35 if has_support
        end
        
        score
      end
      
      # G-Max moves with special effects
      def self.evaluate_gmax_move(battle, attacker, move, skill_level = 100)
        return 0 unless skill_level >= 70
        return 0 unless battle.pbSideSize(0) > 1
        
        score = 0
        
        # G-Max Volcalith (ongoing Rock damage)
        if move.id == :GMAXVOLCALITH
          opponents = battle.allOtherSideBattlers(attacker.index).count { |b| b && !b.fainted? }
          score += opponents * 20
        end
        
        # G-Max Vine Lash / Wildfire / Cannonade (ongoing damage)
        if [:GMAXVINELASH, :GMAXWILDFIRE, :GMAXCANNONADE].include?(move.id)
          opponents = battle.allOtherSideBattlers(attacker.index).count { |b| b && !b.fainted? }
          score += opponents * 20
        end
        
        # G-Max Wind Rage (removes screens/hazards)
        if move.id == :GMAXWINDRAGE
          opp_side = attacker.pbOpposingSide
          has_screens = opp_side.effects[PBEffects::Reflect] > 0 || 
                        opp_side.effects[PBEffects::LightScreen] > 0 ||
                        opp_side.effects[PBEffects::AuroraVeil] > 0
          score += 40 if has_screens
        end
        
        # G-Max Resonance (Aurora Veil effect)
        if move.id == :GMAXRESONANCE
          if attacker.pbOwnSide.effects[PBEffects::AuroraVeil] == 0
            score += 50
          end
        end
        
        score
      end
    end
    
    #===========================================================================
    # Additional Gen 9 Doubles Strategies
    #===========================================================================
    module Gen9ExtendedStrategies
      # Evaluates Terastallization coordination
      def self.evaluate_tera_timing_doubles(battle, attacker, skill_level = 100)
        return 0 unless skill_level >= 75
        return 0 unless battle.pbSideSize(0) > 1
        
        score = 0
        partner = DoublesCoordination.find_partner(battle, attacker)
        
        # Don't both Tera at the same time (usually)
        if partner && (partner.tera? rescue false)
          score -= 30  # Partner already Terastallized
        end
        
        # Tera to STAB boost (offensive Tera)
        tera_type = attacker.tera_type rescue nil
        if tera_type
          # Check if we have moves of that type
          tera_moves = attacker.moves.count { |m| m && m.type == tera_type && m.damagingMove? }
          score += tera_moves * 20
        end
        
        # Defensive Tera (change type to resist threats)
        opponents = battle.allOtherSideBattlers(attacker.index).select { |b| b && !b.fainted? }
        # This is complex - simplified version
        if attacker.hp < attacker.totalhp * 0.6
          score += 15  # More likely to Tera for survival
        end
        
        score
      end
      
      # Evaluates Collision Course / Electro Drift (boosted if super effective)
      def self.evaluate_paradox_moves(battle, attacker, move, target, skill_level = 100)
        return 0 unless skill_level >= 65
        return 0 unless [:COLLISIONCOURSE, :ELECTRODRIFT].include?(move.id)
        return 0 unless target
        
        score = 0
        
        # These moves get 33% boost if super effective
        type_mod = Effectiveness.calculate(move.type, target.types[0], target.types[1])
        if Effectiveness.super_effective?(type_mod)
          score += 35  # Bonus for using on weak target
        end
        
        score
      end
      
      # Evaluates Ice Spinner / Steel Roller (terrain removal)
      def self.evaluate_terrain_removal(battle, attacker, move, skill_level = 100)
        return 0 unless skill_level >= 60
        return 0 unless [:ICESPINNER, :STEELROLLER].include?(move.id)
        
        score = 0
        
        # Check if terrain is active
        if battle.field.terrain != :None
          score += 30
          
          # Extra bonus if opponent benefits from terrain
          opponents = battle.allOtherSideBattlers(attacker.index).select { |b| b && !b.fainted? }
          
          case battle.field.terrain
          when :Electric
            # Remove if opponents have Electric moves or Surge Surfer
            electric_benefit = opponents.any? { |o| o.ability_id == :SURGESURFER }
            score += 25 if electric_benefit
          when :Psychic
            # Priority blocking might help opponents more
            allies = battle.allSameSideBattlers(attacker.index).select { |b| b && !b.fainted? }
            ally_priority = allies.count { |a| a.moves.any? { |m| m && m.priority > 0 } }
            score += ally_priority * 15  # Remove if WE have priority
          when :Grassy
            # Healing might help opponents
            score += 15
          end
        else
          # Steel Roller fails without terrain
          if move.id == :STEELROLLER
            return -100
          end
        end
        
        score
      end
      
      # Evaluates Court Change (swaps hazards)
      def self.evaluate_court_change(battle, attacker, move, skill_level = 100)
        return 0 unless skill_level >= 70
        return 0 unless move.id == :COURTCHANGE
        
        score = 0
        own_side = attacker.pbOwnSide
        opp_side = attacker.pbOpposingSide
        
        # Count our hazards
        our_hazards = 0
        our_hazards += 1 if own_side.effects[PBEffects::StealthRock]
        our_hazards += own_side.effects[PBEffects::Spikes] if own_side.effects[PBEffects::Spikes]
        our_hazards += own_side.effects[PBEffects::ToxicSpikes] if own_side.effects[PBEffects::ToxicSpikes]
        our_hazards += 1 if own_side.effects[PBEffects::StickyWeb]
        
        # Count their hazards
        their_hazards = 0
        their_hazards += 1 if opp_side.effects[PBEffects::StealthRock]
        their_hazards += opp_side.effects[PBEffects::Spikes] if opp_side.effects[PBEffects::Spikes]
        their_hazards += opp_side.effects[PBEffects::ToxicSpikes] if opp_side.effects[PBEffects::ToxicSpikes]
        their_hazards += 1 if opp_side.effects[PBEffects::StickyWeb]
        
        # Also count screens
        our_screens = 0
        our_screens += 1 if own_side.effects[PBEffects::Reflect] > 0
        our_screens += 1 if own_side.effects[PBEffects::LightScreen] > 0
        our_screens += 1 if own_side.effects[PBEffects::AuroraVeil] > 0
        
        their_screens = 0
        their_screens += 1 if opp_side.effects[PBEffects::Reflect] > 0
        their_screens += 1 if opp_side.effects[PBEffects::LightScreen] > 0
        their_screens += 1 if opp_side.effects[PBEffects::AuroraVeil] > 0
        
        # Good if we have more hazards and they have more screens
        score += (our_hazards - their_hazards) * 20
        score += (their_screens - our_screens) * 25
        
        # Also consider Tailwind
        our_tailwind = own_side.effects[PBEffects::Tailwind] > 0 ? 1 : 0
        their_tailwind = opp_side.effects[PBEffects::Tailwind] > 0 ? 1 : 0
        score += (their_tailwind - our_tailwind) * 30
        
        score
      end
      
      # Evaluates Mortal Spin (hazard removal + poison)
      def self.evaluate_mortal_spin(battle, attacker, move, skill_level = 100)
        return 0 unless skill_level >= 60
        return 0 unless move.id == :MORTALSPIN
        
        score = 0
        own_side = attacker.pbOwnSide
        
        # Check for hazards to remove
        hazard_count = 0
        hazard_count += 1 if own_side.effects[PBEffects::StealthRock]
        hazard_count += own_side.effects[PBEffects::Spikes] if own_side.effects[PBEffects::Spikes]
        hazard_count += own_side.effects[PBEffects::ToxicSpikes] if own_side.effects[PBEffects::ToxicSpikes]
        hazard_count += 1 if own_side.effects[PBEffects::StickyWeb]
        
        score += hazard_count * 25
        
        # Also poisons targets (spread move in doubles)
        if battle.pbSideSize(0) > 1
          opponents = battle.allOtherSideBattlers(attacker.index).select { |b| b && !b.fainted? }
          poisonable = opponents.count do |opp|
            !opp.pbHasType?(:POISON) && !opp.pbHasType?(:STEEL) && opp.status == :NONE
          end
          score += poisonable * 15
        end
        
        score
      end
      
      # Evaluates Make It Rain (spread move with SpAtk drop)
      def self.evaluate_make_it_rain(battle, attacker, move, skill_level = 100)
        return 0 unless skill_level >= 65
        return 0 unless battle.pbSideSize(0) > 1
        return 0 unless move.id == :MAKEITRAIN
        
        score = 0
        opponents = battle.allOtherSideBattlers(attacker.index).select { |b| b && !b.fainted? }
        
        # Spread Steel move is good
        score += opponents.count * 20
        
        # But drops SpAtk - penalty if staying in
        if attacker.hp > attacker.totalhp * 0.5
          score -= 15  # Staying in, SpAtk drop hurts
        else
          score += 10  # Might switch out anyway
        end
        
        score
      end
      
      # Evaluates Triple Arrows (defense drop + flinch chance)
      def self.evaluate_triple_arrows(battle, attacker, move, target, skill_level = 100)
        return 0 unless skill_level >= 60
        return 0 unless move.id == :TRIPLEARROWS
        return 0 unless target
        
        score = 0
        
        # Defense drop helps partner's physical attacks
        partner = DoublesCoordination.find_partner(battle, attacker)
        if partner && partner.attack > partner.spatk
          score += 25
        end
        
        # Flinch chance
        if attacker.speed > target.speed
          score += 15
        end
        
        score
      end
      
      # Evaluates Trailblaze / Chilling Water (guaranteed stat changes)
      def self.evaluate_stat_lowering_attacks(battle, attacker, move, target, skill_level = 100)
        return 0 unless skill_level >= 60
        return 0 unless [:TRAILBLAZE, :CHILLINGWATER, :LUMINACRASH].include?(move.id)
        return 0 unless target
        
        score = 0
        
        case move.id
        when :TRAILBLAZE
          # Boosts own Speed
          if attacker.stages[:SPEED] < 6
            score += 20
          end
        when :CHILLINGWATER
          # Lowers target Attack
          partner = DoublesCoordination.find_partner(battle, attacker)
          if partner && target.attack > target.spatk
            score += 25  # Reduce threat to partner
          end
        when :LUMINACRASH
          # Drops SpDef by 2 stages
          partner = DoublesCoordination.find_partner(battle, attacker)
          if partner && partner.spatk > partner.attack
            score += 30  # Partner can capitalize
          end
        end
        
        score
      end
      
      # Evaluates Order Up (Commander boost when Dondozo uses it)
      def self.evaluate_order_up(battle, attacker, move, skill_level = 100)
        return 0 unless skill_level >= 70
        return 0 unless move.id == :ORDERUP
        
        score = 0
        
        # Check if Tatsugiri is in the Commander slot
        if attacker.species == :DONDOZO
          # Dondozo with Tatsugiri inside gets stat boost based on Tatsugiri form
          # This is complex to check, but give base bonus
          score += 30
        end
        
        score
      end
      
      # Evaluates Salt Cure (ongoing damage based on type)
      def self.evaluate_salt_cure(battle, attacker, move, target, skill_level = 100)
        return 0 unless skill_level >= 65
        return 0 unless move.id == :SALTCURE
        return 0 unless target
        
        score = 0
        
        # Salt Cure does 1/8 damage, 1/4 to Water/Steel
        if target.pbHasType?(:WATER) || target.pbHasType?(:STEEL)
          score += 50  # Double damage per turn!
        else
          score += 25  # Still good chip damage
        end
        
        # More valuable if target is bulky (will take more turns)
        if target.hp > target.totalhp * 0.7
          score += 15
        end
        
        score
      end
      
      # Evaluates Rage Fist (power increases with hits taken)
      def self.evaluate_rage_fist(battle, attacker, move, skill_level = 100)
        return 0 unless skill_level >= 60
        return 0 unless move.id == :RAGEFIST
        
        score = 0
        
        # Check how many times attacker has been hit
        times_hit = attacker.effects[PBEffects::RageFist] rescue 0
        
        # Base power 50 + 50 per hit, max 350
        effective_power = [50 + (times_hit * 50), 350].min
        
        if effective_power >= 200
          score += 40
        elsif effective_power >= 150
          score += 25
        elsif effective_power >= 100
          score += 10
        end
        
        score
      end
    end
    
    #===========================================================================
    # Terrain Synergy for Doubles
    #===========================================================================
    module TerrainSynergyDoubles
      TERRAIN_MOVES = {
        :ELECTRICTERRAIN => :Electric,
        :GRASSYTERRAIN => :Grassy,
        :PSYCHICTERRAIN => :Psychic,
        :MISTYTERRAIN => :Misty
      }
      
      TERRAIN_ABILITIES = {
        :Electric => [:SURGESURFER, :ELECTRICSEED],
        :Grassy => [:GRASSYSEED],
        :Psychic => [:PSYCHICSEED],
        :Misty => [:MISTYSEED]
      }
      
      def self.evaluate_terrain_doubles(battle, attacker, move, skill_level = 100)
        return 0 unless skill_level >= 70
        return 0 unless battle.pbSideSize(0) > 1
        
        terrain_type = TERRAIN_MOVES[move.id]
        return 0 unless terrain_type
        
        score = 0
        
        # Already active?
        if battle.field.terrain == terrain_type
          return -60
        end
        
        allies = battle.allSameSideBattlers(attacker.index).select { |b| b && !b.fainted? }
        
        # Check ability synergy
        synergy_abilities = TERRAIN_ABILITIES[terrain_type] || []
        allies.each do |ally|
          if synergy_abilities.include?(ally.ability_id)
            score += 35
          end
          
          # Check for Seed items
          seed_items = {
            :Electric => :ELECTRICSEED,
            :Grassy => :GRASSYSEED,
            :Psychic => :PSYCHICSEED,
            :Misty => :MISTYSEED
          }
          if ally.item_id == seed_items[terrain_type]
            score += 40
          end
        end
        
        # Type-specific bonuses
        case terrain_type
        when :Electric
          # Boosts Electric moves, prevents Sleep
          electric_users = allies.count { |a| a.moves.any? { |m| m && m.type == :ELECTRIC && m.damagingMove? } }
          score += electric_users * 20
          # Rising Voltage doubles in Electric Terrain
          rising_voltage_users = allies.count { |a| a.moves.any? { |m| m && m.id == :RISINGVOLTAGE } }
          score += rising_voltage_users * 35
          
        when :Grassy
          # Heals grounded Pokemon, boosts Grass, weakens Earthquake
          grass_users = allies.count { |a| a.moves.any? { |m| m && m.type == :GRASS && m.damagingMove? } }
          score += grass_users * 20
          # Reduces Earthquake damage
          opponents = battle.allOtherSideBattlers(attacker.index).select { |b| b && !b.fainted? }
          eq_users = opponents.count { |o| o.moves.any? { |m| m && m.id == :EARTHQUAKE } }
          score += eq_users * 15
          # Grassy Glide priority
          grassy_glide_users = allies.count { |a| a.moves.any? { |m| m && m.id == :GRASSYGLIDE } }
          score += grassy_glide_users * 30
          
        when :Psychic
          # Blocks priority, boosts Psychic moves
          psychic_users = allies.count { |a| a.moves.any? { |m| m && m.type == :PSYCHIC && m.damagingMove? } }
          score += psychic_users * 20
          # Expanding Force becomes spread move
          expanding_force_users = allies.count { |a| a.moves.any? { |m| m && m.id == :EXPANDINGFORCE } }
          score += expanding_force_users * 40
          
        when :Misty
          # Prevents status, weakens Dragon
          opponents = battle.allOtherSideBattlers(attacker.index).select { |b| b && !b.fainted? }
          dragon_users = opponents.count { |o| o.moves.any? { |m| m && m.type == :DRAGON && m.damagingMove? } }
          score += dragon_users * 20
          # Misty Explosion boosted
          misty_explosion_users = allies.count { |a| a.moves.any? { |m| m && m.id == :MISTYEXPLOSION } }
          score += misty_explosion_users * 25
        end
        
        score
      end
    end
    
    #===========================================================================
    # Item Awareness for Doubles (VGC Meta Items)
    #===========================================================================
    module ItemAwarenessDoubles
      # Focus Sash awareness - don't overkill, need to break sash first
      def self.check_focus_sash(battle, attacker, target, move, skill_level = 100)
        return 0 unless skill_level >= 70
        return 0 unless target
        return 0 unless target.item_id == :FOCUSSASH
        return 0 unless target.hp == target.totalhp  # Sash only works at full HP
        
        score = 0
        
        # Multi-hit moves break sash then KO
        if move.multiHitMove?
          score += 40
        end
        
        # Spread moves - partner can break sash, we KO
        partner = DoublesCoordination.find_partner(battle, attacker)
        if partner && battle.pbSideSize(0) > 1
          # If partner is faster and also attacking this target
          score += 25
        end
        
        # Weather/hazard damage breaks sash
        if battle.field.weather != :None
          weather_damages = [:Sandstorm, :Hail]
          if weather_damages.include?(battle.field.weather)
            # Check if target takes weather damage
            unless target.pbHasType?(:ROCK) || target.pbHasType?(:GROUND) || 
                   target.pbHasType?(:STEEL) || target.pbHasType?(:ICE)
              score += 20  # Weather will break sash
            end
          end
        end
        
        score
      end
      
      # Weakness Policy abuse - hit partner with weak super effective move
      def self.evaluate_weakness_policy_abuse(battle, attacker, move, skill_level = 100)
        return 0 unless skill_level >= 80
        return 0 unless battle.pbSideSize(0) > 1
        
        partner = DoublesCoordination.find_partner(battle, attacker)
        return 0 unless partner
        return 0 unless partner.item_id == :WEAKNESSPOLICY
        
        score = 0
        
        # Check if move hits partner and is super effective
        if DoublesCoordination.hits_partner?(move, attacker, partner)
          type_mod = Effectiveness.calculate(move.type, partner.types[0], partner.types[1])
          
          if Effectiveness.super_effective?(type_mod)
            # Low power move preferred (don't KO partner!)
            if move.power <= 40
              score += 80  # Weak move triggers WP without killing
            elsif move.power <= 60
              score += 50
            else
              score -= 20  # Too strong, might KO
            end
          end
        end
        
        # Beat Up on WP Justified mon is god-tier
        if move.id == :BEATUP && partner.ability_id == :JUSTIFIED && partner.item_id == :WEAKNESSPOLICY
          score += 100  # +4 Attack and +2 Attack/SpAtk!
        end
        
        score
      end
      
      # Safety Goggles awareness (immune to powder/spore moves)
      def self.check_safety_goggles(battle, attacker, target, move, skill_level = 100)
        return 0 unless skill_level >= 65
        return 0 unless target
        return 0 unless target.item_id == :SAFETYGOGGLES
        
        score = 0
        
        powder_moves = [:SPORE, :SLEEPPOWDER, :STUNSPORE, :POISONPOWDER, :RAGEPOWDER,
                        :POWDER, :COTTONSPORE]
        
        if powder_moves.include?(move.id)
          score -= 80  # Move will fail
        end
        
        score
      end
      
      # Assault Vest awareness (can only use attacking moves)
      def self.check_assault_vest_target(battle, target, skill_level = 100)
        return 0 unless skill_level >= 60
        return 0 unless target
        return 0 unless target.item_id == :ASSAULTVEST
        
        # Target can't use status moves - less Protect, less setup
        30  # Bonus - opponent is limited
      end
      
      # Choice item awareness
      def self.check_choice_item(battle, attacker, target, skill_level = 100)
        return 0 unless skill_level >= 70
        return 0 unless target
        
        choice_items = [:CHOICEBAND, :CHOICESPECS, :CHOICESCARF]
        return 0 unless choice_items.include?(target.item_id)
        
        score = 0
        
        # Choice locked opponent - can predict their move
        if target.lastMoveUsed
          score += 25  # We know what they're locked into
          
          # If locked into something we resist
          last_move = GameData::Move.try_get(target.lastMoveUsed)
          if last_move
            type_mod = Effectiveness.calculate(last_move.type, attacker.types[0], attacker.types[1])
            if Effectiveness.not_very_effective?(type_mod) || Effectiveness.ineffective?(type_mod)
              score += 35  # They're locked into bad move vs us
            end
          end
        end
        
        score
      end
      
      # Eject Button / Red Card awareness
      def self.check_ejection_items(battle, target, skill_level = 100)
        return 0 unless skill_level >= 70
        return 0 unless target
        
        if target.item_id == :EJECTBUTTON
          # Hitting them causes switch - might lose momentum
          return -15
        elsif target.item_id == :REDCARD
          # Hitting them switches US - careful
          return -25
        end
        
        0
      end
      
      # Air Balloon awareness
      def self.check_air_balloon(battle, target, move, skill_level = 100)
        return 0 unless skill_level >= 60
        return 0 unless target
        return 0 unless target.item_id == :AIRBALLOON
        
        # Ground moves fail
        if move.type == :GROUND
          return -80
        end
        
        # Popping the balloon is valuable
        if move.damagingMove?
          return 15  # Pop their balloon
        end
        
        0
      end
      
      # Room Service / Adrenaline Orb awareness
      def self.check_stat_trigger_items(battle, attacker, partner, skill_level = 100)
        return 0 unless skill_level >= 75
        return 0 unless partner
        
        score = 0
        
        # Room Service triggers in Trick Room
        if partner.item_id == :ROOMSERVICE
          if battle.field.effects[PBEffects::TrickRoom] > 0
            score += 30  # Partner got speed drop for TR
          end
        end
        
        # Adrenaline Orb triggers on Intimidate
        if partner.item_id == :ADRENALINEORB
          # Bonus if facing Intimidate users
          opponents = battle.allOtherSideBattlers(attacker.index).select { |b| b && !b.fainted? }
          if opponents.any? { |o| o.ability_id == :INTIMIDATE }
            score += 25
          end
        end
        
        score
      end
      
      # Sitrus Berry / Healing Berries awareness
      def self.check_healing_berries(battle, target, skill_level = 100)
        return 0 unless skill_level >= 60
        return 0 unless target
        
        healing_berries = [:SITRUSBERRY, :AGUAVBERRY, :FIGYBERRY, :IAPAPABERRY,
                          :MAGOBERRY, :WIKIBERRY, :ORANBERRY]
        
        return 0 unless healing_berries.include?(target.item_id)
        
        # Target will heal at 50% or below - need to burst them
        if target.hp > target.totalhp * 0.5
          return 15  # Try to burst through the heal threshold
        else
          return -10  # They'll heal, might not KO
        end
      end
    end
    
    #===========================================================================
    # Ability Synergies for Doubles (VGC Meta Abilities)
    #===========================================================================
    module AbilitySynergyDoubles
      # Intimidate awareness
      def self.check_intimidate(battle, attacker, skill_level = 100)
        return 0 unless skill_level >= 65
        return 0 unless battle.pbSideSize(0) > 1
        
        score = 0
        partner = DoublesCoordination.find_partner(battle, attacker)
        
        # Check if we have Intimidate
        if attacker.ability_id == :INTIMIDATE
          # Value of Intimidate higher against physical attackers
          opponents = battle.allOtherSideBattlers(attacker.index).select { |b| b && !b.fainted? }
          phys_attackers = opponents.count { |o| o.attack > o.spatk }
          score += phys_attackers * 15
          
          # Check for Defiant/Competitive (they punish Intimidate)
          punishing_abilities = [:DEFIANT, :COMPETITIVE, :CONTRARY, :MIRRORARMOR]
          if opponents.any? { |o| punishing_abilities.include?(o.ability_id) }
            score -= 40
          end
        end
        
        # Check if partner has Defiant/Competitive (Intimidate helps them!)
        if partner
          if partner.ability_id == :DEFIANT || partner.ability_id == :COMPETITIVE
            # Facing Intimidate is actually good for us
            opponents = battle.allOtherSideBattlers(attacker.index).select { |b| b && !b.fainted? }
            if opponents.any? { |o| o.ability_id == :INTIMIDATE }
              score += 35
            end
          end
        end
        
        score
      end
      
      # Prankster awareness
      def self.check_prankster(battle, attacker, move, target, skill_level = 100)
        return 0 unless skill_level >= 70
        return 0 unless attacker.ability_id == :PRANKSTER
        return 0 unless move.category == 2  # Status move
        
        score = 0
        
        # Prankster gives priority to status moves
        score += 20
        
        # But Dark types are immune to Prankster status
        if target && target.pbHasType?(:DARK)
          score -= 80  # Move fails
        end
        
        score
      end
      
      # Inner Focus / Own Tempo (Fake Out immunity)
      def self.check_flinch_immunity(battle, target, move, skill_level = 100)
        return 0 unless skill_level >= 65
        return 0 unless target
        
        flinch_immune = [:INNERFOCUS, :OWNTEMPO, :SHIELDDUST, :SCRAPPY]
        
        if flinch_immune.include?(target.ability_id)
          if move.id == :FAKEOUT || move.addlEffect == "Flinch"
            return -50  # Flinch won't work
          end
        end
        
        0
      end
      
      # Friend Guard awareness (reduces damage to partner)
      def self.check_friend_guard(battle, attacker, target, skill_level = 100)
        return 0 unless skill_level >= 70
        return 0 unless target
        return 0 unless battle.pbSideSize(0) > 1
        
        partner = DoublesCoordination.find_partner(battle, target)
        return 0 unless partner
        
        # If target's partner has Friend Guard, target takes less damage
        if partner.ability_id == :FRIENDGUARD
          return -15  # 25% damage reduction
        end
        
        0
      end
      
      # Telepathy (immune to partner's moves)
      def self.check_telepathy(battle, attacker, move, skill_level = 100)
        return 0 unless skill_level >= 65
        return 0 unless battle.pbSideSize(0) > 1
        
        partner = DoublesCoordination.find_partner(battle, attacker)
        return 0 unless partner
        
        # If partner has Telepathy, we can use spread moves freely
        if partner.ability_id == :TELEPATHY
          if DoublesCoordination.hits_partner?(move, attacker, partner)
            return 40  # Partner won't be hit
          end
        end
        
        0
      end
      
      # Neutralizing Gas awareness
      def self.check_neutralizing_gas(battle, attacker, skill_level = 100)
        return 0 unless skill_level >= 75
        
        # Check if anyone has Neutralizing Gas active
        all_battlers = battle.allBattlers
        if all_battlers.any? { |b| b && !b.fainted? && b.ability_id == :NEUTRALIZINGGAS }
          # All abilities are nullified - ignore ability-based strategies
          return 20  # Simplifies calculations
        end
        
        0
      end
      
      # Skill Swap / Entrainment / Role Play strategies
      def self.evaluate_ability_manipulation(battle, attacker, move, target, skill_level = 100)
        return 0 unless skill_level >= 80
        return 0 unless [:SKILLSWAP, :ENTRAINMENT, :ROLEPLAY, :GASTROACID].include?(move.id)
        return 0 unless target
        
        score = 0
        
        case move.id
        when :SKILLSWAP
          # Good abilities to steal
          good_abilities = [:HUGEPOWER, :PUREPOWER, :SPEEDBOOST, :INTIMIDATE,
                           :MULTISCALE, :MAGICGUARD, :LEVITATE, :PRANKSTER]
          if good_abilities.include?(target.ability_id)
            score += 50
          end
          
          # Bad abilities to give away
          bad_abilities = [:SLOWSTART, :TRUANT, :DEFEATIST, :STALL]
          if bad_abilities.include?(attacker.ability_id)
            score += 60  # Give them our bad ability
          end
          
        when :ENTRAINMENT
          # Give target our ability - good if we have something bad
          bad_for_them = [:TRUANT, :SLOWSTART, :DEFEATIST]
          if bad_for_them.include?(attacker.ability_id)
            score += 70
          end
          
        when :GASTROACID
          # Suppress target's ability
          strong_abilities = [:HUGEPOWER, :INTIMIDATE, :LEVITATE, :MULTISCALE,
                             :MAGICGUARD, :WONDERGUARD]
          if strong_abilities.include?(target.ability_id)
            score += 55
          end
        end
        
        score
      end
      
      # Slow Start awareness (Regigigas)
      def self.check_slow_start(battle, attacker, target, skill_level = 100)
        return 0 unless skill_level >= 65
        
        if target && target.ability_id == :SLOWSTART
          # Target is weakened for 5 turns
          return 25  # Take advantage
        end
        
        if attacker.ability_id == :SLOWSTART
          # We're weakened - play defensively
          return -20
        end
        
        0
      end
      
      #=========================================================================
      # Ally-Boosting Abilities (Power Spot, Battery, Steely Spirit, Flower Gift)
      #=========================================================================
      
      # Power Spot (Stonjourner) - +30% move power to allies
      def self.check_power_spot(battle, attacker, move, skill_level = 100)
        return 0 unless skill_level >= 70
        return 0 unless battle.pbSideSize(0) > 1
        return 0 unless move && move.damagingMove?
        
        partner = DoublesCoordination.find_partner(battle, attacker)
        return 0 unless partner && !partner.fainted?
        
        if partner.ability_id == :POWERSPOT
          # Our moves deal 30% more damage!
          return 25
        end
        
        0
      end
      
      # Battery (Charjabug) - +30% special move power to allies
      def self.check_battery(battle, attacker, move, skill_level = 100)
        return 0 unless skill_level >= 70
        return 0 unless battle.pbSideSize(0) > 1
        return 0 unless move && move.specialMove?
        
        partner = DoublesCoordination.find_partner(battle, attacker)
        return 0 unless partner && !partner.fainted?
        
        if partner.ability_id == :BATTERY
          # Our special moves deal 30% more damage!
          return 25
        end
        
        0
      end
      
      # Steely Spirit - +50% Steel move power to allies
      def self.check_steely_spirit(battle, attacker, move, skill_level = 100)
        return 0 unless skill_level >= 70
        return 0 unless battle.pbSideSize(0) > 1
        return 0 unless move && move.damagingMove? && move.type == :STEEL
        
        partner = DoublesCoordination.find_partner(battle, attacker)
        return 0 unless partner && !partner.fainted?
        
        if partner.ability_id == :STEELYSPIRIT
          # Our Steel moves deal 50% more damage!
          return 40
        end
        
        # Also check if WE have Steely Spirit (partner's Steel moves are boosted)
        if attacker.ability_id == :STEELYSPIRIT
          # Partner benefits - consider this when protecting the ally
          return 10
        end
        
        0
      end
      
      # Flower Gift (Cherrim) - +50% Atk & SpDef in Sun
      def self.check_flower_gift(battle, attacker, move, skill_level = 100)
        return 0 unless skill_level >= 70
        return 0 unless battle.pbSideSize(0) > 1
        
        # Only active in Sun
        weather = battle.pbWeather
        return 0 unless [:Sun, :HarshSun].include?(weather)
        
        partner = DoublesCoordination.find_partner(battle, attacker)
        return 0 unless partner && !partner.fainted?
        
        score = 0
        
        # If partner has Flower Gift, we get boosted
        if partner.ability_id == :FLOWERGIFT
          if move && move.physicalMove?
            score += 35  # 50% Attack boost
          end
          # Also +50% SpDef for surviving special attacks
          score += 15
        end
        
        # If WE have Flower Gift, partner benefits
        if attacker.ability_id == :FLOWERGIFT
          # Consider protecting partner / setting sun
          score += 10
        end
        
        score
      end
      
      # Comprehensive ally-boost check
      def self.check_ally_boosting_abilities(battle, attacker, move, skill_level = 100)
        return 0 unless skill_level >= 70
        return 0 unless battle.pbSideSize(0) > 1
        
        score = 0
        score += check_power_spot(battle, attacker, move, skill_level)
        score += check_battery(battle, attacker, move, skill_level)
        score += check_steely_spirit(battle, attacker, move, skill_level)
        score += check_flower_gift(battle, attacker, move, skill_level)
        
        score
      end
    end
    
    #===========================================================================
    # VGC Meta Strategies (World Championship Tactics)
    #===========================================================================
    module VGCMetaStrategies
      # Perish Trap strategy
      def self.evaluate_perish_trap(battle, attacker, move, skill_level = 100)
        return 0 unless skill_level >= 80
        return 0 unless move.id == :PERISHSONG
        
        score = 0
        
        # Check if we have trapping moves/abilities
        partner = DoublesCoordination.find_partner(battle, attacker)
        trapping_moves = [:MEANLOOK, :BLOCK, :SPIDERWEB, :SPIRITSHACKLE]
        trapping_abilities = [:SHADOWTAG, :ARENATRAP, :MAGNETPULL]
        
        has_trapping = false
        if partner
          has_trapping = partner.moves.any? { |m| m && trapping_moves.include?(m.id) }
          has_trapping ||= trapping_abilities.include?(partner.ability_id)
        end
        has_trapping ||= attacker.moves.any? { |m| m && trapping_moves.include?(m.id) }
        has_trapping ||= trapping_abilities.include?(attacker.ability_id)
        
        if has_trapping
          score += 60
        else
          score -= 20  # Opponents can just switch out
        end
        
        # Check if we have more Pokemon in back
        own_party = battle.pbParty(attacker.index)
        fainted_own = own_party.count { |p| p && p.fainted? }
        
        opp_party = battle.pbParty(battle.allOtherSideBattlers(attacker.index).first&.index || 1)
        fainted_opp = opp_party.count { |p| p && p.fainted? }
        
        if fainted_own < fainted_opp
          score += 40  # We have more reserves
        end
        
        score
      end
      
      # Taunt evaluation for doubles
      def self.evaluate_taunt_doubles(battle, attacker, move, target, skill_level = 100)
        return 0 unless skill_level >= 70
        return 0 unless battle.pbSideSize(0) > 1
        return 0 unless move.id == :TAUNT
        return 0 unless target
        
        score = 0
        
        # Check target's status move count
        status_moves = target.moves.count { |m| m && m.category == 2 }
        
        if status_moves >= 3
          score += 60  # Target relies on status moves
        elsif status_moves >= 2
          score += 40
        elsif status_moves >= 1
          score += 20
        else
          score -= 30  # Pure attacker, Taunt does little
        end
        
        # High priority targets for Taunt
        priority_taunt = [:TRICKROOM, :TAILWIND, :PROTECT, :FOLLOWME, :RAGEPOWDER,
                         :SPORE, :WILLOWISP, :THUNDERWAVE]
        if target.moves.any? { |m| m && priority_taunt.include?(m.id) }
          score += 35
        end
        
        # Check for Mental Herb (blocks Taunt once)
        if target.item_id == :MENTALHERB
          score -= 25
        end
        
        # Prankster Taunt is especially good
        if attacker.ability_id == :PRANKSTER
          score += 25
        end
        
        score
      end
      
      # Encore evaluation for doubles
      def self.evaluate_encore_doubles(battle, attacker, move, target, skill_level = 100)
        return 0 unless skill_level >= 75
        return 0 unless move.id == :ENCORE
        return 0 unless target
        
        score = 0
        
        # Encore last used move
        if target.lastMoveUsed
          last_move = GameData::Move.try_get(target.lastMoveUsed)
          if last_move
            # Encore them into bad moves
            bad_to_encore = [:PROTECT, :DETECT, :SPLASH, :HELPINGHAND]
            if bad_to_encore.include?(target.lastMoveUsed)
              score += 70  # Locked into useless move
            end
            
            # Encore them into something we resist
            if last_move.damagingMove?
              type_mod = Effectiveness.calculate(last_move.type, attacker.types[0], attacker.types[1])
              if Effectiveness.not_very_effective?(type_mod)
                score += 40
              elsif Effectiveness.ineffective?(type_mod)
                score += 60
              end
            end
          end
        end
        
        score
      end
      
      # Imprison for doubles (block opponent's Protect/TR)
      def self.evaluate_imprison(battle, attacker, move, skill_level = 100)
        return 0 unless skill_level >= 80
        return 0 unless move.id == :IMPRISON
        
        score = 0
        
        # Check what moves we share with opponents
        opponents = battle.allOtherSideBattlers(attacker.index).select { |b| b && !b.fainted? }
        
        our_moves = attacker.moves.map { |m| m&.id }.compact
        
        # Key moves to block
        key_moves = [:PROTECT, :TRICKROOM, :TAILWIND, :FAKEOUT, :SPORE]
        
        opponents.each do |opp|
          opp.moves.each do |opp_move|
            next unless opp_move
            if our_moves.include?(opp_move.id) && key_moves.include?(opp_move.id)
              score += 30
            end
          end
        end
        
        score
      end
      
      # Soak strategy (make target Water-type)
      def self.evaluate_soak(battle, attacker, move, target, skill_level = 100)
        return 0 unless skill_level >= 75
        return 0 unless move.id == :SOAK
        return 0 unless target
        
        score = 0
        partner = DoublesCoordination.find_partner(battle, attacker)
        
        # Partner has Grass/Electric moves
        if partner
          grass_elec = partner.moves.any? do |m|
            m && m.damagingMove? && [:GRASS, :ELECTRIC].include?(m.type)
          end
          if grass_elec
            score += 50  # Make target weak to partner's moves
          end
        end
        
        # Remove their STAB/immunities
        if target.pbHasType?(:GROUND)
          score += 35  # Remove Ground immunity to Electric
        end
        if target.pbHasType?(:GHOST)
          score += 30  # Remove Ghost immunities
        end
        
        score
      end
      
      # Ally Switch mind games
      def self.evaluate_ally_switch_prediction(battle, attacker, move, skill_level = 100)
        return 0 unless skill_level >= 85
        return 0 unless move.id == :ALLYSWITCH
        return 0 unless battle.pbSideSize(0) > 1
        
        score = 0
        partner = DoublesCoordination.find_partner(battle, attacker)
        return 0 unless partner
        
        # Predict super effective attacks coming at partner
        opponents = battle.allOtherSideBattlers(attacker.index).select { |b| b && !b.fainted? }
        
        partner_in_danger = false
        we_resist = false
        
        opponents.each do |opp|
          opp.moves.each do |opp_move|
            next unless opp_move && opp_move.damagingMove?
            
            # Check if partner is weak
            partner_mod = Effectiveness.calculate(opp_move.type, partner.types[0], partner.types[1])
            our_mod = Effectiveness.calculate(opp_move.type, attacker.types[0], attacker.types[1])
            
            if Effectiveness.super_effective?(partner_mod)
              partner_in_danger = true
              if Effectiveness.not_very_effective?(our_mod) || Effectiveness.ineffective?(our_mod)
                we_resist = true
              end
            end
          end
        end
        
        if partner_in_danger && we_resist
          score += 55
        elsif partner_in_danger
          score += 25
        end
        
        # Mind games - Ally Switch becomes predictable if spammed
        # Add some randomness at high skill
        if skill_level >= 90 && rand(100) < 30
          score += 20  # Sometimes do it anyway
        end
        
        score
      end
      
      # Gravity strategy (enables Ground moves on Flying, boosts accuracy)
      def self.evaluate_gravity(battle, attacker, move, skill_level = 100)
        return 0 unless skill_level >= 75
        return 0 unless move.id == :GRAVITY
        
        score = 0
        
        allies = battle.allSameSideBattlers(attacker.index).select { |b| b && !b.fainted? }
        opponents = battle.allOtherSideBattlers(attacker.index).select { |b| b && !b.fainted? }
        
        # Check if allies have Ground moves
        ground_users = allies.count { |a| a.moves.any? { |m| m && m.type == :GROUND && m.damagingMove? } }
        
        # Check if opponents are Flying/Levitate
        flying_opponents = opponents.count do |o|
          o.pbHasType?(:FLYING) || o.ability_id == :LEVITATE || o.item_id == :AIRBALLOON
        end
        
        score += ground_users * 25
        score += flying_opponents * 30
        
        # Gravity boosts accuracy - good with low accuracy moves
        low_accuracy_moves = allies.count do |a|
          a.moves.any? { |m| m && m.damagingMove? && m.accuracy < 80 }
        end
        score += low_accuracy_moves * 15
        
        score
      end
      
      # Guard Split / Power Split
      def self.evaluate_stat_split(battle, attacker, move, target, skill_level = 100)
        return 0 unless skill_level >= 75
        return 0 unless [:GUARDSPLIT, :POWERSPLIT].include?(move.id)
        return 0 unless target
        
        score = 0
        
        case move.id
        when :GUARDSPLIT
          # Average defenses - good if we're frail and they're bulky
          our_def = attacker.defense + attacker.spdef
          their_def = target.defense + target.spdef
          
          if their_def > our_def * 1.5
            score += 45  # We gain bulk, they lose it
          end
          
        when :POWERSPLIT
          # Average offenses - good if we're weak and they're strong
          our_off = attacker.attack + attacker.spatk
          their_off = target.attack + target.spatk
          
          if their_off > our_off * 1.5
            score += 50  # Neuters their offense
          end
        end
        
        score
      end
    end
    
    #===========================================================================
    # Switch-In Awareness (What happens when Pokemon enters)
    #===========================================================================
    module SwitchInAwareness
      # Intimidate on switch
      def self.predict_intimidate_switch(battle, attacker, skill_level = 100)
        return 0 unless skill_level >= 70
        
        # Check opponent's back for Intimidate users
        # This is predictive - harder to implement without team preview
        # For now, check if current opponents have Intimidate
        opponents = battle.allOtherSideBattlers(attacker.index).select { |b| b && !b.fainted? }
        
        if opponents.any? { |o| o.ability_id == :INTIMIDATE }
          # Intimidate already active
          if attacker.stages[:ATTACK] < 0
            return -15  # We're already debuffed
          end
        end
        
        0
      end
      
      # Weather ability switch-in awareness
      def self.predict_weather_switch(battle, attacker, skill_level = 100)
        return 0 unless skill_level >= 70
        
        # Current weather might change on switch
        # Track if opponent has weather setters in back
        # For now, be aware of current weather abilities
        
        current_weather = battle.field.weather
        
        allies = battle.allSameSideBattlers(attacker.index).select { |b| b && !b.fainted? }
        
        # Check if our team benefits from current weather
        weather_synergy = {
          :Sun => [:CHLOROPHYLL, :SOLARPOWER, :FLOWERGIFT],
          :Rain => [:SWIFTSWIM, :RAINDISH, :DRYSKIN],
          :Sandstorm => [:SANDRUSH, :SANDFORCE],
          :Hail => [:SLUSHRUSH, :ICEBODY]
        }
        
        synergy_abilities = weather_synergy[current_weather] || []
        if allies.any? { |a| synergy_abilities.include?(a.ability_id) }
          return 25  # We benefit from current weather
        end
        
        0
      end
      
      # Terrain setter switch awareness
      def self.predict_terrain_switch(battle, attacker, skill_level = 100)
        return 0 unless skill_level >= 70
        
        terrain_setters = {
          :Electric => [:ELECTRICSURGE],
          :Grassy => [:GRASSYSURGE],
          :Psychic => [:PSYCHICSURGE],
          :Misty => [:MISTYSURGE]
        }
        
        current_terrain = battle.field.terrain
        
        allies = battle.allSameSideBattlers(attacker.index).select { |b| b && !b.fainted? }
        
        # Check if we set the current terrain
        our_setter = false
        terrain_setters.each do |terrain, abilities|
          if current_terrain == terrain
            if allies.any? { |a| abilities.include?(a.ability_id) }
              our_setter = true
              break
            end
          end
        end
        
        our_setter ? 20 : 0
      end
    end
    
    private
    
    def self.find_partner(battle, attacker)
      battle.allSameSideBattlers(attacker.index).find { |b| b && b != attacker && !b.fainted? }
    end

    # Peek at what move the partner has already registered this turn.
    # Returns the move ID symbol (e.g. :FOLLOWME, :HELPINGHAND) or nil.
    # In doubles, the AI picks moves sequentially — if the partner chose
    # first, its choice is already stored in battle.choices.
    def self.partner_planned_move_id(battle, partner)
      return nil unless partner
      begin
        choice = battle.choices[partner.index] rescue nil
        if choice && choice[0] == :UseMove && choice[2]
          return choice[2].id rescue nil
        end
      rescue
      end
      nil
    end

    # Returns true when the partner has registered a non-attacking move
    # this turn — Helping Hand, Follow Me, Rage Powder, Protect, etc.
    # Used to prevent "double support" turns that produce zero offense.
    REDIRECT_MOVE_IDS  = [:FOLLOWME, :RAGEPOWDER, :SPOTLIGHT]
    PROTECT_MOVE_IDS   = [:PROTECT, :DETECT, :KINGSSHIELD, :SPIKYSHIELD,
                          :BANEFULBUNKER, :OBSTRUCT, :SILKTRAP, :BURNINGBULWARK]
    SUPPORT_ONLY_MOVES = REDIRECT_MOVE_IDS + PROTECT_MOVE_IDS + [:HELPINGHAND]

    def self.partner_planned_support_only?(battle, partner)
      mid = partner_planned_move_id(battle, partner)
      return false unless mid
      SUPPORT_ONLY_MOVES.include?(mid)
    end
    
    def self.partner_targets?(battle, partner, target)
      return false unless partner && target
      # Check if partner's chosen action targets the same opponent
      # In Battle::AI, choices are stored in @battle.choices
      begin
        partner_choice = battle.choices[partner.index] rescue nil
        if partner_choice && partner_choice[0] == :UseMove
          partner_target_idx = partner_choice[3]  # Target index
          return partner_target_idx == target.index if partner_target_idx
        end
      rescue
        # Fall back to heuristic: does partner have moves that target this foe?
      end

      # Heuristic: if partner is a physical/special attacker and target is low HP,
      # assume they're likely targeting it
      if target.hp < target.totalhp * 0.35
        return true  # Low HP target is a likely shared target
      end

      false
    end
    
    def self.hits_partner?(move, attacker, partner)
      targets = move.pbTarget(attacker)
      # In v21.1, spread moves that hit partners include AllOtherPokemon, AllFoesAndAllies, etc.
      # We check if num_targets > 1 and it's NOT just hitting foes.
      return targets.num_targets > 1 && ![:AllNearFoes, :AllFoes, :RandomFoe].include?(targets.id)
    end
    
    def self.count_enemies_hit(battle, attacker, move)
      battle.allOtherSideBattlers(attacker.index).count { |b| b && !b.fainted? }
    end
  end
end

# API-Wrapper
module AdvancedAI
  def self.prevent_overkill(battle, attacker, target, skill_level = 100)
    DoublesCoordination.prevent_overkill(battle, attacker, target, skill_level)
  end
  
  def self.prevent_move_conflicts(battle, attacker, move, skill_level = 100)
    DoublesCoordination.prevent_move_conflicts(battle, attacker, move, skill_level)
  end
  
  def self.optimize_spread_moves(battle, attacker, move, skill_level = 100)
    DoublesCoordination.optimize_spread_moves(battle, attacker, move, skill_level)
  end
  
  def self.coordinate_field_effects(battle, attacker, move, skill_level = 100)
    DoublesCoordination.coordinate_field_effects(battle, attacker, move, skill_level)
  end
  
  def self.protect_setup_combo(battle, attacker, move, skill_level = 100)
    DoublesCoordination.protect_setup_combo(battle, attacker, move, skill_level)
  end
  
  # New Doubles APIs
  def self.evaluate_wide_guard(battle, attacker, move, skill_level = 100)
    DoublesCoordination::ProtectiveMovesDoubles.evaluate_wide_guard(battle, attacker, move, skill_level)
  end
  
  def self.evaluate_quick_guard(battle, attacker, move, skill_level = 100)
    DoublesCoordination::ProtectiveMovesDoubles.evaluate_quick_guard(battle, attacker, move, skill_level)
  end
  
  def self.evaluate_follow_me(battle, attacker, move, skill_level = 100)
    DoublesCoordination::RedirectionStrategies.evaluate_follow_me(battle, attacker, move, skill_level)
  end
  
  def self.evaluate_rage_powder(battle, attacker, move, skill_level = 100)
    DoublesCoordination::RedirectionStrategies.evaluate_rage_powder(battle, attacker, move, skill_level)
  end
  
  def self.evaluate_fake_out(battle, attacker, move, target, skill_level = 100)
    DoublesCoordination.evaluate_fake_out(battle, attacker, move, target, skill_level)
  end
  
  def self.evaluate_protect_doubles(battle, attacker, move, skill_level = 100)
    DoublesCoordination.evaluate_protect_doubles(battle, attacker, move, skill_level)
  end
  
  def self.evaluate_tailwind(battle, attacker, move, skill_level = 100)
    DoublesCoordination::SpeedControlDoubles.evaluate_tailwind(battle, attacker, move, skill_level)
  end
  
  def self.evaluate_trick_room(battle, attacker, move, skill_level = 100)
    DoublesCoordination::SpeedControlDoubles.evaluate_trick_room(battle, attacker, move, skill_level)
  end
  
  def self.evaluate_speed_control_attack(battle, attacker, move, skill_level = 100)
    DoublesCoordination::SpeedControlDoubles.evaluate_speed_control_attack(battle, attacker, move, skill_level)
  end
  
  def self.evaluate_weather_move_doubles(battle, attacker, move, skill_level = 100)
    DoublesCoordination::WeatherCoordinationDoubles.evaluate_weather_move(battle, attacker, move, skill_level)
  end
  
  def self.evaluate_weather_boosted_move(battle, attacker, move, skill_level = 100)
    DoublesCoordination::WeatherCoordinationDoubles.evaluate_weather_boosted_move(battle, attacker, move, skill_level)
  end
  
  def self.evaluate_helping_hand(battle, attacker, move, skill_level = 100)
    DoublesCoordination::AllySynergyDoubles.evaluate_helping_hand(battle, attacker, move, skill_level)
  end
  
  def self.evaluate_coaching(battle, attacker, move, skill_level = 100)
    DoublesCoordination::AllySynergyDoubles.evaluate_coaching(battle, attacker, move, skill_level)
  end
  
  def self.evaluate_ally_heal(battle, attacker, move, skill_level = 100)
    DoublesCoordination::AllySynergyDoubles.evaluate_ally_heal(battle, attacker, move, skill_level)
  end
  
  def self.evaluate_ally_switch(battle, attacker, move, skill_level = 100)
    DoublesCoordination::AllySynergyDoubles.evaluate_ally_switch(battle, attacker, move, skill_level)
  end
  
  def self.check_combo_potential(battle, attacker, move)
    DoublesCoordination::ComboCoordinationDoubles.check_combo_potential(battle, attacker, move)
  end
  
  def self.evaluate_setup_for_partner(battle, attacker, move, skill_level = 100)
    DoublesCoordination::ComboCoordinationDoubles.evaluate_setup_for_partner(battle, attacker, move, skill_level)
  end
  
  # Turn Order Manipulation APIs
  def self.evaluate_after_you(battle, attacker, move, skill_level = 100)
    DoublesCoordination::TurnOrderDoubles.evaluate_after_you(battle, attacker, move, skill_level)
  end
  
  def self.evaluate_quash(battle, attacker, move, target, skill_level = 100)
    DoublesCoordination::TurnOrderDoubles.evaluate_quash(battle, attacker, move, target, skill_level)
  end
  
  def self.evaluate_instruct(battle, attacker, move, skill_level = 100)
    DoublesCoordination::TurnOrderDoubles.evaluate_instruct(battle, attacker, move, skill_level)
  end
  
  # Additional Protection APIs
  def self.evaluate_mat_block(battle, attacker, move, skill_level = 100)
    DoublesCoordination::AdditionalProtectionDoubles.evaluate_mat_block(battle, attacker, move, skill_level)
  end
  
  def self.evaluate_crafty_shield(battle, attacker, move, skill_level = 100)
    DoublesCoordination::AdditionalProtectionDoubles.evaluate_crafty_shield(battle, attacker, move, skill_level)
  end
  
  def self.evaluate_spotlight(battle, attacker, move, target, skill_level = 100)
    DoublesCoordination::AdditionalProtectionDoubles.evaluate_spotlight(battle, attacker, move, target, skill_level)
  end
  
  # Gen 9 APIs
  def self.evaluate_revival_blessing(battle, attacker, move, skill_level = 100)
    DoublesCoordination::Gen9DoublesStrategies.evaluate_revival_blessing(battle, attacker, move, skill_level)
  end
  
  def self.evaluate_shed_tail(battle, attacker, move, skill_level = 100)
    DoublesCoordination::Gen9DoublesStrategies.evaluate_shed_tail(battle, attacker, move, skill_level)
  end
  
  def self.evaluate_doodle(battle, attacker, move, target, skill_level = 100)
    DoublesCoordination::Gen9DoublesStrategies.evaluate_doodle(battle, attacker, move, target, skill_level)
  end
  
  def self.check_commander_combo(battle, attacker)
    DoublesCoordination::Gen9DoublesStrategies.check_commander_combo(battle, attacker)
  end
  
  def self.evaluate_tidy_up(battle, attacker, move, skill_level = 100)
    DoublesCoordination::Gen9DoublesStrategies.evaluate_tidy_up(battle, attacker, move, skill_level)
  end
  
  def self.evaluate_psychic_terrain_doubles(battle, attacker, move, skill_level = 100)
    DoublesCoordination::Gen9DoublesStrategies.evaluate_psychic_terrain_doubles(battle, attacker, move, skill_level)
  end
  
  def self.check_ability_synergy(battle, attacker, move)
    DoublesCoordination::Gen9DoublesStrategies.check_ability_synergy(battle, attacker, move)
  end
  
  # Terrain APIs
  def self.evaluate_terrain_doubles(battle, attacker, move, skill_level = 100)
    DoublesCoordination::TerrainSynergyDoubles.evaluate_terrain_doubles(battle, attacker, move, skill_level)
  end
  
  # Gen 8 Dynamax APIs
  def self.evaluate_max_guard(battle, attacker, move, skill_level = 100)
    DoublesCoordination::DynamaxDoublesStrategies.evaluate_max_guard(battle, attacker, move, skill_level)
  end
  
  def self.evaluate_max_team_move(battle, attacker, move, skill_level = 100)
    DoublesCoordination::DynamaxDoublesStrategies.evaluate_max_team_move(battle, attacker, move, skill_level)
  end
  
  def self.evaluate_max_weather_move(battle, attacker, move, skill_level = 100)
    DoublesCoordination::DynamaxDoublesStrategies.evaluate_max_weather_move(battle, attacker, move, skill_level)
  end
  
  def self.evaluate_max_terrain_move(battle, attacker, move, skill_level = 100)
    DoublesCoordination::DynamaxDoublesStrategies.evaluate_max_terrain_move(battle, attacker, move, skill_level)
  end
  
  def self.evaluate_dynamax_timing(battle, attacker, skill_level = 100)
    DoublesCoordination::DynamaxDoublesStrategies.evaluate_dynamax_timing(battle, attacker, skill_level)
  end
  
  def self.evaluate_gmax_move(battle, attacker, move, skill_level = 100)
    DoublesCoordination::DynamaxDoublesStrategies.evaluate_gmax_move(battle, attacker, move, skill_level)
  end
  
  # Gen 9 Extended APIs
  def self.evaluate_tera_timing_doubles(battle, attacker, skill_level = 100)
    DoublesCoordination::Gen9ExtendedStrategies.evaluate_tera_timing_doubles(battle, attacker, skill_level)
  end
  
  def self.evaluate_paradox_moves(battle, attacker, move, target, skill_level = 100)
    DoublesCoordination::Gen9ExtendedStrategies.evaluate_paradox_moves(battle, attacker, move, target, skill_level)
  end
  
  def self.evaluate_terrain_removal(battle, attacker, move, skill_level = 100)
    DoublesCoordination::Gen9ExtendedStrategies.evaluate_terrain_removal(battle, attacker, move, skill_level)
  end
  
  def self.evaluate_court_change(battle, attacker, move, skill_level = 100)
    DoublesCoordination::Gen9ExtendedStrategies.evaluate_court_change(battle, attacker, move, skill_level)
  end
  
  def self.evaluate_mortal_spin(battle, attacker, move, skill_level = 100)
    DoublesCoordination::Gen9ExtendedStrategies.evaluate_mortal_spin(battle, attacker, move, skill_level)
  end
  
  def self.evaluate_make_it_rain(battle, attacker, move, skill_level = 100)
    DoublesCoordination::Gen9ExtendedStrategies.evaluate_make_it_rain(battle, attacker, move, skill_level)
  end
  
  def self.evaluate_triple_arrows(battle, attacker, move, target, skill_level = 100)
    DoublesCoordination::Gen9ExtendedStrategies.evaluate_triple_arrows(battle, attacker, move, target, skill_level)
  end
  
  def self.evaluate_stat_lowering_attacks(battle, attacker, move, target, skill_level = 100)
    DoublesCoordination::Gen9ExtendedStrategies.evaluate_stat_lowering_attacks(battle, attacker, move, target, skill_level)
  end
  
  def self.evaluate_order_up(battle, attacker, move, skill_level = 100)
    DoublesCoordination::Gen9ExtendedStrategies.evaluate_order_up(battle, attacker, move, skill_level)
  end
  
  def self.evaluate_salt_cure(battle, attacker, move, target, skill_level = 100)
    DoublesCoordination::Gen9ExtendedStrategies.evaluate_salt_cure(battle, attacker, move, target, skill_level)
  end
  
  def self.evaluate_rage_fist(battle, attacker, move, skill_level = 100)
    DoublesCoordination::Gen9ExtendedStrategies.evaluate_rage_fist(battle, attacker, move, skill_level)
  end
  
  # Item Awareness APIs (VGC Meta Items)
  def self.check_focus_sash(battle, attacker, target, move, skill_level = 100)
    DoublesCoordination::ItemAwarenessDoubles.check_focus_sash(battle, attacker, target, move, skill_level)
  end
  
  def self.evaluate_weakness_policy_abuse(battle, attacker, move, skill_level = 100)
    DoublesCoordination::ItemAwarenessDoubles.evaluate_weakness_policy_abuse(battle, attacker, move, skill_level)
  end
  
  def self.check_safety_goggles(battle, attacker, target, move, skill_level = 100)
    DoublesCoordination::ItemAwarenessDoubles.check_safety_goggles(battle, attacker, target, move, skill_level)
  end
  
  def self.check_assault_vest_target(battle, target, skill_level = 100)
    DoublesCoordination::ItemAwarenessDoubles.check_assault_vest_target(battle, target, skill_level)
  end
  
  def self.check_choice_item(battle, attacker, target, skill_level = 100)
    DoublesCoordination::ItemAwarenessDoubles.check_choice_item(battle, attacker, target, skill_level)
  end
  
  def self.check_ejection_items(battle, target, skill_level = 100)
    DoublesCoordination::ItemAwarenessDoubles.check_ejection_items(battle, target, skill_level)
  end
  
  def self.check_air_balloon(battle, target, move, skill_level = 100)
    DoublesCoordination::ItemAwarenessDoubles.check_air_balloon(battle, target, move, skill_level)
  end
  
  def self.check_stat_trigger_items(battle, attacker, partner, skill_level = 100)
    DoublesCoordination::ItemAwarenessDoubles.check_stat_trigger_items(battle, attacker, partner, skill_level)
  end
  
  def self.check_healing_berries(battle, target, skill_level = 100)
    DoublesCoordination::ItemAwarenessDoubles.check_healing_berries(battle, target, skill_level)
  end
  
  # Ability Synergy APIs
  def self.check_intimidate(battle, attacker, skill_level = 100)
    DoublesCoordination::AbilitySynergyDoubles.check_intimidate(battle, attacker, skill_level)
  end
  
  def self.check_prankster(battle, attacker, move, target, skill_level = 100)
    DoublesCoordination::AbilitySynergyDoubles.check_prankster(battle, attacker, move, target, skill_level)
  end
  
  def self.check_flinch_immunity(battle, target, move, skill_level = 100)
    DoublesCoordination::AbilitySynergyDoubles.check_flinch_immunity(battle, target, move, skill_level)
  end
  
  def self.check_friend_guard(battle, attacker, target, skill_level = 100)
    DoublesCoordination::AbilitySynergyDoubles.check_friend_guard(battle, attacker, target, skill_level)
  end
  
  def self.check_telepathy(battle, attacker, move, skill_level = 100)
    DoublesCoordination::AbilitySynergyDoubles.check_telepathy(battle, attacker, move, skill_level)
  end
  
  def self.check_neutralizing_gas(battle, attacker, skill_level = 100)
    DoublesCoordination::AbilitySynergyDoubles.check_neutralizing_gas(battle, attacker, skill_level)
  end
  
  def self.evaluate_ability_manipulation(battle, attacker, move, target, skill_level = 100)
    DoublesCoordination::AbilitySynergyDoubles.evaluate_ability_manipulation(battle, attacker, move, target, skill_level)
  end
  
  def self.check_slow_start(battle, attacker, target, skill_level = 100)
    DoublesCoordination::AbilitySynergyDoubles.check_slow_start(battle, attacker, target, skill_level)
  end
  
  def self.check_ally_boosting_abilities(battle, attacker, move, skill_level = 100)
    DoublesCoordination::AbilitySynergyDoubles.check_ally_boosting_abilities(battle, attacker, move, skill_level)
  end
  
  def self.check_power_spot(battle, attacker, move, skill_level = 100)
    DoublesCoordination::AbilitySynergyDoubles.check_power_spot(battle, attacker, move, skill_level)
  end
  
  def self.check_battery(battle, attacker, move, skill_level = 100)
    DoublesCoordination::AbilitySynergyDoubles.check_battery(battle, attacker, move, skill_level)
  end
  
  def self.check_steely_spirit(battle, attacker, move, skill_level = 100)
    DoublesCoordination::AbilitySynergyDoubles.check_steely_spirit(battle, attacker, move, skill_level)
  end
  
  def self.check_flower_gift(battle, attacker, move, skill_level = 100)
    DoublesCoordination::AbilitySynergyDoubles.check_flower_gift(battle, attacker, move, skill_level)
  end
  
  # VGC Meta Strategies APIs
  def self.evaluate_perish_trap(battle, attacker, move, skill_level = 100)
    DoublesCoordination::VGCMetaStrategies.evaluate_perish_trap(battle, attacker, move, skill_level)
  end
  
  def self.evaluate_taunt_doubles(battle, attacker, move, target, skill_level = 100)
    DoublesCoordination::VGCMetaStrategies.evaluate_taunt_doubles(battle, attacker, move, target, skill_level)
  end
  
  def self.evaluate_encore_doubles(battle, attacker, move, target, skill_level = 100)
    DoublesCoordination::VGCMetaStrategies.evaluate_encore_doubles(battle, attacker, move, target, skill_level)
  end
  
  def self.evaluate_imprison(battle, attacker, move, skill_level = 100)
    DoublesCoordination::VGCMetaStrategies.evaluate_imprison(battle, attacker, move, skill_level)
  end
  
  def self.evaluate_soak(battle, attacker, move, target, skill_level = 100)
    DoublesCoordination::VGCMetaStrategies.evaluate_soak(battle, attacker, move, target, skill_level)
  end
  
  def self.evaluate_ally_switch_prediction(battle, attacker, move, skill_level = 100)
    DoublesCoordination::VGCMetaStrategies.evaluate_ally_switch_prediction(battle, attacker, move, skill_level)
  end
  
  def self.evaluate_gravity(battle, attacker, move, skill_level = 100)
    DoublesCoordination::VGCMetaStrategies.evaluate_gravity(battle, attacker, move, skill_level)
  end
  
  def self.evaluate_stat_split(battle, attacker, move, target, skill_level = 100)
    DoublesCoordination::VGCMetaStrategies.evaluate_stat_split(battle, attacker, move, target, skill_level)
  end
  
  # Switch-In Awareness APIs
  def self.predict_intimidate_switch(battle, attacker, skill_level = 100)
    DoublesCoordination::SwitchInAwareness.predict_intimidate_switch(battle, attacker, skill_level)
  end
  
  def self.predict_weather_switch(battle, attacker, skill_level = 100)
    DoublesCoordination::SwitchInAwareness.predict_weather_switch(battle, attacker, skill_level)
  end
  
  def self.predict_terrain_switch(battle, attacker, skill_level = 100)
    DoublesCoordination::SwitchInAwareness.predict_terrain_switch(battle, attacker, skill_level)
  end
end

# Integration in Battle::AI
class Battle::AI
  def apply_doubles_coordination(score, move, user, target, skill = 100)
    return score unless @battle.pbSideSize(0) > 1
    return score unless AdvancedAI.feature_enabled?(:core, skill)
    
    # Original coordination
    score += AdvancedAI.prevent_overkill(@battle, user, target, skill) if target
    score += AdvancedAI.prevent_move_conflicts(@battle, user, move, skill)
    score += AdvancedAI.optimize_spread_moves(@battle, user, move, skill)
    score += AdvancedAI.coordinate_field_effects(@battle, user, move, skill)
    score += AdvancedAI.protect_setup_combo(@battle, user, move, skill)
    
    # Protective moves (Wide Guard, Quick Guard)
    score += AdvancedAI.evaluate_wide_guard(@battle, user, move, skill)
    score += AdvancedAI.evaluate_quick_guard(@battle, user, move, skill)
    
    # Redirection (Follow Me, Rage Powder)
    score += AdvancedAI.evaluate_follow_me(@battle, user, move, skill)
    score += AdvancedAI.evaluate_rage_powder(@battle, user, move, skill)
    
    # Fake Out & Protect
    score += AdvancedAI.evaluate_fake_out(@battle, user, move, target, skill) if target
    score += AdvancedAI.evaluate_protect_doubles(@battle, user, move, skill)
    
    # Speed Control (Tailwind, Trick Room, Icy Wind)
    score += AdvancedAI.evaluate_tailwind(@battle, user, move, skill)
    score += AdvancedAI.evaluate_trick_room(@battle, user, move, skill)
    score += AdvancedAI.evaluate_speed_control_attack(@battle, user, move, skill)
    
    # Weather Coordination
    score += AdvancedAI.evaluate_weather_move_doubles(@battle, user, move, skill)
    score += AdvancedAI.evaluate_weather_boosted_move(@battle, user, move, skill)
    
    # Ally Synergy (Helping Hand, Coaching, Heals)
    score += AdvancedAI.evaluate_helping_hand(@battle, user, move, skill)
    score += AdvancedAI.evaluate_coaching(@battle, user, move, skill)
    score += AdvancedAI.evaluate_ally_heal(@battle, user, move, skill)
    score += AdvancedAI.evaluate_ally_switch(@battle, user, move, skill)
    
    # Combo Detection
    score += AdvancedAI.check_combo_potential(@battle, user, move)
    score += AdvancedAI.evaluate_setup_for_partner(@battle, user, move, skill)
    
    # Turn Order Manipulation (After You, Quash, Instruct)
    score += AdvancedAI.evaluate_after_you(@battle, user, move, skill)
    score += AdvancedAI.evaluate_quash(@battle, user, move, target, skill) if target
    score += AdvancedAI.evaluate_instruct(@battle, user, move, skill)
    
    # Additional Protection (Mat Block, Crafty Shield, Spotlight)
    score += AdvancedAI.evaluate_mat_block(@battle, user, move, skill)
    score += AdvancedAI.evaluate_crafty_shield(@battle, user, move, skill)
    score += AdvancedAI.evaluate_spotlight(@battle, user, move, target, skill) if target
    
    # Gen 8 Dynamax Strategies
    score += AdvancedAI.evaluate_max_guard(@battle, user, move, skill)
    score += AdvancedAI.evaluate_max_team_move(@battle, user, move, skill)
    score += AdvancedAI.evaluate_max_weather_move(@battle, user, move, skill)
    score += AdvancedAI.evaluate_max_terrain_move(@battle, user, move, skill)
    score += AdvancedAI.evaluate_gmax_move(@battle, user, move, skill)
    
    # Gen 9 Strategies
    score += AdvancedAI.evaluate_revival_blessing(@battle, user, move, skill)
    score += AdvancedAI.evaluate_shed_tail(@battle, user, move, skill)
    score += AdvancedAI.evaluate_doodle(@battle, user, move, target, skill) if target
    score += AdvancedAI.check_commander_combo(@battle, user)
    score += AdvancedAI.evaluate_tidy_up(@battle, user, move, skill)
    score += AdvancedAI.evaluate_psychic_terrain_doubles(@battle, user, move, skill)
    score += AdvancedAI.check_ability_synergy(@battle, user, move)
    
    # Gen 9 Extended Strategies
    score += AdvancedAI.evaluate_paradox_moves(@battle, user, move, target, skill) if target
    score += AdvancedAI.evaluate_terrain_removal(@battle, user, move, skill)
    score += AdvancedAI.evaluate_court_change(@battle, user, move, skill)
    score += AdvancedAI.evaluate_mortal_spin(@battle, user, move, skill)
    score += AdvancedAI.evaluate_make_it_rain(@battle, user, move, skill)
    score += AdvancedAI.evaluate_triple_arrows(@battle, user, move, target, skill) if target
    score += AdvancedAI.evaluate_stat_lowering_attacks(@battle, user, move, target, skill) if target
    score += AdvancedAI.evaluate_order_up(@battle, user, move, skill)
    score += AdvancedAI.evaluate_salt_cure(@battle, user, move, target, skill) if target
    score += AdvancedAI.evaluate_rage_fist(@battle, user, move, skill)
    
    # Terrain Synergy
    score += AdvancedAI.evaluate_terrain_doubles(@battle, user, move, skill)
    
    # Item Awareness (VGC Meta Items)
    if target
      score += AdvancedAI.check_focus_sash(@battle, user, target, move, skill)
      score += AdvancedAI.check_safety_goggles(@battle, user, target, move, skill)
      score += AdvancedAI.check_assault_vest_target(@battle, target, skill)
      score += AdvancedAI.check_choice_item(@battle, user, target, skill)
      score += AdvancedAI.check_ejection_items(@battle, target, skill)
      score += AdvancedAI.check_air_balloon(@battle, target, move, skill)
      score += AdvancedAI.check_healing_berries(@battle, target, skill)
    end
    score += AdvancedAI.evaluate_weakness_policy_abuse(@battle, user, move, skill)
    partner = @battle.allSameSideBattlers(user.index).find { |b| b && b != user && !b.fainted? }
    score += AdvancedAI.check_stat_trigger_items(@battle, user, partner, skill) if partner
    
    # Ability Synergy
    score += AdvancedAI.check_intimidate(@battle, user, skill)
    score += AdvancedAI.check_prankster(@battle, user, move, target, skill) if target
    score += AdvancedAI.check_flinch_immunity(@battle, target, move, skill) if target
    score += AdvancedAI.check_friend_guard(@battle, user, target, skill) if target
    score += AdvancedAI.check_telepathy(@battle, user, move, skill)
    score += AdvancedAI.check_neutralizing_gas(@battle, user, skill)
    score += AdvancedAI.evaluate_ability_manipulation(@battle, user, move, target, skill) if target
    score += AdvancedAI.check_slow_start(@battle, user, target, skill) if target
    
    # Ally-Boosting Abilities (Power Spot, Battery, Steely Spirit, Flower Gift)
    score += AdvancedAI.check_ally_boosting_abilities(@battle, user, move, skill)
    
    # VGC Meta Strategies
    score += AdvancedAI.evaluate_perish_trap(@battle, user, move, skill)
    score += AdvancedAI.evaluate_taunt_doubles(@battle, user, move, target, skill) if target
    score += AdvancedAI.evaluate_encore_doubles(@battle, user, move, target, skill) if target
    score += AdvancedAI.evaluate_imprison(@battle, user, move, skill)
    score += AdvancedAI.evaluate_soak(@battle, user, move, target, skill) if target
    score += AdvancedAI.evaluate_ally_switch_prediction(@battle, user, move, skill)
    score += AdvancedAI.evaluate_gravity(@battle, user, move, skill)
    score += AdvancedAI.evaluate_stat_split(@battle, user, move, target, skill) if target
    
    # Switch-In Awareness
    score += AdvancedAI.predict_intimidate_switch(@battle, user, skill)
    score += AdvancedAI.predict_weather_switch(@battle, user, skill)
    score += AdvancedAI.predict_terrain_switch(@battle, user, skill)
    
    # #19: Joint Target Selection
    if target
      real_user = user.respond_to?(:battler) ? user.battler : user
      real_target = target.respond_to?(:battler) ? target.battler : target
      score += DoublesCoordination.joint_target_bonus(@battle, real_user, move, real_target, skill) rescue 0
    end
    
    return score
  end
end

#===============================================================================
# #19: Joint Target Selection — optimize who attacks what in doubles
#===============================================================================
module AdvancedAI
  module DoublesCoordination
    # Returns a bonus/penalty for attacking a specific target in doubles
    # Considers partner's likely action to avoid overkill and optimize KOs
    def self.joint_target_bonus(battle, attacker, move, target, skill_level = 100)
      return 0 unless skill_level >= 60
      return 0 unless battle.pbSideSize(0) > 1
      return 0 unless target && move

      partner = find_partner(battle, attacker)
      return 0 unless partner

      bonus = 0
      enemies = battle.allOtherSideBattlers(attacker.index).select { |b| b && !b.fainted? }
      return 0 if enemies.length < 2  # Only one target anyway

      # Estimate our damage to this target
      our_damage = CombatUtilities.estimate_damage(attacker, move, target, as_percent: true) rescue 0

      # Check if partner is likely targeting the same foe
      partner_on_same = partner_targets?(battle, partner, target)

      if partner_on_same && our_damage >= target.hp.to_f / target.totalhp
        # We can KO alone — partner should attack the other target
        # Slight penalty to encourage partner to spread attacks
        bonus -= 10
      end

      if partner_on_same && our_damage < 0.5
        # Neither of us can KO this target → might be better to focus the other one
        other_targets = enemies.reject { |e| e == target }
        other_targets.each do |other|
          other_hp_pct = other.hp.to_f / other.totalhp
          if other_hp_pct < 0.4
            bonus -= 15  # Other target is low, pick them off instead
            break
          end
        end
      end

      # If we have type advantage on this target but partner doesn't, focus here
      if move.damagingMove?
        target_types = target.respond_to?(:pbTypes) ? target.pbTypes : [:NORMAL]
        eff = 1.0
        target_types.each { |t| eff *= Effectiveness.calculate_one(move.type, t) rescue 1.0 }
        if eff > 1.0
          bonus += 10  # We have SE on this target
        end
      end

      bonus
    end
  end
end

AdvancedAI.log("Doubles Coordination System loaded", "Doubles")
AdvancedAI.log("  - Wide Guard & Quick Guard strategies", "Doubles")
AdvancedAI.log("  - Follow Me / Rage Powder redirection", "Doubles")
AdvancedAI.log("  - Fake Out & Protect coordination", "Doubles")
AdvancedAI.log("  - Tailwind & Trick Room speed control", "Doubles")
AdvancedAI.log("  - Enhanced weather coordination", "Doubles")
AdvancedAI.log("  - Ally synergy moves (Helping Hand, Coaching)", "Doubles")
AdvancedAI.log("  - Combo detection (Beat Up + Justified, etc.)", "Doubles")
AdvancedAI.log("  - Turn order manipulation (After You, Quash, Instruct)", "Doubles")
AdvancedAI.log("  - Additional protection (Mat Block, Crafty Shield)", "Doubles")
AdvancedAI.log("  - Gen 8 Dynamax coordination (Max Airstream, G-Max moves)", "Doubles")
AdvancedAI.log("  - Gen 9 strategies (Revival Blessing, Shed Tail, Doodle)", "Doubles")
AdvancedAI.log("  - Commander combo (Tatsugiri + Dondozo)", "Doubles")
AdvancedAI.log("  - Gen 9 extended (Salt Cure, Rage Fist, Court Change)", "Doubles")
AdvancedAI.log("  - Terastallization & Paradox Pokemon moves", "Doubles")
AdvancedAI.log("  - Terrain synergy (Rising Voltage, Expanding Force, etc.)", "Doubles")
AdvancedAI.log("  - Item awareness (Focus Sash, Weakness Policy, Choice items)", "Doubles")
AdvancedAI.log("  - Ability synergy (Intimidate, Prankster, Telepathy)", "Doubles")
AdvancedAI.log("  - Ally-boosting abilities (Power Spot, Battery, Steely Spirit, Flower Gift)", "Doubles")
AdvancedAI.log("  - VGC Meta strategies (Perish Trap, Taunt, Encore, Imprison)", "Doubles")
AdvancedAI.log("  - Switch-In awareness (Intimidate, Weather, Terrain)", "Doubles")
AdvancedAI.log("  - Spread move 75% damage reduction awareness", "Doubles")
AdvancedAI.log("  - #8 Intimidate cycling switch bonus", "Doubles")
AdvancedAI.log("  - #20 Ally Switch awareness + TR setter coordination", "Doubles")

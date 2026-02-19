#===============================================================================
# Advanced AI System - Tactical Enhancements
# Features #1-21: Ability/Item/Move strategies, multi-turn planning, doubles
#===============================================================================

module AdvancedAI
  module TacticalEnhancements

    #===========================================================================
    # #1 MAGIC BOUNCE IN-BATTLE PENALTY
    # Status/hazard moves bounce back — never use them vs Magic Bounce
    #===========================================================================
    MAGIC_BOUNCE_ABILITIES = [:MAGICBOUNCE]
    MAGIC_BOUNCE_BLOCKED = [
      # Hazards
      :STEALTHROCK, :SPIKES, :TOXICSPIKES, :STICKYWEB,
      # Status
      :THUNDERWAVE, :WILLOWISP, :TOXIC, :POISONPOWDER, :STUNSPORE,
      :SLEEPPOWDER, :SPORE, :HYPNOSIS, :DARKVOID, :GLARE, :YAWN,
      :SING, :GRASSWHISTLE, :LOVELYKISS, :POISONGAS,
      # Stat drops / disruption
      :TAUNT, :ENCORE, :TORMENT, :DISABLE,
      # Entry disruption
      :ROAR, :WHIRLWIND,
      # Screens-debuff
      :DEFOG,  # Defog also raises target evasion — it's reflected
      # Other
      :LEECHSEED, :EMBARGO, :HEALBLOCK,
    ]

    def self.magic_bounce_penalty(target, move)
      return 0 unless target && move
      target_ability = target.respond_to?(:ability_id) ? target.ability_id : nil
      return 0 unless MAGIC_BOUNCE_ABILITIES.include?(target_ability)
      return 0 unless move.statusMove? || MAGIC_BOUNCE_BLOCKED.include?(move.id)
      # Only penalize status/entry moves that bounce back
      if MAGIC_BOUNCE_BLOCKED.include?(move.id)
        AdvancedAI.log("#{move.name} blocked by Magic Bounce on #{target.name}", "Ability")
        return -500  # Effectively blocked — bounces back to us!
      end
      0
    end

    #===========================================================================
    # #2 MOLD BREAKER FAMILY — bypass target abilities in damage calc
    # Mold Breaker/Teravolt/Turboblaze ignore Levitate, Sturdy, Multiscale etc.
    #===========================================================================
    MOLD_BREAKER_ABILITIES = [:MOLDBREAKER, :TERAVOLT, :TURBOBLAZE, :MYCELIUMMIGHT]

    # Bonus when user has Mold Breaker and target has a defensive ability
    BYPASSED_ABILITIES = [:LEVITATE, :STURDY, :MULTISCALE, :SHADOWSHIELD,
                          :DISGUISE, :ICEFACE, :WONDERGUARD, :MAGICBOUNCE,
                          :FLASHFIRE, :WATERABSORB, :VOLTABSORB, :LIGHTNINGROD,
                          :STORMDRAIN, :SAPSIPPER, :MOTORDRIVE, :DRYSKIN,
                          :BATTLEARMOR, :SHELLARMOR, :UNAWARE, :FURCOAT,
                          :ICESCALES, :TERASHELL, :SEEDSOWER]

    def self.mold_breaker_bonus(user, target, move)
      return 0 unless user && target && move && move.damagingMove?
      user_ability = user.respond_to?(:ability_id) ? user.ability_id : nil
      return 0 unless MOLD_BREAKER_ABILITIES.include?(user_ability)
      target_ability = target.respond_to?(:ability_id) ? target.ability_id : nil
      return 0 unless target_ability && BYPASSED_ABILITIES.include?(target_ability)

      bonus = 0
      case target_ability
      when :LEVITATE
        # Ground moves now hit! Huge bonus for EQ/Earth Power
        bonus += 40 if move.type == :GROUND
        AdvancedAI.log("Mold Breaker bypasses Levitate: +#{bonus} for #{move.name}", "Ability") if bonus > 0
      when :STURDY
        bonus += 20  # Can OHKO from full HP now
      when :MULTISCALE, :SHADOWSHIELD
        bonus += 25  # Full damage at full HP
      when :DISGUISE, :ICEFACE
        bonus += 15  # Breaks form AND does damage
      when :WONDERGUARD
        bonus += 50  # Can hit through Wonder Guard!
      when :MAGICBOUNCE
        bonus += 10  # Not huge for damaging moves but still relevant
      when :FLASHFIRE, :WATERABSORB, :VOLTABSORB, :LIGHTNINGROD,
           :STORMDRAIN, :SAPSIPPER, :MOTORDRIVE, :DRYSKIN
        # Type-absorbing abilities bypassed — our move hits normally
        bonus += 35
        AdvancedAI.log("Mold Breaker bypasses #{target_ability}: +#{bonus} for #{move.name}", "Ability") if bonus > 0
      when :FURCOAT
        bonus += 15  # Full physical damage
      when :UNAWARE
        bonus += 10  # Our boosts count
      when :ICESCALES
        bonus += 20  # Full special damage (normally halved)
      when :TERASHELL
        bonus += 25  # Full damage at full HP (normally all NVE)
      when :SEEDSOWER
        bonus += 10  # Prevents Grassy Terrain from being set on hit
      else
        bonus += 10  # Generic bypass bonus
      end
      bonus
    end

    #===========================================================================
    # #3 STURDY AWARENESS
    # Multi-hit moves bypass Sturdy; chip first to break it
    #===========================================================================
    MULTI_HIT_MOVES = [
      :BULLETSEED, :ICICLESPEAR, :ROCKBLAST, :SCALESHOT, :WATERSHURIKEN,
      :TAILSLAP, :TRIPLEAXEL, :SURGINGSTRIKES, :BONERUSH, :PINMISSILE,
      :DOUBLEHIT, :DOUBLEKICK, :TWINEEDLE, :TRIPLEAXEL, :POPULATIONBOMB,
      :ARMTHRUST, :BARRAGE, :COMETPUNCH, :FURYATTACK, :FURYSWIPES,
      :SPIKECANNON, :DUALWINGBEAT, :TRIPLEKICK
    ]

    def self.sturdy_awareness(user, target, move)
      return 0 unless target && move && move.damagingMove?
      target_ability = target.respond_to?(:ability_id) ? target.ability_id : nil
      return 0 unless target_ability == :STURDY

      # Only relevant at full HP
      hp_pct = target.hp.to_f / target.totalhp
      return 0 unless hp_pct >= 0.99

      bonus = 0
      if MULTI_HIT_MOVES.include?(move.id)
        bonus += 40  # Multi-hit bypasses Sturdy!
        AdvancedAI.log("#{move.name} bypasses Sturdy (multi-hit): +40", "Ability")
      elsif move.power && move.power <= 60
        bonus += 10  # Weak move to break Sturdy, then follow up
      else
        bonus -= 15  # Strong move wasted — they'll survive at 1 HP
      end
      bonus
    end

    #===========================================================================
    # #4 MULTISCALE / SHADOW SHIELD — half damage at full HP
    # Prefer chip/hazards first; don't waste strongest move at full HP
    #===========================================================================
    def self.multiscale_awareness(user, target, move)
      return 0 unless target && move && move.damagingMove?
      target_ability = target.respond_to?(:ability_id) ? target.ability_id : nil
      return 0 unless target_ability == :MULTISCALE || target_ability == :SHADOWSHIELD

      hp_pct = target.hp.to_f / target.totalhp
      return 0 unless hp_pct >= 0.99  # Only active at full HP

      bonus = 0
      # Prefer weak chip moves to break Multiscale
      if move.power && move.power <= 60
        bonus += 15  # Good — break Multiscale with chip
        AdvancedAI.log("#{move.name} chips #{target_ability} (weak move): +15", "Ability")
      elsif move.power && move.power >= 100
        bonus -= 20  # Bad — wasting strong move at half damage
        AdvancedAI.log("#{move.name} halved by #{target_ability}: -20", "Ability")
      end

      # Status moves that deal chip are great (Stealth Rock, Toxic, Will-O-Wisp)
      if move.statusMove?
        if [:TOXIC, :WILLOWISP, :THUNDERWAVE].include?(move.id)
          bonus += 10  # Status breaks Multiscale for next turn
        end
      end
      bonus
    end

    #===========================================================================
    # #5 FOCUS SASH CONSUMPTION TRACKING
    # If Sash is consumed (HP < 100% at any point), don't play around it
    #===========================================================================
    @sash_consumed = {}

    def self.mark_sash_consumed(battler_index)
      @sash_consumed[battler_index] = true
    end

    def self.sash_consumed?(battler_index)
      @sash_consumed[battler_index] == true
    end

    def self.cleanup_sash_tracking
      @sash_consumed = {}
    end

    def self.focus_sash_awareness(user, target, move)
      return 0 unless target && move && move.damagingMove?
      target_item = target.respond_to?(:item_id) ? target.item_id : nil
      return 0 unless target_item == :FOCUSSASH

      # If target has taken damage, Sash is broken
      hp_pct = target.hp.to_f / target.totalhp
      idx = target.respond_to?(:index) ? target.index : 0
      if hp_pct < 0.99 || sash_consumed?(idx)
        mark_sash_consumed(idx)
        return 0  # Sash already broken — score normally
      end

      # Sash is active — multi-hit moves bypass it
      if MULTI_HIT_MOVES.include?(move.id)
        AdvancedAI.log("#{move.name} bypasses Focus Sash (multi-hit): +30", "Item")
        return 30
      end

      # Strong single-hit moves are wasted on Sash — they survive at 1 HP anyway
      if move.power && move.power >= 100
        return -15  # Use a weaker move first to pop Sash
      end
      0
    end

    #===========================================================================
    # #6 FLAME ORB + GUTS + FACADE SYNERGY
    # Don't burn Guts mons; prefer Facade when Guts-active
    #===========================================================================
    GUTS_ABILITIES = [:GUTS, :MARVELSCALE, :QUICKFEET]

    def self.guts_status_penalty(target, move)
      return 0 unless target && move
      target_ability = target.respond_to?(:ability_id) ? target.ability_id : nil

      # Don't inflict status on Guts/Marvel Scale/Quick Feet targets
      if target_ability == :GUTS
        if [:WILLOWISP, :TOXIC, :THUNDERWAVE, :SCALD].include?(move.id)
          AdvancedAI.log("#{move.name} powers up Guts on #{target.name}: -60", "Ability")
          return -60  # You're powering them up!
        end
        # Scald's 30% burn chance makes it riskier
        if move.id == :SCALD
          return -30
        end
      end

      if target_ability == :MARVELSCALE
        if [:WILLOWISP, :TOXIC, :THUNDERWAVE].include?(move.id)
          return -40  # +50% Defense when statused
        end
      end

      if target_ability == :QUICKFEET
        if [:THUNDERWAVE, :WILLOWISP, :TOXIC].include?(move.id)
          return -30  # 1.5x Speed when statused
        end
      end
      0
    end

    def self.facade_guts_bonus(user, move)
      return 0 unless user && move
      return 0 unless move.id == :FACADE
      user_ability = user.respond_to?(:ability_id) ? user.ability_id : nil
      user_status = user.respond_to?(:status) ? user.status : :NONE

      if user_status != :NONE
        bonus = 30  # Facade doubles to 140 BP when statused
        if user_ability == :GUTS
          bonus += 25  # 1.5x on top of 140 BP = 210 effective BP!
          AdvancedAI.log("Facade + Guts: +55 (210 effective BP!)", "Ability")
        end
        return bonus
      end
      0
    end

    # Don't inflict status on Poison Heal mons either
    def self.poison_heal_penalty(target, move)
      return 0 unless target && move
      target_ability = target.respond_to?(:ability_id) ? target.ability_id : nil
      return 0 unless target_ability == :POISONHEAL

      if [:TOXIC, :POISONPOWDER, :POISONGAS, :TOXICSPIKES].include?(move.id)
        AdvancedAI.log("#{move.name} heals Poison Heal on #{target.name}: -80", "Ability")
        return -80  # You're giving them 1/8 HP recovery per turn!
      end
      0
    end

    #===========================================================================
    # #7 TRAPPING ABILITY AWARENESS
    # When WE have Arena Trap/Shadow Tag/Magnet Pull: opponent can't switch
    # → boost setup & Toxic; reduce switch-pressure concern
    #===========================================================================
    TRAPPING_ABILITIES = [:ARENATRAP, :SHADOWTAG, :MAGNETPULL]

    def self.trapping_ability_bonus(user, target, move)
      return 0 unless user && target && move
      user_ability = user.respond_to?(:ability_id) ? user.ability_id : nil
      return 0 unless TRAPPING_ABILITIES.include?(user_ability)

      # Check if target is actually trapped
      can_escape = false
      target_ability = target.respond_to?(:ability_id) ? target.ability_id : nil

      case user_ability
      when :ARENATRAP
        # Flying types and Levitate are immune
        can_escape = true if target.respond_to?(:pbHasType?) && target.pbHasType?(:FLYING)
        can_escape = true if target_ability == :LEVITATE
        can_escape = true if target.respond_to?(:item_id) && target.item_id == :AIRBALLOON
      when :SHADOWTAG
        can_escape = true if target_ability == :SHADOWTAG  # Mirror match
        can_escape = true if target.respond_to?(:pbHasType?) && target.pbHasType?(:GHOST)
      when :MAGNETPULL
        # Only traps Steel types
        can_escape = true unless target.respond_to?(:pbHasType?) && target.pbHasType?(:STEEL)
      end
      return 0 if can_escape

      bonus = 0
      # Target can't escape — boost setup & status moves
      if AdvancedAI.setup_move?(move.id)
        bonus += 25  # Free setup — they can't switch to a counter
        AdvancedAI.log("Trapped foe: +25 for setup #{move.name}", "Tactic")
      end
      if [:TOXIC, :WILLOWISP, :THUNDERWAVE].include?(move.id)
        bonus += 20  # Status sticks — no switching out
      end
      if move.id == :PERISHSONG
        bonus += 40  # Perish trap combo!
        AdvancedAI.log("Perish trap: +40 for Perish Song", "Tactic")
      end
      # Reduce value of phazing (they're already trapped)
      if [:ROAR, :WHIRLWIND, :DRAGONTAIL, :CIRCLETHROW].include?(move.id)
        bonus -= 20  # Don't phaze — we want them trapped
      end
      bonus
    end

    #===========================================================================
    # #8 INTIMIDATE CYCLING (Doubles)
    # Switch Intimidate mons in/out to repeatedly lower Attack
    #===========================================================================
    def self.intimidate_cycle_bonus(battle, user, skill)
      return 0 unless battle && user && skill >= 70
      return 0 unless battle.pbSideSize(0) > 1  # Doubles only
      user_ability = user.respond_to?(:ability_id) ? user.ability_id : nil
      return 0 unless user_ability == :INTIMIDATE

      # Check if opponents are physical
      physical_threat_count = 0
      battle.allOtherSideBattlers(user.index).each do |opp|
        next unless opp && !opp.fainted?
        # Count physical attackers
        phys_moves = opp.moves.count { |m| m && m.physicalMove? && m.power && m.power >= 60 }
        physical_threat_count += 1 if phys_moves >= 2
        # Defiant/Competitive counter-check
        opp_ability = opp.respond_to?(:ability_id) ? opp.ability_id : nil
        return 0 if opp_ability == :DEFIANT || opp_ability == :COMPETITIVE
        return 0 if opp_ability == :CLEARBODY || opp_ability == :WHITESMOKE || opp_ability == :FULLMETALBODY
      end

      return 0 if physical_threat_count == 0

      # If we've been in battle for a while, switching out to come back = free Intimidate
      bonus = 0
      if user.turnCount >= 2 && physical_threat_count >= 1
        bonus += physical_threat_count * 15  # More physical threats = more value
        AdvancedAI.log("Intimidate cycle value: +#{bonus} (#{physical_threat_count} phys threats)", "Doubles")
      end
      bonus
    end

    #===========================================================================
    # #9 MULTI-TURN LOOK-AHEAD (2-3 turn sequences)
    # Evaluate common competitive sequences as cohesive plans
    #===========================================================================
    def self.multi_turn_bonus(battle, user, move, target, skill)
      return 0 unless user && move && skill >= 75
      bonus = 0

      user_moves = user.moves.map { |m| m.id if m }.compact
      hp_pct = user.hp.to_f / user.totalhp

      # Belly Drum → priority move sweep
      if move.id == :BELLYDRUM
        has_priority = user_moves.any? { |mid| [:AQUAJET, :MACHPUNCH, :BULLETPUNCH, :ICESHARD, :EXTREMESPEED, :SUCKERPUNCH, :SHADOWSNEAK, :JETPUNCH].include?(mid) }
        if has_priority && hp_pct > 0.55
          bonus += 40  # Belly Drum + priority = sweep potential
          AdvancedAI.log("Multi-turn: Belly Drum → priority sweep: +40", "Plan")
        elsif !has_priority
          bonus -= 10  # No priority = risky (can be revenge killed)
        end
      end

      # Shell Smash → sweep
      if move.id == :SHELLSMASH
        user_item = user.respond_to?(:item_id) ? user.item_id : nil
        if user_item == :WHITEHERB
          bonus += 30  # No defense drops!
          AdvancedAI.log("Multi-turn: Shell Smash + White Herb: +30", "Plan")
        end
        # Check if we outspeed after +2
        if target
          our_speed = user.speed * 2  # +2 Speed
          their_speed = target.respond_to?(:speed) ? target.speed : 100
          bonus += 20 if our_speed > their_speed  # We'll outspeed = sweep
        end
      end

      # Toxic → Protect stall
      if move.id == :TOXIC
        has_protect = user_moves.include?(:PROTECT) || user_moves.include?(:BANEFULBUNKER) || user_moves.include?(:SPIKYSHIELD)
        has_recovery = user_moves.any? { |mid| AdvancedAI.healing_move?(mid) rescue false }
        if has_protect && has_recovery
          bonus += 20  # Toxic stall plan
          AdvancedAI.log("Multi-turn: Toxic → Protect → Recover plan: +20", "Plan")
        end
      end

      # Substitute → setup
      if move.id == :SUBSTITUTE && hp_pct > 0.3
        has_setup = user_moves.any? { |mid| AdvancedAI.setup_move?(mid) rescue false }
        if has_setup
          bonus += 15  # Sub → setup is a classic competitive sequence
          AdvancedAI.log("Multi-turn: Substitute → setup: +15", "Plan")
        end
        # Sub + Focus Punch
        if user_moves.include?(:FOCUSPUNCH)
          bonus += 25
          AdvancedAI.log("Multi-turn: Sub → Focus Punch: +25", "Plan")
        end
      end

      # Dragon Dance / Quiver Dance → sweep check
      if [:DRAGONDANCE, :QUIVERDANCE, :SHIFTGEAR].include?(move.id)
        if target
          our_speed_boosted = user.speed * 1.5  # +1 Speed
          their_speed = target.respond_to?(:speed) ? target.speed : 100
          if our_speed_boosted > their_speed
            bonus += 15  # One DD and we outspeed = sweep
            AdvancedAI.log("Multi-turn: #{move.name} outspeeds at +1: +15", "Plan")
          end
        end
      end

      # Swords Dance/Nasty Plot at safe HP = followup sweep
      if [:SWORDSDANCE, :NASTYPLOT, :CALMMIND].include?(move.id)
        if hp_pct > 0.7 && user.effects[PBEffects::Substitute] > 0
          bonus += 20  # Behind Sub = safe setup
        end
      end

      bonus
    end

    #===========================================================================
    # #10 POWER HERB + CHARGE MOVES
    # Solar Beam, Meteor Beam, Phantom Force etc. skip charge turn
    #===========================================================================
    CHARGE_MOVES = [
      :SOLARBEAM, :SOLARBLADE, :METEORBEAM, :PHANTOMFORCE, :SHADOWFORCE,
      :SKULLBASH, :SKYATTACK, :FLY, :DIG, :DIVE, :BOUNCE, :GEOMANCY,
      :FREEZESHOCK, :ICEBURN, :RAZORWIND, :ELECTROSHOT
    ]

    def self.power_herb_bonus(user, move)
      return 0 unless user && move
      user_item = user.respond_to?(:item_id) ? user.item_id : nil
      return 0 unless user_item == :POWERHERB
      return 0 unless CHARGE_MOVES.include?(move.id)

      bonus = 35  # Skips charge turn = massive action economy gain
      # Meteor Beam also raises SpAtk → extra value
      bonus += 15 if move.id == :METEORBEAM
      # Geomancy raises SpAtk/SpDef/Speed → insane value
      bonus += 25 if move.id == :GEOMANCY
      AdvancedAI.log("Power Herb: #{move.name} instant: +#{bonus}", "Item")
      bonus
    end

    #===========================================================================
    # #11 WHITE HERB + SHELL SMASH / STAT-DROP MOVES
    # Negates defense drops from Shell Smash, Close Combat, etc.
    #===========================================================================
    SELF_DROP_MOVES = [:SHELLSMASH, :CLOSECOMBAT, :SUPERPOWER, :OVERHEAT,
                       :DRACOMETEOR, :LEAFSTORM, :FLEURCANNON, :PSYCHOBOOST,
                       :VCREATE]

    def self.white_herb_bonus(user, move)
      return 0 unless user && move
      user_item = user.respond_to?(:item_id) ? user.item_id : nil
      return 0 unless user_item == :WHITEHERB
      return 0 unless SELF_DROP_MOVES.include?(move.id)

      bonus = 0
      case move.id
      when :SHELLSMASH
        bonus += 35  # +2/+2/+2 with NO defense drops = insane
        AdvancedAI.log("White Herb + Shell Smash: +35 (no def drops!)", "Item")
      when :CLOSECOMBAT, :SUPERPOWER
        bonus += 15  # No Atk/Def drops
      when :OVERHEAT, :DRACOMETEOR, :LEAFSTORM, :FLEURCANNON, :PSYCHOBOOST
        bonus += 20  # No SpAtk drop = can spam
        AdvancedAI.log("White Herb + #{move.name}: +20 (no SpAtk drop)", "Item")
      when :VCREATE
        bonus += 15
      end
      bonus
    end

    #===========================================================================
    # #12 DISGUISE / ICE FACE — waste weak hit to break form
    #===========================================================================
    def self.disguise_iceface_awareness(user, target, move)
      return 0 unless target && move && move.damagingMove?
      target_ability = target.respond_to?(:ability_id) ? target.ability_id : nil

      if target_ability == :DISGUISE
        # Check if Disguise is still active (form 0 = Disguised)
        form = target.respond_to?(:form) ? target.form : 0
        if form == 0  # Disguised form
          if move.power && move.power <= 60
            return 20  # Good — use weak move to pop Disguise
          elsif move.power && move.power >= 100
            return -25  # Bad — wasting strong move on Disguise
          end
        end
      end

      if target_ability == :ICEFACE
        form = target.respond_to?(:form) ? target.form : 0
        if form == 0 && move.physicalMove?  # Ice Face blocks first physical hit
          if move.power && move.power <= 60
            return 15  # Good — pop Ice Face cheaply
          elsif move.power && move.power >= 100
            return -20  # Bad — wasting strong physical move
          end
          # Special moves bypass Ice Face entirely!
        end
        if move.specialMove?
          return 10  # Special moves go through Ice Face
        end
      end
      0
    end

    #===========================================================================
    # #13 POISON HEAL / GUTS STATUS IMMUNITY (aggregated)
    # Combined: don't inflict status on ability-immune targets
    #===========================================================================
    # (Implemented in #6 above — guts_status_penalty + poison_heal_penalty)

    #===========================================================================
    # #14 GOOD AS GOLD — full status immunity
    #===========================================================================
    def self.good_as_gold_penalty(target, move)
      return 0 unless target && move
      target_ability = target.respond_to?(:ability_id) ? target.ability_id : nil
      return 0 unless target_ability == :GOODASGOLD
      return 0 unless move.statusMove?

      AdvancedAI.log("#{move.name} blocked by Good as Gold on #{target.name}: -200", "Ability")
      -200  # All status moves fail against Good as Gold
    end

    #===========================================================================
    # #15 FUTURE SIGHT + SWITCH SYNERGY
    # Use Future Sight, then switch to a fighter who pressures the target
    #===========================================================================
    def self.future_sight_bonus(battle, user, move, target)
      return 0 unless move && user
      return 0 unless move.id == :FUTURESIGHT || move.id == :DOOMDESIRE

      bonus = 0
      # Check if Future Sight is already active
      if target && target.effects[PBEffects::FutureSightCounter] > 0
        return -50  # Already active — don't stack
      end

      # Bonus if we have good switch-ins that pressure the target
      party = battle.pbParty(user.index) rescue []
      good_partners = 0
      party.each do |pkmn|
        next if !pkmn || pkmn.fainted? || pkmn.egg?
        next if pkmn == (user.respond_to?(:pokemon) ? user.pokemon : user)
        # Partner that can pressure the target (physical attacker, trapper, etc.)
        pkmn_roles = AdvancedAI.detect_roles(pkmn) rescue [:balanced]
        good_partners += 1 if pkmn_roles.include?(:wallbreaker) || pkmn_roles.include?(:sweeper)
      end

      if good_partners >= 1
        bonus += 20  # Future Sight + switch to attacker = double pressure
        bonus += 10 if good_partners >= 2
        AdvancedAI.log("Future Sight + switch option: +#{bonus}", "Tactic")
      end

      # Pivot moves make this even better (switch out safely)
      user_moves = user.moves.map { |m| m.id if m }.compact
      pivot_moves = [:UTURN, :VOLTSWITCH, :FLIPTURN, :PARTINGSHOT, :TELEPORT, :BATONPASS]
      if user_moves.any? { |mid| pivot_moves.include?(mid) }
        bonus += 10  # Can pivot out after Future Sight
      end
      bonus
    end

    #===========================================================================
    # #16 WISH PROACTIVE USE + WISH-PASS
    # Use Wish at high HP to prepare healing cycle
    #===========================================================================
    def self.wish_proactive_bonus(battle, user, move)
      return 0 unless move && user
      return 0 unless move.id == :WISH

      bonus = 0
      hp_pct = user.hp.to_f / user.totalhp

      # Already handled: Wish active → blocked. This handles the planning aspect.

      # At high HP: less immediate need, but good for cycling
      if hp_pct > 0.85
        # Check if any teammate is low
        party = battle.pbParty(user.index) rescue []
        low_teammates = party.count do |pkmn|
          next false if !pkmn || pkmn.fainted? || pkmn.egg?
          next false if pkmn == (user.respond_to?(:pokemon) ? user.pokemon : user)
          pkmn.hp.to_f / pkmn.totalhp < 0.5
        end

        if low_teammates >= 1
          bonus += 25  # Wish-pass to heal a teammate
          AdvancedAI.log("Wish-pass: low teammate needs healing: +25", "Tactic")
        else
          bonus += 10  # Proactive Wish at high HP = prepare for future
        end
      end

      # Wish + Protect combo detection
      user_moves = user.moves.map { |m| m.id if m }.compact
      if user_moves.include?(:PROTECT) || user_moves.include?(:BANEFULBUNKER)
        bonus += 10  # Can guarantee Wish landing with Protect next turn
      end
      bonus
    end

    #===========================================================================
    # #17 BELLY DRUM DEDICATED EVAL
    # All-or-nothing: +6 Atk but costs 50% HP
    #===========================================================================
    def self.belly_drum_eval(battle, user, move, target, skill)
      return 0 unless move && move.id == :BELLYDRUM
      return 0 unless user

      hp_pct = user.hp.to_f / user.totalhp
      # Need >50% HP to use
      return -200 if hp_pct <= 0.5

      bonus = 0
      user_moves = user.moves.map { |m| m.id if m }.compact
      user_item = user.respond_to?(:item_id) ? user.item_id : nil

      # Priority move = can sweep even at half HP
      priority_moves = [:AQUAJET, :MACHPUNCH, :BULLETPUNCH, :ICESHARD,
                        :EXTREMESPEED, :SUCKERPUNCH, :SHADOWSNEAK, :JETPUNCH]
      has_priority = user_moves.any? { |mid| priority_moves.include?(mid) }

      if has_priority
        bonus += 50  # Belly Drum + priority = guaranteed sweep
      end

      # Sitrus Berry recovery after Drum
      if user_item == :SITRUSBERRY
        bonus += 20  # Recover 25% after Drum → 75% HP at +6
      end

      # Check if we can actually sweep from +6
      if target
        our_atk_boosted = user.attack * 4  # +6 stages
        # Rough check: can we OHKO most things?
        their_def = target.respond_to?(:defense) ? target.defense : 100
        if our_atk_boosted > their_def * 3
          bonus += 20  # Likely sweeping
        end
      end

      # Penalty if opponent has priority/scarf revenge killer
      if target
        target_speed = target.respond_to?(:speed) ? target.speed : 100
        if target_speed > user.speed && !has_priority
          bonus -= 30  # They outspeed us = revenge killed post-Drum
        end
      end

      AdvancedAI.log("Belly Drum eval: #{bonus} (priority=#{has_priority}, HP=#{(hp_pct * 100).to_i}%%)", "Plan") if bonus != 0
      bonus
    end

    #===========================================================================
    # #18 STALL-BREAKER MODE
    # When facing stall, prioritize anti-stall tools cohesively
    #===========================================================================
    def self.stallbreaker_bonus(battle, user, move, target, skill)
      return 0 unless battle && user && move && skill >= 70
      return 0 unless target

      # Check if opponent is running stall
      state = AdvancedAI::StrategicAwareness.battle_state(battle) rescue nil
      archetype = state ? state[:opponent_archetype] : nil
      return 0 unless archetype == :stall

      bonus = 0
      # Taunt is king vs stall
      if move.id == :TAUNT
        bonus += 30
        AdvancedAI.log("Stallbreaker: Taunt vs stall: +30", "Strategy")
      end

      # Knock Off removes Leftovers/Black Sludge
      if move.id == :KNOCKOFF
        bonus += 20
      end

      # Setup moves: set up on passive walls
      if AdvancedAI.setup_move?(move.id)
        # Only if target is passive (wall/support)
        target_roles = AdvancedAI.detect_roles(target) rescue [:balanced]
        if target_roles.include?(:wall) || target_roles.include?(:stall) || target_roles.include?(:support)
          bonus += 20
          AdvancedAI.log("Stallbreaker: setup on passive #{target.name}: +20", "Strategy")
        end
      end

      # Trick/Switcheroo cripple walls with Choice items
      if [:TRICK, :SWITCHEROO].include?(move.id)
        user_item = user.respond_to?(:item_id) ? user.item_id : nil
        if AdvancedAI.choice_item?(user_item)
          bonus += 25  # Lock wall into one move
        end
      end

      # Super-effective wallbreaking moves
      if move.damagingMove? && move.power && move.power >= 100
        bonus += 10  # Raw power vs stall
      end
      bonus
    end

    #===========================================================================
    # #19 HAZARD STACKING ORDER
    # Dynamic hazard priority based on opponent team composition
    #===========================================================================
    def self.hazard_order_bonus(battle, user, move, target)
      return 0 unless move && user && target
      return 0 unless [:STEALTHROCK, :SPIKES, :TOXICSPIKES, :STICKYWEB].include?(move.id)

      bonus = 0
      opp_party = battle.pbParty((user.index + 1) % 2) rescue []

      case move.id
      when :TOXICSPIKES
        # Check if opponents are mostly Steel/Poison (immune to TSpikes)
        immune_count = opp_party.count do |pkmn|
          next false if !pkmn || pkmn.fainted? || pkmn.egg?
          types = pkmn.types rescue []
          types.include?(:STEEL) || types.include?(:POISON)
        end
        alive_count = opp_party.count { |p| p && !p.fainted? && !p.egg? }
        if alive_count > 0 && immune_count.to_f / alive_count >= 0.5
          bonus -= 30  # Half+ the team is immune
          AdvancedAI.log("TSpikes deprioritized: #{immune_count}/#{alive_count} immune", "Hazard")
        end

        # Check for Flying types / Levitate (not grounded)
        airborne_count = opp_party.count do |pkmn|
          next false if !pkmn || pkmn.fainted? || pkmn.egg?
          types = pkmn.types rescue []
          abilities = pkmn.respond_to?(:ability_id) ? [pkmn.ability_id] : []
          types.include?(:FLYING) || abilities.include?(:LEVITATE)
        end
        if alive_count > 0 && airborne_count.to_f / alive_count >= 0.5
          bonus -= 20  # Many fliers
        end

      when :STICKYWEB
        # Less valuable vs already-slow teams or Trick Room teams
        fast_count = opp_party.count do |pkmn|
          next false if !pkmn || pkmn.fainted? || pkmn.egg?
          base_speed = pkmn.respond_to?(:speed) ? pkmn.speed : 80
          base_speed >= 90  # Fast enough to benefit from speed drop
        end
        alive_count = opp_party.count { |p| p && !p.fainted? && !p.egg? }
        if alive_count > 0 && fast_count.to_f / alive_count < 0.3
          bonus -= 20  # Mostly slow team — Sticky Web less impactful
        end

        # Useless if TR is up
        if battle.field.effects[PBEffects::TrickRoom] > 0
          bonus -= 40  # Speed drop helps them in TR!
        end

      when :SPIKES
        # Less valuable if many fliers/levitators
        grounded_count = opp_party.count do |pkmn|
          next false if !pkmn || pkmn.fainted? || pkmn.egg?
          types = pkmn.types rescue []
          abilities = pkmn.respond_to?(:ability_id) ? [pkmn.ability_id] : []
          !types.include?(:FLYING) && !abilities.include?(:LEVITATE)
        end
        alive_count = opp_party.count { |p| p && !p.fainted? && !p.egg? }
        if alive_count > 0 && grounded_count.to_f / alive_count < 0.4
          bonus -= 20  # Most of team avoids Spikes
        end
      end
      bonus
    end

    #===========================================================================
    # #20 ALLY SWITCH AWARENESS + TR SETTER/SWEEPER COORDINATION (Doubles)
    #===========================================================================

    # Ally Switch: use strategically to dodge predicted attacks
    def self.ally_switch_bonus(battle, user, move, target, skill)
      return 0 unless move && move.id == :ALLYSWITCH
      return 0 unless battle.pbSideSize(0) > 1  # Doubles only

      bonus = 0
      partner = battle.allSameSideBattlers(user.index).find { |b| b && b != user && !b.fainted? }
      return 0 unless partner

      # Value: protect partner from predicted KO
      partner_hp_pct = partner.hp.to_f / partner.totalhp
      user_hp_pct = user.hp.to_f / user.totalhp

      if partner_hp_pct < 0.4 && user_hp_pct > 0.6
        bonus += 25  # Save low-HP partner by swapping positions
      end

      # Mind game value at high skill
      bonus += 10 if skill >= 85
      AdvancedAI.log("Ally Switch: +#{bonus}", "Doubles") if bonus > 0
      bonus
    end

    # Trick Room setter should Protect or sacrifice after setting TR
    def self.tr_setter_followup(battle, user, move, skill)
      return 0 unless battle && user && move && skill >= 70
      return 0 unless battle.pbSideSize(0) > 1  # Doubles only

      bonus = 0
      # If TR is active and we SET it (we're slow = TR setter)
      if battle.field.effects[PBEffects::TrickRoom] > 0
        our_speed = user.speed
        # Check if partner is the TR sweeper (slow, powerful)
        partner = battle.allSameSideBattlers(user.index).find { |b| b && b != user && !b.fainted? }
        if partner
          partner_speed = partner.respond_to?(:speed) ? partner.speed : 100
          # If we're faster than partner in TR (lower Speed = faster), we're the setter
          if our_speed > partner_speed
            # Setter should Protect to let sweeper act, or use support moves
            if move.id == :PROTECT || move.id == :BANEFULBUNKER || move.id == :SPIKYSHIELD
              bonus += 15  # Protect while sweeper attacks
            end
            # Helping Hand partner's sweep
            if move.id == :HELPINGHAND
              bonus += 20  # Boost the TR sweeper
            end
            # Self-sacrifice moves (Memento, Healing Wish)
            if [:MEMENTO, :HEALINGWISH, :LUNARDANCE].include?(move.id)
              bonus += 15  # Set up replacement
            end
          end
        end
      end
      bonus
    end

    #===========================================================================
    # #21 BOOSTER ENERGY SCORING
    # Paradox abilities (Protosynthesis/Quark Drive) + Booster Energy
    #===========================================================================
    PARADOX_ABILITIES = [:PROTOSYNTHESIS, :QUARKDRIVE]

    def self.booster_energy_bonus(user, move)
      return 0 unless user && move
      user_ability = user.respond_to?(:ability_id) ? user.ability_id : nil
      user_item = user.respond_to?(:item_id) ? user.item_id : nil
      return 0 unless PARADOX_ABILITIES.include?(user_ability)
      return 0 unless user_item == :BOOSTERENERGY

      # Booster Energy auto-activates the Paradox ability
      # → stat boost already active, so favor moves that leverage it
      bonus = 0
      # Determine which stat is boosted (highest stat)
      stats = {
        atk: user.respond_to?(:attack) ? user.attack : 0,
        spa: user.respond_to?(:spatk) ? user.spatk : 0,
        speed: user.respond_to?(:speed) ? user.speed : 0,
        def_stat: user.respond_to?(:defense) ? user.defense : 0,
        spd: user.respond_to?(:spdef) ? user.spdef : 0,
      }
      best_stat = stats.max_by { |_, v| v }.first

      case best_stat
      when :atk
        bonus += 10 if move.physicalMove?  # Leverage boosted Atk
      when :spa
        bonus += 10 if move.specialMove?   # Leverage boosted SpAtk
      when :speed
        bonus += 5  # Speed boost = outspeed more things
      end
      bonus
    end

    #===========================================================================
    # COMBINED SCORING — called from scoring pipeline
    #===========================================================================
    def self.tactical_score(battle, user, move, target, skill = 100)
      return 0 unless skill >= 50
      total = 0

      begin
        # Ability awareness (#1, #2, #3, #4, #6, #13, #14)
        if target
          total += magic_bounce_penalty(target, move)
          total += mold_breaker_bonus(user, target, move)
          total += sturdy_awareness(user, target, move)
          total += multiscale_awareness(user, target, move)
          total += focus_sash_awareness(user, target, move)
          total += guts_status_penalty(target, move)
          total += poison_heal_penalty(target, move)
          total += good_as_gold_penalty(target, move)
          total += disguise_iceface_awareness(user, target, move)
          total += trapping_ability_bonus(user, target, move)
        end

        # User-side item/ability bonuses (#6, #10, #11, #21)
        total += facade_guts_bonus(user, move)
        total += power_herb_bonus(user, move)
        total += white_herb_bonus(user, move)
        total += booster_energy_bonus(user, move)

        # Multi-turn planning (#9, #17)
        total += multi_turn_bonus(battle, user, move, target, skill) if skill >= 75
        total += belly_drum_eval(battle, user, move, target, skill) if move.id == :BELLYDRUM

        # Strategic (#15, #16, #18, #19)
        total += future_sight_bonus(battle, user, move, target) if target
        total += wish_proactive_bonus(battle, user, move) if move.id == :WISH
        total += stallbreaker_bonus(battle, user, move, target, skill) if target
        total += hazard_order_bonus(battle, user, move, target) if target

        # Doubles-specific (#8, #20)
        if battle.pbSideSize(0) > 1
          total += intimidate_cycle_bonus(battle, user, skill)
          total += ally_switch_bonus(battle, user, move, target, skill) if move.id == :ALLYSWITCH
          total += tr_setter_followup(battle, user, move, skill)
        end
      rescue => e
        AdvancedAI.log("[Tactical] Error: #{e.message}", "Tactical")
      end

      total
    end

    # Cleanup between battles
    def self.cleanup
      @sash_consumed = {}
    end
  end
end

#===============================================================================
# API Wrapper
#===============================================================================
module AdvancedAI
  def self.tactical_score(battle, user, move, target, skill = 100)
    TacticalEnhancements.tactical_score(battle, user, move, target, skill)
  end

  def self.mark_sash_consumed(battler_index)
    TacticalEnhancements.mark_sash_consumed(battler_index)
  end
end

#===============================================================================
# Integration in Battle::AI — Wires tactical enhancements into scoring pipeline
#===============================================================================
class Battle::AI
  def apply_tactical_enhancements(score, move, user, target, skill = 100)
    return score unless move && user
    begin
      real_user = user.respond_to?(:battler) ? user.battler : user
      real_target = target ? (target.respond_to?(:battler) ? target.battler : target) : nil
      bonus = AdvancedAI.tactical_score(@battle, real_user, move, real_target, skill)
      score += bonus if bonus && bonus != 0
    rescue => e
      AdvancedAI.log("[Tactical] Pipeline error: #{e.message}", "Tactical")
    end
    return score
  end
end

#===============================================================================
# Sash consumption tracking — hook into damage dealing
#===============================================================================
class Battle
  alias aai_tactical_cleanup_pbEndOfBattle pbEndOfBattle
  def pbEndOfBattle
    AdvancedAI::TacticalEnhancements.cleanup
    aai_tactical_cleanup_pbEndOfBattle
  end
end

AdvancedAI.log("Tactical Enhancements loaded", "Tactical")
AdvancedAI.log("  - #1 Magic Bounce in-battle penalty", "Tactical")
AdvancedAI.log("  - #2 Mold Breaker ability bypass", "Tactical")
AdvancedAI.log("  - #3 Sturdy multi-hit/chip awareness", "Tactical")
AdvancedAI.log("  - #4 Multiscale/Shadow Shield chip logic", "Tactical")
AdvancedAI.log("  - #5 Focus Sash consumption tracking", "Tactical")
AdvancedAI.log("  - #6 Guts/Facade/Poison Heal synergy", "Tactical")
AdvancedAI.log("  - #7 Trapping ability awareness", "Tactical")
AdvancedAI.log("  - #8 Intimidate cycling (Doubles)", "Tactical")
AdvancedAI.log("  - #9 Multi-turn look-ahead planning", "Tactical")
AdvancedAI.log("  - #10 Power Herb + charge moves", "Tactical")
AdvancedAI.log("  - #11 White Herb + Shell Smash synergy", "Tactical")
AdvancedAI.log("  - #12 Disguise/Ice Face form breaking", "Tactical")
AdvancedAI.log("  - #13 Status immunity abilities", "Tactical")
AdvancedAI.log("  - #14 Good as Gold full status immune", "Tactical")
AdvancedAI.log("  - #15 Future Sight + switch synergy", "Tactical")
AdvancedAI.log("  - #16 Wish proactive + Wish-pass", "Tactical")
AdvancedAI.log("  - #17 Belly Drum dedicated eval", "Tactical")
AdvancedAI.log("  - #18 Stall-breaker mode", "Tactical")
AdvancedAI.log("  - #19 Hazard stacking order", "Tactical")
AdvancedAI.log("  - #20 Ally Switch + TR coordination", "Tactical")
AdvancedAI.log("  - #21 Booster Energy scoring", "Tactical")

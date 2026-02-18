#===============================================================================
# Advanced AI System - Advanced Item Intelligence
# Handles Pinch Berries, Eject mechanics, Air Balloon, and situational items
#===============================================================================

module AdvancedAI
  # Pinch Berry activation thresholds
  PINCH_BERRIES = {
    :SITRUSBERRY  => 0.50,  # Heals when ≤50% HP
    :ORANBERRY    => 0.50,  # Heals 10 HP
    :FIGYBERRY    => 0.25,  # Heals 1/3 HP at 25%
    :WIKIBERRY    => 0.25,  #
    :MAGOBERRY    => 0.25,  #
    :AGUAVBERRY   => 0.25,  #
    :IAPAPABERRY  => 0.25,  #
    :LIECHIBERRY  => 0.25,  # +1 Atk
    :PETAYABERRY  => 0.25,  # +1 SpAtk
    :SALACBERRY   => 0.25,  # +1 Speed
    :GANLONBERRY  => 0.25,  # +1 Def
    :APICOTBERRY  => 0.25,  # +1 SpDef
    :STARFBERRY   => 0.25,  # +2 random stat
    :CUSTAPBERRY  => 0.25,  # Priority
  }
  
  # Type resist berries
  TYPE_RESIST_BERRIES = {
    :OCCABERRY    => :FIRE,
    :PASSHOBERRY  => :WATER,
    :WACANBERRY   => :ELECTRIC,
    :RINDOBERRY   => :GRASS,
    :YACHEBERRY   => :ICE,
    :CHOPLEBERRY  => :FIGHTING,
    :KEBIABERRY   => :POISON,
    :SHUCABERRY   => :GROUND,
    :COBABERRY    => :FLYING,
    :PAYAPABERRY  => :PSYCHIC,
    :TANGABERRY   => :BUG,
    :CHARTIBERRY  => :ROCK,
    :KASIBBERRY   => :GHOST,
    :HABANBERRY   => :DRAGON,
    :COLBURBERRY  => :DARK,
    :BABIRIBERRY  => :STEEL,
    :CHILANBERRY  => :NORMAL,
    :ROSELIBERRY  => :FAIRY,
  }
end

class Battle::AI
  # ============================================================================
  # PINCH BERRY AWARENESS
  # ============================================================================
  
  alias advanced_items_pbRegisterMove pbRegisterMove
  def pbRegisterMove(user, move)
    score = advanced_items_pbRegisterMove(user, move)
    
    return score unless user && move
    
    @battle.allOtherSideBattlers(user.index).each do |target|
      next unless target && !target.fainted? && target.item
      
      # PINCH BERRIES: Damage threshold awareness
      if AdvancedAI::PINCH_BERRIES.key?(target.item_id)
        score += evaluate_pinch_berry(user, move, target)
      end
      
      # TYPE RESIST BERRIES: Resist once then consumed
      if AdvancedAI::TYPE_RESIST_BERRIES.key?(target.item_id)
        score += evaluate_resist_berry(user, move, target)
      end
      
      # EJECT BUTTON / RED CARD
      if [:EJECTBUTTON, :REDCARD].include?(target.item_id)
        score += evaluate_eject_mechanics(user, move, target)
      end
      
      # AIR BALLOON
      if target.item_id == :AIRBALLOON
        score += evaluate_air_balloon(user, move, target)
      end
      
      # WEAKNESS POLICY
      if target.item_id == :WEAKNESSPOLICY && move.damagingMove?
        score += evaluate_weakness_policy(user, move, target)
      end
      
      # EJECT PACK
      if target.item_id == :EJECTPACK
        score += evaluate_eject_pack(user, move, target)
      end
      
      # ROCKY HELMET / IRON BARBS
      if target.item_id == :ROCKYHELMET || target.ability_id == :IRONBARBS
        score += evaluate_contact_damage(user, move, target)
      end
    end
    
    return score
  end
  
  # ============================================================================
  # PINCH BERRY EVALUATION
  # ============================================================================
  
  def evaluate_pinch_berry(user, move, target)
    return 0 unless move.damagingMove?
    
    score = 0
    berry_id = target.item_id
    activation_threshold = AdvancedAI::PINCH_BERRIES[berry_id]
    
    hp_percent = target.hp.to_f / target.totalhp
    rough_damage = CombatUtilities.estimate_damage(user.battler, move, target, as_percent: true)
    hp_after = hp_percent - rough_damage
    
    # Check if damage will trigger berry
    will_trigger = (hp_percent > activation_threshold && hp_after <= activation_threshold)
    
    if will_trigger
      case berry_id
      when :SITRUSBERRY, :FIGYBERRY, :WIKIBERRY, :MAGOBERRY, :AGUAVBERRY, :IAPAPABERRY
        # Healing berry - try to KO instead
        if rough_damage < hp_percent
          score -= 20  # Don't chip them into berry range
          AdvancedAI.log("  #{berry_id}: -20 (triggers heal)", "Items")
          
          # Unless we can KO through the heal
          heal_amount = (berry_id == :SITRUSBERRY) ? 0.25 : 0.33
          if rough_damage >= hp_percent + heal_amount
            score += 30  # KO through heal
            AdvancedAI.log("  But KOs through heal: +30", "Items")
          end
        end
        
      when :LIECHIBERRY, :PETAYABERRY, :SALACBERRY, :GANLONBERRY, :APICOTBERRY, :STARFBERRY
        # Stat boost berry - DON'T trigger unless KO
        if rough_damage >= hp_percent
          score += 20  # KO before activation
          AdvancedAI.log("  #{berry_id}: +20 (KO before boost)", "Items")
        else
          score -= 35  # Don't give them free +1
          AdvancedAI.log("  #{berry_id}: -35 (triggers stat boost!)", "Items")
        end
        
      when :CUSTAPBERRY
        # Priority berry - less scary
        score -= 10
        AdvancedAI.log("  Custap Berry: -10 (grants priority)", "Items")
      end
    end
    
    return score
  end
  
  # ============================================================================
  # TYPE RESIST BERRY EVALUATION
  # ============================================================================
  
  def evaluate_resist_berry(user, move, target)
    return 0 unless move.damagingMove?
    
    score = 0
    berry_id = target.item_id
    resisted_type = AdvancedAI::TYPE_RESIST_BERRIES[berry_id]
    
    # Check if our move matches the berry type
    if move.type == resisted_type
      type_mod = Effectiveness.calculate(move.type, *target.pbTypes(true))
      
      if Effectiveness.super_effective?(type_mod)
        # Berry will halve damage
        score -= 25
        AdvancedAI.log("  #{berry_id}: -25 (halves SE damage)", "Items")
        
        # Check if we'd still KO
        rough_damage = CombatUtilities.estimate_damage(user.battler, move, target, as_percent: true)
        halved_damage = rough_damage * 0.5
        
        if halved_damage >= target.hp.to_f / target.totalhp
          score += 40  # Still KO
          AdvancedAI.log("  But still KOs: +40", "Items")
        end
      end
    end
    
    return score
  end
  
  # ============================================================================
  # EJECT BUTTON / RED CARD EVALUATION
  # ============================================================================
  
  def evaluate_eject_mechanics(user, move, target)
    return 0 unless move.damagingMove?
    
    score = 0
    item_id = target.item_id
    
    # Eject Button: Target switches out when hit
    # Red Card: User switches out when hitting
    
    if item_id == :EJECTBUTTON
      # They get a free switch - check if bad for us
      hp_percent = target.hp.to_f / target.totalhp
      
      if hp_percent < 0.4
        # Good - they're weak, force them out before recovery
        score += 15
        AdvancedAI.log("  Eject Button (weak target): +15 (forces out)", "Items")
      else
        # Bad - they get a free pivot
        score -= 20
        AdvancedAI.log("  Eject Button: -20 (free switch)", "Items")
      end
      
    elsif item_id == :REDCARD
      # We get forced out - generally bad
      score -= 30
      AdvancedAI.log("  Red Card: -30 (forces us out)", "Items")
      
      # Unless we want to switch anyway
      if user.hp < user.totalhp * 0.3
        score += 25  # Fine, we wanted out
        AdvancedAI.log("  But low HP: +25 (wanted to switch)", "Items")
      end
    end
    
    return score
  end
  
  # ============================================================================
  # AIR BALLOON EVALUATION
  # ============================================================================
  
  def evaluate_air_balloon(user, move, target)
    return 0 unless move.damagingMove?
    
    score = 0
    
    # Air Balloon: Ground immunity until hit
    if move.type == :GROUND
      # Our Ground move does nothing
      score -= 80
      AdvancedAI.log("  Air Balloon: -80 (Ground immunity)", "Items")
    else
      # We can pop the balloon
      score += 15
      AdvancedAI.log("  Air Balloon: +15 (pop it!)", "Items")
      
      # Bonus if we have Ground coverage next turn
      if user.moves.any? { |m| m && m.type == :GROUND }
        score += 10
        AdvancedAI.log("  Have Ground move: +10 (follow-up)", "Items")
      end
    end
    
    return score
  end
  
  # ============================================================================
  # WEAKNESS POLICY EVALUATION
  # ============================================================================
  
  def evaluate_weakness_policy(user, move, target)
    return 0 unless move.damagingMove?
    
    score = 0
    type_mod = Effectiveness.calculate(move.type, *target.pbTypes(true))
    
    if Effectiveness.super_effective?(type_mod)
      rough_damage = CombatUtilities.estimate_damage(user.battler, move, target, as_percent: true)
      
      if rough_damage >= target.hp.to_f / target.totalhp
        # KO before trigger
        score += 30
        AdvancedAI.log("  Weakness Policy: +30 (KO before trigger)", "Items")
      else
        # Triggers +2/+2 - BAD
        score -= 50
        AdvancedAI.log("  Weakness Policy: -50 (triggers +2/+2!)", "Items")
        
        # CRITICAL if they're a sweeper
        if target.attack > 100 || target.spatk > 100
          score -= 30
          AdvancedAI.log("  High offense: -30 (becomes unstoppable)", "Items")
        end
      end
    end
    
    return score
  end
  
  # ============================================================================
  # EJECT PACK EVALUATION
  # ============================================================================
  
  def evaluate_eject_pack(user, move, target)
    return 0 unless move.statusMove?
    
    score = 0
    
    # Eject Pack: Switches out when stats are lowered
    # Check if move lowers stats
    stat_drop_moves = [:LOWER_TARGET_ATK_1, :LOWER_TARGET_DEF_1, :LOWER_TARGET_SPATK_1,
                      :LOWER_TARGET_SPDEF_1, :LOWER_TARGET_SPEED_1]
    
    if stat_drop_moves.include?(move.function_code.to_sym)
      # They escape stat drops for free
      score -= 35
      AdvancedAI.log("  Eject Pack: -35 (escapes stat drop)", "Items")
      
      # Unless we wanted them gone anyway
      if target.stages.values.sum >= 2
        score += 40  # Reset their boosts
        AdvancedAI.log("  But removes boosts: +40", "Items")
      end
    end
    
    return score
  end
  
  # ============================================================================
  # ROCKY HELMET / IRON BARBS EVALUATION
  # ============================================================================
  
  def evaluate_contact_damage(user, move, target)
    return 0 unless move.damagingMove?
    return 0 unless move.contactMove?  # Only contact moves trigger
    
    score = 0
    
    # 1/6 max HP damage to user
    recoil_damage = user.totalhp / 6.0
    user_hp_percent = user.hp.to_f / user.totalhp
    
    if user_hp_percent < 0.3
      # Low HP - avoid contact
      score -= 25
      AdvancedAI.log("  Rocky Helmet (low HP): -25 (avoid contact)", "Items")
    elsif user_hp_percent < 0.5
      score -= 15
      AdvancedAI.log("  Rocky Helmet: -15 (contact damage)", "Items")
    else
      score -= 5
      AdvancedAI.log("  Rocky Helmet: -5 (minor chip)", "Items")
    end
    
    # Unless it KOs the target
    rough_damage = CombatUtilities.estimate_damage(user.battler, move, target, as_percent: true)
    if rough_damage >= target.hp.to_f / target.totalhp
      score += 20  # Worth it for the KO
      AdvancedAI.log("  But KOs: +20 (worth it)", "Items")
    end
    
    return score
  end
end

AdvancedAI.log("Advanced Item Intelligence loaded", "Core")
AdvancedAI.log("  - Pinch Berry awareness (Sitrus, Liechi, etc.)", "Items")
AdvancedAI.log("  - Type Resist Berries", "Items")
AdvancedAI.log("  - Eject mechanics (Button, Red Card, Pack)", "Items")
AdvancedAI.log("  - Air Balloon strategy", "Items")
AdvancedAI.log("  - Contact damage (Rocky Helmet, Iron Barbs)", "Items")

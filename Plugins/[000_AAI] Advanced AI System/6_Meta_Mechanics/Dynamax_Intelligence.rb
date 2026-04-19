#===============================================================================
# Advanced AI System - Dynamax Intelligence (DBK_005 Integration)
# Strategic Dynamax Timing and G-Max Optimization
#===============================================================================

class Battle::AI
  # Checks if Dynamax should be used
  def should_dynamax?(user, skill)
    AdvancedAI.log("should_dynamax? called for #{user.name} (skill #{skill})", "Dynamax")
    
    if skill < 95
      AdvancedAI.log("  ❌ Skill too low (#{skill} < 95)", "Dynamax")
      return false
    end
    
    unless AdvancedAI.dbk_enabled?(:dynamax)
      AdvancedAI.log("  ❌ DBK Dynamax not enabled", "Dynamax")
      return false
    end
    
    # Check if Dynamax is available for this battler
    # Note: user is an AIBattler, so we use the battle's method with the index
    unless @battle.pbCanDynamax?(user.index)
      # Detailed diagnostics: which sub-check is failing?
      begin
        battler = @battle.battlers[user.index]
        AdvancedAI.log("  ❌ @battle.pbCanDynamax? returned false — diagnostics:", "Dynamax")
        AdvancedAI.log("    battler: #{battler&.name} idx=#{user.index}", "Dynamax")
        if battler
          pkmn = battler.pokemon
          AdvancedAI.log("    pokemon.dynamax_lvl = #{pkmn&.respond_to?(:dynamax_lvl) ? pkmn.dynamax_lvl : 'N/A'}", "Dynamax")
          AdvancedAI.log("    pokemon.dynamax_able? = #{pkmn&.respond_to?(:dynamax_able?) ? pkmn.dynamax_able? : 'N/A'}", "Dynamax")
          AdvancedAI.log("    pokemon.can_dynamax? = #{pkmn&.respond_to?(:can_dynamax?) ? pkmn.can_dynamax? : 'N/A'}", "Dynamax")
          AdvancedAI.log("    battler.hasDynamax? = #{battler.respond_to?(:hasDynamax?) ? battler.hasDynamax? : 'N/A'}", "Dynamax")
          if battler.respond_to?(:pbDynamaxAvailable?)
            AdvancedAI.log("    battler.pbDynamaxAvailable? = #{battler.pbDynamaxAvailable?}", "Dynamax")
          end
          if battler.respond_to?(:getActiveState)
            AdvancedAI.log("    battler.getActiveState = #{battler.getActiveState.inspect}", "Dynamax")
          end
          AdvancedAI.log("    NO_DYNAMAX switch (#{Settings::NO_DYNAMAX}) = #{$game_switches[Settings::NO_DYNAMAX]}", "Dynamax")
          AdvancedAI.log("    DYNAMAX_ON_ANY_MAP switch (#{Settings::DYNAMAX_ON_ANY_MAP}) = #{$game_switches[Settings::DYNAMAX_ON_ANY_MAP]}", "Dynamax")
          if $game_map
            map_data = GameData::MapMetadata.try_get($game_map.map_id) rescue nil
            has_power_spot = map_data&.respond_to?(:has_flag?) ? map_data.has_flag?("PowerSpot") : false
            AdvancedAI.log("    Map #{$game_map.map_id} has PowerSpot? = #{has_power_spot}", "Dynamax")
          end
          AdvancedAI.log("    pbHasDynamaxBand? = #{@battle.pbHasDynamaxBand?(user.index)}", "Dynamax")
          side = battler.idxOwnSide
          owner = @battle.pbGetOwnerIndexFromBattlerIndex(user.index)
          AdvancedAI.log("    @dynamax[#{side}][#{owner}] = #{@battle.dynamax[side][owner]}", "Dynamax")
        end
      rescue => e
        AdvancedAI.log("  Diagnostics error: #{e.message}", "Dynamax")
      end
      return false
    end
    
    if user.dynamax?
      AdvancedAI.log("  ❌ Already Dynamaxed", "Dynamax")
      return false
    end
    
    AdvancedAI.log("  ✅ All checks passed - calculating score", "Dynamax")
    score = calculate_dynamax_score(user, skill)
    
    # Wild Pokemon bonus (for testing/balance)
    if @battle.wildBattle?
      score += 10
      AdvancedAI.log("  Wild Pokemon bonus: +10", "Dynamax")
    end
    
    AdvancedAI.log("Dynamax score for #{user.pbThis}: #{score}", "Dynamax")
    
    # Thresholds
    return true if score >= 100  # Excellent
    return true if score >= 70   # Strong  
    return true if score >= 50 && remaining_pokemon_count(user) <= 2  # Good + few remaining
    
    return false
  end
  
  private
  
  def calculate_dynamax_score(user, skill)
    score = 0
    
    # 1. TIMING CONTEXT (0-35)
    score += evaluate_dynamax_timing(user, skill)
    
    # 2. OFFENSIVE VALUE (0-40)
    score += evaluate_dynamax_offensive(user, skill)
    
    # 3. SWEEP POTENTIAL (0-35)
    score += evaluate_dynamax_sweep(user, skill)
    
    # 4. SURVIVAL VALUE (0-45)
    score += evaluate_dynamax_survival(user, skill)
    
    # 5. PARTY COMPARISON (0 bis -25)
    score += evaluate_dynamax_party(user, skill)
    
    # 6. BATTLE MOMENTUM (0-30)
    score += evaluate_dynamax_momentum(user, skill)
    
    return score
  end
  
  # 1. Timing Context
  def evaluate_dynamax_timing(user, skill)
    score = 0
    turn = @battle.turnCount
    
    if turn <= 3
      # Early Game: Only for G-Max Steelsurge or Threat
      if user.gmax_move?(:STEELSURGE)
        score += 25
      elsif user.hp < user.totalhp * 0.4
        score += 20
      else
        score -= 10
      end
    elsif turn <= 8
      # Mid Game: Optimal
      score += 20
    else
      # Late Game: Cleanup or Desperation
      enemy_count = alive_enemies_count(user)
      if enemy_count == 1
        score += 15  # Cleanup
      elsif user.hp < user.totalhp * 0.5
        score += 25  # Comeback attempt
      end
    end
    
    # Team State Penalties
    alive = remaining_pokemon_count(user)
    score -= 10 if alive >= 5  # Too early
    
    return score
  end
  
  # 2. Offensive Value
  def evaluate_dynamax_offensive(user, skill)
    score = 0
    
    # Multiple Damage Types
    move_types = user.moves.select { |m| m && m.damagingMove? }.map { |m| AdvancedAI::CombatUtilities.resolve_move_type(user, m) }.uniq
    score += move_types.count * 5
    
    # Strong Moves (80+ BP)
    strong_moves = user.moves.count { |m| m && m.damagingMove? && AdvancedAI::CombatUtilities.resolve_move_power(m) >= 80 }
    score += strong_moves * 3
    
    # Coverage against Enemies
    @battle.allOtherSideBattlers(user.index).each do |target|
      next unless target && !target.fainted?
      
      user.moves.each do |move|
        next unless move && move.damagingMove?
        # Calculate type effectiveness: move type vs target's types
        resolved_type = AdvancedAI::CombatUtilities.resolve_move_type(user, move)
        type_mod = Effectiveness.calculate(resolved_type, *target.pbTypes(true))
        score += 5 if Effectiveness.super_effective?(type_mod)
      end
    end
    
    # G-Max Moves Bonus
    score += 10 if user.gmax_factor?
    
    # Choice Item Escape
    if user.item && [:CHOICEBAND, :CHOICESCARF, :CHOICESPECS].include?(user.item_id)
      score += 15
    end
    
    return [score, 40].min
  end
  
  # 3. Sweep Potential
  def evaluate_dynamax_sweep(user, skill)
    score = 0
    
    # Existing Stat Boosts
    positive_boosts = user.stages.values.count { |stage| stage > 0 }
    if positive_boosts >= 3
      score += 15
    elsif positive_boosts >= 1
      score += 8
    end
    
    # Max Move Boost Potential
    # Only count moves whose Max Move versions give offensive/speed boosts
    boosting_max_types = [:FIRE, :WATER, :FIGHTING, :FLYING, :DARK, :STEEL,
                          :GROUND, :ROCK, :BUG, :GHOST, :POISON]
    max_moves_with_boosts = user.moves.count do |move|
      next false unless move && move.damagingMove?
      resolved_type = AdvancedAI::CombatUtilities.resolve_move_type(user, move)
      boosting_max_types.include?(resolved_type)
    end
    score += max_moves_with_boosts * 6
    
    # Speed Advantage
    faster_than_all = @battle.allOtherSideBattlers(user.index).all? do |target|
      next true unless target && !target.fainted?
      user.pbSpeed > target.pbSpeed
    end
    score += 10 if faster_than_all
    
    # Weak Enemies
    weak_enemies = @battle.allOtherSideBattlers(user.index).count do |target|
      next false unless target && !target.fainted?
      target.hp < target.totalhp * 0.4
    end
    score += weak_enemies * 4
    
    return [score, 35].min
  end
  
  # 4. Survival Value
  def evaluate_dynamax_survival(user, skill)
    score = 0
    hp_percent = user.hp.to_f / user.totalhp
    
    # Emergency HP Boost
    if hp_percent < 0.3
      score += 25
    elsif hp_percent < 0.5
      score += 15
    end
    
    # Prevent OHKO
    @battle.allOtherSideBattlers(user.index).each do |target|
      next unless target && !target.fainted?
      
      target.moves.each do |move|
        next unless move && move.damagingMove?
        
        rough_damage = calculate_rough_damage(move, target, user)
        if rough_damage >= user.hp
          score += 20  # Would be KO without Dynamax
          break
        end
      end
    end
    
    # Dynamax Immunities
    # OHKO Immunity
    @battle.allOtherSideBattlers(user.index).each do |target|
      next unless target && !target.fainted?
      has_ohko = target.moves.any? { |m| m && [:GUILLOTINE, :FISSURE, :SHEERCOLD, :HORNDRILL].include?(m.id) }
      score += 15 if has_ohko
    end
    
    # Remove Restrictions
    score += 10 if user.effects[PBEffects::Taunt] > 0
    score += 10 if user.effects[PBEffects::Torment]
    score += 10 if user.effects[PBEffects::NoRetreat]
    
    # Penalties
    score -= 30 if user.effects[PBEffects::PerishSong] > 0  # Waste
    
    return [score, 45].min
  end
  
  # 5. Party Comparison
  def evaluate_dynamax_party(user, skill)
    score = 0
    party = @battle.pbParty(user.index & 1)
    
    # Better Dynamax Candidates?
    better_candidates = party.count do |pkmn|
      next false if !pkmn || pkmn.fainted? || pkmn.egg?
      # Skip if this Pokemon is currently in battle
      next false if pkmn == user.pokemon
      
      # Higher Attack or Special Attack (compare base stats, not staged stats)
      pkmn.attack > (user.respond_to?(:pokemon) ? user.pokemon.attack : user.attack) ||
      pkmn.spatk > (user.respond_to?(:pokemon) ? user.pokemon.spatk : user.spatk)
    end
    
    if better_candidates > 0
      score -= [better_candidates * 10, 20].min
    end
    
    # Last Pokemon Bonus
    alive = remaining_pokemon_count(user)
    score += 15 if alive == 1
    
    return score
  end
  
  # 6. Battle Momentum
  def evaluate_dynamax_momentum(user, skill)
    score = 0
    
    # Current Momentum
    if user_has_momentum?(user)
      score += 10
    end
    
    # Opponent Setup Pressure
    @battle.allOtherSideBattlers(user.index).each do |target|
      next unless target && !target.fainted?
      
      positive_boosts = target.stages.values.count { |stage| stage > 0 }
      if positive_boosts >= 3
        score += 15
      elsif positive_boosts >= 1
        score += 8
      end
    end
    
    # G-Max Steelsurge Timing (if not yet set)
    if user.gmax_move?(:STEELSURGE)
      side = @battle.pbOwnedByPlayer?(user.index) ? @battle.sides[1] : @battle.sides[0]
      score += 10 unless side.effects[PBEffects::Steelsurge]
    end
    
    # Field Effect Control (terrain is a Symbol like :Electric, :None - not Ruby nil)
    if @battle.field.terrain && @battle.field.terrain != :None
      score += 5
    end
    
    return [score, 30].min
  end
  
  # === HELPER METHODS ===
  
  def remaining_pokemon_count(user)
        @battle.pbParty(user.index & 1).count { |p| p && !p.fainted? && !p.egg? }
  end
  
  def alive_enemies_count(user)
    # idxOwnSide is 0 for player side, 1 for opponent side.
    # We want the party of the OTHER side.
    own_side = user.respond_to?(:battler) ? user.battler.idxOwnSide : (user.index & 1)
    opp_index = 1 - own_side
    @battle.pbParty(opp_index).count { |p| p && !p.fainted? && !p.egg? }
  end
  
  def user_has_momentum?(user)
    # Simplified Momentum Check
    hp_advantage = user.hp.to_f / user.totalhp > 0.6
    stat_advantage = user.stages.values.sum > 0
    
    return hp_advantage && stat_advantage
  end
end

# Extended Battler Methods for Dynamax
class Battle::Battler
  def can_dynamax?
    return false unless defined?(Battle::Scene::USE_DYNAMAX_GRAPHICS)
    # Check if battle allows Dynamax OR if this Pokemon has dynamax_lvl (wild Pokemon)
    return true if @battle.pbCanDynamax?(@index)
    return true if @pokemon &&  @pokemon.dynamax_lvl && @pokemon.dynamax_lvl > 0
    return false
  end
  
  def dynamax?
    return false unless defined?(Battle::Scene::USE_DYNAMAX_GRAPHICS)
    return @pokemon&.dynamax? || false
  end
  
  def gmax?
    return false unless defined?(Battle::Scene::USE_DYNAMAX_GRAPHICS)
    return @pokemon&.gmax? || false
  end
  
  def gmax_move?(move_type)
    return false unless respond_to?(:gmax_factor?) && gmax_factor?
    # Check if this species actually has matches for the given G-Max move type
    gmax_moves = {
      :STEELSURGE => [:COPPERAJAH],
      :VOLCALITH  => [:COALOSSAL],
      :VINELASH   => [:VENUSAUR],
      :WILDFIRE   => [:CHARIZARD],
      :CANNONADE  => [:BLASTOISE],
      :WINDRAGE   => [:CORVIKNIGHT],
      :STONESURGE => [:DREDNAW],
      :TARTNESS   => [:FLAPPLE],
      :SWEETNESS  => [:APPLETUN],
      :SANDBLAST  => [:SANDACONDA],
      :STUNSHOCK  => [:TOXTRICITY],
      :CENTIFERNO => [:CENTISKORCH],
      :SMITE      => [:HATTERENE],
      :SNOOZE     => [:GRIMMSNARL],
      :FINALE     => [:ALCREMIE],
      :DEPLETION  => [:DURALUDON],
      :GRAVITAS   => [:ORBEETLE],
      :REPLENISH  => [:SNORLAX],
      :MALODOR    => [:GARBODOR],
      :MELTDOWN   => [:MELMETAL],
      :FOAMBURST  => [:KINGLER],
      :RESONANCE  => [:LAPRAS],
      :CUDDLE     => [:EEVEE],
      :TERROR     => [:GENGAR],
      :BEFUDDLE   => [:BUTTERFREE],
      :GOLDRUSH   => [:MEOWTH]
    }
    species_list = gmax_moves[move_type]
    return false unless species_list
    return species_list.any? { |s| self.isSpecies?(s) }
  end
end

# Extended AIBattler Methods for Dynamax
class Battle::AI::AIBattler
  def dynamax?
    return @battler.dynamax? if @battler.respond_to?(:dynamax?)
    return false
  end
  
  def gmax?
    return @battler.gmax? if @battler.respond_to?(:gmax?)
    return false
  end
  
  def gmax_factor?
    return @battler.gmax_factor? if @battler.respond_to?(:gmax_factor?)
    return false
  end
  
  def gmax_move?(type_symbol)
    return @battler.gmax_move?(type_symbol) if @battler.respond_to?(:gmax_move?)
    return false
  end
  
  # Delegate common battler methods used in scoring
  def hp
    return @battler.hp if @battler
    return 0
  end
  
  def totalhp
    return @battler.totalhp if @battler
    return 1
  end
  
  def item
    return @battler.item if @battler.respond_to?(:item)
    return nil
  end
  
  def item_id
    return @battler.item_id if @battler.respond_to?(:item_id)
    return nil
  end
  
  def moves
    return @battler.moves if @battler
    return []
  end
  
  def stages
    return @battler.stages if @battler.respond_to?(:stages)
    return {}
  end
  
  def pbSpeed
    return @battler.pbSpeed if @battler.respond_to?(:pbSpeed)
    return 0
  end
  
  def attack
    return @battler.attack if @battler.respond_to?(:attack)
    return 0
  end
  
  def defense
    return @battler.defense if @battler.respond_to?(:defense)
    return 0
  end
  
  def spatk
    return @battler.spatk if @battler.respond_to?(:spatk)
    return 0
  end
  
  def spdef
    return @battler.spdef if @battler.respond_to?(:spdef)
    return 0
  end
  
  def pbThis(lowercase = false)
    return @battler.pbThis(lowercase) if @battler.respond_to?(:pbThis)
    return "Pokemon"
  end
  
  def name
    return @battler.name if @battler.respond_to?(:name)
    return "Pokemon"
  end
end

AdvancedAI.log("Dynamax Intelligence loaded (DBK_005)", "Dynamax")

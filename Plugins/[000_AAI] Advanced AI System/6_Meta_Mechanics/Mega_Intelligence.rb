#===============================================================================
# Advanced AI System - Mega Intelligence
# Logic for optimal Mega Evolution timing
#===============================================================================

class Battle::AI
  # Main entry point for checking Mega Evolution
  def should_mega_evolve?(user, skill)
    return false unless user.can_mega_evolve?
    return false if user.mega?
    
    # Base score
    score = 0
    
    # 1. Stat Increase Value
    score += evaluate_mega_stats(user)
    
    # 2. Ability Change Value
    score += evaluate_mega_ability(user)
    
    # 3. Type Change Value
    score += evaluate_mega_type(user)
    
    # 4. Turn Context
    score += evaluate_mega_context(user, skill)
    
    AdvancedAI.log("Mega Eval for #{user.pbThis}: Score #{score}", "Mega")
    
    # Thresholds
    return true if score >= 20  # Good value
    return true if user.hp <= user.totalhp * 0.5 && score > 0 # Desperation
    
    return false
  end
  
  private
  
  def evaluate_mega_stats(user)
    score = 0
    # Retrieve Mega Form data (assumed to be form + 1 or linked via item)
    # Since we can't easily peek at the specific Mega stats without transforming,
    # we assume Mega Evolution is generally beneficial stats-wise (approx +100 BST).
    score += 15 
    return score
  end
  
  def evaluate_mega_ability(user)
    score = 0
    current_ability = user.ability_id
    
    # Predict Mega Ability (Simplified: We know specific powerful Megas)
    # Ideally we'd look up the species form data, but for now we apply heuristics
    
    # Examples of abilities YOU WANT immediately
    # Drizzle, Drought, Snow Warning, Sand Stream (Weather wars)
    # Intimidate (Attack drop)
    # Speed Boost
    
    # This requires looking up the form's ability if possible.
    # In Essentials, we can try to find the standard Mega form.
    mega_form_id = user.pokemon.getMegaForm
    if mega_form_id > 0
      mega_species = GameData::Species.get_species_form(user.species, mega_form_id)
      mega_abil = mega_species.abilities.first
      
      if mega_abil != current_ability
        # Weather setting abilities are high priority on turn 1
        if [:DRIZZLE, :DROUGHT, :SNOWWARNING, :SANDSTREAM].include?(mega_abil)
          score += 25
          # Don't override if we already have the weather we want
          if (@battle.pbWeather == :Sun && mega_abil == :DROUGHT) ||
             (@battle.pbWeather == :Rain && mega_abil == :DRIZZLE)
             score -= 20
          end
        end
        
        # Power boosts
        if [:HUGEPOWER, :PUREPOWER, :ADAPTABILITY, :TOUGHCLAWS].include?(mega_abil)
          score += 20
        end
        
        # Defensive
        if [:MAGICBOUNCE, :INTIMIDATE].include?(mega_abil)
          score += 15
        end
      end
    end
    
    return score
  end
  
  def evaluate_mega_type(user)
    score = 0
    # Check if type changes and if that's good against current targets
    return score
  end
  
  def evaluate_mega_context(user, skill)
    score = 0
    # Almost always good to Mega Evolve immediately to get the stat boosts
    # unless we specifically want to hold off (e.g. keeping a specific resistance)
    
    # Default aggressive: Mega Evolve early
    score += 10
    
    return score
  end
end

class Battle::AI::AIBattler
  def can_mega_evolve?
    return @battler.can_mega_evolve? if @battler.respond_to?(:can_mega_evolve?)
    # Fallback: check via battle reference
    return false unless @battler && @battler.battle
    return @battler.battle.pbCanMegaEvolve?(@battler.index) rescue false
  end
  
  def mega?
    return @battler.mega? if @battler.respond_to?(:mega?)
    return false
  end
end

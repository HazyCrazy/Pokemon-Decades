#===============================================================================
# Advanced AI System - DBK Compatibility Patches
# Makes DBK gimmicks work for wild Pokemon with attributes set (as documented)
#===============================================================================
# [DBK] Deluxe Battle Kit Compatibility Patches
#===============================================================================
# Fixes DBK AI trying to access statDown/statUp on Unimplemented moves
class Battle::Move
  def statDown
    return []
  end unless method_defined?(:statDown)

  def statUp
    return []
  end unless method_defined?(:statUp)
end

#===============================================================================

#===============================================================================
# Dynamax Compatibility
# Allows wild Pokemon with dynamax_lvl > 0 to Dynamax (as per DBK docs)
#===============================================================================
# Only apply patch if the FULL Dynamax plugin is installed (not just placeholder)
# DBK_000 defines a parameterless placeholder: def hasDynamax?; return false; end
# DBK_005 defines the real method: def hasDynamax?(check_available = true)
# We check arity to distinguish: arity == 0 means placeholder, arity == -1 means real
if defined?(Battle::Battler) && Battle::Battler.method_defined?(:hasDynamax?) &&
   Battle::Battler.instance_method(:hasDynamax?).arity != 0
  class Battle::Battler
    alias aai_compat_hasDynamax? hasDynamax?
    def hasDynamax?(check_available = true)
      # Wild Pokemon with dynamax_lvl set should be eligible
      # Check if method exists to prevent crash if simple DBK is installed without Dynamax
      if wild? && @pokemon&.respond_to?(:dynamax_lvl) && @pokemon.dynamax_lvl && @pokemon.dynamax_lvl > 0
        AdvancedAI.log("  ✅ Wild Pokemon hasDynamax? override - has dynamax_lvl!", "Compatibility")
        return true
      end
      
      # Otherwise use original logic
      aai_compat_hasDynamax?(check_available)
    end
  end
  
  AdvancedAI.log("DBK hasDynamax? compatibility patch applied", "Compatibility")
end

if defined?(Battle) && Battle.method_defined?(:pbCanDynamax?)
  class Battle
    alias aai_compat_pbCanDynamax? pbCanDynamax?
    def pbCanDynamax?(idxBattler)
      battler = @battlers[idxBattler]
      
      # Special case: Wild Pokemon with dynamax_lvl set can Dynamax
      # This makes DBK work as documented in its tutorial
      if battler.wild? && battler.pokemon&.respond_to?(:dynamax_lvl) && battler.pokemon.dynamax_lvl && battler.pokemon.dynamax_lvl > 0
        AdvancedAI.log("  ✅ Wild Pokemon has dynamax_lvl, allowing Dynamax!", "Compatibility")
        # Still need to pass other checks (not in Sky Drop, etc.)
        if !battler.hasDynamax?
          AdvancedAI.log("  ❌ FAILED: battler.hasDynamax? returned false", "Compatibility")
          return false
        end
        AdvancedAI.log("  ✅ Passed hasDynamax check", "Compatibility")
        
        if battler.effects[PBEffects::SkyDrop] >= 0
          AdvancedAI.log("  ❌ FAILED: In Sky Drop", "Compatibility")
          return false
        end
        AdvancedAI.log("  ✅ Passed Sky Drop check", "Compatibility")
        
        # Check dyna slots if they exist
        if @dynamax
          side  = battler.idxOwnSide
          owner = pbGetOwnerIndexFromBattlerIndex(idxBattler)
          result = @dynamax[side][owner] == -1
          AdvancedAI.log("  Dynamax slot check: @dynamax[#{side}][#{owner}] == -1 ? #{result}", "Compatibility")
          return result
        end
        return true
      end
      
      # Otherwise use original logic
      aai_compat_pbCanDynamax?(idxBattler)
    end
  end
  
  AdvancedAI.log("DBK Dynamax compatibility patch applied", "Compatibility")
end

#===============================================================================
# Terastallization Compatibility
# Allows wild Pokemon with tera_type set to Terastallize (similar to Dynamax)
#===============================================================================

# Patch Pokemon#tera_type to return the set value for wild Pokemon
if defined?(Pokemon) && Pokemon.method_defined?(:tera_type)
  class Pokemon
    alias aai_compat_tera_type tera_type
    def tera_type
      # If @tera_type is explicitly set (e.g., via editWildPokemon), return it
      # This allows wild Pokemon to have their tera_type even if !terastal_able?
      if @tera_type && !@tera_type.nil?
        return @tera_type
      end
      # Otherwise use original logic
      aai_compat_tera_type
    end
    
    # Only alias/override if method exists
    if method_defined?(:terastallized=)
      alias aai_compat_terastallized= terastallized=
      def terastallized=(value)
        # If we have an explicit tera type (wild pokemon case), bypass the terastal_able check
        # ensuring the state persists (form change, icon, etc.)
        if @tera_type && !@tera_type.nil?
          @terastallized = value
          if @terastallized
            self.makeTerastalForm if respond_to?(:makeTerastalForm)
          else
            self.makeUnterastal if respond_to?(:makeUnterastal)
          end
          return
        end
        
        self.aai_compat_terastallized = value
      end
    end
    
    # FIX: Ensure tera? returns state, overriding any DBK placeholders
    def tera?
      return @terastallized
    end

    # FIX: Ensure dynamax? returns state, overriding any DBK placeholders
    def dynamax?
      return @dynamax
    end
    
    # FIX: Track if tera type was explicitly set (e.g. by battle rule)
    attr_accessor :explicit_tera_type
    
    if method_defined?(:tera_type=)
      alias aai_compat_tera_type= tera_type=
      def tera_type=(value)
        self.aai_compat_tera_type = value
        @explicit_tera_type = true
      end
    else
      # Define it if missing (DBK Tera not installed)
      def tera_type=(value)
        @tera_type = value
        @explicit_tera_type = true
      end
    end
  end
  
  AdvancedAI.log("DBK Pokemon#tera_type compatibility patch applied", "Compatibility")
end

if defined?(Battle::Battler) && Battle::Battler.method_defined?(:tera_type)
  class Battle::Battler
    alias aai_compat_battler_tera_type tera_type
    def tera_type
      # For wild Pokemon with explicitly set tera_type, return it directly
      if wild? && @pokemon&.instance_variable_get(:@tera_type)
        return @pokemon.instance_variable_get(:@tera_type)
      end
      # Otherwise use original logic
      aai_compat_battler_tera_type
    end
    
    # Debug logging for unTera - ONLY check if unTera exists
    if method_defined?(:unTera)
      alias aai_compat_unTera unTera
      def unTera(teraBreak = false)
        aai_compat_unTera(teraBreak)
      end
    end
  end
  
  AdvancedAI.log("DBK Battle::Battler#tera_type compatibility patch applied", "Compatibility")
end

if defined?(Battle::Battler) && Battle::Battler.method_defined?(:hasTera?)
  class Battle::Battler
    alias aai_compat_hasTera? hasTera?
    def hasTera?(check_available = true)
      # If this is a wild Pokemon with tera_type set, allow it
      # This makes the documented editWildPokemon behavior work
      if wild? && @pokemon&.respond_to?(:tera_type) && @pokemon.tera_type && !@pokemon.tera_type.nil?
        # Still check other restrictions
        return false if shadowPokemon?
        return false if @battle.raidBattle? && @battle.raidRules[:style] != :Tera
        return false if @pokemon.respond_to?(:hasTerastalForm?) && @pokemon.hasTerastalForm? && @effects[PBEffects::Transform]
        return false if @effects[PBEffects::TransformPokemon]&.respond_to?(:hasTerastalForm?) && @effects[PBEffects::TransformPokemon]&.hasTerastalForm?
        return false if !getActiveState.nil?
        
        # Check if hasEligibleAction exists and use it safely
        if respond_to?(:hasEligibleAction?)
           return false if hasEligibleAction?(:mega, :primal, :zmove, :ultra, :dynamax, :style, :zodiac)
        end

        side  = self.idxOwnSide
        owner = @battle.pbGetOwnerIndexFromBattlerIndex(@index)
        if @battle.respond_to?(:terastallize) && @battle.terastallize
           return false if check_available && @battle.terastallize[side][owner] == -2
        end
        return true
      end
      
      # Otherwise use original logic
      aai_compat_hasTera?(check_available)
    end

    # FIX: Ensure tera? delegates to pokemon, overriding placeholders
    def tera?
      return @pokemon&.tera?
    end

    # FIX: Ensure dynamax? delegates to pokemon, overriding placeholders
    def dynamax?
      return @pokemon&.dynamax?
    end
    
    # FIX: Override tera_type to bypass terastal_able? check
    # The issue: Pokemon#tera_type returns nil if terastal_able? is false,
    # but @tera_type is correctly set from PBS data. This causes hasTera? to fail.
    # Solution: Directly return the stored @tera_type value for trainer Pokemon.
    def tera_type
      return nil if !@pokemon
      # For trainer Pokemon, directly return the stored tera_type
      if !wild?
        stored_tera = @pokemon.instance_variable_get(:@tera_type)
        return stored_tera if stored_tera
      end
      # For wild Pokemon or if no stored value, use original logic
      return @pokemon.tera_type
    end
  end
  
  AdvancedAI.log("DBK Terastallization compatibility patch applied", "Compatibility")
end

# Also patch Battle#pbCanTerastallize? for wild Pokemon
if defined?(Battle) && Battle.method_defined?(:pbCanTerastallize?)
  class Battle
    alias aai_compat_pbCanTerastallize? pbCanTerastallize?
    def pbCanTerastallize?(idxBattler)
      battler = @battlers[idxBattler]
      
      # Special case: Wild Pokemon
      if battler.wild?
         # 1. Must have explicit tera type (set via editWildPokemon)
         return false unless battler.pokemon.respond_to?(:explicit_tera_type) && battler.pokemon.explicit_tera_type
         
         # 2. Must pass standard checks
         return false if !battler.hasTera?
         return false if battler.tera?
         
         # 3. Slot check (is someone else terastallized?)
         side  = battler.idxOwnSide
         owner = pbGetOwnerIndexFromBattlerIndex(idxBattler)
         # In DBK, -1 means available, 0+ means used/active index, -2 means disabled?
         if @terastallize
            return true if @terastallize[side][owner] == -1
         else
            return true
         end
         
         return false
      end
      
      # Otherwise use original logic (Trainer)
      return aai_compat_pbCanTerastallize?(idxBattler)
    end
  end
  
  #=============================================================================
  # Patch [DBK] Enhanced Battle UI to allow Wild Tera Icons
  #=============================================================================
  if defined?(Battle::Scene) && Battle::Scene.method_defined?(:pbAddTypesDisplay)
    class Battle::Scene
      # Override pbAddTypesDisplay to allow wild pokemon strict check bypass
      # We cannot alias because we need to change a specific line in the middle
      def pbAddTypesDisplay(xpos, ypos, battler, poke)
        return unless battler && poke
        
        #---------------------------------------------------------------------------
        # Gets display types (considers Illusion)
        illusion = battler.effects[PBEffects::Illusion] && !battler.pbOwnedByPlayer?
        
        is_tera = battler.respond_to?(:tera?) && battler.tera?
        
        if is_tera
          displayTypes = (illusion) ? poke.types.clone : battler.pbPreTeraTypes
        elsif illusion
          displayTypes = poke.types.clone
          displayTypes.push(battler.effects[PBEffects::ExtraType]) if battler.effects[PBEffects::ExtraType]
        else
          displayTypes = battler.pbTypes(true)
        end
        #---------------------------------------------------------------------------
        # Displays the "???" type on newly encountered species, or battlers with no typing.
        if Settings::SHOW_TYPE_EFFECTIVENESS_FOR_NEW_SPECIES
          unknown_species = false
        else
          unknown_species = !(
            !@battle.internalBattle ||
            battler.pbOwnedByPlayer? ||
            $player.pokedex.owned?(poke.species) ||
            $player.pokedex.battled_count(poke.species) > 0
          )
        end
        displayTypes = [:QMARKS] if unknown_species || displayTypes.empty?
        #---------------------------------------------------------------------------
        # Draws each display type. Maximum of 3 types.
        typeY = (displayTypes.length >= 3) ? ypos + 6 : ypos + 34
        
        # FIX: Re-applied correct path and rescue - User's file was missing
        begin
          path = "Graphics/Battle/icon_types" 
          # Check if existing path provided by user exists, else fallback
          if !pbResolveBitmap(path)
             path = "Graphics/UI/types"
          end
          typebitmap = AnimatedBitmap.new(_INTL(path))

          displayTypes.each_with_index do |type, i|
            break if i > 2
            type_number = GameData::Type.get(type).icon_position
            type_rect = Rect.new(0, type_number * 28, 64, 28)
            @enhancedUIOverlay.blt(xpos + 170, typeY + (i * 30), typebitmap.bitmap, type_rect)
          end
        rescue => e
          AdvancedAI.log("Error loading type icons (non-fatal): #{e.message}", "Compatibility")
        end

        #---------------------------------------------------------------------------
        # Draws Tera type.
        if is_tera
          showTera = true
        else
          # ORIGINAL: showTera = defined?(battler.tera_type) && battler.pokemon.terastal_able?
          # FIXED: Allow wild pokes with tera_type SAFE CHECK
          showTera = false
          if battler.respond_to?(:tera_type) && battler.pokemon
             has_tera_type = battler.pokemon.respond_to?(:tera_type) && !battler.pokemon.tera_type.nil?
             is_able = battler.pokemon.respond_to?(:terastal_able?) && battler.pokemon.terastal_able?
             
             if is_able || (battler.wild? && has_tera_type)
               showTera = true
             end
          end
          
          showTera = ((@battle.internalBattle) ? !battler.opposes? : true) if showTera
        end
        
        if showTera
          pkmn = (illusion) ? poke : battler
          begin
            pbDrawImagePositions(@enhancedUIOverlay, [[@path + "info_extra", xpos + 182, ypos + 95]])
            pbDisplayTeraType(pkmn, @enhancedUIOverlay, xpos + 186, ypos + 97, true)
          rescue => e
             AdvancedAI.log("Error displaying Tera Type: #{e.message}", "Compatibility")
          end
        end
      end
    end
    AdvancedAI.log("DBK Enhanced Battle UI pbAddTypesDisplay compatibility patch applied", "Compatibility")
  end
  
  AdvancedAI.log("DBK pbCanTerastallize? compatibility patch applied", "Compatibility")
end

AdvancedAI.log("DBK Compatibility patches loaded", "Compatibility")

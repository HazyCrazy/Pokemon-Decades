class PokemonDexNav_Scene

  def pbUpdate
    pbUpdateSpriteHash(@sprites)
  end

  def pbStartScene
    @sprites = {}
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99999
    @sprites["background"] = IconSprite.new(0, 0, @viewport)
    @sprites["background"].setBitmap("Graphics/UI/DexNav/bg")
    @typebitmap = AnimatedBitmap.new(_INTL("Graphics/UI/DexNav/types"))
    pbShowEncounters
    if @is_grass
      @sprites["pointer"] = IconSprite.new(12, 251, @viewport)
    else
      @sprites["pointer"] = IconSprite.new(12, 74, @viewport)
    end
    @sprites["pointer"].setBitmap("Graphics/UI/DexNav/pointer")
    @sprites["pointer"].z = 1
    @sprites["overlay"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
    @sprites["overlay2"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
    @active_ability_id = 0
    updateInfoBox
    pbDeactivateWindows(@sprites)
    pbFadeInAndShow(@sprites)
  end

  def pbEndScene
    pbFadeOutAndHide(@sprites)
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end

  # Displays the active species in the DexNav
  def showActiveSpecies
    species = Pokemon.new(@active_species, 1)
    overlay = @sprites["overlay"].bitmap
    seen = $player.pokedex.seen?(@active_species)
    owned = $player.pokedex.owned?(@active_species)
    types = seen ? species.types : [:UNKNOWN]
    base    = Color.new(64, 64, 64)
    shadow  = Color.new(176, 176, 176)
    if types.length == 1
      type_number = Constant::TYPES_NUMBERS[types[0]]
      typerect = Rect.new(0, type_number * 32, 64, 32)
      overlay.blt(393, 61, @typebitmap.bitmap, typerect)
    end
    if types.length == 2
      type_number = Constant::TYPES_NUMBERS[types[0]]
      typerect = Rect.new(0, type_number * 32, 64, 32)
      overlay.blt(347, 61, @typebitmap.bitmap, typerect)
      type_number = Constant::TYPES_NUMBERS[types[1]]
      typerect = Rect.new(0, type_number * 32, 64, 32)
      overlay.blt(440, 61, @typebitmap.bitmap, typerect)
    end
    name = seen ? species.name : "???"
    pbDrawTextPositions(@sprites["overlay"].bitmap, [[_INTL(name), 424, 40, 2, Color.new(255, 255, 255), Color.new(100, 100, 100)]])
    method = seen ? @is_grass ? "Walk" : "Surf" : "---"
    pbDrawTextPositions(@sprites["overlay2"].bitmap, [[_INTL(method), 347, 187, 0, base, shadow]])
    specieData = species.species_data
    dexnav = safeAccessDexNav
    search_level = dexnav.get_chain_level(@active_species)
    pbDrawTextPositions(@sprites["overlay2"].bitmap, [[_INTL(search_level.to_s), 347, 128, 0, base, shadow]])
    hidden_abilities = specieData.hidden_abilities
    @hidden_ability_list = []
    hidden_abilities.each do |ability|
      @hidden_ability_list.push(GameData::Ability.get(ability).name)
    end
    hiddenAbility = if owned
                      (!hidden_abilities.nil? && !hidden_abilities.empty?) ? @hidden_ability_list[@active_ability_id] : "None"
                    else
                      seen ? "???" : "---"
                    end
    #pbDrawTextPositions(@sprites["overlay2"].bitmap, [[_INTL(hiddenAbility), 347, 243, 0, base, shadow]])
	pbDrawTextPositions(@sprites["overlay2"].bitmap, [[_INTL("Use Ability Vial"), 347, 243, 0, base, shadow]])
    if @hidden_ability_list.length > 1
      baseHA = Color.new(255, 255, 255)
      shadowHA = nil
      x = 480
      y = 215
      if @active_ability_id == 0
        #pbDrawTextPositions(@sprites["overlay2"].bitmap, [[_INTL(">"), x + 14, y, 0, baseHA, shadowHA]])
      elsif @active_ability_id == (@hidden_ability_list.length - 1)
        #pbDrawTextPositions(@sprites["overlay2"].bitmap, [[_INTL("<"), x, y, 0, baseHA, shadowHA]])
      else
        #pbDrawTextPositions(@sprites["overlay2"].bitmap, [[_INTL("< >"), x, y, 0, baseHA, shadowHA]])
      end
    end
    itemCommon = owned ? specieData.wild_item_common[0] : seen ? "???" : "---"
    itemUncommon = owned ? specieData.wild_item_uncommon[0] : seen ? "???" : "---"
    itemRare = owned ? specieData.wild_item_rare[0] : seen ? "???" : "---"
    itemString = getItemString(itemCommon, itemUncommon, itemRare)
    itemX = 347
    itemY = 302
    percX = 501
    unless itemString.empty?
      itemString.each do |item|
        pbDrawTextPositions(@sprites["overlay2"].bitmap, [[_INTL(item[0]), itemX, itemY, 0, base, shadow]])
        pbDrawTextPositions(@sprites["overlay2"].bitmap, [[_INTL(item[1]), percX, itemY, 1, base, shadow]])
        itemY += 25
      end
    end


  end

  # Returns a string with the item name and its chance of being held.
  # The chances of holding the item for each rarity are 50%, 5% and 1% respectively.
  # If all three are the same item, then the chance of holding it is 100% instead.
  def getItemString(itemCommon, itemUncommon, itemRare)
    itemString = []
    if !itemCommon.nil? && !itemCommon.empty? && itemCommon == itemUncommon && itemCommon == itemRare
      perc = itemCommon == "---" ? "" : itemCommon == "???" ? "" : "100%"
      itemString.push([itemCommon.to_s.capitalize, perc])
    else
      unless itemCommon.nil?
        itemString.push([itemCommon.to_s.capitalize, "50%"])
      end
      unless itemUncommon.nil?
        itemString.push([itemUncommon.to_s.capitalize, "5%"])
      end
      unless itemRare.nil?
        itemString.push([itemRare.to_s.capitalize, "1%"])
      end
    end
    return itemString
  end

  def pbShowEncounters
    map_id = $game_map.map_id
    enc_list = getEncounterInfo(map_id)
    @land_list = pbGetEncounterAtTime(enc_list, Constant::ENCOUNTER_LAND)
    @water_list = pbGetEncounterAtTime(enc_list, Constant::ENCOUNTER_WATER)
    @act_list = @land_list.empty? ? @water_list : @land_list
    @active_species = !@act_list.empty? ? @act_list[0] : nil
    @cursor = 0
    @is_grass = !@land_list.empty?
    pbLoadSpeciesIcon(@land_list, 251)
    pbLoadSpeciesIcon(@water_list, 74)
  end

  def getEncounterInfo(mapID = nil)
    tableData = {}
    encounterData = GameData::Encounter.get(mapID, $PokemonGlobal.encounter_version)
    unless encounterData.nil?
      encounterTables = Marshal.load(Marshal.dump(encounterData.types))
      encounterTables.each do |type, enc|
        next if enc.empty?
        encounters = enc.map { |enc| enc[1] }.uniq
        tableData[type] = encounters
      end
    end
    return tableData
  end

  def pbLoadSpeciesIcon(list, iconY)
    iconX = 12
    # iconY = 251 land; iconY = 74 water
    list.each do |specie|
      icon = Pokemon.new(specie, 1)
      to_disp = $player.pokedex.seen?(specie)
      if to_disp
        @sprites["icon#{specie}"] = PokemonIconSprite.new(icon, @viewport)
      else
        @sprites["icon#{specie}"] = PokemonIconSprite.new(nil, @viewport)
      end
      @sprites["icon#{specie}"].x = iconX
      @sprites["icon#{specie}"].y = iconY
      iconX += 64
      if iconX > 320
        iconX = 12
        iconY += 64
      end
    end
  end

  def pbGetEncounterAtTime(enc, encounter_keys)
    # Check if the encounter is available at the current time of day
    ret = []
    (0..4).each { |i|
      if pbGetTimeDay(i)
        # Iterate through encounter types and add encounters based on time period
        encounter_keys.each do |type, keys|
          ret.concat(enc[keys[i]]) unless enc[keys[i]].nil?
        end
        break unless ret.empty?
      end
    }

    encounter_keys.each do |type, keys|
      next unless ret.empty?
      ret.concat(enc[type]) unless enc[type].nil?
    end

    ret.uniq!
    return ret
  end

  def updateInfoBox
    @sprites["overlay"].bitmap.clear
    @sprites["overlay2"].bitmap.clear
    pbSetSystemFont(@sprites["overlay"].bitmap)
    pbSetNarrowFont(@sprites["overlay2"].bitmap)
    printText
    if @active_species.nil?
      x = Graphics.width / 2
      y = Graphics.height / 2
      pbDrawTextPositions(@sprites["overlay"].bitmap, [[_INTL("No species in this area"), x, y, 2, Color.new(64, 64, 64), Color.new(176, 176, 176)]])
      @sprites["pointer"].dispose
    else
      showActiveSpecies
    end
  end

  def printText
    Constant::TEXTS.each do |key, params|
      if params[:to_print] == @is_grass
        pbDrawTextPositions(@sprites["overlay"].bitmap, [[params[:text], params[:x], params[:y], params[:align], params[:color], params[:shadow_color]]])
      end
    end
    Constant::TEXTS_SMALL.each do |key, params|
      pbDrawTextPositions(@sprites["overlay2"].bitmap, [[params[:text], params[:x], params[:y], params[:align], params[:color], params[:shadow_color]]])
    end
    dexnav = safeAccessDexNav
    pbDrawTextPositions(@sprites["overlay"].bitmap, [[_INTL("Chain: {1}", dexnav.active_chain), 380, 8, 0, Color.new(232, 32, 16), Color.new(248, 168, 184)]])
  end

  def pbDexnav
    ret = false
    loop do
      Graphics.update
      Input.update
      pbUpdate
      if Input.trigger?(Input::BACK)
        pbPlayCloseMenuSE
        break
      end
      unless @active_species.nil?
        oldCursor = @cursor
        if Input.trigger?(Input::LEFT)
          if @cursor == 5
            @sprites["pointer"].y -= 64
            @sprites["pointer"].x += (64 * 4)
            @cursor -= 1
          elsif @cursor > 0
            @cursor -= 1
            @sprites["pointer"].x -= 64
          end
        end
        if Input.trigger?(Input::RIGHT)
          border = @act_list.length - 1
          if @cursor == 4 && border != 4
            @sprites["pointer"].y += 64
            @sprites["pointer"].x -= (64 * 4)
            @cursor += 1
          elsif @cursor < border
            @cursor += 1
            @sprites["pointer"].x += 64
          end
        end
        if Input.trigger?(Input::UP)
          if @cursor > 4
            @cursor -= 5
            @sprites["pointer"].y -= 64
          end
        end
        if Input.trigger?(Input::DOWN)
          if (@cursor + 5) < @act_list.length
            @cursor += 5
            @sprites["pointer"].y += 64
          end
        end
        if oldCursor != @cursor
          pbPlayCursorSE
          @active_species = @act_list[@cursor]
          @active_ability_id = 0
          updateInfoBox
        end
        if Input.trigger?(Input::ACTION)
          if @is_grass && !@water_list.empty?
            @cursor = 0
            @act_list = @water_list
            @sprites["pointer"].y = 74
            pbPlayCursorSE
            @sprites["pointer"].x = 12
            @is_grass = false
          elsif !@land_list.empty?
            @cursor = 0
            @act_list = @land_list
            @sprites["pointer"].y = 251
            pbPlayCursorSE
            @sprites["pointer"].x = 12
            @is_grass = true
          end
          @active_species = @act_list[@cursor]
          @active_ability_id = 0
          updateInfoBox
        end
        if Input.trigger?(Input::USE)
          if $player.pokedex.seen?(@active_species)
            action = pbMessage(_INTL("What you want to do?"), [_INTL("Search"), _INTL("Register"), _INTL("Cancel")], 3)
            if action == 0
              pbPlayDecisionSE
              $game_switches[Settings::DEXNAX_HAS_REGISTERED_SWITCH_ID] = false
              saveActiveSpecies
              ret = true
              break
            end
            if action == 1
              pbPlayDecisionSE
              pbMessage(_INTL("{1} registered, press Ctrl to search.", @active_species.to_s.capitalize))
              $game_switches[Settings::DEXNAX_HAS_REGISTERED_SWITCH_ID] = true
              saveActiveSpecies
            end
            if action == 2
              pbPlayCancelSE
            end
          else
            pbMessage(_INTL("There is no option for this species yet."))
          end
        end
        #if Input.trigger?(Input::JUMPDOWN)
        #  if @hidden_ability_list.length > 1 && @active_ability_id != (@hidden_ability_list.length - 1)
        #    pbPlayCursorSE
        #    @active_ability_id += 1
        #    updateInfoBox
        #  end
        #end
        #if Input.trigger?(Input::JUMPUP)
        #  if @hidden_ability_list.length > 1 && @active_ability_id != 0
        #    pbPlayCursorSE
        #    @active_ability_id -= 1
        #    updateInfoBox
        #  end
        #end
      end
    end
    return ret
  end

  # Returns the current period of the day based on game switches
  # @return [Integer] period identifier (0:day, 1:night, 2:morning, 3:afternoon, 4:evening)
  def pbGetTimeDay(index)
    if index == 4
      return PBDayNight.isEvening?
    elsif index == 3
      return PBDayNight.isAfternoon?
    elsif index == 2
      return PBDayNight.isMorning?
    elsif index == 1
      return PBDayNight.isNight?
    elsif index == 0
      return PBDayNight.isDay?
    end
    return false
  end

  def saveActiveSpecies
    dexnav = safeAccessDexNav
    dexnav.set_active_species(@active_species, 15, @is_grass)
  end
end

class PokemonDexNavScreen
  def initialize(scene)
    @scene = scene
  end

  def pbStartScreen
    @scene.pbStartScene
    ret = @scene.pbDexnav
    @scene.pbEndScene
    return ret
  end
end

def pbCanViewDexNav?
  return $game_switches[Settings::ACCESS_DEXNAV_SWITCH_ID]
end


MenuHandlers.add(:pause_menu, :dexnav, {
  "name"      => _INTL("DexNav"),
  "order"     => 25,
  "condition" => proc { next pbCanViewDexNav? },
  "effect"    => proc { |menu|
    pbPlayDecisionSE
    out = nil
    pbFadeOutIn {
      scene = PokemonDexNav_Scene.new
      screen = PokemonDexNavScreen.new(scene)
      out = screen.pbStartScreen
      (out) ? menu.pbEndScene : menu.pbRefresh
    }
    next false unless out
    $game_temp.in_menu = false
    pbDexNavSearchEvent
    next true
  }
})
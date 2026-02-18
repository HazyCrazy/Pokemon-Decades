#===============================================================================
# Summary scene edits and additions to both visuals and function.
#===============================================================================
class PokemonSummary_Scene
  #-----------------------------------------------------------------------------
  # Rewritten for the display of modular pages.
  #-----------------------------------------------------------------------------
  def drawPage(page)
    setPages # Gets the list of pages and current page ID.
    suffix = UIHandlers.get_info(:summary, @page_id, :suffix)
    @sprites["background"].setBitmap("Graphics/UI/Summary/bg_#{suffix}")
    @sprites["pokemon"].setPokemonBitmap(@pokemon)
    @sprites["pokeicon"].pokemon = @pokemon
    @sprites["itemicon"].item = @pokemon.item_id
    overlay = @sprites["overlay"].bitmap
    overlay.clear
    base   = Color.new(248, 248, 248)
    shadow = Color.new(104, 104, 104)
    drawPageIcons # Draws the page icons.
    imagepos = []
    # Draws general page info.
    ballimage = sprintf("Graphics/UI/Summary/icon_ball_%s", @pokemon.poke_ball)
    imagepos.push([ballimage, 14, 60])
    pagename = UIHandlers.get_info(:summary, @page_id, :name)
    textpos = [
      [pagename, 26, 22, :left, base, shadow],
      [@pokemon.name, 46, 68, :left, base, shadow],
      [_INTL("Item"), 66, 324, :left, base, shadow]
    ]
    if @pokemon.hasItem?
      textpos.push([@pokemon.item.name, 16, 358, :left, Color.new(64, 64, 64), Color.new(176, 176, 176)])
    else
      textpos.push([_INTL("None"), 16, 358, :left, Color.new(192, 200, 208), Color.new(208, 216, 224)])
    end
    # Draws additional info for non-Egg Pokemon.
    if !@pokemon.egg?
      status = -1
      if @pokemon.fainted?
        status = GameData::Status.count - 1
      elsif @pokemon.status != :NONE
        status = GameData::Status.get(@pokemon.status).icon_position
      elsif @pokemon.pokerusStage == 1
        status = GameData::Status.count
      end
      if status >= 0
        imagepos.push(["Graphics/UI/statuses", 124, 100, 0, 16 * status, 44, 16])
      end
      if @pokemon.pokerusStage == 2
        imagepos.push(["Graphics/UI/Summary/icon_pokerus", 176, 100])
      end
      imagepos.push(["Graphics/UI/shiny", 2, 134]) if @pokemon.shiny?
      textpos.push([@pokemon.level.to_s, 46, 98, :left, Color.new(64, 64, 64), Color.new(176, 176, 176)])
      if @pokemon.male?
        textpos.push([_INTL("♂"), 178, 68, :left, Color.new(24, 112, 216), Color.new(136, 168, 208)])
      elsif @pokemon.female?
        textpos.push([_INTL("♀"), 178, 68, :left, Color.new(248, 56, 32), Color.new(224, 152, 144)])
      end
    end
    # Draws the page.
    pbDrawImagePositions(overlay, imagepos)
    pbDrawTextPositions(overlay, textpos)
    UIHandlers.call(:summary, @page_id, "layout", @pokemon, self)
    drawMarkings(overlay, 84, 292)
  end
  
  #-----------------------------------------------------------------------------
  # Edited to remove code that is now handled in def drawPage instead.
  #-----------------------------------------------------------------------------
  def drawPageOneEgg
    red_text_tag = shadowc3tag(RED_TEXT_BASE, RED_TEXT_SHADOW)
    black_text_tag = shadowc3tag(BLACK_TEXT_BASE, BLACK_TEXT_SHADOW)
    memo = ""
    if @pokemon.timeReceived
      date  = @pokemon.timeReceived.day
      month = pbGetMonthName(@pokemon.timeReceived.mon)
      year  = @pokemon.timeReceived.year
      memo += black_text_tag + _INTL("{1} {2}, {3}", date, month, year) + "\n"
    end
    mapname = pbGetMapNameFromId(@pokemon.obtain_map)
    mapname = @pokemon.obtain_text if @pokemon.obtain_text && !@pokemon.obtain_text.empty?
    if mapname && mapname != ""
      mapname = red_text_tag + mapname + black_text_tag
      memo += black_text_tag + _INTL("A mysterious Pokémon Egg received from {1}.", mapname) + "\n"
    else
      memo += black_text_tag + _INTL("A mysterious Pokémon Egg.") + "\n"
    end
    memo += "\n"
    memo += black_text_tag + _INTL("\"The Egg Watch\"") + "\n"
    eggstate = _INTL("It looks like this Egg will take a long time to hatch.")
    eggstate = _INTL("What will hatch from this? It doesn't seem close to hatching.") if @pokemon.steps_to_hatch < 10_200
    eggstate = _INTL("It appears to move occasionally. It may be close to hatching.") if @pokemon.steps_to_hatch < 2550
    eggstate = _INTL("Sounds can be heard coming from inside! It will hatch soon!") if @pokemon.steps_to_hatch < 1275
    memo += black_text_tag + eggstate
    drawFormattedTextEx(@sprites["overlay"].bitmap, 232, 86, 268, memo)
  end
  
  #-----------------------------------------------------------------------------
  # Rewritten so that the commands that appear in the Options menu are now
  # determined by which options are set in each page handler.
  # Also added new Gen 9 Options. (nickname and move-related options)
  #-----------------------------------------------------------------------------
  def pbOptions
    dorefresh = false
    commands = {}
    options = UIHandlers.get_info(:summary, @page_id, :options)
    options.each do |cmd|
      case cmd
      when :item
        commands[:item] = _INTL("Give item")
        commands[:take] = _INTL("Take item") if @pokemon.hasItem?
      when :nickname then commands[cmd] = _INTL("Nickname")      if Settings::MECHANICS_GENERATION >= 9 && !@pokemon.foreign?
      when :pokedex  then commands[cmd] = _INTL("View Pokédex")  if $player.has_pokedex
      when :moves    then commands[cmd] = _INTL("Check Moves")   if Settings::MECHANICS_GENERATION >= 9 && !@pokemon.moves.empty?
      when :remember then commands[cmd] = _INTL("Remember Move") if Settings::MECHANICS_GENERATION >= 9 && @pokemon.can_relearn_move?
      when :forget   then commands[cmd] = _INTL("Forget Move")   if Settings::MECHANICS_GENERATION >= 9 && @pokemon.moves.length > 1
      when :tms      then commands[cmd] = _INTL("Use TM's")      if Settings::MECHANICS_GENERATION >= 9 && $bag.has_compatible_tm?(@pokemon)
      when :mark     then commands[cmd] = _INTL("Mark")
      when String    then commands[cmd] = _INTL("#{cmd}")
      end
    end
    #---------------------------------------------------------------------------
    # Opens move selection if on the moves page and no options are available.
    #---------------------------------------------------------------------------
    if @page_id == :page_moves
      if commands.empty? || @inbattle
        pbMoveSelection
        @sprites["pokemon"].visible = true
        @sprites["pokeicon"].visible = false
        return true
      end
    end
    #---------------------------------------------------------------------------
    commands[:cancel] = _INTL("Cancel")
    command = pbShowCommands(commands.values)
    command_list = commands.clone.to_a
    case command_list[command][0]
    #---------------------------------------------------------------------------
    # Option commands.
    #---------------------------------------------------------------------------
    # [:item] Gives a held item to the Pokemon, or removes a held item.
    when :item      
      item = nil
      pbFadeOutIn do
        scene = PokemonBag_Scene.new
        screen = PokemonBagScreen.new(scene, $bag)
        item = screen.pbChooseItemScreen(proc { |itm| GameData::Item.get(itm).can_hold? })
      end
      dorefresh = pbGiveItemToPokemon(item, @pokemon, self, @partyindex) if item
    when :take      
      dorefresh = pbTakeItemFromPokemon(@pokemon, self)
    #---------------------------------------------------------------------------
    # [:nickname] Nicknames the Pokemon. (Gen 9+)
    when :nickname
      nickname = pbEnterPokemonName(_INTL("{1}'s nickname?", @pokemon.name), 0, Pokemon::MAX_NAME_SIZE, "", @pokemon, true)
      @pokemon.name = nickname
      dorefresh = true
    #---------------------------------------------------------------------------
    # [:pokedex] View the Pokedex entry for this Pokemon's species.
    when :pokedex   
      $player.pokedex.register_last_seen(@pokemon)
      pbFadeOutIn do
        scene = PokemonPokedexInfo_Scene.new
        screen = PokemonPokedexInfoScreen.new(scene)
        screen.pbStartSceneSingle(@pokemon.species)
      end
      dorefresh = true
    #---------------------------------------------------------------------------
    # [:moves] View and/or reorder this Pokemon's moves. (Gen 9+)
    when :moves     
      pbPlayDecisionSE
      pbMoveSelection
      @sprites["pokemon"].visible = true
      @sprites["pokeicon"].visible = false
      dorefresh = true
    #---------------------------------------------------------------------------
    # [:remember] Reteach this Pokemon a previously known move. (Gen 9+)
    when :remember
      pbRelearnMoveScreen(@pokemon)
      dorefresh = true
    #---------------------------------------------------------------------------
    # [:forget] Forget a currently known move. (Gen 9+)
    when :forget
      pbPlayDecisionSE	
      ret = -1
      @sprites["movesel"].visible = true
      @sprites["movesel"].index   = 0
      drawSelectedMove(nil, @pokemon.moves[0])
      loop do
        ret = pbChooseMoveToForget(nil)
        break if ret < 0
        #break if $DEBUG
		#break if $DEBUG || !@pokemon.moves[ret].hidden_move?
        #pbMessage(_INTL("HM moves can't be forgotten now.")) { pbUpdate }
		break if $DEBUG || !$DEBUG # Removes the shitty no HM Delete Mechanic. Soft Lock issues cannot happen in Pokemon Decades, unelss the player goes out of their way to make one happen. And they always have the No Clip Disk.
		pbMessage(_INTL("Talk to Field Deleters in Pokémon Centers, to remove this Field Move.")) { pbUpdate }
      end
      if ret >= 0
        old_move_name = @pokemon.moves[ret].name
        #pbMessage(_INTL("{1} forgot how to use {2}.", @pokemon.name, old_move_name))
        @pokemon.forget_move_at_index(ret)
      end
      @sprites["movesel"].visible = false
      @sprites["pokemon"].visible = true
      @sprites["pokeicon"].visible = false
      dorefresh = true
    #---------------------------------------------------------------------------
    # [:tms] Select a TM from your bag to use on this Pokemon. (Gen 9+)
    when :tms       
      item = nil
      pbFadeOutIn {
        scene  = PokemonBag_Scene.new
        screen = PokemonBagScreen.new(scene, $bag)
        item = screen.pbChooseItemScreen(Proc.new{ |itm|
          move = GameData::Item.get(itm).move  
          next false if !move || @pokemon.hasMove?(move) || !@pokemon.compatible_with_move?(move)
          next true
        })
      }
      if item
        pbUseItemOnPokemon(item, @pokemon, self)
        dorefresh = true
      end
    #---------------------------------------------------------------------------
    # [:mark] Put markings on this Pokemon.
    when :mark      
      dorefresh = pbMarking(@pokemon)
    #---------------------------------------------------------------------------
    # Custom options.
    else
      cmd = command_list[command][0]
      if cmd.is_a?(String)
        dorefresh = pbPageCustomOption(cmd)
      end
    end
    return dorefresh
  end

  #-----------------------------------------------------------------------------
  # Edited to allow Summary pages to loop with RIGHT/LEFT.
  # You may now also jump to the first/last in party with JUMPUP/JUMPDOWN.
  # You may now hold a directional key to continuously loop through pages.
  # The USE key now varies in function based on @page_id instead of @page number.
  #-----------------------------------------------------------------------------
  def pbScene
    @pokemon.play_cry
    loop do
      Graphics.update
      Input.update
      pbUpdate
      dorefresh = false
      if Input.trigger?(Input::ACTION)
        pbSEStop
        @pokemon.play_cry
        @show_back = !@show_back
        if PluginManager.installed?("[DBK] Animated Pokémon System")
          @sprites["pokemon"].setSummaryBitmap(@pokemon, @show_back)
        else
          @sprites["pokemon"].setPokemonBitmap(@pokemon, @show_back)
        end
      elsif Input.trigger?(Input::BACK)
        pbPlayCloseMenuSE
        break
      elsif Input.trigger?(Input::USE)
        dorefresh = pbPageCustomUse(@page_id)
        if !dorefresh
          case @page_id
          when :page_moves
            pbPlayDecisionSE
            dorefresh = pbOptions
          when :page_ribbons
            pbPlayDecisionSE
            pbRibbonSelection
            dorefresh = true
          else
            if !@inbattle
              pbPlayDecisionSE
              dorefresh = pbOptions
            end
          end
        end
      elsif Input.repeat?(Input::UP)
        oldindex = @partyindex
        pbGoToPrevious
        if @partyindex != oldindex
          pbChangePokemon
          @ribbonOffset = 0
          dorefresh = true
        end
      elsif Input.repeat?(Input::DOWN)
        oldindex = @partyindex
        pbGoToNext
        if @partyindex != oldindex
          pbChangePokemon
          @ribbonOffset = 0
          dorefresh = true
        end
      elsif Input.trigger?(Input::JUMPUP) && !@party.is_a?(PokemonBox)
        oldindex = @partyindex
        @partyindex = 0
        if @partyindex != oldindex
          pbChangePokemon
          @ribbonOffset = 0
          dorefresh = true
        end
      elsif Input.trigger?(Input::JUMPDOWN) && !@party.is_a?(PokemonBox)
        oldindex = @partyindex
        @partyindex = @party.length - 1
        if @partyindex != oldindex
          pbChangePokemon
          @ribbonOffset = 0
          dorefresh = true
        end
      elsif Input.repeat?(Input::LEFT)
        oldpage = @page
        numpages = @page_list.length
        @page -= 1
        @page = numpages if @page < 1
        @page = 1 if @page > numpages
        if @page != oldpage
          pbSEPlay("GUI summary change page")
          @ribbonOffset = 0
          dorefresh = true
        end
      elsif Input.repeat?(Input::RIGHT)
        oldpage = @page
        numpages = @page_list.length
        @page += 1
        @page = numpages if @page < 1
        @page = 1 if @page > numpages
        if @page != oldpage
          pbSEPlay("GUI summary change page")
          @ribbonOffset = 0
          dorefresh = true
        end
      end
      @show_back = false if dorefresh
      drawPage(@page) if dorefresh
    end
    return @partyindex
  end
end
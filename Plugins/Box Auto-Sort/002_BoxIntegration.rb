#===============================================================================
# Box Auto-Sort - Box Integration
#===============================================================================

module BoxAutoSort
  # Main sort menu
  def self.show_sort_menu(storage, current_box = nil)
    current_box ||= storage.currentBox
    
    commands = [
      _INTL("Level (Low to High)"),
      _INTL("Level (High to Low)"),
      _INTL("Alphabetical (A-Z)"),
      _INTL("Alphabetical (Z-A)"),
      _INTL("Primary Type"),
      _INTL("Type Combination"),
      _INTL("Catch Date"),
      _INTL("Shiny First"),
      _INTL("National Dex"),
      _INTL("Forms"),
      _INTL("Friendship"),
      _INTL("Nature"),
      _INTL("Cancel")
    ]
    
    choice = pbMessage(_INTL("How would you like to sort this box?"), commands, commands.length - 1)
    
    return if choice < 0 || choice >= commands.length - 1
    
    sort_method = case choice
    when 0 then :LEVEL_ASC
    when 1 then :LEVEL_DESC
    when 2 then :ALPHABET
    when 3 then :ALPHABET_REV
    when 4 then :TYPE_PRIMARY
    when 5 then :TYPE_DUAL
    when 6 then :CATCH_DATE
    when 7 then :SHINY_FIRST
    when 8 then :SPECIES_ID
    when 9 then :FORM_ID
    when 10 then :FRIENDSHIP
    when 11 then :NATURE
    end
    
    perform_sort(storage, current_box, sort_method)
  end

  # Perform sorting
  def self.perform_sort(storage, box, method)
    sorter = BoxSorter.new(storage, box)
    
    # Show preview
    preview_list = sorter.preview_sort(method)
    if preview_list.empty?
      pbMessage("This box is empty!")
      return
    end
    
    # Create preview text (show only first 8 Pokemon)
    #preview_count = [preview_list.length, 8].min
	#preview_count = [preview_list.length, 1].min
    #preview_text = "Preview of first #{preview_count} Pokémon:\n"
    #preview_list[0, preview_count].each_with_index do |pokemon_data, i|
    #  pokemon = pokemon_data[0]  # Pokemon is the first element in the array
    #  name = pokemon.name
    #  level = pokemon.level
      #preview_text += "#{i+1}. #{name} (Lv.#{level})\n"
    #end
    #preview_text += "\nWould you like to apply this sorting?"
	preview_text = "Apply Sorting Preset?"
    
    if pbConfirmMessage(preview_text)
      #pbMessage("Sorting box...")
      success = sorter.sort_pokemon(method)
      if success
        pbMessage("Box has been sorted!")
        pbPlayDecisionSE
      else
        pbMessage("Sorting failed!")
        pbPlayBuzzerSE
      end
    end
  end
end

# =============================================================================
# PC MENU INTEGRATION - Direct Access
# =============================================================================

MenuHandlers.add(:pc_menu, :box_auto_sort, {
  "name"      => _INTL("Box Auto-Sort"),
  "order"     => 15,
  "effect"    => proc { |menu|
    pbMessage("\\se[PC access]" + _INTL("Box Auto-Sort System opened."))
    
    # Select box
    commands = []
    $PokemonStorage.maxBoxes.times do |i|
      box = $PokemonStorage[i]
      if box
        commands.push(_INTL("{1} ({2}/{3})", box.name, box.nitems, box.length))
      end
    end
    commands.push(_INTL("Cancel"))
    
    choice = pbMessage(_INTL("Which box to sort?"), commands, commands.length - 1)
    
    if choice >= 0 && choice < $PokemonStorage.maxBoxes
      selected_box = choice
      BoxAutoSort.show_sort_menu($PokemonStorage, selected_box)
    end
    
    next false
  }
})

# =============================================================================
# DIRECT OVERRIDE - Loads immediately!
# =============================================================================

# Define the pbBoxCommands override in a standalone module
module BoxAutoSortOverride
  def pbBoxCommands
    commands = [
      _INTL("Jump"),
      _INTL("Wallpaper"),
      _INTL("Name"),
      _INTL("Sort"),
      _INTL("Cancel")
    ]
    
    # Add Swap if Storage System Utilities is active
    if defined?(CAN_SWAP_BOXES) && CAN_SWAP_BOXES
      commands.insert(1, _INTL("Swap"))
    end
    
    command = pbShowCommands(_INTL("What do you want to do?"), commands)
    
    case command
    when commands.index(_INTL("Jump"))
      destbox = @scene.pbChooseBox(_INTL("Jump to which Box?"))
      @scene.pbJumpToBox(destbox) if destbox >= 0
      
    when commands.index(_INTL("Swap"))
      if defined?(CAN_SWAP_BOXES) && CAN_SWAP_BOXES && @scene.respond_to?(:pbSwapBoxes)
        destbox = @scene.pbChooseBox(_INTL("Swap with which Box?"))
        @scene.pbSwapBoxes(destbox) if destbox >= 0
      end
      
    when commands.index(_INTL("Wallpaper"))
      papers = @storage.availableWallpapers
      index = 0
      papers[1].length.times do |i|
        if papers[1][i] == @storage[@storage.currentBox].background
          index = i
          break
        end
      end
      wpaper = pbShowCommands(_INTL("Pick the wallpaper."), papers[0], index)
      @scene.pbChangeBackground(papers[1][wpaper]) if wpaper >= 0
      
    when commands.index(_INTL("Name"))
      @scene.pbBoxName(_INTL("Box name?"), 0, 12)
      
    when commands.index(_INTL("Sort"))
      BoxAutoSort.show_sort_menu(@storage, @storage.currentBox)
      @scene.pbHardRefresh if @scene.respond_to?(:pbHardRefresh)
      @scene.pbRefresh if @scene.respond_to?(:pbRefresh)
    end
  end
end

# Wait briefly and then override ALL storage classes
Thread.new do
  sleep(2) # Wait 2 seconds for all plugins to load
  
  # Standard Storage Screen
  if defined?(PokemonStorageScreen)
    PokemonStorageScreen.prepend(BoxAutoSortOverride)
  end
  
  # BW Storage Screen
  if defined?(PokemonStorageScreenBW)
    PokemonStorageScreenBW.prepend(BoxAutoSortOverride)
  end
end

# =============================================================================
# Debug Commands for Testing
# =============================================================================

if $DEBUG
  MenuHandlers.add(:debug_menu, :box_auto_sort_test, {
    "name"        => "Test Box Auto-Sort",
    "parent"      => :plugins_menu,
    "description" => "Test the Box Auto-Sort functionality",
    "effect"      => proc {
      if $player&.storage
        pbMessage("Testing Box Auto-Sort directly...")
        BoxAutoSort.show_sort_menu($PokemonStorage)
      else
        pbMessage("No storage system available!")
      end
    }
  })
end 
#===============================================================================
# Box Auto-Sort - Event Handler Integration
# Extends existing pbBoxCommands methods of all Storage plugins
#===============================================================================

# Override the pbBoxCommands method for all Storage plugins
EventHandlers.add(:on_game_map_setup, :box_auto_sort_integration,
  proc {
    next if !defined?(PokemonStorageScreen)
    
    # Save the original pbBoxCommands method
    PokemonStorageScreen.class_eval do
      alias_method :original_pbBoxCommands, :pbBoxCommands unless method_defined?(:original_pbBoxCommands)
      
      def pbBoxCommands
        # Create extended commands array
        if defined?(CAN_SWAP_BOXES) && CAN_SWAP_BOXES
          # Storage System Utilities is active - extend its commands
          c_consts = [:JUMP]
          c_consts.push(:SWAP) if defined?(CAN_SWAP_BOXES) && CAN_SWAP_BOXES
          c_consts.push(:SORT, :WALL, :NAME, :CANCEL)  # Add Sort
          
          commands = [_INTL("Jump")]
          commands.push(_INTL("Swap")) if defined?(CAN_SWAP_BOXES) && CAN_SWAP_BOXES
          commands.push(
            _INTL("Sort"),
            _INTL("Wallpaper"),
            _INTL("Name"),
            _INTL("Cancel")
          )
          
          command = pbShowCommands(_INTL("What do you want to do?"), commands)
          case c_consts[command]
          when :JUMP
            destbox = @scene.pbChooseBox(_INTL("Jump to which Box?"))
            @scene.pbJumpToBox(destbox) if destbox >= 0
          when :SWAP
            if @scene.respond_to?(:pbSwapBoxes)
              destbox = @scene.pbChooseBox(_INTL("Swap with which Box?"))
              @scene.pbSwapBoxes(destbox) if destbox >= 0
            else
              pbMessage(_INTL("Swap function not available in this storage system."))
            end
          when :SORT
            # Our Sort feature
            AutoSort.show_sort_dialog(@scene, @storage)
          when :WALL
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
          when :NAME
            @scene.pbBoxName(_INTL("Box name?"), 0, 12)
          end
        else
          # Standard Essentials or BW Storage - extend their commands
          commands = [
            _INTL("Jump"),
            _INTL("Sort"),    # Our new command
            _INTL("Wallpaper"),
            _INTL("Name"),
            _INTL("Cancel")
          ]
          
          command = pbShowCommands(_INTL("What do you want to do?"), commands)
          case command
          when 0  # Jump
            destbox = @scene.pbChooseBox(_INTL("Jump to which Box?"))
            @scene.pbJumpToBox(destbox) if destbox >= 0
          when 1  # Sort
            AutoSort.show_sort_dialog(@scene, @storage)
          when 2  # Wallpaper
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
          when 3  # Name
            @scene.pbBoxName(_INTL("Box name?"), 0, 12)
          end
        end
      end
    end
  }
) 
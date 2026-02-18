#===============================================================================
# Message types.
#===============================================================================
# Adds titles to the list of message types. Renumber if necessary.
#-------------------------------------------------------------------------------
module MessageTypes
  MEMENTO_TITLES = 31
end

#===============================================================================
# Settings
#===============================================================================
module Settings
  #-----------------------------------------------------------------------------
  # Graphics path
  #-----------------------------------------------------------------------------
  # Stores the path name for the graphics utilized by this plugin.
  #-----------------------------------------------------------------------------
  MEMENTOS_GRAPHICS_PATH = "Graphics/Plugins/Improved Mementos/"
  
  #-----------------------------------------------------------------------------
  # You may set the text color of Pokemon titles to make them pop more when
  # displayed. 0 = Default color, 1 = Red, 2 = Blue, 3 = Green.
  #-----------------------------------------------------------------------------
  TITLE_COLORATION = 0#2
  
  #-----------------------------------------------------------------------------
  # When true, whenever a Pokemon gains a new memento, it will automatically
  # attach that memento to itself to gain its title. This will only occur if the
  # Pokemon doesn't already have a title set.
  #-----------------------------------------------------------------------------
  AUTO_SET_TITLES = true
  
  #-----------------------------------------------------------------------------
  # The base odds used to calculate the chance of a mark being generated on a
  # Pokemon. This number is used as a ratio, such as 1/50 chance. This number 
  # will scale based on the intended rarity of the mark.
  #-----------------------------------------------------------------------------
  BASE_MARK_GENERATION_RATIO = 1#50
  
  #-----------------------------------------------------------------------------
  # When true, the Mini/Jumbo Marks will always appear on wild Pokemon encountered
  # that match the size requirements of those respective marks. Note that this is 
  # not how these marks are obtained in the real games.
  #-----------------------------------------------------------------------------
  GUARANTEED_WILD_SIZE_MARKS = true
  
  #-----------------------------------------------------------------------------
  # When true, sets the default display of mementos viewed in the Summary to 
  # collapse lower-ranked mementos into their higher ranked versions, so that 
  # only the highest rank obtained will be visible. Set to false to show all 
  # mementos of all ranks by default.
  #-----------------------------------------------------------------------------
  COLLAPSE_RANKED_MEMENTOS = true
end
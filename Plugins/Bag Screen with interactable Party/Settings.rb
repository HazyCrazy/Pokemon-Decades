#===============================================================================
# Bag Screen with interactable Party: Settings
#===============================================================================
module BagScreenWiInParty
# If you want your Bag Screen to have a scrolling panorama (true or false):
  PANORAMA = true
 
# Interface background color:
 # 0 for only orange (newer gens style);
 # 1 for a different color for the player's gender (BW style);
 # 2 for a different color for each pocket (HGSS style).
  BGSTYLE = 0

# If you want the Panorama and Gradient sprites to change if you are choosing an item:
# Example: during a battle, while planting a berry, etc.
  ALTCHOOSINGSTYLE = true

# If the player should be able to access the party while choosing an item:
  ACCESSWHILECHOOSING = true

# If you want a Pokérus icon and/or a shiny icon to appear, respectively (true or false):
  SHINYICON = true
  PKRSICON  = true

# If the player will leave the party automatically after using an evolution item, machine, or key item:
  LEAVEPARTYEVO  = true # For evolution stones
  LEAVEPARTYMACH = true # For machines
  LEAVEPARTYKEY  = true # For key items
end

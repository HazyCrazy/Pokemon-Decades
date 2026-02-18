#====================================================================================
#=============================== DexNav Usage Tips ==================================
#====================================================================================
#
#----------------------------------------------------------------------------------
# Multi Hidden Abilities support: when a pkmn has more than one HA a ">" appers
# next the HA text, using JUMPUP and JUMPDOWN is possible loop over the HA.
#----------------------------------------------------------------------------------
module Settings
  #====================================================================================
  #================================ DexNav Settings ===================================
  #====================================================================================
    #----------------------------------------------------------------------------------
    # If set, the DexNav will appear in the Pause Menu.
    #----------------------------------------------------------------------------------
    ACCESS_DEXNAV_SWITCH_ID = 76

    #----------------------------------------------------------------------------------
    # Used to determine if there is a registered species in the DexNav.
    #----------------------------------------------------------------------------------
    DEXNAX_HAS_REGISTERED_SWITCH_ID = 77

    #----------------------------------------------------------------------------------
    # Used to store the Object of the DexNav.
    # The Object contains every searched species in the map and their chain level.
    # Used also to store the Object of the currently active species.
    #----------------------------------------------------------------------------------
    DEXNAX_GLOBAL_STORAGE_VARIABLE_ID = 44

    #----------------------------------------------------------------------------------
    # The maximum search level value for a species.
    #----------------------------------------------------------------------------------
    DEXNAX_MAX_SEARCH_LEVEL_VALUE = 255

    #----------------------------------------------------------------------------------
    # The maximum chain value for a species.
    #----------------------------------------------------------------------------------
    DEXNAX_MAX_CHAIN_VALUE = 100

    #----------------------------------------------------------------------------------
    # The minimum chain value required for a Pokémon to have an Egg Move.
    #----------------------------------------------------------------------------------
    DEXNAX_MIN_CHAIN_EGG_MOVES = 1

    #----------------------------------------------------------------------------------
    # The minimum chain value required for a Pokémon to have one perfect IV.
    #----------------------------------------------------------------------------------
    DEXNAX_MIN_CHAIN_ONE_IVS = 1

    #----------------------------------------------------------------------------------
    # The minimum chain value required for a Pokémon to have one or two perfect IVs.
    #----------------------------------------------------------------------------------
    DEXNAX_MIN_CHAIN_TWO_IVS = 2

    #----------------------------------------------------------------------------------
    # The minimum chain value required for a Pokémon to have one, two or three perfect
    # IVs.
    #----------------------------------------------------------------------------------
    DEXNAX_MIN_CHAIN_THREE_IVS = 3

    #----------------------------------------------------------------------------------
    # For the water encounter the plugin adds a new animation, with ID 8, if you have
    # insert other custom animation change this properly to reflect those change.
    #----------------------------------------------------------------------------------
    BUBBLE_ANIM_ID = 8

    DEXNAV_OVERLAY_USE_ICON = true
end
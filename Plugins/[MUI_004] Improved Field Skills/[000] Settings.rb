module Settings
  #-----------------------------------------------------------------------------
  # Field Skills that require badges to use.
  #-----------------------------------------------------------------------------
  HM_SKILLS    = [:CUT,         # HM01
                  :FLY,         # HM02
                  :SURF,        # HM03
                  :STRENGTH,    # HM04
                  :WATERFALL,   # HM05
                  :DIVE,        # HM06
                  :FLASH,       # Legacy HM
                  :ROCKSMASH,   # Legacy HM
                 ]
                 
  #-----------------------------------------------------------------------------
  # Field Skills that don't require badges to use.
  #-----------------------------------------------------------------------------
  MISC_SKILLS  = [:WHIRLPOOL,   # Legacy HM (Not implemented in Essentials)
                  :DEFOG,       # Legacy HM (Not implemented in Essentials)
                  :ROCKCLIMB,   # Legacy HM (Not implemented in Essentials)
                  :DIG,         # Field Move
                  :TELEPORT,    # Field Move
                  :SWEETSCENT,  # Field Move
                  :HEADBUTT,    # Field Move
                  :SECRETPOWER, # Field Move (Not implemented in Essentials)
				  
                  #-------------------------------------------------------------
                  # These Field Skills are added by other plugins/scripts:
                  #-------------------------------------------------------------
                  :SUNNYDAY,    # Overworld Weather Moves
                  :RAINDANCE,   # Overworld Weather Moves
                  :SANDSTORM,   # Overworld Weather Moves
                  :HAIL,        # Overworld Weather Moves
                  :EXTREMESPEED,# Field Move functionality by TechSkylander1518
                  :CAMOUFLAGE,  # Field Move functionality by TechSkylander1518
                  :BOUNCE       # Field Move functionality by TechSkylander1518
                 ]
                 
  #-----------------------------------------------------------------------------
  # Moves that are used to heal party HP by sacrificing some of the user's HP. 
  # This is handled directly through the party menu. Any move added here will 
  # function as a healing field skill.
  #-----------------------------------------------------------------------------
  HEAL_SKILLS  = [:SOFTBOILED,
                  :MILKDRINK,
                  :HEALPULSE
                 ]

  #-----------------------------------------------------------------------------
  # Moves with custom effects that are used directly in the party menu.
  # If CUSTOM_SKILLS_REQUIRE_MOVE is true, these moves consume PP upon usage.
  # Any new custom move effects must be manually coded in.
  # The moves included by default are based on scripts released by TechSkylander1518.
  #-----------------------------------------------------------------------------
  CUSTOM_SKILLS = [:RECOVER,                  # Heals 1/4th of the user's HP.
                   :LIFEDEW,                  # Heals 1/4th of the entire party's HP.
                   :HEALBELL, :AROMATHERAPY,  # Cures the status conditions of the party.
                   :SKETCH,                   # Allows the user to Sketch a party member's move.
                   :FUTURESIGHT,              # Allows the user to see the species of an Egg, or next level-up move of a Pokemon.
                  ]
                 
  #-----------------------------------------------------------------------------
  # Toggles whether HM_SKILLS that have badge requirements should be hidden 
  # in the party menu if the appropriate badges for unlocking that Field Skill
  # have not yet been acquired.
  #-----------------------------------------------------------------------------
  HM_SKILLS_REQUIRE_BADGE = false
  
  #-----------------------------------------------------------------------------
  # Toggles whether or not MISC_SKILLS require the Pokemon to know the move for
  # that skill to appear in the menu.
  #-----------------------------------------------------------------------------
  MISC_SKILLS_REQUIRE_MOVE = true
  
  #-----------------------------------------------------------------------------
  # Toggles whether or not HEAL_SKILLS require the Pokemon to know the move for
  # that skill to appear in the menu.
  #-----------------------------------------------------------------------------
  HEAL_SKILLS_REQUIRE_MOVE = true
  
  #-----------------------------------------------------------------------------
  # Toggles whether or not CUSTOM_SKILLS require the Pokemon to know the move for
  # that skill to appear in the menu.
  #-----------------------------------------------------------------------------
  CUSTOM_SKILLS_REQUIRE_MOVE = true
end
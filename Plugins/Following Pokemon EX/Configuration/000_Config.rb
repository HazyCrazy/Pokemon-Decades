 module FollowingPkmn
  # Common event that contains "FollowingPkmn.talk" in  a script command
  # Change this if you want a separate common event to play when talking to
  # Following Pokemon. Otherwise, set this to nil.
  FOLLOWER_COMMON_EVENT     = nil

  # Animation IDs from followers
  # Change this if you are not using the Animations.rxdata provided in the script.
  ANIMATION_COME_OUT        = 30
  ANIMATION_COME_IN         = 29

  ANIMATION_EMOTE_HEART     = 9
  ANIMATION_EMOTE_MUSIC     = 12
  ANIMATION_EMOTE_HAPPY     = 10
  ANIMATION_EMOTE_ELIPSES   = 13
  ANIMATION_EMOTE_ANGRY     = 15
  ANIMATION_EMOTE_POISON    = 17

  # The key the player needs to press to toggle followers. Set this to nil if
  # you want to disable this feature. (A key)
  TOGGLE_FOLLOWER_KEY       = Input::JUMPUP

  # Show the option to toggle Following Pokemon in the Options screen.
  SHOW_TOGGLE_IN_OPTIONS    = true

  # The key the player needs to press to quickly cycle through their party. Set
  # this to nil if you want to disable this feature.
  # Input::JUMPDOWN is S key - rotates party forward (first Pokemon goes to end)
  # Input::AUX2 is W key - rotates party backward (last Pokemon goes to first)
  # Input::JUMPUP is A key - swaps first and second Pokemon
  CYCLE_PARTY_FORWARD_KEY  = Input::JUMPDOWN
  CYCLE_PARTY_BACKWARD_KEY = Input::AUX2

  # Status tones to be used, if this is true (Red, Green, Blue)
  APPLY_STATUS_TONES        = true
  TONE_BURN                 = [206, 73, 43]
  TONE_POISON               = [109, 55, 130]
  TONE_PARALYSIS            = [204, 152, 44]
  TONE_FROZEN               = [56, 160, 193]
  TONE_SLEEP                = [0, 0, 0]
  # For your custom status conditions, just add it as "TONE_(INTERNAL NAME)"
  # Example: TONE_BLEED, TONE_CONFUSE, TONE_INFATUATION

  # Time Taken for Follower to increase Friendship when first in party (in seconds)
  FRIENDSHIP_TIME_TAKEN     = 125

  # Time Taken for Follower to find an item when first in party (in seconds)
  ITEM_TIME_TAKEN           = 375

  # Whether the Follower always stays in its move cycle (like HGSS) or not.
  ALWAYS_ANIMATE            = true

  # Whether the Follower always faces the player, or not like in HGSS.
  ALWAYS_FACE_PLAYER        = false

  # Whether other events can walk through Follower or no
  IMPASSABLE_FOLLOWER       = true

  # Whether Following Pokemon slides into battle instead of being sent
  # in a Pokeball. (This doesn't affect EBDX, read the EBDX documentation to
  # change this feature in EBDX)
  SLIDE_INTO_BATTLE         = true

  # Show the Ball Opening and Closing animation when Nurse Joy takes your
  # Pokeballs at the Pokecenter.
  SHOW_POKECENTER_ANIMATION = true

  # List of Pokemon that are classifed as "Levitating" and will always appear
  # behind the player when surfing.
  # Doesn't include any flying or water types because those are handled already
  LEVITATING_FOLLOWERS = [
    # Gen 1
    :BEEDRILL, :VENOMOTH, :ABRA, :GEODUDE, :MAGNEMITE, :GASTLY, :HAUNTER,
    :KOFFING, :WEEZING, :PORYGON, :MEW,
    # Gen 2
    :MISDREAVUS, :UNOWN, :PORYGON2, :CELEBI,
    # Gen 3
    :DUSTOX, :SHEDINJA, :MEDITITE, :VOLBEAT, :ILLUMISE, :FLYGON, :LUNATONE,
    :SOLROCK, :BALTOY, :CLAYDOL, :CASTFORM, :SHUPPET, :DUSKULL, :CHIMECHO,
    :GLALIE, :BELDUM, :METANG, :LATIAS, :LATIOS, :JIRACHI,
    # Gen 4
    :MISMAGIUS, :BRONZOR, :BRONZONG, :SPIRITOMB, :CARNIVINE, :MAGNEZONE,
    :PORYGONZ, :PROBOPASS, :DUSKNOIR, :FROSLASS, :ROTOM, :UXIE, :MESPRIT,
    :AZELF, :GIRATINA_1, :CRESSELIA, :DARKRAI,
    # Gen 5
    :MUNNA, :MUSHARNA, :YAMASK, :COFAGRIGUS, :SOLOSIS, :DUOSION, :REUNICLUS,
    :VANILLITE, :VANILLISH, :VANILLUXE, :ELGYEM, :BEHEEYEM, :LAMPENT,
    :CHANDELURE, :CRYOGONAL, :HYDREIGON, :VOLCARONA, :RESHIRAM, :ZEKROM,
    # Gen 6
    :SPRITZEE, :DRAGALGE, :CARBINK, :KLEFKI, :PHANTUMP, :DIANCIE, :HOOPA,
    # Gen 7
    :VIKAVOLT, :CUTIEFLY, :RIBOMBEE, :COMFEY, :DHELMISE, :TAPUKOKO, :TAPULELE,
    :TAPUBULU, :COSMOG, :COSMOEM, :LUNALA, :NIHILEGO, :KARTANA, :NECROZMA,
    :MAGEARNA, :POIPOLE, :NAGANADEL,
    # Gen 8
    :ORBEETLE, :FLAPPLE, :SINISTEA, :POLTEAGEIST, :FROSMOTH, :DREEPY, :DRAKLOAK,
    :DRAGAPULT, :ETERNATUS, :REGIELEKI, :REGIDRAGO, :CALYREX
  ]

  # List of Pokemon that will not appear behind the player when surfing,
  # regardless of whether they are flying type, have levitate or are mentioned
  # in the LEVITATING_FOLLOWERS array.
  SURFING_FOLLOWERS_EXCEPTIONS = [
    # Gen I
    :CHARIZARD, :PIDGEY, :SPEAROW, :FARFETCHD, :DODUO, :DODRIO, :SCYTHER,
    :ZAPDOS_1,
    # Gen II
    :NATU, :XATU, :MURKROW, :DELIBIRD,
    # Gen III
    :TAILLOW, :VIBRAVA, :TROPIUS,
    # Gen IV
    :STARLY, :HONCHKROW, :CHINGLING, :CHATOT, :ROTOM_1, :ROTOM_2, :ROTOM_3,
    :ROTOM_5, :SHAYMIN_1, :ARCEUS_2,
    # Gen V
    :ARCHEN, :DUCKLETT, :EMOLGA, :EELEKTRIK, :EELEKTROSS, :RUFFLET, :VULLABY,
    :LANDORUS_1,
    # Gen VI
    :FLETCHLING, :HAWLUCHA,
    # Gen VII
    :ROWLET, :DARTRIX, :PIKIPEK, :ORICORIO, :SILVALLY_2,
    # Gen VIII
    :ROOKIDEE, :CALYREX_1, :CALYREX_2
  ]

  #-----------------------------------------------------------------------------
  # Fly Animation Settings
  #-----------------------------------------------------------------------------
  # Set to true to disable the fly animation
  DISABLE_FLY_ANIMATION = false

  #-----------------------------------------------------------------------------
  # Distance Setting
  #-----------------------------------------------------------------------------
  # The distance (in pixels) to visually push the follower away from the player
  # to prevent overlap.
  FOLLOWER_DISTANCE_OFFSET = 8

  # Specific distance offsets for certain Pokemon (e.g. large sprites).
  # Use this to override the default offset above.
  # Format: :SPECIES => offset_in_pixels
  FOLLOWER_DISTANCE_EXCEPTIONS = {
    # Gen 1
    :VENUSAUR   => 16, :CHARIZARD  => 16, :BLASTOISE  => 16,
    :ONIX       => 24, :GYARADOS   => 24, :LAPRAS     => 16,
    :SNORLAX    => 16, :ARTICUNO   => 16, :ZAPDOS     => 16,
    :MOLTRES    => 16, :DRAGONITE  => 16, :MEWTWO     => 16,
    :RHYDON     => 16,
    # Gen 2
    :MEGANIUM   => 16, :FERALIGATR => 16, :STEELIX    => 24,
    :LUGIA      => 24, :HOOH       => 24, :TYRANITAR  => 16,
    # Gen 3
    :SCEPTILE   => 16, :SWAMPERT   => 16, :WAILORD    => 32,
    :AGGRON     => 16, :METAGROSS  => 16, :REGIROCK   => 16,
    :REGICE     => 16, :REGISTEEL  => 16, :KYOGRE     => 32,
    :GROUDON    => 32, :RAYQUAZA   => 32,
    # Gen 4
    :TORTERRA   => 24, :GARCHOMP   => 16, :RHYPERIOR  => 24,
    :DIALGA     => 32, :PALKIA     => 32, :HEATRAN    => 16,
    :REGIGIGAS  => 24, :GIRATINA   => 32, :ARCEUS     => 24,
    # Gen 5
    :SERPERIOR  => 16, :SCOLIPEDE  => 24, :GIGALITH   => 16,
    :RESHIRAM   => 32, :ZEKROM     => 32, :KYUREM     => 32,
    # Gen 6
    :XERNEAS    => 24, :YVELTAL    => 24, :ZYGARDE    => 32,
    :HOOPA      => 24, :VOLCANION  => 16,
    # Gen 7
    :SOLGALEO   => 24, :LUNALA     => 24, :NECROZMA   => 24,
    :GUZZLORD   => 32, :STAKATAKA  => 32,
    # Gen 8
    :ETERNATUS  => 32, :ZAMAZENTA  => 16, :ZACIAN     => 16,
    :CALYREX    => 16, :REGIDRAGO  => 16, :REGIELEKI  => 16
  }
end

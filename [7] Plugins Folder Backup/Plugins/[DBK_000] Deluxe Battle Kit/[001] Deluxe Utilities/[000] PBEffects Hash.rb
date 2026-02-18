#===============================================================================
# Stores and organizes the ID's of all relavent PBEffects.
#===============================================================================
# [:counter] contains effects which store a number which is counted to determine
# its value, such as the number of stacks or number of remaining turns.
# [:boolean] contains effects which are stored as either nil, true, or false.
# [:index] contains effects which store a battler index. Only relevant to
# battler effects.
#-------------------------------------------------------------------------------
$DELUXE_PBEFFECTS = {
  #-----------------------------------------------------------------------------
  # Effects that apply to the entire battlefield.
  #-----------------------------------------------------------------------------
  :field => {
    :boolean => [
      :HappyHour,
      :IonDeluge
    ],
    :counter => [
      :PayDay,
      :FairyLock,
      :Gravity,
      :MagicRoom,
      :WonderRoom,
      :TrickRoom,
      :MudSportField,
      :WaterSportField
    ]
  },
  #-----------------------------------------------------------------------------
  # Effects that apply to one side of the field.
  #-----------------------------------------------------------------------------
  :team => {
    :boolean => [
      :CraftyShield,
      :QuickGuard,
      :WideGuard,
      :MatBlock,
      :StealthRock,
      :Steelsurge,
      :StickyWeb
    ],
    :counter => [
      :Spikes, 
      :ToxicSpikes,
      :Volcalith,
      :VineLash,
      :Wildfire,
      :Cannonade,
      :SeaOfFire,
      :Rainbow, 
      :Swamp, 
      :Tailwind,
      :AuroraVeil,
      :Reflect,
      :LightScreen,
      :Safeguard,
      :Mist,
      :LuckyChant,
      :CheerDefense1,
      :CheerDefense2,
      :CheerDefense3,
      :CheerOffense1,
      :CheerOffense2,
      :CheerOffense3
    ]
  },
  #-----------------------------------------------------------------------------
  # Effects that apply to a battler position.
  #-----------------------------------------------------------------------------
  :position => {
    :boolean => [
      :HealingWish,
      :LunarDance,
      :ZHealing
    ],
    :counter => [
      :FutureSightCounter,
      :Wish
    ]
  },
  #-----------------------------------------------------------------------------
  # Effects that apply to a battler.
  #-----------------------------------------------------------------------------
  :battler => {
    :index => [
      :LeechSeed,
      :Attract,
      :MeanLook,
      :JawLock, 
      :Octolock,
      :SkyDrop
    ],
    :boolean => [
      :Endure,
      :AquaRing,
      :Ingrain,
      :Curse,
      :Nightmare,
      :SaltCure,
      :Flinch,
      :Torment,
      :Imprison,
      :Snatch,
      :Quash,
      :Grudge,
      :DestinyBond,
      :GastroAcid,
      :ExtraType,
      :Electrify,
      :Powder,
      :TarShot,
      :MudSport,
      :WaterSport,
      :SmackDown,
      :Roost,
      :BurnUp,
      :DoubleShock,
      :Foresight,
      :MiracleEye,
      :Minimize,
      :Rage,
      :HelpingHand,
      :PowerTrick,
      :MagicCoat,
      :Protect,
      :SpikyShield,
      :BanefulBunker,
      :BurningBulwark,
      :KingsShield,
      :Obstruct,
      :SilkTrap,
      :NoRetreat,
      :TwoTurnAttack
    ],
    :counter => [
      :Substitute,
      :Toxic,
      :Splinters,
      :HealBlock,
      :Confusion,
      :Outrage,
      :Uproar,
      :ThroatChop,
      :Encore,
      :Disable,
      :Taunt,
      :Embargo,
      :Charge,
      :MagnetRise,
      :Telekinesis,
      :GlaiveRush,
      :Syrupy,
      :LockOn,
      :LaserFocus,
      :FocusEnergy,
      :Stockpile,
      :WeightChange,
      :Trapping,
      :HyperBeam,
      :Yawn,
      :PerishSong,
      :SlowStart
    ]
  }
}
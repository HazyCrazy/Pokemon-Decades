#===============================================================================
# Type Enhance Overhaul handlers
# The type enhance items have been overhauled in SY 3.0.0
# to be consumed and apply dedicated status effects on a holder entering the field
# Only the type Plates give the 20% type boost now
# The technicals of the Terrain Seed items means a stat has to be raised
# for the effects to apply and have the item be consumed as intended.
# All the overhauls simply raise Accuracy, because it's the only Stat 
# that causes the least amount of balance problems. (Anything else could be a serious problem)
#===============================================================================
Battle::ItemEffects::TerrainStatBoost.add(:BLACKBELT,
  proc { |item, battler, battle|
    itemName = GameData::Item.get(item).name
    battle.pbCommonAnimation("UseItem", battler)
    showAnim = true
	
	choice = battler.pbDirectOpposing
    battle.pbAnimation(:LASERFOCUS, battler, choice)
    battler.effects[PBEffects::LaserFocus] = 2
    battle.pbDisplay(_INTL("{1} next attack will land a Critical Hit!", battler.pbThis))
	
	next battler.pbRaiseStatStageByCause(:ACCURACY, 1, battler, itemName)
  }
)

Battle::ItemEffects::TerrainStatBoost.add(:BLACKGLASSES,
  proc { |item, battler, battle|
    itemName = GameData::Item.get(item).name
    battle.pbCommonAnimation("UseItem", battler)
    showAnim = true
	
	choice = battler
    battle.pbAnimation(:OBSTRUCT, battler, choice)
    battler.effects[PBEffects::Obstruct] = true
    battle.pbDisplay(_INTL("{1}'s guard will weaken the defense of incoming physical moves!", battler.pbThis))
	
	next battler.pbRaiseStatStageByCause(:ACCURACY, 1, battler, itemName)
  }
)

Battle::ItemEffects::TerrainStatBoost.add(:CHARCOAL,
  proc { |item, battler, battle|
    itemName = GameData::Item.get(item).name
    battle.pbCommonAnimation("UseItem", battler)
    showAnim = true
	
	choice = battler
    battle.pbAnimation(:BURNINGBULWARK, battler, choice)
    battler.effects[PBEffects::BurningBulwark] = true
    battle.pbDisplay(_INTL("{1}'s guard will burn incoming physical moves!", battler.pbThis))
	
	next battler.pbRaiseStatStageByCause(:ACCURACY, 1, battler, itemName)
  }
)

Battle::ItemEffects::TerrainStatBoost.add(:DRAGONFANG,
  proc { |item, battler, battle|
    itemName = GameData::Item.get(item).name
    battle.pbCommonAnimation("UseItem", battler)
    showAnim = true
	
	choice = battler
    battle.pbAnimation(:DRAGONCHEER, battler, choice)
    battler.effects[PBEffects::FocusEnergy] = 1
    battle.pbDisplay(_INTL("{1}'s Crit Rate is now 12.5%! Becomes 50% with Dragon Claw!", battler.pbThis))
	
	next battler.pbRaiseStatStageByCause(:ACCURACY, 1, battler, itemName)
  }
)

Battle::ItemEffects::TerrainStatBoost.add(:FAIRYFEATHER,
  proc { |item, battler, battle|
    itemName = GameData::Item.get(item).name
    battle.pbCommonAnimation("UseItem", battler)
    showAnim = true
	
	choice = battler.pbDirectOpposing
    battle.pbAnimation(:FAIRYLOCK, battler, choice)
    battle.field.effects[PBEffects::FairyLock] = 2
    battle.pbDisplay(_INTL("Non Ghost-types cannot escape the field until the next turn!"))
	
	next battler.pbRaiseStatStageByCause(:ACCURACY, 1, battler, itemName)
  }
)

Battle::ItemEffects::TerrainStatBoost.add(:HARDSTONE,
  proc { |item, battler, battle|
    itemName = GameData::Item.get(item).name
    battle.pbCommonAnimation("UseItem", battler)
    showAnim = true
	
	choice = battler
    choice2 = battler.pbDirectOpposing
    battle.pbAnimation(:STEALTHROCK, battler, choice) if !battler.pbOwnSide.effects[PBEffects::StealthRock]
    battle.pbAnimation(:STEALTHROCK, battler.pbDirectOpposing, choice2) if !battler.pbOpposingSide.effects[PBEffects::StealthRock]
    battler.pbOwnSide.effects[PBEffects::StealthRock] = true if !battler.pbOwnSide.effects[PBEffects::StealthRock]
    battler.pbOpposingSide.effects[PBEffects::StealthRock] = true if !battler.pbOpposingSide.effects[PBEffects::StealthRock]
    battle.pbDisplay(_INTL("Stellar Rocks were laid out on both sides!"))
	
	next battler.pbRaiseStatStageByCause(:ACCURACY, 1, battler, itemName)
  }
)

Battle::ItemEffects::TerrainStatBoost.add(:MAGNET,
  proc { |item, battler, battle|
    itemName = GameData::Item.get(item).name
    battle.pbCommonAnimation("UseItem", battler)
    showAnim = true
	
    choice = battler.pbDirectOpposing
    battle.pbAnimation(:MAGNETRISE, battler, choice)
    battler.effects[PBEffects::MagnetRise] = 5
    battle.pbDisplay(_INTL("{1} levitated with electromagnetism!", battler.pbThis))
	
	next battler.pbRaiseStatStageByCause(:ACCURACY, 1, battler, itemName)
  }
)

Battle::ItemEffects::TerrainStatBoost.add(:METALCOAT,
  proc { |item, battler, battle|
    itemName = GameData::Item.get(item).name
    battle.pbCommonAnimation("UseItem", battler)
    showAnim = true
	
	choice = battler
    battle.pbAnimation(:KINGSSHIELD, battler, choice)
    battler.effects[PBEffects::KingsShield] = true
    battle.pbDisplay(_INTL("{1}'s guard will weaken the attack of incoming physical moves!", battler.pbThis))
	
	next battler.pbRaiseStatStageByCause(:ACCURACY, 1, battler, itemName)
  }
)

Battle::ItemEffects::TerrainStatBoost.add(:MIRACLESEED,
  proc { |item, battler, battle|
    itemName = GameData::Item.get(item).name
    battle.pbCommonAnimation("UseItem", battler)
    showAnim = true
	
	if !battler.effects[PBEffects::Ingrain]
           choice = battler.pbDirectOpposing
           battle.pbAnimation(:INGRAIN, battler, choice)
           battler.effects[PBEffects::Ingrain] = true
           battle.pbDisplay(_INTL("{1} is grounded by its roots! They will recover 6.25% HP every turn.", battler.pbThis))
    end
	
	next battler.pbRaiseStatStageByCause(:ACCURACY, 1, battler, itemName)
  }
)

Battle::ItemEffects::TerrainStatBoost.add(:MYSTICWATER,
  proc { |item, battler, battle|
    itemName = GameData::Item.get(item).name
    battle.pbCommonAnimation("UseItem", battler)
    showAnim = true
	
	if !battler.effects[PBEffects::AquaRing]
           choice = battler.pbDirectOpposing
           battle.pbAnimation(:AQUARING, battler, choice)
           battler.effects[PBEffects::AquaRing] = true
           battle.pbDisplay(_INTL("{1} cloaks itself in a veil of water! They will recover 6.25% HP every turn.", battler.pbThis))
    end
	
	next battler.pbRaiseStatStageByCause(:ACCURACY, 1, battler, itemName)
  }
)

Battle::ItemEffects::TerrainStatBoost.add(:NEVERMELTICE,
  proc { |item, battler, battle|
    itemName = GameData::Item.get(item).name
    battle.pbCommonAnimation("UseItem", battler)
    showAnim = true
	
	choice = battler.pbDirectOpposing
	battle.pbAnimation(:HAZE, battler, choice)
	battle.allBattlers.each { |b| b.pbResetStatStages }
    battle.pbDisplay(_INTL("All stat changes were eliminated!"))
	
	next battler.pbRaiseStatStageByCause(:ACCURACY, 1, battler, itemName)
  }
)

Battle::ItemEffects::TerrainStatBoost.add(:POISONBARB,
  proc { |item, battler, battle|
    itemName = GameData::Item.get(item).name
    battle.pbCommonAnimation("UseItem", battler)
    showAnim = true
	
	choice = battler
    choice2 = battler.pbDirectOpposing
    battle.pbAnimation(:TOXICSPIKES, battler, choice) 
    battle.pbAnimation(:TOXICSPIKES, battler.pbDirectOpposing, choice2)
    battler.pbOwnSide.effects[PBEffects::ToxicSpikes] = 2
    battler.pbOpposingSide.effects[PBEffects::ToxicSpikes] = 2
    battle.pbDisplay(_INTL("Two layers of Toxic Spikes were laid out on both sides!"))
	
	next battler.pbRaiseStatStageByCause(:ACCURACY, 1, battler, itemName)
  }
)

Battle::ItemEffects::TerrainStatBoost.add(:SHARPBEAK,
  proc { |item, battler, battle|
    itemName = GameData::Item.get(item).name
    battle.pbCommonAnimation("UseItem", battler)
    showAnim = true
	
    choice = battler
    battle.pbAnimation(:TAILWIND, battler, choice)
    battler.pbOwnSide.effects[PBEffects::Tailwind] = 4
    battle.pbDisplay(_INTL("The Tailwind blew from behind {1}!", battler.pbThis))
	
	next battler.pbRaiseStatStageByCause(:ACCURACY, 1, battler, itemName)
  }
)

Battle::ItemEffects::TerrainStatBoost.add(:SILKSCARF,
  proc { |item, battler, battle|
    itemName = GameData::Item.get(item).name
    battle.pbCommonAnimation("UseItem", battler)
    showAnim = true
	
	if battler.effects[PBEffects::Wish] = 0
           choice = battler.pbDirectOpposing
           battle.pbAnimation(:WISH, battler, choice)
           battle.positions[battler.index].effects[PBEffects::Wish]       = 1
           battle.positions[battler.index].effects[PBEffects::WishAmount] = (battler.totalhp * 0.75).round 
           battle.positions[battler.index].effects[PBEffects::WishMaker]  = battler.pokemonIndex
           battle.pbDisplay(_INTL("A wish was made for {1}!", battler.pbThis(true)))
        end
	
	next battler.pbRaiseStatStageByCause(:ACCURACY, 1, battler, itemName)
  }
)

Battle::ItemEffects::TerrainStatBoost.add(:SILVERPOWDER,
  proc { |item, battler, battle|
    itemName = GameData::Item.get(item).name
    battle.pbCommonAnimation("UseItem", battler)
    showAnim = true
	
    choice = battler
    battle.pbAnimation(:SILKTRAP, battler, choice)
    battler.effects[PBEffects::SilkTrap] = true
    battle.pbDisplay(_INTL("{1}'s guard will slow down incoming physical moves!", battler.pbThis))
	
	next battler.pbRaiseStatStageByCause(:ACCURACY, 1, battler, itemName)
  }
)

Battle::ItemEffects::TerrainStatBoost.add(:SOFTSAND,
  proc { |item, battler, battle|
    itemName = GameData::Item.get(item).name
    battle.pbCommonAnimation("UseItem", battler)
    showAnim = true

	choice = battler
    choice2 = battler.pbDirectOpposing
    battle.pbAnimation(:SPIKES, battler, choice)
    battle.pbAnimation(:SPIKES, battler.pbDirectOpposing, choice2)
    battler.pbOwnSide.effects[PBEffects::Spikes] = 3
    battler.pbOpposingSide.effects[PBEffects::Spikes] = 3
    battle.pbDisplay(_INTL("Three layers of Spikes were laid out on both sides!"))
	
	next battler.pbRaiseStatStageByCause(:ACCURACY, 1, battler, itemName)
  }
)

Battle::ItemEffects::TerrainStatBoost.add(:SPELLTAG,
  proc { |item, battler, battle|
    itemName = GameData::Item.get(item).name
    battle.pbCommonAnimation("UseItem", battler)
    showAnim = true
	
	choice = battler.pbDirectOpposing
    battle.pbAnimation(:MAGICCOAT, battler, choice)
    battler.effects[PBEffects::MagicCoat] = true
    battle.pbDisplay(_INTL("{1} shrouded itself with Magic Coat!", battler.pbThis))
	
	next battler.pbRaiseStatStageByCause(:ACCURACY, 1, battler, itemName)
  }
)

Battle::ItemEffects::TerrainStatBoost.add(:TWISTEDSPOON,
  proc { |item, battler, battle|
    itemName = GameData::Item.get(item).name
    battle.pbCommonAnimation("UseItem", battler)
    showAnim = true
	
	choice = battler
	battle.pbAnimation(:IMPRISON, battler, choice)
	battler.effects[PBEffects::Imprison] = true
    battle.pbDisplay(_INTL("{1} sealed any moves its target shares with it!", battler.pbThis))
	
	next battler.pbRaiseStatStageByCause(:ACCURACY, 1, battler, itemName)
  }
)

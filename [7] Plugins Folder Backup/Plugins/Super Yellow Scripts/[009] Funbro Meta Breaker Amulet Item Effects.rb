#===============================================================================
# Meta Breaker Amulet
# This is a joke Item for Funbro only.
# It is the final piece of the puzzle, to make Funbro's joke fight,
# a battle you will never win.
# This gag fight is intended to fuck with Speed Up Spammers.
# People who abuse Emulator and Delta Speed Ups, and devalue the game's immersion
# for themselves. And it's also because I wanted to show Pokemon Scale x Fang,
# that it's virgin behavior to take away someone's decision to use Emulator Speed Up.
# You don't piss off and alienate people's decision to ruin their experience for themselves.
# You instead, fuck with them. Use their own lack of self control at their own expense.
# Because it's going to be funny as fuck. 
#===============================================================================

#===============================================================================
# Good As Gold as an item effect
#===============================================================================
#Battle::ItemEffects::StatLossImmunity.add(:CLEARAMULET,
#  proc { |item, battler, stat, battle, showMessages|
#    if showMessages
#      battle.pbDisplay(_INTL("{1}'s {2} prevents stat loss!", battler.pbThis, battler.itemName))
#    end
#    next true
#  }
#)

#Battle::AbilityEffects::MoveImmunity.add(:GOODASGOLD,
#  proc { |ability, user, target, move, type, battle, show_message|
#    next false if !move.statusMove?
#    next false if user.index == target.index
#    if show_message
#      battle.pbShowAbilitySplash(target)
#      if Battle::Scene::USE_ABILITY_SPLASH
#        battle.pbDisplay(_INTL("It doesn't affect {1}...", target.pbThis(true)))
#      else
#        battle.pbDisplay(_INTL("{1}'s {2} blocks {3}!",
#           target.pbThis, target.abilityName, move.name))
#      end
#      battle.pbHideAbilitySplash(target)
#    end
#    next true
#  }
#)

#===============================================================================
# Levitate as an item effect (Funbro will Tera Electric, and has Wonder Guard)
#===============================================================================



#===============================================================================
# 100% HP Regen and Full PP Restoration every turn as an item effect
#===============================================================================

#===============================================================================
# 100% Damage Reduction as an item effect
#===============================================================================
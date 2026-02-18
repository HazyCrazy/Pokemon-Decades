################################################################################
# 
# New ability handlers.
# 
################################################################################

#===============================================================================
# Anti Meta (For the joke Funbro Battle only)
# This ability is the effects of all of the following, all at once:
# Wonder Guard (Stops the Gravity Field effect)
# Levitate (Paris with Tera Electric)
# Good as Gold (Stops all Status Moves)
# Magic Bounce (Reflect nearly every Status interaction)
# Leppa Harvest (100% Berry Harvest Chance for Funbro's Leppa Berry
# Sticky Hold (Held Item cannot be knocked off)
# Magic Guard (Stops all indirect damage)
# Soundproof 
# Shell Armor 
# Shadow Tag
# This ability will also count as a form changing ability, stopping Netural Gas
# Funbro's Moveset is HEALPULSE,SLACKOFF,TAUNT,SIMPLEBEAM
# It's held item is the Leppa Berry
#===============================================================================
Battle::AbilityEffects::OnSwitchIn.add(:ANTIMETA,
  proc { |ability, battler, battle, switch_in|
    battle.pbShowAbilitySplash(battler)
    battle.pbDisplay(_INTL("{1}'s raw malice gives it an invincible assortment of abilities! It's Tera Type is Electric!!", battler.pbThis))
    battle.pbHideAbilitySplash(battler)
  }
)
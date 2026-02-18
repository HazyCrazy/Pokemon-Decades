#===============================================================================
# Always Headbutt Encounters
# Headbutt usage in the overworld will now always guarantee an encounter.
#===============================================================================
def pbIsHeadbuttAlways?
  return true
end

alias headbutt_effect_always pbHeadbuttEffect
def pbHeadbuttEffect(event = nil)
  if pbIsHeadbuttAlways?
    pbHeadbuttEffectAlways
  else
    headbutt_effect_always(event)
  end
end

#-----------------------------------------------------------------------------
# Custom Headbutt behavior will always tries an encounter. 15% chance of using Headbutt for a rare encounter; otherwise uses the common Headbutt encounter type.
#-----------------------------------------------------------------------------
def pbHeadbuttEffectAlways
  #enctype = (rand(100) < 15 ? :HeadbuttLow : :HeadbuttHigh)
  enctype = (rand(100) < 50 ? :HeadbuttLow : :HeadbuttHigh)
  if pbEncounter(enctype)
    $stats.headbutt_battles += 1
  else
    #pbMessage(_INTL("Nope. Nothing..."))
  end
end
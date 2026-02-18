def pbDexNavRegisteredEvent
  dexnav = safeAccessDexNav
  dexnav.max_steps = 15
  pbDexNavSearchEvent
end

def pbDexNavSearchEvent
  MyOverlayModule.pbEndMyOverlay
  #pbMessage(_INTL("Searching... \\wtnp[5]... \\wtnp[5]... \\wtnp[5]"))
  pbMessage(_INTL("Scanning... (Press CTRL again if nothing is found)"))
  dexnav = safeAccessDexNav
  is_grass = dexnav.is_grass
  coords = getCoords(is_grass)
  pbWait(0.1)
  if coords[0] >= 0 && coords[1] >= 0
    showGrassShaking(coords[0], coords[1], true, is_grass)
    dexnav.set_coords(coords)
    dexnav.prepare_battler
    info = dexnav.get_info
    MyOverlayModule.pbShowMyOverlay(info)
    Graphics.update
  end
end

def showGrassShaking(x, y, first, is_grass)
  anim = is_grass ? Settings::RUSTLE_NORMAL_ANIMATION_ID : Settings::BUBBLE_ANIM_ID
  $scene.spriteset.addUserAnimation(anim, x, y, true, 1)
  if first
    pbWait(0.5)
    $scene.spriteset.addUserAnimation(anim, x, y, true, 1)
    pbWait(0.5)
  end
end

def getCoords(is_grass)
  target = is_grass ? [:Grass, :TallGrass, :UnderwaterGrass] : [:Water, :DeepWater, :StillWater]
  x = -1
  y = -1
  (0..3).each { |j|
    i = 3
    r = rand((i + 1) * 8)
    if r <= (i + 1) * 2
      x = $game_player.x - i - 1 + r
      y = $game_player.y - i - 1
    elsif r <= ((i + 1) * 6) - 2
      x = [$game_player.x + i + 1, $game_player.x - i - 1][r % 2]
      y = $game_player.y - i + ((r - 1 - ((i + 1) * 2)) / 2).floor
    else
      x = $game_player.x - i + r - ((i + 1) * 6)
      y = $game_player.y + i + 1
    end
    # Add tile to grasses array if it's a valid grass tile
    unless x < 0 || x >= $game_map.width || y < 0 || y >= $game_map.height
      terrain = $game_map.terrain_tag(x, y)
      if target.include?(terrain.id)
        break
      else
        x = -1
        y = -1
      end
    else
      x = -1
      y = -1
    end
  }
  return [x, y]
end

def startBattleDexNav(dexnav)
  dexnav.in_battle = true
  WildBattle.start(dexnav.battler)
end

EventHandlers.add(:on_enter_map, :reset_dexnav,
  proc { |map_id|
    next unless $game_switches[Settings::ACCESS_DEXNAV_SWITCH_ID]
    dexnav = safeAccessDexNav
    dexnav.set_inactive
    $game_switches[Settings::DEXNAX_HAS_REGISTERED_SWITCH_ID] = false
    MyOverlayModule.pbEndMyOverlay
  }
)

EventHandlers.add(:on_player_step_taken, :check_battle_dexnav,
  proc {
    next unless $game_switches[Settings::ACCESS_DEXNAV_SWITCH_ID]
    dexnav = safeAccessDexNav
    next unless dexnav.is_active?
    dexnav.decrease_step
    x = $game_player.x
    y = $game_player.y
    next unless dexnav.is_active?
    showGrassShaking(dexnav.coords[0], dexnav.coords[1], false, dexnav.is_grass)
    if dexnav.are_right_coords?([x, y])
      MyOverlayModule.pbEndMyOverlay
      startBattleDexNav(dexnav)
    end
  }
)

EventHandlers.add(:on_end_battle, :end_battle_dexnav,
  proc { |decision, canLose|
    dexnav = safeAccessDexNav
    if [1, 4].include?(decision)
      if dexnav.is_active? && dexnav.in_battle
        dexnav.increase_search_level
        dexnav.increase_active_chain
      end
    end
    dexnav.reset_active_chain unless dexnav.in_battle
    dexnav.set_inactive
  }
)

EventHandlers.add(:on_start_battle, :overlay_cleaning,
  proc {
    MyOverlayModule.pbEndMyOverlay
  }
)

EventHandlers.add(:on_player_interact, :overlay_cleaning_interact,
  proc {
    MyOverlayModule.pbEndMyOverlay
  }
)
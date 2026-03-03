module FollowingPkmn
  #-----------------------------------------------------------------------------
  # Script Command for getting the Following Pokemon event and corresponding
  # Follower Data
  #-----------------------------------------------------------------------------
  def self.get
    return nil if !FollowingPkmn.can_check?
    $game_temp.followers.each_follower do |event, follower|
      next if !follower.following_pkmn?
      return [event, follower]
    end
    return nil
  end
  #-----------------------------------------------------------------------------
  # Script Command for getting the Following Pokemon event
  #-----------------------------------------------------------------------------
  def self.get_event
    return nil if !FollowingPkmn.can_check?
    ret = FollowingPkmn.get
    return ret.is_a?(Array) ? ret[0] : nil
  end
  #-----------------------------------------------------------------------------
  # Script Command for getting the Following Pokemon FollowerData
  #-----------------------------------------------------------------------------
  def self.get_data
    return nil if !FollowingPkmn.can_check?
    ret = FollowingPkmn.get
    return ret.is_a?(Array) ? ret[1] : nil
  end
  #-----------------------------------------------------------------------------
  # Script Command for getting the Pokemon Object of the Following Pokemon
  #-----------------------------------------------------------------------------
  def self.get_pokemon
    return nil if !FollowingPkmn.can_check?
    return $player.first_able_pokemon
  end
  #-----------------------------------------------------------------------------
  # Script Command for checking whether the current follower is airborne
  #-----------------------------------------------------------------------------
  def self.airborne_follower?
    return false if !FollowingPkmn.can_check?
    pkmn = FollowingPkmn.get_pokemon
    return false if !pkmn
    return true if pkmn.hasType?(:FLYING)
    return true if pkmn.hasAbility?(:LEVITATE)
    return true if FollowingPkmn::LEVITATING_FOLLOWERS.any? { |s| s == pkmn.species || s.to_s == "#{pkmn.species}_#{pkmn.form}" }
    return false
  end
  #-----------------------------------------------------------------------------
  # Script Command for checking if a swimming sprite exists for the Pokemon
  #-----------------------------------------------------------------------------
  def self.has_swimming_sprite?
    return false if !FollowingPkmn.can_check?
    pkmn = FollowingPkmn.get_pokemon
    return false if !pkmn
    
    # Check if swimming sprite exists
    shiny = pkmn.shiny?
    shiny = pkmn.superVariant if (pkmn.respond_to?(:superVariant) && !pkmn.superVariant.nil? && pkmn.superShiny?)
    
    # Check for swimming sprite first
    folder = shiny ? "Swimming Shiny" : "Swimming"
    ret = GameData::Species.check_graphic_file("Graphics/Characters/", pkmn.species, pkmn.form,
                                               pkmn.gender, shiny, pkmn.shadow, folder)
    return true if !nil_or_empty?(ret)
    
    # Check for levitate sprite (for airborne Pokemon over water)
    folder = shiny ? "Levitates Shiny" : "Levitates"
    ret = GameData::Species.check_graphic_file("Graphics/Characters/", pkmn.species, pkmn.form,
                                               pkmn.gender, shiny, pkmn.shadow, folder)
    return !nil_or_empty?(ret)
  end
  #-----------------------------------------------------------------------------
  # Script Command for checking whether the current follower is waterborne
  #-----------------------------------------------------------------------------
  def self.waterborne_follower?
    return false if defined?(@@checking_waterborne) && @@checking_waterborne
    @@checking_waterborne = true
    begin
      return false if !FollowingPkmn.can_check?
      pkmn = FollowingPkmn.get_pokemon
      return false if !pkmn
      
      # Always follow if Pokemon is water type
      return true if pkmn.hasType?(:WATER)
      
      # Always follow if the Pokemon has a swimming or levitate sprite available
      # This takes priority over the exceptions list
      return true if FollowingPkmn.has_swimming_sprite?
      
      # Check exceptions list before checking airborne
      return false if FollowingPkmn::SURFING_FOLLOWERS_EXCEPTIONS.any? do |s|
        s == pkmn.species || s.to_s == "#{pkmn.species}_#{pkmn.form}"
      end
      
      # Follow if the Pokemon flies or levitates (and not in exceptions)
      return true if FollowingPkmn.airborne_follower?
      
      return false
    ensure
      @@checking_waterborne = false
    end
  end
  #-----------------------------------------------------------------------------
  # Script Command for checking whether the current follower should use swimming sprites
  #-----------------------------------------------------------------------------
  def self.should_use_swimming_sprites?
    return false if !FollowingPkmn.can_check? || !FollowingPkmn.active?
    # Use swimming sprites only when player is actually surfing AND the follower is on water
    return false if !$PokemonGlobal.surfing || !FollowingPkmn.waterborne_follower?
    
    # Check if the follower is actually on a water tile
    event = FollowingPkmn.get_event
    return false if !event
    
    # Check the terrain tag of the follower's current position
    terrain_tag = $map_factory.getTerrainTag(event.map.map_id, event.x, event.y)
    return terrain_tag.can_surf
  end
  #-----------------------------------------------------------------------------
  # Forcefully refresh Following Pokemon sprite with animation (if specified)
  #-----------------------------------------------------------------------------
  def self.refresh(anim = false)
    return if !FollowingPkmn.can_check?
    event = FollowingPkmn.get_event
    FollowingPkmn.remove_sprite
    event&.calculate_bush_depth
    first_pkmn = FollowingPkmn.get_pokemon
    return if !first_pkmn
    FollowingPkmn.refresh_internal
    ret = FollowingPkmn.active?
    event = FollowingPkmn.get_event
    if anim
      anim_name = ret ? :ANIMATION_COME_OUT : :ANIMATION_COME_IN
      anim_id   = nil
      anim_id   = FollowingPkmn.const_get(anim_name) if FollowingPkmn.const_defined?(anim_name)
      if event && anim_id
        $scene.spriteset.addUserAnimation(anim_id, event.x, event.y, false, 1)
      end
    end
    FollowingPkmn.change_sprite(first_pkmn) if ret
    FollowingPkmn.move_route([(ret ? PBMoveRoute::STEP_ANIME_ON : PBMoveRoute::STEP_ANIME_OFF)]) if FollowingPkmn::ALWAYS_ANIMATE
    event&.calculate_bush_depth
    $PokemonGlobal.time_taken = 0 if !ret
    return ret
  end
  #-----------------------------------------------------------------------------
  # Forcefully refresh Following Pokemon sprite with animation (if specified)
  #-----------------------------------------------------------------------------
  def self.remove_sprite
    FollowingPkmn.get_event&.character_name = ""
    FollowingPkmn.get_data&.character_name  = ""
    FollowingPkmn.get_event&.character_hue  = 0
    FollowingPkmn.get_data&.character_hue   = 0
  end
  #-----------------------------------------------------------------------------
  # Set the Following Pokemon sprite to a different Pokemon
  #-----------------------------------------------------------------------------
  def self.change_sprite(pkmn)
    shiny = pkmn.shiny?
    shiny = pkmn.superVariant if (pkmn.respond_to?(:superVariant) && !pkmn.superVariant.nil? && pkmn.superShiny?)
    swimming = FollowingPkmn.should_use_swimming_sprites?
    fname = GameData::Species.ow_sprite_filename(pkmn.species, pkmn.form,
      pkmn.gender, shiny, pkmn.shadow, swimming)
    fname.gsub!("Graphics/Characters/", "")
    FollowingPkmn.get_event&.character_name = fname
    FollowingPkmn.get_data&.character_name  = fname
    if FollowingPkmn.get_event&.move_route_forcing
      hue = pkmn.respond_to?(:superHue) && pkmn.superShiny? ? pkmn.superHue : 0
      FollowingPkmn.get_event&.character_hue  = hue
      FollowingPkmn.get_data&.character_hue   = hue
    end
  end
  #-----------------------------------------------------------------------------
end

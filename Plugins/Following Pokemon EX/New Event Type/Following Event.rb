#-------------------------------------------------------------------------------
# Defining a new method for base Essentials followers to show dust animation
#-------------------------------------------------------------------------------
class Game_Follower
  def update_move
    was_jumping = jumping?
    super
    show_dust_animation if was_jumping && !jumping?
  end

  if !method_defined?(:show_dust_animation)
    def show_dust_animation
      spriteset = $scene.spriteset(map_id)
      spriteset&.addUserAnimation(Settings::DUST_ANIMATION_ID, self.x, self.y, true, 1)
    end
  end
end

#-------------------------------------------------------------------------------
# Defining a new class for Following Pokemon event which has several additions
# to make it more robust as a Following Pokemon
#-------------------------------------------------------------------------------
class Game_FollowingPkmn < Game_Follower
  def initialize(*args)
    super(*args)
    @last_leader_x = nil
    @last_leader_y = nil
  end

  #-----------------------------------------------------------------------------
  # Update pattern at a constant rate independent of move speed
  #-----------------------------------------------------------------------------
  def update_pattern
    return if @lock_pattern
    if @moved_last_frame && !@moved_this_frame && !@step_anime
      @pattern = @original_pattern
      @anime_count = 0
      return
    end
    if !@moved_last_frame && @moved_this_frame && !@step_anime
      @pattern = (@pattern + 1) % 4 if @walk_anime
      @anime_count = 0
      return
    end
    pattern_time = pattern_update_speed / 4   # 4 frames per cycle in a charset
    return if @anime_count < pattern_time
    # Advance to the next animation frame
    @pattern = (@pattern + 1) % 4
    @anime_count -= pattern_time
  end
  #-----------------------------------------------------------------------------
  # Don't turn off walk animation when sliding on ice if the following pokemon
  # is airborne.
  #-----------------------------------------------------------------------------
  alias __followingpkmn__walk_anime walk_anime= unless method_defined?(:__followingpkmn__walk_anime)
  def walk_anime=(value)
    return if $PokemonGlobal.ice_sliding && (!FollowingPkmn.active? || FollowingPkmn.airborne_follower?)
    __followingpkmn__walk_anime(value)
  end
  #-----------------------------------------------------------------------------
  # Don't reset walk animation when sliding on ice if the following pokemon is
  # airborne.
  #-----------------------------------------------------------------------------
  alias __followingpkmn__straighten straighten unless method_defined?(:__followingpkmn__straighten)
  def straighten
    return if $PokemonGlobal.ice_sliding && (!FollowingPkmn.active? || FollowingPkmn.airborne_follower?)
    __followingpkmn__straighten
  end
  #-----------------------------------------------------------------------------
  # Don't show dust animation if Following Pokemon isn't active or is airborne
  #-----------------------------------------------------------------------------
  def show_dust_animation
    return if !FollowingPkmn.active? || FollowingPkmn.airborne_follower?
    super
  end

  #-----------------------------------------------------------------------------
  # Allow following pokemon to freely walk on water
  #-----------------------------------------------------------------------------
  def location_passable?(x, y, direction)
    this_map = self.map
    return false if !this_map || !this_map.valid?(x, y)
    return true if @through
    passed_tile_checks = false
    bit = (1 << ((direction / 2) - 1)) & 0x0f
    # Check all events for ones using tiles as graphics, and see if they're passable
    this_map.events.each_value do |event|
      next if event.tile_id < 0 || event.through || !event.at_coordinate?(x, y)
      tile_data = GameData::TerrainTag.try_get(this_map.terrain_tags[event.tile_id])
      next if tile_data.ignore_passability
      next if tile_data.bridge && $PokemonGlobal.bridge == 0
      return false if tile_data.ledge
      # Allow Folllowers to surf if they can travel on water
      return true if tile_data.can_surf && FollowingPkmn.waterborne_follower?
      passage = this_map.passages[event.tile_id] || 0
      return false if passage & bit != 0
      passed_tile_checks = true if (tile_data.bridge && $PokemonGlobal.bridge > 0) ||
                                   (this_map.priorities[event.tile_id] || -1) == 0
      break if passed_tile_checks
    end
    # Check if tiles at (x, y) allow passage for follower
    if !passed_tile_checks
      [2, 1, 0].each do |i|
        tile_id = this_map.data[x, y, i] || 0
        next if tile_id == 0
        tile_data = GameData::TerrainTag.try_get(this_map.terrain_tags[tile_id])
        next if tile_data.ignore_passability
        next if tile_data.bridge && $PokemonGlobal.bridge == 0
        return false if tile_data.ledge
        # Allow Folllowers to surf if they can travel on water
        return true if tile_data.can_surf && FollowingPkmn.waterborne_follower?
        passage = this_map.passages[tile_id] || 0
        return false if passage & bit != 0
        break if tile_data.bridge && $PokemonGlobal.bridge > 0
        break if (this_map.priorities[tile_id] || -1) == 0
      end
    end
    # Check all events on the map to see if any are in the way
    this_map.events.values.each do |event|
      next if !event.at_coordinate?(x, y)
      return false if !event.through && event.character_name != ""
    end
    return true
  end

  #-----------------------------------------------------------------------------
  # Updating the event turning to prevent following Pokemon from changing its
  # direction with the player
  #-----------------------------------------------------------------------------
  def turn_towards_leader(leader)
    return if FollowingPkmn.active? && !FollowingPkmn::ALWAYS_FACE_PLAYER
    pbTurnTowardEvent(self, leader)
  end

  #-----------------------------------------------------------------------------
  # Updating the method which controls event position to include changes to
  # work with Marin and Boonzeet's side stairs
  #-----------------------------------------------------------------------------
  def follow_leader(leader, instant = false, leaderIsTrueLeader = true)
    return if @move_route_forcing
    # Don't interrupt movement unless leader has moved significantly
    return if (jumping? || moving?) && !instant && 
              leader.x == @last_leader_x && leader.y == @last_leader_y
    end_movement

    old_terrain = $map_factory.getTerrainTag(self.map.map_id, self.x, self.y) if self.x && self.y
    # Check if the leader has moved to a new tile
    if @last_leader_x.nil? || @last_leader_y.nil? || leader.x != @last_leader_x || leader.y != @last_leader_y
      @last_leader_x = leader.x
      @last_leader_y = leader.y

      maps_connected = $map_factory.areConnected?(leader.map.map_id, self.map.map_id)
      target = nil

      # Get the target tile that self wants to move to
      if maps_connected
        # MODIFIED: Logic to check multiple directions for a valid spot
        bg_dir = 10 - leader.direction
        dirs = []
        case leader.direction
        when 2 then dirs = [8, 4, 6] # Down -> Up, Left, Right
        when 4 then dirs = [6, 2, 8] # Left -> Right, Down, Up
        when 6 then dirs = [4, 2, 8] # Right -> Left, Down, Up
        when 8 then dirs = [2, 4, 6] # Up -> Down, Left, Right
        else        dirs = [bg_dir]
        end
        
        dirs.each do |dir|
          t = $map_factory.getFacingTile(dir, leader)
          next if !t
          
          # Check passability
          map = $map_factory.getMap(t[0])
          next if !map || !map.valid?(t[1], t[2])
          
          # Check for blocking events (excluding through events)
          blocked_by_event = map.events.values.any? do |e|
            !e.through && e.at_coordinate?(t[1], t[2]) && e != self && e != leader
          end
          next if blocked_by_event
          
          # Check passability using the follower itself (self)
          if map.passable?(t[1], t[2], 0, self)
            target = t
            break
          end
        end

        # If no target found by strict passability, allow falling back to player position (below)

        
        if target && $map_factory.getTerrainTag(target[0], target[1], target[2]).ledge
          # Get the tile above the ledge (where the leader jumped from)
          # Use bg_dir as a best guess for "behind" logic
          target = $map_factory.getFacingTileFromPos(target[0], target[1], target[2], bg_dir)
        end
        target = [leader.map.map_id, leader.x, leader.y] if !target
        if GameData::TerrainTag.exists?(:StairLeft)
          currentTag = $map_factory.getTerrainTag(self.map.map_id, self.x, self.y)
          if currentTag == :StairLeft
            target[2] += (target[1] > $game_player.x ? -1 : 1)
          elsif currentTag == :StairRight
            target[2] += (target[1] < $game_player.x ? -1 : 1)
          end
        end
        # Added
        if defined?(on_stair?) && on_stair?
          if leader.on_stair?
            if leader.stair_start_x != self.stair_start_x
              # Leader stepped on other side so start/end swapped, but not for follower yet
              target[2] = self.y
            elsif leader.stair_start_x < leader.stair_end_x
              # Left to Right
              if leader.x < leader.stair_start_x && self.x != self.stair_start_x
                # Leader stepped off
                target[2] = self.y
              end
            elsif leader.stair_end_x < leader.stair_start_x
              # Right to Left
              if leader.x > leader.stair_start_x && self.x != self.stair_start_x
                # Leader stepped off
                target[2] = self.y
              end
            end
          elsif self.on_middle_of_stair?
            # Leader is no longer on stair but follower is, so player moved up or down at the start or end of the stair
            if leader.y < self.stair_end_y - self.stair_y_height + 1 || leader.y > self.stair_end_y
              target[2] = self.y
            end
          end
        end
      else
        # Map transfer to an unconnected map
        target = [leader.map.map_id, leader.x, leader.y]
      end

      # Move self to the target
      if self.map.map_id != target[0]
        vector = $map_factory.getRelativePos(target[0], 0, 0, self.map.map_id, @x, @y)
        @map = $map_factory.getMap(target[0])
        # NOTE: Can't use moveto because vector is outside the boundaries of the
        #       map, and moveto doesn't allow setting invalid coordinates.
        @x = vector[0]
        @y = vector[1]
        @real_x = @x * Game_Map::REAL_RES_X
        @real_y = @y * Game_Map::REAL_RES_Y
      end

      if instant || !maps_connected
        moveto(target[1], target[2])
      else
        fancy_moveto(target[1], target[2], leader)
      end
      
      # Fix for tall grass and surf animations - recalculate bush depth after movement
      calculate_bush_depth
      
      # Check if we moved from/to water and refresh sprite if needed
      # This is done here in follow_leader to avoid recursion issues when accessing
      # $game_temp.followers during moveto/fancy_moveto
      new_terrain = $map_factory.getTerrainTag(self.map.map_id, self.x, self.y)
      if old_terrain && (old_terrain.can_surf != new_terrain.can_surf)
        pkmn = FollowingPkmn.get_pokemon
        FollowingPkmn.change_sprite(pkmn) if pkmn
      end
    end
  end

  #-----------------------------------------------------------------------------
  # Override moveto to ensure bush depth is recalculated after any movement
  #-----------------------------------------------------------------------------
  def moveto(x, y)
    super(x, y)
    calculate_bush_depth
  end

  #-----------------------------------------------------------------------------
  # Override fancy_moveto to ensure bush depth is recalculated after movement
  #-----------------------------------------------------------------------------
  def fancy_moveto(new_x, new_y, leader)
    super(new_x, new_y, leader)
    calculate_bush_depth
  end

  #-----------------------------------------------------------------------------
  # Allow following pokemon to move through obstacles when necessary
  #-----------------------------------------------------------------------------
  def move_through(direction)
    old_through = @through
    @through = true
    
    case direction
    when 2 then move_down
    when 4 then move_left
    when 6 then move_right
    when 8 then move_up
    end
    
    @through = old_through
    @step_anime = true
  end

  #-----------------------------------------------------------------------------
  # Make Follower Appear above player
  #-----------------------------------------------------------------------------
  def screen_z(height = 0)
    ret = super
    return ret + 1
  end

  #-----------------------------------------------------------------------------
  # Adjust screen_x to account for visual offset (prevents overlap)
  #-----------------------------------------------------------------------------
  def screen_x(*args)
    ret = super(*args)
    return ret unless FollowingPkmn.active?
    
    offset = FollowingPkmn::FOLLOWER_DISTANCE_OFFSET
    pkmn = FollowingPkmn.get_pokemon
    if pkmn && FollowingPkmn::FOLLOWER_DISTANCE_EXCEPTIONS[pkmn.species]
      offset = FollowingPkmn::FOLLOWER_DISTANCE_EXCEPTIONS[pkmn.species]
    end
    
    # Move opposite to facing direction to "push away" from what it's facing (usually player)
    # Check passability to ensure we don't visual clip into walls
    case self.direction
    when 4 # Facing Left -> Move Right
      ret += offset if self.map.passable?(self.x, self.y, 6)
    when 6 # Facing Right -> Move Left
      ret -= offset if self.map.passable?(self.x, self.y, 4)
    end
    return ret
  end

  #-----------------------------------------------------------------------------
  # Adjust screen_y to account for visual offset (prevents overlap)
  #-----------------------------------------------------------------------------
  def screen_y(*args)
    ret = super(*args)
    return ret unless FollowingPkmn.active?

    offset = FollowingPkmn::FOLLOWER_DISTANCE_OFFSET
    pkmn = FollowingPkmn.get_pokemon
    if pkmn && FollowingPkmn::FOLLOWER_DISTANCE_EXCEPTIONS[pkmn.species]
      offset = FollowingPkmn::FOLLOWER_DISTANCE_EXCEPTIONS[pkmn.species]
    end
    
    # Move opposite to facing direction to "push away" from what it's facing (usually player)
    # Check passability to ensure we don't visual clip into walls
    case self.direction
    when 2 # Facing Down -> Move Up
      ret -= offset if self.map.passable?(self.x, self.y, 8)
    when 8 # Facing Up -> Move Down
      ret += offset if self.map.passable?(self.x, self.y, 2)
    end
    return ret
  end
  #-----------------------------------------------------------------------------
end

class FollowerData
  #-----------------------------------------------------------------------------
  # Shorthand for checking whether the data is for a Following Pokemon event
  #-----------------------------------------------------------------------------
  def following_pkmn?; return name[/FollowingPkmn/]; end
  #-----------------------------------------------------------------------------
  # Updating the FollowerData interact method to allow Following Pokemon to
  # interact with the player without needing a common event
  #-----------------------------------------------------------------------------
  alias __followingpkmn__interact interact unless method_defined?(:__followingpkmn__interact)
  def interact(*args)
    return __followingpkmn__interact(*args) if !following_pkmn?
    if !@common_event_id
      event = args[0]
      $game_map.refresh if $game_map.need_refresh
      event.lock
      FollowingPkmn.talk
      event.unlock
    elsif FollowingPkmn.can_talk?
      return __followingpkmn__interact(*args)
    end
  end
  #-----------------------------------------------------------------------------
end


class Game_FollowerFactory
  #-----------------------------------------------------------------------------
  # Define the Following as a different class from Game_Follower ie
  # Game_FollowingPkmn
  #-----------------------------------------------------------------------------
  alias __followingpkmn__create_follower_object create_follower_object unless private_method_defined?(:__followingpkmn__create_follower_object)
  def create_follower_object(*args)
    return Game_FollowingPkmn.new(args[0]) if args[0].following_pkmn?
    return __followingpkmn__create_follower_object(*args)
  end
  #-----------------------------------------------------------------------------
  # Following Pokemon shouldn't be a leader if it is inactive.
  #-----------------------------------------------------------------------------
  def move_followers
    leader = $game_player
    $PokemonGlobal.followers.each_with_index do |follower, i|
      event = @events[i]
      event.follow_leader(leader, false, (i == 0))
      follower.x              = event.x
      follower.y              = event.y
      follower.current_map_id = event.map.map_id
      follower.direction      = event.direction
      leader = event if !event.is_a?(Game_FollowingPkmn) || FollowingPkmn.active?
    end
  end
  #-----------------------------------------------------------------------------
  # Following Pokemon shouldn't be a leader if it is inactive.
  #-----------------------------------------------------------------------------
  def turn_followers
    leader = $game_player
    $PokemonGlobal.followers.each_with_index do |follower, i|
      event = @events[i]
      event.turn_towards_leader(leader)
      follower.direction = event.direction
      leader = event if !event.is_a?(Game_FollowingPkmn) || FollowingPkmn.active?
    end
  end
  #-----------------------------------------------------------------------------
  # Method to remove all Followers except Following Pokemon
  #-----------------------------------------------------------------------------
  def remove_all_except_following_pkmn
    followers = $PokemonGlobal.followers
    followers.each_with_index do |follower, i|
      next if follower.following_pkmn?
      followers[i] = nil
      @events[i] = nil
      @last_update += 1
    end
    followers.compact!
    @events.compact!
  end
  #-----------------------------------------------------------------------------
end

#-------------------------------------------------------------------------------
# Ensure the follower only moves when the player moves exactly one tile
# DISABLED: This was causing followers to teleport/stutter on bridges because
# it updates on EVERY frame during movement animation instead of only when
# the player completes a tile. The follower system already handles updates
# properly via follow_leader's leader position tracking.
#-------------------------------------------------------------------------------
# class Scene_Map
#   alias __followingevent__update update unless method_defined?(:__followingevent__update)
#   def update(*args)
#     __followingevent__update(*args)
#     if $game_player.moving?
#       $game_temp.followers.move_followers
#       $game_temp.followers.turn_followers
#     end
#   end
# end
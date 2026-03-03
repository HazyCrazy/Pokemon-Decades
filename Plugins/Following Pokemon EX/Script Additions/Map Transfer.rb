#-------------------------------------------------------------------------------
#  Unhides hidden followers after completing move animation
#-------------------------------------------------------------------------------
class Game_Player
  alias_method :update_move_with_follower, :update_move unless method_defined?(:update_move_with_follower)
  def update_move
    update_move_with_follower

    FollowingPkmn.unhide_follower(false) if !moving?
  end
end
#-------------------------------------------------------------------------------
#  Enables temporarily hiding follower Pokemon
#-------------------------------------------------------------------------------
module FollowingPkmn
  @@hidden = false

  # @return [Boolean]
  def self.active?
    @@can_refresh && !@@hidden
  end

  # @return [Boolean]
  def self.hidden?
    @@hidden
  end

  # Temporarily hides the follower sprite
  def self.hide_follower
    @@hidden = true

    remove_sprite
  end

  # Unhides the follower sprite if active
  def self.unhide_follower(anim = true)
    return unless self.hidden?

    @@hidden = false

    # Check if follower should be active (without hidden check)
    if @@can_refresh && $PokemonGlobal.follower_toggled
      self.refresh(anim)
    end
  end
end
#-------------------------------------------------------------------------------
#  Temporarily hides follower sprites when transfering players across maps
#-------------------------------------------------------------------------------
class Interpreter
  def command_201
    return true if $game_temp.in_battle
    return false if $game_temp.player_transferring ||
                    $game_temp.message_window_showing ||
                    $game_temp.transition_processing
    # Set up the transfer and the player's new coordinates
    $game_temp.player_transferring = true
    if @parameters[0] == 0   # Direct appointment
      $game_temp.player_new_map_id    = @parameters[1]
      $game_temp.player_new_x         = @parameters[2]
      $game_temp.player_new_y         = @parameters[3]
    else   # Appoint with variables
      $game_temp.player_new_map_id    = $game_variables[@parameters[1]]
      $game_temp.player_new_x         = $game_variables[@parameters[2]]
      $game_temp.player_new_y         = $game_variables[@parameters[3]]
    end
    $game_temp.player_new_direction = @parameters[4]
    # Hide follower when transfering maps using event commands
    FollowingPkmn.hide_follower
    @index += 1
    # If transition happens with a fade, do the fade
    if @parameters[5] == 0
      Graphics.freeze
      $game_temp.transition_processing = true
      $game_temp.transition_name       = ""
    end
    return false
  end
end
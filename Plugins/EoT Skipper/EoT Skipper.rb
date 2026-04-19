#=============================================================================
# End of Turn Skipper (Atlat)
#
# END_OF_TURN
# 0 = Original system (everything as-is)
# 1 = Original system only in singles, new system in multi-battles
# 2 = Always use new system
#
# EOR_NOTIFICATIONS
# false = Do not show notifications with new system
# true = Show notifications with new system
#=============================================================================

END_OF_TURN = 2

EOR_NOTIFICATIONS = false

class Battle

  #=============================================================================
  # Main End Of Round phase method.
  #=============================================================================

  alias pbEndOfRoundPhase_original pbEndOfRoundPhase

  def pbEndOfRoundPhase
    pbEndOfRoundPhase_original
    @endOfRound = true
    if pbSpeedyEndOfRound? && EOR_NOTIFICATIONS
      @scene.pbDisposeEndOfTurnEffects
      pbShowEndOfRoundMessages
    end
    @endOfRound = false
  end
  
  
  def pbSpeedyEndOfRound?
    return @endOfRound && !(END_OF_TURN == 0 || (END_OF_TURN == 1 && singleBattle?))
  end
  
  def pbDisplay(msg, &block)
    if pbSpeedyEndOfRound?
      return if !EOR_NOTIFICATIONS
      @pendingEORMessages ||= Hash.new { |h, k| h[k] = [] }
      key = @currentEORBattler || :global
      @pendingEORMessages[key] << msg.to_s
    else
      @scene.pbDisplayMessage(msg, &block)
    end
  end
  
  def pbShowEndOfRoundMessages
    return if !@pendingEORMessages
    @pendingEORMessages.each do |battler, messages|
      battler_obj = battler.is_a?(Integer) ? @battlers[battler] : battler
      @scene.pbShowEndOfTurnEffects(battler_obj || OpenStruct.new(name: "???"), messages)
    end
    @pendingEORMessages.clear
  end
end

#===============================================================================
# Changed to when animations play.
#===============================================================================

class Battle::Scene
  alias_method :pbCommonAnimation_original, :pbCommonAnimation
  def pbCommonAnimation(animName, user = nil, target = nil)
    return if nil_or_empty?(animName)
    return if @battle&.pbSpeedyEndOfRound?
    pbCommonAnimation_original(animName, user, target)
  end

  alias_method :pbDamageAnimation_original, :pbDamageAnimation
  def pbDamageAnimation(battler, effectiveness = 0)
    return if @battle&.pbSpeedyEndOfRound?
    pbDamageAnimation_original(battler, effectiveness)
  end

  #=============================================================================
  # Graphics for the new End of Round scene.
  #=============================================================================

  # Draw centered text on the Name Box
  def pbShowEndOfTurnBar(battler)
    if @sprites["eor_box_name"]
      @sprites["eor_box_name"].dispose
      @sprites.delete("eor_box_name")
    end
    base_bitmap = RPG::Cache.ui("Battle/box_name")
    name_sprite = Sprite.new(@viewport)
    name_sprite.bitmap = base_bitmap.clone
    name_sprite.z = 99999
    name_sprite.x = Graphics.width - name_sprite.bitmap.width - 16
    name_sprite.y = 16
    @sprites["eor_box_name"] = name_sprite
    overlay = Bitmap.new(name_sprite.bitmap.width, name_sprite.bitmap.height)
    overlay.font.name = MessageConfig.pbGetSystemFontName
    overlay.font.size = 20
    base   = Color.new(248, 248, 248)
    shadow = Color.new(40, 40, 40)
    text = "Battle Effects"
    # Center the text horizontally
    text_width = overlay.text_size(text).width
    x_center  = (overlay.width - text_width) / 2
    pbDrawTextPositions(overlay, [[text, x_center, 6, :left, base, shadow]])
    name_sprite.bitmap.blt(0, 0, overlay, overlay.rect)
    overlay.dispose
  end
  
  # Draw effect boxes with dynamic font size
  def pbShowEndOfTurnEffects(battler, effects)
    return if effects.empty?
    effects = effects.compact.map { |e| e.is_a?(Hash) ? e[:text].to_s : e.to_s }
    if @eor_effect_sprites
      @eor_effect_sprites.each(&:dispose)
      @eor_effect_sprites.clear
    else
      @eor_effect_sprites = []
    end
    pbShowEndOfTurnBar(battler)
    name_sprite = @sprites["eor_box_name"]
    base_z = name_sprite.z
    base_y = name_sprite.y
    start_y       = base_y + 34
    final_gap     = 2
    step_amount   = 3
    frame_wait    = 0.01
    initial_pause = 0.3
    pause         = 0.1
    effects.each_with_index do |effect, i|
      sprite = Sprite.new(@viewport)
      sprite.bitmap = RPG::Cache.ui("Battle/box_effect").clone
      sprite.z = base_z - i - 1
      sprite.x = Graphics.width - sprite.bitmap.width - 16
      sprite.y = start_y
      overlay = sprite.bitmap
      overlay.font.name = MessageConfig.pbGetSystemFontName
      overlay.font.size = 18
      base   = Color.new(248, 248, 248)
      shadow = Color.new(40, 40, 40)
      text = effect.is_a?(Hash) && effect[:text] ? effect[:text] : effect.to_s.capitalize
      # Dynamically reduce font until text fits within box width minus padding
      max_width = overlay.width - 12
      while overlay.text_size(text).width > max_width && overlay.font.size > 6
        overlay.font.size -= 1
      end
      # Center text horizontally
      text_width = overlay.text_size(text).width
      x_center = (overlay.width - text_width) / 2
      pbDrawTextPositions(overlay, [[text, x_center, 6, :left, base, shadow]])
      @eor_effect_sprites << sprite
    end
    pbWait(initial_pause)
    @eor_effect_sprites.each_with_index do |sprite, i|
      target_y = base_y + i * final_gap
      while sprite.y > target_y
        sprite.y -= step_amount
        sprite.y = target_y if sprite.y < target_y
        Graphics.update
        Input.update
        pbWait(frame_wait)
      end
      pbWait(pause)
    end
    pbWait(pause)
    pbDisposeEndOfTurnEffects
  end

  def pbDisposeEndOfTurnEffects
    if @sprites["eor_box_name"]
      @sprites["eor_box_name"].dispose
      @sprites.delete("eor_box_name")
    end
    if @eor_effect_sprites
      @eor_effect_sprites.each(&:dispose)
      @eor_effect_sprites.clear
    end
  end
end
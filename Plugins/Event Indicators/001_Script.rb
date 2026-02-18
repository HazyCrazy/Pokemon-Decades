class EventIndicator
    attr_accessor :type
    attr_accessor :event
    attr_accessor :visible
    attr_accessor :movement_counter
    attr_accessor :movement_speed
    attr_accessor :animation_counter
    attr_accessor :animation_speed
    attr_accessor :animation_frame_amount
    attr_accessor :indicator

    def initialize(params, event, viewport, map)
        @type = params[0]
        @event = event
        @viewport = viewport
        @map = map
        @alwaysvisible = false
        @ignoretimeshade = false
        @x_adj = Settings::EVENT_INDICATOR_X_ADJ
        @y_adj = Settings::EVENT_INDICATOR_Y_ADJ
        @x_adj += params[1] if params[1] && params[1].is_a?(Integer)
        @y_adj += params[2] if params[2] && params[2].is_a?(Integer)

        data = Settings::EVENT_INDICATORS[@type]
        if !data
            @disposed = true
            return
        end
        @x_adj += data[:x_adjustment] if data[:x_adjustment]
        @y_adj += data[:y_adjustment] if data[:y_adjustment]

        if can_vertical_move?
            @movement_speed = data[:movement_speed] || Settings::EVENT_INDICATOR_DEFAULT_MOVEMENT_SPEED
            @movement_speed = 1 if @movement_speed < 1
            @movement_counter = 0
        end 
        if data[:animation_frames]
            @animation_frame_amount = data[:animation_frames]
            @animation_counter = 0
            @animation_speed = data[:animation_speed] || Settings::EVENT_INDICATOR_DEFAULT_ANIMATION_SPEED
        end

        @alwaysvisible = true if data[:always_visible]
        @ignoretimeshade = true if data[:ignore_time_shading]
		@condition = data[:condition]
        if @animation_frame_amount && @animation_frame_amount > 1
            @indicator = IndicatorIconSprite.new(data[:graphic], @animation_frame_amount, viewport)
        else
            @indicator = IconSprite.new(0, 0, viewport)
            @indicator.setBitmap(data[:graphic])
            @indicator.ox = @indicator.bitmap.width / 2
        end
        @indicator.oy = @indicator.bitmap.height
        @indicator.z = 1000
        @disposed = false
    end
  
    def disposed?
        @disposed
    end
  
    def dispose
        @indicator.dispose
        @disposed = true
    end
  
    def update
        if @alwaysvisible
            @visible = true
        elsif pbMapInterpreterRunning? && pbMapInterpreter.get_self && @event && pbMapInterpreter.get_self.id == @event.id
            @visible = false
        else
            @visible = true
        end
        @visible = @alwaysvisible || !(pbMapInterpreterRunning? && pbMapInterpreter&.get_self&.id == @event&.id)
        @visible = false if @condition && !@condition.call
        @indicator.update
        @indicator.visible = @visible
        pbDayNightTint(@indicator) unless @ignoretimeshade
        @indicator.x = @event.screen_x + @x_adj
        @indicator.y = @event.screen_y - Game_Map::TILE_HEIGHT + @y_adj
        if @movement_speed
            @movement_counter += 1
            @movement_counter = 0 if @movement_counter >= @movement_speed * 4
            case @movement_counter
            when @movement_speed...@movement_speed * 2
                @indicator.y += 2
            when @movement_speed*3...@movement_speed * 4
                @indicator.y -= 2
            end
        end
        if @animation_frame_amount && @animation_frame_amount > 1 && @visible
            @animation_counter += 1
            if @animation_counter >= @animation_speed
                @indicator.advanceFrame
                @animation_counter = 0
            end
        end
    end

    def can_vertical_move?
        return false if $PokemonSystem.eventindicatorsmove == 1
        return false if Settings::EVENT_INDICATORS[@type][:no_movement]
        return Settings::EVENT_INDICATOR_VERTICAL_MOVEMENT
    end
end

class Scene_Map
    attr_reader :spritesets
end

class Spriteset_Map
    attr_accessor :event_indicator_sprites
            
    alias event_indicator_spriteset_init initialize 
    def initialize(map = nil)
        @event_indicator_sprites = []
        event_indicator_spriteset_init(map)
    end
    
    def addEventIndicator(new_sprite, forced = false)
        return false if Settings::EVENT_INDICATOR_ALLOW_HIDE_OPTION && $PokemonSystem.showeventindicators == 1
        return false if !Settings::EVENT_INDICATORS[new_sprite.type]
        return false if !forced && @event_indicator_sprites[new_sprite.event.id] && !@event_indicator_sprites[new_sprite.event.id].disposed?
        return false if new_sprite.event.map_id != @map.map_id
        old_move_counter = nil
        old_anim_counter = nil
        old_anim_frame = nil
        old_type = nil
        old_sprite = @event_indicator_sprites[new_sprite.event.id]
        if old_sprite
            old_type = old_sprite.type
            old_move_counter = old_sprite.movement_counter if old_sprite.movement_counter
            if old_sprite.animation_counter
                old_anim_counter = old_sprite.animation_counter 
                old_anim_frame = old_sprite.indicator.currentFrame 
            end
            old_sprite.dispose
        end
        @event_indicator_sprites[new_sprite.event.id] = new_sprite
        if @event_indicator_sprites[new_sprite.event.id].type == old_type
            @event_indicator_sprites[new_sprite.event.id].movement_counter = old_move_counter if old_move_counter
            if old_anim_counter
                @event_indicator_sprites[new_sprite.event.id].animation_counter = old_anim_counter 
                @event_indicator_sprites[new_sprite.event.id].indicator.setFrame(old_anim_frame)
            end
        end
        return true
    end

    def refreshEventIndicator(event)
        params = event.pbCheckForActiveIndicator
        if params
            ret = addEventIndicator(EventIndicator.new(params, event, @@viewport1, map), true)
            @event_indicator_sprites[event.id].dispose if @event_indicator_sprites[event.id] && !ret
        elsif @event_indicator_sprites[event.id] && map.map_id == event.map_id
            @event_indicator_sprites[event.id].dispose
        end
    end
    
    alias event_indicator_spriteset_dispose dispose
    def dispose
        event_indicator_spriteset_dispose
        @event_indicator_sprites.each do |sprite| 
            next if sprite.nil?
            sprite.dispose
        end
        @event_indicator_sprites.clear
    end
    
    alias event_indicator_spriteset_update update 
    def update
        event_indicator_spriteset_update
        @event_indicator_sprites.each do |sprite| 
            next if sprite.nil?
            sprite.update if !sprite.disposed?
        end
    end
end

class Game_Event < Game_Character
    attr_accessor :event_indicator_refresh

    def pbCheckForActiveIndicator
        ret = pbEventCommentInput(self, 1, "Event Indicator")
        if ret
            ret = ret[0].split.map { |x| x.match?(/^-?\d+$/) ? x.to_i : x }
        end
        return ret 
    end

    alias event_indicator_e_refresh refresh
    def refresh
        event_indicator_e_refresh
        if $scene.is_a?(Scene_Map) && $scene.spritesets && $scene.spriteset
            $scene.spriteset.refreshEventIndicator(self)
        end
    end

end

class IndicatorIconSprite < Sprite
    attr_accessor :currentFrame

    def initialize(path, numFrames = 1, viewport = nil)
      super(viewport)
      @numFrames = numFrames
      @currentFrame = 0
      @animBitmap = AnimatedBitmap.new(path)
      self.bitmap = @animBitmap.bitmap
      self.src_rect.height = @animBitmap.height
      self.src_rect.width  = @animBitmap.width / @numFrames
      self.ox = self.src_rect.width / 2
    end

    def setFrame(frame)
        @currentFrame = frame
        @currentFrame = 0 if @currentFrame >= @numFrames
        self.src_rect.x = self.src_rect.width * @currentFrame
    end

    def advanceFrame
        setFrame(@currentFrame + 1)
    end

end
  
EventHandlers.add(:on_new_spriteset_map, :add_event_indicators,
    proc do |spriteset, viewport|
        map = spriteset.map
        map.events.each_key do |i|
            event = map.events[i]
            params = event.pbCheckForActiveIndicator
            spriteset.addEventIndicator(EventIndicator.new(params, event, viewport, map)) if params
        end
    end
)

class PokemonSystem
    attr_accessor :showeventindicators
    attr_accessor :eventindicatorsmove

    alias event_indicator_syst_init initialize
    def initialize
        event_indicator_syst_init
        @showeventindicators = 0
        @eventindicatorsmove = 0
    end
end
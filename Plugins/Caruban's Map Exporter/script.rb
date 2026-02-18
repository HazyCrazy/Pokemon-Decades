#===============================================================================
# Map Exporter Class
#===============================================================================
class CarubanMapExporter
  EXPORTED_FILENAME = "ExportedMap"

  def initialize(mapid, options)
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99999
    @mapid = mapid
    @options = options
    @mapSprites = {}
    getMapConnections
    createmapSprite(mapid)
    adjustMapPositions(mapid, []) if @options[:connected_maps]
    centeringImage
    exportImage
  end

  #---------------------------------------------------------------

  def getMapConnections
    conns = MapFactoryHelper.getMapConnections
    @mapconns = []
    @adjustedmap = []
    conns.each do |map_conns|
      next if !map_conns
      map_conns.each do |c|
        @mapconns.push(c.clone) if @mapconns.none? { |x| x[0] == c[0] && x[3] == c[3] }
      end
    end
  end

  def createmapSprite(id)
    if !@mapSprites[id]
      @mapSprites[id] = Sprite.new(@viewport)
      @mapSprites[id].z = 0
      @mapSprites[id].bitmap = nil
      @mapSprites[id].visible = false
    end
    if !@mapSprites[id].bitmap || @mapSprites[id].bitmap.disposed?
      @mapSprites[id].bitmap = createBitmapMap(id, @options)
    end
  end

  def setMapSpritePos(id, x, y)
    createmapSprite(id) if !@mapSprites[id]
    @mapSprites[id].x = x
    @mapSprites[id].y = y
  end

  def adjustMapPositions(id, sprites)
    conns = @mapconns
    mapsprite = @mapSprites[id]
    dispx = mapsprite.x
    dispy = mapsprite.y
    tilesize = 32
    conns.each do |conn|
      if conn[0] == id
        b = sprites.any? { |i| i == conn[3] }
        if !b
          x = ((conn[1] - conn[4]) * tilesize) + dispx
          y = ((conn[2] - conn[5]) * tilesize) + dispy
          setMapSpritePos(conn[3], x, y)
          sprites.push(conn[3])
          adjustMapPositions(conn[3], sprites)
        end
      elsif conn[3] == id
        b = sprites.any? { |i| i == conn[0] }
        if !b
          x = ((conn[4] - conn[1]) * tilesize) + dispx
          y = ((conn[5] - conn[2]) * tilesize) + dispy
          setMapSpritePos(conn[0], x, y)
          sprites.push(conn[3])
          adjustMapPositions(conn[0], sprites)
        end
      end
    end
  end

  def centeringImage
    # Centering
    minx = miny = 0
    maxx = maxy = 0
    @mapSprites.each do |k, s|
      minx = s.x if minx > s.x
      miny = s.y if miny > s.y
      maxx = s.x + s.width if maxx < s.x + s.width
      maxy = s.y + s.height if maxy < s.y + s.height
    end
    @full_width = maxx - minx
    @full_height = maxy - miny
    @mapSprites.each do |k, s|
      s.x += minx * -1 if minx != 0
      s.y += miny * -1 if miny != 0
    end
  end
  
  #---------------------------------------------------------------
  # Tile Drawing Helper

  def createBitmapMap(mapid, options = {})
    map = load_data(sprintf("Data/Map%03d.rxdata", mapid)) rescue nil
    return Bitmap.new(32, 32) if !map
    tilesize = 32
    bitmap = Bitmap.new(map.width * tilesize, map.height * tilesize)
    black = Color.black
    tilesets = $data_tilesets
    tileset = tilesets[map.tileset_id]
    return bitmap if !tileset
    objects_y = {}
    # Map Tiles
    helper = TileDrawingHelper.fromTileset(tileset)
    map.height.times do |y|
      map.width.times do |x|
        3.times do |z|
          id = map.data[x, y, z]
          id = 0 if !id
          terrain_tag = tileset.terrain_tags[id] || 0
          terrain_tag_data = GameData::TerrainTag.try_get(terrain_tag)
          priority = tileset.priorities[id] || 0
          if terrain_tag_data.shows_reflections
            this_y = -100
          else
            this_y = (priority == 0) ? 0 : (y * 32) + (priority * 32) + 32 + 1
          end
          objects_y[[x, y, z]] = this_y + z
        end
      end
    end
    # Player Event
    objects_y["player"] = $game_player.y if @options[:player_event]
    # Map Events
    map.events.keys.each {|k| objects_y[k] = map.events[k].y } if @options[:map_events]
    # Sorted objects
    sorted_keys = objects_y.keys.sort { |a, b| objects_y[a] <=> objects_y[b] } # lowest to highest
    sorted_keys.each do |id|
      if id.is_a?(Array)
        x = id[0]; y = id[1]; z = id[2]
        id = map.data[x, y, z]
        id = 0 if !id
        helper.bltTile(bitmap, x * 32, y * 32, id)
      elsif id == "player"
        meta = GameData::PlayerMetadata.get($player.character_ID)
        filename = pbGetPlayerCharset(meta.walk_charset, $player, true)
        bmp = Bitmap.new("Graphics/Characters/" + filename)
        dir = $game_player.direction
        bitmap.blt($game_player.x * 32 + 16 - bmp.width / 8, ($game_player.y + 1) * 32 - bmp.height / 4,
            bmp, Rect.new(0, bmp.height / 4 * (dir / 2 - 1), bmp.width / 4, bmp.height / 4))
      else
        event = map.events[id]
        @event_id = id
        @map_id = mapid
        # Get Actived page
        new_page = nil
        event.pages.reverse.each_with_index do |page, i|
          c = page.condition
          next if c.switch1_valid && !switchIsOn?(c.switch1_id)
          next if c.switch2_valid && !switchIsOn?(c.switch2_id)
          next if c.variable_valid && $game_variables[c.variable_id] < c.variable_value
          if c.self_switch_valid
            key = [mapid, event.id, c.self_switch_ch]
            next if $game_self_switches[key] != true
          end
          new_page = page
          break
        end
        @event_id = nil
        @map_id = nil
        next if !new_page
        page = new_page
        cw = 32
        ch = 32
        ex = ey = 0
        if page.graphic.tile_id >= 384
          bmp = pbGetTileBitmap(tileset.tileset_name, page.graphic.tile_id,
                                page.graphic.character_hue)
        elsif page.graphic.character_name && page.graphic.character_name.size > 0
          bmp = Bitmap.new("Graphics/Characters/#{page.graphic.character_name}")
          if bmp
            bmp = bmp.clone
            bmp.hue_change(page.graphic.character_hue) unless page.graphic.character_hue == 0
            ex = bmp.width / 4 * page.graphic.pattern
            ey = bmp.height / 4 * (page.graphic.direction / 2 - 1)
            cw = bmp.width / 4
            ch = bmp.height / 4
          end
        end
        next if !bmp
        bitmap.blt(event.x * 32 + 16 - (cw / 2), (event.y + 1) * 32 - ch, bmp,
            Rect.new(ex, ey, cw, ch))
        bmp.dispose
        bmp = nil
      end
    end
    # Outline
    if options[:outline]
      bitmap.fill_rect(0, 0, bitmap.width, 1, black)
      bitmap.fill_rect(0, bitmap.height - 1, bitmap.width, 1, black)
      bitmap.fill_rect(0, 0, 1, bitmap.height, black)
      bitmap.fill_rect(bitmap.width - 1, 0, 1, bitmap.height, black)
    end
    if options[:map_name] || options[:map_id]
      pbSetSystemFont(bitmap)
      mapname = map.pbGetMapNameFromId(mapid)
      name = []
      name.push(mapname)                  if options[:map_name]
      name.push(sprintf("[%03d]",mapid))  if options[:map_id]
      x = map.width * tilesize / 2
      y = map.height * tilesize - (32 * name.length) - 4
      textpos = []
      name.each_with_index do |n, i|
        textpos.push([n, x, y + (32 * i), :center, Color.new(80, 80, 80), Color.new(248, 248, 248), :outline])
      end
      pbDrawTextPositions(bitmap, textpos)
    end
    return bitmap
  end
  
  #---------------------------------------------------------------
  # Event Utilities  
  def tsOn?(c); return false; end
  def tsOff?(c); return true; end
  def isOff?(c); return !$game_self_switches[[@map_id, @event_id, c]]; end

  def switchIsOn?(id)
    switchname = $data_system.switches[id]
    return false if !switchname
    if switchname[/^s\:/]
      return eval($~.post_match)
    else
      return $game_switches[id]
    end
  end

  def variable
    return nil if !$PokemonGlobal.eventvars
    return $PokemonGlobal.eventvars[[@map_id, @event_id]]
  end

  def varAsInt
    return 0 if !$PokemonGlobal.eventvars
    return $PokemonGlobal.eventvars[[@map_id, @event_id]].to_i
  end

  def expired?(secs = 86_400)
    ontime = self.variable
    time = pbGetTimeNow
    return ontime && (time.to_i > ontime + secs)
  end

  def expiredDays?(days = 1)
    ontime = self.variable.to_i
    return false if !ontime
    now = pbGetTimeNow
    elapsed = (now.to_i - ontime) / 86_400
    elapsed += 1 if (now.to_i - ontime) % 86_400 > ((now.hour * 3600) + (now.min * 60) + now.sec)
    return elapsed >= days
  end

  def cooledDown?(seconds)
    return true if expired?(seconds) && tsOff?("A")
    return false
  end

  def cooledDownDays?(days)
    return true if expiredDays?(days) && tsOff?("A")
    return false
  end

  #---------------------------------------------------------------

  def exportImage
    result = Bitmap.new(@full_width, @full_height)
    @mapSprites.each do |k, s|
      result.blt(s.x, s.y, s.bitmap, Rect.new(0, 0, s.width, s.height))
    end
    result.to_file("#{EXPORTED_FILENAME}.png")
    result.dispose
    pbDisposeSpriteHash(@mapSprites)
    @viewport.dispose
  end
end

#===============================================================================
# Menu Handlers
#===============================================================================
MenuHandlers.add(:debug_menu, :exportmap_menu, {
  "name"        => "Export a Map",
  "parent"      => :field_menu,
  "description" => "Choose a map and export is as a PNG Image.",
  "effect"      => proc { |sprites, viewport|
    pbFadeOutIn do
      viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
      viewport.z = 99999
      bg = BitmapSprite.new(Graphics.width, Graphics.height, viewport)
      bg.bitmap.fill_rect(0, 0, Graphics.width, Graphics.height, Color.black)
      chosen = pbDefaultMap
      loop do
        cmd = 0
        chosen = pbListScreen(_INTL("Choose a map"), MapLister.new(chosen))
        options = {
          :map_events     => false,
          :player_event   => false,
          :outline        => false,
          :connected_maps => false,
          :map_name       => false,
          :map_id         => false,
          :game_title     => false,
        }
        break if chosen < 0
        loop do
          cmdMapEvent = -1
          cmdMapPlayer = -1
          cmdMapOutline = -1
          cmdMapConnect = -1
          cmdMapName = -1
          cmdMapID = -1
          cmds = []
          cmds[cmdMapEvent = cmds.length]   = (options[:map_events] ? "[Y]" : "[  ]") + " " + _INTL("Show Map Events")
          cmds[cmdMapPlayer = cmds.length]  = (options[:player_event] ? "[Y]" : "[  ]") + " " + _INTL("Show Player Event") if $game_map.map_id == chosen
          cmds[cmdMapOutline = cmds.length] = (options[:outline] ? "[Y]" : "[  ]") + " " + _INTL("Show Outline")
          cmds[cmdMapName = cmds.length]    = (options[:map_name] ? "[Y]" : "[  ]") + " " + _INTL("Show Map Name")
          cmds[cmdMapID = cmds.length]      = (options[:map_id] ? "[Y]" : "[  ]") + " " + _INTL("Show Map ID")
          cmds[cmdMapConnect = cmds.length] = (options[:connected_maps] ? "[Y]" : "[  ]") + " " + _INTL("Export Connected Maps") if MapFactoryHelper.hasConnections?(chosen)
          cmds.push(_INTL("Export Map"))
          cmd = pbShowCommands(nil, cmds, -1, cmd)
          break if cmd < 0
          case cmd
          when cmdMapEvent                # Map Events
            options[:map_events] = !options[:map_events]
          when cmdMapPlayer               # Player event
            options[:player_event] = !options[:player_event]
          when cmdMapOutline              # Export outline
            options[:outline] = !options[:outline]
          when cmdMapName                 # Export Map Name
            options[:map_name] = !options[:map_name]
          when cmdMapID                   # Export Map Name
            options[:map_id] = !options[:map_id]
          when cmdMapConnect              # Connected Maps
            options[:connected_maps] = !options[:connected_maps]
          when cmds.length - 1            # Export Map
            msgwindow = Window_AdvancedTextPokemon.newWithSize(_INTL("Exporting..."),
              0, Graphics.height - 96, Graphics.width, 96, viewport
            )
            msgwindow.setSkin(MessageConfig.pbGetSpeechFrame)
            Graphics.update
            CarubanMapExporter.new(chosen, options)
            pbDisposeMessageWindow(msgwindow)
            pbMessage(_INTL("The map has been exported successfully."))
            break
          end
        end
      end
      bg.dispose
      viewport.dispose
    end
  }
})

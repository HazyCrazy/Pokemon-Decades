#===============================================================================
# Summary handler.
#===============================================================================
# Rewrites the Ribbons page handler.
#-------------------------------------------------------------------------------
UIHandlers.add(:summary, :page_ribbons, {
  "name"      => "MEMENTOS",
  "suffix"    => "mementos",
  "order"     => 50,
  "layout"    => proc { |pkmn, scene| scene.drawPageMementos }
})


#===============================================================================
# Selection sprite.
#===============================================================================
# Tweaks the selection sprite used for highlighting mementos in the Summary.
#-------------------------------------------------------------------------------
class RibbonSelectionSprite < MoveSelectionSprite
  attr_reader :showActive
  attr_reader :activePage
  
  def initialize(viewport = nil)
    super(viewport)
    path = Settings::MEMENTOS_GRAPHICS_PATH
    @movesel = AnimatedBitmap.new(path + "cursor")
    @frame = 0
    @index = 0
    @activePage = 0
    @showActive = false
    @preselected = false
    @updating = false
    @spriteVisible = true
    refresh
  end

  def visible=(value)
    super
    @spriteVisible = value if !@updating
  end
  
  def showActive=(value)
    @showActive = value
  end
  
  def activePage=(value)
    @activePage = value
  end
  
  def getMemento(mementos, page = nil)
    page = @activePage if page.nil?
    page_size = MementoSprite::PAGE_SIZE
    idxList = (page * page_size) + @index
    return mementos[idxList]
  end

  def refresh
    w = @movesel.width / 2
    h = @movesel.height / 3
    style = (PluginManager.installed?("BW Summary Screen")) ? 1 : 0
    self.x = 12 + ((self.index % 6) * 82)
    self.y = 50 + ((self.index / 6).floor * 82)
    self.bitmap = @movesel.bitmap
    if self.preselected
      self.src_rect.set(w * style, h * 2, w, h)
    elsif self.showActive
      self.src_rect.set(w * style, 0, w, h)
    else
      self.src_rect.set(w * style, h, w, h)
    end
  end

  def update
    @updating = true
    super
    page_size = MementoSprite::PAGE_SIZE
    self.visible = @spriteVisible && @index >= 0 && @index < page_size
    @movesel.update
    @updating = false
    refresh
  end
end
	

#===============================================================================
# Memento sprite.
#===============================================================================
# Used to draw the entire page of memento icons at once.
#-------------------------------------------------------------------------------
class MementoSprite < Sprite
  PAGE_SIZE = 12
  ROW_SIZE  = 6
  ICON_GAP  = 82
  PAGE_X    = 12
  PAGE_Y    = 46

  def initialize(mementos, page, viewport = nil)
    super(viewport)
    @memento_sprites = []
    path = Settings::MEMENTOS_GRAPHICS_PATH
    mementos = [mementos] * PAGE_SIZE if !mementos.is_a?(Array)
    PAGE_SIZE.times do |i|
      index = PAGE_SIZE * page + i
      break if index > mementos.length - 1
      memento = mementos[index]
      data = GameData::Ribbon.try_get(memento)
      next if !data
      icon = data.icon_position
      @memento_sprites[i] = IconSprite.new(0, 0, @viewport)
      @memento_sprites[i].setBitmap(path + "mementos")
      @memento_sprites[i].viewport = self.viewport
      @memento_sprites[i].src_rect.x = 78 * (icon % 8)
      @memento_sprites[i].src_rect.y = 78 * (icon / 8).floor
      @memento_sprites[i].src_rect.width = 78
      @memento_sprites[i].src_rect.height = 78
      xpos = PAGE_X + (ICON_GAP * (i % ROW_SIZE))
      ypos = PAGE_Y + (ICON_GAP * (i / ROW_SIZE).floor)
      @memento_sprites[i].x = xpos
      @memento_sprites[i].y = ypos
    end
    @contents = BitmapWrapper.new(324, 296)
    self.bitmap = @contents
  end
  
  def dispose
    if !disposed?
      PAGE_SIZE.times do |i|
        @memento_sprites[i]&.dispose
      end
      @contents.dispose
      super
    end
  end
  
  def visible=(value)
    super
    PAGE_SIZE.times do |i|
      if @memento_sprites[i] && !@memento_sprites[i].disposed?
        @memento_sprites[i].visible = value
      end
    end
  end
  
  def setMementos(mementos, page)
    PAGE_SIZE.times do |i|
      index = PAGE_SIZE * page + i
      memento = mementos[index]
      path = Settings::MEMENTOS_GRAPHICS_PATH
      if GameData::Ribbon.exists?(memento)
        icon = GameData::Ribbon.get(memento).icon_position
        @memento_sprites[i].src_rect.x = 78 * (icon % 8)
        @memento_sprites[i].src_rect.y = 78 * (icon / 8).floor
        @memento_sprites[i].visible = true
      else
        @memento_sprites[i].visible = false
      end
    end
  end
  
  def getPageSize(list, page)
    count = 0
    PAGE_SIZE.times do |i|
      index = PAGE_SIZE * page + i
      break if index > list.length - 1
      count += 1 if list[index]
    end
    return count
  end
  
  def update
    @memento_sprites.each { |s| s.update }
  end
end


#===============================================================================
# Summary UI.
#===============================================================================
# Changes and additions to add the Mementos page in the Summary.
#-------------------------------------------------------------------------------
class PokemonSummary_Scene
  alias memento_pbStartScene pbStartScene
  def pbStartScene(party, partyindex, inbattle = false)
    memento_pbStartScene(party, partyindex, inbattle)
    @sprites["uparrow"].x = (Graphics.width / 2) - 14
    @sprites["uparrow"].y = 30
    @sprites["downarrow"].x = (Graphics.width / 2) - 14
    @sprites["downarrow"].y = 184
    @sprites["mementosel"] = RibbonSelectionSprite.new(@viewport)
    @sprites["mementosel"].showActive = true
    @sprites["mementosel"].visible = false
    @sprites["mementos"] = MementoSprite.new(GameData::Ribbon::DATA.first[0], 0, @viewport)
    @sprites["mementos"].visible = false
  end
  
  #-----------------------------------------------------------------------------
  # Draws the Mementos page.
  #-----------------------------------------------------------------------------
  def drawPageMementos
    overlay = @sprites["overlay"].bitmap
    blkBase   = Color.new(64, 64, 64)
    blkShadow = Color.new(176, 176, 176)
    whtBase   = Color.new(248, 248, 248)
    whtShadow = Color.new(104, 104, 104)
    @sprites["uparrow"].visible   = false
    @sprites["downarrow"].visible = false
    path  = Settings::MEMENTOS_GRAPHICS_PATH
    idnum = type = name = title = "---"
    memento_data = GameData::Ribbon.try_get(@pokemon.memento)
    xpos = (PluginManager.installed?("BW Summary Screen")) ? -4 : 218
    ypos = (PluginManager.installed?("BW Summary Screen")) ? 70 : 74
    imagepos = []
    if memento_data
      title_data = memento_data.title_upcase(@pokemon)
      icon  = memento_data.icon_position
      idnum = (icon + 1).to_s
      rank  = @pokemon.getMementoRank(@pokemon.memento)
      name  = memento_data.name
      title = _INTL("'{1}'", title_data) if !nil_or_empty?(title_data)
      type  = (memento_data.is_ribbon?) ? "Ribbon" : "Mark"
      typeX = (memento_data.is_ribbon?) ? 184 : 194
      imagepos.push([path + "mementos", xpos + 12, ypos + 14, 78 * (icon % 8), 78 * (icon / 8).floor, 78, 78],
                    [path + "memento_icon", xpos + typeX, ypos + 7, (memento_data.is_ribbon?) ? 0 : 28, 0, 28, 28])
      if rank < 5
        rank.times do |i| 
          offset = (rank == 1) ? 44 : (rank == 2) ? 35 : (rank == 3) ? 26 : 17
          imagepos.push([path + "memento_rank", xpos + 182 + offset + (18 * i), ypos + 77])
        end
      else
        imagepos.push([path + "memento_rank", xpos + 246, ypos + 77])
      end
    end
    pbDrawImagePositions(overlay, imagepos)
    textpos = [
      [_INTL("Type:"),            xpos + 104, ypos + 12,  0, whtBase, whtShadow],
      [_INTL("ID No.:"),          xpos + 104, ypos + 44,  0, whtBase, whtShadow],
      [_INTL("#{idnum}"),         xpos + 234, ypos + 44,  2, blkBase, blkShadow],
      [_INTL("Rank:"),            xpos + 104, ypos + 76,  0, whtBase, whtShadow],
      [_INTL("Name:"),            xpos + 145, ypos + 116, 2, whtBase, whtShadow],
      [_INTL("#{name}"),          xpos + 145, ypos + 148, 2, blkBase, blkShadow],
      [_INTL("Title Conferred:"), xpos + 145, ypos + 190, 2, whtBase, whtShadow],
      [_INTL("#{title}"),         xpos + 145, ypos + 222, 2, blkBase, blkShadow],
      [_INTL("View mementos:"),   xpos + 212, ypos + 268, 1, whtBase, whtShadow]
    ]
    if memento_data
      typeX = (memento_data.is_ribbon?) ? 213 : 228
      textpos.push([_INTL("#{type}"), xpos + typeX, ypos + 12, 0, blkBase, blkShadow])
      textpos.push([_INTL("#{rank}"), xpos + 240, ypos + 76, 1, blkBase, blkShadow]) if rank > 4
    else
      textpos.push([_INTL("#{type}"), xpos + 232, ypos + 12, 2, blkBase, blkShadow])
    end
    pbDrawTextPositions(overlay, textpos)
  end
  
  #-----------------------------------------------------------------------------
  # Draws the mementos display window to scroll through.
  #-----------------------------------------------------------------------------
  def drawSelectedRibbon(filter, index, page, maxpage)
    base   = Color.new(64, 64, 64)
    shadow = Color.new(176, 176, 176)
    nameBase   = Color.new(248, 248, 248)
    nameShadow = Color.new(104, 104, 104)
    path = Settings::MEMENTOS_GRAPHICS_PATH
    page_size = MementoSprite::PAGE_SIZE
    idxList = (page * page_size) + index
    memento_data = GameData::Ribbon.try_get(filter[idxList])
    overlay = @sprites["overlay"].bitmap
    activesel = @sprites["mementosel"]
    if filter.include?(@pokemon.memento)
      activeidx = filter.index(@pokemon.memento)
      activesel.index = activeidx - page_size * page
      activesel.activePage = (activeidx / page_size).floor
    end
    activesel.visible = activesel.activePage == page
    preselect = @sprites["ribbonpresel"]
    preselect.visible = preselect.activePage == page
    @sprites["ribbonsel"].index = index
    @sprites["ribbonsel"].activePage = page
    @sprites["uparrow"].visible = page > 0
    @sprites["uparrow"].z = @sprites["mementos"].z + 1
    @sprites["downarrow"].visible = page < maxpage
    @sprites["downarrow"].z = @sprites["mementos"].z + 1
    @sprites["mementos"].setMementos(filter, page) if !filter.empty?
    style = (PluginManager.installed?("BW Summary Screen")) ? 1 : 0
    imagepos = [[path + "overlay", 0, 0, 512 * style, 0, 512, 386]]
    imagepos.push([path + "memento_active", 36, 226]) if memento_data && memento_data.id == @pokemon.memento
    imagepos.push([path + "memento_icon", 8, 8, (memento_data.is_ribbon?) ? 0 : 28, 0, 28, 28]) if memento_data
    rank = (memento_data) ? @pokemon.getMementoRank(memento_data.id) : 0
    if rank < 5
      rank.times do |i| 
        offset = (rank == 1) ? 44 : (rank == 2) ? 35 : (rank == 3) ? 26 : 17
        imagepos.push([path + "memento_rank", 416 + offset + (18 * i), 226])
      end
    else
      imagepos.push([path + "memento_rank", 480, 226])
    end
    pbDrawImagePositions(overlay, imagepos)
    name  = (memento_data) ? memento_data.name : "---"
    desc  = (memento_data) ? memento_data.description : ""
    count = (memento_data) ? "#{idxList + 1}/#{filter.length}" : ""
    title_data = (memento_data) ? memento_data.title_upcase(@pokemon) : ""
    title = (!nil_or_empty?(title_data)) ? _INTL("'{1}'", title_data) : "---"
    textpos = [
      [_INTL("#{count}"), 210, 12, 1, nameBase, nameShadow],
      [name, Graphics.width / 2, 224, 2, nameBase, nameShadow],
      [_INTL("Title Conferred:"), 10, 260, 0, base, shadow],
      [title, 346, 260, 2, base, shadow]
    ]
    if memento_data
      case @mementoFilter
      when :ribbon   then header = "Ribbon"
      when :mark     then header = "Mark"
      when :contest  then header = "Contest"
      when :league   then header = "League"
      when :frontier then header = "Frontier"
      when :memorial then header = "Memorial"
      when :gift     then header = "Special"
      else                header = "Memento"
      end
      textpos.push([_INTL("#{header}"), 40, 12, 0, nameBase, nameShadow])
      textpos.push([_INTL("#{rank}"), 476, 224, 1, nameBase, nameShadow]) if rank > 4
    end
    pbDrawTextPositions(overlay, textpos)
    drawTextEx(overlay, 10, 292, 494, 3, desc, base, shadow)
  end
  
  #-----------------------------------------------------------------------------
  # The controls while viewing all of a Pokemon's mementos.
  #-----------------------------------------------------------------------------
  def pbRibbonSelection
    @mementoFilter = (Settings::COLLAPSE_RANKED_MEMENTOS) ? :rank : nil
    filter    = pbFilteredMementos
    page      = 0
    index     = 0
    row_size  = MementoSprite::ROW_SIZE
    page_size = MementoSprite::PAGE_SIZE
    maxpage   = ((filter.length - 1) / page_size).floor
    @sprites["ribbonsel"].index = 0
    @sprites["ribbonsel"].visible = true
    @sprites["ribbonpresel"].index = 0
    @sprites["ribbonpresel"].activePage = -1
    @sprites["mementosel"].index = 0
    @sprites["mementosel"].activePage = -1
    switching = false
    if filter.include?(@pokemon.memento)
      idxList = filter.index(@pokemon.memento)
      page = (idxList / page_size).floor
      index = idxList - page_size * page
    end
    drawSelectedRibbon(filter, index, page, maxpage)
    loop do
      Graphics.update
      Input.update
      pbUpdate
      count = 0
      dorefresh = false
      #-------------------------------------------------------------------------
      if Input.repeat?(Input::UP)
        if index >= row_size
          index -= row_size
          dorefresh = true
        else
          if page > 0
            page -= 1
            index += row_size
            dorefresh = true
          elsif maxpage > 0
            page = maxpage
            count = @sprites["mementos"].getPageSize(filter, page) - 1
            if index + row_size <= count
              index += row_size
            elsif index > count
              index = count
            end
            dorefresh = true
          end
        end
      #-------------------------------------------------------------------------
      elsif Input.repeat?(Input::DOWN)
        if index < row_size
          count = @sprites["mementos"].getPageSize(filter, page) - 1
          if count < index + row_size
            if page == maxpage && maxpage > 0
              page = 0
              index -= row_size if index >= row_size
              dorefresh = true
            end
          else
            index += row_size
            dorefresh = true
          end
        else
          if page < maxpage
            page += 1
            count = @sprites["mementos"].getPageSize(filter, page) - 1
            index -= row_size
            index = count if index > count
            dorefresh = true
          elsif maxpage > 0
            page = 0
            index -= row_size if index >= row_size
            dorefresh = true
          end
        end
      #-------------------------------------------------------------------------
      elsif Input.repeat?(Input::LEFT)
        if index > 0
          index -= 1
          dorefresh = true
        else
          if page > 0
            page -= 1
            count = @sprites["mementos"].getPageSize(filter, page) - 1
            index = count
            dorefresh = true
          else
            page = maxpage
            count = @sprites["mementos"].getPageSize(filter, page) - 1
            next if count == 0 && page == 0
            index = count
            dorefresh = true
          end
        end
      #-------------------------------------------------------------------------
      elsif Input.repeat?(Input::RIGHT)
        count = @sprites["mementos"].getPageSize(filter, page) - 1
        next if count == 0 && page == 0
        if index < count
          index += 1
          dorefresh = true
        else
          if page < maxpage
            page += 1
            index = 0
            dorefresh = true
          else
            page = 0
            index = 0
            dorefresh = true
          end
        end
      #-------------------------------------------------------------------------
      elsif Input.repeat?(Input::JUMPUP)
        if page > 0
          page -= 1
          index = 0
          dorefresh = true
        end
      #-------------------------------------------------------------------------
      elsif Input.repeat?(Input::JUMPDOWN)
        if page < maxpage
          page += 1
          index = 0
          dorefresh = true
        end
      #-------------------------------------------------------------------------
      elsif Input.trigger?(Input::ACTION)
        if filter.include?(@pokemon.memento)
          oldpg, oldidx = page, index
          idxList = filter.index(@pokemon.memento)
          page = (idxList / page_size).floor
          index = idxList - page_size * page
          dorefresh = (page != oldpg || index != oldidx)
        end
      #-------------------------------------------------------------------------
      elsif Input.trigger?(Input::USE)
        if switching
          memento = @sprites["ribbonpresel"].getMemento(filter)
          oldidx = filter.index(memento)
          newidx = (page * page_size) + index
          @pokemon.ribbons[oldidx] = @pokemon.ribbons[newidx]
          @pokemon.ribbons[newidx] = memento
          @sprites["ribbonpresel"].activePage = -1
          @sprites["ribbonpresel"].visible = false
          switching = false
          dorefresh = true
        else
          memento = @sprites["ribbonsel"].getMemento(filter, page)
          option = pbMementoOptions(memento)
          case option
          when :endscreen then break
          when :switching then switching = true
          when :dorefresh then dorefresh = true; page = index = 0
          end
        end
      #-------------------------------------------------------------------------
      elsif Input.trigger?(Input::BACK)
        (switching) ? pbPlayCancelSE : pbPlayCloseMenuSE
        break if !switching
        @sprites["ribbonpresel"].activePage = -1
        @sprites["ribbonpresel"].visible = false
        switching = false
      end
      #-------------------------------------------------------------------------
      if dorefresh && !filter.empty?
        pbPlayCursorSE
        filter = pbFilteredMementos
        maxpage = ((filter.length - 1) / page_size).floor
        drawSelectedRibbon(filter, index, page, maxpage)
      end
    end
    @sprites["mementosel"].activePage = -1
    @sprites["mementosel"].visible = false
    @sprites["ribbonsel"].visible = false
    @sprites["mementos"].visible = false
  end
  
  #-----------------------------------------------------------------------------
  # A utility for getting a filtered list of mementos when using sorting options.
  #-----------------------------------------------------------------------------
  def pbFilteredMementos
    filter = []
    case @mementoFilter
    when :rank     then return @pokemon.collapsed_mementos                                                          # Shows only collapsed mementos
    when :ribbon   then @pokemon.ribbons.each { |m| filter.push(m) if GameData::Ribbon.get(m).is_ribbon? }          # Shows only Ribbons
    when :mark     then @pokemon.ribbons.each { |m| filter.push(m) if GameData::Ribbon.get(m).is_mark? }            # Shows only Marks
    when :contest  then @pokemon.ribbons.each { |m| filter.push(m) if GameData::Ribbon.get(m).is_contest_ribbon? }  # Shows only Contest Ribbons
    when :league   then @pokemon.ribbons.each { |m| filter.push(m) if GameData::Ribbon.get(m).is_league_ribbon? }   # Shows only League Ribbons
    when :frontier then @pokemon.ribbons.each { |m| filter.push(m) if GameData::Ribbon.get(m).is_frontier_ribbon? } # Shows only Frontier Ribbons
    when :memorial then @pokemon.ribbons.each { |m| filter.push(m) if GameData::Ribbon.get(m).is_memorial_ribbon? } # Shows only Memorial Ribbons
    when :gift     then @pokemon.ribbons.each { |m| filter.push(m) if GameData::Ribbon.get(m).is_gift_ribbon? }     # Shows only Special Ribbons
    else           return @pokemon.ribbons                                                                          # Shows all mementos
    end
    return filter
  end
  
  #-----------------------------------------------------------------------------
  # A utility for generating the list of options while selecting a memento.
  #-----------------------------------------------------------------------------
  def pbMementoOptions(memento)
    ids = []
    commands = []
    if memento
      if !@mementoFilter
        ids.push(:move)
        commands.push(_INTL("Move"))
      end
      if !@inbattle
        ids.push(:confer)                    if !@pokemon.shadowPokemon?
        commands.push(_INTL("Confer title")) if !@pokemon.shadowPokemon?
        ids.push(:remove)                    if @pokemon.memento
        commands.push(_INTL("Remove title")) if @pokemon.memento
      end
    end
    pbPlayDecisionSE
    ids.push(:sort, :cancel)
    commands.push(_INTL("Sort mementos"), _INTL("Cancel"))    
    loop do
      cmd = pbShowCommands(commands, 0)
      break if cmd < 0 || cmd >= commands.length - 1
      case ids[cmd]
      when :move
        @sprites["ribbonpresel"].index = @sprites["ribbonsel"].index
        @sprites["ribbonpresel"].activePage = @sprites["ribbonsel"].activePage
        @sprites["ribbonpresel"].visible = true
        return :switching
      when :confer
        return :endscreen if pbConferTitle(memento)
      when :remove
        if pbConfirmMessage(_INTL("Would you like to remove {1}'s attached memento and conferred title?", @pokemon.name))
          @pokemon.memento = nil
          pbMessage(_INTL("{1}'s memento and any associated titles were removed.", @pokemon.name))
          return :endscreen
        end
      when :sort
        sorted = []
        sort_commands = []
        [:rank, :ribbon, :mark, :contest, :league, :frontier, :memorial, :gift].each do |check|
          next if check == @mementoFilter
          next if !@pokemon.hasMementoType?(check)
          sorted.push(check)
          case check
          when :rank     then sort_commands.push(_INTL("Only highest rank"))
          when :ribbon   then sort_commands.push(_INTL("Only ribbons"))
          when :mark     then sort_commands.push(_INTL("Only marks"))
          when :contest  then sort_commands.push(_INTL("Only contest ribbons"))
          when :league   then sort_commands.push(_INTL("Only league ribbons"))
          when :frontier then sort_commands.push(_INTL("Only frontier ribbons"))
          when :memorial then sort_commands.push(_INTL("Only memorial ribbons"))
          when :gift     then sort_commands.push(_INTL("Only special ribbons"))
          end
        end
        sort_commands.push(_INTL("All mementos"), _INTL("Cancel"))
        sort_cmd = pbShowCommands(sort_commands, 0)
        if sort_cmd >= 0 && sort_cmd < sort_commands.length - 1 && sorted[sort_cmd] != @mementoFilter
          @mementoFilter = sorted[sort_cmd]
          return :dorefresh
        else
          break
        end
      else
        break
      end
    end
  end
  
  #-----------------------------------------------------------------------------
  # A utility for conferring a selected title on a Pokemon.
  #-----------------------------------------------------------------------------
  def pbConferTitle(memento)
    memento_data = GameData::Ribbon.get(memento)
    if !nil_or_empty?(memento_data.title(@pokemon))
      if @mementoFilter == :rank
        allRanks = memento_data.prev_ranks.clone
        allRanks.push(memento)
        last_title = nil
        allRanks.each_with_index do |r, i|
          title = GameData::Ribbon.get(r).title(@pokemon)
          allRanks[i] = nil if !title || title == last_title
          last_title = title
        end
        allRanks.compact!
      end
      if @mementoFilter == :rank && allRanks.length > 1
        pbMessage(_INTL("This memento has multiple ranks.\nWhich title should be conferred?"))
        cmd = 0
        commands = []
        allRanks = allRanks.reverse
        allRanks.each { |r| commands.push(_INTL("{1}", GameData::Ribbon.get(r).title_upcase(@pokemon))) }
        commands.push(_INTL("Cancel"))
        loop do
          cmd = pbShowCommands(commands, 0)
          break if cmd < 0 || cmd >= commands.length - 1
          case @pokemon.memento
          when allRanks[cmd]
            pbMessage(_INTL("{1} has already been conferred with this title...", @pokemon.name))
            if pbConfirmMessage(_INTL("Would you like to remove this attached memento from {1}?", @pokemon.name))
              @pokemon.memento = nil
              pbMessage(_INTL("{1}'s memento and any associated titles were removed.", @pokemon.name))
              return true
            end
          else
            @pokemon.memento = allRanks[cmd]
            pbMessage(_INTL("{1} will now be known as\n{2}!", @pokemon.name, @pokemon.name_title))
            return true
          end
        end
      else
        case @pokemon.memento
        when memento
          pbMessage(_INTL("{1} has already been conferred with this title...", @pokemon.name))
          if pbConfirmMessage(_INTL("Would you like to remove this attached memento from {1}?", @pokemon.name))
            @pokemon.memento = nil
            pbMessage(_INTL("{1}'s memento and any associated titles were removed.", @pokemon.name)) 
            return true
          end
        else
          if pbConfirmMessage(_INTL("Would you like to attach this memento and confer its title to {1}?", @pokemon.name))
            @pokemon.memento = memento
            pbMessage(_INTL("{1} will now be known as\n{2}!", @pokemon.name, @pokemon.name_title)) 
            return true
          end
        end
      end
    else
      pbMessage(_INTL("This memento doesn't have any associated title to confer...")) 
    end
    return false
  end
end
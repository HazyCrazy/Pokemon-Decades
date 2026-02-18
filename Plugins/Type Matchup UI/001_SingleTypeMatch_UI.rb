class TypeMatch_Scene

  # Filename for base graphic
  WINDOWSKIN = "base.png"
  
  # Choose whether you want the background to animate
  MOVINGBACKGROUND = true
  
  def initialize
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99999
    @sprites = {}
	@bg_scroll_speed = 0.5  # Adjust this value to control the speed of scrolling
    @bg_ox = 0.0
    @bg_oy = 0.0
  end
  
   def addBackgroundPlane(sprites, key, file, viewport)
    sprites[key] = Plane.new(viewport)
    sprites[key].bitmap = Bitmap.new(file)
    sprites[key].z = 0
    sprites[key].ox = 0
    sprites[key].oy = 0
   end
 
  def pbStartScene
    addBackgroundPlane(@sprites,"bg","Graphics/UI/TypeMatch/bg",@viewport)
    @sprites["base"] = IconSprite.new(0,0,@viewport)
    @sprites["base"].setBitmap("Graphics/UI/TypeMatch/"+WINDOWSKIN)
    @sprites["base"].ox = @sprites["base"].bitmap.width/2
    @sprites["base"].oy = @sprites["base"].bitmap.height/2
    @sprites["base"].x = Graphics.width/2; @sprites["base"].y = Graphics.height/2 - 16
    @h = @sprites["base"].y - @sprites["base"].oy
    @w = @sprites["base"].x - @sprites["base"].ox
    @typebitmap = AnimatedBitmap.new(_INTL("Graphics/UI/types"))
    2.times do |i|
      @sprites["icon_#{i}"] = PokemonSpeciesIconSprite.new(nil,@viewport)
      @sprites["icon_#{i}"].setOffset(PictureOrigin::CENTER)
      @sprites["icon_#{i}"].x = Graphics.width/2 - 96 + 192*i
      @sprites["icon_#{i}"].y = @h+34
      @sprites["icon_#{i}"].mirror = true if i==0
    end
    @sprites["rightarrow"] = AnimatedSprite.new("Graphics/UI/right_arrow",8,40,28,2,@viewport)
    @sprites["rightarrow"].x = Graphics.width - @sprites["rightarrow"].bitmap.width
    @sprites["rightarrow"].y = Graphics.height/2 - @sprites["rightarrow"].bitmap.height/16
    @sprites["rightarrow"].visible = false
    @sprites["rightarrow"].play
    @sprites["leftarrow"] = AnimatedSprite.new("Graphics/UI/left_arrow",8,40,28,2,@viewport)
    @sprites["leftarrow"].x = 0
    @sprites["leftarrow"].y = Graphics.height/2 - @sprites["rightarrow"].bitmap.height/16
    @sprites["leftarrow"].visible = false
    @sprites["leftarrow"].play
    @sprites["bottombar"] = BitmapSprite.new(Graphics.width,Graphics.height,@viewport)
    @sprites["bottombar"].bitmap.fill_rect(0,Graphics.height-32,Graphics.width,32,Color.new(48,192,216))
    @sprites["bottombar"].visible = true
    @sprites["text"] = BitmapSprite.new(Graphics.width,Graphics.height,@viewport)
    @overlay_text = @sprites["text"].bitmap
    pbSetSystemFont(@overlay_text)
    @sprites["type"] = BitmapSprite.new(Graphics.width,Graphics.height,@viewport)
    @overlay_type = @sprites["type"].bitmap
    @types = []
    GameData::Type.each { |s| @types.push(s.id) if !s.pseudo_type }
    @types.sort!
  end
    
  def pbTypeMatchUp
    @index = 0
    type = @types[@index]
    @init = true
    drawTypes(type)
    pbFadeInAndShow(@sprites) { pbUpdate }
    loop do
      Graphics.update
      Input.update
      pbUpdate
      refresh = false
      if Input.trigger?(Input::RIGHT) && @index< @types.length-1
        pbPlayCursorSE
        @index +=1
        newType = @types[@index]
        refresh = true
      elsif Input.trigger?(Input::LEFT) && @index> 0
        pbPlayCursorSE
        @index -=1
        newType = @types[@index]
        refresh = true
      elsif Input.trigger?(Input::USE) # Option to choose specific type
        oldType = @types[@index]
        newType = pbChooseTypeFromList(oldType, oldType)
        if oldType != newType
          @index = @types.index(newType)
          refresh = true
        end
      elsif Input.trigger?(Input::BACK)
        pbPlayCloseMenuSE
        break
      end
      drawTypes(newType) if refresh
    end
  end
  
  def drawTypes(type)
    @sprites["rightarrow"].visible = (@index < @types.length-1) ? true : false
    @sprites["leftarrow"].visible = (@index > 0) ? true : false
    @overlay_type.clear
    s = getRandomSpeciesFromType(type)
    2.times do |i|
      @sprites["icon_#{i}"].pbSetParams(s,0,0,false)
    end
    # Selected type
    type = GameData::Type.get(type)
	type_number = GameData::Type.get(type).icon_position
    @overlay_type.blt(Graphics.width/2-32,@h+20,@typebitmap.bitmap,
                  Rect.new(0, type_number * 28, 64, 28))
    # Weaknesses
    weak = type.weaknesses
    weaktype_rect = []
    weak.each_with_index do |s, i|
      t = GameData::Type.get(s).icon_position
      weaktype_rect.push(Rect.new(0, t * 28, 64, 28))
      @overlay_type.blt(@w+40,@h+102+28*i,@typebitmap.bitmap,weaktype_rect[i])
    end
    # Resistances
    resist = type.resistances
    # Because Steel typing has an annoying number of resistances
    xPos = (resist.length >6) ? [Graphics.width/2-64,Graphics.width/2] : Graphics.width/2-32
    resisttype_rect = []
    resist.each_with_index do |s, i|
      t = GameData::Type.get(s).icon_position
      resisttype_rect.push(Rect.new(0, t * 28, 64, 28))
      x = (xPos.is_a?(Array)) ? xPos[i/6] : xPos
      @overlay_type.blt(x,@h+102+28*(i%6),@typebitmap.bitmap,
          resisttype_rect[i])
    end
    # Immunities
    immune = type.immunities
    immunetype_rect = []
    immune.each_with_index do |s, i|
      t = GameData::Type.get(s).icon_position
      immunetype_rect.push(Rect.new(0, t * 28, 64, 28))
      @overlay_type.blt(@w+280,@h+102+28*i,@typebitmap.bitmap,immunetype_rect[i])
    end
    base   = Color.new(80,80,88)
    shadow = Color.new(160,160,168)
    textpos = [
    ["Weak",@w+72,@h+74,2,base,shadow],
    ["Resist",Graphics.width/2,@h+74,2,base,shadow],
    ["Immune",@w+312,@h+74,2,base,shadow],
    ["USE: Jump",4,Graphics.height-26,0,Color.new(248,248,248),Color.new(72,80,88)],
    ["ARROWS: Navigate",Graphics.width/2,Graphics.height-26,2,Color.new(248,248,248),Color.new(72,80,88)],
    ["BACK: Exit",Graphics.width-4,Graphics.height-26,1,Color.new(248,248,248),Color.new(72,80,88)]
    ]
    pbDrawTextPositions(@overlay_text,textpos) if @init
    @init = false
  end
  
  # Method that pulls a random species of the given type
  def getRandomSpeciesFromType(type)
    arr = []
    GameData::Species.each { |s| arr.push(s.id) if s.form==0 && (s.types[0]==type || s.types[1]==type) && s.generation <6 }
    return arr[rand(arr.length)]
  end
  
  def pbUpdate
    pbUpdateSpriteHash(@sprites)

    if @sprites["bg"] && MOVINGBACKGROUND
      @bg_ox -= @bg_scroll_speed  # Move to the right (negative for opposite direction)
      @bg_oy -= @bg_scroll_speed  # Move up (negative for opposite direction)

      # Reset the offsets when they go beyond the bitmap size to create a loop
      @bg_ox %= @sprites["bg"].bitmap.width
      @bg_oy %= @sprites["bg"].bitmap.height

      # Set the rounded integer values to the sprite's offsets
      @sprites["bg"].ox = @bg_ox.round
      @sprites["bg"].oy = @bg_oy.round
    end
  end
  
  # Dipose stuff at the end
  def pbEndScene
    pbFadeOutAndHide(@sprites) { pbUpdate }
    pbDisposeSpriteHash(@sprites)
    @typebitmap.dispose
    @viewport.dispose
  end
  
  # Borrowed from the editor scripts
  # Renamed so as to not break anything anywhere else
  def pbChooseTypeFromList(default = nil, currType)
    commands = []
    GameData::Type.each { |t| commands.push([commands.length + 1, t.name, t.id]) if !t.pseudo_type }
    return pbChooseList(commands, default, currType, 1)
  end
  
end

class TypeMatch_Screen
  
  def initialize(scene)
    @scene = scene
  end

  def pbStartScreen
    @scene.pbStartScene
    @scene.pbTypeMatchUp
    @scene.pbEndScene
  end
  
end

def pbTypeMatchUI
  pbFadeOutIn {
    scene = TypeMatch_Scene.new
    screen = TypeMatch_Screen.new(scene)
    screen.pbStartScreen
  }
end
#===============================================================================
# * Character Selection - by FL (Credits will be apreciated)
#===============================================================================
#
# This script is for Pokémon Essentials. It's a character selection screen
# suggested for player selection or partner selection.
#
#== INSTALLATION ===============================================================
#
# To this script works, put it above main OR convert into a plugin. Put a 32x32
# background at "Graphics/UI/character_selection_tile" (may works with other 
# sizes).
#
#== HOW TO USE =================================================================
#
# Call 'startCharacterSelection(overworld,battle)' passing two arrays with the
# same size as arguments: 
#
# - The first include overworld graphics names (from "Graphics/Characters").
# - The second include battler/front graphics names (from "Graphics/Trainers" 
# or "Graphics/Characters").
#
# The return is the player selected index, starting at 0. 
#
#== EXAMPLES ===================================================================
#
# A basic example that initialize the player:
#
#  overworld = [
#   "trainer_POKEMONTRAINER_Red",
#   "trainer_POKEMONTRAINER_Leaf"]
#  battle = ["POKEMONTRAINER_Red",
#   "POKEMONTRAINER_Leaf"]
#  r=startCharacterSelection(
#   overworld,battle) 
#  pbChangePlayer(r+1)
#
# Example with 4 characters. This example won't change your character, just 
# store the index result at game variable 70.  
#
#  overworld = [
#    "trainer_POKEMONTRAINER_Red", "trainer_POKEMONTRAINER_Leaf",
#    "trainer_POKEMONTRAINER_Brendan","trainer_POKEMONTRAINER_May"
#  ]
#  battle = [
#    "POKEMONTRAINER_Red","POKEMONTRAINER_Leaf",
#    "POKEMONTRAINER_Brendan","POKEMONTRAINER_May"
#  ]
#  $game_variables[70] = startCharacterSelection(overworld,battle) 
#
#===============================================================================

#if defined?(PluginManager) && !PluginManager.installed?("Character Selection")
#  PluginManager.register({                                                 
#    :name    => "Character Selection",                                        
#    :version => "1.2",                                                     
#    :link    => "https://www.pokecommunity.com/showthread.php?t=338481",             
#    :credits => "FL"
#  })
#end

class CharacterSelectionScene
  BACKGROUND_SPEED = 1
  ANIMATION_FRAME_INTERVAL = 4 # Increase for slower animation.
  FRAMES_TO_TURN = 128
  
  def pbStartScene(overworld,battle)
    @overworld = overworld
    @battle = battle
    @sprites={}
    @viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z=99999
    @sprites["bg"]=CharacterSelectionPlane.new(
      BACKGROUND_SPEED,FRAMES_TO_TURN,@viewport)
    @sprites["bg"].setBitmap("Graphics/UI/character_selection_tile")
    @sprites["arrow"]=IconSprite.new(@viewport)
    @sprites["arrow"].setBitmap(arrowBitmapPath)
    @sprites["battlerbox"]=Window_AdvancedTextPokemon.new("")
    @sprites["battlerbox"].viewport=@viewport
    pbBottomLeftLines(@sprites["battlerbox"],5)
    @sprites["battlerbox"].width=256
    @sprites["battlerbox"].x=Graphics.width-@sprites["battlerbox"].width
    @sprites["battlerbox"].z=0
    @sprites["battler"]=IconSprite.new(384,284,@viewport)
    # Numbers for coordinates calculation
    lines = 2
    totalWidth = 512
    totalHeight = 232
    marginX = totalWidth/((@overworld.size/2.0).ceil+1)
    marginY = 72
    for i in 0...@overworld.size
      @sprites["icon#{i}"]=AnimatedChar.new(
          "Graphics/Characters/"+@overworld[i],4,
          [ANIMATION_FRAME_INTERVAL-1,0].max, FRAMES_TO_TURN, @viewport)
      @sprites["icon#{i}"].x = marginX*((i/2).floor+1)
      @sprites["icon#{i}"].y = marginY+(totalHeight - marginY*2)*(i%lines)
      @sprites["icon#{i}"].start
    end
    updateCursor
    @sprites["messagebox"]=Window_AdvancedTextPokemon.new(
        _INTL("Choose your character."))
    @sprites["messagebox"].viewport=@viewport
    pbBottomLeftLines(@sprites["messagebox"],5)
    @sprites["messagebox"].width=256
    pbFadeInAndShow(@sprites) { update }
  end
  
  def updateCursor(index=nil)
    @index=0
    if index
      pbPlayCursorSE
      @index=index
    end
    @sprites["arrow"].x=@sprites["icon#{@index}"].x-32
    @sprites["arrow"].y=@sprites["icon#{@index}"].y-32
    @sprites["battler"].setBitmap(trainerBitmapPath(@battle[@index]))
    @sprites["battler"].ox=@sprites["battler"].bitmap.width/2
    @sprites["battler"].oy=@sprites["battler"].bitmap.height/2
  end

  def arrowBitmapPath
    ret = pbResolveBitmap("Graphics/UI/sel_arrow")
    return ret if ret
    ret = pbResolveBitmap("Graphics/Pictures/selarrow")
    return ret
  end

  def trainerBitmapPath(spriteName)
    ret = pbResolveBitmap("Graphics/Trainers/"+spriteName)
    return ret if ret
    ret = pbResolveBitmap("Graphics/Characters/"+spriteName)
    return ret
  end
  
  def pbMidScene
   loop do
    Graphics.update
    Input.update
    self.update
    if Input.trigger?(Input::C)
      pbPlayDecisionSE
      if pbDisplayConfirm(_INTL("Are you sure?"))
        pbPlayDecisionSE
        return @index
      else 
        pbPlayCancelSE
      end
    end
    lines=2
    if Input.repeat?(Input::LEFT)
      updateCursor((@index-lines)>=0 ? 
          @index-lines : @overworld.size-lines+(@index%lines))
    end
    if Input.repeat?(Input::RIGHT)
      updateCursor((@index+lines)<=(@overworld.size-1) ? 
          @index+lines : @index%lines)
    end
    if Input.repeat?(Input::UP)
      updateCursor(@index!=0 ? @index-1 : @overworld.size-1)
    end
    if Input.repeat?(Input::DOWN)
      updateCursor(@index!=@overworld.size-1 ? @index+1 : 0)  
    end
   end 
  end
  
  def update
    pbUpdateSpriteHash(@sprites)
  end
  
  def pbDisplayConfirm(text)
   ret=-1
   oldtext=@sprites["messagebox"].text
   @sprites["messagebox"].text=text
   using(cmdwindow=Window_CommandPokemon.new([_INTL("Yes"),_INTL("No")])){
     cmdwindow.z=@viewport.z+1
     cmdwindow.visible=false
     pbBottomRight(cmdwindow)
     cmdwindow.y-=@sprites["messagebox"].height
     loop do
       Graphics.update
       Input.update
       cmdwindow.visible=true if !@sprites["messagebox"].busy?
       cmdwindow.update
       self.update
       if Input.trigger?(Input::B) && !@sprites["messagebox"].busy?
         ret=false
       end
       if (Input.trigger?(Input::C) && 
           @sprites["messagebox"].resume && !@sprites["messagebox"].busy?)
         ret=(cmdwindow.index==0)
         break
       end
     end
   }
   @sprites["messagebox"].text=oldtext
   return ret
  end
  
  def pbEndScene
    pbFadeOutAndHide(@sprites) { update }
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end

  class CharacterSelectionPlane < AnimatedPlane
    LIMIT=16
    
    def initialize(speed, turnTime, viewport)
      super(viewport)
      @speed = speed
      @turnTime = turnTime
    end  
    
    def update
      super
      @frame=0 if !@frame
      @frame+=1
      @direction=0 if !@direction
      if @frame==@turnTime
        @frame=0
        @direction+=1
        @direction=0 if @direction==4
      end
      case @direction
      when 0 #down
        self.oy+=@speed
      when 1 #left
        self.ox-=@speed
      when 2 #up
        self.oy-=@speed
      when 3 #right
        self.ox+=@speed
      end
      self.ox=0 if self.ox==-LIMIT || self.ox==LIMIT 
      self.oy=0 if self.oy==-LIMIT || self.oy==LIMIT 
    end
  end

  class AnimatedChar < AnimatedSprite
    def initialize(*args)
      @realframeschar=0
      @direction=0
      @turnTime=args[3]
      super([args[0],args[1],args[2],args[4]])
      @frameheight=@animbitmap.height/4
      if @animbitmap.width%framecount!=0
        raise _INTL("Bitmap's width ({1}) is not a multiple of frame count ({2}) [Bitmap={3}]",@animbitmap.width,@framewidth,@animname)
      end
      @playing=false
      self.src_rect.height=@frameheight
      self.ox=@framewidth/2
      self.oy=@frameheight
    end
  
    def frame=(value)
      @frame=value
      @realframes=0
      self.src_rect.x=@frame%@framesperrow*@framewidth
    end
  
    def update
      super
      if @playing
        @realframeschar+=1
        if @realframeschar==@turnTime
          @realframeschar=0 
          @direction+=1
          @direction= 0 if @direction==4
          #Spin
          if @direction==2
            dir=3
          elsif @direction==3
            dir=2
          else
            dir=@direction
          end  
          self.src_rect.y=@frameheight*dir
        end
      end
    end
  end  
end

class CharacterSelectionScreen
  def initialize(scene)
    @scene=scene
  end
  
  def pbStartScreen(overworld,battle)
    @scene.pbStartScene(overworld,battle)
    ret = @scene.pbMidScene
    @scene.pbEndScene
    return ret
  end
end

def startCharacterSelection(overworld,battle)
  ret = nil
  pbFadeOutIn(99999) {
    scene=CharacterSelectionScene.new
    screen=CharacterSelectionScreen.new(scene)
    ret=screen.pbStartScreen(overworld,battle)
  }
  return ret
end
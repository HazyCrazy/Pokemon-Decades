#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#   Developer-Configurable Constant Defaults
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

FAST_PICK_ITEM_ACTIVE = 1  # 1 = Items picked up get the BOTW anim.       0 = Old anim.
FAST_PICK_BERRY_ACTIVE = 1 # 1 = Berries harvested up get the BOTW anim.  0 = Old anim.
FAST_ITEM_GET_SE = "Voltorb Flip point" # Sound that will play after obtaining an item.

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#   Menu Handlers
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

MenuHandlers.add(:options_menu, :botw_item_pickup, {
  "name"        => _INTL("Item Pickup"),
  "order"       => 88,
  "type"        => EnumOption,
  "parameters"  => [_INTL("Default"), _INTL("Instant")],
  "description" => _INTL("Choose whether a message should appear when picking up items."),
  "get_proc"    => proc { next FAST_PICK_ITEM_ACTIVE },
  "set_proc"    => proc { |value, _scene| FAST_PICK_ITEM_ACTIVE = value }
})

MenuHandlers.add(:options_menu, :botw_berry_harvest, {
  "name"        => _INTL("Berry Harvest"),
  "order"       => 89,
  "type"        => EnumOption,
  "parameters"  => [_INTL("Default"), _INTL("Instant")],
  "description" => _INTL("Choose whether a message should appear when harvesting berries."),
  "get_proc"    => proc { next FAST_PICK_BERRY_ACTIVE },
  "set_proc"    => proc { |value, _scene| FAST_PICK_BERRY_ACTIVE = value }
})

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#   UI        (Ported from v18.1)
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# UI Object with timer, animation and other relevant data
class UISprite < Sprite # Originally UISprite < SpriteWrapper, I assume SpriteWrapper is now Sprite???
  attr_accessor :scroll
  attr_accessor :timer

  def initialize(x, y, bitmap, viewport)
    super(viewport)
    self.bitmap = bitmap
    self.x = x
    self.y = y
    @scroll = false
    @timer = 0
  end

  def update
    return if self.disposed?
    @timer += 1
    case @timer
    when (0..10)
      self.x += self.bitmap.width / 10
    when (100..110)
      self.x -= self.bitmap.width / 10
    when 111
      self.dispose
    end
  end
end


class Spriteset_Map
  # Handles all UI objects in order to control their positions on screen, timing 
  # and disposal. Acts like a Queue.
  class UIHandler
    def initialize
      @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height) # Uses its own viewport to make it compatible with both v16 and v17.
      @viewport.z = 9999
      @sprites = []
    end

    def addSprite(x, y, bitmap)
      @sprites.each{|sprite|
        sprite.scroll = true
      }
      index = @sprites.length
      @sprites[index] = UISprite.new(x, y, bitmap, @viewport)
    end

    def update
      removed = []
      @sprites.each_index{|key|
        sprite = @sprites[key]
        if sprite.scroll
          sprite2 = @sprites[key + 1]
          if sprite.x >= sprite2.x && sprite.x <= sprite2.bitmap.width + sprite2.x
            if sprite.y >= sprite2.y && sprite.y <= sprite2.bitmap.height + sprite2.y + 5
              sprite.y += 5
            end
          else
            sprite.scroll = false
          end
        end
        sprite.update
        if sprite.disposed?
          removed.push(sprite)
        end
      }
      
      removed.each{|sprite|
        @sprites.delete(sprite)
      }
    end
        
    def dispose
      @sprites.each{|sprite|
        if !sprite.disposed?
          sprite.dispose
        end
      }
      @viewport.dispose
    end
  end
  
  alias :disposeOld :dispose
  alias :updateOld :update

  def dispose
    @ui.dispose if @ui
    disposeOld
  end

  def update
    @ui = UIHandler.new if !@ui
    @ui.update
    updateOld
  end

  def ui
    return @ui
  end
end


class Scene_Map
  def addSprite(x, y, bitmap)
    self.spriteset.ui.addSprite(x, y, bitmap)
  end
end

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#   Animation        (Ported from v18.1)
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

def itemAnim(item, qty)
  bitmap = Bitmap.new("Graphics/Pictures/Object")
  pbSetSystemFont(bitmap)
  base = Color.new(248, 248, 248)
  shadow = Color.new(72, 80, 88)
  itemData = GameData::Item.get(item)
  move = GameData::Move.get(itemData.move) if itemData.is_machine?
  if itemData.is_machine?
    itemname = "#{itemData.portion_name} #{move.name}"
    if qty > 1
      textpos = [[_INTL("{1} x{2}", itemname,qty), 5, 15, false, base, shadow]]
    else
      textpos = [[_INTL("{1}", itemname), 5, 15, false, base, shadow]]
    end
  else
    if qty > 1
      textpos = [[_INTL("{1} x{2}", itemData.portion_name_plural,qty), 5, 15, false, base, shadow]]
    else
      textpos = [[_INTL("{1}", itemData.portion_name), 5, 15, false, base, shadow]]
    end
  end
  pbDrawTextPositions(bitmap,textpos)
  if itemData.is_machine?
    if pbResolveBitmap("Graphics/Items/machine_#{move::type.to_s}")
      bitmap.blt(274,5,Bitmap.new("Graphics/Items/machine_#{move::type.to_s}"),Rect.new(0,0,48,48))
    end
  else
    if pbResolveBitmap("Graphics/Items/#{itemData::id.to_s}")
      bitmap.blt(274,5,Bitmap.new("Graphics/Items/#{itemData::id.to_s}"),Rect.new(0,0,48,48))
    end
  end
  pbSEPlay(FAST_ITEM_GET_SE)
  $scene.addSprite(-bitmap.width, 200, bitmap)
end

#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#   Method Overrides        (Ported from v18.1)
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

alias :oldItem :pbItemBall
def pbItemBall(item,quantity = 1)
  if FAST_PICK_ITEM_ACTIVE == 0 # Old Animation
    oldItem(item, quantity)
  else # New Animation
    item = GameData::Item.get(item)
    return false if !item || quantity < 1
    itemname = (quantity > 1) ? item.portion_name_plural : item.portion_name
    pocket = item.pocket
    move = item.move
    if item.is_machine?
      itemname += " #{GameData::Move.get(move).name}"
    end
    if $bag.add(item, quantity)   # If item can be picked up 
      itemAnim(item, quantity)
      return true
    else   # Can't add the item
      if item.is_machine?   # TM or HM
        if quantity > 1
          pbMessage(_INTL("You found {1} \\c[1]{2} {3}\\c[0]!", quantity, itemname, GameData::Move.get(move).name))
        else
          pbMessage(_INTL("You found \\c[1]{1} {2}\\c[0]!", itemname, GameData::Move.get(move).name))
        end
      elsif quantity > 1
        pbMessage(_INTL("You found {1} \\c[1]{2}\\c[0]!", quantity, itemname))
      elsif itemname.starts_with_vowel?
        pbMessage(_INTL("You found an \\c[1]{1}\\c[0]!", itemname))
      else
        pbMessage(_INTL("You found a \\c[1]{1}\\c[0]!", itemname))
      end
      pbMessage(_INTL("But your Bag is full..."))
      return false
    end
  end
end

alias :oldBerry :pbPickBerry
def pbPickBerry(berry, qty=1)
  if FAST_PICK_BERRY_ACTIVE == 0 # Old Animation
    oldBerry(berry, qty)
  else # New Animation
    interp=pbMapInterpreter
    thisEvent=interp.get_self
    berryData=interp.getVariable
    berry = GameData::Item.get(berry)
    itemname=(qty > 1) ? GameData::Item.get(berry).portion_name_plural : GameData::Item.get(berry).portion_name
    if !$bag.can_add?(berry, qty)
      pbMessage(_INTL("Too bad...\nThe Bag is full..."))
      return false
    end
    $stats.berry_plants_picked += 1
    if qty >= GameData::BerryPlant.get(berry.id).maximum_yield
      $stats.max_yield_berry_plants += 1
    end
    $bag.add(berry, qty)
    itemAnim(berry, qty)
    pbSetSelfSwitch(thisEvent.id, "A", true)
    return true
  end
end
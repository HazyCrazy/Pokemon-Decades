#===============================================================================
# Adds a newly called battler to the battle scene.
#===============================================================================
class Battle::Scene
  #-----------------------------------------------------------------------------
  # Prepares the battle scene for the introduction of a new battler.
  #-----------------------------------------------------------------------------
  def pbPrepNewBattler(idxBattler)
    pbRefresh
    battler = @battle.battlers[idxBattler]
    addNewBattler = !@sprites["dataBox_#{idxBattler}"]
    if addNewBattler
      @sprites["targetWindow"].dispose
      @sprites["targetWindow"] = TargetMenu.new(@viewport, 200, @battle.sideSizes)
      @sprites["targetWindow"].visible = false
      pbCreatePokemonSprite(idxBattler)
      if defined?(pbHideInfoUI)
        @sprites["info_icon#{idxBattler}"] = PokemonIconSprite.new(battler.pokemon, @viewport)
        @sprites["info_icon#{idxBattler}"].setOffset(PictureOrigin::CENTER)
        @sprites["info_icon#{idxBattler}"].visible = false
        @sprites["info_icon#{idxBattler}"].z = 300
        pbAddSpriteOutline(["info_icon#{idxBattler}", @viewport, battler.pokemon, PictureOrigin::CENTER])
      end
    else
      @sprites["pokemon_#{idxBattler}"].dispose
      @sprites["shadow_#{idxBattler}"].dispose
      pbCreatePokemonSprite(idxBattler)
    end
    @sprites["pokemon_#{idxBattler}"].visible = false
    @sprites["shadow_#{idxBattler}"].visible = false
    sideSize = @battle.pbSideSize(idxBattler)
    @battle.allSameSideBattlers(idxBattler).each do |b|
      @sprites["pokemon_#{b.index}"].sideSize = sideSize
      @sprites["shadow_#{b.index}"].sideSize = sideSize
      if addNewBattler
        @sprites["dataBox_#{b.index}"]&.dispose
        @sprites["dataBox_#{b.index}"] = PokemonDataBox.new(b, sideSize, @viewport)
      else
        @sprites["dataBox_#{b.index}"].battler = b
        @sprites["dataBox_#{b.index}"].visible = @sprites["pokemon_#{b.index}"].visible
        @sprites["dataBox_#{b.index}"].refresh
      end
      @sprites["dataBox_#{b.index}"].update
    end
    return addNewBattler
  end

  #-----------------------------------------------------------------------------
  # Adds a new wild Pokemon via SOS call.
  #-----------------------------------------------------------------------------
  def pbSOSJoin(idxBattler)
    addNewBattler = pbPrepNewBattler(idxBattler)
    battler = @battle.battlers[idxBattler]
    pbChangePokemon(idxBattler, battler.displayPokemon)
    sosAnim = Animation::SOSJoin.new(@sprites, @viewport, @battle, battler.index, addNewBattler)
    @animations.push(sosAnim)
    while inPartyAnimation?
      pbUpdate
    end
    if @battle.showAnims && battler.shiny?
      if Settings::SUPER_SHINY && battler.super_shiny?
        pbCommonAnimation("SuperShiny", battler)
      else
        pbCommonAnimation("Shiny", battler)
      end
    end
  end
  
  #-----------------------------------------------------------------------------
  # Adds a new trainer.
  #-----------------------------------------------------------------------------
  def pbTrainerJoin(sendOuts, idxTrainer)
    addNewBattler = false
    sendOuts.each_with_index do |sendOut, i|
      addNew = pbPrepNewBattler(sendOut[0])
      addNewBattler = addNew if i == 0
    end
    trainer = @battle.opponent[idxTrainer]
    sprite = @sprites["trainer_#{idxTrainer + 1}"]
    if sprite
      if PluginManager.installed?("[DBK] Animated Trainer Intros")
        sprite.numTrainers = @battle.opponent.length
        sprite.setTrainerBitmap(trainer.trainer_type)
      else
        trainerFile = GameData::TrainerType.front_sprite_filename(trainer.trainer_type)
        spriteX, spriteY = Battle::Scene.pbTrainerPosition(1, idxTrainer, @battle.opponent.length)
        sprite.setBitmap(trainerFile)
        sprite.x = spriteX
        sprite.y = spriteY
        sprite.ox = sprite.src_rect.width / 2
        sprite.oy = sprite.bitmap.height
      end
    else
      pbCreateTrainerFrontSprite(idxTrainer, trainer.trainer_type, @battle.opponent.length)
    end
    if @battle.launcherBattle?
      @sprites["launcherBar_1_#{idxTrainer}"] = WonderLauncherPointsBar.new(1, idxTrainer, trainer, @viewport)
    end
    joinAnim = Animation::TrainerJoin.new(@sprites, @viewport, @battle, sendOuts[0][0], idxTrainer + 1, addNewBattler)
    @animations.push(joinAnim)
    while inPartyAnimation?
      pbUpdate
    end
    if PluginManager.installed?("[DBK] Animated Trainer Intros")
      loop do 
        pbUpdate
        break if @sprites["trainer_#{idxTrainer + 1}"].finished?
        @sprites["trainer_#{idxTrainer + 1}"].play
      end
    end
    pbDisplayPausedMessage(_INTL("{1} joined the battle!", trainer.full_name))
    battler_names = ""
    sendOuts.each_with_index do |sendOut, i|
      battler = @battle.battlers[sendOut[0]]
      battler_names += ((i == sendOuts.length - 1) ? " and " : ", ") if i > 0
      battler_names += (defined?(battler.name_title)) ? battler.name_title : battler.name
    end
    pbDisplayMessage(_INTL("{1} sent out {2}!", trainer.full_name, battler_names))
    @battle.pbSendOut(sendOuts)
  end
  
  #-----------------------------------------------------------------------------
  # Used to quickly add a foe via the battle debug menu.
  #-----------------------------------------------------------------------------
  def pbQuickJoin(idxBattler, idxTrainer = nil)
    addNewBattler = pbPrepNewBattler(idxBattler)
    battler = @battle.battlers[idxBattler]
    @battle.battlers.each do |b|
      next if !b || b.opposes?(idxBattler)
      batSprite = @sprites["pokemon_#{b.index}"]
      shaSprite = @sprites["shadow_#{b.index}"]
      boxSprite = @sprites["dataBox_#{b.index}"]
      if b.index == idxBattler
        batSprite.visible = true
        shaSprite.visible = true
        boxSprite.visible = true
      else
        batSprite.dispose
        shaSprite.dispose
        pbCreatePokemonSprite(b.index)
        @sprites["pokemon_#{b.index}"].visible = true
        @sprites["shadow_#{b.index}"].visible = true
        boxSprite.visible = true if !b.fainted?
      end
      pbChangePokemon(b.index, b.displayPokemon)
    end
    if idxTrainer
      trainer = @battle.opponent[idxTrainer]
      sprite = @sprites["trainer_#{idxTrainer + 1}"]
      if sprite
        trainerFile = GameData::TrainerType.front_sprite_filename(trainer.trainer_type)
        oldX = sprite.x
        if PluginManager.installed?("[DBK] Animated Trainer Intros")
          sprite.setTrainerBitmap(trainer.trainer_type)
        else
          sprite.setBitmap(trainerFile)
        end
        sprite.x = oldX
      else
        pbCreateTrainerFrontSprite(idxTrainer, trainer.trainer_type, @battle.opponent.length)
        sprite.x = @sprites["trainer_1"].x
      end
      if @battle.launcherBattle?
        @sprites["launcherBar_1_#{idxTrainer}"] = WonderLauncherPointsBar.new(1, idxTrainer, trainer, @viewport)
      end
    end
  end
end

#===============================================================================
# Allows the size of side to be edited mid-battle.
#===============================================================================
class Battle::Scene::BattlerSprite < RPG::Sprite
  attr_accessor :sideSize
end

class Battle::Scene::BattlerShadowSprite < RPG::Sprite
  attr_accessor :sideSize
end

#===============================================================================
# Mixin for determining new positions for battler sprites.
#===============================================================================
module Battle::Scene::Animation::SOSPositionMixin
  def pbGetBattlerPosition(b, sideSize)
    p = Battle::Scene.pbBattlerPosition(b.index, sideSize)
    newX, newY = p[0], p[1]
    if PluginManager.installed?("[DBK] Animated Pokémon System")
      if b.battlerSprite.substitute
        newY += Settings::SUBSTITUTE_DOLL_METRICS[1]
      else
        metrics = GameData::SpeciesMetrics.get_species_form(b.species, b.form, b.gender == 1)
      end
    else
      metrics = GameData::SpeciesMetrics.get_species_form(b.species, b.form)
    end
    if metrics
      newX += metrics.front_sprite[0] * 2
      newY += metrics.front_sprite[1] * 2
      newY -= metrics.front_sprite_altitude * 2
    end
    newZ = 50 - (5 * (b.index + 1) / 2)
    return newX, newY, newZ
  end
  
  def pbGetShadowPosition(b, sideSize)
    p = Battle::Scene.pbBattlerPosition(b.index, sideSize)
    newX, newY, newZ = p[0], p[1], 3
    if PluginManager.installed?("[DBK] Animated Pokémon System")
      if !b.battlerSprite.substitute
        metrics = GameData::SpeciesMetrics.get_species_form(b.species, b.form, b.gender == 1)
        newX += (metrics.front_sprite[0] * 2 + metrics.shadow_sprite[0] * 2)
        newY += (metrics.front_sprite[1] * 2 + metrics.shadow_sprite[2] * 2)
        newY -= (b.shadowSprite.height / 4).round
      end
    else
      metrics = GameData::SpeciesMetrics.get_species_form(b.species, b.form)
      newX += metrics.shadow_x * 2
    end
    return newX, newY, newZ
  end
end

#===============================================================================
# Animation used for new wild Pokemon joining the battle.
#===============================================================================
class Battle::Scene::Animation::SOSJoin < Battle::Scene::Animation
  include Battle::Scene::Animation::SOSPositionMixin
  
  def initialize(sprites, viewport, battle, idxSOS, addNewBattler)
    @battle = battle
    @idxSOS = idxSOS
    @addNewBattler = addNewBattler
    super(sprites, viewport)
  end
 
  def createProcesses
    delay = 0
    @battle.battlers.each do |b|
      next if !b || b.opposes?(@idxSOS)
      batSprite = @sprites["pokemon_#{b.index}"]
      shaSprite = @sprites["shadow_#{b.index}"]
      boxSprite = @sprites["dataBox_#{b.index}"]
      if b.index == @idxSOS
        battler = addSprite(batSprite, PictureOrigin::BOTTOM)
        battler.setTone(delay, Tone.new(-196, -196, -196, -196))
        battler.setOpacity(delay, 0)
        battler.setVisible(delay, true)
        battler.moveOpacity(delay, 4, 255)
        battler.moveTone(delay + 4, 10, Tone.new(0, 0, 0, 0), [batSprite,:pbPlayIntroAnimation])
        shaSprite.visible = false
        shadow = addSprite(shaSprite, PictureOrigin::CENTER)
        shadow.setOpacity(delay, 0)
        shadow.setVisible(delay, true)
        shadow.moveOpacity(delay, 4, 255)
        dir = (b.index.even?) ? 1 : -1
        box = addSprite(boxSprite)
        box.setDelta(delay, dir * Graphics.width / 2, 0)
        box.setVisible(delay, true)
        box.moveDelta(delay, 8, -dir * Graphics.width / 2, 0)
      else
        battler = addSprite(batSprite, PictureOrigin::BOTTOM)
        newX, newY, newZ = pbGetBattlerPosition(b, batSprite.sideSize)
        battler.setZ(delay, newZ)
        battler.moveXY(delay, 4, newX, newY)
        shadow = addSprite(shaSprite, PictureOrigin::CENTER)
        newX, newY, newZ = pbGetShadowPosition(b, shaSprite.sideSize)
        shadow.setZ(delay, newZ)
        shadow.moveXY(delay, 4, newX, newY)
        if @addNewBattler
          dir = (b.index.even?) ? 1 : -1
          box = addSprite(boxSprite)
          box.setDelta(delay, dir * Graphics.width / 2, 0)
          box.setVisible(delay, true) if !b.fainted?
          box.moveDelta(delay, 8, -dir * Graphics.width / 2, 0)
        else
          box = addSprite(boxSprite)
          box.setVisible(delay, true) if !b.fainted?
        end
      end
      delay += 1
    end
  end
end

#===============================================================================
# Animation used for a new trainer joining the battle.
#===============================================================================
class Battle::Scene::Animation::TrainerJoin < Battle::Scene::Animation
  include Battle::Scene::Animation::SOSPositionMixin
  
  def initialize(sprites, viewport, battle, idxSOS, idxTrainer, addNewBattler)
    @battle = battle
    @idxSOS = idxSOS
    @idxTrainer = idxTrainer
    @addNewBattler = addNewBattler
    super(sprites, viewport)
  end
 
  def createProcesses
    delay = 0
    @battle.battlers.each do |b|
      next if !b || b.opposes?(@idxSOS) || b.index == @idxSOS
      batSprite = @sprites["pokemon_#{b.index}"]
      shaSprite = @sprites["shadow_#{b.index}"]
      boxSprite = @sprites["dataBox_#{b.index}"]
      battler = addSprite(batSprite, PictureOrigin::BOTTOM)
      newX, newY, newZ = pbGetBattlerPosition(b, batSprite.sideSize)
      battler.setZ(delay, newZ)
      battler.moveXY(delay, 4, newX, newY)
      shadow = addSprite(shaSprite, PictureOrigin::CENTER)
      newX, newY, newZ = pbGetShadowPosition(b, shaSprite.sideSize)
      shadow.setZ(delay, newZ)
      shadow.moveXY(delay, 4, newX, newY)
      if @addNewBattler
        dir = (b.index.even?) ? 1 : -1
        box = addSprite(boxSprite)
        box.setDelta(delay, dir * Graphics.width / 2, 0)
        box.setVisible(delay, true) if !b.fainted? && batSprite.visible
        box.moveDelta(delay, 8, -dir * Graphics.width / 2, 0)
      else
        box = addSprite(boxSprite)
        box.setVisible(delay, true) if !b.fainted? && batSprite.visible
      end
      delay += 1
    end
    trSprite = @sprites["trainer_#{@idxTrainer}"]
    trSprite.visible = false
    trainer = addSprite(trSprite, PictureOrigin::BOTTOM)
    trainer.setOpacity(delay, 0)
    trainer.setTone(delay, Tone.new(-196, -196, -196, -196))
    trainer.setVisible(delay, true)
    trainer.moveOpacity(delay, 4, 255)
    trainer.moveTone(delay + 4, 10, Tone.new(0, 0, 0, 0))
  end
end
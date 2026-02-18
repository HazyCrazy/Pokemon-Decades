#===============================================================================
# Title display.
#===============================================================================
# Displays a Pokemon's full title when being sent out into battle.
#-------------------------------------------------------------------------------
class Battle
  def pbStartBattleSendOut_WithTitles(sendOuts)
    foes = @opponent || pbParty(1)
    msg = (wildBattle?) ? "Oh! A wild " : "You are challenged by "
    foes.each_with_index do |foe, i|
      if i > 0
        msg += (i == foes.length - 1) ? " and " : ", "
      end
      msg += (wildBattle?) ? foe.name : foe.full_name
    end
    msg += (wildBattle?) ? " appeared!" : "!"
    pbDisplayPaused(_INTL("{1}", msg))
    [1, 0].each do |side|
      next if side == 1 && wildBattle?
      msg = ""
      toSendOut = []
      trainers = (side == 0) ? @player.reverse : @opponent
      trainers.each_with_index do |t, i|
        msg += "\r\n" if msg.length > 0
        if side == 0 && i == trainers.length - 1
          msg += "Go! "
          sent = sendOuts[side][0]
        else
          msg += "#{t.full_name} sent out "
          sent = (side == 0) ? sendOuts[0][1] : sendOuts[1][i]
        end
        sent.each_with_index do |idxBattler, j|
          if j > 0
            msg += (j == sent.length - 1) ? " and " : ", "
          end
          msg += @battlers[idxBattler].name_title
        end
        msg += "!"
        toSendOut.concat(sent)
      end
      pbDisplayBrief(_INTL("{1}", msg)) if msg.length > 0
      animSendOuts = []
      toSendOut.each do |idxBattler|
        animSendOuts.push([idxBattler, @battlers[idxBattler].pokemon])
      end
      pbSendOut(animSendOuts, true)
    end
  end

  def pbMessagesOnReplace_WithTitles(idxBattler, idxParty)
    party = pbParty(idxBattler)
    newPkmnName = party[idxParty].name_title
    if party[idxParty].ability == :ILLUSION && !pbCheckGlobalAbility(:NEUTRALIZINGGAS)
      new_index = pbLastInTeam(idxBattler)
      newPkmnName = party[new_index].name_title if new_index >= 0 && new_index != idxParty
    end
    if pbOwnedByPlayer?(idxBattler)
      opposing = @battlers[idxBattler].pbDirectOpposing
      if opposing.fainted? || opposing.hp == opposing.totalhp
        pbDisplayBrief(_INTL("You're in charge, {1}!", newPkmnName))
      elsif opposing.hp >= opposing.totalhp / 2
        pbDisplayBrief(_INTL("Go for it, {1}!", newPkmnName))
      elsif opposing.hp >= opposing.totalhp / 4
        pbDisplayBrief(_INTL("Just a little more! Hang in there, {1}!", newPkmnName))
      else
        pbDisplayBrief(_INTL("Your opponent's weak! Get 'em, {1}!", newPkmnName))
      end
    else
      owner = pbGetOwnerFromBattlerIndex(idxBattler)
      pbDisplayBrief(_INTL("{1} sent out {2}!", owner.full_name, newPkmnName))
    end
  end
end

#-------------------------------------------------------------------------------
# Returns a battler's colorized name & title. Takes Illusion into account.
#-------------------------------------------------------------------------------
class Battle::Battler
  def name_title(withColor = true)
    return displayPokemon.name_title(withColor)
  end
end


#===============================================================================
# Battle send out.
#===============================================================================
# Adds memento animation as part of the general send out animation in battle.
#-------------------------------------------------------------------------------
class Battle::Scene
  def pbSendOutBattlers(sendOuts, startBattle = false)
    return if sendOuts.length == 0
    while inPartyAnimation?
      pbUpdate
    end
    @briefMessage = false
    if @battle.opposes?(sendOuts[0][0])
      fadeAnim = Animation::TrainerFade.new(@sprites, @viewport, startBattle)
    else
      fadeAnim = Animation::PlayerFade.new(@sprites, @viewport, startBattle)
    end
    sendOutAnims = []
    sendOuts.each_with_index do |b, i|
      pkmn = @battle.battlers[b[0]].effects[PBEffects::Illusion] || b[1]
      pbChangePokemon(b[0], pkmn)
      pbRefresh
      if @battle.opposes?(b[0])
        sendOutAnim = Animation::PokeballTrainerSendOut.new(
          @sprites, @viewport, @battle.pbGetOwnerIndexFromBattlerIndex(b[0]) + 1,
          @battle.battlers[b[0]], startBattle, i
        )
      else
        sendOutAnim = Animation::PokeballPlayerSendOut.new(
          @sprites, @viewport, @battle.pbGetOwnerIndexFromBattlerIndex(b[0]) + 1,
          @battle.battlers[b[0]], startBattle, i
        )
      end
      dataBoxAnim = Animation::DataBoxAppear.new(@sprites, @viewport, b[0])
      mementoAnim = Animation::BattlerMemento.new(@sprites, @viewport, @battle, b[0])
      sendOutAnims.push([sendOutAnim, mementoAnim, dataBoxAnim, false])
    end
    loop do
      fadeAnim.update
      sendOutAnims.each do |a|
        next if a[3]
        a[0].update
        a[1].update if a[0].animDone?
        a[2].update if a[1].animDone?
        a[3] = true if a[2].animDone?
      end
      pbUpdate
      if !inPartyAnimation? && sendOutAnims.none? { |a| !a[3] }
        break
      end
    end
    fadeAnim.dispose
    sendOutAnims.each do |a|
      a[0].dispose
      a[1].dispose
      a[2].dispose
    end
    sendOuts.each do |b|
      next if !@battle.showAnims || !@battle.battlers[b[0]].shiny?
      if Settings::SUPER_SHINY && @battle.battlers[b[0]].super_shiny?
        pbCommonAnimation("SuperShiny", @battle.battlers[b[0]])
      else
        pbCommonAnimation("Shiny", @battle.battlers[b[0]])
      end
    end
  end
end


#===============================================================================
# Memento animation.
#===============================================================================
# Displays a battler's memento when being sent out in battle.
#-------------------------------------------------------------------------------
class Battle::Scene::Animation::BattlerMemento < Battle::Scene::Animation
  def initialize(sprites, viewport, battle, idxBattler)
    @battle = battle
    @idxBattler = idxBattler
    super(sprites, viewport)
  end

  def createProcesses
    batSprite = @sprites["pokemon_#{@idxBattler}"]
    return if !batSprite
    memento = GameData::Ribbon.try_get(batSprite.pkmn.memento)
    return if !memento
    delay = 0
    coords = Battle::Scene.pbBattlerPosition(@idxBattler, batSprite.sideSize)
    pictureSPRITE = addMementoSprite(memento.icon_position)
    pictureSPRITE.setXY(0, coords[0], coords[1])
    pictureSPRITE.setZ(0, batSprite.z + 1)
    pictureSPRITE.setOpacity(0, 0)
    #pictureSPRITE.moveXY(0, 16, coords[0], coords[1] - 160)
    #pictureSPRITE.moveOpacity(0, 4, 255)
    #pictureSPRITE.moveOpacity(8, 8, 0)
	pictureSPRITE.moveXY(0, 0.1, coords[0], coords[1] - 160)
    pictureSPRITE.moveOpacity(0, 0.1, 0)
    pictureSPRITE.moveOpacity(0, 0.1, 0)
  end
  
  def addMementoSprite(icon)
    file_path = Settings::MEMENTOS_GRAPHICS_PATH + "mementos"
    picMemento = addNewSprite(Graphics.width, Graphics.height, file_path, PictureOrigin::CENTER)
    mementoSprite = @pictureSprites.last
    mementoSprite.src_rect.x = 78 * (icon % 8)
    mementoSprite.src_rect.y = 78 * (icon / 8).floor
    mementoSprite.src_rect.width = 78
    mementoSprite.src_rect.height = 78
    picMemento.setSrc(0, mementoSprite.src_rect.x, mementoSprite.src_rect.y)
    picMemento.setSrcSize(0, mementoSprite.src_rect.width, mementoSprite.src_rect.height)
    return picMemento
  end
end
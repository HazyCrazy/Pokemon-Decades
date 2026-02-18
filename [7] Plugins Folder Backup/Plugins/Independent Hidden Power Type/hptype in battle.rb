#===============================================================================
# Fight menu (choose a move)
#===============================================================================
class Battle::Scene::FightMenu < Battle::Scene::MenuBase

    def refreshMoveData(move)
        # Write PP and type of the selected move
        if !USE_GRAPHICS
        moveType = GameData::Type.get(move.display_type(@battler)).name
        moveType = @battler.hptype if move.name=="Hidden Power"  # DemICE Inddependent Hidden Pwer Type edit
        if move.total_pp <= 0
            @msgBox.text = _INTL("PP: ---<br>TYPE/{1}", moveType)
        else
            @msgBox.text = _ISPRINTF("PP: {1: 2d}/{2: 2d}<br>TYPE/{3:s}",
                                    move.pp, move.total_pp, moveType)
        end
        return
        end
        @infoOverlay.bitmap.clear
        if !move
        @visibility["typeIcon"] = false
        return
        end
        @visibility["typeIcon"] = true
        # Type icon
        type_number = GameData::Type.get(move.display_type(@battler)).icon_position
         # DemICE Inddependent Hidden Pwer Type edit
        type_number = GameData::Type.get(@battler.hptype).icon_position if move.name=="Hidden Power" 
        @typeIcon.src_rect.y = type_number * TYPE_ICON_HEIGHT
        # PP text
        if move.total_pp > 0
        ppFraction = [(4.0 * move.pp / move.total_pp).ceil, 3].min
        textPos = []
        textPos.push([_INTL("PP: {1}/{2}", move.pp, move.total_pp),
                        448, 56, 2, PP_COLORS[ppFraction * 2], PP_COLORS[(ppFraction * 2) + 1]])
        pbDrawTextPositions(@infoOverlay.bitmap, textPos)
        end
    end

end    
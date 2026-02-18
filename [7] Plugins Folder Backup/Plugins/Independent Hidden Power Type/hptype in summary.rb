#Optional script that makes the hidden power type visible in the summary screen.

class PokemonSummary_Scene
  
    alias hptype_drawPageTwo drawPageTwo
    def drawPageTwo
      hptype_drawPageTwo
      overlay = @sprites["overlay"].bitmap
      if PluginManager.installed?("BW Summary Screen")
        base   = Color.new(255, 255, 255)
        shadow = Color.new(123, 123, 123)
		textpos = [ [_INTL("Hidden Power:"), 32, 296, 0, base, shadow] ]
		  pbDrawTextPositions(overlay, textpos)
		  hptype_number = GameData::Type.get(@pokemon.hptype).icon_position
		  hptype_rect = Rect.new(0, hptype_number * 28, 64, 28)
		  overlay.blt(174, 294, @typebitmap.bitmap, hptype_rect)    
      else
        base   = Color.new(64, 64, 64)
        shadow = Color.new(176, 176, 176)
		#textpos = [ [_INTL("H. Power:"), 410, 86, 0, base, shadow] ]
		textpos = [ [_INTL("Hidden Power Type:"), 232, 276, 0, base, shadow] ]
		  pbDrawTextPositions(overlay, textpos)
		  hptype_number = GameData::Type.get(@pokemon.hptype).icon_position
		  hptype_rect = Rect.new(0, hptype_number * 28, 64, 28)
		  #overlay.blt(422, 111, @typebitmap.bitmap, hptype_rect)
		   overlay.blt(430, 272, @typebitmap.bitmap, hptype_rect)    		  
      end  
    end    

end
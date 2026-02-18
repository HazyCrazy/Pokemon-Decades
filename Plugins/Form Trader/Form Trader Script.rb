# Added to track whether Pokemon has already recieved IV boost due to Trading Charm.
class Pokemon
  attr_accessor :tradingCharmStatsIncreased
  
  def tradingCharmStatsIncreased?
	  @tradingCharmStatsIncreased ||= false
  end
end


# Main Script 
# Basic script for trading the same Pokemon back, in a different form.
# ================ Form Trader From Party =====================#
def pbFormTrader(nickName = nil, trainerName = nil, trainerGender = 0)
chosen = -1
allowIneligible = false
  pbFadeOutIn {
    scene = PokemonParty_Scene.new
    screen = PokemonPartyScreen.new(scene, $player.party)
    chosen = screen.pbChooseForm(allowIneligible)
    }
    if chosen[2] >= 0
      retval = nickName, trainerName, trainerGender
      pbStartFormTrade(chosen, retval)
    else
      #pbMessage(_INTL("Come back if you want to trade."))
    end  
end


def pbChooseForm(allowIneligible = false)
  @party = $player.party
  annot = []
  choice = []
  pkmnid = -1
  myPokemon = nil
  yourPokemon = nil
  pkmn = nil
  eligibility = []
  formcmds_hash = {}
    
      @party.each_with_index  do |pkmn, index|
       
        elig = true
          formcmds = []
          form_name = [] 
          form_ids = []
          GameData::Species.each do |sp|
            next if sp.species != pkmn.species
            next if sp.mega_stone
            form_name = sp.form_name
            form_name = _INTL("Normal Form") if !form_name || form_name.empty?
            form_name = sprintf("%d: %s", sp.form, form_name)
            formcmds.push(form_name)
            form_ids.push(sp.form)
            cmd2 = sp.form if pkmn.form == sp.form
          end
    if form_ids.length <= 1
      elig = false
    end
    species_data = GameData::Species.get(pkmn.species)
	elig = false if pkmn.egg? || pkmn.shadowPokemon? || pkmn.cannot_trade || 
	  species_data.egg_groups.include?(:Undiscovered) || 
	  MultipleForms.hasFunction?(pkmn, "getForm") || 
	  MultipleForms.hasFunction?(pkmn, "getFormOnEnteringBattle") || 
	  MultipleForms.hasFunction?(pkmn, "getMegaForm") || 
	  MultipleForms.hasFunction?(pkmn, "getUltraBurstForm") ||
	  MultipleForms.hasFunction?(pkmn, "getFormOnLeavingBattle") ||
	  species_data.has_flag?("SpecialForm")
    eligibility.push(elig)
    formcmds_hash[index] = formcmds
    annot.push((elig) ? _INTL("ABLE") : _INTL("NOT ABLE"))
   end
  
    ret = -1
    @scene.pbStartScene(
      @party,
      (@party.length > 1) ? _INTL("Choose a Pokémon.") : _INTL("Choose Pokémon or cancel."),
      annot
    )
   loop do
      @scene.pbSetHelpText(
        (@party.length > 1) ? _INTL("Choose a Pokémon.") : _INTL("Choose Pokémon or cancel.")
      )
      pkmnid = @scene.pbChoosePokemon
      break if pkmnid < 0
      if !eligibility[pkmnid] && !allowIneligible
        pbDisplay(_INTL("This Pokémon can't be chosen."))
      else
        formcmds2 = formcmds_hash[pkmnid]
        cmd2 = pbMessage(_INTL("Which form would you like to trade for?."), formcmds2, -1)
          if cmd2 == -1
             pbMessage(_INTL("Maybe later, then."))
             next
          else
             form_name = formcmds2[cmd2]
             chosen_form_name = form_name.split(': ')[1] 
             
             myPokemon = $player.party[pkmnid]
             
             yourPokemon = myPokemon.clone
             
             #selected_form = form_ids[cmd2]	
             selected_form = cmd2
             if myPokemon.form == selected_form
               pbMessage(_INTL("Your Pokemon is already in that form!"))
               next
             else
               choice = pbConfirmMessage(_INTL("Would you like to trade for {1} Form of {2}?", chosen_form_name, myPokemon.name))
               if choice
                 yourPokemon.form = selected_form
                 break
               else
                 pbMessage(_INTL("Please choose a Pokemon."))
                next
              end
            end
          end
      end
    end
    @scene.pbEndScene
    return myPokemon, yourPokemon, pkmnid
  end
  
    def pbStartFormTrade(chosen, retval)
    $stats.trade_count += 1
    nickName = retval[0]
    trainerName = retval[1]
    trainerName ||= $game_map.events[@event_id].name
    trainerGender = retval[2]
    
    myPokemon = chosen[0]
    yourPokemon = chosen[1]
    
    resetmoves = true
    
    yourPokemon.owner = Pokemon::Owner.new_foreign(trainerName, trainerGender)
    yourPokemon.name          = nickName
    yourPokemon.obtain_method = 2   # traded
    yourPokemon.reset_moves if resetmoves
    yourPokemon.record_first_moves
    
		if PluginManager.installed?("Charms Case")
        tradingCharmIV = CharmCaseSettings::TRADING_CHARM_IV
          if $player.activeCharm?(:TRADINGCHARM)
            unless yourPokemon.tradingCharmStatsIncreased
              GameData::Stat.each_main do |s|
                stat_id = s.id
                # Adds 5 IVs to each stat.
                yourPokemon.iv[stat_id] = [yourPokemon.iv[stat_id] + tradingCharmIV, 31].min if yourPokemon.iv[stat_id]
              end
              # Set the attribute to track the stat increase
              yourPokemon.tradingCharmStatsIncreased = true
			end
            if rand(100) < CharmCaseSettings::TRADING_CHARM_SHINY
              yourPokemon.shiny = true
            end
		  end
	end
	
  pbFadeOutInWithMusic {
    evo = PokemonTrade_Scene.new
    evo.pbStartScreen(myPokemon, yourPokemon, $player.name, trainerName)
    evo.pbTrade
    evo.pbEndScreen
  }
  $player.party[chosen[2]] = yourPokemon
end




  
  
  
  

# ============ Start Method For Form Trader PC ====================== #
def pbFormTraderPC(nickName = nil, trainerName = nil, trainerGender = 0)
  chosen = -1
  retval = [[], [], []]
  pbFadeOutIn {
    scene = PokemonStorageScene.new
    screen = PokemonStorageScreen.new(scene, $PokemonStorage)
    chosen = screen.pbFormTradePC
    }
  if !chosen[0].nil?
    retval = nickName, trainerName, trainerGender
    pbStartFormTradePC(chosen, retval)
  else
    #pbMessage(_INTL("Come back if you want to trade."))
  end
end

class PokemonStorageScreen
   def pbFormTradePC
      $game_temp.in_storage = true
      @heldpkmn = nil
      @scene.pbStartBox(self, 0)
      storageLocation = [[],[]]
      myPokemon = nil
      yourPokemon = nil
      selected = []
      trainerName = "Form Trader"
      retval = nil
      loop do
        selected = @scene.pbSelectBox(@storage.party)
        if selected && selected[0] == -3   # Close box
          if pbConfirm(_INTL("Exit from the Box?"))
            pbSEPlay("PC close")
            break
          end
          next
        end
        if selected.nil?
          next if pbConfirm(_INTL("Continue Box operations?"))
          break
        elsif selected[0] == -4   # Box name
          pbBoxCommands
        else
          pokemon = @storage[selected[0], selected[1]]
          next if !pokemon
          species_data = GameData::Species.get(pokemon.species)
          #if species_data && species_data.egg_groups.include?(:Undiscovered) # These checks have been shut off, to allow for unconditional no nonsense form changing, for better or for worse
            #pbMessage("Legendary Pokemon are too rare! I can't find one of those!")
            #next
          #elsif MultipleForms.hasFunction?(pokemon, "getForm")
            #pbMessage("This species decides its own form and cannot be changed.")
            #next
		  #elsif   MultipleForms.hasFunction?(pokemon, "getFormOnEnteringBattle") || MultipleForms.hasFunction?(pokemon, "getMegaForm") || MultipleForms.hasFunction?(pokemon, "getUltraBurstForm") || MultipleForms.hasFunction?(pokemon, "getFormOnLeavingBattle") || species_data.has_flag?("SpecialForm") 
			#pbMessage("Sorry. This Pokemon is too special for me to do anything with.")
			#next
          #end
          formcmds = []
          form_name = [] 
          form_ids = []
          GameData::Species.each do |sp|
            next if sp.species != pokemon.species
            next if sp.mega_stone
            form_name = sp.form_name
            form_name = _INTL("Normal Form") if !form_name || form_name.empty?
            form_name = sprintf("%d: %s", sp.form, form_name)
            formcmds.push(form_name)
            form_ids.push(sp.form)
            cmd2 = sp.form if pokemon.form == sp.form
            end
          
          if formcmds.length <= 1
            pbMessage(_INTL("Species {1} only has one form.", pokemon.speciesName))
          else
            commands = [
              _INTL("Trade"),
              _INTL("Summary"),
            ]
            commands.push(_INTL("Debug")) if $DEBUG
            commands.push(_INTL("Cancel"))
            commands[2] = _INTL("Store") if selected[0] == -1
            helptext = _INTL("{1} is selected.", pokemon.name)
            command = pbShowCommands(helptext, commands)
            case command
            when 0   # Trade
              cmd2 = pbMessage(_INTL("Which form would you like to trade for?."), formcmds, -1)
              if cmd2 == -1
                pbMessage(_INTL("Maybe later, then."))
                next
              else
                form_name = formcmds[cmd2]
                chosen_form_name = form_name.split(': ')[1] 
                myPokemon = pokemon
                yourPokemon = pokemon.clone
                selected_form = form_ids[cmd2]				
                if myPokemon.form == selected_form
                  pbMessage(_INTL("Your Pokemon is already in that form!"))
                  next
                else
                  ret = pbConfirmMessage(_INTL("Would you like to trade for {1} Form of {2}?", chosen_form_name, pokemon.name))
                  if ret
                    yourPokemon.form = selected_form
                    break
                  else
                    pbMessage(_INTL("Please choose a Pokemon."))
                    next
                  end
                end
               end
            when 1
              pbSummary(selected, nil)
              next
            when 2
              if $DEBUG
                pbPokemonDebug(pokemon, selected)
              end
            end
          end
        end
      end
      @scene.pbCloseBox
      $game_temp.in_storage = false
      return [myPokemon || nil, yourPokemon || nil, selected&.[](0), selected&.[](1)]

    end
end 

  def pbStartFormTradePC(chosen, retval)
  myPokemon = chosen[0]
  yourPokemon = chosen[1]
  storageLocation = chosen[2]
  $stats.trade_count += 1 
  resetmoves = true
  nickName = retval[0]
  trainerName = retval[1]
  trainerName ||= $game_map.events[@event_id].name
  trainerGender = retval[2]
  
  yourPokemon.name = nickName
  yourPokemon.owner = Pokemon::Owner.new_foreign(trainerName, trainerGender)
  yourPokemon.obtain_method = 2   # traded
  yourPokemon.reset_moves if resetmoves
  yourPokemon.record_first_moves
  
	if PluginManager.installed?("Charms Case")
        tradingCharmIV = CharmCaseSettings::TRADING_CHARM_IV
          if $player.activeCharm?(:TRADINGCHARM)
            unless yourPokemon.tradingCharmStatsIncreased
              GameData::Stat.each_main do |s|
                stat_id = s.id
                # Adds 5 IVs to each stat.
                yourPokemon.iv[stat_id] = [yourPokemon.iv[stat_id] + tradingCharmIV, 31].min if yourPokemon.iv[stat_id]
              end
              # Set the attribute to track the stat increase
              yourPokemon.tradingCharmStatsIncreased = true
			end
            if rand(100) < CharmCaseSettings::TRADING_CHARM_SHINY
              yourPokemon.shiny = true
            end
		  end
	end
    
  pbFadeOutInWithMusic {
    evo = PokemonTrade_Scene.new
    evo.pbStartScreen(myPokemon, yourPokemon, $player.name, trainerName)
    evo.pbTrade
    evo.pbEndScreen
  }
   $PokemonStorage[chosen[2], chosen[3]] = yourPokemon
end
    
    
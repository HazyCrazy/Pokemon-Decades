################################################################################
# PSS Exp Gain and Exp.All Non-participant 50% Inhibitor toggles
# This is the final piece of the puzzle, to shut down all I don't like grinding
# excuses. Dexit is a good thing for the offical Pokemon games.
# Fan Games can have 1 of every Pokemon. Fan Games developers are right to 
# call fan games that slap all Pokemon up to the latest generation with no effort
# put into a making a custom region, and pathetically vomit Pokemon for Monotype 
# Challenge runs, with no shits given to the geography of an area. Dogshit cancer.
# Go ahead and say Pokemon Decades is a dogshit fan game. 
# I only wanted to, in a way that was feasible for me, solo,
# with Essentials's public resources. Make a fan game, that didn't repeat the same
# things, I don't like in the fan games I have played. 
# Pokemon Decades gives you one of every Pokemon after you obtain your starter.
# Because a negative experience with a version of Radical Red Hardcore Mode,
# where hatching eggs crashed the game. A crashing issue that meant 
# only Arcanine could handle Grassy Gilde Kartana. (It's a hell fight you will only understand if you have played Radical Red Hardcore Mode, and suffered the Egg Hatching crashing issue like I did)
# And when I finally brought the brick wall down. I was not happy. I was pissed off, so much, I went on a war path, to finish Hardocore Mode, out of raw spite, for a crashing glitch, that almost rendered the game unbeatable. 
# That negative experience irreversibly made me see the real flaws of the traditional regional dex and dividing distribution by linear progression sections.
# You can go ahead and condemn Pokemon Decades because I never want someone to suffer what I went through, with a linear progression section and crashing issue locking away tools I needed, to not suffer. 
# If I ever make Pokemon fan games again after Decades. You gotta get used to mine letting you have 1 of everything, unconditionally. I can never go back, after Grassy Glide Kartana.  
################################################################################

#===============================================================================
#  Pokémon Box Link Anti Grind Upgrades
#===============================================================================
ItemHandlers::UseFromBag.add(:POKEMONBOXLINK, proc { |item|
	cmds = ["PSS Exp Toggle", "Exp.All Inhibitor Toggle", "What do these toggles do?", "Optimal Grinding Guide", "Pokémon Vault", "Cancel"]
	c = pbMessage("Select a Power Leveling Preset", cmds)
	if c == 0
		if $game_switches[92] == true # PSS Exp Toggle
			$game_switches[92] = false
			pbMessage(_INTL("PSS Pokémon do not gain Exp from the Exp.All."))
			elsif $game_switches[92] == false 
			$game_switches[92] = true 
			pbMessage(_INTL("All PSS Pokémon gain Exp from the Exp.All!"))
			next 1 
		end
	elsif c == 1
		if $game_switches[91] == true # Exp.All Inhibitor Toggle
			$game_switches[91] = false # Exp.All's 50% penalty applies when the Inhibitor is active
			pbMessage(_INTL("The Exp.All's Inhibitor is active. The 50% Non-participant penalty will apply."))
			elsif $game_switches[91] == false 
			$game_switches[91] = true # Exp.All will give 100% of exp gains when the Inhibitor is off (Changes made in Battle_ExpAndMoveLearning, Line 114)
			pbMessage(_INTL("The Exp.All's Inhibitor is gone. Exp.All gains for Non-participants is 100%!"))
			next 1 
		end
		
	elsif c == 2
	pbShowTipCard(:POWERLEVEL1,:POWERLEVEL2)
	
	elsif c == 3
	pbShowTipCard(:POWERLEVEL4,:POWERLEVEL5,:POWERLEVEL6)
	
	elsif c == 4
	PokemonVault.open_menu
	
	end

	next 1
})

ItemHandlers::UseInField.add(:POKEMONBOXLINK, proc { |item|
	cmds = ["PSS Exp Toggle", "Exp.All Inhibitor Toggle", "What do these toggles do?", "Optimal Grinding Guide", "Pokémon Vault", "Cancel"]
	c = pbMessage("Select a Power Leveling Preset", cmds)
	if c == 0
		if $game_switches[92] == true # PSS Exp Toggle
			$game_switches[92] = false
			pbMessage(_INTL("PSS Pokémon do not gain Exp from the Exp.All."))
			elsif $game_switches[92] == false 
			$game_switches[92] = true 
			pbMessage(_INTL("All PSS Pokémon gain Exp from the Exp.All!"))
			next 1 
		end
	elsif c == 1
		if $game_switches[91] == true # Exp.All Inhibitor Toggle
			$game_switches[91] = false # Exp.All's 50% penalty applies when the Inhibitor is active
			pbMessage(_INTL("The Exp.All's Inhibitor is active. The 50% Non-participant penalty will apply."))
			elsif $game_switches[91] == false 
			$game_switches[91] = true # Exp.All will give 100% of exp gains when the Inhibitor is off (Changes made in Battle_ExpAndMoveLearning, Line 114)
			pbMessage(_INTL("The Exp.All's Inhibitor is gone. Exp.All gains for Non-participants is 100%!"))
			next 1 
		end
		
	elsif c == 2
	pbShowTipCard(:POWERLEVEL1,:POWERLEVEL2)
	
	elsif c == 3
	pbShowTipCard(:POWERLEVEL4,:POWERLEVEL5,:POWERLEVEL6)
	
	elsif c == 4
	PokemonVault.open_menu
	
	end
	
    next true
})

#===============================================================================
#  Exp.All Non Charm Case Toggle (The Charms Case Plugin was removed, 
# due to it conflicting with PSS Exp Gain
#===============================================================================
ItemHandlers::UseFromBag.add(:EXPALL, proc { |item|
	if $player.has_exp_all == false
		$player.has_exp_all = true
		pbMessage(_INTL("Non-participant Pokemon now gain 50% of the participant's Exp!"))
		elsif $player.has_exp_all == true
		$player.has_exp_all = false
		pbMessage(_INTL("Non-participant Pokemon will not gain any of the participant's Exp!"))
	end	
	
	next 1
})

ItemHandlers::UseInField.add(:EXPALL, proc { |item|
	if $player.has_exp_all == false
		$player.has_exp_all = true
		pbMessage(_INTL("Non-participant Pokemon now gain 50% of the participant's Exp!"))
		elsif $player.has_exp_all == true
		$player.has_exp_all = false
		pbMessage(_INTL("Non-participant Pokemon will not gain any of the participant's Exp!"))
	end	
	
	next true
})

#===============================================================================
#  Exp Charm Effect Application Overhaul (Changes made in Battle_ExpAndMoveLearning, search for: exp = exp * 3 / 2 if $bag.has?(:EXPCHARM)
#===============================================================================
ItemHandlers::UseFromBag.add(:EXPCHARM, proc { |item|
	#cmds = ["Turn off Exp Charm","50% boost", "100% boost", "300% boost", "1000% boost", "Cancel"]
	cmds = ["Turn off Exp Charm", "50% boost", "100% boost", "150% boost", "300% boost", "1000% boost", "Cancel"]
	c = pbMessage("Select a Exp Boost Preset", cmds)
	
	if c == 0
	$game_variables[96] = 0 # Exp Charm Boosts
	pbMessage(_INTL("The Exp Charm's boosting effect has been turned off."))
	
	elsif c == 1
	$game_variables[96] = 1
	pbMessage(_INTL("Exp Gain is boosted by 50%! (1 Lucky Egg, no Item Slot)"))
	
	elsif c == 2
	$game_variables[96] = 2
	pbMessage(_INTL("Exp Gain is boosted by 100%! (1 Lucky Egg, 1 Exp Charm)"))
	
	elsif c == 3
	$game_variables[96] = 3
	pbMessage(_INTL("Exp Gain is boosted by 150%! (1 Lucky Eggs, 1 Exp Charm, Pre Gen 7 Trainer Battle Boost)"))
	
	elsif c == 4
	$game_variables[96] = 4
	pbMessage(_INTL("Exp Gain is boosted by 300%! (6 Lucky Eggs, no Item Slots)"))
	
	elsif c == 5
	$game_variables[96] = 5
	pbMessage(_INTL("Exp Gain is boosted by 1000%! (10 Lucky Eggs, 10 Exp Charms)"))
	
	end

	next 1
})

ItemHandlers::UseInField.add(:EXPCHARM, proc { |item|
	#cmds = ["Turn off Exp Charm","50% boost", "100% boost", "300% boost", "1000% boost", "Cancel"]
	cmds = ["Turn off Exp Charm", "50% boost", "100% boost", "150% boost", "300% boost", "1000% boost", "Cancel"]
	c = pbMessage("Select a Exp Boost Preset", cmds)
	
	if c == 0
	$game_variables[96] = 0 # Exp Charm Boosts
	pbMessage(_INTL("The Exp Charm's boosting effect has been turned off."))
	
	elsif c == 1
	$game_variables[96] = 1
	pbMessage(_INTL("Exp Gain is boosted by 50%! (1 Lucky Egg, no Item Slot)"))
	
	elsif c == 2
	$game_variables[96] = 2
	pbMessage(_INTL("Exp Gain is boosted by 100%! (1 Lucky Egg, 1 Exp Charm)"))
	
	elsif c == 3
	$game_variables[96] = 3
	pbMessage(_INTL("Exp Gain is boosted by 150%! (1 Lucky Eggs, 1 Exp Charm, Pre Gen 7 Trainer Battle Boost)"))
	
	elsif c == 4
	$game_variables[96] = 4
	pbMessage(_INTL("Exp Gain is boosted by 300%! (6 Lucky Eggs, no Item Slots)"))
	
	elsif c == 5
	$game_variables[96] = 5
	pbMessage(_INTL("Exp Gain is boosted by 1000%! (10 Lucky Eggs, 10 Exp Charms)"))
	
	end
	
	next true
})
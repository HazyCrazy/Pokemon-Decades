################################################################################
# On command and on demand fast travel for Pokemon Decades (Not Plugin Resource friendly, due to a lack of checks and balances for Ally Trainers)
# This Key Item can only work for Pokemon Decades' design goals
# This Item exists, because no fan game, no matter how hard they try, can account for the entire spectrum of how people want to use their playtime, or players who are simply tourist consumers.
# The amount of times my real life friend expects me to have a 100% Save File for him, with whatever game he wants to play, and will not use any of the resources on the internet to do it himself,
# has become so annoying for me, that I am simply fed up with him. In the sense that his tourist consumerism of any video game that is not in the sandbox genre outright pisses me off.
# He's still my only friend. But my god, I'm just sick of PC Games that gatekeep their content behind 100+ hour time commitments. Single handily because of him.
# On the bright side, thank you my real life friend. The sheer annoyance of your whining that you cannot find a 100% Save File for the PC Game called Fuel, was a powerful motivator
# to make sure people like you, have no ground to stand on when you say, "I don't have the time to play that video game for that many hours, so I can have a 100% save file, so I can see everything."
# The execution of Pokemon Decades' game design turned out the way it is, because Level Curve and Level Candy Discourse in Pokemon Fan Games, is a retarded pissing contest. 
# And everything's set to the Level Format in Competitive battles anyway.  
################################################################################

# This item's function only works in the Field, not in the bag menu (Not true, I forget the bag_screen proc like a dumbass. But the Item's better off a Field Item anyway)
ItemHandlers::UseInField.add(:ROTOMPHONE, proc { |item|
	# Testing Fast Travel
	#cmds = ["Cherryhill City", "Shimmer Coast City", "Obsidian Peak City", "Cancel"]
	#c = pbMessage("Choose your destination", cmds)
	#if c == 0
	#	pbSEPlay("Dragon Ball Z Instant Transmission")
	#	$game_temp.player_new_map_id    = 77 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
	#	$game_temp.player_new_x         = 19 # Cord_X
	#	$game_temp.player_new_y         = 17 # Cord_Y
	#	$game_temp.player_new_direction = 2 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
	#	pbCancelVehicles
	#	$scene.transfer_player
	#	next 2
	#	
	#elsif c == 1
	#	pbSEPlay("Dragon Ball Z Instant Transmission")
	#	$game_temp.player_new_map_id    = 87 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
	#	$game_temp.player_new_x         = 36 # Cord_X
	#	$game_temp.player_new_y         = 26 # Cord_Y
	#	$game_temp.player_new_direction = 2 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
	#	pbCancelVehicles
	#	$scene.transfer_player
	#	next 2
		
	#elsif c == 2
	#	pbSEPlay("Dragon Ball Z Instant Transmission")
	#	$game_temp.player_new_map_id    = 90 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
	#	$game_temp.player_new_x         = 26 # Cord_X
	#	$game_temp.player_new_y         = 21 # Cord_Y
	#	$game_temp.player_new_direction = 2 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
	#	pbCancelVehicles
	#	$scene.transfer_player
	#	next 2
	
	#end 
	
	# Fast Travel Locations (X and Y Locations, and transfer directions are optmized for killing all tedium in getting to Quest Pokemon and Type Masters. If you REALLY are that level of impatient and a lazy bastard combined. But if your a Speedrunner, I'm with you in that I am popping off!)
	cmds = ["Toggle Damage Rolls", "Cherryhill City Quest 1", "Cloakfall Forest", "Grass Type Master", "Route 1 Quest 2", "Route 1 Underground", "Shimmer Coast Quest 3", "Shimmer Lighthouse", "Scatter Flood Islands Quest 4", "Scatter Flood Foes", "Water Type Master", "Obsidian Peak City Quest 5", "Obsidian Volcano", "Fire Type Master", "Mantic City Quest 6", "Prehistoric Grotto", "Futuristic Grotto", "Psychic Type Master", "Boulevard City Quest 7", "Route 5 Cave", "Fighting Type Master", "Penumbra City Quest 8", "Stygian Cave", "Dark Type Master", "Apterygota City Quest 9", "Apterygota Nest", "Bug Type Master", "Bulwark City Quest 10", "Gemstone Cave", "Rock Type Master", "Virga City Quest 11", "Virga Underpass", "Ground Type Master", "Lucid City Quest 12", "Lucid Weather Station", "Normal Type Master", "Circuit City Quest 13", "Circuit Factory", "Electric Type Master", "Noxious City Quest 14", "Mt.Vile", "Poison Type Master", "Sylph City Quest 15", "Sylph Playhouse", "Fairy Type Master", "Revenant City Quest 16", "Revenant Tomb", "Ghost Type Master", "Draco City Quest 17", "Draco Cave", "Dragon Type Master", "Iron City Quest 18", "Iron Complex", "Steel Type Master", "Crystal City Quest 19", "Sub Zero Islands", "Ice Type Master", "Stratos City Quest 20", "Stratos Horizon", "Flying Type Master", "Peninsula of Mastery", "Route 1", "Route 2", "Route 3", "Route 4", "Route 5", "Route 6", "Route 7", "Route 8", "Route 9", "Route 10", "Route 11", "Route 12", "Route 13", "Route 14", "Route 15", "Route 16", "Route 17", "Route 18", "Cherryhill East Gatehouse", "Cherryhill West Gatehouse", "Abandoned Cabin", "Cherryhill Center (Team/Gimmick Heal)", "Cherryhill Center (Anti Grind)", "Shimmer Coast Center (Team/Gimmick Heal)", "Shimmer Coast Center (Anti Grind)", "Obsidian Peak West Gatehouse", "Obsidian Volcano Exterior", "Obsidian Center (Team/Gimmick Heal", "Obsidian Center (Anti Grind)", "Mantic City East Gatehouse", "Mantic City West Gatehouse", "Mantic Center (Team/Gimmick Heal)", "Mantic Center (Anti Grind)", "Boulevard City East Gatehouse", "Boulevard City West Gatehouse", "Boulevard City Center (Team/Gimmick Heal)", "Boulevard City Center (Anti Grind)", "Penumbra City West Gatehouse", "Stygian Woods", "Penumbra Center (Team/Gimmick Heal)", "Penumbra Center (Anti Grind)", "Apterygota City East Gatehouse", "Apterygota Center (Team/Gimmick Heal)", "Apterygota Center (Anti Grind)", "Bulwark Center (Team/Gimmick Heal)", "Bulwark Center (Anti Grind)", "Virga City East Gatehouse", "Virga Center (Team/Gimmick Heal)", "Virga Center (Anti Grind)", "Lucid City West Gatehouse", "Lucid Center (Team/Gimmick Heal)", "Lucid Center (Anti Grind)", "Safari Zone", "Circuit City East Gatehouse", "Circuit Center (Team/Gimmick Heal)", "Circuit City (Anti Grind)", "Noxious Center (Team/Gimmick Heal)", "Noxious Center (Anti Grind)", "Sylph Center (Team/Gimmick Heal)", "Sylph Center (Anti Grind)", "Revenant Center (Team/Gimmick Heal)", "Revenant Center (Anti Grind)", "Draco City West Gatehouse", "Draco Center (Team/Gimmick Heal)", "Draco Center (Anti Grind)", "Iron City East Gatehouse", "Iron City West Gatehouse", "Iron Center (Team/Gimmick Heal)", "Iron Center (Anti Grind)", "Crystal Lake", "Crystal Center (Team/Gimmick Heal)", "Crystal Center (Anti Grind)", "Stratos Center (Team/Gimmick Heal)", "Stratos Center (Anti Grind)", "Zenith Domain (Sequence Break)", "Super Domain (Sequence Break)", "Battle Paradise 130", "Battle Paradise 230", "Battle Paradise 330", "Battle Paradise 430", "Cancel"]
	c = pbMessage("Choose your destination", cmds)	
	if c == 0 # Damage Rolls Toggle
		if $game_switches[94] == true # Game Switch 94 is Damage Roll Toggle (When false, Damage dealt to player and foes is a variance of 85% to 100% of the calculated damge. Speedruns need consistency, and the normal Damage Roll does not cut it for the highest level speedruns)
			$game_switches[94] = false # Damage rolls revert back to their 85% to 100% variance of calculated damage (This option is for Speedrunners only)
			pbMessage(_INTL("Damage Rolls are a 85% to 100% variance!"))
			elsif $game_switches[94] == false # Game Switch 94 is Damage Roll Toggle (When false, Damage dealt to player and foes is a variance of 85% to 100% of the calculated damge. Speedruns need consistency, and the normal Damage Roll does not cut it for the highest level speedruns)
			$game_switches[94] = true # Damage rolls will always deal 100% of calculated damage (Changes applied in Move_UsageCalculations, Line 458)
			pbMessage(_INTL("Damage Rolls always deal 100% of calculated damage!"))
			next 1 
		end
		next true
	
	elsif c == 1 # Cherryhill City Quest 1 
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 77 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 28 # Cord_X
		$game_temp.player_new_y         = 25 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 2 # Cloakfall Forest
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 82 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 25 # Cord_X
		$game_temp.player_new_y         = 17 # Cord_Y
		$game_temp.player_new_direction = 1 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 3 # Grass Type Master
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 80 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 15 # Cord_X
		$game_temp.player_new_y         = 15 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 4 # Route 1 Quest 1
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 86 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 29 # Cord_X
		$game_temp.player_new_y         = 26 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 5 # Route 1 Quest 1 Underground
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 138 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 10 # Cord_X
		$game_temp.player_new_y         = 16 # Cord_Y
		$game_temp.player_new_direction = 2 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2	
	elsif c == 6 # Shimmer Coast Quest 3 
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 87 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 36 # Cord_X
		$game_temp.player_new_y         = 35 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2	
	elsif c == 6
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 87 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 12 # Cord_X
		$game_temp.player_new_y         = 30 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2	
	elsif c == 7 # Shimmer Lighthouse
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 87 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 12 # Cord_X
		$game_temp.player_new_y         = 30 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2	
	elsif c == 8 # Scatter Flood Islands Quest 4
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 154 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 40 # Cord_X
		$game_temp.player_new_y         = 20 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2	
	elsif c == 9 # Scatter Flood Foes
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 154 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 40 # Cord_X
		$game_temp.player_new_y         = 14 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2	
	elsif c == 10 # Water Type Master
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 195 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 15 # Cord_X
		$game_temp.player_new_y         = 15 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2	
	elsif c == 11 # Obsidian Peak City Quest 5
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 90 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 35 # Cord_X
		$game_temp.player_new_y         = 30 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 12 # Obsidian Volcano
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 155 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 27 # Cord_X
		$game_temp.player_new_y         = 11 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 13 # Fire Type Master
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 196 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 15 # Cord_X
		$game_temp.player_new_y         = 15 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 14 # Mantic City Quest 6
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 96 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 34 # Cord_X
		$game_temp.player_new_y         = 35 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 15 # Prehistoric Grotto
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 156 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 20 # Cord_X
		$game_temp.player_new_y         = 28 # Cord_Y
		$game_temp.player_new_direction = 2 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 16 # Futuristic Grotto
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 157 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 20 # Cord_X
		$game_temp.player_new_y         = 28 # Cord_Y
		$game_temp.player_new_direction = 2 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 17 # Psychic Type Master
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 198 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 15 # Cord_X
		$game_temp.player_new_y         = 15 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 18 # Boulevard City Quest 7
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 101 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 33 # Cord_X
		$game_temp.player_new_y         = 47 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 19 # Route 5 Cave
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 158 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 14 # Cord_X
		$game_temp.player_new_y         = 9 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 20 # Fighting Type Master
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 213 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 15 # Cord_X
		$game_temp.player_new_y         = 15 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 21 # Penumbra City Quest 8
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 103 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 32 # Cord_X
		$game_temp.player_new_y         = 30 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 22 # Stygian Cave
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 159 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 14 # Cord_X
		$game_temp.player_new_y         = 9 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 23 # Dark Type Master
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 214 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 15 # Cord_X
		$game_temp.player_new_y         = 15 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 24 # Apterygota City Quest 9
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 111 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 30 # Cord_X
		$game_temp.player_new_y         = 35 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 25 # Apterygota Nest
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 160 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 10 # Cord_X
		$game_temp.player_new_y         = 16 # Cord_Y
		$game_temp.player_new_direction = 2 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 26 # Bug Type Master
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 215 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 15 # Cord_X
		$game_temp.player_new_y         = 15 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 27 # Bulwark City Quest 10
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 113 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 16 # Cord_X
		$game_temp.player_new_y         = 28 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 28 # Gemstone Cave
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 162 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 30 # Cord_X
		$game_temp.player_new_y         = 17 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 29 # Rock Type Master
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 216 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 15 # Cord_X
		$game_temp.player_new_y         = 15 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 30 # Virga City Quest 11
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 115 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 35 # Cord_X
		$game_temp.player_new_y         = 42 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 31 # Virga Underpass
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 163 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 25 # Cord_X
		$game_temp.player_new_y         = 21 # Cord_Y
		$game_temp.player_new_direction = 1 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 32 # Ground Type Master
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 217 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 15 # Cord_X
		$game_temp.player_new_y         = 15 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 33 # Lucid City Quest 12
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 117 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 34 # Cord_X
		$game_temp.player_new_y         = 28 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 34 # Lucid Weather Station
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 117 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 21 # Cord_X
		$game_temp.player_new_y         = 10 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 35 # Normal Type Master
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 218 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 15 # Cord_X
		$game_temp.player_new_y         = 15 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 36 # Circuit City Quest 13
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 119 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 29 # Cord_X
		$game_temp.player_new_y         = 28 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 37 # Circuit Factory
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 119 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 24 # Cord_X
		$game_temp.player_new_y         = 11 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 38 # Electric Type Master
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 219 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 15 # Cord_X
		$game_temp.player_new_y         = 15 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 39 # Noxious City Quest 14
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 121 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 26 # Cord_X
		$game_temp.player_new_y         = 28 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 40 # Mt.Vile
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 173 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 33 # Cord_X
		$game_temp.player_new_y         = 16 # Cord_Y
		$game_temp.player_new_direction = 2 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 41 # Poison Type Master
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 220 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 15 # Cord_X
		$game_temp.player_new_y         = 15 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 42 # Sylph City Quest 15
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 123 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 27 # Cord_X
		$game_temp.player_new_y         = 37 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 43 # Sylph Playhouse
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 123 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 22 # Cord_X
		$game_temp.player_new_y         = 16 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 44 # Fairy Type Master
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 221 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 15 # Cord_X
		$game_temp.player_new_y         = 15 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 45 # Revenant City Quest 16
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 125 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 25 # Cord_X
		$game_temp.player_new_y         = 28 # Cord_Y
		$game_temp.player_new_direction = 2 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 46 # Revenant Tomb
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 166 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 10 # Cord_X
		$game_temp.player_new_y         = 16 # Cord_Y
		$game_temp.player_new_direction = 2 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 47 # Ghost Type Master
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 222 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 15 # Cord_X
		$game_temp.player_new_y         = 15 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 48 # Draco City Quest 17
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 127 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 31 # Cord_X
		$game_temp.player_new_y         = 48 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 49 # Draco Cave
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 167 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 14 # Cord_X
		$game_temp.player_new_y         = 15 # Cord_Y
		$game_temp.player_new_direction = 2 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 50 # Dragon Type Master
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 223 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 15 # Cord_X
		$game_temp.player_new_y         = 15 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 51 # Iron City Quest 18
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 129 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 33 # Cord_X
		$game_temp.player_new_y         = 32 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 52 # Iron Complex
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 129 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 28 # Cord_X
		$game_temp.player_new_y         = 12 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 53 # Steel Type Master
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 224 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 15 # Cord_X
		$game_temp.player_new_y         = 15 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 54 # Crystal City Quest 19
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 131 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 26 # Cord_X
		$game_temp.player_new_y         = 37 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 55 # Sub Zero Islands
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 179 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 40 # Cord_X
		$game_temp.player_new_y         = 14 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 56 # Ice Type Master
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 225 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 15 # Cord_X
		$game_temp.player_new_y         = 15 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 57 # Stratos City Quest 20
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 133 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 45 # Cord_X
		$game_temp.player_new_y         = 30 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 58 # Stratos Horizon
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 171 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 30 # Cord_X
		$game_temp.player_new_y         = 12 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 59 # Flying Type Master
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 226 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 15 # Cord_X
		$game_temp.player_new_y         = 15 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 60 # Peninsula of Mastery
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 135 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 19 # Cord_X
		$game_temp.player_new_y         = 22 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 61 # Route 1
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 86 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 22 # Cord_X
		$game_temp.player_new_y         = 28 # Cord_Y
		$game_temp.player_new_direction = 2 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 62 # Route 2
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 88 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 40 # Cord_X
		$game_temp.player_new_y         = 24 # Cord_Y
		$game_temp.player_new_direction = 2 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 63 # Route 3
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 89 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 24 # Cord_X
		$game_temp.player_new_y         = 45 # Cord_Y
		$game_temp.player_new_direction = 2 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 64 # Route 4
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 94 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 27 # Cord_X
		$game_temp.player_new_y         = 22 # Cord_Y
		$game_temp.player_new_direction = 2 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 65 # Route 5
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 100 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 30 # Cord_X
		$game_temp.player_new_y         = 43 # Cord_Y
		$game_temp.player_new_direction = 2 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 66 # Route 6
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 102 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 22 # Cord_X
		$game_temp.player_new_y         = 24 # Cord_Y
		$game_temp.player_new_direction = 2 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 67 # Route 7
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 109 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 20 # Cord_X
		$game_temp.player_new_y         = 20 # Cord_Y
		$game_temp.player_new_direction = 2 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 68 # Route 8
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 112 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 22 # Cord_X
		$game_temp.player_new_y         = 27 # Cord_Y
		$game_temp.player_new_direction = 2 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 69 # Route 9
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 114 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 33 # Cord_X
		$game_temp.player_new_y         = 20 # Cord_Y
		$game_temp.player_new_direction = 2 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 70 # Route 10
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 116 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 17 # Cord_X
		$game_temp.player_new_y         = 13 # Cord_Y
		$game_temp.player_new_direction = 2 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 71 # Route 11
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 118 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 40 # Cord_X
		$game_temp.player_new_y         = 24 # Cord_Y
		$game_temp.player_new_direction = 2 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 72 # Route 12
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 120 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 25 # Cord_X
		$game_temp.player_new_y         = 12 # Cord_Y
		$game_temp.player_new_direction = 2 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 73 # Route 13
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 122 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 32 # Cord_X
		$game_temp.player_new_y         = 13 # Cord_Y
		$game_temp.player_new_direction = 2 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 74 # Route 14
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 124 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 20 # Cord_X
		$game_temp.player_new_y         = 17 # Cord_Y
		$game_temp.player_new_direction = 2 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 75 # Route 15
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 126 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 35 # Cord_X
		$game_temp.player_new_y         = 32 # Cord_Y
		$game_temp.player_new_direction = 2 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 76 # Route 16
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 128 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 28 # Cord_X
		$game_temp.player_new_y         = 21 # Cord_Y
		$game_temp.player_new_direction = 2 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 77 # Route 17
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 130 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 22 # Cord_X
		$game_temp.player_new_y         = 15 # Cord_Y
		$game_temp.player_new_direction = 2 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 78 # Route 18
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 132 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 36 # Cord_X
		$game_temp.player_new_y         = 29 # Cord_Y
		$game_temp.player_new_direction = 2 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 79 # Cherryhill East Gatehouse
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 81 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 17 # Cord_X
		$game_temp.player_new_y         = 14 # Cord_Y
		$game_temp.player_new_direction = 2 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 80 # Cherryhill West Gatehouse
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 91 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 17 # Cord_X
		$game_temp.player_new_y         = 14 # Cord_Y
		$game_temp.player_new_direction = 2 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 81 # Abandoned Cabin
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 84 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 27 # Cord_X
		$game_temp.player_new_y         = 19 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 82 # Cherryhill Center (Team Heal/Gimmick Recharge)
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 79 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 12 # Cord_X
		$game_temp.player_new_y         = 14 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 83 # Cherryhill Center (Anti Grind Battle)
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 79 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 10 # Cord_X
		$game_temp.player_new_y         = 15 # Cord_Y
		$game_temp.player_new_direction = 3 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 84 # Shimmer Coast Center (Team Heal/Gimmick Recharge)
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 194 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 12 # Cord_X
		$game_temp.player_new_y         = 14 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 85 # Shimmer Coast Center (Anti Grind Battle)
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 194 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 10 # Cord_X
		$game_temp.player_new_y         = 15 # Cord_Y
		$game_temp.player_new_direction = 3 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 86 # Obsidian Peak West Gatehouse
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 95 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 17 # Cord_X
		$game_temp.player_new_y         = 14 # Cord_Y
		$game_temp.player_new_direction = 2 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 87 # Obsidian Volcano Exterior
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 93 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 21 # Cord_X
		$game_temp.player_new_y         = 21 # Cord_Y
		$game_temp.player_new_direction = 2 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 88 # Obsidian Center (Team Heal/Gimmick Recharge)
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 164 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 12 # Cord_X
		$game_temp.player_new_y         = 14 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 89 # Obsidian Center (Anti Grind Battle)
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 164 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 10 # Cord_X
		$game_temp.player_new_y         = 15 # Cord_Y
		$game_temp.player_new_direction = 3 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 90 # Mantic City East Gatehouse
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 98 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 17 # Cord_X
		$game_temp.player_new_y         = 14 # Cord_Y
		$game_temp.player_new_direction = 2 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 91 # Mantic City West Gatehouse
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 99 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 17 # Cord_X
		$game_temp.player_new_y         = 14 # Cord_Y
		$game_temp.player_new_direction = 2 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 92 # Mantic Center (Team Heal/Gimmick Recharge)
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 197 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 12 # Cord_X
		$game_temp.player_new_y         = 14 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 93 # Mantic Center (Anti Grind Battle)
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 197 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 10 # Cord_X
		$game_temp.player_new_y         = 15 # Cord_Y
		$game_temp.player_new_direction = 3 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 94 # Boulevard City East Gatehouse
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 105 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 17 # Cord_X
		$game_temp.player_new_y         = 12 # Cord_Y
		$game_temp.player_new_direction = 2 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 95 # Boulevard City West Gatehouse
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 106 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 17 # Cord_X
		$game_temp.player_new_y         = 12 # Cord_Y
		$game_temp.player_new_direction = 2 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 96 # Boulevard City Center (Team Heal/Gimmick Recharge)
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 199 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 12 # Cord_X
		$game_temp.player_new_y         = 14 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 97 # Boulevard City Center (Anti Grind Battle)
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 199 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 10 # Cord_X
		$game_temp.player_new_y         = 15 # Cord_Y
		$game_temp.player_new_direction = 3 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 98 # Penumbra City West Gatehouse
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 108 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 17 # Cord_X
		$game_temp.player_new_y         = 12 # Cord_Y
		$game_temp.player_new_direction = 2 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 99 # Stygian Woods
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 110 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 25 # Cord_X
		$game_temp.player_new_y         = 16 # Cord_Y
		$game_temp.player_new_direction = 2 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 100 # Penumbra Center (Team Heal/Gimmick Recharge)
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 200 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 12 # Cord_X
		$game_temp.player_new_y         = 14 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 101 # Penumbra Center (Anti Grind Battle)
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 200 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 10 # Cord_X
		$game_temp.player_new_y         = 15 # Cord_Y
		$game_temp.player_new_direction = 3 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 102 # Apterygota City East Gatehouse
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 142 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 17 # Cord_X
		$game_temp.player_new_y         = 12 # Cord_Y
		$game_temp.player_new_direction = 2 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 103 # Apterygota Center (Team Heal/Gimmick Recharge)
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 201 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 12 # Cord_X
		$game_temp.player_new_y         = 14 # Cord_Y
		$game_temp.player_new_direction = 2 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 104 # Apterygota Center (Anti Grind Battle)
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 201 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 10 # Cord_X
		$game_temp.player_new_y         = 15 # Cord_Y
		$game_temp.player_new_direction = 3 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 105 # Bulwark Center (Team Heal/Gimmick Recharge)
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 202 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 12 # Cord_X
		$game_temp.player_new_y         = 14 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 106 # Bulwark Center (Anti Grind Battle)
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 202 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 10 # Cord_X
		$game_temp.player_new_y         = 15 # Cord_Y
		$game_temp.player_new_direction = 3 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 107 # Virga City East Gatehouse
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 144 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 17 # Cord_X
		$game_temp.player_new_y         = 12 # Cord_Y
		$game_temp.player_new_direction = 2 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 108 # Virga Center (Team Heal/Gimmick Recharge)
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 203 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 12 # Cord_X
		$game_temp.player_new_y         = 14 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 109 # Virga Center (Anti Grind Battle)
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 203 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 10 # Cord_X
		$game_temp.player_new_y         = 15 # Cord_Y
		$game_temp.player_new_direction = 3 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 110 # Lucid City West Gatehouse
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 146 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 17 # Cord_X
		$game_temp.player_new_y         = 12 # Cord_Y
		$game_temp.player_new_direction = 2 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 111 # Lucid Center (Team Heal/Gimmick Recharge)
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 204 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 12 # Cord_X
		$game_temp.player_new_y         = 14 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 112 # Lucid Center (Anti Grind Battle)
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 204 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 10 # Cord_X
		$game_temp.player_new_y         = 15 # Cord_Y
		$game_temp.player_new_direction = 3 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 113 # Safari Zone
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 193 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 20 # Cord_X
		$game_temp.player_new_y         = 28 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 114 # Circuit City East Gatehouse
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 148 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 17 # Cord_X
		$game_temp.player_new_y         = 12 # Cord_Y
		$game_temp.player_new_direction = 2 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 115 # Circuit Center (Team Heal/Gimmick Recharge)
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 205 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 12 # Cord_X
		$game_temp.player_new_y         = 14 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 116 # Circuit Center (Anti Grind Battle)
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 205 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 10 # Cord_X
		$game_temp.player_new_y         = 15 # Cord_Y
		$game_temp.player_new_direction = 3 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 117 # Noxious Center (Team Heal/Gimmick Recharge)
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 206 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 12 # Cord_X
		$game_temp.player_new_y         = 14 # Cord_Y
		$game_temp.player_new_direction = 3 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 118 # Noxious Center (Anti Grind Battle)
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 206 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 10 # Cord_X
		$game_temp.player_new_y         = 15 # Cord_Y
		$game_temp.player_new_direction = 3 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 119 # Sylph Center (Team Heal/Gimmick Recharge)
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 207 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 12 # Cord_X
		$game_temp.player_new_y         = 14 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 120 # Sylph Center (Anti Grind Battle)
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 207 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 10 # Cord_X
		$game_temp.player_new_y         = 15 # Cord_Y
		$game_temp.player_new_direction = 3 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 121 # Revenant Center (Team Heal/Gimmick Recharge)
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 208 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 12 # Cord_X
		$game_temp.player_new_y         = 14 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 122 # Revenant Center (Anti Grind Battle)
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 208 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 10 # Cord_X
		$game_temp.player_new_y         = 15 # Cord_Y
		$game_temp.player_new_direction = 3 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 123 # Draco City West Gatehouse
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 150 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 17 # Cord_X
		$game_temp.player_new_y         = 12 # Cord_Y
		$game_temp.player_new_direction = 2 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 124 # Draco Center (Team Heal/Gimmick Recharge)
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 209 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 12 # Cord_X
		$game_temp.player_new_y         = 14 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 125 # Draco Center (Anti Grind Battle)
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 209 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 10 # Cord_X
		$game_temp.player_new_y         = 15 # Cord_Y
		$game_temp.player_new_direction = 3 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 126 # Iron City East Gatehouse
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 153 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 17 # Cord_X
		$game_temp.player_new_y         = 12 # Cord_Y
		$game_temp.player_new_direction = 2 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 127 # Iron City West Gatehouse
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 152 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 17 # Cord_X
		$game_temp.player_new_y         = 12 # Cord_Y
		$game_temp.player_new_direction = 2 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 128 # Iron Center (Team Heal/Gimmick Recharge)
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 210 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 12 # Cord_X
		$game_temp.player_new_y         = 14 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 129 # Iron Center (Anti Grind Battle)
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 210 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 12 # Cord_X
		$game_temp.player_new_y         = 15 # Cord_Y
		$game_temp.player_new_direction = 3 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 130 # Crystal Lake
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 169 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 18 # Cord_X
		$game_temp.player_new_y         = 14 # Cord_Y
		$game_temp.player_new_direction = 2 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 131 # Crystal Center (Team Heal/Gimmick Recharge)
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 211 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 12 # Cord_X
		$game_temp.player_new_y         = 14 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 132 # Crystal Center (Anti Grind Battle)
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 211 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 10 # Cord_X
		$game_temp.player_new_y         = 15 # Cord_Y
		$game_temp.player_new_direction = 3 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 133 # Stratos Center (Team Heal/Gimmick Recharge)
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 212 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 12 # Cord_X
		$game_temp.player_new_y         = 14 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 134 # Stratos Center (Anti Grind Battle)
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 212 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 10 # Cord_X
		$game_temp.player_new_y         = 15 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 135 # Zenith Domain (Sequence Break)
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 136 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 9 # Cord_X
		$game_temp.player_new_y         = 13 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 136 # Super Domain (Sequence Break)
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 137 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 9 # Cord_X
		$game_temp.player_new_y         = 10 # Cord_Y
		$game_temp.player_new_direction = 0 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 137 # Battle Paradise 130 (Battle Mode)
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 33 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 30 # Cord_X
		$game_temp.player_new_y         = 16 # Cord_Y
		$game_temp.player_new_direction = 2 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 138 # Battle Paradise 230 (Battle Mode)
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 42 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 30 # Cord_X
		$game_temp.player_new_y         = 16 # Cord_Y
		$game_temp.player_new_direction = 2 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 139 # Battle Paradise 330 (Battle Mode)
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 43 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 30 # Cord_X
		$game_temp.player_new_y         = 16 # Cord_Y
		$game_temp.player_new_direction = 2 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	elsif c == 140 # Battle Paradise 430 (Battle Mode)
		pbSEPlay("Dragon Ball Z Instant Transmission")
		$game_temp.player_new_map_id    = 48 # Map_id (Can be found in the Project Editor, on the bottom right corner of a Level Map. ID: Map Name (Width x Height) Click on an area in the Events Layer to find the exact X and Y location your transfer needs)
		$game_temp.player_new_x         = 30 # Cord_X
		$game_temp.player_new_y         = 16 # Cord_Y
		$game_temp.player_new_direction = 2 # Direction (0 is up, 1 is right, 2 is down, 3 is left)
		pbCancelVehicles
		$scene.transfer_player
		next 2
	
	end 
	
    next true
})

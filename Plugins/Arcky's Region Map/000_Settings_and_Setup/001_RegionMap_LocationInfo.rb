=begin
  The following settings for text formatting can be used for the description of each location.
  <b> ... </b>       - Formats the text in bold.
  <i> ... </i>       - Formats the text in italics.
  <u> ... </u>       - Underlines the text.
  <s> ... </s>       - Draws a strikeout line over the text.
  <al> ... </al>     - Left-aligns the text.  Causes line breaks before and after
                       the text.
  <r>                - Right-aligns the text until the next line break.
  <ar> ... </ar>     - Right-aligns the text.  Causes line breaks before and after
                       the text.
  <ac> ... </ac>     - Centers the text.  Causes line breaks before and after the
                       text.
  <br>               - Causes a line break.
  <o=X>              - Displays the text in the given opacity (0-255)
  <outln>            - Displays the text in outline format.
  <outln2>           - Displays the text in outline format (outlines more
                       exaggerated.
  <icon=X>           - Displays the icon X (in Graphics/Icons/).


module ARMLocationPreview
  # Region0
  LappetTown = {
    description: _INTL("A fairly old and loud town. It's a big and not so pretty place."), # \n or <br> can be used to add a line break.
    south: [13, 13],
    north: [13, 11],
    west: [12, 12],
    icon: "LappetTown"
  }

  Route1 = {
    description: _INTL("<ac>The first Route in the Region and a home to Kurt.</ac>"), # <ac>text</ac> can be used to center text horizontally.
    south: [13, 12],
    north: [13, 10]
  }

  CedolanCity = {
    # location [13, 10]
    northEast_13_10: [14, 9],
    south_13_10: [13, 11],
    # location [14, 10]
    north_14_10: [14, 9],
    southWest_14_10: [13, 11],
    # used for both locations
    east: [15, 10],
    west: [12, 10],
    description_13_10: _INTL("The biggest City in Essen. It has a department store!"),
    description_14_10: _INTL("The biggest City in Essen. It has a department store and what does it not have?"),
    icon: "LappetTown",
    landMarks: {
      "Pokemon Center" => _INTL("The place to be when you're feeling tired and your Pokémon too of course."),
      "Department Store" => _INTL("A 6 floor tall building where you can almost buy anything you can imagine."),
      "Game Corner" => _INTL("A great place to spend the day but don't be mad if you're broke at the end!"),
      "Cedolan Gym" => _INTL("Earn the Rainbow Badge by defeating Eric the Bug Type Gym Leader."),
      "Pokemon Institute" => _INTL("A place for people that like to go to an institute...")
    }
  }

  Route2 = {
    description: _INTL("A route with a lot of bridges."),
    east_14_8: [15, 8],
    northEast_14_9: [15, 8],
    south: [13, 10]
  }

  LeruceanTown = {
    west: [14, 8],
    east: [16, 8],
    north: [15, 7],
    description: _INTL("Another Small Town. And a lot of text to fill the space here up to 3 lines yes yes baguette!"),
    icon: "LappetTown"
  }

  NaturalPark = {
    west: [15, 8],
    description: _INTL("A big Park and it's natural.")
  }

  Route3 = {
    west_14_6: [13, 6],
    east_14_6: _INTL("Ice Cave"),
    west_15_6: [13, 6],
    south_15_6: [15, 8],
    south_15_7: [15, 8],
    north_15_7: _INTL("Ice Cave"),
    description: _INTL("A Route full with Trainers."),
    description_15_6: _INTL("An Icy Cold Cave located here... And still a lot of Trainers!")
  }

  IngidoPlateau = {
    description: _INTL("Once a trainer has collected all 8 Badges, they are allowed to enter the League and challenge the E4 and Champion!"),
    west: [12, 6],
    east: [14, 6]
  }

  Route4 = {
    description: _INTL("The start of the Cycling Bridge."),
    south_11_6: [11, 7],
    east: [13, 6],
    southWest_12_6: [11, 7]
  }

  Route5 = {
    description: _INTL("The Cycling Bridge itself!"),
    north: [11, 6],
    south: [11, 10]
  }

  Route6 = {
    description: _INTL("The end of the Cycling Bridge"),
    north_11_10: [11, 7],
    northWest_12_10: [11, 7],
    east: [13, 10]
  }

  Route7 = {
    description: _INTL("A rocky route with mountains and caves and stuff.")
  }

  BattleFrontier = {
    south: [18, 17],
    west: _INTL("Rock Cave"),
    description: _INTL("Challenge the Brains of the Frontier! Which are just Humans.")
  }

  SafariZone = {
    description: _INTL("A zone to go on Safari. What else would you do here?"),
    east: [13, 12]
  }

  Route8 = {
    description: _INTL("Is this even a Route? It's just water and a waterfall."),
    north: [13, 12]
  }

  BerthIsland = {
    description: _INTL("The island which is home to the Pokémon named Deoxys.")
  }

  FaradayIsland = {
    description: _INTL("The island which is home to the Pokémon named Mew and it's shiny!")
  }

  # Region1
  TiallRegion = {
    description: _INTL("There's something here but I don't know what!")
  }

  #Region2
  ViraidanCity = {
    description: _INTL("All there's known about this place is that they sell Baguette!")
  }
end

=end

module ARMLocationPreview
	# Pokemon Decades Beatha Region (1 Region game. 18 Type Masters for Story Mode, 18 Routes, 2 Islands, 1 Battle Paradise Island for Battle Mode, 1 Final Boss (Stellar Master), 1 Super Boss. (Unknown Master)
	# Full Gen 9 Legends ZA National Dex, Megas, Z-Moves, Dynamax, Tera and NTAW STAB MYFT (Normal Type Attacks Without Same Type Attack Bonus Match Your First/Tera Type
	
	# International Airport (Exists as the player's last chance to setup their playthrough in the way they want)
	InternationalAirport = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("The location all Trainers use to get to Regions all around the world.") # \n or <br> can be used to add a line break.
	}
  
    # Battle Paradise
	BattleParadise130 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("The 1st chuck of an area with 438 Pokemon Trainers from around the world.") # \n or <br> can be used to add a line break.
	}
  
	BattleParadise230 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("The 2nd chuck of an area with 438 Pokemon Trainers from around the world.") # \n or <br> can be used to add a line break.
	}
  
	BattleParadise330 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("The 3rd chuck of an area with 438 Pokemon Trainers from around the world.") # \n or <br> can be used to add a line break.
	}
  
	BattleParadise430 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("The 4th chuck of an area with 438 Pokemon Trainers from around the world.") # \n or <br> can be used to add a line break.
	}
	
	# Type Master Cities
	CherryhillCity = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
  
	ShimmerCoastCity = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	ObsidianPeakCity = {
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	ManticCity = {
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	BoulevardCity = {
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	PenumbraCity = {
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	ApterygotaCity = {
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	BulwarkCity = {
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	VirgaCity = {
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	LucidCity = {
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	CircuitCity = {
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	NoxiousCity = {
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	SylphCity = {
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	RevenantCity = {
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	DracoCity = {
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	IronCity = {
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	CrystalCity = {
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	StratosCity = {
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
  
	# Routes 
	Route1 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	Underground1 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
  
	Route2 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	Route3 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	Route4 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	Route5 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	Cave5 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	Route6 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	Route7 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	Route8 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	Route9 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	Route10 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	Route11 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	Route12 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	Route13 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	Route14 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	Route15 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	Route16 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	Route17 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	Route18 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
  
	# Landmarks 
	CloakfallForest = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	ObsidianVolcanoExterior = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	ObsidianVolcano = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	PrehistoricGrotto = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	FuturisticGrotto = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	StygianWoods = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	StygianCave = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	ApterygotaNest = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	GemstoneCave = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	VirgaUnderpass = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	GenerationsZone = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("A place where any Trainer can create any Pokemon they want.") # \n or <br> can be used to add a line break.
	}
	
	ForestZone = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	CityZone = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	DesertZone = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	ScrublandsZone = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	CragZone = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	VolcanoZone = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	TundraZone = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	CaveZone = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	BeachZone = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	SeafloorZone = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	RiverZone = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	SkyZone = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	IndustralZone = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	SimpleField = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	MtVile = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	RevenantTomb = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	DracoCave = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	CrystalLake = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	StratosHorizon = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	PeninsulaofMastery = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Without this monument, Beatha's balance will collapse. One day, without a Trainer holding the Stellar Emerald, this monument will break.") # \n or <br> can be used to add a line break.
	}
	
	ZenithDomain = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("If the power in this domain enters the world, the world is doomed. Only the Stellar Emerald can stop this power.") # \n or <br> can be used to add a line break.
	}
	
	# Islands 
	ScatterFloodIslands = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	SubZeroIslands = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
  
	# Gatehouses
	CherryhillEastGatehouse = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	CherryhillWestGatehouse = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	ObsidianPeakWestGatehouse = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	ManticCityEastGatehouse = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	ManticCityWestGatehouse = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	BoulevardCityEastGatehouse = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	BoulevardCityWestGatehouse = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	PenumbraCityWestGatehouse = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	ApterygotaCityEastGatehouse = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	VirgaCityEastGatehouse = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	LucidCityWestGatehouse = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	CircuitCityWestGatehouse = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	DracoCityWestGatehouse = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	IronCityEastGatehouse = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
	
	IronCityWestGatehouse = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area.") # \n or <br> can be used to add a line break.
	}
  
  # Mystery Zones 
	MysteryZone0 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area. (Scatter Flood Islands)") # \n or <br> can be used to add a line break.
	}
	
	MysteryZone1 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area. (Shimmer Coast City)") # \n or <br> can be used to add a line break.
	}
	
	MysteryZone2 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area. (Route 1)") # \n or <br> can be used to add a line break.
	}
	
	MysteryZone3 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area. (Route 2)") # \n or <br> can be used to add a line break.
	}
	
	MysteryZone4 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area. (Cherryhill City)") # \n or <br> can be used to add a line break.
	}
	
	MysteryZone5 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area. (Cloakfall Forest)") # \n or <br> can be used to add a line break.
	}
	
	MysteryZone6 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area. (Route 3)") # \n or <br> can be used to add a line break.
	}
	
	MysteryZone7 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area. (Obsidian Peak City)") # \n or <br> can be used to add a line break.
	}
	
	MysteryZone8 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area. (Obsidian Volcano Exterior)") # \n or <br> can be used to add a line break.
	}
	
	MysteryZone9 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area. (Obsidian Volcano Interior)") # \n or <br> can be used to add a line break.
	}
	
	MysteryZone10 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area. (Route 4)") # \n or <br> can be used to add a line break.
	}
	
	MysteryZone11 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area. (Mantic City)") # \n or <br> can be used to add a line break.
	}
	
	MysteryZone12 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area. (Prehistoric Grotto)") # \n or <br> can be used to add a line break.
	}
	
	MysteryZone13 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area. (Futuristic Grotto)") # \n or <br> can be used to add a line break.
	}
	
	MysteryZone14 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area. (Route 5)") # \n or <br> can be used to add a line break.
	}
	
	MysteryZone15 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area. (Boulevard City)") # \n or <br> can be used to add a line break.
	}
	
	MysteryZone16 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area. (Route 6)") # \n or <br> can be used to add a line break.
	}
	
	MysteryZone17 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area. (Penumbra City)") # \n or <br> can be used to add a line break.
	}
	
	MysteryZone18 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area. (Stygian Woods") # \n or <br> can be used to add a line break.
	}
	
	MysteryZone19 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area. (Route 7)") # \n or <br> can be used to add a line break.
	}
	
	MysteryZone20 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area. (Apterygota City)") # \n or <br> can be used to add a line break.
	}
	
	MysteryZone21 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area. (Route 8)") # \n or <br> can be used to add a line break.
	}
	
	MysteryZone22 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area. (Bulwark City)") # \n or <br> can be used to add a line break.
	}
	
	MysteryZone23 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area. (Gemstone Cave)") # \n or <br> can be used to add a line break.
	}
	
	MysteryZone24 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area. (Route 9)") # \n or <br> can be used to add a line break.
	}
	
	MysteryZone25 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area. (Virga City)") # \n or <br> can be used to add a line break.
	}
	
	MysteryZone26 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area. (Virga Underpass)") # \n or <br> can be used to add a line break.
	}
	
	MysteryZone27 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area. (Route 10)") # \n or <br> can be used to add a line break.
	}
	
	MysteryZone28 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area. (Lucid City)") # \n or <br> can be used to add a line break.
	}
	
	MysteryZone29 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area. (Route 11)") # \n or <br> can be used to add a line break.
	}
	
	MysteryZone30 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area. (Circuit City)") # \n or <br> can be used to add a line break.
	}
	
	MysteryZone31 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area. (Route 12)") # \n or <br> can be used to add a line break.
	}
	
	MysteryZone32 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area. (Noxious City)") # \n or <br> can be used to add a line break.
	}
	
	MysteryZone33 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area. (Mt.Vile)") # \n or <br> can be used to add a line break.
	}
	
	MysteryZone34 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area. (Route 13)") # \n or <br> can be used to add a line break.
	}
	
	MysteryZone35 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area. (Sylph City)") # \n or <br> can be used to add a line break.
	}
	
	MysteryZone36 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area. (Route 14)") # \n or <br> can be used to add a line break.
	}
	
	MysteryZone37 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area. (Revenant City)") # \n or <br> can be used to add a line break.
	}
	
	MysteryZone38 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area. (Revenant Tomb)") # \n or <br> can be used to add a line break.
	}
	
	MysteryZone39 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area. (Route 15)") # \n or <br> can be used to add a line break.
	}
	
	MysteryZone40 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area. (Draco City)") # \n or <br> can be used to add a line break.
	}
	
	MysteryZone41 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area. (Draco Cave)") # \n or <br> can be used to add a line break.
	}
	
	MysteryZone42 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area. (Route 16)") # \n or <br> can be used to add a line break.
	}
	
	MysteryZone43 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area. (Iron City)") # \n or <br> can be used to add a line break.
	}
	
	MysteryZone44 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area. (Route 17)") # \n or <br> can be used to add a line break.
	}
	
	MysteryZone45 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area. (Crystal City)") # \n or <br> can be used to add a line break.
	}
	
	MysteryZone46 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area. (Crystal Lake)") # \n or <br> can be used to add a line break.
	}
	
	MysteryZone47 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area. (Sub Zero Islands)") # \n or <br> can be used to add a line break.
	}
	
	MysteryZone48 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area. (Route 18)") # \n or <br> can be used to add a line break.
	}
	
	MysteryZone49 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area. (Stratos City)") # \n or <br> can be used to add a line break.
	}
	
	MysteryZone50 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area. (Stratos Horizon)") # \n or <br> can be used to add a line break.
	}
	
	MysteryZone51 = { # Name must be the same as the point entry in town_map.txt
		description: _INTL("Press [C] Again to view Wild Encounters in this area. (Peninsula of Mastery)") # \n or <br> can be used to add a line break.
	}
end
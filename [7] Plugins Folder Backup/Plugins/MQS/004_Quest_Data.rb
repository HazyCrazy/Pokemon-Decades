module QuestModule
  
  # You don't actually need to add any information, but the respective fields in the UI will be blank or "???"
  # I included this here mostly as an example of what not to do, but also to show it's a thing that exists
  Quest0 = {
  
  }
  
  # Here's the simplest example of a single-stage quest with everything specified
  Quest1 = {
    :ID => "1",
    :Name => "Introductions",
    :QuestGiver => "Little Boy",
    :Stage1 => "Look for clues.",
    :Location1 => "Lappet Town",
    :QuestDescription => "Some wild Pokémon stole a little boy's favourite toy. Find those troublemakers and help him get it back.",
    :RewardString => "Something shiny!"
  }
  
  # Here's an extension of the above that includes multiple stages
  Quest2 = {
    :ID => "2",
    :Name => "Introductions",
    :QuestGiver => "Little Boy",
    :Stage1 => "Look for clues.",
    :Stage2 => "Follow the trail.",
    :Stage3 => "Catch the troublemakers!",
    :Location1 => "Lappet Town",
    :Location2 => "Viridian Forest",
    :Location3 => "Route 3",
	:StageLabel1 => "1",
	:StageLabel2 => "2",
    :QuestDescription => "Some wild Pokémon stole a little boy's favourite toy. Find those troublemakers and help him get it back.",
    :RewardString => "Something shiny!"
  }
  
  # Here's an example of a quest with lots of stages that also doesn't have a stage location defined for every stage
  Quest3 = {
    :ID => "3",
    :Name => "Last-minute chores",
    :QuestGiver => "Grandma",
    :Stage1 => "A",
    :Stage2 => "B",
    :Stage3 => "C",
    :Stage4 => "D",
    :Stage5 => "E",
    :Stage6 => "F",
    :Stage7 => "G",
    :Stage8 => "H",
    :Stage9 => "I",
    :Stage10 => "J",
    :Stage11 => "K",
    :Stage12 => "L",
    :Location1 => "nil",
    :Location2 => "nil",
    :Location3 => "Dewford Town",
    :QuestDescription => "Isn't the alphabet longer than this?",
    :RewardString => "Chicken soup!"
  }
  
  # Here's an example of not defining the quest giver and reward text
  Quest4 = {
    :ID => "4",
    :Name => "A new beginning",
    :QuestGiver => "nil",
    :Stage1 => "Turning over a new leaf... literally!",
    :Stage2 => "Help your neighbours.",
    :Location1 => "Milky Way",
    :Location2 => "nil",
    :QuestDescription => "You crash landed on an alien planet. There are other humans here and they look hungry...",
    :RewardString => "nil"
  }
  
  # Other random examples you can look at if you want to fill out the UI and check out the page scrolling
  Quest5 = {
    :ID => "5",
    :Name => "All of my friends",
    :QuestGiver => "Barry",
    :Stage1 => "Meet your friends near Acuity Lake.",
    :QuestDescription => "Barry told me that he saw something cool at Acuity Lake and that I should go see. I hope it's not another trick.",
    :RewardString => "You win nothing for giving in to peer pressure."
  }
  
  Quest6 = {
    :ID => "6",
    :Name => "The journey begins",
    :QuestGiver => "Professor Oak",
    :Stage1 => "Deliver the parcel to the Pokémon Mart in Viridian City.",
    :Stage2 => "Return to the Professor.",
    :Location1 => "Viridian City",
    :Location2 => "nil",
    :QuestDescription => "The Professor has entrusted me with an important delivery for the Viridian City Pokémon Mart. This is my first task, best not mess it up!",
    :RewardString => "nil"
  }
  
  Quest7 = {
    :ID => "7",
    :Name => "Close encounters of the... first kind?",
    :QuestGiver => "nil",
    :Stage1 => "Make contact with the strange creatures.",
    :Location1 => "Rock Tunnel",
    :QuestDescription => "A sudden burst of light, and then...! What are you?",
    :RewardString => "A possible probing."
  }
  
  Quest8 = {
    :ID => "8",
    :Name => "These boots were made for walking",
    :QuestGiver => "Musician #1",
    :Stage1 => "Listen to the musician's, uhh, music.",
    :Stage2 => "Find the source of the power outage.",
    :Location1 => "nil",
    :Location2 => "Celadon City Sewers",
    :QuestDescription => "A musician was feeling down because he thinks no one likes his music. I should help him drum up some business."
  }
  
  Quest9 = {
    :ID => "9",
    :Name => "Got any grapes?",
    :QuestGiver => "Duck",
    :Stage1 => "Listen to The Duck Song.",
    :Stage2 => "Try not to sing it all day.",
    :Location1 => "YouTube",
    :QuestDescription => "Let's try to revive old memes by listening to this funny song about a duck wanting grapes.",
    :RewardString => "A loss of braincells. Hurray!"
  }
  
  Quest10 = {
    :ID => "10",
    :Name => "Singing in the rain",
    :QuestGiver => "Some old dude",
    :Stage1 => "I've run out of things to write.",
    :Stage2 => "If you're reading this, I hope you have a great day!",
    :Location1 => "Somewhere prone to rain?",
    :QuestDescription => "Whatever you want it to be.",
    :RewardString => "Wet clothes."
  }
  
  Quest11 = {
    :ID => "11",
    :Name => "When is this list going to end?",
    :QuestGiver => "Me",
    :Stage1 => "When IS this list going to end?",
    :Stage2 => "123",
    :Stage3 => "456",
    :Stage4 => "789",
    :QuestDescription => "I'm losing my sanity.",
    :RewardString => "nil"
  }
  
  Quest12 = {
    :ID => "12",
    :Name => "The laaast melon",
    :QuestGiver => "Some stupid dodo",
    :Stage1 => "Fight for the last of the food.",
    :Stage2 => "Don't die.",
    :Location1 => "A volcano/cliff thing?",
    :Location2 => "Good advice for life.",
    :QuestDescription => "Tea and biscuits, anyone?",
    :RewardString => "Food, glorious food!"
  }
  
  # Story Mode Quests
  CherryhillCityQuest1 = {
	:ID => "13",
    :Name => "Trouble in The Woods",
    :QuestGiver => "Gardener Woman, Cherryhill City",
    :Stage1 => "Investigate Cloakfall Forest",
    :Location1 => "Cherryhill City",
    :QuestDescription => "An trio of troublesome Pokémon have made it dangerous for Cherryhill City's Gardener to gather fertilizer material. Find and best the trio in battle to make them leave Cloakfall Forest. (Cloakfall Forest is East of Cherryhill City)",
    :RewardString => "A unique Grass Type Pokémon"
  }
  
  Route1Quest2 = {
	:ID => "14",
    :Name => "Underground Trouble",
    :QuestGiver => "Ruin Maniac, Route 1",
    :Stage1 => "Investigate Route 1's Underground",
    :Location1 => "Route 1",
    :QuestDescription => "An trio of troublesome Pokémon have made it dangerous to delve into Route 1's underground caves. Find and best the trio in battle to make them leave Route 1's underground. (The underground is near the Ruin Maniac's house.)",
    :RewardString => "A mascot Pokémon"
  }
  
  ShimmerCoastCityQuest3 = {
	:ID => "15",
    :Name => "Lighthouse Trouble",
    :QuestGiver => "Lady, Shimmer Coast City",
    :Stage1 => "Investigate the Shimmer Lighthouse",
    :Location1 => "Shimmer Coast City",
    :QuestDescription => "An trio of troublesome Pokémon are obstructing maintenance of Shimmer Coast's Lighthouse. Find and best the trio in battle to make them leave. (The lighthouse is west from the Pokémon Center)",
    :RewardString => "A unique Water Type Pokémon"
  }
  
  ScatterFloodIslandsQuest4 = {
	:ID => "16",
    :Name => "Scattered Trouble",
    :QuestGiver => "Swimmer Woman, Scatter Flood Islands",
    :Stage1 => "Defeat the Troublesome Trio",
    :Location1 => "Scatter Flood Islands",
    :QuestDescription => "An trio of troublesome Pokémon are polluting the waters of the Scatter Flood Islands. Best the trio in battle to make them leave. (The trio are north from the sailor's ship)",
    :RewardString => "A colourful rock Pokémon"
  }
  
  ObsidianPeakCityQuest5 = {
	:ID => "17",
    :Name => "Dormant Trouble",
    :QuestGiver => "Volcano Caretaker, Obsidian Peak",
    :Stage1 => "Investigate Obsidian Volcano",
    :Location1 => "Obsidian Volcano Exterior",
    :QuestDescription => "An trio of troublesome Pokémon are harming the nearby Volcano's stability. Best the trio in battle to make them leave. (The trio are inside Obsidan Volcano, east from Obsidan Peak City.",
    :RewardString => "A unique Fire Type Pokémon"
  }
  
  ManticCityQuest6 = {
	:ID => "18",
    :Name => "Timeline Trouble",
    :QuestGiver => "Medium Woman, Mantic City",
    :Stage1 => "Investigate the timeline grottos",
    :Location1 => "Timeline Grottos",
    :QuestDescription => "2 trios of troublesome Pokémon are harming the timeline stability of Mantic City's grottos. Best the two trios in their respective grottos to make them leave. (one trio is in the Prehistoric Grotto, the other is in the Futuristic Grotto)",
    :RewardString => "A unique Psychic Type Pokémon"
  }
  
  BoulevardCityQuest7 = {
	:ID => "19",
    :Name => "Greedy Trouble",
    :QuestGiver => "Gentleman, Boulevard City",
    :Stage1 => "Investigate Route 5's cave",
    :Location1 => "Route 5",
    :QuestDescription => "An trio of troublesome Pokémon have robbed food and pocessions from people in Boulevard City. Best the trio in battle to make them stop. (The trio are north of Boulevard City's East Gatehouse.)",
    :RewardString => "A unique Fighting Type Pokémon"
  }
  
  PenumbraCityQuest8 = {
	:ID => "20",
    :Name => "Murderous Trouble",
    :QuestGiver => "Tourist, Penumbra City",
    :Stage1 => "Investigate Stygian Cave",
    :Location1 => "Stygian Woods",
    :QuestDescription => "There has been rumors of a trio of troublesome Pokémon who are murdering people who explore the depths of Stygian Cave. Investigate the cave to see if a trio need to be stopped. (The cave is west of Penumbra City's West Gatehouse.)",
    :RewardString => "A unique Dark Type Pokémon"
  }
  
  ApterygotaCityQuest9 = {
	:ID => "21",
    :Name => "Infested Trouble",
    :QuestGiver => "Tourist, Apterygota City",
    :Stage1 => "Investigate The Nest",
    :Location1 => "Apterygota Nest",
    :QuestDescription => "An trio of troublesome Pokémon are disturbing the larve and eggs of Apterygota's underground nest. Best the trio in battle to make them stop. (The nest is east of Apterygota City's Gym.)",
    :RewardString => "A unique Bug Type Pokémon"
  }
  
  BulwarkCityQuest10 = {
	:ID => "22",
    :Name => "Excavation Trouble",
    :QuestGiver => "Ruin Maniac, Bulwark City",
    :Stage1 => "Investigate Gemstone Cave",
    :Location1 => "Gemstone Cave",
    :QuestDescription => "An trio of troublesome Pokémon are breaking apart the precious gemstones of Gemstone Cave. Best the trio in battle to make them leave. (Gemstone Cave is east of Bulwark City's Gym.)",
    :RewardString => "A unique Rock Type Pokémon"
  }
  
  VirgaCityQuest11 = {
	:ID => "23",
    :Name => "Buried Trouble",
    :QuestGiver => "Worker, Virga City",
    :Stage1 => "Investigate Virga Underpass",
    :Location1 => "Virga Underpass",
    :QuestDescription => "An trio of troublesome Pokémon are collapsing Virga's Underpass. Best the trio in battle to make them leave. (Virga Underpass is north west of of Virga City's Pokemon Center.)",
    :RewardString => "A unique Ground Type Pokémon"
  }
  
  LucidCityQuest12 = {
	:ID => "24",
    :Name => "Climate Trouble",
    :QuestGiver => "Pokemon Ranger Man, Lucid City",
    :Stage1 => "Investigate The Weather Station",
    :Location1 => "Weather Station",
    :QuestDescription => "An trio of troublesome Pokémon are disrupting the Safari Zone's weather conditions. Best the trio in battle to make them leave. (The Weather Station is North from the Pokemon Center.)",
    :RewardString => "A unique Normal Type Pokémon"
  }
  
  CircuitCityQuest13 = {
	:ID => "25",
    :Name => "Blackout Trouble",
    :QuestGiver => "Crush Girl, Circuit City",
    :Stage1 => "Investigate Circuit Factory",
    :Location1 => "Circuit Factory",
    :QuestDescription => "An trio of troublesome Pokémon are causing blackouts. Best the trio in battle to make them leave. (Circuit Factory is north from the city's center point)",
    :RewardString => "A unique Electric Type Pokémon"
  }
  
  NoxiousCityQuest14 = {
	:ID => "26",
    :Name => "Purifying Trouble",
    :QuestGiver => "Juggler, Noxious City",
    :Stage1 => "Investigate Mt. Vile",
    :Location1 => "Mt. Vile",
    :QuestDescription => "An trio of troublesome Pokémon are making Mt.Vile's water non corrosive. Best the trio in battle to make them leave. (Mt.Vile is East from the Noxious City's Gym.)",
    :RewardString => "A unique Poison Type Pokémon"
  }
  
  SylphCityQuest15 = {
	:ID => "27",
    :Name => "Bullying Trouble",
    :QuestGiver => "Beauty, Sylph City",
    :Stage1 => "Investigate Sylph Playhouse",
    :Location1 => "Sylph Playhouse",
    :QuestDescription => "An trio of troublesome Pokémon are bullying the Pokemon in the playhouse. Best the trio in battle to make them leave. (The Playhouse is north from the city's center point.)",
    :RewardString => "A unique Fairy Type Pokémon"
  }
  
  RevenantCityQuest16 = {
	:ID => "28",
    :Name => "Disturbance Trouble",
    :QuestGiver => "Scientist, Revenant City",
    :Stage1 => "Investigate Revenant Tomb",
    :Location1 => "Revenant Tomb",
    :QuestDescription => "An trio of troublesome Pokémon are reviving dead spirits. Best the trio in battle to make them leave. (The Tomb is south from the city's center point.)",
    :RewardString => "A unique Ghost Type Pokémon"
  }
  
  DracoCityQuest17 = {
	:ID => "29",
    :Name => "Mighty Trouble",
    :QuestGiver => "Fun Old Lady, Draco City",
    :Stage1 => "Investigate Draco Cave",
    :Location1 => "Draco Cave",
    :QuestDescription => "An trio of troublesome Pokémon have horded Draco City's resources. Best the trio in battle to make them leave. (The cave is north from the city's center point.)",
    :RewardString => "A unique Dragon Type Pokémon"
  }
  
  IronCityQuest18 = {
	:ID => "30",
    :Name => "Manufacturing Trouble",
    :QuestGiver => "Janitor, Iron City",
    :Stage1 => "Investigate Iron Complex",
    :Location1 => "Iron Complex",
    :QuestDescription => "An trio of troublesome Pokémon are breaking Iron City's machines. Best the trio in battle to make them leave. (The Complex is north from the city's center point.)",
    :RewardString => "A unique Steel Type Pokémon"
  }
  
  CrystalCityQuest19 = {
	:ID => "31",
    :Name => "Sub Zero Trouble",
    :QuestGiver => "Clown, Crystal City",
    :Stage1 => "Investigate Sub Zero Islands",
    :Location1 => "Sub Zero Islands",
    :QuestDescription => "An trio of troublesome Pokémon are polluting the waters of the Sub Zero Islands. Best the trio in battle to make them leave. (Go west to Crystal Lake, then south to sail to the Islands.)",
    :RewardString => "A unique Ice Type Pokémon"
  }
  
  StratosCityQuest20 = {
	:ID => "32",
    :Name => "Pollution Trouble",
    :QuestGiver => "Bird Keeper, Stratos City",
    :Stage1 => "Investigate Stratos Horizon",
    :Location1 => "Stratos Horizon",
    :QuestDescription => "An trio of troublesome Pokémon are polluting the skies of Stratos Horizon. Best the trio in battle to make them leave. (Stratos Horizon is north from the city's center point.)",
    :RewardString => "A unique Flying Type Pokémon"
  }

end

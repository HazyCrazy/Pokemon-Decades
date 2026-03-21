module Settings
    #====================================================================================
    #=============================== Tip Cards Settings =================================
    #====================================================================================
    
        #--------------------------------------------------------------------------------
        #  Set the default background for tip cards.
        #  The files are located in Graphics/Pictures/Tip Cards
        #--------------------------------------------------------------------------------	
        TIP_CARDS_DEFAULT_BG            = "bg"

        #--------------------------------------------------------------------------------
        #  If set to true, if only one group is shown when calling pbRevisitTipCardsGrouped,
        #  the group header will still appear. Otherwise, the header won't appear.
        #--------------------------------------------------------------------------------	
        TIP_CARDS_SINGLE_GROUP_SHOW_HEADER = true

        #--------------------------------------------------------------------------------
        #  If set to true, when the player uses the SPECIAL control, a list of all
        #  groups available to view will appear for the player to jump to one.
        #--------------------------------------------------------------------------------	
        TIP_CARDS_GROUP_LIST = true

        #--------------------------------------------------------------------------------
        #  Set the default text colors
        #--------------------------------------------------------------------------------	
        #TIP_CARDS_TEXT_MAIN_COLOR       = Color.new(80, 80, 88)
        #TIP_CARDS_TEXT_SHADOW_COLOR     = Color.new(160, 160, 168)
		TIP_CARDS_TEXT_MAIN_COLOR       = Color.new(248, 248, 248)
        TIP_CARDS_TEXT_SHADOW_COLOR     = Color.new(104, 104, 104)

        #--------------------------------------------------------------------------------
        #  Set the sound effect to play when showing, dismissing, and switching tip cards.
        #  For TIP_CARDS_SWITCH_SE, set to nil to use the default cursor sound effect.
        #--------------------------------------------------------------------------------	
        TIP_CARDS_SHOW_SE               = "GUI menu open"
        TIP_CARDS_DISMISS_SE            = "GUI menu close"
        TIP_CARDS_SWITCH_SE             = nil

        #--------------------------------------------------------------------------------
        #  Define your tips in this hash. The :EXAMPLE describes what some of the 
        #  parameters do.
        #--------------------------------------------------------------------------------	
        TIP_CARDS_CONFIGURATION = {
            :EXAMPLE => { # ID of the tip
                    # Required Settings
                    :Title => _INTL("Example Tip"),
                    :Text => _INTL("This is the text of the tip. You can include formatting."),
                    # Optional Settings
                    :Image => "example", # An image located in Graphics/Pictures/Tip Cards/Images
                    :ImagePosition => :Top, # Set to :Top, :Bottom, :Left, or :Right.
                        # If not defined, it will place wider images to :Top, and taller images to :Left.
                    :Background => "bg2", # A replacement background image located in Graphics/Pictures/Tip Cards
                    :YAdjustment => 0, # Adjust the vertical spacing of the tip's text (in pixels)
                    :HideRevisit => true # Set to true if you don't want the player to see the tip again when revisiting seen tips.
            },
            :CATCH => {
                :Title => _INTL("Catching Pokémon"),
                :Text => _INTL("This is the text of the tip. You catch Pokémon by throwing a <c2=0999367C><b>Poké Ball</b></c2> at them."),
                :Image => "catch",
                :Background => "bg2"
            },
            :CATCH2 => {
                :Title => _INTL("Catching Pokémon"),
                :Text => _INTL("This is the text of the tip with a bottom picture. You catch Pokémon by throwing a <c2=0999367C><b>Poké Ball</b></c2> at them."),
                :Image => "catch",
                :ImagePosition => :Bottom,
                :Background => "bg2"
            },
            :ITEMS => {
                :Title => _INTL("Items"),
                :Text => _INTL("This is the text of the other tip. You may find items lying around."),
                :Image => "items",
                :YAdjustment => 64
            },
            :ITEMS2 => {
                :Title => _INTL("Items"),
                :Text => _INTL("This is the text of the other tip with a right picture. You may find items lying around."),
                :Image => "items",
                :ImagePosition => :Right,
                :YAdjustment => 64
            },
            :BOOK1PAGE1 => {
                :Title => _INTL("Page 1"),
                :Text => _INTL("<al>This is the first page. <br>Introducing: all the characters!</al>"),
                :Background => "bg_book"
            },
            :BOOK1PAGE2 => {
                :Title => _INTL("Page 2"),
                :Text => _INTL("<al>This is the second page. <br>Introducing: the vilain!</al>"),
                :Background => "bg_book"
            },
            :BOOK1PAGE3 => {
                :Title => _INTL("Page 3"),
                :Text => _INTL("<al>This is the third page. <br>It's conflict time!</al>"),
                :Background => "bg_book"
            },
            :BOOK1PAGE4 => {
                :Title => _INTL("Page 4"),
                :Text => _INTL("<al>This is the final page. <br>It's resolution time!</al>"),
                :Background => "bg_book"
            },
			:FEATURES1 => {
                :Title => _INTL("Following Pokémon"),
                :Text => _INTL("Press the A Key to toggle making Pokémon follow you. Press the S Key to change the first Pokémon you send out in Battle."),
                :Background => "bg_book2"
            },
			:FEATURES2 => {
                :Title => _INTL("Relearning a Pokémon's entire Learnset"),
                :Text => _INTL("In the Summary Screen, on the Info Page, Press the Spacebar and select Relearn Moves. Any Pokémon can relearn <c2=0999367C>the entire history of it's Learnset, Gen 1 to Gen 9.</c2> No Pokémon has a Level Up Learnset, you have to use the Move Relearner."),
                :Background => "bg_book2"
            },
			:FEATURES3 => {
                :Title => _INTL("EV Allowcating"),
                :Text => _INTL("In the Summary Screen, on the Skills Page, Press the Spacebar to edit EV's. <c2=0999367C>You cannot gain EV's from Battles of any kind. You have to use the EV Allowcator to fully train your Pokémon.</c2> Attack and Sp.Atk EV's are linked together."),
                :Background => "bg_book2"
            },
			:FEATURES4 => {
                :Title => _INTL("IV Editing and Trick Room Presets"),
                :Text => _INTL("In the Party Screen, Press the Spacebar and choose Change IVs. <c2=0999367C>All Pokémon will have Perfect 31 IV's.</c2> In the Summary Screen, on the Info Page, Press the Spacebar and select an IV Preset. Useful for Trick Room, Foul Play and Sparkly Swirl."),
                :Background => "bg_book2"
            },
			:FEATURES5 => {
                :Title => _INTL("Trainer Suite"),
				:Text => _INTL("As part of your Trainer Suite, <c2=0999367C>The Exp All Toggle is included in the Charms Case, and on by default.</c2> You also have other tools such as Shiny Toggles, Repel Toggles, Nature Modifiers, Level Candies and more."),
                :Background => "bg_book2"
            },
			:FEATURES6 => {
                :Title => _INTL("Where are my Pokémon?"),
				:Text => _INTL("In the Party Screen, Press the D Key to access your PSS. (Pokémon Storage System) <c2=0999367C>Form Traders in any Pokémon Center can trade back around any specfic Regional or obscure Form/Formes.</c2>"),
                :Background => "bg_book2"
            },
			:FEATURES7 => {
                :Title => _INTL("Soft Reset/Change Controls"),
				:Text => _INTL("After you have saved your game, press the F12 Key to Soft Reset. This will take you back to the Main Menu, without quitting the game. In the Pause Menu, select Controls to change assigned Keyboard/Gamepad Inputs."),
                :Background => "bg_book2"
            },
			:FEATURES8 => {
                :Title => _INTL("Type Matchup Lookup"),
				:Text => _INTL("During a battle, Press the T Key to inspect the Type Matchups of all Pokémon on the battlefield."),
                :Background => "bg_book2"
            },
			:FEATURES9 => {
                :Title => _INTL("Battle Turn Tips"),
				:Text => _INTL("In battles, the Pokémon with the higher speed stat uses their move first. Some moves, such as Tailwind modify this. Speed ties are decided randomly. Trick Room makes the Pokémon with the slower speed stat use their move first."),
                :Background => "bg_book2"
            },
			:FEATURES10 => {
                :Title => _INTL("Same Type Attack Bonus (STAB)"),
				:Text => _INTL("Pokémon deal 50% more damage with moves that share a type with them. Pikachu (Electric) deals 50% more damage with an Electric move than a Grass move."),
                :Background => "bg_book2"
            },
			:FEATURES11 => {
                :Title => _INTL("NTAW STAB MFT"),
				:Text => _INTL("Pokémon who are not Normal type, who use a Normal type move, will convert that move into their Primary/Tera type. A Nidoking (Poison/Ground) using Tri Attack, will change Tri Attack into a Poison type move. A Tera Ice Nidoking using Tri Attack, will change Tri Attack into a Ice type move."),
                :Background => "bg_book2"
            },
			:FEATURES12 => {
                :Title => _INTL("Status Condition Changes"),
				:Text => _INTL("Paralysis will only cut Speed in half, and will never fully paralyse. Frostbite is the Sp.Atk version of Burn, and replaces Freeze. Drowzy replaces Sleep, and a Drowzy Pokémon has a 50% to doze off. Outside of these changes, this game uses the offical Status Conditions."),
                :Background => "bg_book2"
            },
			:FEATURES13 => {
                :Title => _INTL("Weather Changes"),
				:Text => _INTL("Hailstorm combines Snow and Hail, giving Ice types a 50% Defense boost, and non Ice, Fire and Fighting types take damage from the Hailstorm every turn. Outside of these changes, this game uses the offical Weathers."),
                :Background => "bg_book2"
            },
			:FEATURES14 => {
                :Title => _INTL("Universal Type Moves"),
				:Text => _INTL("Every Pokémon has universal Moves for any primary or secondary type they are. To view the Universal Move Types, view the Folder Plugins/Ultimate Move Tutor/move_tutor.rb"),
                :Background => "bg_book2"
            },
			:FEATURES15 => {
                :Title => _INTL("Battle Gimmicks"),
				:Text => _INTL("In battle, press the Z Key to toggle Mega Evolution, Z-Moves, Dynamax or Tera. You need to use Dynamax Inhibitors to not have it take over changing your Pokémon's Tera type. When Dynamax is used up, a Pokémon can Tera straight after."),
                :Background => "bg_book2"
            },
			:FEATURES16 => {
                :Title => _INTL("Z-Status Moves + NTAW STAB MFT"),
				:Text => _INTL("For the effect of a Z-Status move to work, the Pokémon's primary Type must match the Type of the Z-Crystal used."),
                :Background => "bg_book2"
            },
			:FEATURES17 => {
                :Title => _INTL("100% Wild Battle Flee Rate"),
				:Text => _INTL("You can always escape any wild battle, no matter how slow your Pokémon are. You can still be trapped in battle."),
                :Background => "bg_book2"
            },
			:LEVELSCALE1 => {
                :Title => _INTL("Story Mode Showdown Mode"),
				:Text => _INTL("The Levels of the Player and Opponents are 1:1, meaning any battle the player has, they will be up against Opponents who match the player's Levels. Seperate from Battle Mode. The default experience the game is designed around."),
                :Background => "bg_book2"
            },
			:LEVELSCALE2 => {
                :Title => _INTL("Hard Mode"),
				:Text => _INTL("The Levels of Trainer and Wild Pokémon are 2 Levels higher than the player."),
                :Background => "bg_book2"
            },
			:LEVELSCALE3 => {
                :Title => _INTL("Medium Mode"),
				:Text => _INTL("The Levels of Trainer and Wild Pokémon are a random increase of 2 Levels."),
                :Background => "bg_book2"
            },
			:LEVELSCALE4 => {
                :Title => _INTL("Easy Mode"),
				:Text => _INTL("The Levels of Trainer and Wild Pokémon are a random variation of 3 lower or higher Levels."),
                :Background => "bg_book2"
            },
			:LEVELSCALE5 => {
                :Title => _INTL("Stock Mode"),
				:Text => _INTL("The Levels of Trainer and Wild Pokémon are a random variation of 2 lower Levels, or 3 higher Levels."),
                :Background => "bg_book2"
            },
			:LEVELSCALE6 => {
                :Title => _INTL("Trivial Mode"),
				:Text => _INTL("The Levels of Trainer and Wild Pokémon will always be Level 1. Exists to assist players getting past sections they don't care about."),
                :Background => "bg_book2"
            },
			:LEVELSCALE7 => {
                :Title => _INTL("Battle Mode Showdown Mode"),
				:Text => _INTL("The Levels of the Opponents are set to a battle format, Lvl.50 being the default. To change the battle format, go to Battle Paradise at any Pokémon Center, and talk to the Nurse. Seperate from Story Mode."),
                :Background => "bg_book2"
            },
			:ENCOUNTERNUMBERS => {
                :Title => _INTL("Encounter Version Numbers"),
				:Text => _INTL("Every number after 0 is Pokémon native to the Generation number of the version. Version 1 is Kanto native Pokémon, Version 5 is Unova native Pokémon, Version 9 is Paldea native Pokémon."),
                :Background => "bg_book2"
            },
			:ENCOUNTERNUMBERS2 => {
                :Title => _INTL("Region Number Listings"),
				:Text => _INTL("<c2=0999367C>Version 1:</c2> Kanto <c2=0999367C>Version 2:</c2> Johto <c2=0999367C>Version 3:</c2> Hoenn <c2=0999367C>Version 4:</c2> Sinnoh <c2=0999367C>Version 5:</c2> Unova <c2=0999367C>Version 6:</c2> Kalos <c2=0999367C>Version 7:</c2> Alola <c2=0999367C>Version 8:</c2> Galar <c2=0999367C>Version 9:</c2> Paldea"),
                :Background => "bg_book2"
            },
			:DEVNAV => {
                :Title => _INTL("Level Scaling + Dex Nav"),
				:Text => _INTL("The Dex Nav ignores a searched Pokémon evolving via Level Scaling. You can pair the Dex Nav with the Repel Toggle to have the exact Pokémon you want for a Nuzlocke."),
                :Background => "bg_book2"
            },
			:DEVNAV2 => {
                :Title => _INTL("Paradox Encounters"),
				:Text => _INTL("You must use the Dex Nav's Search Function to encounter Paradox Pokémon. This is because the Dex Nav ignores a searched Pokémon evolving via Level Scaling. Wild encounters here without the Dex Nav search will be the present timeline Pokémon."),
                :Background => "bg_book2"
            },
			:STARTERS1 => {
                :Title => _INTL("VGC Starters"),
				:Text => _INTL("This consists of 500+ Pokémon who are chosen to have powerful competitive moves. To view what moves VGC Starters can learn, view the Folder Plugins/Ultimate Move Tutor/move_tutor.rb (UStarterMoves, Line 124"),
                :Background => "bg_book2"
            },
			:FIELDMOVES1 => {
                :Title => _INTL("HM/Field Moves"),
				:Text => _INTL("Type Emeralds are not required for Field Moves such as Surf. A Pokémon is not required to have a Field Move in it's Moveset. It only needs to be able to learn a Field Move. (Universal Moves must be taught to a Pokémon if it cannot naturally learn it, such as Flash + Alolan Golem)"),
                :Background => "bg_book2"
            },
			:FIELDMOVES2 => {
                :Title => _INTL("Encounter Objects"),
				:Text => _INTL("Environment objects such as <c2=0999367C>TV's in Gatehouses, Small Trees, Cracked Rocks and Trash Bins</c2> can have Pokémon in them."),
                :Background => "bg_book2"
            },
			:GAMEGOAL1 => {
                :Title => _INTL("Your Goal"),
				:Text => _INTL("Obtain all 18 Type Emeralds, by defeating Beatha's Type Masters. With all Emeralds, go to the Peninsula of Mastery, west of Stratos City."),
				:Image => "gyms",
                :ImagePosition => :Top,
                :Background => "bg_book2"
            },
			:GAMEGOAL2 => {
                :Title => _INTL("Quests can be repeated"),
				:Text => _INTL("All quests can be replayed again. You can also lie straight up to a quest giver, to get the reward. This is intended by design."),
                :Background => "bg_book2"
            },
			:MECHANICS1 => {
                :Title => _INTL("Light Ball Changes"),
				:Text => _INTL("When held, can Paralyze like how the Toxic and Flame Orb work. Power boosts for Electric Rodents, such as Pawmi, Emolga and Morpeko range from 30% to 50%. Pikachu and Pawmo get a 100% power boost."),
                :Background => "bg_book2"
            },
			:MECHANICS2 => {
                :Title => _INTL("Natural Gift Changes"),
				:Text => _INTL("Natural Gift no longer consumes a held berry item when used. Berry Item Power varies from 80 to 110."),
                :Background => "bg_book2"
            },
			:MECHANICS3 => {
                :Title => _INTL("Hazard Changes"),
				:Text => _INTL("Stealth Rock is now Stellar Rock. All Pokémon Types take 12.5% damage on switch in. Steel Types absorb Stellar Rock on switch in. Bug Types absorb Spikes on switch in. All other Hazard interactions are the same as the offical games."),
                :Background => "bg_book2"
            },
			:MECHANICS4 => {
                :Title => _INTL("How to Skip Battles"),
				:Text => _INTL("Hold down the [CTRL] Key before starting any battle to go straight to the winning outcome of the battle, without engaging in it. You do not need to be in Debug Mode to do this."),
                :Background => "bg_book2"
            },
			:MECHANICS5 => {
                :Title => _INTL("Make any Poké Ball catch any Pokémon"),
				:Text => _INTL("Hold down the [CTRL] Key before using a Poké Ball to give any Poké Ball the effects of the Master Ball. You do not need to be in Debug Mode to do this."),
                :Background => "bg_book2"
            },
			:MECHANICS6 => {
                :Title => _INTL("Light Ball Rodent Boosts (1/2)"),
				:Text => _INTL("Pichu/Pawmi: 30% Pikachu/Pawmo: 100% (Base, Cosplay and Cap Forms) Raichu/Pawmot: 50%"),
                :Background => "bg_book2"
            },
			:MECHANICS7 => {
                :Title => _INTL("Light Ball Rodent Boosts (2/2)"),
				:Text => _INTL("Plusle/Minun/Pachirisu/Emolga/Dedenne/Togedemaru/Morpeko: 50%"),
                :Background => "bg_book2"
            },
			:MECHANICS8 => {
                :Title => _INTL("Pulse and Flying Type Moves"),
				:Text => _INTL("All Flying Type moves can hit anyone on the field in a Triple Battle. Pulse moves such as Heal Pulse can hit anyone on the field in a Triple Battle."),
                :Background => "bg_book2"
            },
			:EXPGAIN1 => {
                :Title => _INTL("Exp Gain Changes"),
				:Text => _INTL("Wild Pokémon battles give 50% more Exp. (The effect of 1 Lucky Egg, without using a Held Item) Trainer battles give 100% more Exp (The effect of 2 Lucky Eggs, without using a Held Item)"),
                :Background => "bg_book2"
            },
			:LEVELCAPS1 => {
                :Title => _INTL("Level Caps"),
				:Text => _INTL("This games does not enforce Level Caps. The Level Cap begins at Lvl.10. Every Type Emerald, in any order you obtain adds +5 to the Level Cap. Use the Level Candies to manually set Levels. With 18 Type Emeralds, the Level Cap reaches Lvl.100."),
                :Background => "bg_book2"
            },
			:LEVELCAPS2 => {
                :Title => _INTL("Progress Level Caps (1/2)"),
				:Text => _INTL("0 Emeralds: 10 1 Emeralds: 15 2 Emeralds: 20 3 Emeralds: 25 4 Emeralds: 30 5 Emeralds: 35 6 Emeralds: 40 7 Emeralds: 45 8 Emeralds: 50 9 Emeralds: 55"),
                :Background => "bg_book2"
            },
			:LEVELCAPS3 => {
                :Title => _INTL("Progress Level Caps (2/2)"),
				:Text => _INTL("10 Emeralds: 60 11 Emeralds: 65 12 Emeralds: 70 13 Emeralds: 75 14 Emeralds: 80 15 Emeralds: 85 16 Emeralds: 90 17 Emeralds: 95 18 Emeralds: 100"),
                :Background => "bg_book2"
            },
			:POWERLEVEL1 => {
                :Title => _INTL("PSS Exp Gain"),
				:Text => _INTL("When active, Pokémon in the Pokémon Storage System gain Exp in the same manner as the Exp.All. PSS Pokémon cannot Evolve when stored in the PSS. You must Evolve them manually outside the PSS. (It drags on when there's lots of Pokémon)"),
                :Background => "bg_book2"
            },
			:POWERLEVEL2 => {
                :Title => _INTL("Exp.All Inhibitor Removal"),
				:Text => _INTL("Until it's turned off, Non-Participant Pokémon gain 100% of Exp Gains from the Exp.All."),
                :Background => "bg_book2"
            },
			:POWERLEVEL3 => {
                :Title => _INTL("The Death Gong?"),
				:Text => _INTL("When active, the 50% Exp Gain penalty Non-Participant Pokémon take from the Exp.All, is gone. Until it's turned off, Non-Participant Pokémon gain 100% of Exp Gains from the Exp.All!"),
				#:Text => _INTL("When active, the Death Gong increases Exp Gain by 1000000000% (1 Billion. You have 1218 Pokémon to fully train. And you already invested the time getting their metasets up and running)"),
                :Background => "bg_book2"
            },
			:POWERLEVEL4 => {
                :Title => _INTL("Optimal Grinding Setup"),
				:Text => _INTL("Set the Exp Charm boost to 1000%. Toggle on PSS Exp Gain. Toggle off the Exp.All's inhibitor. Toggle on the Exp.All. In any Pokémon Center, talk to the Anti-Grind Trainer, choose Lvl.100 Grind."),
				#:Text => _INTL("When active, the Death Gong increases Exp Gain by 1000000000% (1 Billion. You have 1218 Pokémon to fully train. And you already invested the time getting their metasets up and running)"),
                :Background => "bg_book2"
            },
			:POWERLEVEL5 => {
                :Title => _INTL("Optimal Grinding Setup"),
				:Text => _INTL("After following these steps, you will train 1025+ Pokémon up to Lvl.100, or the Level Cap you want, in just one battle. This process takes 1 minute, after clicking New Game."),
				#:Text => _INTL("When active, the Death Gong increases Exp Gain by 1000000000% (1 Billion. You have 1218 Pokémon to fully train. And you already invested the time getting their metasets up and running)"),
                :Background => "bg_book2"
            },
			:POWERLEVEL6 => {
                :Title => _INTL("Optimal Grinding Setup"),
				:Text => _INTL("To ensure just one battle is needed, you must use Fluctuating Exp Pokémon. Only Shroomish, Makuhita, Illumise, Gulpin, Wailmer, Seviper, Corphish, Drifloon and their Evolution Lines are in this group."),
				#:Text => _INTL("When active, the Death Gong increases Exp Gain by 1000000000% (1 Billion. You have 1218 Pokémon to fully train. And you already invested the time getting their metasets up and running)"),
                :Background => "bg_book2"
            },
			:DESIGNNOTES1 => {
                :Title => _INTL("Why Level Scaling is used"),
				:Text => _INTL("The dumbest thing a Pokémon Fangame can do, is making all 1025+ Pokémon obtainable in the wild. Automatic Level Scaling's setup in Decades, means only 541 Evolution Lines need to be in the wild."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES2 => {
                :Title => _INTL("Why Level Scaling is used"),
				:Text => _INTL("Decades aimed to take the good qualities of Crystal Clear, Tectonic, Elite Redux, Ashen Frost, Reborn and Rejuvenation. And in the confines of being developed by a single person only using public resources,"),
                :Background => "bg_book2"
            },
			:DESIGNNOTES3 => {
                :Title => _INTL("Why Level Scaling is used"),
				:Text => _INTL("not repeat their mistakes or petty frustrations, in the best way he could in execution. In Metagame Level Formats, everything is set to the Level Format, making grinding a non factor in team building."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES4 => {
                :Title => _INTL("Starter Pokémon Choices"),
				:Text => _INTL("Decade's 362 First Partner Pokémon (VGC Starers) were chosen, to allow the player to decide what magical pet they like the most, and to enforce that Decade's is not in anyway a typical Reborn-Like."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES5 => {
                :Title => _INTL("Starter Pokémon Choices"),
				:Text => _INTL("Reborn-Like refers to Pokémon Fangames that take inspiration from Reborn/Rejuvenation's focus on an orginal Region Map, some form of distinct Battle Gimmick (NTAW STAB MYFT for Pokémon Decades), and diffcult high stakes battles."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES6 => {
                :Title => _INTL("Starter Pokémon Choices"),
				:Text => _INTL("The very nature of how NTAW STAB MYFT works, and that players typically get attached to their First Partner Pokémon, was the major factor in Decades commiting to it's Metagame balance changes."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES7 => {
                :Title => _INTL("Very linear, no backtracking paths"),
				:Text => _INTL("Beatha's Level Maps were made first, (The actual levels the player plays in) not the Region Map. (The 2D Map the player uses to know where they are) Pokémon fangames typically make the Region Map first, and revise it as development marches on."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES8 => {
                :Title => _INTL("Very linear, no backtracking paths"),
				:Text => _INTL("The number one priority with Story Mode, before anything else, was having a dedicated biome for every one of the 18 Pokémon Types. So the mistakes of Radical Red vomiting Monotype Pokémon into biomes and geography that make no sense, was not repeated."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES9 => {
                :Title => _INTL("Very linear, no backtracking paths"),
				:Text => _INTL("Pokémon Compact was the frame of reference for the max width and height of Level Maps. Compact's highest Width Map is 76, and the highest Height Map is 60. The small size of Decade's Level Maps, makes the workload feasible for one person."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES10 => {
                :Title => _INTL("Offline Wiki Decision"),
				:Text => _INTL("Pokémon Decade's efforts to make the Pokédex actually useful with the Pokédex Data Page, are so development time isn't wasted on an online resource that is too much and cannot be maintained by one person."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES11 => {
                :Title => _INTL("Offline Wiki Decision"),
				:Text => _INTL("Pokémon Decades will not cater to Nuzlockes audiences thay play Fangames such as Run and Bun, Emerald Kaizo, and Radical Red Hardcore Mode."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES12 => {
                :Title => _INTL("Offline Wiki Decision"),
				:Text => _INTL("The only things a Fangame developer needs to make docs for, is wild Pokémon locations, what can beat a hard boss fight and puzzle solutions. The Pokédex Data Page and Metagame Wiki Pokédex Pages do the rest."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES13 => {
                :Title => _INTL("Why IV's suck in the offical games"),
				:Text => _INTL("Naturally obtaining a Pokémon you caught, with the exact perfect IV's you need, is 1 in 887503681. (much lower than 0.0122%) These values being fully optimized are critical in the highest levels of competitive battles."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES14 => {
                :Title => _INTL("Why EV's suck in the offical games"),
				:Text => _INTL("There is no manual control of EV's from wild Pokémon, no precise way to see the values, 255 is not divisible by 4, and past offical games were forced to keep efficient EV training at the postgame, or have the casual experience be a mindless curb stomp."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES15 => {
                :Title => _INTL("Why allocation is used"),
				:Text => _INTL("Nothing competes with a 5 second 0 Atk IV preset and 256/256 Offense/Speed EV setup, for 1 Pokémon. A full team with simple EV Spreads is 30 seconds. The Allocator is worth cutting a miserable 40 hour process in Gen 9, for 1 full Pokémon Team. When you know what you are doing."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES16 => {
                :Title => _INTL("The Metagame's Sandbox"),
				:Text => _INTL("Pokémon Decades cares more about the freedom to choose however you want to craft your team, over making a futile attempt to balance a game series with 1025+ characters, 900+ Moves, 300+ Abilities, 18 Types, and 4 Distinct Battle Gimmicks."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES17 => {
                :Title => _INTL("The Metagame's Sandbox"),
				:Text => _INTL("The 500, 550, 600 Base Stat Total Standard Decades has out of the box, before applying the Basic Vanilla Gen 9 Patch, is also done to facillitate the sandbox of choosing the magical pet you like."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES18 => {
                :Title => _INTL("The Metagame's Sandbox"),
				:Text => _INTL("Decades is a game made by one person. It will never, and would fail miserably to compete with Tectonic, Eon Guardians, Reborn, Rejuvenation, and Ashen Frost. If Decades didn't care, it would have been foolish enough to make a full scale Reborn-Like."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES19 => {
                :Title => _INTL("Why one of every Pokémon"),
				:Text => _INTL("Pokémon Fangames, unlike the offical games, are not bound to the franchise's merchandise production momentum. They can choose to have one of everything, if having every Pokémon suits the Fangame's design goals."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES20 => {
                :Title => _INTL("Why one of every Pokémon"),
				:Text => _INTL("Decades cares about the sandbox of Pokémon's Metagame, and it's design approach to how the player can get one of everything allows anyone to get what they want, in anyway they want."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES21 => {
                :Title => _INTL("Why one of every Pokémon"),
				:Text => _INTL("And it sucks straight up, having to research and pray that the Pokémon you like makes the cut to be obtainable in a game. And hacking them into a Fangame, is not respecting the Fangame's design decisions."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES22 => {
                :Title => _INTL("Interior Buildings are not needed"),
				:Text => _INTL("Due to the nature of how Beatha's Level Maps were made first, to have dedicated biomes for all 18 Pokémon Types. All creative energy was exausted making an entire custom region from scratch."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES23 => {
                :Title => _INTL("Interior Buildings are not needed"),
				:Text => _INTL("Decade's quality was worse off having the lifelss empty rooms that could be mustered from the embers of creative energy lost in the process of making every Exterior Map."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES24 => {
                :Title => _INTL("Interior Buildings are not needed"),
				:Text => _INTL("The only required Interiors were the Pokémon Centers and Type Master Gyms in the end. Interiors for areas such as Shimmer Coast City's Lighthouse were cut due to them having nothing of substance."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES25 => {
                :Title => _INTL("Why Decades rebalanced every Pokémon"),
				:Text => _INTL("The Fangames Decades takes notes from, such as Tectonic and Renegade Platinum, without applying Renegade's rebalance patch, all make changes to the Pokémon. From Typings, Base Stat Totals, Abilities and Learnsets."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES26 => {
                :Title => _INTL("Why Decades rebalanced every Pokémon"),
				:Text => _INTL("Pokémon will never be a balanced game. But fangames such as Tectonic show that more can be done, to give everything a legimate role to fufill in the Metagame. Decades, by the very nature of how it's made by one person, cannot reach Tectonic's standards."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES27 => {
                :Title => _INTL("Why Decades rebalanced every Pokémon"),
				:Text => _INTL("It's a flaw of the offical games, where a Pokémon's Metagame potential, is decided by where it's obtained in the traditional linear structure. Praying for the next game to get around to fixing Pokemon such as Unown or Dedenne isn't dealing with the problem's source."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES28 => {
                :Title => _INTL("Why Decades rebalanced every Pokémon"),
				:Text => _INTL("It should be evident to anyone reading this, that my idea of Pokémon as a Role Playing game, is not what most people think of with Pokémon being a role playing game. The sandbox of it's Metagame, is the only Role Playing I can enjoy fully with Pokémon."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES29 => {
                :Title => _INTL("Why Decades didn't Elite Redux"),
				:Text => _INTL("4 Abilities all at once pushes the power level of every Pokémon too far. And I didn't want to deal with the testing nightmare of 3 Innates, and 3 configuable Abilities. On top of being an inferior clone of Elite Redux."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES30 => {
                :Title => _INTL("Why Decades didn't Elite Redux"),
				:Text => _INTL("That doesn't mean I just slapped on what suited a Pokémon and called it a day. Notes from Elite Redux, Radical Red and Techtonic were taken, and implemented into Decades in whatever feasible way I could."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES31 => {
                :Title => _INTL("Why Decades didn't Elite Redux"),
				:Text => _INTL("1 to 3 Ability choices simply isn't enough, with how much Gen 9's Metagame demands. 1 choice out of 6 Abilities fully allows for thematically suitable Abilities, and what a Pokémon requires to function in a Metagame's role."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES32 => {
                :Title => _INTL("Why Regenerating Items are used"),
				:Text => _INTL("Due to a crashing error with Arcky's Mart Plugin early in production, and the sheer amount of tools required on demand to fully train a Pokémon team, on top of Story and Battle Mode being freely selectable at any point. All this, to be done by 1 person."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES33 => {
                :Title => _INTL("Why Regenerating Items are used"),
				:Text => _INTL("The decision to use a Regenerating Trainer Suite was benefical in keeping Decade's scope under control for 1 person. The speed of Story Mode's production exceeded what I expected, because of the Regenerating Trainer Suite."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES34 => {
                :Title => _INTL("Why Regenerating Items are used"),
				:Text => _INTL("A major bottleneck in a Pokémon Fangame's development process, is Item and Pokémon Distrubutions, on top of not using Automatic Level Scaling to remove needing to use a traditional Pokémon League Gym Challenge structure."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES35 => {
                :Title => _INTL("Pokémon breeding sucks"),
				:Text => _INTL("Ultimate Move Tutor, Automatic Level Scaling, EV/IV Allocator, Form Trader and the Ability Vial exist with intent to kill the Pokémon breeding mechanic. Competitive players will PkHex a team if they are not forced to need to use the Breeding mechanic."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES36 => {
                :Title => _INTL("Pokémon breeding sucks"),
				:Text => _INTL("It's not intuitive who is in what Egg Group for hyper specfic Egg Move Chains without the Pokédex Data Page, it has a cynical eugenics execution due to how Natures and IV's work, and Gen 9's changes don't fix the fundemental problems."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES37 => {
                :Title => _INTL("Pokémon breeding sucks"),
				:Text => _INTL("The Breeding mechanic is a waste of time that can go die in a ditch. Any Fangame that is able to force this wicked witch to die, is a major selling point in my eyes. I don't give a fuck about your Fangame's story needing the Pokémon Daycare."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES38 => {
                :Title => _INTL("Why you have unlimited Poké Balls"),
				:Text => _INTL("Simply put, if you get screwed over by a game's Random Number Generator (RNG) enough times. It's just an arbitary waste of time. Customizing the Poké Ball a Pokemon is in, is better than rolling random dice for them to get in."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES39 => {
                :Title => _INTL("Why you have unlimited Poké Balls"),
				:Text => _INTL("The novelty of the thrill of finding something rare, wears off fast, when hours are burned waiting for random dice to make the rare Pokémon get in the ball after going through the hassle of making them spawn."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES40 => {
                :Title => _INTL("Why you have unlimited Poké Balls"),
				:Text => _INTL("I wasn't able to figure out how to make it, so defeating a wild Pokémon results in a 100% catch rate when you choose to catch it. The traditional catching method is a remnant of when Pokémon began on the Game Boy."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES41 => {
                :Title => _INTL("Why Level Candies and PSS Exp Gain exist"),
				:Text => _INTL("Every Fangame with a focus on diffcult battles, even Tectonic, suffers from the tedium of training every obtainable Pokémon in bulk, to have on demand responses to problems faced with solving a tough fight."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES42 => {
                :Title => _INTL("Why Level Candies and PSS Exp Gain exist"),
				:Text => _INTL("The changes to the Exp.All, Exp.Charm and the Pokémon Storage System, (PSS) are done, because the feature being active with no way to turn it off when the specfic Item is in the bag, is fucking stupid."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES43 => {
                :Title => _INTL("Why Level Candies and PSS Exp Gain exist"),
				:Text => _INTL("Due to the PSS Exp Gain being a feature added late into development, I wasn't able to figure out how to incorporate Level Caps EX with it. A 4.0.0 update will be required to perfect the PSS Exp Gain feature."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES44 => {
                :Title => _INTL("Why Level Candies and PSS Exp Gain exist"),
				:Text => _INTL("The unlimited and Reset Level Candies exist, because the entire spectrum of people's tolerance for grinding are so extreme, that the only way to make everyone happy, is Automatic Level Scaling and deciding if they want to use Level Candies."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES45 => {
                :Title => _INTL("Hard Level Caps are not needed"),
				:Text => _INTL("The very nature of how wild Pokémon are distributed, and how it works with Automatic Level Scaling, means Levels are a malleable flexible tool. Level Caps are free form in Pokémon Decades."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES46 => {
                :Title => _INTL("Hard Level Caps are not needed"),
				:Text => _INTL("This design decision also exists to solve the problem of the player not being able to invest in the Pokémon team they want, the second New Game is clicked. You can Evolve a Pokémon, and set them to Lvl.1 straight away."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES47 => {
                :Title => _INTL("Hard Level Caps are not needed"),
				:Text => _INTL("I didn't want to go through the uncessary trouble of doing what Fangames such as Tower of Ashes do, where Levels don't exist. Decades needs Levels, so the player can get the exact Pokémon for their squad that they want."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES48 => {
                :Title => _INTL("Why Evolutions are Standardized"),
				:Text => _INTL("No, going through a cryptic Evolution method that ends up with you Googling the answer after all was said and done, isn't engaging or makes you invested in a Pokémon. It results in you not bothering with them."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES49 => {
                :Title => _INTL("Why Evolutions are Standardized"),
				:Text => _INTL("Level Up, Evolution Stones and Specfic Gender are the only, and should be the only accetable Evolution Methods. Everything else results in constant Google searches without the Pokédex Data Page."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES50 => {
                :Title => _INTL("Why Evolutions are Standardized"),
				:Text => _INTL("Outside of exceptions such as Tyrogue, (Atk>Def, Atk<Def, Atk==Def) that are only accetable with the intervention of the EV/IV Allocator, every other Evolution Method is pointless bloated baggage."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES51 => {
                :Title => _INTL("Why PAS (Phone Assisted Speedrun) exists"),
				:Text => _INTL("I have a real life friend who plays mostly Sandbox games. All he wants in a game is to tour around and see everything, the second he clicks New Game. It's to the point he won't play a game unless there's a easily downloadable 100% save file."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES52 => {
                :Title => _INTL("Why PAS (Phone Assisted Speedrun) exists"),
				:Text => _INTL("I got so sick of him dropping games because he can't tour around after clicking New Game/Contiune, that I realise how pointless it is to expect a player to play up to a ceartin point, to engage with the section of a game they want to play."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES53 => {
                :Title => _INTL("Why PAS (Phone Assisted Speedrun) exists"),
				:Text => _INTL("You are not cheaping a game by providing tools that cut out the length of a game's playtime. You are allowing people with little to no free time, or just want to mess around, to actually enjoy playing a video game."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES54 => {
                :Title => _INTL("Why PAS (Phone Assisted Speedrun) exists"),
				:Text => _INTL("One of the worst Game Design pratices plaguing contempory video games, is bloated optional content. Stuff unrelated to the game's fundemental goal, that exists to reach a playtime quota."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES55 => {
                :Title => _INTL("Why PAS (Phone Assisted Speedrun) exists"),
				:Text => _INTL("Justify your playtime quota all you want. You cannot overcome the burden of downtime being sapped from a 9 to 5, 5 days a week. Or the general unpredictable outcome of when distress saps the ability to be able to enjoy a video game."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES56 => {
                :Title => _INTL("Why a Collision Toggle exists"),
				:Text => _INTL("It exists for the same reasons listed in the Fast Travel Phone section. The No Clip Disk being a tool to get to the Mystery Zones, exist to reward those who have any agency of curiosity to No Clip."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES57 => {
                :Title => _INTL("Why a Collision Toggle exists"),
				:Text => _INTL("I didn't want to waste development time doing Legendary Encounters in the manner most people expect Legendary Encounters to work. On top of spiting people that won't use the Wild Adjuster, and complain about where a specfic Pokémon is."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES58 => {
                :Title => _INTL("Why a Collision Toggle exists"),
				:Text => _INTL("Pokémon Decades has the PSS Pokémon Suite, the Wild Adjuster for 10 dedicated Wild Encounter chuncks for almost every area in the game, the Mystery Zones and the Safari Zone. Over 4 dedicated methods of getting every Pokémon up to Gen 9."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES59 => {
                :Title => _INTL("Why a Collision Toggle exists"),
				:Text => _INTL("Even with these 4 dedicated methods. Someone will bitch about most areas having 10 Pokémon in an area, dispite the Dexnav being a tool, and there's 18 dedicated areas for biomes. And they can't be fucked to use the Wild Adjuster."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES60 => {
                :Title => _INTL("Why the Auto Win Policy Exists"),
				:Text => _INTL("Ever played Pokémon Radical Red Hardcore Mode, beyond Gym 4? I have. Gym 4 has a permanent Grassy Terrain. With a Grassy Glide Kartana. The version of Radical Red I played, crashed when Eggs hatched. Eggs that were the only source of viable Fire type Pokémon."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES61 => {
                :Title => _INTL("Why the Auto Win Policy Exists"),
				:Text => _INTL("Talonflame up to that point can only learn Ember, no Will-O-Wisp access. The Egg Crash means literally only Arcanine is the viable option against Grassy Glide Kartana, if you didn't choose a Fire Type Starter at the start of the game."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES62 => {
                :Title => _INTL("Why the Auto Win Policy Exists"),
				:Text => _INTL("You have to fight with precision, to maneuver Arcanine into Kartana, after getting through the rest of Gym 4's Pokémon team. If that section of the game decided that Arcanine wouldn't be available at that point, I would have been screwed."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES63 => {
                :Title => _INTL("Why the Auto Win Policy Exists"),
				:Text => _INTL("Radical Red Hardcore Mode pushing the Pokémon League Gym Challenge Structure to it's logical extreme, irreversibly tainted my view on the traditional way of doing progression in Pokémon, offical and Fangames."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES64 => {
                :Title => _INTL("Why the Auto Win Policy Exists"),
				:Text => _INTL("Sometimes, you break through a diffcult part of the game, made harder from crap out of your control as a player. And all you have is raw angry rage, that puts you on a war path of spite, to ass fuck the game."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES65 => {
                :Title => _INTL("Why the Auto Win Policy Exists"),
				:Text => _INTL("Nothing else in Radical Red Hardcore Mode, made me as pissed off as I was, or was as soul sucking, than finally breaking that Grassy Gliding wall. Not Gym 5's Trick Room, the Primal Dialga bitch, not the Berry Forest, not the Marshadow Gauntlet."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES66 => {
                :Title => _INTL("Why the Auto Win Policy Exists"),
				:Text => _INTL("When a game makes you that level of pissed off. No, it's not a cop out from the developer allowing the player to just skip the bullshit. It's ensuring you don't have players who will forever hate your game. Or only want a play a hyper specfic part."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES67 => {
                :Title => _INTL("Why the Auto Win Policy Exists"),
				:Text => _INTL("Or radicalize them into never accepting playing a Pokémon game, without access to 1 of every Pokémon. Gifted, not in shitty Eggs, when the New Game button is clicked. So they have every tool required to solve daunting problems."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES68 => {
                :Title => _INTL("Why the Auto Win Policy Exists"),
				:Text => _INTL("The very nature of that negative experience, is the reason I don't want to go through the trouble of having a development team for Pokémon Decades. I am well aware that my pure hatred for the traditonal Pokémon progression, as a result of Grassy Glide Kartana."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES69 => {
                :Title => _INTL("Why the Auto Win Policy Exists"),
				:Text => _INTL("Would result in nothing but eternal arguments with team members that want to replicate the good qualities of other Fangames following the traditional Pokémon progression path. I mean it when I say, I cannot go back to not having 1 of every Pokémon."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES70 => {
                :Title => _INTL("Why the ATM Disk Exists"),
				:Text => _INTL("It's for people who want to skip the Type Master fights by buying the Type Emerald, but forgot to toggle the Auto Win Policy. And it's there if an update wants to give Poké Dollars a purpose again."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES71 => {
                :Title => _INTL("Why Story Mode is the way it is"),
				:Text => _INTL("I am that abnormal alien of Pokémon gamers, who's only enjoyment from Pokémon is it's Metagame and Team Building Sandbox. And I made peace early in development, that I will never compete with Techtonic, Rejuvenation, Unbreakable Ties, and Ashen Frost."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES72 => {
                :Title => _INTL("Why Story Mode is the way it is"),
				:Text => _INTL("If I was truly foolish in making a Reborn-Like, I would have aimed for and failed to reach the same story telling standards as Desolation, Rejuvenation, Ashen Frost, Unbreakable Ties and Realidea System."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES73 => {
                :Title => _INTL("Why Story Mode is the way it is"),
				:Text => _INTL("The number one priority of Pokémon Decades, was making a game that facillitates a highly replayable sandbox team building experience, and not latching onto an existing Region such as Johto or Kanto, like Grueling Gold or Radical Red."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES74 => {
                :Title => _INTL("Why Story Mode is the way it is"),
				:Text => _INTL("The very nature of how Side Quests are executed, shows that they only existed to have some form of meaningful reward, before the Mystery Zones were concieved. 4.0.0 will remove Side Quests, due to the Mystery Zones being added late into development."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES75 => {
                :Title => _INTL("Why Story Mode is the way it is"),
				:Text => _INTL("One of the most vital skills you need to learn in making a video game, is knowing when to cut the shit. And not waste time adding features or content you are not good at, or are not required for the game's design goals."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES76 => {
                :Title => _INTL("Why Story Mode is the way it is"),
				:Text => _INTL("A game developer greater than you will always exist and outclass you. So hold onto what you are good at, or enjoy about the video games you play, for dear life. You will never surpass those who are greater than you."),
                :Background => "bg_book2"
            },
			:DESIGNNOTES77 => {
                :Title => _INTL("Why Story Mode is the way it is"),
				:Text => _INTL("You never want to waste someone's time, if you yourself cannot finish what you started, as time marches on. The worst trap you can fall into, is dependance on people who all dysfunctionally depend on each other's strengths."),
                :Background => "bg_book2"
            },
			:CLIFFNOTES1 => {
                :Title => _INTL("The Cliff Notes"),
				:Text => _INTL("Pokémon Decades is a one Region game with 18 Type Masters, 1 Final Boss, and 1 Superboss. All of the Gen 9 National Dex is present, and all Battle Gimmicks can be used in the Beatha Region."),
                :Background => "bg_book2"
            },
			:CLIFFNOTES2 => {
                :Title => _INTL("The Cliff Notes"),
				:Text => _INTL("All generated Pokémon will have perfect 31 IVs, and EVs can be allocated in the Summary Screen, on the Info Page. Ultimate Move Tutor is used to allow every Pokémon to have the entire history of their Learnsets."),
                :Background => "bg_book2"
            },
			:CLIFFNOTES3 => {
                :Title => _INTL("The Cliff Notes"),
				:Text => _INTL("You have a Trainer Suite, that consists of every Item in the game Story and Battle Mode need. You can regenerate the Suite by going to the Pokémon Center. Anti Grind Trainers and Title Granting Trainers can be found in the Pokémon Center."),
                :Background => "bg_book2"
            },
			:INGAMEDOCS1 => {
                :Title => _INTL("Your Goal"),
				:Text => _INTL("Obtain all 18 Type Emeralds, by defeating Beatha's Type Masters. With all Emeralds, go to the Peninsula of Mastery, west of Stratos City."),
				:Image => "gyms",
                :ImagePosition => :Top,
                :Background => "bg_book2"
            },
			:INGAMEDOCS2 => {
                :Title => _INTL("Following Pokémon"),
                :Text => _INTL("Press the A Key to toggle making Pokémon follow you. Press the S Key to change the first Pokémon you send out in Battle. Useful for the Single Battle Format."),
                :Background => "bg_book2"
            },
			:INGAMEDOCS3 => {
                :Title => _INTL("Regional Pokémon Forms/Obscure Forms"),
                :Text => _INTL("To obtain a specfic Pokémon Form/Forme, go to the Pokémon Center and talk to the Form Trader. Traded Pokémon always obey you, and do not gain any extra Experience. You are expected to use the Form Trader to obtain specfic Pokémon Forms/Formes."),
                :Background => "bg_book2"
            },
			:INGAMEDOCS4 => {
                :Title => _INTL("Relearning a Pokémon's entire Learnset"),
                :Text => _INTL("In the Summary Screen, on the Info Page, Press the Spacebar and select Relearn Moves. Any Pokémon can relearn <c2=0999367C>the entire history of it's Learnset, Gen 1 to Gen 9.</c2> No Pokémon has a Level Up Learnset, you have to use the Move Relearner."),
                :Background => "bg_book2"
            },
			:INGAMEDOCS5 => {
                :Title => _INTL("EV Allowcating"),
                :Text => _INTL("In the Summary Screen, on the Skills Page, Press the Spacebar to edit EV's. <c2=0999367C>You cannot gain EV's from Battles of any kind. You have to use the EV Allowcator to fully train your Pokémon.</c2> Attack and Sp.Atk EV's are linked together."),
                :Background => "bg_book2"
            },
			:INGAMEDOCS6 => {
                :Title => _INTL("IV Editing and Trick Room Presets"),
                :Text => _INTL("In the Party Screen, Press the Spacebar and choose Proficiency IVs. <c2=0999367C>All Pokémon will have Perfect 31 IV's.</c2> In the Summary Screen, on the Info Page, Press the Spacebar and select an IV Preset. Useful for Trick Room, Foul Play and Sparkly Swirl."),
                :Background => "bg_book2"
            },
			:INGAMEDOCS7 => {
                :Title => _INTL("Trainer Suite"),
				:Text => _INTL("As part of your Trainer Suite, <c2=0999367C>The Exp All Toggle is included, and on by default.</c2> You also have other tools such as Shiny Toggles, Repel Toggles, Nature Modifiers, Level Candies and more. Your Suite can be regenerated at the Pokémon Center."),
                :Background => "bg_book2"
            },
			:INGAMEDOCS8 => {
                :Title => _INTL("Where are my Pokémon?"),
				:Text => _INTL("In the Party Screen, Press the D Key to access your PSS. (Pokémon Storage System) The PSS can store up to 3000 Pokémon. Upon Clicking New Game, you can decide if you want the PSS Suite. The suite is one of every Pokemon, and the Form Trader can be used to get anything missing."),
                :Background => "bg_book2"
            },
			:INGAMEDOCS9 => {
                :Title => _INTL("Soft Reset/Change Controls"),
				:Text => _INTL("After you have saved your game, press the F12 Key to Soft Reset. This will take you back to the Main Menu, without quitting the game. In the Pause Menu, select Controls to change assigned Keyboard/Gamepad Inputs."),
                :Background => "bg_book2"
            },
			:INGAMEDOCS10 => {
                :Title => _INTL("Type Matchup Lookup"),
				:Text => _INTL("During a battle, Press the T Key to inspect the Type Matchups of all Pokémon on the battlefield."),
                :Background => "bg_book2"
            },
			:INGAMEDOCS11 => {
                :Title => _INTL("Battle Turn Tips"),
				:Text => _INTL("In battles, the Pokémon with the higher speed stat uses their move first. Some moves, such as Tailwind modify this. Speed ties are decided randomly. Trick Room makes the Pokémon with the slower speed stat use their move first."),
                :Background => "bg_book2"
            },
			:INGAMEDOCS12 => {
                :Title => _INTL("Same Type Attack Bonus (STAB)"),
				:Text => _INTL("Pokémon deal 50% more damage with moves that share a type with them. Pikachu (Electric) deals 50% more damage with an Electric move than a Grass move."),
                :Background => "bg_book2"
            },
			:INGAMEDOCS13 => {
                :Title => _INTL("NTAW STAB MFT"),
				:Text => _INTL("Pokémon who are not Normal type, who use a Normal type move, will convert that move into their Primary/Tera type. A Nidoking (Poison/Ground) using Tri Attack, will change Tri Attack into a Poison type move. A Tera Ice Nidoking using Tri Attack, will change Tri Attack into a Ice type move."),
                :Background => "bg_book2"
            },
			:INGAMEDOCS14 => {
                :Title => _INTL("Status Condition Changes"),
				:Text => _INTL("Paralysis will only cut Speed in half, and will never fully paralyse. Frostbite is the Sp.Atk version of Burn, and replaces Freeze. Drowzy replaces Sleep, and a Drowzy Pokémon has a 50% chance to doze off. Outside of these changes, this game uses the offical Status Conditions."),
                :Background => "bg_book2"
            },
			:INGAMEDOCS15 => {
                :Title => _INTL("Weather Changes"),
				:Text => _INTL("Hailstorm combines Snow and Hail, giving Ice types a 50% Defense boost. Non Ice, Fire and Fighting types take damage from the Hailstorm every turn. Outside of these changes, this game uses the offical Weathers."),
                :Background => "bg_book2"
            },
			:INGAMEDOCS16 => {
                :Title => _INTL("Universal Type Moves"),
				:Text => _INTL("Every Pokémon has universal Moves for any primary or secondary type they are. When a Pokémon's Typing changes from Evolution, it loses access to previous Universal Type Moves. To view the Universal Move Types, view the Folder Plugins/Ultimate Move Tutor/move_tutor.rb"),
                :Background => "bg_book2"
            },
			:INGAMEDOCS17 => {
                :Title => _INTL("Battle Gimmicks"),
				:Text => _INTL("In battle, press the Z Key to toggle Mega Evolution, Z-Moves, Dynamax or Tera. You need to use Dynamax Inhibitors to not have it take over changing your Pokémon's Tera type. When Dynamax is used up, a Pokémon can Tera straight after."),
                :Background => "bg_book2"
            },
			:INGAMEDOCS18 => {
                :Title => _INTL("Z-Status Moves + NTAW STAB MFT"),
				:Text => _INTL("For the effect of a Z-Status move to work, the Pokémon's primary Type must match the Type of the Z-Crystal used. Attempts were made to fix this issue, and as of this game's current version, it is not possible to fix this issue."),
                :Background => "bg_book2"
            },
			:INGAMEDOCS19 => {
                :Title => _INTL("100% Wild Battle Flee Rate"),
				:Text => _INTL("You can always escape any wild battle, no matter how slow your Pokémon are. You can still be trapped in battle."),
                :Background => "bg_book2"
            },
			:INGAMEDOCS20 => {
                :Title => _INTL("HM/Field Moves"),
				:Text => _INTL("Type Emeralds are not required for Field Moves such as Surf. A Pokémon is not required to have a Field Move in it's Moveset. It only needs to be able to learn a Field Move. (Universal Moves must be taught to a Pokémon if it cannot naturally learn it, such as Flash + Alolan Golem)"),
                :Background => "bg_book2"
            },
			:INGAMEDOCS21 => {
                :Title => _INTL("Encounter Objects"),
				:Text => _INTL("Environment objects such as <c2=0999367C>TV's in Gatehouses, Small Trees, Cracked Rocks and Trash Bins</c2> can have Pokémon in them."),
                :Background => "bg_book2"
            },
			:INGAMEDOCS22 => {
                :Title => _INTL("Light Ball Changes"),
				:Text => _INTL("When held, can Paralyze like how the Toxic and Flame Orb work. Power boosts for Electric Rodents, such as Pawmi, Emolga and Morpeko range from 30% to 50%. Pikachu and Pawmo get a 100% power boost."),
                :Background => "bg_book2"
            },
			:INGAMEDOCS23 => {
                :Title => _INTL("Natural Gift Changes"),
				:Text => _INTL("Natural Gift no longer consumes a held berry item when used. Berry Item Power varies from 80 to 110."),
                :Background => "bg_book2"
            },
			:INGAMEDOCS24 => {
                :Title => _INTL("Level Caps"),
				:Text => _INTL("This games does not enforce Level Caps. The Level Cap begins at Lvl.10. Every Type Emerald, in any order you obtain adds +5 to the Level Cap. Use the Level Candies to manually set Levels. With 18 Type Emeralds, the Level Cap reaches Lvl.100."),
                :Background => "bg_book2"
            },
			:INGAMEDOCS25 => {
                :Title => _INTL("Hazard Changes"),
				:Text => _INTL("Stealth Rock is now Stellar Rock. All Pokémon Types take 12.5% damage on switch in. Steel Types absorb Stellar Rock on switch in. Bug Types absorb Spikes on switch in. All other Hazard interactions are the same as the offical games."),
                :Background => "bg_book2"
            },
			:INGAMEDOCS26 => {
                :Title => _INTL("How to Skip Battles"),
				:Text => _INTL("Toggle on the Auto Win Policy to skip to the winning outcome of Wild and Trainer battles. This Trainer Suite Item exists to accelerate getting to a specfic section of a game, without slogging through sections you don't care about."),
                :Background => "bg_book2"
            },
			:STARTERDESC1 => {
                :Title => _INTL("First Partner Pokémon Options"),
				:Text => _INTL("In Pokémon Decades, you have a total of 22 Options for getting a Starter Pokémon. The Option VGC Starters are this game's intended Starter Choices. The rest exist to facillitate as many exact tastes as possible."),
                :Background => "bg_book2"
            },
			:STARTERDESC2 => {
                :Title => _INTL("The VGC Starters"),
				:Text => _INTL("VGC Pokémon are given via Ultimate Move Tutor (Plugins Folder) an injection of moves that allow them to excel in any Battle Format. (move_tutor.rb, line 124) These VGC/Universal/Universal Type Moves are not documented in the Pokédex Data Page."),
                :Background => "bg_book2"
            },
			:STARTERDESC3 => {
                :Title => _INTL("Traditional Starters"),
				:Text => _INTL("Traditional Starters consist of the Grass/Fire/Water Triangle from the offical Gen 1 to Gen 9 games, alternative offical game Starters Gen 1 to Gen 9, and Beatha's Regional Dex Starters. (Rhyhorn/Trapinch/Sandile)"),
                :Background => "bg_book2"
            },
			:STARTERDESC4 => {
                :Title => _INTL("Any Family Line"),
				:Text => _INTL("This consists of every Pokémon Evolution Line, from Gen 1 to Gen 9. Any Pokémon that is not part of the VGC Starter Options will not get the VGC Movepool injection, but will have access to Universal Moves/Universal Type Moves."),
                :Background => "bg_book2"
            },
			:STARTERDESC5 => {
                :Title => _INTL("Random Starters"),
				:Text => _INTL("You will be given a completely random selection of any Pokémon to be your Starter/First Partner Pokémon. With all choices including this one, you can choose 1 to 6 Pokémon."),
                :Background => "bg_book2"
            },
			:STARTERDESC6 => {
                :Title => _INTL("Monotype Starters"),
				:Text => _INTL("Monotype Starters are Pokémon from any Evolution Family Line, who are or become an exact Monotype in their Evolution Line. Monotype Starter Options are best used with the PSS (Pokémon Storage System) Suite."),
                :Background => "bg_book2"
            },
			:STARTERDESC7 => {
                :Title => _INTL("Basic Vanilla Gen 9 Patch"),
				:Text => _INTL("If you are using the Basic Vanilla Gen 9 Patch, the Starter Choices will not update to match Vanilla Gen 9 Typings. This is because Pokémon Decades is designed around it's stock modded Gen 9 Metagame. Read the Patch's disclaimer for more details."),
                :Background => "bg_book2"
            },
			:WIKIDEXDESC1 => {
                :Title => _INTL("Pokédex Config Choice"),
				:Text => _INTL("Choosing Yes will make the Pokédex be pre-configured with all Data of every Pokémon, Form/Formes included. Choose Yes if you want to do a Nuzlocke or Challenge Run. Decades is designed around a pre-configured Pokédex."),
                :Background => "bg_book2"
            },
			:WIKIDEXDESC2 => {
                :Title => _INTL("Pokédex Config Choice"),
				:Text => _INTL("Choosing No means you have to catch/obtain a Pokémon in order to view it's Data. Choose No if you want a traditional Pokémon experience, or are confident in your ability to do a Nuzlocke Challenge."),
                :Background => "bg_book2"
            },
			:DOCUMENTS => {
                :Title => _INTL("Where's the Documentation?"),
				:Text => _INTL("Press the Z Key to access your Bag. Go to the Walkthrough section of the bag. The Pokédex is preconfigured with data on all Pokémon, Moves and Abilities."),
				:Image => "docs",
                :ImagePosition => :Top,
                :Background => "bg_book2"
            }
        }

        TIP_CARDS_GROUPS = {
            :BEGINNER => {
                :Title => _INTL("Beginner Tips"),
                :Tips => [:CATCH, :CATCH2, :ITEMS, :ITEMS2]
            },
            :CATCHING => {
                :Title => _INTL("Catching Tips"),
                :Tips => [:CATCH, :CATCH2]
            },
            :ITEMS => {
                :Title => _INTL("Item Tips"),
                :Tips => [:ITEMS, :ITEMS2]
            },
            :BOOK1 => {
                :Title => _INTL("Book Alpha"),
                :Tips => [:BOOK1PAGE1, :BOOK1PAGE2, :BOOK1PAGE3, :BOOK1PAGE4]
            },
			:GAMEFEATURES => {
				:Title => _INTL("Game Features"),
				:Tips => [:FEATURES1, :FEATURES2, :FEATURES3, :FEATURES4, :FEATURES5, :FEATURES6,:FEATURES7, :FEATURES8]
			}
        }

end
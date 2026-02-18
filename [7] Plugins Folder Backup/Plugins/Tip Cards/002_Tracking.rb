def pbRevisitTipCards
    return Console.echo_warn "No available tips to show" if !$stats.tip_cards_seen || $stats.tip_cards_seen.empty?
    arr = []
    $stats.tip_cards_seen.each { |tip| arr.push(tip) unless Settings::TIP_CARDS_CONFIGURATION[tip] && 
        Settings::TIP_CARDS_CONFIGURATION[tip][:HideRevisit]}
    pbShowTipCard(*arr)
end

def pbRevisitTipCardsGrouped(*groups, continuous: false)
    groups = Settings::TIP_CARDS_GROUPS.keys if !groups || groups.empty?
    sections = []
    groups.each_with_index do |group, i|
        group = Settings::TIP_CARDS_GROUPS[group]
        next unless group
        group[:Tips].each do |tip|
            next if !Settings::TIP_CARDS_CONFIGURATION[tip] || Settings::TIP_CARDS_CONFIGURATION[tip][:HideRevisit] || 
                !pbSeenTipCard?(tip)
            sections.push(groups[i])
            break
        end
    end
    if sections.length > 1 || (sections.length == 1 && Settings::TIP_CARDS_SINGLE_GROUP_SHOW_HEADER)
        scene = TipCardGroups_Scene.new(sections, true, continuous)
        screen = TipCardGroups_Screen.new(scene)
        screen.pbStartScreen
    elsif sections[0]
        tips = Settings::TIP_CARDS_GROUPS[sections[0]][:Tips]
        arr = []
        tips.each do |tip| 
            next if !Settings::TIP_CARDS_CONFIGURATION[tip] || Settings::TIP_CARDS_CONFIGURATION[tip][:HideRevisit] || 
            !pbSeenTipCard?(tip)
            arr.push(tip)
        end
        pbShowTipCard(*arr)
    else
        Console.echo_warn "No available tips to show"
    end
end

def pbSetTipCardSeen(tip_id, seen = true)
    $stats.tip_cards_seen ||= []
    if seen
        $stats.tip_cards_seen.push(tip_id) unless $stats.tip_cards_seen.include?(tip_id)
    else
        $stats.tip_cards_seen.delete(tip_id) if $stats.tip_cards_seen.include?(tip_id)
    end
end

def pbSeenTipCard?(tip_id)
    return false if !$stats.tip_cards_seen || $stats.tip_cards_seen.empty?
    return $stats.tip_cards_seen.include?(tip_id)
end

#===============================================================================
# GameStats
#===============================================================================

class GameStats
    attr_accessor :tip_cards_seen

    alias tdw_tip_cards_stats_init initialize
    def initialize
        tdw_tip_cards_stats_init
        @tip_cards_seen = []
    end
end

#===============================================================================
# Item
#===============================================================================

#===============================================================================
# In Game Docs (I am not making an online wiki I cannot maintain)
#===============================================================================
ItemHandlers::UseFromBag.add(:ADVENTUREGUIDE, proc { |item|
	
	# In Game Docs 
	cmds = ["Pokémon Decades Cliff Notes", "What's the objective again?", "Following Pokémon", "Regional and Obscure Forms/Formes", "Relearning Moves", "EV Allocation", "IV Presets", "Trainer Suite", "Where are my Pokémon", "Soft Reset/Change Controls", "Type Chart", "Type Matchups in Battle", "Battle Turn Tips", "STAB", "NTAW STAB MYFT", "Status Condition Changes", "Weather Changes", "Universal Type Moves", "Battle Gimmicks", "Z-Status Moves + NTAW STAB MYFT", "100% Wild Battle Flee Rate", "Field/HM Moves", "Encounter Objects", "Light Ball Changes", "Natural Gift Changes", "Level Caps", "Hazard Changes", "How to Skip Battles", "Cancel"]
	c = pbMessage("What section do you want to know about?", cmds)
	if c == 0
		pbShowTipCard(:CLIFFNOTES1,:CLIFFNOTES2,:CLIFFNOTES3)
 
	elsif c == 1
		pbShowTipCard(:INGAMEDOCS1)
		
	elsif c == 2
		pbShowTipCard(:INGAMEDOCS2)
		
	elsif c == 3
		pbShowTipCard(:INGAMEDOCS3)

	elsif c == 4
		pbShowTipCard(:INGAMEDOCS4)
		
	elsif c == 5
		pbShowTipCard(:INGAMEDOCS5)

	elsif c == 6
		pbShowTipCard(:INGAMEDOCS6)

	elsif c == 7
		pbShowTipCard(:INGAMEDOCS7)

	elsif c == 8
		pbShowTipCard(:INGAMEDOCS8)

	elsif c == 9
		pbShowTipCard(:INGAMEDOCS9)

	elsif c == 10
		pbTypeMatchUI
		
	elsif c == 11
		pbShowTipCard(:INGAMEDOCS10)

	elsif c == 12
		pbShowTipCard(:INGAMEDOCS11)

	elsif c == 13
		pbShowTipCard(:INGAMEDOCS12)

	elsif c == 14
		pbShowTipCard(:INGAMEDOCS13)

	elsif c == 15
		pbShowTipCard(:INGAMEDOCS14)

	elsif c == 16
		pbShowTipCard(:INGAMEDOCS15)
	
	elsif c == 17
		pbShowTipCard(:INGAMEDOCS16)
		
	elsif c == 18
		pbShowTipCard(:INGAMEDOCS17)

	elsif c == 19
		pbShowTipCard(:INGAMEDOCS18)

	elsif c == 20
		pbShowTipCard(:INGAMEDOCS19)	

	elsif c == 21
		pbShowTipCard(:INGAMEDOCS20)

	elsif c == 22
		pbShowTipCard(:INGAMEDOCS21)

	elsif c == 23
		pbShowTipCard(:INGAMEDOCS22)
		
	elsif c == 24
		pbShowTipCard(:INGAMEDOCS23)

	elsif c == 25
		pbShowTipCard(:INGAMEDOCS24)	

	elsif c == 26
		pbShowTipCard(:INGAMEDOCS25)

	elsif c == 27
		pbShowTipCard(:INGAMEDOCS26)
		
	end 
	
	# End of In Game Docs List
    next 1
	
	
	# Test List
#	cmds = ["Why Level Scaling?", "Why so many Starters?", "Why is Beatha so linear?", "Cancel"]
#	c = pbMessage("What do you want answers for?", cmds)
#	if c == 0
#		pbShowTipCard(:DESIGNNOTES1,:DESIGNNOTES2,:DESIGNNOTES3)
# 
#	elsif c == 1
#		pbShowTipCard(:DESIGNNOTES4,:DESIGNNOTES5,:DESIGNNOTES6)
#		
#	elsif c == 2
#		pbShowTipCard(:DESIGNNOTES7,:DESIGNNOTES8,:DESIGNNOTES9)
#		
#	end 
#	
#	# End of FAQ List
#   next true

#   cmds = ["Following Pokémon", "Relearning Moves", "EV Allocation", "IV Presets", "Trainer Suite", "Where are my Pokémon?", "Soft Reset/Change Controls", "Type Chart", "Type Matchups in Battle", "Battle Turn Tips", "STAB", "NTAW STAB MFT", "Status Condition Changes", "Weather Changes", "Universal Type Moves", "Battle Gimmicks", "Z-Status Moves + NTAW STAB MFT", "100% Wild Battle Flee Rate", "Field/HM Moves", "Encounter Objects", "Light Ball Changes", "Natural Gift Changes", "Level Caps", "Hazard Changes", "How to Skip Battles", "Cancel"]
#	c = pbMessage("What section do you want to know about?", cmds)
#	if c == 0
#		pbShowTipCard(:FEATURES1)
# 
#	elsif c == 1
#		pbShowTipCard(:FEATURES2)
#		
#	elsif c == 2
#		pbShowTipCard(:FEATURES3)
#
#	elsif c == 3
#		pbShowTipCard(:FEATURES4)
#	
#	elsif c == 4
#		pbShowTipCard(:FEATURES5)
#
#	elsif c == 5
#		pbShowTipCard(:FEATURES6)
#
#	elsif c == 6
#		pbShowTipCard(:FEATURES7)
#
#	elsif c == 7
#		pbTypeMatchUI
#		
#	elsif c == 8
#		pbShowTipCard(:FEATURES8)
#
#	elsif c == 9
#		pbShowTipCard(:FEATURES9)
#
#	elsif c == 10
#		pbShowTipCard(:FEATURES10)
#
#	elsif c == 11
#		pbShowTipCard(:FEATURES11)
#	
#	elsif c == 12
#		pbShowTipCard(:FEATURES12)
#		
#	elsif c == 13
#		pbShowTipCard(:FEATURES13)
#		
#	elsif c == 14
#		pbShowTipCard(:FEATURES14)
#	
#	elsif c == 15
#		pbShowTipCard(:FEATURES15)
#
#	elsif c == 16
#		pbShowTipCard(:FEATURES16)
#	
#	elsif c == 17
#		pbShowTipCard(:FEATURES17)
#	
#	elsif c == 18
#		pbShowTipCard(:FIELDMOVES1)
#
#	elsif c == 19
#		pbShowTipCard(:FIELDMOVES2)
#
#	elsif c == 20
#		pbShowTipCard(:MECHANICS1)	
#		
#	elsif c == 21
#		pbShowTipCard(:MECHANICS2)	
#
#	elsif c == 22
#		pbShowTipCard(:LEVELCAPS1)	
#	
#	elsif c == 23
#		pbShowTipCard(:MECHANICS3)
#
#	elsif c == 24
#		pbShowTipCard(:MECHANICS4)
#		
#	end 
	
    next 1
})

#===============================================================================
# In Game Docs (I am not making an online wiki I cannot maintain)
#===============================================================================
ItemHandlers::UseInField.add(:ADVENTUREGUIDE, proc { |item|

	# In Game Docs
	cmds = ["Pokémon Decades Cliff Notes", "What's the objective again?", "Following Pokémon", "Regional and Obscure Forms/Formes", "Relearning Moves", "EV Allocation", "IV Presets", "Trainer Suite", "Where are my Pokémon", "Soft Reset/Change Controls", "Type Chart", "Type Matchups in Battle", "Battle Turn Tips", "STAB", "NTAW STAB MYFT", "Status Condition Changes", "Weather Changes", "Universal Type Moves", "Battle Gimmicks", "Z-Status Moves + NTAW STAB MYFT", "100% Wild Battle Flee Rate", "Field/HM Moves", "Encounter Objects", "Light Ball Changes", "Natural Gift Changes", "Level Caps", "Hazard Changes", "How to Skip Battles", "Cancel"]
	c = pbMessage("What section do you want to know about?", cmds)
	if c == 0
		pbShowTipCard(:CLIFFNOTES1,:CLIFFNOTES2,:CLIFFNOTES3)
 
	elsif c == 1
		pbShowTipCard(:INGAMEDOCS1)
		
	elsif c == 2
		pbShowTipCard(:INGAMEDOCS2)
		
	elsif c == 3
		pbShowTipCard(:INGAMEDOCS3)

	elsif c == 4
		pbShowTipCard(:INGAMEDOCS4)
		
	elsif c == 5
		pbShowTipCard(:INGAMEDOCS5)

	elsif c == 6
		pbShowTipCard(:INGAMEDOCS6)

	elsif c == 7
		pbShowTipCard(:INGAMEDOCS7)

	elsif c == 8
		pbShowTipCard(:INGAMEDOCS8)

	elsif c == 9
		pbShowTipCard(:INGAMEDOCS9)

	elsif c == 10
		pbTypeMatchUI
		
	elsif c == 11
		pbShowTipCard(:INGAMEDOCS10)

	elsif c == 12
		pbShowTipCard(:INGAMEDOCS11)

	elsif c == 13
		pbShowTipCard(:INGAMEDOCS12)

	elsif c == 14
		pbShowTipCard(:INGAMEDOCS13)

	elsif c == 15
		pbShowTipCard(:INGAMEDOCS14)

	elsif c == 16
		pbShowTipCard(:INGAMEDOCS15)
	
	elsif c == 17
		pbShowTipCard(:INGAMEDOCS16)
		
	elsif c == 18
		pbShowTipCard(:INGAMEDOCS17)

	elsif c == 19
		pbShowTipCard(:INGAMEDOCS18)

	elsif c == 20
		pbShowTipCard(:INGAMEDOCS19)	

	elsif c == 21
		pbShowTipCard(:INGAMEDOCS20)

	elsif c == 22
		pbShowTipCard(:INGAMEDOCS21)

	elsif c == 23
		pbShowTipCard(:INGAMEDOCS22)
		
	elsif c == 24
		pbShowTipCard(:INGAMEDOCS23)

	elsif c == 25
		pbShowTipCard(:INGAMEDOCS24)	

	elsif c == 26
		pbShowTipCard(:INGAMEDOCS25)

	elsif c == 27
		pbShowTipCard(:INGAMEDOCS26)
		
	end 
	
	# End of In Game Docs List
   next true

	# Test List
#	cmds = ["Why Level Scaling?", "Why so many Starters?", "Why is Beatha so linear?", "Cancel"]
#	c = pbMessage("What do you want answers for?", cmds)
#	if c == 0
#		pbShowTipCard(:DESIGNNOTES1,:DESIGNNOTES2,:DESIGNNOTES3)
# 
#	elsif c == 1
#		pbShowTipCard(:DESIGNNOTES4,:DESIGNNOTES5,:DESIGNNOTES6)
#		
#	elsif c == 2
#		pbShowTipCard(:DESIGNNOTES7,:DESIGNNOTES8,:DESIGNNOTES9)
#		
#	end 
#	
#	# End of FAQ List
#   next true

#	cmds = ["Following Pokémon", "Relearning Moves", "EV Allocation", "IV Presets", "Trainer Suite", "Where are my Pokémon?", "Soft Reset/Change Controls", "Type Chart", "Type Matchups in Battle", "Battle Turn Tips", "STAB", "NTAW STAB MFT", "Status Condition Changes", "Weather Changes", "Universal Type Moves", "Battle Gimmicks", "Z-Status Moves + NTAW STAB MFT", "100% Wild Battle Flee Rate", "Field/HM Moves", "Encounter Objects", "Light Ball Changes", "Natural Gift Changes", "Level Caps", "Hazard Changes", "How to Skip Battles", "Cancel"]
#	c = pbMessage("What section do you want to know about?", cmds)
#	if c == 0
#		pbShowTipCard(:FEATURES1)
# 
#	elsif c == 1
#		pbShowTipCard(:FEATURES2)
#		
#	elsif c == 2
#		pbShowTipCard(:FEATURES3)
#
#	elsif c == 3
#		pbShowTipCard(:FEATURES4)
#	
#	elsif c == 4
#		pbShowTipCard(:FEATURES5)
#
#	elsif c == 5
#		pbShowTipCard(:FEATURES6)
#
#	elsif c == 6
#		pbShowTipCard(:FEATURES7)
#
#	elsif c == 7
#		pbTypeMatchUI
#		
#	elsif c == 8
#		pbShowTipCard(:FEATURES8)
#
#	elsif c == 9
#		pbShowTipCard(:FEATURES9)
#
#	elsif c == 10
#		pbShowTipCard(:FEATURES10)
#
#	elsif c == 11
#		pbShowTipCard(:FEATURES11)
#	
#	elsif c == 12
#		pbShowTipCard(:FEATURES12)
#		
#	elsif c == 13
#		pbShowTipCard(:FEATURES13)
#		
#	elsif c == 14
#		pbShowTipCard(:FEATURES14)
#	
#	elsif c == 15
#		pbShowTipCard(:FEATURES15)
#
#	elsif c == 16
#		pbShowTipCard(:FEATURES16)
#	
#	elsif c == 17
#		pbShowTipCard(:FEATURES17)
#		
#	elsif c == 18
#		pbShowTipCard(:FIELDMOVES1)	
#		
#	elsif c == 19
#		pbShowTipCard(:FIELDMOVES2)
#
#	elsif c == 20
#		pbShowTipCard(:MECHANICS1)	
#		
#	elsif c == 21
#		pbShowTipCard(:MECHANICS2)	
#
#	elsif c == 22
#		pbShowTipCard(:LEVELCAPS1)
#
#	elsif c == 23
#		pbShowTipCard(:MECHANICS3)
#
#	elsif c == 24
#		pbShowTipCard(:MECHANICS4)
#		
#	end 
	
    next true
})

#===============================================================================
# In Game FAQ (I am not making an online wiki I cannot maintain)
# This exists only as fuel for those that hate this game,
# and to provide answers to decisions I have made with it's game design,
# and why it turned out the way it is.
# It's also so I can rewrite the Adventure Guide for the final time
ItemHandlers::UseInField.add(:DESIGNNOTES, proc { |item|
	
	# Test List
#	cmds = ["Why Level Scaling?", "Why so many Starters?", "Why is Beatha so linear?", "Cancel"]
#	c = pbMessage("What do you want answers for?", cmds)
#	if c == 0
#		pbShowTipCard(:DESIGNNOTES1,:DESIGNNOTES2,:DESIGNNOTES3)
#  
#	elsif c == 1
#		pbShowTipCard(:DESIGNNOTES4,:DESIGNNOTES5,:DESIGNNOTES6)
#		
#	elsif c == 2
#		pbShowTipCard(:DESIGNNOTES7,:DESIGNNOTES8,:DESIGNNOTES9)
#		
#	end 
#	
#	# End of FAQ List
 #   next 1	
	
	
	# FAQ List
	cmds = ["Level Scaling?", "Why so many Starters?", "Why is Beatha so linear?", "Metagame Wiki Dex?", "EV/IV Allocation?", "All Battle Gimmicks?", "All Pokémon in PSS?", "Interior Buildings?", "Rebalanced Pokémon?", "1 out of 6 Abilities?", "No Poké Marts?", "Pokémon Eggs?", "Infinite Balls?", "Power Leveling?", "No Hard Level Caps?", "Standardized Evolution Methods?", "Fast Travel Phone?", "No Clip?", "Auto Win Policy!?", "Money Printer?", "Story Mode's boring!", "Cancel"]
	c = pbMessage("What do you want answers for?", cmds)
	if c == 0
		pbShowTipCard(:DESIGNNOTES1,:DESIGNNOTES2,:DESIGNNOTES3)
  
	elsif c == 1
		pbShowTipCard(:DESIGNNOTES4,:DESIGNNOTES5,:DESIGNNOTES6)
		
	elsif c == 2
		pbShowTipCard(:DESIGNNOTES7,:DESIGNNOTES8,:DESIGNNOTES9)
	
	elsif c == 3
		pbShowTipCard(:DESIGNNOTES10,:DESIGNNOTES11,:DESIGNNOTES12)

	elsif c == 4
		pbShowTipCard(:DESIGNNOTES13,:DESIGNNOTES14,:DESIGNNOTES15)
		
	elsif c == 5
		pbShowTipCard(:DESIGNNOTES16,:DESIGNNOTES17,:DESIGNNOTES18)
	
	elsif c == 6
		pbShowTipCard(:DESIGNNOTES19,:DESIGNNOTES20,:DESIGNNOTES21)

	elsif c == 7
		pbShowTipCard(:DESIGNNOTES22,:DESIGNNOTES23,:DESIGNNOTES24)
		
	elsif c == 8
		pbShowTipCard(:DESIGNNOTES25,:DESIGNNOTES26,:DESIGNNOTES27,:DESIGNNOTES28)

	elsif c == 9
		pbShowTipCard(:DESIGNNOTES29,:DESIGNNOTES30,:DESIGNNOTES31)
		
	elsif c == 10
		pbShowTipCard(:DESIGNNOTES32,:DESIGNNOTES33,:DESIGNNOTES34)

	elsif c == 11
		pbShowTipCard(:DESIGNNOTES35,:DESIGNNOTES36,:DESIGNNOTES37)
		
	elsif c == 12
		pbShowTipCard(:DESIGNNOTES38,:DESIGNNOTES39,:DESIGNNOTES40)

	elsif c == 13
		pbShowTipCard(:DESIGNNOTES41,:DESIGNNOTES42,:DESIGNNOTES43,:DESIGNNOTES44)
		
	elsif c == 14
		pbShowTipCard(:DESIGNNOTES45,:DESIGNNOTES46,:DESIGNNOTES47)

	elsif c == 15
		pbShowTipCard(:DESIGNNOTES48,:DESIGNNOTES49,:DESIGNNOTES50)
		
	elsif c == 16
		pbShowTipCard(:DESIGNNOTES51,:DESIGNNOTES52,:DESIGNNOTES53,:DESIGNNOTES54,:DESIGNNOTES55)

	elsif c == 17
		pbShowTipCard(:DESIGNNOTES56,:DESIGNNOTES57,:DESIGNNOTES58,:DESIGNNOTES59)

	elsif c == 18
		pbShowTipCard(:DESIGNNOTES60,:DESIGNNOTES61,:DESIGNNOTES62,:DESIGNNOTES63,:DESIGNNOTES64,:DESIGNNOTES65,:DESIGNNOTES66,:DESIGNNOTES67,:DESIGNNOTES68,:DESIGNNOTES69)
		
	elsif c == 19
		pbShowTipCard(:DESIGNNOTES70)

	elsif c == 20
		pbShowTipCard(:DESIGNNOTES71,:DESIGNNOTES72,:DESIGNNOTES73,:DESIGNNOTES74,:DESIGNNOTES75,:DESIGNNOTES76,:DESIGNNOTES77)
		
	end 
	
	# End of FAQ List
    next 1
})

ItemHandlers::UseInField.add(:DESIGNNOTES, proc { |item|
	
	# Test List
#	cmds = ["Why Level Scaling?", "Why so many Starters?", "Why is Beatha so linear?", "Cancel"]
#	c = pbMessage("What do you want answers for?", cmds)
#	if c == 0
#		pbShowTipCard(:DESIGNNOTES1,:DESIGNNOTES2,:DESIGNNOTES3)
# 
#	elsif c == 1
#		pbShowTipCard(:DESIGNNOTES4,:DESIGNNOTES5,:DESIGNNOTES6)
#		
#	elsif c == 2
#		pbShowTipCard(:DESIGNNOTES7,:DESIGNNOTES8,:DESIGNNOTES9)
#		
#	end 
#	
#	# End of FAQ List
#   next true
 
	# FAQ List
	cmds = ["Level Scaling?", "Why so many Starters?", "Why is Beatha so linear?", "Metagame Wiki Dex?", "EV/IV Allocation?", "All Battle Gimmicks?", "All Pokémon in PSS?", "Interior Buildings?", "Rebalanced Pokémon?", "1 out of 6 Abilities?", "No Poké Marts?", "Pokémon Eggs?", "Infinite Balls?", "Power Leveling?", "No Hard Level Caps?", "Standardized Evolution Methods?", "Fast Travel Phone?", "No Clip?", "Auto Win Policy!?", "Money Printer?", "Story Mode's boring!", "Cancel"]
	c = pbMessage("What do you want answers for?", cmds)
	if c == 0
		pbShowTipCard(:DESIGNNOTES1,:DESIGNNOTES2,:DESIGNNOTES3)
  
	elsif c == 1
		pbShowTipCard(:DESIGNNOTES4,:DESIGNNOTES5,:DESIGNNOTES6)
		
	elsif c == 2
		pbShowTipCard(:DESIGNNOTES7,:DESIGNNOTES8,:DESIGNNOTES9)
		
	elsif c == 3
		pbShowTipCard(:DESIGNNOTES10,:DESIGNNOTES11,:DESIGNNOTES12)

	elsif c == 4
		pbShowTipCard(:DESIGNNOTES13,:DESIGNNOTES14,:DESIGNNOTES15)
		
	elsif c == 5
		pbShowTipCard(:DESIGNNOTES16,:DESIGNNOTES17,:DESIGNNOTES18)

	elsif c == 6
		pbShowTipCard(:DESIGNNOTES19,:DESIGNNOTES20,:DESIGNNOTES21)

	elsif c == 7
		pbShowTipCard(:DESIGNNOTES22,:DESIGNNOTES23,:DESIGNNOTES24)
		
	elsif c == 8
		pbShowTipCard(:DESIGNNOTES25,:DESIGNNOTES26,:DESIGNNOTES27,:DESIGNNOTES28)

	elsif c == 9
		pbShowTipCard(:DESIGNNOTES29,:DESIGNNOTES30,:DESIGNNOTES31)
		
	elsif c == 10
		pbShowTipCard(:DESIGNNOTES32,:DESIGNNOTES33,:DESIGNNOTES34)

	elsif c == 11
		pbShowTipCard(:DESIGNNOTES35,:DESIGNNOTES36,:DESIGNNOTES37)
		
	elsif c == 12
		pbShowTipCard(:DESIGNNOTES38,:DESIGNNOTES39,:DESIGNNOTES40)

	elsif c == 13
		pbShowTipCard(:DESIGNNOTES41,:DESIGNNOTES42,:DESIGNNOTES43,:DESIGNNOTES44)
		
	elsif c == 14
		pbShowTipCard(:DESIGNNOTES45,:DESIGNNOTES46,:DESIGNNOTES47)

	elsif c == 15
		pbShowTipCard(:DESIGNNOTES48,:DESIGNNOTES49,:DESIGNNOTES50)
		
	elsif c == 16
		pbShowTipCard(:DESIGNNOTES51,:DESIGNNOTES52,:DESIGNNOTES53,:DESIGNNOTES54,:DESIGNNOTES55)

	elsif c == 17
		pbShowTipCard(:DESIGNNOTES56,:DESIGNNOTES57,:DESIGNNOTES58,:DESIGNNOTES59)
		
	elsif c == 18
		pbShowTipCard(:DESIGNNOTES60,:DESIGNNOTES61,:DESIGNNOTES62,:DESIGNNOTES63,:DESIGNNOTES64,:DESIGNNOTES65,:DESIGNNOTES66,:DESIGNNOTES67,:DESIGNNOTES68,:DESIGNNOTES69)
	
	elsif c == 19
		pbShowTipCard(:DESIGNNOTES70)
		
	elsif c == 20
		pbShowTipCard(:DESIGNNOTES71,:DESIGNNOTES72,:DESIGNNOTES73,:DESIGNNOTES74,:DESIGNNOTES75,:DESIGNNOTES76,:DESIGNNOTES77)	
		
	end 
	
	# End of FAQ List
    next true
})

#===============================================================================

#===============================================================================
# Level Scale Adjuster 
# Pokemon Decades is designed around the Story Mode Showdown Mode preset. 
# The extra presets only exist, because I am not 
# making a traditional linear Pokemon League Challenge Level Curve.
# Trival Mode exists for those powering through sections they don't care about
# And everything after Story Mode Showdown Mode and before Battle Mode Showdown Mode
# are only there, so those who bitch about a fan game not having difficulty options,
# cannot pull that card with Decades
#===============================================================================
ItemHandlers::UseFromBag.add(:TEACHYTV, proc { |item|
	cmds = ["Presets Info", "Story Mode Showdown Mode", "Hard Mode", "Medium Mode", "Easy Mode", "Stock Mode", "Trivial Mode", "Battle Mode Showdown Mode", "Cancel"]
	c = pbMessage("Select a Level Scale Preset", cmds)
	
	if c == 0
		pbShowTipCard(:LEVELSCALE1,:LEVELSCALE2,:LEVELSCALE3,:LEVELSCALE4,:LEVELSCALE5,:LEVELSCALE6,:LEVELSCALE7)
  
	elsif c == 1
		$game_variables[98] = 4 # 98 is the TRAINER_VARIABLE and WILD_VARIABLE. Both are set here to make life easier. 4 is Story Mode Showdown Mode
		#pbMessage(_INTL("The Level Scale has been set to Story Mode Showdown Mode!"))
		pbSEPlay("GUI trainer card open")
		
	elsif c == 2	
		$game_variables[98] = 3 # 98 is the TRAINER_VARIABLE and WILD_VARIABLE. Both are set here to make life easier. 3 is Hard Mode
		pbSEPlay("GUI trainer card open")
		
	elsif c == 3	
		$game_variables[98] = 2 # 98 is the TRAINER_VARIABLE and WILD_VARIABLE. Both are set here to make life easier. 3 is Medium Mode
		pbSEPlay("GUI trainer card open")	
	
	elsif c == 4	
		$game_variables[98] = 1 # 98 is the TRAINER_VARIABLE and WILD_VARIABLE. Both are set here to make life easier. 1 is Easy Mode
		pbSEPlay("GUI trainer card open")
		
	elsif c == 5	
		$game_variables[98] = 5 # 98 is the TRAINER_VARIABLE and WILD_VARIABLE. Both are set here to make life easier. 5 is Stock Mode
		pbSEPlay("GUI trainer card open")
		
	elsif c == 6	
		$game_variables[98] = 7 # 98 is the TRAINER_VARIABLE and WILD_VARIABLE. Both are set here to make life easier. 7 is Trivial Mode
		pbSEPlay("GUI trainer card open")

	elsif c == 7	
		$game_variables[98] = 6 # 98 is the TRAINER_VARIABLE and WILD_VARIABLE. Both are set here to make life easier. 6 is Battle Mode Showdown Mode
		pbSEPlay("GUI trainer card open")	
		
	end
	
	next 1
})

#===============================================================================

#===============================================================================
# Level Scale Adjuster 
# Pokemon Decades is designed around the Story Mode Showdown Mode preset. 
# The extra presets only exist, because I am not 
# making a traditional linear Pokemon League Challenge Level Curve.
# Trival Mode exists for those powering through sections they don't care about
# And everything after Story Mode Showdown Mode and before Battle Mode Showdown Mode
# are only there, so those who bitch about a fan game not having difficulty options,
# cannot pull that card with Decades
#===============================================================================
ItemHandlers::UseInField.add(:TEACHYTV, proc { |item|
	cmds = ["Presets Info", "Story Mode Showdown Mode", "Hard Mode", "Medium Mode", "Easy Mode", "Stock Mode", "Trivial Mode", "Battle Mode Showdown Mode", "Cancel"]
	c = pbMessage("Select a Level Scale Preset", cmds)
	
	if c == 0
		pbShowTipCard(:LEVELSCALE1,:LEVELSCALE2,:LEVELSCALE3,:LEVELSCALE4,:LEVELSCALE5,:LEVELSCALE6,:LEVELSCALE7)
  
	elsif c == 1
		$game_variables[98] = 4 # 98 is the TRAINER_VARIABLE and WILD_VARIABLE. Both are set here to make life easier. 4 is Story Mode Showdown Mode
		#pbMessage(_INTL("The Level Scale has been set to Story Mode Showdown Mode!"))
		pbSEPlay("GUI trainer card open")
		
	elsif c == 2	
		$game_variables[98] = 3 # 98 is the TRAINER_VARIABLE and WILD_VARIABLE. Both are set here to make life easier. 3 is Hard Mode
		pbSEPlay("GUI trainer card open")
		
	elsif c == 3	
		$game_variables[98] = 2 # 98 is the TRAINER_VARIABLE and WILD_VARIABLE. Both are set here to make life easier. 3 is Medium Mode
		pbSEPlay("GUI trainer card open")	
	
	elsif c == 4	
		$game_variables[98] = 1 # 98 is the TRAINER_VARIABLE and WILD_VARIABLE. Both are set here to make life easier. 1 is Easy Mode
		pbSEPlay("GUI trainer card open")
		
	elsif c == 5	
		$game_variables[98] = 5 # 98 is the TRAINER_VARIABLE and WILD_VARIABLE. Both are set here to make life easier. 5 is Stock Mode
		pbSEPlay("GUI trainer card open")
		
	elsif c == 6	
		$game_variables[98] = 7 # 98 is the TRAINER_VARIABLE and WILD_VARIABLE. Both are set here to make life easier. 7 is Trivial Mode
		pbSEPlay("GUI trainer card open")

	elsif c == 7	
		$game_variables[98] = 6 # 98 is the TRAINER_VARIABLE and WILD_VARIABLE. Both are set here to make life easier. 6 is Battle Mode Showdown Mode
		#$game_variables[78] = 50 # 78 is the Level Scale Constant Variable. Set this value to 5, 30, 50 or 100 for Battle Mode
		
		#cmds2 = ["Little Cup (Lvl.5)","Not Fully Evolved (Lvl.30)","VGC Mode (Lvl.50)","Smogon Mode (Lvl.100)","Cancel"]
		#c2 = pbMessage("Choose a Metagame Level Format", cmds2)
		
		#if c2 == 0
		#	$game_variables[78] = 5 # 78 is the Level Scale Constant Variable. Set this value to 5, 30, 50 or 100 for Battle Mode
		
		#elsif c2 == 1
		#	$game_variables[78] = 30 # 78 is the Level Scale Constant Variable. Set this value to 5, 30, 50 or 100 for Battle Mode
			
		#elsif c2 == 2
		#	$game_variables[78] = 50 # 78 is the Level Scale Constant Variable. Set this value to 5, 30, 50 or 100 for Battle Mode

		#elsif c2 == 3
		#	$game_variables[78] = 100 # 78 is the Level Scale Constant Variable. Set this value to 5, 30, 50 or 100 for Battle Mode
		
		pbSEPlay("GUI trainer card open")	
		
		#end
	end
	
	next true
})

#===============================================================================
# Level Format Book 
# This item exists because setting the Level Constant didn't work
# with the Battle Mode Showdown Mode choice in the Level Scale Adjuster Item.
# And Inverse is here too, at the last minute. It was orgianlly Battle Mode exclusive.
# But I don't want any feasible stone unturned, that someone can use to bitch about the game.
# Due to technical problems and general frustration, this item is just a Inverse Battle Toggle.
# The player still needs to go to Battle Paradise to set the Battle Mode Showdown Mode Level Format.
#===============================================================================
ItemHandlers::UseFromBag.add(:RULEBOOK, proc { |item, bag_screen|
	if $game_switches[99] == true # Game Switch 99 is Inverse Battle Toggle
	  $game_switches[99] = false # Battles follow normal Type Matchups (Inverse Battles are part of a trainer battle's Event setup, requires Deluxe Battle Kit, DBK)
	  pbMessage(_INTL("Trainer Battles only have reverted to regular Type Matchups!"))
	  elsif $game_switches[99] == false # Game Switch 99 is Inverse Battle Toggle
	  $game_switches[99] = true # Battles follow inverted Type Matchups (Inverse Battles are part of a trainer battle's Event setup)
	  pbMessage(_INTL("Trainer Battles only have inverted Type Matchups!"))
	  next 1 
	end
})

ItemHandlers::UseInField.add(:RULEBOOK, proc { |item|
	if $game_switches[99] == true # Game Switch 99 is Inverse Battle Toggle
	  $game_switches[99] = false # Battles follow normal Type Matchups (Inverse Battles are part of a trainer battle's Event setup, requires Deluxe Battle Kit, DBK)
	  pbMessage(_INTL("Trainer Battles only have reverted to regular Type Matchups!"))
	  elsif $game_switches[99] == false # Game Switch 99 is Inverse Battle Toggle
	  $game_switches[99] = true # Battles follow inverted Type Matchups (Inverse Battles are part of a trainer battle's Event setup)
	  pbMessage(_INTL("Trainer Battles only have inverted Type Matchups!"))
	  next 1 
	end
	next true
})

#===============================================================================
# Wild Format Bottle 
# Orginally, this would set wild battles to be Triple, Doubles or Singles.
# But Essentials out of the box does have the technical work required done
# to make wild Triple Battles work. So Singles and Doubles will have to do,
# sadly. :(
#===============================================================================
ItemHandlers::UseFromBag.add(:MAXLURE, proc { |item, bag_screen|
	if $game_switches[93] == true # Game Switch 93 is Wild Doubles Toggle
	  $game_switches[93] = false # Wild Battles go back to normal Singles Format Battles
	  pbMessage(_INTL("Wild Pokémon encountered will be in the Singles Format!"))
	  elsif $game_switches[93] == false # Game Switch 93 Wild Doubles Toggle
	  $game_switches[93] = true # Wild Battles will be in the Doubles Format (Changes applied in Overworld_WildEncounters, Line 216) 
	  pbMessage(_INTL("Wild Pokémon encountered will be in the Doubles Format!"))
	  next 1 
	end
})

ItemHandlers::UseInField.add(:MAXLURE, proc { |item|
	if $game_switches[93] == true # Game Switch 93 is Wild Doubles Toggle
	  $game_switches[93] = false # Wild Battles go back to normal Singles Format Battles
	  pbMessage(_INTL("Wild Pokémon encountered will be in the Singles Format!"))
	  elsif $game_switches[93] == false # Game Switch 93 Wild Doubles Toggle
	  $game_switches[93] = true # Wild Battles will be in the Doubles Format (Changes applied in Overworld_WildEncounters, Line 216)
	  pbMessage(_INTL("Wild Pokémon encountered will be in the Doubles Format!"))
	  next 1
	end
	next true
})
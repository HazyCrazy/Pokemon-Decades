#Everything below is just here to check if your pokémons can learn moves 
  def eggMoves(pkmn)
    babyspecies=pkmn.species
    babyspecies = GameData::Species.get(babyspecies).get_baby_species(false, nil, nil)
    eggmoves=GameData::Species.get_species_form(babyspecies, pkmn.form).egg_moves
    return eggmoves
  end
		
	
  def premoves(pkmn) 
      babyspecies=pkmn.species
      babyspecies = GameData::Species.get(babyspecies).get_baby_species(false, nil, nil)
	  return [] if babyspecies=pkmn.species 
	  pkmn.species=babyspecies
	  moves= []
	  pkmn.getMoveList.each do |m|
        next if m[0] > pkmn.level || pkmn.hasMove?(m[1])
        moves.push(m[1]) if !moves.include?(m[1]) 
      end
      tmoves = []
      if pkmn.first_moves
        for i in pkmn.first_moves
          tmoves.push(i) if !pkmn.hasMove?(i) && !moves.include?(i)
        end
      end
	  moves = tmoves + moves 
      return moves
  end
	
  def getMoveList
    return species_data.moves
  end
  
  def tutorMoves(pkmn)
    return pkmn.species_data.tutor_moves
  end
  
  def hackmoves
    moves=[]
	GameData::Move.each { |i| moves.push(i.id) }
	return moves
  end
  
  def compare_names(move,pkmn)
    pk= pkmn.name[0]
	m= move.real_name[0]
	return (pk==m)	
  end
  
  def validmove(move)
	if $game_switches[BORW]
		if Whitelist[$game_variables[BANVAR]].include?(move) 
			return true
		end
		whitelist=Whitelist[$game_variables[BANVAR]]
		for i in 0...whitelist.length
			if whitelist[i].is_a?(Numeric)
				rmove=0
				GameData::Move.each do |m|
					if m.id==move 
						rmove=m
					end
				end
				if rmove.power> whitelist[i]
					return false
				end
			end
		end
	else
		if Blacklist[$game_variables[BANVAR]].include?(move)
			return false
		end
		blacklist=Blacklist[$game_variables[BANVAR]]
		for i in 0...blacklist.length
			if blacklist[i].is_a?(Numeric)
				rmove=0
				GameData::Move.each do |m|
					if m.id==move 
						rmove=m
					end
				end
				if rmove.power> blacklist[i]
					return false
				end
			end
		end
	end 
	return true
  end
	
  def pbGetRelearnableMoves(pkmn)
    return [] if !pkmn || pkmn.egg? || pkmn.shadowPokemon?
    moves = []
    pkmn.getMoveList.each do |m|
      next if m[0] > pkmn.level || pkmn.hasMove?(m[1])
	  moves.push(m[1]) if !moves.include?(m[1]) && validmove(m[1])
    end
    if pkmn.first_moves
	  tmoves = []
      for i in pkmn.first_moves
		moves.push(i) if !pkmn.hasMove?(i) && !moves.include?(i) && validmove(i)
      end
	  moves = tmoves + moves
    end
	
	######pre-evo moves
	if $game_variables[MOVETUTOR]>=0 
	  specie=pkmn.species
      babyspecies=pkmn.species
      babyspecies = GameData::Species.get(babyspecies).get_baby_species(false, nil, nil) 
	  pkmn.species=babyspecies
	  pmoves=[]
	  pkmn.getMoveList.each do |m|
        next if m[0] > pkmn.level || pkmn.hasMove?(m[1])
		pmoves.push(m[1]) if !moves.include?(m[1]) && validmove(m[1])
      end
	  moves=pmoves + moves
	  pkmn.species=specie
	end
    
    # add tutor moves, eggmoves and pre evolution moves
    if $game_variables[MOVETUTOR]>=1				#modify to == if you want to make distinct NPCs
      eggmoves=eggMoves(pkmn)
	  for i in eggmoves
		  moves.push(i) if !pkmn.hasMove?(i) && !moves.include?(i) && validmove(i) 
      end
    end
    if $game_variables[MOVETUTOR]>=2				#modify to == if you want to make distinct NPCs
      tutormoves= tutorMoves(pkmn)
	  for i in tutormoves
		  moves.push(i) if !pkmn.hasMove?(i) && !moves.include?(i) && validmove(i)
      end
    end
	if $game_variables[MOVETUTOR]==3	#hackmon
	  hmoves = hackmoves
	  for i in hmoves 
		  moves.push(i) if !pkmn.hasMove?(i) && !moves.include?(i) && validmove(i)
      end
	end
	if $game_variables[MOVETUTOR]==4    #Stabmon
	  smoves=[]
	  if i.respond_to?(:maxMove?)
		GameData::Move.each { |i| smoves.push(i.id) if (i.type==pkmn.types[0] || i.type==pkmn.types[1]) && (!i.maxMove? && !i.zMove?) }	
	  else 
		GameData::Move.each { |i| smoves.push(i.id) if (i.type==pkmn.types[0] || i.type==pkmn.types[1])}
	  end
	  for i in smoves
		  moves.push(i) if !pkmn.hasMove?(i) && !moves.include?(i) && validmove(i) 
	  end
	end
	if $game_variables[MOVETUTOR]==5    #Alphabetmon
	  smoves=[]
	  if i.respond_to?(:maxMove?)
		GameData::Move.each { |i| smoves.push(i.id) if compare_names(i,pkmn) && (!i.maxMove? && !i.zMove?)}	
	  else 
		GameData::Move.each { |i| smoves.push(i.id) if compare_names(i,pkmn)}
	  end
	  for i in smoves
		  moves.push(i) if !pkmn.hasMove?(i) && !moves.include?(i) && validmove(i) 
	  end
	end	
    if $game_variables[MOVETUTOR]>=6	#universal move tutor		
		for i in UCmoves
		    moves.push(i) if !pkmn.hasMove?(i) && !moves.include?(i) && validmove(i)
		end
	end
	if $game_variables[MOVETUTOR]>=7	#custom move tutor	
		pmoves=[:JUDGMENT]
		if Poke.include?(pkmn.species)
			for i in pmoves
				moves.push(i) if !pkmn.hasMove?(i) && !moves.include?(i) && validmove(i)
			end
		end
	end		
    moves.sort! { |a, b| a.downcase <=> b.downcase } #sort moves alphabetically
    return moves | []   # remove duplicates
  end
  
  def can_learn_move(pkmn)
	return false if pkmn.egg? || pkmn.shadowPokemon?
	return true if $game_variables[MOVETUTOR]==3
	moves = pbGetRelearnableMoves(pkmn)
    if moves!=[]
	 return true
	else
	 return false
	end
  end 
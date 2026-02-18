
#===============================================================================
# NOTE: In Gen 7+, the Day Care is replaced by the Pokémon Nursery, which works
#       in much the same way except deposited Pokémon no longer gain Exp because
#       of the player walking around and, in Gen 8+, deposited Pokémon are able
#       to learn egg moves from each other if they are the same species. In
#       Essentials, this code can be used for both facilities, and these
#       mechanics differences are set by some Settings.
# NOTE: The Day Care has a different price than the Pokémon Nursery. For the Day
#       Care, you are charged when you withdraw a deposited Pokémon and you pay
#       an amount based on how many levels it gained. For the Nursery, you pay
#       $500 up-front when you deposit a Pokémon. This difference will appear in
#       the Day Care Lady's event, not in these scripts.
#===============================================================================







class DayCare
  #=============================================================================
  # Code that generates an egg based on two given Pokémon.
  #=============================================================================
  module EggGenerator
    module_function
	
	  if PluginManager.installed?("Essentials Deluxe")	
    
		def generate(mother, father)
		  if mother.male? || father.female? || mother.genderless?
			mother, father = father, mother
		  end
		  mother_data = [mother, fluid_egg_group?(mother.species_data.egg_groups)]
		  father_data = [father, fluid_egg_group?(father.species_data.egg_groups)]
		  species_parent = (mother_data[1]) ? father : mother
		  baby_species = determine_egg_species(species_parent.species, mother, father)
		  mother_data.push(mother.species_data.breeding_can_produce?(baby_species))
		  father_data.push(father.species_data.breeding_can_produce?(baby_species))
		  egg = generate_basic_egg(baby_species)
		  inherit_form(egg, species_parent, mother_data, father_data)
		  inherit_nature(egg, mother, father)
		  inherit_ability(egg, mother_data, father_data)
		  inherit_moves(egg, mother_data, father_data)
		  inherit_IVs(egg, mother, father)
		  inherit_hptype(egg, mother, father)
		  inherit_poke_ball(egg, mother_data, father_data)
		  inherit_birthsign(egg, mother, father) if PluginManager.installed?("Pokémon Birthsigns")
		  set_shininess(egg, mother, father)
		  set_pokerus(egg)
		  egg.calc_stats
		  return egg
		end


	  else	
		

		def generate(mother, father)
		  # Determine which Pokémon is the mother and which is the father
		  # Ensure mother is female, if the pair contains a female
		  # Ensure father is male, if the pair contains a male
		  # Ensure father is genderless, if the pair is a genderless with Ditto
		  if mother.male? || father.female? || mother.genderless?
			mother, father = father, mother
		  end
		  mother_data = [mother, mother.species_data.egg_groups.include?(:Ditto)]
		  father_data = [father, father.species_data.egg_groups.include?(:Ditto)]
		  # Determine which parent the egg's species is based from
		  species_parent = (mother_data[1]) ? father : mother
		  # Determine the egg's species
		  baby_species = determine_egg_species(species_parent.species, mother, father)
		  mother_data.push(mother.species_data.breeding_can_produce?(baby_species))
		  father_data.push(father.species_data.breeding_can_produce?(baby_species))
		  # Generate egg
		  egg = generate_basic_egg(baby_species)
		  # Inherit properties from parent(s)
		  inherit_form(egg, species_parent, mother_data, father_data)
		  inherit_nature(egg, mother, father)
		  inherit_ability(egg, mother_data, father_data)
		  inherit_moves(egg, mother_data, father_data)
		  inherit_IVs(egg, mother, father)
		  inherit_hptype(egg, mother, father)  # DemICE Inddependent Hidden Pwer Type edit
		  inherit_poke_ball(egg, mother_data, father_data)
		  # Calculate other properties of the egg
		  set_shininess(egg, mother, father)   # Masuda method and Shiny Charm
		  set_pokerus(egg)
		  # Recalculate egg's stats
		  egg.calc_stats
		  return egg
		end

	  end	
	 
	# DemICE Inddependent Hidden Pwer Type  
    def inherit_hptype(egg, mother, father)
      new_hptypes = []
      new_hptypes.push(mother.hptype) if mother.hasItem?(:DESTINYKNOT)
      new_hptypes.push(father.hptype) if father.hasItem?(:DESTINYKNOT)
      return if new_hptypes.empty?
      egg.hptype = new_hptypes.sample
	  egg.sethptypeflag  # a pokemon with an inherited hidden power counts as one with an already altered hidden power
    end	  

  end	
end	
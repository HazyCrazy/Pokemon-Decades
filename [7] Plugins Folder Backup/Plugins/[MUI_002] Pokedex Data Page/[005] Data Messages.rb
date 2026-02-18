#===============================================================================
# Related to displaying various text in the message box of the Data page.
#===============================================================================
class PokemonPokedexInfo_Scene
  #-----------------------------------------------------------------------------
  # Draws the relevant text relative to the cursor position.
  #-----------------------------------------------------------------------------
  def pbDrawDataNotes(cursor = nil)
    t = DATA_TEXT_TAGS
    cursor = @cursor if !cursor
    path = Settings::POKEDEX_DATA_PAGE_GRAPHICS_PATH + "cursor"
    species = GameData::Species.get_species_form(@species, @form)
    overlay = @sprites["data_overlay"].bitmap
    overlay.clear
    case cursor
    when :encounter then text = pbDataTextEncounters(path, species, overlay)
    when :general   then text = pbDataTextGeneral(path, species, overlay)
    when :stats     then text = pbDataTextStats(path, species, overlay)
    when :family    then text = pbDataTextFamily(path, species, overlay)
    when :habitat   then text = pbDataTextHabitat(path, species, overlay)
    when :shape     then text = pbDataTextShape(path, species, overlay)
    when :egg       then text = pbDataTextEggGroup(path, species, overlay)
    when :item      then text = pbDataTextItems(path, species, overlay)
    when :ability
      pbDrawImagePositions(overlay, [[path, 248, 240, 0, 244, 116, 44]])
      text = t[0] + "Abilities\n"
      if $player.owned?(@species)
        text << "View all abilities available to this species."
      else
        text << "Unknown."
      end
    when :moves
      pbDrawImagePositions(overlay, [[path, 376, 240, 0, 244, 116, 44]])
      text = t[0] + "Moves\n"
      if $player.owned?(@species)
        text << "View all moves this species may learn."
      else
        text << "Unknown."
      end
    end
    drawFormattedTextEx(overlay, 34, 294, 446, _INTL("{1}", text))
  end
  
  
  ##############################################################################
  #
  # These methods draw text when the cursor is highlighting a selection.
  #
  ##############################################################################
  
  
  #=============================================================================
  # Determines the encounter text to display. (Cursor == :encounter)
  #=============================================================================
  def pbDataTextEncounters(path, species, overlay)
    t = DATA_TEXT_TAGS
    text = t[0] + "Encounters\n"
    text << "Number Defeated: " + "#{$player.pokedex.defeated_count(species.id)}\n"
    text << "Number Captured: " + "#{$player.pokedex.caught_count(species.id)}\n"
    return text
  end
  
  #=============================================================================
  # Determines the general text to display. (Cursor == :general)
  #=============================================================================
  def pbDataTextGeneral(path, species, overlay, inMenu = false)
    t = DATA_TEXT_TAGS
    pbDrawImagePositions(overlay, [[path, 0, 36, 0, 0, 512, 56]])
    owned = $player.owned?(@species)
    text = t[0] + "General Statistics\n"
    if owned
      chance = species.catch_rate
      c = ((chance / 256.0) * 100).floor
      c = 1 if c < 1
      text << "Capture Success Rate: #{c}%\n"
      gender = "This species "
      case species.gender_ratio
      when :AlwaysMale   then gender << "is " + t[2] + "always male"
      when :AlwaysFemale then gender << "is " + t[1] + "always female"
      when :Genderless   then gender << "is " + "genderless"
      else
        chance = GameData::GenderRatio.get(species.gender_ratio).female_chance
        if chance
          f = ((chance / 256.0) * 100).round
          m = (100 - f)
          if m > f      # Male odds are higher than female.
            gender << "is " + t[2] + "#{m.to_s}% likely to be male"
          elsif f > m   # Female odds are higher than male.
            gender << "is " + t[1] + "#{f.to_s}% likely to be female"
          else          # Gender odds are equal.
            gender << "has an equal gender ratio"
          end
        else
          gender = ""
        end
      end
      text << gender + t[0] + "." if gender != ""
      pbDrawTextPositions(overlay, [
        [_INTL("View Compatible"), Graphics.width - 34, 292, :right, Color.new(0, 112, 248), Color.new(120, 184, 232)]
      ]) if !inMenu && !@data_hash[:general].empty?
    else
      text << "Unknown."
    end
    return text
  end
  
  #=============================================================================
  # Determines the wild held item text to display. (Cursor == :item)
  #=============================================================================
  def pbDataTextItems(path, species, overlay)
    t = DATA_TEXT_TAGS
    pbDrawImagePositions(overlay, [[path, 224, 166, 432, 208, 74, 72]])
    owned = $player.owned?(@species)
    text = ""
    if owned
      @data_hash[:item].keys.each_with_index do |r, a|
        next if @data_hash[:item][r].empty?
        text << ", " if !nil_or_empty?(text)
        @data_hash[:item][r].each_with_index do |item, i|
          text << t[1] + GameData::Item.get(item).name + t[0]
          text << ", " if i < @data_hash[:item][r].length - 1
        end
      end
      if nil_or_empty?(text)
        text << "---" 
      else
        pbDrawTextPositions(overlay, [
          [_INTL("View Details"), Graphics.width - 34, 292, :right, Color.new(0, 112, 248), Color.new(120, 184, 232)]
        ])
      end
    else
      text << "Unknown."
    end
    text = t[0] + "Held Items\n" + text
    return text
  end
  
  #=============================================================================
  # Determines the base stat text to display. (Cursor == :stats)
  #=============================================================================
  def pbDataTextStats(path, species, overlay, s2 = nil)
    t = DATA_TEXT_TAGS
    pbDrawImagePositions(overlay, [[path, 0, 90, 0, 56, 222, 188]])
    owned = $player.owned?(@species)
    text = t[0] + "Base Stats" 
    if owned
      nt = (s2 && s2.base_stat_total == species.base_stat_total) ? t[2] : t[1]
      text << " - " + nt + _ISPRINTF("Total: {1:3d}", species.base_stat_total)
      s1 = species.base_stats
      s2 = s2.base_stats if s2
      stats_order = [[:HP, :SPEED], [:ATTACK, :DEFENSE], [:SPECIAL_ATTACK, :SPECIAL_DEFENSE]]
      stats_order.each_with_index do |st, i|
        names = values = ""
        st.each_with_index do |s, j|
          stat = (s == :SPECIAL_ATTACK) ? "Sp. Atk" : (s == :SPECIAL_DEFENSE) ? "Sp. Def" : GameData::Stat.get(s).name
          nt = (s2 && s2[s] == s1[s]) ? t[2] : t[0]
          names  += nt + _INTL("{1}", stat)
          values += nt + _ISPRINTF("{1:3d}", s1[s])
          names  += "\n" if j == 0
          values += "\n" if j == 0
        end
        nameX = 34 + 158 * i
        valueX = nameX + 94
        drawFormattedTextEx(overlay, nameX, 324, 76, _INTL("{1}", names))
        drawFormattedTextEx(overlay, valueX, 324, 52, _INTL("{1}", values))
      end
      pbDrawTextPositions(overlay, [
        [_INTL("View Compatible"), Graphics.width - 34, 292, :right, Color.new(0, 112, 248), Color.new(120, 184, 232)]
      ]) if !s2 && !@data_hash[:stats].empty?
    else
      text << "\nUnknown."
    end
    return text
  end
  
  #=============================================================================
  # Determines the habitat text to display. (Cursor == :habitat)
  #=============================================================================
  def pbDataTextHabitat(path, species, overlay, s2 = nil)
    t = DATA_TEXT_TAGS
    pbDrawImagePositions(overlay, [[path, 440, 166, 432, 208, 74, 72]])
    owned = $player.owned?(@species)
    text = t[0] + "Habitat\n"
    if owned
      habitat = GameData::Habitat.get(species.habitat)
      nt = (s2 && s2 == habitat.id) ? t[2] : t[1]
      name = habitat.name.downcase
      text << "This species may be found "
      case habitat.id
      when :Grassland    then text << "roaming within wide open " + nt + _INTL("{1}", name) + t[0] + " areas."
      when :Forest       then text << "within densely wooded areas, such as a " + nt + _INTL("{1}", name) + t[0] + "."
      when :WatersEdge   then text << "within areas near the " + nt + _INTL("{1}", name) + t[0] + "."
      when :Sea          then text << "roaming above or below bodies of water, such as the " + nt + _INTL("{1}", name) + t[0] + "."
      when :Cave         then text << "within dark and secluded areas, such as a " + nt + _INTL("{1}", name) + t[0] + "."
      when :Mountain     then text << "up high, scaling the sides of " + nt + _INTL("{1}", name) + t[0] + " ranges."
      when :RoughTerrain then text << "within harsher locales with " + nt + _INTL("{1}", name) + t[0] + "."
      when :Urban        then text << "near man-made structures or within " + nt + _INTL("{1}", name) + t[0] + " areas."
      when :Rare         then text << "only in very " + nt + _INTL("{1}", name) + t[0] + " situations or locations."
      else                    text << "in an unknown location."
      end
      pbDrawTextPositions(overlay, [
        [_INTL("View Compatible"), Graphics.width - 34, 292, :right, Color.new(0, 112, 248), Color.new(120, 184, 232)]
      ]) if !s2 && !@data_hash[:habitat].empty?
    else
      text << "Unknown."
    end
    return text
  end
  
  #=============================================================================
  # Determines the body color & shape text to display. (Cursor == :shape)
  #=============================================================================
  def pbDataTextShape(path, species, overlay, s2 = nil)
    t = DATA_TEXT_TAGS
    pbDrawImagePositions(overlay, [[path, 368, 166, 432, 208, 74, 72]])
    text = t[0] + "Morphology\n"
    color = GameData::BodyColor.get(species.color)
    nt = (s2 && s2[0] == color.id) ? t[2] : t[1]
    name = color.name.downcase
    text << "This species is primarily " + nt + _INTL("{1}", name) + t[0] + " in color, and its body "
    shape = GameData::BodyShape.get(species.shape)
    nt = (s2 && s2[1] == shape.id) ? t[2] : t[1]
    name = shape.name.downcase
    case shape.id
    when :Head, :HeadArms, :HeadBase, :HeadLegs
      text << "shape is just a " + nt + _INTL("{1}", name) + t[0] + "."
    when :Bipedal, :BipedalTail, :Quadruped, :Multiped, :MultiBody, :MultiWinged, :Winged, :Serpentine
      text << "has a " + nt + _INTL("{1}", name) + t[0] + " shape."
    when :Insectoid
      text << "has an " + nt + _INTL("{1}", name) + t[0] + " shape."
    when :Finned
      text << "is " + nt + _INTL("{1}", name) + t[0] + " and shaped for swimming."
    else
      text << "shape can't be classified."
    end
    if !s2 && $player.owned?(@species) && !@data_hash[:shape].empty?
      pbDrawTextPositions(overlay, [
        [_INTL("View Compatible"), Graphics.width - 34, 292, :right, Color.new(0, 112, 248), Color.new(120, 184, 232)]
      ])
    end
    return text
  end
  
  #=============================================================================
  # Determines the egg group text to display. (Cursor == :egg)
  #=============================================================================
  def pbDataTextEggGroup(path, species, overlay, s2 = nil)
    return pbDataTextMoveSource(path, species, overlay) if @viewingMoves
    t = DATA_TEXT_TAGS
    pbDrawImagePositions(overlay, [[path, 296, 166, 432, 208, 74, 72]])
    owned = $player.owned?(@species)
    text = t[0] + "Breeding\n"
    if owned
      text << "This species "
      groups = species.egg_groups
      groups = [:None] if species.gender_ratio == :Genderless && 
                          !(groups.include?(:Ditto) || groups.include?(:Undiscovered))
      if groups.include?(:None)
        data = GameData::EggGroup.get(:Ditto)
        name = (Settings::ALT_EGG_GROUP_NAMES) ? data.alt_name : data.name
        text << "is genderless, and may only breed with species in the " + t[1] + "#{name}" + t[0] + " group."
      elsif groups.include?(:Ditto)
        data = GameData::EggGroup.get(:Ditto)
        name = (Settings::ALT_EGG_GROUP_NAMES) ? data.alt_name : data.name
        text << "is in the " + t[1] + "#{name}" + t[0] + " group, and may breed with species in all other groups."
      elsif groups.include?(:Undiscovered) || groups.empty?
        data = GameData::EggGroup.get(:Undiscovered)
        name = (Settings::ALT_EGG_GROUP_NAMES) ? data.alt_name : data.name
        text << "is in the " + t[1] + "#{name}" + t[0] + " group, and is incapable of breeding."
      else
        text << "may only breed with species in the "
        groups.each_with_index do |group, i|
          data = GameData::EggGroup.get(group)
          name = (Settings::ALT_EGG_GROUP_NAMES) ? data.alt_name : data.name
          nt = (s2 && s2.include?(group)) ? t[2] : t[1]
          text << nt + "#{name} " + t[0]
          if i < groups.length - 1
            text << "or "
          else
            total = (i > 0) ? "groups." : "group."
            text << total
          end
        end
      end
      pbDrawTextPositions(overlay, [
        [_INTL("View Compatible"), Graphics.width - 34, 292, :right, Color.new(0, 112, 248), Color.new(120, 184, 232)]
      ]) if !s2 && !@data_hash[:egg].empty?
    else
      text << "Unknown."
    end
    return text
  end
  
  #=============================================================================
  # Determines the family & evolution method text to display. (Cursor == :family)
  #=============================================================================
  def pbDataTextFamily(path, species, overlay, inMenu = false)
    t = DATA_TEXT_TAGS
    #---------------------------------------------------------------------------
    # Determines how many species icons to draw.
    #---------------------------------------------------------------------------
    if @sprites["familyicon1"].visible && @sprites["familyicon2"].visible
      pbDrawImagePositions(overlay, [[path, 228, 90, 222, 56, 284, 76]])
    elsif @sprites["familyicon1"].visible
      pbDrawImagePositions(overlay, [[path, 280, 90, 222, 132, 180, 76]])
    else
      pbDrawImagePositions(overlay, [[path, 332, 90, 402, 132, 76, 76]])
    end
    text = pbDrawSpecialFormText(species) # If this species is a special form.
    if nil_or_empty?(text)
      prevo = species.get_previous_species
      #-------------------------------------------------------------------------
      # These unique forms are treated as if they have no family trees.
      #-------------------------------------------------------------------------
      if [:PICHU_2, :FLOETTE_5, :GIMMIGHOUL_1].include?(species.id) ||
         species.species == :PIKACHU && (8..15).include?(species.form)
        prevo = species.species
      end
      #-------------------------------------------------------------------------
      # When the species is the base species in a family tree.
      #-------------------------------------------------------------------------
      if prevo == species.species
        text = t[0] + "Evolution Paths\n"
        family_ids = []
        evos = species.get_evolutions
        evos.each do |evo|
          next if family_ids.include?(evo[0]) || evo[1] == :None
          family_ids.push(evo[0])
          species.branch_evolution_forms.each do |form|
            try_species = GameData::Species.get_species_form(evo[0], form)
            try_evos = try_species.get_evolutions
            next if try_evos.empty?
            try_evos.each do |try_evo|
              next if family_ids.include?(try_evo[0]) || try_evo[1] == :None
              family_ids.push(try_evo[0])
            end
          end
        end
        if family_ids.empty?          # Species doesn't evolve.
          text << "Does not evolve."
        else                          # Species does evolve.
          family_ids.each_with_index do |fam, i|  
            name = ($player.seen?(fam)) ? GameData::Species.get(fam).name : "????"
            text << t[1] + name
            if i < family_ids.length - 1
              if fam == GameData::Species.get(family_ids[i + 1]).get_previous_species
                text << t[0] + "=> "  # Shows evolution pathway.
              else
                text << t[0] + ", "   # Shows a new pathway.
              end				
            end
          end
        end
      #-------------------------------------------------------------------------
      # When the species is an evolved species.
      #-------------------------------------------------------------------------
      else
        #-----------------------------------------------------------------------
        # Compiles the actual description for this species' evolution method.
        # Some species require special treatment due to unique evolution traits.
        #-----------------------------------------------------------------------
        form = (species.default_form >= 0) ? species.default_form : species.form
        prevo_data = GameData::Species.get_species_form(prevo, form)
        if species.species == :ALCREMIE
          name = t[1] + "#{prevo_data.name}" + t[0]
          text << "Use various " + t[2] + "Sweets" + t[0] + " on #{name}."
        else
          index = 0
          prevo_data.get_evolutions(true).each do |evo|
            next if evo[0] != species.species
            next if evo[1] == :None
            if species.species == :URSHIFU && evo[1] == :Item
              next if evo[2] != [:SCROLLOFDARKNESS, :SCROLLOFWATERS][species.form]
            end
            spec = ($player.seen?(prevo_data.id)) ? prevo_data.id : nil
            data = GameData::Evolution.get(evo[1])
            text << " " if index > 0
            text << data.description(spec, evo[0], evo[2], nil_or_empty?(text), true, t)
            break if index > 0
            index += 1
          end
          case species.species
          when :LYCANROC
            case species.form
            when 0 then text << " Must be day for this form."
            when 1 then text << " Must be night for this form."
            when 2 then text << " Requires " + t[2] + GameData::Ability.get(:OWNTEMPO).name + t[0] + "."
            end
          when :TOXTRICITY
            text << " Form depends on " + t[2] + "Nature" + t[0] + "."
          end
        end
        heading = t[0] + "Evolution Method"
        if species.form_name
          Settings::REGIONAL_NAMES.each do |region|
            next if !species.form_name.include?(region)
            heading = t[0] + "#{region} Evolution"
          end
        end
        evos = species.evolutions
        if inMenu && evos[-1][0] == prevo && !evos.any? { |evo| evo[0] != prevo && evo[1] != :None }
          heading << " (Final stage)"
        end
        text = heading + "\n" + text
      end
      if !inMenu && $player.owned?(@species) && !@data_hash[:family].empty?
        pbDrawTextPositions(overlay, [
          [_INTL("View Family"), Graphics.width - 34, 292, :right, Color.new(0, 112, 248), Color.new(120, 184, 232)]
        ])
      end
    end
    return text
  end
  
  #=============================================================================
  # Draws text related to special forms such as Mega Evolutions.
  #=============================================================================
  def pbDrawSpecialFormText(species)
    text = ""
    t = DATA_TEXT_TAGS
    special_form, check_form, check_item = pbGetSpecialFormData(species)
    if special_form
      base_data = GameData::Species.get_species_form(species.species, check_form)
      form_name = base_data.form_name
      if nil_or_empty?(form_name)
        spname = base_data.name
      elsif form_name.include?(base_data.name)
        spname = form_name
      else
        spname = form_name + " " + base_data.name
      end
      case special_form
      #-------------------------------------------------------------------------
      # Mega forms
      #-------------------------------------------------------------------------
      when :mega
        text = t[0] + "Mega Evolution Method\n"
        text << t[0] + "Available when " + t[1] + "#{spname}" + t[0]
        if species.mega_stone
          param = GameData::Item.get(check_item).name
          text << " triggers its held " + t[2] + "#{param}" + t[0] + "."
        else
          param = GameData::Move.get(species.mega_move).name
          text << " has the move " + t[2] + "#{param}" + t[0] + "."
        end
      #-------------------------------------------------------------------------
      # Primal forms
      #-------------------------------------------------------------------------
      when :primal
        text = t[0] + "Primal Reversion Method\n"
        text << t[0] + "Occurs when " + t[1] + "#{spname}"
        item = GameData::Item.try_get(check_item)
        param = (item) ? t[2] + item.name + t[0] : "Primal orb"
        text << t[0] + " enters battle with its held " + "#{param}" + "."
      #-------------------------------------------------------------------------
      # Ultra Burst forms
      #-------------------------------------------------------------------------
      when :ultra
        spname = "a fused form of #{base_data.name}" if species.species == :NECROZMA
        text = t[0] + "Ultra Burst Method\n"
        text << t[0] + "Available when " + t[1] + "#{spname}" + t[0]
        item = GameData::Item.try_get(check_item)
        param = (item) ? t[2] + item.name + t[0] : "Ultra item"
        text << " triggers its held " + "#{param}" + "."
      #-------------------------------------------------------------------------
      # Gigantamax forms
      #-------------------------------------------------------------------------
      when :gmax
        spname = "any form of #{base_data.name}" if species.has_flag?("AllFormsShareGmax") || species.species == :TOXTRICITY
        text = t[0] + "Gigantamax Method\n"
        text << t[0] + "Available when " + t[1] + "#{spname}" + t[0]
        text << " has " + t[2] + "G-Max Factor" + t[0] + "."
      #-------------------------------------------------------------------------
      # Eternamax forms
      #-------------------------------------------------------------------------
      when :emax
        text = t[0] + "Eternamax Method\n"
        text << "Unknown."
      #-------------------------------------------------------------------------
      # Terastal forms
      #-------------------------------------------------------------------------
      when :tera
        text = t[0] + "Terastal Form Method\n"
        text << t[0] + "Available when " + t[1] + "#{spname}" + t[0] + " triggers Terastallization."
      end
    end
    return text
  end
  
  
  ##############################################################################
  #
  # These methods draw text only when a selection has been opened to view.
  #
  ##############################################################################

  
  #=============================================================================
  # Determines item rarity text to display. (Viewing item compatibility)
  #=============================================================================
  def pbDataTextItemSource(path, species, overlay, item)
    t = DATA_TEXT_TAGS
    itemName = GameData::Item.get(item).name
    text = t[2] + "#{itemName}\n"
    text << t[0] + "This is "
    if species.wild_item_common.include?(item)
      text << "a " + t[1] + "common"     # Common items.
    elsif species.wild_item_uncommon.include?(item)
      text << "an " + t[1] + "uncommon"  # Uncommon items.
    elsif species.wild_item_rare.include?(item)
      text << "a " + t[1] + "rare"       # Rare items.
    end
    text << t[0] + " item that may be held by this species."
    return text
  end
  
  #=============================================================================
  # Determines ability availability text to display. (Viewing ability compatibility)
  #=============================================================================
  def pbDataTextAbilitySource(path, species, overlay, ability)
    t = DATA_TEXT_TAGS
    abilityName = GameData::Ability.get(ability).name
    text = t[2] + "#{abilityName}\n"
    text << t[0] + "Available as "
    #---------------------------------------------------------------------------
    # Natural abilities.
    #---------------------------------------------------------------------------
    if species.abilities.include?(ability)
      case species.abilities.length
      when 1 # Species only has one base ability.
        if species.hidden_abilities.empty? || 
           species.mega_stone || species.mega_move
          text << "the " + t[1] + "only"
        else
          text << "the " + t[1] + "base"
        end
      when 2 # Species has two base abilities.
        if species.abilities[0] == ability
          text << "the " + t[1] + "primary"
        else
          text << "the " + t[1] + "secondary"
        end
      end
    #---------------------------------------------------------------------------
    # Hidden abilities.
    #---------------------------------------------------------------------------
    elsif species.hidden_abilities.include?(ability)
      text << "a " + t[1] + "hidden"
    else
      text << "a " + t[1] + "special" 
    end
    text << t[0] + " ability for this species."
    return text
  end
  
  #=============================================================================
  # Determines move learning text to display. (Viewing move compatibility)
  #=============================================================================
  def pbDataTextMoveSource(path, species, overlay)
    t = DATA_TEXT_TAGS
    moveID = pbCurrentMoveID
    moveName = GameData::Move.get(moveID).name
    text = t[2] + "#{moveName}\n"
    text << t[0] + "Learned by this species "
    methods = []
    #---------------------------------------------------------------------------
    # Move appears in the species' learnset.
    #---------------------------------------------------------------------------
    species.moves.each do |m|
      next if m[1] != moveID
      case m[0]
      when -1 then method = "through " + t[1] + "move relearning" + t[0]  # Gen 9 move relearning.
      when 0  then method = "upon " + t[1] + "evolution" + t[0]           # Evolution move.
      else         method = "at " + t[1] + "level #{m[0]}" + t[0]         # Level-up move.
      end
      methods.push(method)
      break	  
    end
    text << "through " if methods.empty?
    #---------------------------------------------------------------------------
    # Move is learned as an Egg Move.
    #---------------------------------------------------------------------------
    if species.get_inherited_moves.include?(moveID)
      method = t[1] + "inheritance" + t[0]
      methods.push(method)
    end
    #---------------------------------------------------------------------------
    # Move is learned via TM or move tutor.
    #---------------------------------------------------------------------------
    if species.tutor_moves.include?(moveID)
      method = "visiting a " + t[1] + "move tutor" + t[0]
      # If none of the below applies, assume this is a move tutor move.
      GameData::Item.each do |item|
        next if !item.is_machine?
        next if item.move != moveID
        if $bag.has?(item.id)  # Player owns required machine.
          method = "using " + t[1] + item.name + t[0]
        elsif item.is_HM?      # Move is taught via HM.
          method = "using an " + t[1] + "HM" + t[0]
        elsif item.is_TM?      # Move is taught via TM.
          method = "using a " + t[1] + "TM" + t[0]
        elsif item.is_TR?      # Move is taught via TR.
          method = "using a " + t[1] + "TR" + t[0]
        end
        break
      end
      methods.push(method)
    end
    #---------------------------------------------------------------------------
    # Fixes up grammar and phrasing of learning methods.
    #---------------------------------------------------------------------------
    methods.push("unknown means") if methods.empty?
    methods.each_with_index do |m, i|
      if i > 0 && i == methods.length - 1
        if m.include?("inheritance")
          text << " or through "
        else
          text << " or by "
        end
      end
      text << m
      text << ", " if i == 0 && methods.length > 2
    end
    text << "."
    return text
  end
end
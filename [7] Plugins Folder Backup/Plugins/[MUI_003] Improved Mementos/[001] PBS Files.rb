#===============================================================================
# Compiler.
#===============================================================================
# Adds new data to validate when compiling ribbons and trainers.
#-------------------------------------------------------------------------------
module Compiler
  def validate_all_compiled_ribbons
    memento_names = []
    memento_descriptions = []
    memento_titles = []
    GameData::Ribbon.each do |memento|
      memento.prev_ranks.each do |other_memento|
        next if GameData::Ribbon.exists?(other_memento)
        raise _INTL("'{1}' is not a defined memento ({2}, PreviousRanks).", other_memento.to_s, memento.id)
      end
      memento_names.push(memento.real_name)
      memento_descriptions.push(memento.real_description)
      memento_titles.push(memento.real_title)
    end
    MessageTypes.setMessagesAsHash(MessageTypes::RIBBON_NAMES, memento_names)
    MessageTypes.setMessagesAsHash(MessageTypes::RIBBON_DESCRIPTIONS, memento_descriptions)
    MessageTypes.setMessagesAsHash(MessageTypes::MEMENTO_TITLES, memento_titles)
  end
  
  alias memento_validate_compiled_trainer validate_compiled_trainer
  def validate_compiled_trainer(hash)
    memento_validate_compiled_trainer
    hash[:pokemon].each do |pkmn|
      if pkmn[:size] && pkmn[:size] > 255
        raise _INTL("Bad size: {1} (must be 0-255).\n{2}", pkmn[:size], FileLineData.linereport)
      end
    end
  end
end


#===============================================================================
# Trainer PBS data.
#===============================================================================
# Adds size and memento attributes to NPC trainer's Pokemon.
#-------------------------------------------------------------------------------
module GameData
  class Trainer
    SUB_SCHEMA["Size"]    = [:size,    "u"]
    SUB_SCHEMA["Memento"] = [:memento, "e", :Ribbon]
	
    alias memento_to_trainer to_trainer
    def to_trainer
      trainer = memento_to_trainer
      trainer.party.each_with_index do |pkmn, i|
        pkmn.scale = @pokemon[i][:size] if @pokemon[i][:size]
        pkmn.memento = (pkmn.shadowPokemon?) ? nil : @pokemon[i][:memento]
        pkmn.calc_stats
      end
      return trainer
    end
  end
end

module TrainerPokemonProperty
  TrainerPokemonProperty.singleton_class.alias_method :memento_editor_settings, :editor_settings
  def self.editor_settings(initsetting)
    initsetting = {:species => nil, :level => 10} if !initsetting
    oldsetting, keys = self.memento_editor_settings(initsetting)
    [:size, :memento].each do |sym|
      oldsetting.push(initsetting[sym])
      keys.push(sym)
    end
    return oldsetting, keys
  end
  
  TrainerPokemonProperty.singleton_class.alias_method :memento_editor_properties, :editor_properties
  def self.editor_properties(oldsetting)
    properties = self.memento_editor_properties(oldsetting)
    properties.concat([
      [_INTL("Size"),    LimitProperty2.new(255),       _INTL("Size variance of the Pokémon (0-255).")],
      [_INTL("Memento"), GameDataProperty.new(:Ribbon), _INTL("The memento adorned on the Pokémon. This determines its title.")]
    ])
    return properties
  end
end
class PokemonSystem
  attr_accessor :battlesize
 
  alias oldinitialize initialize

  def initialize
    oldinitialize
    @battlesize    = 2     # Battle size (0 = single, 1 = double 2 = triple)
  end
end

MenuHandlers.add(:options_menu, :battle_size_option, {
  "name"        => _INTL("Battle Format"),
  "order"       => 55,
  "type"        => EnumOption,
  "parameters"  => [_INTL("Single"), _INTL("Double"), _INTL("Triple")],
  #"description" => _INTL("Your Battle Format preference. Auto Adapts battles to your chosen format."),
  "description" => _INTL("Auto adapts only Trainer Battles to your chosen format."),
  "get_proc"    => proc { next $PokemonSystem.battlesize },
  "set_proc"    => proc { |value, _scene| $PokemonSystem.battlesize = value }
})


EventHandlers.add(:on_trainer_load, :battle_size_option,
  proc { |trainer|
    if !$game_temp.battle_rules["size"] && trainer
    case $PokemonSystem.battlesize
      when 1
          setBattleRule("double") if pbCanDoubleBattle?
      when 2
          setBattleRule("triple") if pbCanTripleBattle?
          setBattleRule("double") if !pbCanTripleBattle? && pbCanDoubleBattle?
      end
    end
  }
)
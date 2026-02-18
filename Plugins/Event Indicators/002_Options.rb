MenuHandlers.add(:options_menu, :show_event_indicators, {
    "name"        => _INTL("Show NPC Indicator"),
    "order"       => 121,
    "type"        => EnumOption,
    "parameters"  => [_INTL("Show"), _INTL("Hide")],
    "condition"   => proc { next Settings::EVENT_INDICATOR_ALLOW_HIDE_OPTION },
    "description" => _INTL("Choose whether indicator bubbles appear above NPCs."),
    "get_proc"    => proc { next $PokemonSystem.showeventindicators || 0},
    "set_proc"    => proc { |value, _scene| 
        $PokemonSystem.showeventindicators = value 
        $game_map&.refresh
    }
})

MenuHandlers.add(:options_menu, :event_indicators_move, {
    "name"        => _INTL("NPC Indicator Move"),
    "order"       => 122,
    "type"        => EnumOption,
    "parameters"  => [_INTL("Move"), _INTL("Don't Move")],
    "condition"   => proc { next Settings:: EVENT_INDICATOR_VERTICAL_MOVEMENT && Settings::EVENT_INDICATOR_ALLOW_MOVEMENT_OPTION },
    "description" => _INTL("Choose whether indicator bubbles above NPCs move up and down."),
    "get_proc"    => proc { next $PokemonSystem.eventindicatorsmove || 0},
    "set_proc"    => proc { |value, _scene| 
        $PokemonSystem.eventindicatorsmove = value 
        $game_map&.refresh
    }
})
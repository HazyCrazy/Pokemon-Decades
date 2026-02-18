#===============================================================================
# Pokemon Summary handlers.
#===============================================================================
UIHandlers.add(:summary, :page_allstats, { 
  "name"      => "Stats [C] Move Order",
  "suffix"    => "allstats",
  "order"     => 35,
  "options"   => [:item, :nickname, :pokedex, :moves, :remember, :forget],
  "layout"    => proc { |pkmn, scene| scene.drawPageAllStats }
})
################################################################################
# 
# Obtain/Lose All Items (Needed for Battle Mode)
# 
################################################################################

#===============================================================================
# Lose All Items 
#===============================================================================
def pbDumpOutAllItems 
	$bag.clear
    pbMessage(_INTL("The Bag was cleared."))
end 

#===============================================================================
# Get All Items (Organise the Pocket slots, so the bag does not become a slog to navigate)
# An Alternative method to keep the bag clean, is using Arcky's Poke Market plugin,
# and setting all items needed in Battle Mode, to a non money currency, that regens to max on the player's command.
# No matter what you do, making sure every single item required in Battle Mode is instantly obtainable isn't easy.
#===============================================================================
def pbPumbInAllItems
	params = ChooseNumberParams.new
    params.setRange(1, Settings::BAG_MAX_PER_SLOT)
    params.setInitialValue(1)
    params.setCancelValue(0)
    #qty = pbMessageChooseNumber(_INTL("Choose the number of items. Please set to 900."), params)
	qty = 900
    if qty > 0
      $bag.clear
      # NOTE: This doesn't simply use $bag.add for every item in turn, because
      #       that's really slow when done in bulk.
      pocket_sizes = Settings::BAG_MAX_POCKET_SIZE
      bag = $bag.pockets   # Called here so that it only rearranges itself once
      GameData::Item.each do |i|
        next if !pocket_sizes[i.pocket - 1] || pocket_sizes[i.pocket - 1] == 0
        next if pocket_sizes[i.pocket - 1] > 0 && bag[i.pocket].length >= pocket_sizes[i.pocket - 1]
        item_qty = (i.is_important?) ? 1 : qty
        bag[i.pocket].push([i.id, item_qty])
      end
      # NOTE: Auto-sorting pockets don't need to be sorted afterwards, because
      #       items are added in the same order they would be sorted into.
      #pbMessage(_INTL("The Bag was filled with {1} of each item.", qty))
	  pbMessage(_INTL("The Bag was filled with {1} of every item in the game. (Auto Decluttered in Story Mode, can be Decluttered in Battle Mode)", qty))
    end
end 

#===============================================================================
# Declutter the Bag (Removes all junk items, after all items are dumped in)
#===============================================================================
def pbRemoveBagClutter
	$bag.remove(:CHARMCASE, 999)
	$bag.remove(:APRICORNCHARM, 999)
	$bag.remove(:BALANCECHARM, 999)
	$bag.remove(:BERRYCHARM, 999)
	$bag.remove(:CLOVERCHARM, 999)
	$bag.remove(:COINCHARM, 999)
	$bag.remove(:COLORCHARM, 999)
	$bag.remove(:CONTESTCHARM, 999)
	$bag.remove(:CORRUPTCHARM, 999)
	$bag.remove(:CRAFTINGCHARM, 999)
	$bag.remove(:DISABLECHARM, 999)
	$bag.remove(:EASYCHARM, 999)
	$bag.remove(:EFFORTCHARM, 999)
	$bag.remove(:EXPALLCHARM, 999)
	$bag.remove(:FRUGALCHARM, 999)
	$bag.remove(:GENECHARM, 999)
	$bag.remove(:GOLDCHARM, 999)
	$bag.remove(:HARDCHARM, 999)
	$bag.remove(:HEALINGCHARM, 999)
	$bag.remove(:HEARTCHARM, 999)
	$bag.remove(:IVCHARM, 999)
	$bag.remove(:LINKCHARM, 999)
	$bag.remove(:KEYCHARM, 999)
	$bag.remove(:LURECHARM, 999)
	$bag.remove(:MERCYCHARM, 999)
	$bag.remove(:MININGCHARM, 999)
	$bag.remove(:NATURECHARM, 999)
	$bag.remove(:POINTSCHARM, 999)
	$bag.remove(:PROMOCHARM, 999)
	$bag.remove(:PURIFYCHARM, 999)
	$bag.remove(:ROAMINGCHARM, 999)
	$bag.remove(:RESISTORCHARM, 999)
	$bag.remove(:SAFARICHARM, 999)
	$bag.remove(:SLOTSCHARM, 999)
	$bag.remove(:SMARTCHARM, 999)
	$bag.remove(:SPIRITCHARM, 999)
	$bag.remove(:STABCHARM, 999)
	$bag.remove(:STEPCHARM, 999)
	$bag.remove(:TRADINGCHARM, 999)
	$bag.remove(:TRIPTRIADCHARM, 999)
	$bag.remove(:TWINCHARM, 999)
	$bag.remove(:VIRALCHARM, 999)
	$bag.remove(:WISHINGCHARM, 999)
	$bag.remove(:ELEMENTCHARM, 999)
	$bag.remove(:BUGCHARM, 999)
	$bag.remove(:DARKCHARM, 999)
	$bag.remove(:DRAGONCHARM, 999)
	$bag.remove(:ELECTRICCHARM, 999)
	$bag.remove(:FAIRYCHARM, 999)
	$bag.remove(:FIGHTINGCHARM, 999)
	$bag.remove(:FIRECHARM, 999)
	$bag.remove(:FLYINGCHARM, 999)
	$bag.remove(:GHOSTCHARM, 999)
	$bag.remove(:GRASSCHARM, 999)
	$bag.remove(:GROUNDCHARM, 999)
	$bag.remove(:ICECHARM, 999)
	$bag.remove(:NORMALCHARM, 999)
	$bag.remove(:POISONCHARM, 999)
	$bag.remove(:PSYCHICCHARM, 999)
	$bag.remove(:ROCKCHARM, 999)
	$bag.remove(:STEELCHARM, 999)
	$bag.remove(:WATERCHARM, 999)
	$bag.remove(:DYNAMAXCANDY, 999)
	$bag.remove(:DYNAMAXCANDYXL, 999)
	$bag.remove(:NORMALTERASHARD, 999)
	$bag.remove(:FIRETERASHARD, 999)
	$bag.remove(:WATERTERASHARD, 999)
	$bag.remove(:ELECTRICTERASHARD, 999)
	$bag.remove(:GRASSTERASHARD, 999)
	$bag.remove(:ICETERASHARD, 999)
	$bag.remove(:FIGHTINGTERASHARD, 999)
	$bag.remove(:POISONTERASHARD, 999)
	$bag.remove(:GROUNDTERASHARD, 999)
	$bag.remove(:FLYINGTERASHARD, 999)
	$bag.remove(:PSYCHICTERASHARD, 999)
	$bag.remove(:BUGTERASHARD, 999)
	$bag.remove(:ROCKTERASHARD, 999)
	$bag.remove(:GHOSTTERASHARD, 999)
	$bag.remove(:DRAGONTERASHARD, 999)
	$bag.remove(:DARKTERASHARD, 999)
	$bag.remove(:STEELTERASHARD, 999)
	$bag.remove(:FAIRYTERASHARD, 999)
	$bag.remove(:STELLARTERASHARD, 999)
	$bag.remove(:MYSTERYTERAJEWEL, 999)
	$bag.remove(:GLIMMERINGCHARM, 999)
	$bag.remove(:GIMMIGHOULCOIN, 999)
	$bag.remove(:HEALTHMOCHI, 999)
	$bag.remove(:MUSCLEMOCHI, 999)
	$bag.remove(:RESISTMOCHI, 999)
	$bag.remove(:GENIUSMOCHI, 999)
	$bag.remove(:CLEVERMOCHI, 999)
	$bag.remove(:SWIFTMOCHI, 999)
	$bag.remove(:FRESHSTARTMOCHI, 999)
	$bag.remove(:MYTHICALPECHABERRY, 999)
	$bag.remove(:SYNCHROMACHINE, 999)
	$bag.remove(:BRIARSBOOK, 999)
	$bag.remove(:TM001, 999)
	$bag.remove(:TM002, 999)
	$bag.remove(:TM003, 999)
	$bag.remove(:TM004, 999)
	$bag.remove(:TM005, 999)
	$bag.remove(:TM006, 999)
	$bag.remove(:TM007, 999)
	$bag.remove(:TM008, 999)
	$bag.remove(:TM009, 999)
	$bag.remove(:TM010, 999)
	$bag.remove(:TM011, 999)
	$bag.remove(:TM012, 999)
	$bag.remove(:TM013, 999)
	$bag.remove(:TM014, 999)
	$bag.remove(:TM015, 999)
	$bag.remove(:TM016, 999)
	$bag.remove(:TM017, 999)
	$bag.remove(:TM018, 999)
	$bag.remove(:TM019, 999)
	$bag.remove(:TM020, 999)
	$bag.remove(:TM021, 999)
	$bag.remove(:TM022, 999)
	$bag.remove(:TM023, 999)
	$bag.remove(:TM024, 999)
	$bag.remove(:TM025, 999)
	$bag.remove(:TM026, 999)
	$bag.remove(:TM027, 999)
	$bag.remove(:TM028, 999)
	$bag.remove(:TM029, 999)
	$bag.remove(:TM030, 999)
	$bag.remove(:TM031, 999)
	$bag.remove(:TM032, 999)
	$bag.remove(:TM033, 999)
	$bag.remove(:TM034, 999)
	$bag.remove(:TM035, 999)
	$bag.remove(:TM036, 999)
	$bag.remove(:TM037, 999)
	$bag.remove(:TM038, 999)
	$bag.remove(:TM039, 999)
	$bag.remove(:TM040, 999)
	$bag.remove(:TM041, 999)
	$bag.remove(:TM042, 999)
	$bag.remove(:TM043, 999)
	$bag.remove(:TM044, 999)
	$bag.remove(:TM045, 999)
	$bag.remove(:TM046, 999)
	$bag.remove(:TM047, 999)
	$bag.remove(:TM048, 999)
	$bag.remove(:TM049, 999)
	$bag.remove(:TM050, 999)
	$bag.remove(:TM051, 999)
	$bag.remove(:TM052, 999)
	$bag.remove(:TM053, 999)
	$bag.remove(:TM054, 999)
	$bag.remove(:TM055, 999)
	$bag.remove(:TM056, 999)
	$bag.remove(:TM057, 999)
	$bag.remove(:TM058, 999)
	$bag.remove(:TM059, 999)
	$bag.remove(:TM060, 999)
	$bag.remove(:TM061, 999)
	$bag.remove(:TM062, 999)
	$bag.remove(:TM063, 999)
	$bag.remove(:TM064, 999)
	$bag.remove(:TM065, 999)
	$bag.remove(:TM066, 999)
	$bag.remove(:TM067, 999)
	$bag.remove(:TM068, 999)
	$bag.remove(:TM069, 999)
	$bag.remove(:TM070, 999)
	$bag.remove(:TM071, 999)
	$bag.remove(:TM072, 999)
	$bag.remove(:TM073, 999)
	$bag.remove(:TM074, 999)
	$bag.remove(:TM075, 999)
	$bag.remove(:TM076, 999)
	$bag.remove(:TM077, 999)
	$bag.remove(:TM078, 999)
	$bag.remove(:TM079, 999)
	$bag.remove(:TM080, 999)
	$bag.remove(:TM081, 999)
	$bag.remove(:TM082, 999)
	$bag.remove(:TM083, 999)
	$bag.remove(:TM084, 999)
	$bag.remove(:TM085, 999)
	$bag.remove(:TM086, 999)
	$bag.remove(:TM087, 999)
	$bag.remove(:TM088, 999)
	$bag.remove(:TM089, 999)
	$bag.remove(:TM090, 999)
	$bag.remove(:TM091, 999)
	$bag.remove(:TM092, 999)
	$bag.remove(:TM093, 999)
	$bag.remove(:TM094, 999)
	$bag.remove(:TM095, 999)
	$bag.remove(:TM096, 999)
	$bag.remove(:TM097, 999)
	$bag.remove(:TM098, 999)
	$bag.remove(:TM099, 999)
	$bag.remove(:TM100, 999)
	$bag.remove(:TM101, 999)
	$bag.remove(:TM102, 999)
	$bag.remove(:TM103, 999)
	$bag.remove(:TM104, 999)
	$bag.remove(:TM105, 999)
	$bag.remove(:TM106, 999)
	$bag.remove(:TM107, 999)
	$bag.remove(:TM108, 999)
	$bag.remove(:TM109, 999)
	$bag.remove(:TM110, 999)
	$bag.remove(:TM111, 999)
	$bag.remove(:TM112, 999)
	$bag.remove(:TM113, 999)
	$bag.remove(:TM114, 999)
	$bag.remove(:TM115, 999)
	$bag.remove(:TM116, 999)
	$bag.remove(:TM117, 999)
	$bag.remove(:TM118, 999)
	$bag.remove(:TM119, 999)
	$bag.remove(:TM120, 999)
	$bag.remove(:TM121, 999)
	$bag.remove(:TM122, 999)
	$bag.remove(:TM123, 999)
	$bag.remove(:TM124, 999)
	$bag.remove(:TM125, 999)
	$bag.remove(:TM126, 999)
	$bag.remove(:TM127, 999)
	$bag.remove(:TM128, 999)
	$bag.remove(:TM129, 999)
	$bag.remove(:TM130, 999)
	$bag.remove(:TM131, 999)
	$bag.remove(:TM132, 999)
	$bag.remove(:TM133, 999)
	$bag.remove(:TM134, 999)
	$bag.remove(:TM135, 999)
	$bag.remove(:TM136, 999)
	$bag.remove(:TM137, 999)
	$bag.remove(:TM138, 999)
	$bag.remove(:TM139, 999)
	$bag.remove(:TM140, 999)
	$bag.remove(:TM141, 999)
	$bag.remove(:TM142, 999)
	$bag.remove(:TM143, 999)
	$bag.remove(:TM144, 999)
	$bag.remove(:TM145, 999)
	$bag.remove(:TM146, 999)
	$bag.remove(:TM147, 999)
	$bag.remove(:TM148, 999)
	$bag.remove(:TM149, 999)
	$bag.remove(:TM150, 999)
	$bag.remove(:TM151, 999)
	$bag.remove(:TM152, 999)
	$bag.remove(:TM153, 999)
	$bag.remove(:TM154, 999)
	$bag.remove(:TM155, 999)
	$bag.remove(:TM156, 999)
	$bag.remove(:TM157, 999)
	$bag.remove(:TM158, 999)
	$bag.remove(:TM159, 999)
	$bag.remove(:TM160, 999)
	$bag.remove(:TM161, 999)
	$bag.remove(:TM162, 999)
	$bag.remove(:TM163, 999)
	$bag.remove(:TM164, 999)
	$bag.remove(:TM165, 999)
	$bag.remove(:TM166, 999)
	$bag.remove(:TM167, 999)
	$bag.remove(:TM168, 999)
	$bag.remove(:TM169, 999)
	$bag.remove(:TM170, 999)
	$bag.remove(:TM171, 999)
	$bag.remove(:TM172, 999)
	$bag.remove(:TM173, 999)
	$bag.remove(:TM174, 999)
	$bag.remove(:TM175, 999)
	$bag.remove(:TM176, 999)
	$bag.remove(:TM177, 999)
	$bag.remove(:TM178, 999)
	$bag.remove(:TM179, 999)
	$bag.remove(:TM180, 999)
	$bag.remove(:TM181, 999)
	$bag.remove(:TM182, 999)
	$bag.remove(:TM183, 999)
	$bag.remove(:TM184, 999)
	$bag.remove(:TM185, 999)
	$bag.remove(:TM186, 999)
	$bag.remove(:TM187, 999)
	$bag.remove(:TM188, 999)
	$bag.remove(:TM189, 999)
	$bag.remove(:TM190, 999)
	$bag.remove(:TM191, 999)
	$bag.remove(:TM192, 999)
	$bag.remove(:TM193, 999)
	$bag.remove(:TM194, 999)
	$bag.remove(:TM195, 999)
	$bag.remove(:TM196, 999)
	$bag.remove(:TM197, 999)
	$bag.remove(:TM198, 999)
	$bag.remove(:TM199, 999)
	$bag.remove(:TM200, 999)
	$bag.remove(:TM201, 999)
	$bag.remove(:TM202, 999)
	$bag.remove(:TM203, 999)
	$bag.remove(:TM204, 999)
	$bag.remove(:TM205, 999)
	$bag.remove(:TM206, 999)
	$bag.remove(:TM207, 999)
	$bag.remove(:TM208, 999)
	$bag.remove(:TM209, 999)
	$bag.remove(:TM210, 999)
	$bag.remove(:TM211, 999)
	$bag.remove(:TM212, 999)
	$bag.remove(:TM213, 999)
	$bag.remove(:TM214, 999)
	$bag.remove(:TM215, 999)
	$bag.remove(:TM216, 999)
	$bag.remove(:TM217, 999)
	$bag.remove(:TM218, 999)
	$bag.remove(:TM219, 999)
	$bag.remove(:TM220, 999)
	$bag.remove(:TM221, 999)
	$bag.remove(:TM222, 999)
	$bag.remove(:TM223, 999)
	$bag.remove(:TM224, 999)
	$bag.remove(:TM225, 999)
	$bag.remove(:TM226, 999)
	$bag.remove(:TM227, 999)
	$bag.remove(:TM228, 999)
	$bag.remove(:TM229, 999)
	$bag.remove(:SUPERREPEL, 999)
	$bag.remove(:MAXREPEL, 999)
	$bag.remove(:BLACKFLUTE, 999)
	$bag.remove(:WHITEFLUTE, 999)
	$bag.remove(:REDSHARD, 999)
	$bag.remove(:YELLOWSHARD, 999)
	$bag.remove(:BLUESHARD, 999)
	$bag.remove(:GREENSHARD, 999)
	$bag.remove(:REDAPRICORN, 999)
	$bag.remove(:YELLOWAPRICORN, 999)
	$bag.remove(:BLUEAPRICORN, 999)
	$bag.remove(:GREENAPRICORN, 999)
	$bag.remove(:PINKAPRICORN, 999)
	$bag.remove(:WHITEAPRICORN, 999)
	$bag.remove(:BLACKAPRICORN, 999)
	$bag.remove(:HELIXFOSSIL, 999)
	$bag.remove(:DOMEFOSSIL, 999)
	$bag.remove(:OLDAMBER, 999)
	$bag.remove(:ROOTFOSSIL, 999)
	$bag.remove(:CLAWFOSSIL, 999)
	$bag.remove(:SKULLFOSSIL, 999)
	$bag.remove(:ARMORFOSSIL, 999)
	$bag.remove(:COVERFOSSIL, 999)
	$bag.remove(:PLUMEFOSSIL, 999)
	$bag.remove(:JAWFOSSIL, 999)
	$bag.remove(:SAILFOSSIL, 999)
	$bag.remove(:FOSSILIZEDBIRD, 999)
	$bag.remove(:FOSSILIZEDFISH, 999)
	$bag.remove(:FOSSILIZEDDRAKE, 999)
	$bag.remove(:FOSSILIZEDDINO, 999)
	$bag.remove(:PRETTYFEATHER, 999)
	$bag.remove(:TINYMUSHROOM, 999)
	$bag.remove(:BIGMUSHROOM, 999)
	$bag.remove(:BALMMUSHROOM, 999)
	$bag.remove(:PEARL, 999)
	$bag.remove(:BIGPEARL, 999)
	$bag.remove(:PEARLSTRING, 999)
	$bag.remove(:STARDUST, 999)
	$bag.remove(:STARPIECE, 999)
	$bag.remove(:COMETSHARD, 999)
	$bag.remove(:NUGGET, 999)
	$bag.remove(:HEARTSCALE, 999)
	$bag.remove(:SLOWPOKETAIL, 999)
	$bag.remove(:RAREBONE, 999)
	$bag.remove(:RELICCOPPER, 999)
	$bag.remove(:RELICSILVER, 999)
	$bag.remove(:RELICGOLD, 999)
	$bag.remove(:RELICVASE, 999)
	$bag.remove(:RELICBAND, 999)
	$bag.remove(:RELICSTATUE, 999)
	$bag.remove(:RELICCROWN, 999)
	$bag.remove(:GROWTHMULCH, 999)
	$bag.remove(:DAMPMULCH, 999)
	$bag.remove(:STABLEMULCH, 999)
	$bag.remove(:GOOEYMULCH, 999)
	$bag.remove(:SHOALSALT, 999)
	$bag.remove(:SHOALSHELL, 999)
	$bag.remove(:ODDKEYSTONE, 999)
	$bag.remove(:SMOKEBALL, 999)
	$bag.remove(:LUCKYEGG, 999)
	$bag.remove(:EXPSHARE, 999)
	$bag.remove(:AMULETCOIN, 999)
	$bag.remove(:SOOTHEBELL, 999)
	$bag.remove(:CLEANSETAG, 999)
	$bag.remove(:MACHOBRACE, 999)
	$bag.remove(:POWERWEIGHT, 999)
	$bag.remove(:POWERBRACER, 999)
	$bag.remove(:POWERBELT, 999)
	$bag.remove(:POWERLENS, 999)
	$bag.remove(:POWERBAND, 999)
	$bag.remove(:POWERANKLET, 999)
	$bag.remove(:POTION, 999)
	$bag.remove(:SUPERPOTION, 999)
	$bag.remove(:HYPERPOTION, 999)
	$bag.remove(:MAXPOTION, 999)
	$bag.remove(:FULLRESTORE, 999)
	$bag.remove(:SACREDASH, 999)
	$bag.remove(:AWAKENING, 999)
	$bag.remove(:ANTIDOTE, 999)
	$bag.remove(:BURNHEAL, 999)
	$bag.remove(:PARALYZEHEAL, 999)
	$bag.remove(:ICEHEAL, 999)
	$bag.remove(:FULLHEAL, 999)
	$bag.remove(:PEWTERCRUNCHIES, 999)
	$bag.remove(:RAGECANDYBAR, 999)
	$bag.remove(:LAVACOOKIE, 999)
	$bag.remove(:OLDGATEAU, 999)
	$bag.remove(:CASTELIACONE, 999)
	$bag.remove(:LUMIOSEGALETTE, 999)
	$bag.remove(:SHALOURSABLE, 999)
	$bag.remove(:BIGMALASADA, 999)
	$bag.remove(:REVIVE, 999)
	$bag.remove(:MAXREVIVE, 999)
	$bag.remove(:SWEETHEART, 999)
	$bag.remove(:FRESHWATER, 999)
	$bag.remove(:SODAPOP, 999)
	$bag.remove(:LEMONADE, 999)
	$bag.remove(:MOOMOOMILK, 999)
	$bag.remove(:ENERGYPOWDER, 999)
	$bag.remove(:ENERGYROOT, 999)
	$bag.remove(:HEALPOWDER, 999)
	$bag.remove(:REVIVALHERB, 999)
	$bag.remove(:MAXHONEY, 999)
	$bag.remove(:ETHER, 999)
	$bag.remove(:MAXETHER, 999)
	$bag.remove(:ELIXIR, 999)
	$bag.remove(:MAXELIXIR, 999)
	$bag.remove(:HPUP, 999)
	$bag.remove(:PROTEIN, 999)
	$bag.remove(:IRON, 999)
	$bag.remove(:CALCIUM, 999)
	$bag.remove(:ZINC, 999)
	$bag.remove(:CARBOS, 999)
	$bag.remove(:HEALTHFEATHER, 999)
	$bag.remove(:MUSCLEFEATHER, 999)
	$bag.remove(:RESISTFEATHER, 999)
	$bag.remove(:GENIUSFEATHER, 999)
	$bag.remove(:CLEVERFEATHER, 999)
	$bag.remove(:SWIFTFEATHER, 999)
	$bag.remove(:ABILITYCAPSULE, 999)
	$bag.remove(:ABILITYPATCH, 999)
	$bag.remove(:EXPCANDYXS, 999)
	$bag.remove(:EXPCANDYS, 999)
	$bag.remove(:EXPCANDYM, 999)
	$bag.remove(:EXPCANDYL, 999)
	$bag.remove(:EXPCANDYXL, 999)
	$bag.remove(:TM01, 999)
	$bag.remove(:TM02, 999)
	$bag.remove(:TM03, 999)
	$bag.remove(:TM04, 999)
	$bag.remove(:TM05, 999)
	$bag.remove(:TM06, 999)
	$bag.remove(:TM07, 999)
	$bag.remove(:TM08, 999)
	$bag.remove(:TM09, 999)
	$bag.remove(:TM10, 999)
	$bag.remove(:TM11, 999)
	$bag.remove(:TM12, 999)
	$bag.remove(:TM13, 999)
	$bag.remove(:TM14, 999)
	$bag.remove(:TM15, 999)
	$bag.remove(:TM16, 999)
	$bag.remove(:TM17, 999)
	$bag.remove(:TM18, 999)
	$bag.remove(:TM19, 999)
	$bag.remove(:TM20, 999)
	$bag.remove(:TM21, 999)
	$bag.remove(:TM22, 999)
	$bag.remove(:TM23, 999)
	$bag.remove(:TM24, 999)
	$bag.remove(:TM25, 999)
	$bag.remove(:TM26, 999)
	$bag.remove(:TM27, 999)
	$bag.remove(:TM28, 999)
	$bag.remove(:TM29, 999)
	$bag.remove(:TM30, 999)
	$bag.remove(:TM31, 999)
	$bag.remove(:TM32, 999)
	$bag.remove(:TM33, 999)
	$bag.remove(:TM34, 999)
	$bag.remove(:TM35, 999)
	$bag.remove(:TM36, 999)
	$bag.remove(:TM37, 999)
	$bag.remove(:TM38, 999)
	$bag.remove(:TM39, 999)
	$bag.remove(:TM40, 999)
	$bag.remove(:TM41, 999)
	$bag.remove(:TM42, 999)
	$bag.remove(:TM43, 999)
	$bag.remove(:TM44, 999)
	$bag.remove(:TM45, 999)
	$bag.remove(:TM46, 999)
	$bag.remove(:TM47, 999)
	$bag.remove(:TM48, 999)
	$bag.remove(:TM49, 999)
	$bag.remove(:TM50, 999)
	$bag.remove(:TM51, 999)
	$bag.remove(:TM52, 999)
	$bag.remove(:TM53, 999)
	$bag.remove(:TM54, 999)
	$bag.remove(:TM55, 999)
	$bag.remove(:TM56, 999)
	$bag.remove(:TM57, 999)
	$bag.remove(:TM58, 999)
	$bag.remove(:TM59, 999)
	$bag.remove(:TM60, 999)
	$bag.remove(:TM61, 999)
	$bag.remove(:TM62, 999)
	$bag.remove(:TM63, 999)
	$bag.remove(:TM64, 999)
	$bag.remove(:TM65, 999)
	$bag.remove(:TM66, 999)
	$bag.remove(:TM67, 999)
	$bag.remove(:TM68, 999)
	$bag.remove(:TM69, 999)
	$bag.remove(:TM70, 999)
	$bag.remove(:TM71, 999)
	$bag.remove(:TM72, 999)
	$bag.remove(:TM73, 999)
	$bag.remove(:TM74, 999)
	$bag.remove(:TM75, 999)
	$bag.remove(:TM76, 999)
	$bag.remove(:TM77, 999)
	$bag.remove(:TM78, 999)
	$bag.remove(:TM79, 999)
	$bag.remove(:TM80, 999)
	$bag.remove(:TM81, 999)
	$bag.remove(:TM82, 999)
	$bag.remove(:TM83, 999)
	$bag.remove(:TM84, 999)
	$bag.remove(:TM85, 999)
	$bag.remove(:TM86, 999)
	$bag.remove(:TM87, 999)
	$bag.remove(:TM88, 999)
	$bag.remove(:TM89, 999)
	$bag.remove(:TM90, 999)
	$bag.remove(:TM91, 999)
	$bag.remove(:TM92, 999)
	$bag.remove(:TM93, 999)
	$bag.remove(:TM94, 999)
	$bag.remove(:TM95, 999)
	$bag.remove(:TM96, 999)
	$bag.remove(:TM97, 999)
	$bag.remove(:TM98, 999)
	$bag.remove(:TM99, 999)
	$bag.remove(:TM100, 999)
	$bag.remove(:HM01, 999)
	$bag.remove(:HM02, 999)
	$bag.remove(:HM03, 999)
	$bag.remove(:HM04, 999)
	$bag.remove(:HM05, 999)
	$bag.remove(:HM06, 999)
	$bag.remove(:HM07, 999)
	$bag.remove(:GRASSMAIL, 999)
	$bag.remove(:FLAMEMAIL, 999)
	$bag.remove(:BUBBLEMAIL, 999)
	$bag.remove(:BLOOMMAIL, 999)
	$bag.remove(:TUNNELMAIL, 999)
	$bag.remove(:STEELMAIL, 999)
	$bag.remove(:HEARTMAIL, 999)
	$bag.remove(:SNOWMAIL, 999)
	$bag.remove(:SPACEMAIL, 999)
	$bag.remove(:AIRMAIL, 999)
	$bag.remove(:MOSAICMAIL, 999)
	$bag.remove(:BRICKMAIL, 999)
	$bag.remove(:BLUEFLUTE, 999)
	$bag.remove(:YELLOWFLUTE, 999)
	$bag.remove(:REDFLUTE, 999)
	$bag.remove(:POKEDOLL, 999)
	$bag.remove(:FLUFFYTAIL, 999)
	$bag.remove(:POKETOY, 999)
	$bag.remove(:BICYCLE, 999)
	$bag.remove(:OLDROD, 999)
	$bag.remove(:GOODROD, 999)
	#$bag.remove(:SUPERROD, 999)
	$bag.remove(:ITEMFINDER, 999)
	$bag.remove(:DOWSINGMACHINE, 999)
	$bag.remove(:POKERADAR, 999)
	$bag.remove(:TOWNMAP, 999)
	$bag.remove(:ESCAPEROPE, 999)
	$bag.remove(:COINCASE, 999)
	$bag.remove(:POKEFLUTE, 999)
	$bag.remove(:SOOTSACK, 999)
	$bag.remove(:SILPHSCOPE, 999)
	$bag.remove(:DEVONSCOPE, 999)
	$bag.remove(:SQUIRTBOTTLE, 999)
	$bag.remove(:SPRAYDUCK, 999)
	$bag.remove(:WAILMERPAIL, 999)
	$bag.remove(:SPRINKLOTAD, 999)
	$bag.remove(:OVALCHARM, 999)
	$bag.remove(:SHINYCHARM, 999)
	$bag.remove(:CATCHINGCHARM, 999)
	#$bag.remove(:EXPCHARM, 999)
	$bag.remove(:AURORATICKET, 999)
	$bag.remove(:OLDSEAMAP, 999)
	$bag.remove(:REPEL, 999)
	$bag.remove(:REPELCHARM, 999)
	$bag.remove(:FIRESTONE, 999)
	$bag.remove(:THUNDERSTONE, 999)
	$bag.remove(:WATERSTONE, 999)
	$bag.remove(:LEAFSTONE, 999)
	$bag.remove(:MOONSTONE, 999)
	$bag.remove(:SUNSTONE, 999)
	$bag.remove(:DUSKSTONE, 999)
	$bag.remove(:DAWNSTONE, 999)
	$bag.remove(:SHINYSTONE, 999)
	$bag.remove(:ICESTONE, 999)
	$bag.remove(:SWEETAPPLE, 999)
	$bag.remove(:TARTAPPLE, 999)
	$bag.remove(:CRACKEDPOT, 999)
	$bag.remove(:CHIPPEDPOT, 999)
	$bag.remove(:GALARICACUFF, 999)
	$bag.remove(:GALARICAWREATH, 999)
	$bag.remove(:METALCOAT, 999)
	$bag.remove(:STRAWBERRYSWEET, 999)
	$bag.remove(:LOVESWEET, 999)
	$bag.remove(:BERRYSWEET, 999)
	$bag.remove(:CLOVERSWEET, 999)
	$bag.remove(:FLOWERSWEET, 999)
	$bag.remove(:STARSWEET, 999)
	$bag.remove(:RIBBONSWEET, 999)
	$bag.remove(:BLACKAUGURITE, 999)
	$bag.remove(:PEATBLOCK, 999)
	$bag.remove(:LINKINGCORD, 999)
	$bag.remove(:AUSPICIOUSARMOR, 999)
	$bag.remove(:MALICIOUSARMOR, 999)
	$bag.remove(:LEADERSCREST, 999)
	$bag.remove(:GIMMIGHOULCOIN, 999)
	$bag.remove(:TINYBAMBOOSHOOT, 999)
	$bag.remove(:BIGBAMBOOSHOOT, 999)
	$bag.remove(:SYRUPYAPPLE, 999)
	$bag.remove(:UNREMARKABLETEACUP, 999)
	$bag.remove(:MASTERPIECETEACUP, 999)
	$bag.remove(:METALALLOY, 999)
	$bag.remove(:MYTHICALPECHABERRY, 999)
	$bag.remove(:MARKCHARM, 999)
	$bag.remove(:ZRING, 999)
	$bag.remove(:LAXINCENSE, 999)
	$bag.remove(:FULLINCENSE, 999)
	$bag.remove(:LUCKINCENSE, 999)
	$bag.remove(:PUREINCENSE, 999)
	$bag.remove(:SEAINCENSE, 999)
	$bag.remove(:WAVEINCENSE, 999)
	$bag.remove(:ROSEINCENSE, 999)
	$bag.remove(:ODDINCENSE, 999)
	$bag.remove(:ROCKINCENSE, 999)
	$bag.remove(:DRAGONSCALE, 999)
	$bag.remove(:UPGRADE, 999)
	$bag.remove(:DUBIOUSDISC, 999)
	$bag.remove(:PROTECTOR, 999)
	$bag.remove(:ELECTIRIZER, 999)
	$bag.remove(:MAGMARIZER, 999)
	$bag.remove(:REAPERCLOTH, 999)
	$bag.remove(:PRISMSCALE, 999)
	$bag.remove(:OVALSTONE, 999)
	$bag.remove(:WHIPPEDDREAM, 999)
	$bag.remove(:SACHET, 999)
	$bag.remove(:XATTACK, 999)
	$bag.remove(:XATTACK2, 999)
	$bag.remove(:XATTACK3, 999)
	$bag.remove(:XATTACK6, 999)
	$bag.remove(:XDEFENSE, 999)
	$bag.remove(:XDEFENSE2, 999)
	$bag.remove(:XDEFENSE3, 999)
	$bag.remove(:XDEFENSE6, 999)
	$bag.remove(:XSPATK, 999)
	$bag.remove(:XSPATK2, 999)
	$bag.remove(:XSPATK3, 999)
	$bag.remove(:XSPATK6, 999)
	$bag.remove(:XSPDEF, 999)
	$bag.remove(:XSPDEF2, 999)
	$bag.remove(:XSPDEF3, 999)
	$bag.remove(:XSPDEF6, 999)
	$bag.remove(:XSPEED, 999)
	$bag.remove(:XSPEED2, 999)
	$bag.remove(:XSPEED3, 999)
	$bag.remove(:XSPEED6, 999)
	$bag.remove(:XACCURACY, 999)
	$bag.remove(:XACCURACY2, 999)
	$bag.remove(:XACCURACY3, 999)
	$bag.remove(:XACCURACY6, 999)
	$bag.remove(:MAXMUSHROOMS, 999)
	$bag.remove(:DIREHIT, 999)
	$bag.remove(:DIREHIT2, 999)
	$bag.remove(:DIREHIT3, 999)
	$bag.remove(:GUARDSPEC, 999)
	$bag.remove(:RESETURGE, 999)
	$bag.remove(:ABILITYURGE, 999)
	$bag.remove(:ITEMURGE, 999)
	$bag.remove(:ITEMDROP, 999)
	$bag.remove(:WISHINGSTAR, 999)
	$bag.remove(:RADIANTTERAJEWEL, 999)
	$bag.remove(:ZBOOSTER, 999)
	$bag.remove(:SCARLETBOOK, 999)
	$bag.remove(:VIOLETBOOK, 999)
	$bag.remove(:FAIRYFEATHER, 999)
	$bag.remove(:EVERSTONE, 999)
	$bag.remove(:RARECANDY, 999)
	$bag.remove(:DOOMCANDY, 999)
	$bag.remove(:VENUSAURITE, 999)
	$bag.remove(:CHARIZARDITEX, 999)
	$bag.remove(:CHARIZARDITEY, 999)
	$bag.remove(:BLASTOISINITE, 999)
	$bag.remove(:BEEDRILLITE, 999)
	$bag.remove(:PIDGEOTITE, 999)
	$bag.remove(:ALAKAZITE, 999)
	$bag.remove(:SLOWBRONITE, 999)
	$bag.remove(:GENGARITE, 999)
	$bag.remove(:KANGASKHANITE, 999)
	$bag.remove(:PINSIRITE, 999)
	$bag.remove(:GYARADOSITE, 999)
	$bag.remove(:AERODACTYLITE, 999)
	$bag.remove(:MEWTWONITEX, 999)
	$bag.remove(:MEWTWONITEY, 999)
	$bag.remove(:AMPHAROSITE, 999)
	$bag.remove(:STEELIXITE, 999)
	$bag.remove(:SCIZORITE, 999)
	$bag.remove(:HERACRONITE, 999)
	$bag.remove(:HOUNDOOMINITE, 999)
	$bag.remove(:TYRANITARITE, 999)
	$bag.remove(:SCEPTILITE, 999)
	$bag.remove(:BLAZIKENITE, 999)
	$bag.remove(:SWAMPERTITE, 999)
	$bag.remove(:GARDEVOIRITE, 999)
	$bag.remove(:SABLENITE, 999)
	$bag.remove(:MAWILITE, 999)
	$bag.remove(:AGGRONITE, 999)
	$bag.remove(:MEDICHAMITE, 999)
	$bag.remove(:MANECTITE, 999)
	$bag.remove(:SHARPEDONITE, 999)
	$bag.remove(:CAMERUPTITE, 999)
	$bag.remove(:ALTARIANITE, 999)
	$bag.remove(:BANETTITE, 999)
	$bag.remove(:ABSOLITE, 999)
	$bag.remove(:GLALITITE, 999)
	$bag.remove(:SALAMENCITE, 999)
	$bag.remove(:METAGROSSITE, 999)
	$bag.remove(:LATIASITE, 999)
	$bag.remove(:LATIOSITE, 999)
	$bag.remove(:LOPUNNITE, 999)
	$bag.remove(:GARCHOMPITE, 999)
	$bag.remove(:LUCARIONITE, 999)
	$bag.remove(:ABOMASITE, 999)
	$bag.remove(:GALLADITE, 999)
	$bag.remove(:AUDINITE, 999)
	$bag.remove(:DIANCITE, 999)
	#$bag.remove(:BLANKPLATE, 999)
	#$bag.remove(:FLAMEPLATE, 999)
	#$bag.remove(:SPLASHPLATE, 999)
	#$bag.remove(:ZAPPLATE, 999)
	#$bag.remove(:MEADOWPLATE, 999)
	#$bag.remove(:ICICLEPLATE, 999)
	#$bag.remove(:FISTPLATE, 999)
	#$bag.remove(:TOXICPLATE, 999)
	#$bag.remove(:EARTHPLATE, 999)
	#$bag.remove(:SKYPLATE, 999)
	#$bag.remove(:MINDPLATE, 999)
	#$bag.remove(:INSECTPLATE, 999)
	#$bag.remove(:STONEPLATE, 999)
	#$bag.remove(:SPOOKYPLATE, 999)
	#$bag.remove(:DRACOPLATE, 999)
	#$bag.remove(:DREADPLATE, 999)
	#$bag.remove(:IRONPLATE, 999)
	#$bag.remove(:PIXIEPLATE, 999)
	$bag.remove(:FIREMEMORY, 999)
	$bag.remove(:WATERMEMORY, 999)
	$bag.remove(:ELECTRICMEMORY, 999)
	$bag.remove(:GRASSMEMORY, 999)
	$bag.remove(:ICEMEMORY, 999)
	$bag.remove(:FIGHTINGMEMORY, 999)
	$bag.remove(:POISONMEMORY, 999)
	$bag.remove(:GROUNDMEMORY, 999)
	$bag.remove(:FLYINGMEMORY, 999)
	$bag.remove(:PSYCHICMEMORY, 999)
	$bag.remove(:BUGMEMORY, 999)
	$bag.remove(:ROCKMEMORY, 999)
	$bag.remove(:GHOSTMEMORY, 999)
	$bag.remove(:DRAGONMEMORY, 999)
	$bag.remove(:DARKMEMORY, 999)
	$bag.remove(:STEELMEMORY, 999)
	$bag.remove(:FAIRYMEMORY, 999)
	
	$bag.remove(:SETGYMBADGEDISK, 999)
	$bag.remove(:ANYITEMDISK, 999)
	$bag.remove(:ANYABILITYDISK, 999)
	
	$bag.remove(:ESCAPEROPE, 999) # Due to how Escape Points work in Essentials, and the nature of how the No Clip Disk and Mystery Zones work, this item has no purpose.
	
	$bag.remove(:FLOATSTONE, 999) # Was going to overhaul it, but I didn't have the energy to do it
	
	#$bag.remove(:FIGYBERRY, 999)
	#$bag.remove(:WIKIBERRY, 999)
	#$bag.remove(:MAGOBERRY, 999)
	#$bag.remove(:AGUAVBERRY, 999)
	#$bag.remove(:IAPAPABERRY, 999)
	
	#$bag.remove(:METABREAKERAMULET,1000) # Funbro only. Funbro exists as a joke battle, intended to fuck with Speed up Spammers, at their own expense.
	
	$bag.remove(:CANARIBREAD, 999) # A junk item that is part of the AI Scripts. Added to make sure the sciripts work.
	
end

################################################################################
# 
# Obtain All Pokemon Setup/Lose All Pokemon Setup (Needed for the Metagame Wiki Dex)
# 
################################################################################

#===============================================================================
# No Pokemon, Lvl.5, Lvl.30, Lvl.50, Lvl.100
#===============================================================================
def pbClearAllPokemonSetup
    $PokemonStorage.maxBoxes.times do |i|
      $PokemonStorage.maxPokemon(i).times do |j|
        $PokemonStorage[i, j] = nil
      end
    end
    #pbMessage(_INTL("The storage boxes were cleared."))
end

#===============================================================================
# All Pokemon, Lvl.5, Lvl.30, Lvl.50, Lvl.100
#===============================================================================

def pbAllPokemonSetup5
    added = 0
    box_qty = $PokemonStorage.maxPokemon(0)
    completed = true
    GameData::Species.each do |species_data|
      sp = species_data.species
      f = species_data.form
      # Record each form of each species as seen and owned
      if f == 0
        if species_data.single_gendered?
          g = (species_data.gender_ratio == :AlwaysFemale) ? 1 : 0
          $player.pokedex.register(sp, g, f, 0, false)
          $player.pokedex.register(sp, g, f, 1, false)
        else   # Both male and female
          $player.pokedex.register(sp, 0, f, 0, false)
          $player.pokedex.register(sp, 0, f, 1, false)
          $player.pokedex.register(sp, 1, f, 0, false)
          $player.pokedex.register(sp, 1, f, 1, false)
        end
        $player.pokedex.set_owned(sp, false)
      elsif species_data.real_form_name && !species_data.real_form_name.empty?
        g = (species_data.gender_ratio == :AlwaysFemale) ? 1 : 0
        $player.pokedex.register(sp, g, f, 0, false)
        $player.pokedex.register(sp, g, f, 1, false)
      end
      # Add Pokémon (if form 0, i.e. one of each species)
      next if f != 0
      if added >= Settings::NUM_STORAGE_BOXES * box_qty
        completed = false
        next
      end
      added += 1
      $PokemonStorage[(added - 1) / box_qty, (added - 1) % box_qty] = Pokemon.new(sp, 5) # Make every obtained Pokemon Lvl.5
    end
    $player.pokedex.refresh_accessible_dexes
    #pbMessage(_INTL("Storage boxes were filled with one Pokémon of each species."))
    if !completed
      pbMessage(_INTL("Note: The number of storage spaces ({1} boxes of {2}) is less than the number of species.",
                      Settings::NUM_STORAGE_BOXES, box_qty))
    end
end

def pbAllPokemonSetup30
    added = 0
    box_qty = $PokemonStorage.maxPokemon(0)
    completed = true
    GameData::Species.each do |species_data|
      sp = species_data.species
      f = species_data.form
      # Record each form of each species as seen and owned
      if f == 0
        if species_data.single_gendered?
          g = (species_data.gender_ratio == :AlwaysFemale) ? 1 : 0
          $player.pokedex.register(sp, g, f, 0, false)
          $player.pokedex.register(sp, g, f, 1, false)
        else   # Both male and female
          $player.pokedex.register(sp, 0, f, 0, false)
          $player.pokedex.register(sp, 0, f, 1, false)
          $player.pokedex.register(sp, 1, f, 0, false)
          $player.pokedex.register(sp, 1, f, 1, false)
        end
        $player.pokedex.set_owned(sp, false)
      elsif species_data.real_form_name && !species_data.real_form_name.empty?
        g = (species_data.gender_ratio == :AlwaysFemale) ? 1 : 0
        $player.pokedex.register(sp, g, f, 0, false)
        $player.pokedex.register(sp, g, f, 1, false)
      end
      # Add Pokémon (if form 0, i.e. one of each species)
      next if f != 0
      if added >= Settings::NUM_STORAGE_BOXES * box_qty
        completed = false
        next
      end
      added += 1
      $PokemonStorage[(added - 1) / box_qty, (added - 1) % box_qty] = Pokemon.new(sp, 30) # Make every obtained Pokemon Lvl.30
    end
    $player.pokedex.refresh_accessible_dexes
    #pbMessage(_INTL("Storage boxes were filled with one Pokémon of each species."))
    if !completed
      pbMessage(_INTL("Note: The number of storage spaces ({1} boxes of {2}) is less than the number of species.",
                      Settings::NUM_STORAGE_BOXES, box_qty))
    end
end

def pbAllPokemonSetup50
    added = 0
    box_qty = $PokemonStorage.maxPokemon(0)
    completed = true
    GameData::Species.each do |species_data|
      sp = species_data.species
      f = species_data.form
      # Record each form of each species as seen and owned
      if f == 0
        if species_data.single_gendered?
          g = (species_data.gender_ratio == :AlwaysFemale) ? 1 : 0
          $player.pokedex.register(sp, g, f, 0, false)
          $player.pokedex.register(sp, g, f, 1, false)
        else   # Both male and female
          $player.pokedex.register(sp, 0, f, 0, false)
          $player.pokedex.register(sp, 0, f, 1, false)
          $player.pokedex.register(sp, 1, f, 0, false)
          $player.pokedex.register(sp, 1, f, 1, false)
        end
        $player.pokedex.set_owned(sp, false)
      elsif species_data.real_form_name && !species_data.real_form_name.empty?
        g = (species_data.gender_ratio == :AlwaysFemale) ? 1 : 0
        $player.pokedex.register(sp, g, f, 0, false)
        $player.pokedex.register(sp, g, f, 1, false)
      end
      # Add Pokémon (if form 0, i.e. one of each species)
      next if f != 0
      if added >= Settings::NUM_STORAGE_BOXES * box_qty
        completed = false
        next
      end
      added += 1
      $PokemonStorage[(added - 1) / box_qty, (added - 1) % box_qty] = Pokemon.new(sp, 50) # Make every obtained Pokemon Lvl.50
    end
    $player.pokedex.refresh_accessible_dexes
    #pbMessage(_INTL("Storage boxes were filled with one Pokémon of each species."))
    if !completed
      pbMessage(_INTL("Note: The number of storage spaces ({1} boxes of {2}) is less than the number of species.",
                      Settings::NUM_STORAGE_BOXES, box_qty))
    end
end

def pbAllPokemonSetup100
    added = 0
    box_qty = $PokemonStorage.maxPokemon(0)
    completed = true
    GameData::Species.each do |species_data|
      sp = species_data.species
      f = species_data.form
      # Record each form of each species as seen and owned
      if f == 0
        if species_data.single_gendered?
          g = (species_data.gender_ratio == :AlwaysFemale) ? 1 : 0
          $player.pokedex.register(sp, g, f, 0, false)
          $player.pokedex.register(sp, g, f, 1, false)
        else   # Both male and female
          $player.pokedex.register(sp, 0, f, 0, false)
          $player.pokedex.register(sp, 0, f, 1, false)
          $player.pokedex.register(sp, 1, f, 0, false)
          $player.pokedex.register(sp, 1, f, 1, false)
        end
        $player.pokedex.set_owned(sp, false)
      elsif species_data.real_form_name && !species_data.real_form_name.empty?
        g = (species_data.gender_ratio == :AlwaysFemale) ? 1 : 0
        $player.pokedex.register(sp, g, f, 0, false)
        $player.pokedex.register(sp, g, f, 1, false)
      end
      # Add Pokémon (if form 0, i.e. one of each species)
      next if f != 0
      if added >= Settings::NUM_STORAGE_BOXES * box_qty
        completed = false
        next
      end
      added += 1
      $PokemonStorage[(added - 1) / box_qty, (added - 1) % box_qty] = Pokemon.new(sp, 100) # Make every obtained Pokemon Lvl.100
    end
    $player.pokedex.refresh_accessible_dexes
    #pbMessage(_INTL("Storage boxes were filled with one Pokémon of each species."))
    if !completed
      pbMessage(_INTL("Note: The number of storage spaces ({1} boxes of {2}) is less than the number of species.",
                      Settings::NUM_STORAGE_BOXES, box_qty))
    end
end

#===============================================================================
# Fully Optimised Battle Mode Stock Teams
#===============================================================================

#===============================================================================
# Lvl.100 (Full Power/VGC) Poke Paste: https://pokepast.es/774751c5dc2c4500
#===============================================================================

def pbOptimisedPartyQuickStart100
	pkmn1 = Pokemon.new(:MIRAIDON,100)
	pkmn1.item = :CHOICESPECS
	pkmn1.ability_index = 0 # Electric Surge (Ability Indexes go from 0 to 6. 0 to 1 is Base Abilities. 2 to 6 is Hidden Abilities. SY has made it so that nearly all generated Pokemon have 1 Base Ability, set to a Pokemon's general best ability. 2 to 6 is the rest of a Pokemon's ability opitions)
	pkmn1.nature = :MODEST
	pkmn1.learn_move(:ELECTRODRIFT)
	pkmn1.learn_move(:DRACOMETEOR)
	pkmn1.learn_move(:VOLTSWITCH)
	pkmn1.learn_move(:DAZZLINGGLEAM)
	pkmn1.ev[:HP] = 48 # EV's to up to 256 in each Stat, 512 max for total EV Budget. 
	pkmn1.ev[:ATTACK] = 244 # SY uses the EV Allocator Overhaul Plugin. The plugin connects Attack and Sp.Attack Ev's together. The fusion causes Atk and Sp.Atk to reach 768 in budget used, if Speed is maxed out. This behavior is intended by the EV Allocator Overhaul Plugin
	pkmn1.ev[:DEFENSE] = 4
	pkmn1.ev[:SPECIAL_DEFENSE] = 12
	pkmn1.ev[:SPEED] = 204
	pkmn1.iv[:ATTACK] = 0
	pkmn1.tera_type = :FAIRY
	pkmn1.dynamax_able = false # This is only done, so players don't get confused when they want to tera, but the game saids they can Dynamax. 
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:WHIMSICOTT,100)
	pkmn2.item = :COVERTCLOAK
	pkmn2.ability_index = 0 # Prankster
	pkmn2.nature = :TIMID
	pkmn2.learn_move(:MOONBLAST)
	pkmn2.learn_move(:TAILWIND)
	pkmn2.learn_move(:LIGHTSCREEN)
	pkmn2.learn_move(:ENCORE)
	pkmn2.ev[:HP] = 236
	pkmn2.ev[:DEFENSE] = 4
	pkmn2.ev[:SPECIAL_DEFENSE] = 164
	pkmn2.ev[:SPEED] = 108
	pkmn2.iv[:ATTACK] = 0
	pkmn2.tera_type = :DARK
	pkmn2.dynamax_able = false
	pkmn2.calc_stats
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:URSHIFU_1,100)
	pkmn3.item = :FOCUSSASH
	pkmn3.ability_index = 0 # Defiant
	pkmn3.nature = :ADAMANT
	pkmn3.learn_move(:SURGINGSTRIKES)
	pkmn3.learn_move(:CLOSECOMBAT)
	pkmn3.learn_move(:AQUAJET)
	pkmn3.learn_move(:PROTECT)
	pkmn3.ev[:ATTACK] = 252
	pkmn3.ev[:SPECIAL_DEFENSE] = 4
	pkmn3.ev[:SPEED] = 256
	pkmn3.iv[:SPECIAL_ATTACK] = 0
	pkmn3.tera_type = :STELLAR
	pkmn3.dynamax_able = false
	pkmn3.calc_stats
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:OGERPON,100)
	pkmn4.item = :HEARTHFLAMEMASK
	pkmn4.nature = :ADAMANT
	pkmn4.learn_move(:IVYCUDGEL)
	pkmn4.learn_move(:WOODHAMMER)
	pkmn4.learn_move(:FOLLOWME)
	pkmn4.learn_move(:SPIKYSHIELD)
	pkmn4.ev[:HP] = 188
	pkmn4.ev[:ATTACK] = 76
	pkmn4.ev[:DEFENSE] = 52
	pkmn4.ev[:SPECIAL_DEFENSE] = 4
	pkmn4.ev[:SPEED] = 192
	pkmn4.iv[:SPECIAL_ATTACK] = 0
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:FARIGIRAF,100)
	pkmn5.item = :ELECTRICSEED
	pkmn5.ability_index = 0 # Armor Tail
	pkmn5.nature = :BOLD
	pkmn5.learn_move(:FOULPLAY)
	pkmn5.learn_move(:PSYCHICNOISE)
	pkmn5.learn_move(:TRICKROOM)
	pkmn5.learn_move(:HELPINGHAND)
	pkmn5.ev[:HP] = 212
	pkmn5.ev[:ATTACK] = 8
	pkmn5.ev[:DEFENSE] = 164
	pkmn5.ev[:SPECIAL_DEFENSE] = 108
	pkmn5.ev[:SPEED] = 28
	pkmn5.iv[:ATTACK] = 0
	pkmn5.tera_type = :WATER
	pkmn5.dynamax_able = false
	pkmn5.calc_stats
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:IRONHANDS,100)
	pkmn6.item = :ASSAULTVEST
	pkmn6.ability_index = 0 # Quark Drive
	pkmn6.nature = :BRAVE
	pkmn6.learn_move(:DRAINPUNCH)
	pkmn6.learn_move(:LOWKICK)
	pkmn6.learn_move(:WILDCHARGE)
	pkmn6.learn_move(:FAKEOUT)
	pkmn6.ev[:HP] = 84
	pkmn6.ev[:ATTACK] = 180
	pkmn6.ev[:DEFENSE] = 12
	pkmn6.ev[:SPECIAL_DEFENSE] = 236
	pkmn6.iv[:SPEED] = 0
	pkmn6.tera_type = :BUG
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

#===============================================================================
# Lvl.50 (VGC) Poke Paste: https://pokepast.es/ae4e6f640ae46164
#===============================================================================
def pbOptimisedPartyQuickStart50
	pkmn1 = Pokemon.new(:KORAIDON,50)
	pkmn1.item = :LIFEORB
	pkmn1.ability_index = 0 # Drought
	pkmn1.nature = :JOLLY
	pkmn1.learn_move(:PROTECT)
	pkmn1.learn_move(:FLAREBLITZ)
	pkmn1.learn_move(:CLOSECOMBAT)
	pkmn1.learn_move(:FLAMECHARGE)
	pkmn1.ev[:HP] = 32
	pkmn1.ev[:ATTACK] = 228
	pkmn1.ev[:SPEED] = 252
	pkmn1.tera_type = :FIRE
	pkmn1.dynamax_able = false
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:INCINEROAR,50)
	pkmn2.item = :SAFETYGOGGLES
	pkmn2.ability_index = 0 # Intimidate
	pkmn2.nature = :CAREFUL
	pkmn2.learn_move(:FAKEOUT)
	pkmn2.learn_move(:PARTINGSHOT)
	pkmn2.learn_move(:FLAREBLITZ)
	pkmn2.learn_move(:PROTECT)
	pkmn2.ev[:HP] = 244
	pkmn2.ev[:ATTACK] = 4
	pkmn2.ev[:DEFENSE] = 132
	pkmn2.ev[:SPECIAL_DEFENSE] = 84
	pkmn2.ev[:SPEED] = 48
	pkmn2.tera_type = :BUG
	pkmn2.dynamax_able = false
	pkmn2.calc_stats
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:GOTHITELLE,50)
	pkmn3.item = :LEFTOVERS
	pkmn3.ability_index = 2 # Shadow Tag
	pkmn3.nature = :CALM
	pkmn3.learn_move(:PROTECT)
	pkmn3.learn_move(:PSYCHIC)
	pkmn3.learn_move(:FAKEOUT)
	pkmn3.learn_move(:TAUNT)
	pkmn3.ev[:HP] = 256
	pkmn3.ev[:DEFENSE] = 100
	pkmn3.ev[:SPECIAL_DEFENSE] = 156
	pkmn3.iv[:ATTACK] = 0
	pkmn3.tera_type = :WATER
	pkmn3.dynamax_able = false
	pkmn3.calc_stats
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:AMOONGUSS,50)
	pkmn4.item = :MENTALHERB
	pkmn4.ability_index = 3 # Regenerator
	pkmn4.nature = :BOLD
	pkmn4.learn_move(:PROTECT)
	pkmn4.learn_move(:RAGEPOWDER)
	pkmn4.learn_move(:SPORE)
	pkmn4.learn_move(:SLUDGEBOMB)
	pkmn4.ev[:HP] = 240
	pkmn4.ev[:DEFENSE] = 236
	pkmn4.ev[:SPECIAL_DEFENSE] = 36
	pkmn4.iv[:SPEED] = 27
	pkmn4.tera_type = :DARK
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:SCREAMTAIL,50)
	pkmn5.item = :BOOSTERENERGY
	pkmn5.ability_index = 0 # Protosynthesis
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:PROTECT)
	pkmn5.learn_move(:ENCORE)
	pkmn5.learn_move(:DISABLE)
	pkmn5.learn_move(:PERISHSONG)
	pkmn5.ev[:HP] = 228
	pkmn5.ev[:ATTACK] = 4
	pkmn5.ev[:DEFENSE] = 148
	pkmn5.ev[:SPECIAL_DEFENSE] = 28
	pkmn5.ev[:SPEED] = 104
	pkmn5.iv[:ATTACK] = 0
	pkmn5.tera_type = :ELECTRIC
	pkmn5.dynamax_able = false
	pkmn5.calc_stats
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:FLUTTERMANE,50)
	pkmn6.item = :FOCUSSASH
	pkmn6.ability_index = 0 # Protosynthesis
	pkmn6.nature = :TIMID
	pkmn6.learn_move(:PROTECT)
	pkmn6.learn_move(:ICYWIND)
	pkmn6.learn_move(:MOONBLAST)
	pkmn6.learn_move(:SHADOWBALL)
	pkmn6.ev[:ATTACK] = 252
	pkmn6.ev[:SPECIAL_DEFENSE] = 4
	pkmn6.ev[:SPEED] = 256
	pkmn6.iv[:ATTACK] = 0
	pkmn6.tera_type = :NORMAL
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

#===============================================================================
# Lvl.30 (NFE, Not Fully Evolved) Poke Paste: https://pokepast.es/64c6412707c10285
#===============================================================================
def pbOptimisedPartyQuickStart30
	pkmn1 = Pokemon.new(:FROGADIER,30)
	pkmn1.item = :CHOICESPECS
	pkmn1.ability_index = 0 # Protean
	pkmn1.nature = :TIMID
	pkmn1.learn_move(:SURF)
	pkmn1.learn_move(:ICEBEAM)
	pkmn1.learn_move(:UTURN)
	pkmn1.learn_move(:SWITCHEROO)
	pkmn1.ev[:ATTACK] = 256 # SY uses the EV Allocator Overhaul Plugin. The plugin connects Attack and Sp.Attack Ev's together. 
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :WATER
	pkmn1.dynamax_able = false
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:MONFERNO,30)
	pkmn2.item = :EVIOLITE  
	pkmn2.ability_index = 3 # Iron Fist
	pkmn2.nature = :ADAMANT
	pkmn2.learn_move(:FIREPUNCH)
	pkmn2.learn_move(:THUNDERPUNCH)
	pkmn2.learn_move(:KNOCKOFF)
	pkmn2.learn_move(:SWORDSDANCE)
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :FIRE
	pkmn2.dynamax_able = false
	pkmn2.calc_stats
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:PILOSWINE,30)
	pkmn3.item = :EVIOLITE
	pkmn3.ability_index = 0 # Thick Fat
	pkmn3.nature = :ADAMANT
	pkmn3.learn_move(:EARTHQUAKE)
	pkmn3.learn_move(:ICICLECRASH)
	pkmn3.learn_move(:ICESHARD)
	pkmn3.learn_move(:TRAILBLAZE)
	pkmn3.ev[:HP] = 104
	pkmn3.ev[:ATTACK] = 252
	pkmn3.ev[:SPEED] = 156
	pkmn3.iv[:SPECIAL_ATTACK] = 0
	pkmn3.tera_type = :ICE
	pkmn3.dynamax_able = false
	pkmn3.calc_stats
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:THWACKEY,30)
	pkmn4.item = :LIFEORB
	pkmn4.ability_index = 0 # Grassy Surge
	pkmn4.nature = :ADAMANT
	pkmn4.learn_move(:WOODHAMMER)
	pkmn4.learn_move(:GRASSYGLIDE)
	pkmn4.learn_move(:KNOCKOFF)
	pkmn4.learn_move(:UTURN)
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:SPEED] = 256
	pkmn4.iv[:SPECIAL_ATTACK] = 0
	pkmn4.tera_type = :GRASS
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:TINKATUFF,30)
	pkmn5.item = :EVIOLITE
	pkmn5.ability_index = 5 # Pickpocket
	pkmn5.nature = :CAREFUL
	pkmn5.learn_move(:SLAM)
	pkmn5.learn_move(:STEALTHROCK)
	pkmn5.learn_move(:THUNDERWAVE)
	pkmn5.learn_move(:ENCORE)
	pkmn5.ev[:HP] = 252
	pkmn5.ev[:SPECIAL_DEFENSE] = 92
	pkmn5.ev[:SPEED] = 168
	pkmn5.iv[:SPECIAL_ATTACK] = 0
	pkmn5.tera_type = :FAIRY
	pkmn5.dynamax_able = false
	pkmn5.calc_stats
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:WARTORTLE,30)
	pkmn6.item = :EVIOLITE
	pkmn6.ability_index = 3 # Shell Armor
	pkmn6.nature = :MODEST
	pkmn6.learn_move(:SURF)
	pkmn6.learn_move(:ICEBEAM)
	pkmn6.learn_move(:SHELLSMASH)
	pkmn6.learn_move(:RAPIDSPIN)
	pkmn6.ev[:HP] = 200
	pkmn6.ev[:ATTACK] = 252 # SY uses the EV Allocator Overhaul Plugin. The plugin connects Attack and Sp.Attack Ev's together. 
	pkmn6.ev[:SPEED] = 60
	pkmn6.tera_type = :WATER
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

#===============================================================================
# Lvl.5 (Baby, Little Cup Pokemon) Poke Paste: https://pokepast.es/84afcc680ca71bbe
#===============================================================================
def pbOptimisedPartyQuickStart5
	pkmn1 = Pokemon.new(:MIENFOO,5)
	pkmn1.item = :EVIOLITE
	pkmn1.ability_index = 5 # Regenerator
	pkmn1.nature = :JOLLY
	pkmn1.learn_move(:HIGHJUMPKICK)
	pkmn1.learn_move(:KNOCKOFF)
	pkmn1.learn_move(:UTURN)
	pkmn1.learn_move(:SUBSTITUTE)
	pkmn1.ev[:HP] = 36 
	pkmn1.ev[:ATTACK] = 4
	pkmn1.ev[:DEFENSE] = 196
	pkmn1.ev[:SPECIAL_DEFENSE] = 36
	pkmn1.ev[:SPEED] = 240
	pkmn1.tera_type = :STEEL
	pkmn1.dynamax_able = false
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:VULLABY,5)
	pkmn2.item = :EVIOLITE
	pkmn2.ability_index = 4 # Weak Armor
	pkmn2.nature = :ADAMANT
	pkmn2.learn_move(:BRAVEBIRD)
	pkmn2.learn_move(:KNOCKOFF)
	pkmn2.learn_move(:ROOST)
	pkmn2.learn_move(:UTURN)
	pkmn2.ev[:ATTACK] = 236
	pkmn2.ev[:DEFENSE] = 76
	pkmn2.ev[:SPEED] = 200
	pkmn2.tera_type = :GHOST
	pkmn2.dynamax_able = false
	pkmn2.calc_stats
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:FOONGUS,5)
	pkmn3.item = :EVIOLITE
	pkmn3.ability_index = 3 # Regenerator
	pkmn3.nature = :BOLD
	pkmn3.learn_move(:SPORE)
	pkmn3.learn_move(:GIGADRAIN)
	pkmn3.learn_move(:SLUDGEBOMB)
	pkmn3.learn_move(:SYNTHESIS)
	pkmn3.ev[:HP] = 200
	pkmn3.ev[:DEFENSE] = 156
	pkmn3.ev[:SPECIAL_DEFENSE] = 156
	pkmn3.tera_type = :WATER
	pkmn3.dynamax_able = false
	pkmn3.calc_stats
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:DIGLETT,5)
	pkmn4.form = 1 # Alolan form 
	pkmn4.item = :LIFEORB
	pkmn4.ability_index = 0 # Tangling Hair
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:EARTHQUAKE)
	pkmn4.learn_move(:SUCKERPUNCH)
	pkmn4.learn_move(:ROCKBLAST)
	pkmn4.learn_move(:IRONHEAD)
	pkmn4.ev[:HP] = 36
	pkmn4.ev[:ATTACK] = 236
	pkmn4.ev[:DEFENSE] = 36
	pkmn4.ev[:SPEED] = 204
	pkmn4.tera_type = :STELLAR
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:GLIMMET,5) 
	pkmn5.item = :EVIOLITE
	pkmn5.ability_index = 0 # Toxic Debris
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:STEALTHROCK)
	pkmn5.learn_move(:ANCIENTPOWER)
	pkmn5.learn_move(:SLUDGEBOMB)
	pkmn5.learn_move(:MUDSHOT)
	pkmn5.ev[:HP] = 96
	pkmn5.ev[:ATTACK] = 116 # SY uses the EV Allocator Overhaul Plugin. The plugin connects Attack and Sp.Attack Ev's together. 
	pkmn5.ev[:DEFENSE] = 100
	pkmn5.ev[:SPEED] = 200
	pkmn5.tera_type = :FLYING
	pkmn5.dynamax_able = false
	pkmn5.calc_stats
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:SHELLDER,5) 
	pkmn6.item = :EVIOLITE
	pkmn6.ability_index = 2 # Skill Link
	pkmn6.nature = :ADAMANT
	pkmn6.learn_move(:SHELLSMASH)
	pkmn6.learn_move(:LIQUIDATION)
	pkmn6.learn_move(:ROCKBLAST)
	pkmn6.learn_move(:ICICLESPEAR)
	pkmn6.ev[:HP] = 40
	pkmn6.ev[:ATTACK] = 236
	pkmn6.ev[:DEFENSE] = 36
	pkmn6.ev[:SPEED] = 200
	pkmn6.tera_type = :GHOST
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

#===============================================================================
# Lvl.5 (Gen 1 to Gen 9 Pokemon Teams, this exists to allow playtesters to have Optimised teams,
# without wasting time setting up a fully trained competitive teams. It also serves to truly poke 
# and prod the 435 trainers of battle mode, in order to identify tedious filler text, and potential 
# bugs and crashes, rather than just sticking to the stock Metagame teams)
#===============================================================================
def pbOptimisedGen1GrassPartyQuickStart5 # Poke Paste: https://pokepast.es/796bf2bd36e89d42
	pkmn1 = Pokemon.new(:NINETALES,5)
	pkmn1.item = :HEATROCK
	pkmn1.ability_index = 0 # DROUGHT
	pkmn1.nature = :TIMID
	pkmn1.learn_move(:FLAMETHROWER)
	pkmn1.learn_move(:ENCORE)
	pkmn1.learn_move(:HEALINGWISH)
	pkmn1.learn_move(:WILLOWISP)
	pkmn1.ev[:HP] = 248
	pkmn1.ev[:ATTACK] = 0 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn1.ev[:DEFENSE] = 20
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 244
	pkmn1.tera_type = :GHOST
	pkmn1.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:CERULEDGE,5)
	pkmn2.item = :FOCUSSASH
	pkmn2.ability_index = 2 # WEAKARMOR
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:SWORDSDANCE)
	pkmn2.learn_move(:BITTERBLADE)
	pkmn2.learn_move(:SOLARBLADE)
	pkmn2.learn_move(:TERABLAST)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :FAIRY
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:VENUSAUR,5)
	pkmn3.item = :LIFEORB
	pkmn3.ability_index = 3 # CHLOROPHYLL
	pkmn3.nature = :MODEST
	pkmn3.learn_move(:GROWTH)
	pkmn3.learn_move(:GIGADRAIN)
	pkmn3.learn_move(:SLUDGEBOMB)
	pkmn3.learn_move(:WEATHERBALL)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 252
	pkmn3.ev[:DEFENSE] = 4
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :FIRE
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:HATTERENE,5)
	pkmn4.item = :EJECTBUTTON
	pkmn4.ability_index = 0 # MAGICBOUNCE
	pkmn4.nature = :BOLD
	pkmn4.learn_move(:HEALINGWISH)
	pkmn4.learn_move(:PSYCHICNOISE)
	pkmn4.learn_move(:DAZZLINGGLEAM)
	pkmn4.learn_move(:NUZZLE)
	pkmn4.ev[:HP] = 256
	pkmn4.ev[:ATTACK] = 0
	pkmn4.ev[:DEFENSE] = 176
	pkmn4.ev[:SPECIAL_DEFENSE] = 72
	pkmn4.ev[:SPEED] = 8
	pkmn4.tera_type = :STEEL
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:GREATTUSK,5)
	pkmn5.item = :ROCKYHELMET
	pkmn5.ability_index = 0 # PROTOSYNTHESIS
	pkmn5.nature = :JOLLY
	pkmn5.learn_move(:HEADLONGRUSH)
	pkmn5.learn_move(:ICESPINNER)
	pkmn5.learn_move(:RAPIDSPIN)
	pkmn5.learn_move(:STEALTHROCK)
	pkmn5.ev[:HP] = 252
	pkmn5.ev[:ATTACK] = 4
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :FIRE
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:WALKINGWAKE,5)
	pkmn6.item = :CHOICESPECS
	pkmn6.ability_index = 0 # PROTOSYNTHESIS
	pkmn6.nature = :MODEST
	pkmn6.learn_move(:HYDROSTEAM)
	pkmn6.learn_move(:DRACOMETEOR)
	pkmn6.learn_move(:FLAMETHROWER)
	pkmn6.learn_move(:DRAGONPULSE)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.tera_type = :WATER
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen1FirePartyQuickStart5 # Poke Paste: https://pokepast.es/e4bf2a1d848e8146
	pkmn1 = Pokemon.new(:CHARIZARD,5)
	pkmn1.item = :CHOICESPECS
	pkmn1.ability_index = 3 # SOLARPOWER
	pkmn1.nature = :TIMID
	pkmn1.learn_move(:HEATWAVE)
	pkmn1.learn_move(:OVERHEAT)
	pkmn1.learn_move(:WEATHERBALL)
	pkmn1.learn_move(:AEROBLAST)
	pkmn1.ev[:HP] = 0 # For IV's they can be set to 31 or 0 on the Info Summary Option Screen.
	pkmn1.ev[:ATTACK] = 256 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :GHOST
	pkmn1.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:TORKOAL,5)
	pkmn2.item = :EJECTPACK
	pkmn2.ability_index = 2 # DROUGHT
	pkmn2.nature = :QUIET
	pkmn2.learn_move(:ERUPTION)
	pkmn2.learn_move(:OVERHEAT)
	pkmn2.learn_move(:HELPINGHAND)
	pkmn2.learn_move(:PROTECT)
	pkmn2.ev[:HP] = 176
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 72
	pkmn2.ev[:SPEED] = 0
	pkmn2.tera_type = :FIRE
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:PORYGON2,5)
	pkmn3.item = :EVIOLITE
	pkmn3.ability_index = 0 # ANALYTIC
	pkmn3.nature = :BOLD
	pkmn3.learn_move(:ICEBEAM)
	pkmn3.learn_move(:EGGBOMB)
	pkmn3.learn_move(:TRICKROOM)
	pkmn3.learn_move(:RECOVER)
	pkmn3.ev[:HP] = 256
	pkmn3.ev[:ATTACK] = 8
	pkmn3.ev[:DEFENSE] = 176
	pkmn3.ev[:SPECIAL_DEFENSE] = 72
	pkmn3.ev[:SPEED] = 0
	pkmn3.tera_type = :FIGHTING
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:INCINEROAR,5)
	pkmn4.item = :HONEY
	pkmn4.ability_index = 0 # INTIMIDATE
	pkmn4.nature = :CAREFUL
	pkmn4.learn_move(:FLAREBLITZ)
	pkmn4.learn_move(:KNOCKOFF)
	pkmn4.learn_move(:FAKEOUT)
	pkmn4.learn_move(:PARTINGSHOT)
	pkmn4.ev[:HP] = 248
	pkmn4.ev[:ATTACK] = 0
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 212
	pkmn4.ev[:SPEED] = 52
	pkmn4.tera_type = :DRAGON
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:JUMPLUFF,5)
	pkmn5.item = :COVERTCLOAK
	pkmn5.ability_index = 2 # CHLOROPHYLL
	pkmn5.nature = :JOLLY
	pkmn5.learn_move(:EGGBOMB)
	pkmn5.learn_move(:SUNNYDAY)
	pkmn5.learn_move(:RAGEPOWDER)
	pkmn5.learn_move(:TAILWIND)
	pkmn5.ev[:HP] = 256
	pkmn5.ev[:ATTACK] = 0
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :WATER
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:URSALUNA,5)
	pkmn6.item = :FLAMEORB
	pkmn6.ability_index = 0 # GUTS
	pkmn6.nature = :BRAVE
	pkmn6.learn_move(:FACADE)
	pkmn6.learn_move(:HEADLONGRUSH)
	pkmn6.learn_move(:FIREPUNCH)
	pkmn6.learn_move(:PROTECT)
	pkmn6.ev[:HP] = 140
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 44
	pkmn6.ev[:SPECIAL_DEFENSE] = 68
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :FAIRY
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen1WaterPartyQuickStart5 # Poke Paste: https://pokepast.es/18734f48aa3bb354
	pkmn1 = Pokemon.new(:BASCULEGION,5)
	pkmn1.item = :LIFEORB
	pkmn1.ability_index = 5 # SWIFTSWIM
	pkmn1.nature = :ADAMANT
	pkmn1.learn_move(:LASTRESPECTS)
	pkmn1.learn_move(:WAVECRASH)
	pkmn1.learn_move(:AQUAJET)
	pkmn1.learn_move(:PROTECT)
	pkmn1.ev[:HP] = 28 # For IV's they can be set to 31 or 0 on the Info Summary Option Screen.
	pkmn1.ev[:ATTACK] = 220 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn1.ev[:DEFENSE] = 124
	pkmn1.ev[:SPECIAL_DEFENSE] = 4
	pkmn1.ev[:SPEED] = 136
	pkmn1.tera_type = :WATER
	pkmn1.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:BLASTOISE,5)
	pkmn2.item = :WHITEHERB
	pkmn2.ability_index = 2 # STORMDRAIN
	pkmn2.nature = :CALM
	pkmn2.learn_move(:FAKEOUT)
	pkmn2.learn_move(:BUBBLEBEAM)
	pkmn2.learn_move(:EGGBOMB)
	pkmn2.learn_move(:SHELLSMASH)
	pkmn2.ev[:HP] = 228
	pkmn2.ev[:ATTACK] = 192
	pkmn2.ev[:DEFENSE] = 12
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 80
	pkmn2.tera_type = :DRAGON
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:INCINEROAR,5)
	pkmn3.item = :HONEY
	pkmn3.ability_index = 0 # INTIMIDATE
	pkmn3.nature = :IMPISH
	pkmn3.learn_move(:FAKEOUT)
	pkmn3.learn_move(:DARKESTLARIAT)
	pkmn3.learn_move(:UTURN)
	pkmn3.learn_move(:FLAREBLITZ)
	pkmn3.ev[:HP] = 248
	pkmn3.ev[:ATTACK] = 4
	pkmn3.ev[:DEFENSE] = 188
	pkmn3.ev[:SPECIAL_DEFENSE] = 68
	pkmn3.ev[:SPEED] = 4
	pkmn3.tera_type = :BUG
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:PELIPPER,5)
	pkmn4.item = :FOCUSSASH
	pkmn4.ability_index = 0 # DRIZZLE
	pkmn4.nature = :MODEST
	pkmn4.learn_move(:HURRICANE)
	pkmn4.learn_move(:ICYWIND)
	pkmn4.learn_move(:TAILWIND)
	pkmn4.learn_move(:RAINDANCE)
	pkmn4.ev[:HP] = 4
	pkmn4.ev[:ATTACK] = 252
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :GROUND
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:URSALUNA_1,5)
	pkmn5.item = :CHOICESPECS
	pkmn5.ability_index = 0 # MINDSEYE
	pkmn5.nature = :MODEST
	pkmn5.learn_move(:HYPERVOICE)
	pkmn5.learn_move(:EARTHPOWER)
	pkmn5.learn_move(:SNARL)
	pkmn5.learn_move(:MOONBLAST)
	pkmn5.ev[:HP] = 256
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 0
	pkmn5.tera_type = :GHOST
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:OVERQWIL,5)
	pkmn6.item = :SAFETYGOGGLES
	pkmn6.ability_index = 3 # WATERBUBBLE
	pkmn6.nature = :JOLLY
	pkmn6.learn_move(:GUNKSHOT)
	pkmn6.learn_move(:EGGBOMB)
	pkmn6.learn_move(:ACIDSPRAY)
	pkmn6.learn_move(:LIQUIDATION)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.tera_type = :FLYING
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen1ElectricPartyQuickStart5 # Poke Paste: https://pokepast.es/1cd570d0b5e4d125
	pkmn1 = Pokemon.new(:CHARIZARD,5)
	pkmn1.item = :LIFEORB
	pkmn1.ability_index = 3 # SOLARPOWER
	pkmn1.nature = :TIMID
	pkmn1.learn_move(:FLAMETHROWER)
	pkmn1.learn_move(:AEROBLAST)
	pkmn1.learn_move(:SCORCHINGSANDS)
	pkmn1.learn_move(:PROTECT)
	pkmn1.ev[:HP] = 0 # For IV's they can be set to 31 or 0 on the Info Summary Option Screen.
	pkmn1.ev[:ATTACK] = 256 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :FIRE
	pkmn1.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:RAICHU,5)
	pkmn2.item = :FOCUSSASH
	pkmn2.ability_index = 0 # LIGHTNINGROD
	pkmn2.nature = :TIMID
	pkmn2.learn_move(:FAKEOUT)
	pkmn2.learn_move(:ENCORE)
	pkmn2.learn_move(:VOLTSWITCH)
	pkmn2.learn_move(:ENDEAVOR)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :FLYING
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:TORKOAL,5)
	pkmn3.item = :ASSAULTVEST
	pkmn3.ability_index = 2 # DROUGHT
	pkmn3.nature = :MODEST
	pkmn3.learn_move(:HEATWAVE)
	pkmn3.learn_move(:FLAMETHROWER)
	pkmn3.learn_move(:SOLARBEAM)
	pkmn3.learn_move(:CLEARSMOG)
	pkmn3.ev[:HP] = 208
	pkmn3.ev[:ATTACK] = 140
	pkmn3.ev[:DEFENSE] = 164
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 0
	pkmn3.tera_type = :GRASS
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:GASTRODON,5)
	pkmn4.item = :HONEY
	pkmn4.ability_index = 4 # STORMDRAIN
	pkmn4.nature = :BOLD
	pkmn4.learn_move(:EARTHPOWER)
	pkmn4.learn_move(:WEATHERBALL)
	pkmn4.learn_move(:YAWN)
	pkmn4.learn_move(:PROTECT)
	pkmn4.ev[:HP] = 256
	pkmn4.ev[:ATTACK] = 92
	pkmn4.ev[:DEFENSE] = 88
	pkmn4.ev[:SPECIAL_DEFENSE] = 76
	pkmn4.ev[:SPEED] = 0
	pkmn4.tera_type = :FIRE
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:TALONFLAME,5)
	pkmn5.item = :SAFETYGOGGLES
	pkmn5.ability_index = 0 # GALEWINGS
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:WILLOWISP)
	pkmn5.learn_move(:AIRSLASH)
	pkmn5.learn_move(:TAILWIND)
	pkmn5.learn_move(:TAUNT)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 252
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 64
	pkmn5.tera_type = :GHOST
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:TSAREENA,5)
	pkmn6.item = :ZOOMLENS
	pkmn6.ability_index = 0 # QUEENLYMAJESTY
	pkmn6.nature = :JOLLY
	pkmn6.learn_move(:POWERWHIP)
	pkmn6.learn_move(:MEGAKICK)
	pkmn6.learn_move(:TRIPLEAXEL)
	pkmn6.learn_move(:PROTECT)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.tera_type = :WATER
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen1FairyPartyQuickStart5 # Poke Paste: https://pokepast.es/5f79ccf1b3607ea3
	pkmn1 = Pokemon.new(:BLISSEY,5)
	pkmn1.item = :HEAVYDUTYBOOTS 
	pkmn1.ability_index = 4 # NATURALCURE 
	pkmn1.nature = :CALM
	pkmn1.learn_move(:CALMMIND)
	pkmn1.learn_move(:FLAMETHROWER)
	pkmn1.learn_move(:SEISMICTOSS)
	pkmn1.learn_move(:SOFTBOILED)
	pkmn1.ev[:HP] = 0 # For IV's they can be set to 31 or 0 on the Info Summary Option Screen.
	pkmn1.ev[:ATTACK] = 0 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn1.ev[:DEFENSE] = 256
	pkmn1.ev[:SPECIAL_DEFENSE] = 256
	pkmn1.ev[:SPEED] = 0
	pkmn1.tera_type = :DARK
	pkmn1.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:CLEFABLE,5)
	pkmn2.item = :STICKYBARB
	pkmn2.ability_index = 2 # MAGICGUARD
	pkmn2.nature = :BOLD
	pkmn2.learn_move(:KNOCKOFF)
	pkmn2.learn_move(:MOONBLAST)
	pkmn2.learn_move(:MOONLIGHT)
	pkmn2.learn_move(:WISH)
	pkmn2.ev[:HP] = 252
	pkmn2.ev[:ATTACK] = 0
	pkmn2.ev[:DEFENSE] = 252
	pkmn2.ev[:SPECIAL_DEFENSE] = 8
	pkmn2.ev[:SPEED] = 0
	pkmn2.tera_type = :STEEL
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:GLISCOR,5)
	pkmn3.item = :MENTALHERB
	pkmn3.ability_index = 3 # LEVITATE
	pkmn3.nature = :IMPISH
	pkmn3.learn_move(:RUINATION)
	pkmn3.learn_move(:TOXIC)
	pkmn3.learn_move(:SPIKES)
	pkmn3.learn_move(:PROTECT)
	pkmn3.ev[:HP] = 252
	pkmn3.ev[:ATTACK] = 0
	pkmn3.ev[:DEFENSE] = 252
	pkmn3.ev[:SPECIAL_DEFENSE] = 8
	pkmn3.ev[:SPEED] = 0
	pkmn3.tera_type = :ELECTRIC
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:TINGLU,5)
	pkmn4.item = :REDCARD
	pkmn4.ability_index = 0 # VESSELOFRUIN
	pkmn4.nature = :CAREFUL
	pkmn4.learn_move(:STEALTHROCK)
	pkmn4.learn_move(:EARTHQUAKE)
	pkmn4.learn_move(:REST)
	pkmn4.learn_move(:PROTECT)
	pkmn4.ev[:HP] = 252
	pkmn4.ev[:ATTACK] = 0
	pkmn4.ev[:DEFENSE] = 8
	pkmn4.ev[:SPECIAL_DEFENSE] = 252
	pkmn4.ev[:SPEED] = 0
	pkmn4.tera_type = :GHOST
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:DONDOZO,5)
	pkmn5.item = :CHESTOBERRY
	pkmn5.ability_index = 0 # UNAWARE
	pkmn5.nature = :IMPISH
	pkmn5.learn_move(:EGGBOMB)
	pkmn5.learn_move(:CURSE)
	pkmn5.learn_move(:BODYPRESS)
	pkmn5.learn_move(:REST)
	pkmn5.ev[:HP] = 256
	pkmn5.ev[:ATTACK] = 0
	pkmn5.ev[:DEFENSE] = 256
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 0
	pkmn5.tera_type = :FIGHTING
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:AMOONGUSS,5)
	pkmn6.item = :HONEY
	pkmn6.ability_index = 3 # REGENERATOR
	pkmn6.nature = :RELAXED
	pkmn6.learn_move(:TOXIC)
	pkmn6.learn_move(:FOULPLAY)
	pkmn6.learn_move(:STRENGTHSAP) # This is one of the universal Move Type Moves for Grass types. I do not care what specfic Pokemon get the universal type moves. I refuse to manually edit the Level Up/Tutor/Egg Moves of all 1025+ Pokemon. It's a waste of time, and not once in any Pokemon game have I liked any Pokemon's natural Level Up Movepool 
	pkmn6.learn_move(:CUT) # This is one of the universal Move Type Moves for Grass types. 
	pkmn6.ev[:HP] = 252
	pkmn6.ev[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 252
	pkmn6.ev[:SPECIAL_DEFENSE] = 8
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :STEEL
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen1NormalPartyQuickStart5 # Team Craft Info: https://www.smogon.com/forums/threads/the-infamous-evopass-a-sm-ubers-rmt.3591806/
	pkmn1 = Pokemon.new(:MEW,5)
	pkmn1.item = :FOCUSSASH
	pkmn1.ability_index = 3 # PRANKSTER 
	pkmn1.nature = :JOLLY
	pkmn1.learn_move(:TAUNT)
	pkmn1.learn_move(:TAILWIND)
	pkmn1.learn_move(:GRAVITY)
	pkmn1.learn_move(:EXPLOSION)
	pkmn1.ev[:HP] = 8 # For IV's they can be set to 31 or 0 on the Info Summary Option Screen.
	pkmn1.ev[:ATTACK] = 84 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn1.ev[:DEFENSE] = 164
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :STEEL
	pkmn1.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:EEVEE,5)
	pkmn2.item = :EEVIUMZ
	pkmn2.ability_index = 6 # SIMPLE 
	pkmn2.nature = :HARDY # A netural nature is used, because Eevee's job in this team is to send it's Evo boosts to it's teammates
	pkmn2.learn_move(:LASTRESORT)
	pkmn2.learn_move(:BATONPASS)
	pkmn2.learn_move(:TAUNT) # All 1025+ Pokemon Evolution lines have had their movepools fused together, via Egg Move links and Ultimate Move Tutor. Eevee and it's evolutions as a result, learn all each other's moves, such as Sappy Seed. This is the case for all Pokemon Evolution lines, and stacks on top of the universal type moves and VGC Starter moves. If using the Sleep Status, replace Taunt with Sing. SY uses the Drowzy status, due to Sleep's nature being highly abusable at the highest level
	pkmn2.learn_move(:SUBSTITUTE)
	pkmn2.ev[:HP] = 240 # For IV's they can be set to 31 or 0 on the Info Summary Option Screen.
	pkmn2.ev[:ATTACK] = 0 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn2.ev[:DEFENSE] = 36
	pkmn2.ev[:SPECIAL_DEFENSE] = 16
	pkmn2.ev[:SPEED] = 220
	pkmn2.tera_type = :GHOST
	pkmn2.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:ESPEON,5)
	pkmn3.item = :LEFTOVERS
	pkmn3.ability_index = 0 # MAGICBOUNCE
	pkmn3.nature = :BOLD
	pkmn3.learn_move(:DAZZLINGGLEAM)
	pkmn3.learn_move(:STOREDPOWER)
	pkmn3.learn_move(:CALMMIND)
	pkmn3.learn_move(:BATONPASS)
	pkmn3.ev[:HP] = 248
	pkmn3.ev[:ATTACK] = 12
	pkmn3.ev[:DEFENSE] = 252
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 0
	pkmn3.tera_type = :ELECTRIC
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:KROOKODILE,5)
	pkmn4.item = :CHOICEBAND
	pkmn4.ability_index = 0 # MOXIE
	pkmn4.nature = :ADAMANT
	pkmn4.learn_move(:POWERTRIP)
	pkmn4.learn_move(:BEATUP)
	pkmn4.learn_move(:PURSUIT)
	pkmn4.learn_move(:BODYSLAM)
	pkmn4.ev[:HP] = 112
	pkmn4.ev[:ATTACK] = 252
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 148
	pkmn4.tera_type = :POISON
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:ARCEUS_17,5) # Tweaks to the Legend Plate mean Arceus's forms are obtainable without holding the type plates. Dark Form is chosen for Prankster Immunity, before the Legend Plate kicks in 
	pkmn5.item = :LEGENDPLATE # Changes Arceus to any optimal offense type when it uses Judgement
	pkmn5.ability_index = 0 # MULTITYPE
	pkmn5.nature = :MODEST
	pkmn5.learn_move(:JUDGMENT)
	pkmn5.learn_move(:NORETREAT)
	pkmn5.learn_move(:BATONPASS)
	pkmn5.learn_move(:TAUNT)
	pkmn5.ev[:HP] = 116
	pkmn5.ev[:ATTACK] = 116
	pkmn5.ev[:DEFENSE] = 76
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 204
	pkmn5.tera_type = :STELLAR
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:DITTO,5)
	pkmn6.item = :CHOICESCARF
	pkmn6.ability_index = 4 # IMPOSTER
	pkmn6.nature = :RELAXED # This nature + the below EV Spread ensures 4 Struggle uses and minimum Struggle damage from opponent Ditto. Slowest speed stops user's Ditto from kicking in first, allowing transformed Ditto to have more PP.
	pkmn6.learn_move(:TRANSFORM)
	pkmn6.ev[:HP] = 256 # For IV's, they can be set to 31 or 0 on the Info Summary Option Screen.
	pkmn6.ev[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 256
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :FAIRY
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen2GrassPartyQuickStart5 # Poke Paste: https://pokepast.es/bf868cdeb163a7c9
	pkmn1 = Pokemon.new(:MEGANIUM,5)
	pkmn1.item = :POWERHERB
	pkmn1.ability_index = 2 # THICKFAT
	pkmn1.nature = :BOLD
	pkmn1.learn_move(:GEOMANCY)
	pkmn1.learn_move(:LEECHSEED)
	pkmn1.learn_move(:DRAGONTAIL)
	pkmn1.learn_move(:LUNARBLESSING)
	pkmn1.ev[:HP] = 252
	pkmn1.ev[:ATTACK] = 0 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn1.ev[:DEFENSE] = 8
	pkmn1.ev[:SPECIAL_DEFENSE] = 252
	pkmn1.ev[:SPEED] = 0
	pkmn1.tera_type = :POISON
	pkmn1.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:LILLIGANT_1,5)
	pkmn2.item = :FOCUSSASH
	pkmn2.ability_index = 1 # CHLOROPHYLL
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:AFTERYOU)
	pkmn2.learn_move(:LEAFBLADE)
	pkmn2.learn_move(:EGGBOMB)
	pkmn2.learn_move(:STUNSPORE)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :FIRE
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:DRAGAPULT,5)
	pkmn3.item = :LIFEORB
	pkmn3.ability_index = 5 # CLEARBODY
	pkmn3.nature = :JOLLY
	pkmn3.learn_move(:DRAGONDARTS)
	pkmn3.learn_move(:SHADOWFORCE)
	pkmn3.learn_move(:TERABLAST)
	pkmn3.learn_move(:PROTECT)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :FIGHTING
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:TORKOAL,5)
	pkmn4.item = :CHOICESPECS
	pkmn4.ability_index = 2 # DROUGHT
	pkmn4.nature = :MODEST
	pkmn4.learn_move(:ERUPTION)
	pkmn4.learn_move(:HEATWAVE)
	pkmn4.learn_move(:SOLARBEAM)
	pkmn4.learn_move(:EARTHPOWER)
	pkmn4.ev[:HP] = 256
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 0
	pkmn4.tera_type = :FLYING
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:TYPHLOSION_1,5)
	pkmn5.item = :CHOICESCARF
	pkmn5.ability_index = 0 # SOULHEART
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:ERUPTION)
	pkmn5.learn_move(:HEATWAVE)
	pkmn5.learn_move(:FLAMETHROWER)
	pkmn5.learn_move(:EGGBOMB)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :GRASS
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:WEEZING_1,5)
	pkmn6.item = :HONEY
	pkmn6.ability_index = 2 # NEUTRALIZINGGAS
	pkmn6.nature = :CALM
	pkmn6.learn_move(:TAUNT)
	pkmn6.learn_move(:WILLOWISP)
	pkmn6.learn_move(:STRANGESTEAM)
	pkmn6.learn_move(:PROTECT)
	pkmn6.ev[:HP] = 256
	pkmn6.ev[:ATTACK] = 4
	pkmn6.ev[:DEFENSE] = 52
	pkmn6.ev[:SPECIAL_DEFENSE] = 156
	pkmn6.ev[:SPEED] = 44
	pkmn6.tera_type = :DARK
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen2FirePartyQuickStart5 # Poke Paste: https://pokepast.es/0048bf1a01a173c2
	pkmn1 = Pokemon.new(:TYPHLOSION,5)
	pkmn1.item = :CHOICESPECS
	pkmn1.ability_index = 0 # SOULHEART
	pkmn1.nature = :TIMID
	pkmn1.learn_move(:ERUPTION)
	pkmn1.learn_move(:HEATWAVE)
	pkmn1.learn_move(:FOCUSBLAST)
	pkmn1.learn_move(:EGGBOMB)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :GRASS
	pkmn1.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:HITMONTOP,5)
	pkmn2.item = :ROCKYHELMET
	pkmn2.ability_index = 4 # INTIMIDATE
	pkmn2.nature = :ADAMANT
	pkmn2.learn_move(:FAKEOUT)
	pkmn2.learn_move(:REVENGE)
	pkmn2.learn_move(:WIDEGUARD)
	pkmn2.learn_move(:COACHING)
	pkmn2.ev[:HP] = 252
	pkmn2.ev[:ATTACK] = 56
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 204
	pkmn2.tera_type = :GROUND
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:DRAGONITE,5)
	pkmn3.item = :LOADEDDICE
	pkmn3.ability_index = 2 # INNERFOCUS
	pkmn3.nature = :ADAMANT
	pkmn3.learn_move(:SCALESHOT)
	pkmn3.learn_move(:DRAGONCHEER)
	pkmn3.learn_move(:TAILWIND)
	pkmn3.learn_move(:PROTECT)
	pkmn3.ev[:HP] = 196
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 4
	pkmn3.ev[:SPECIAL_DEFENSE] = 4
	pkmn3.ev[:SPEED] = 52
	pkmn3.tera_type = :FAIRY
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:DRAGAPULT,5)
	pkmn4.item = :CHOICEBAND
	pkmn4.ability_index = 5 # CLEARBODY
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:DRAGONDARTS)
	pkmn4.learn_move(:SHADOWFORCE)
	pkmn4.learn_move(:SUCKERPUNCH)
	pkmn4.learn_move(:UTURN)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :DRAGON
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:TORKOAL,5)
	pkmn5.item = :LIFEORB
	pkmn5.ability_index = 2 # DROUGHT
	pkmn5.nature = :MODEST
	pkmn5.learn_move(:HEATWAVE)
	pkmn5.learn_move(:CLEARSMOG)
	pkmn5.learn_move(:HELPINGHAND)
	pkmn5.learn_move(:PROTECT)
	pkmn5.ev[:HP] = 176
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 72
	pkmn5.ev[:SPEED] = 0
	pkmn5.tera_type = :FIRE
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:WHIMSICOTT,5)
	pkmn6.item = :COVERTCLOAK
	pkmn6.ability_index = 0 # Prankster
	pkmn6.nature = :TIMID
	pkmn6.learn_move(:MOONBLAST)
	pkmn6.learn_move(:TAILWIND)
	pkmn6.learn_move(:TRICKROOM)
	pkmn6.learn_move(:SUNNYDAY)
	pkmn6.ev[:HP] = 180
	pkmn6.iv[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 4
	pkmn6.ev[:SPECIAL_DEFENSE] = 108
	pkmn6.ev[:SPEED] = 220
	pkmn6.tera_type = :WATER
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen2WaterPartyQuickStart5 # Poke Paste: https://pokepast.es/7bd4be45d6b25451
	pkmn1 = Pokemon.new(:FERALIGATR,5)
	pkmn1.item = :LIFEORB
	pkmn1.ability_index = 0 # SHEERFORCE
	pkmn1.nature = :JOLLY
	pkmn1.learn_move(:LIQUIDATION)
	pkmn1.learn_move(:CRUNCH)
	pkmn1.learn_move(:DRAGONDANCE)
	pkmn1.learn_move(:PROTECT)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :DARK
	pkmn1.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:KOMMOO,5)
	pkmn2.item = :THROATSPRAY
	pkmn2.ability_index = 0 # MULTISCALE
	pkmn2.nature = :TIMID
	pkmn2.learn_move(:EGGBOMB)
	pkmn2.learn_move(:AURASPHERE)
	pkmn2.learn_move(:CLANGOROUSSOUL)
	pkmn2.learn_move(:PROTECT)
	pkmn2.ev[:HP] = 136
	pkmn2.ev[:ATTACK] = 204
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 172
	pkmn2.tera_type = :POISON
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:POLITOED,5)
	pkmn3.item = :HONEY
	pkmn3.ability_index = 4 # DRIZZLE
	pkmn3.nature = :BOLD
	pkmn3.learn_move(:WEATHERBALL)
	pkmn3.learn_move(:ICYWIND)
	pkmn3.learn_move(:HAZE)
	pkmn3.learn_move(:PROTECT)
	pkmn3.ev[:HP] = 256
	pkmn3.ev[:ATTACK] = 0
	pkmn3.ev[:DEFENSE] = 184
	pkmn3.ev[:SPECIAL_DEFENSE] = 72
	pkmn3.ev[:SPEED] = 0
	pkmn3.tera_type = :GRASS
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:RILLABOOM,5)
	pkmn4.item = :ASSAULTVEST
	pkmn4.ability_index = 0 # GRASSYSURGE
	pkmn4.nature = :ADAMANT
	pkmn4.learn_move(:WOODHAMMER)
	pkmn4.learn_move(:GRASSYGLIDE)
	pkmn4.learn_move(:FAKEOUT)
	pkmn4.learn_move(:UTURN)
	pkmn4.ev[:HP] = 204
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 52
	pkmn4.tera_type = :FIRE
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:INCINEROAR,5)
	pkmn5.item = :SAFETYGOGGLES
	pkmn5.ability_index = 0 # Intimidate
	pkmn5.nature = :CAREFUL
	pkmn5.learn_move(:FAKEOUT)
	pkmn5.learn_move(:PARTINGSHOT)
	pkmn5.learn_move(:TAUNT)
	pkmn5.learn_move(:KNOCKOFF)
	pkmn5.ev[:HP] = 256
	pkmn5.ev[:ATTACK] = 0
	pkmn5.ev[:DEFENSE] = 96
	pkmn5.ev[:SPECIAL_DEFENSE] = 160
	pkmn5.ev[:SPEED] = 0
	pkmn5.tera_type = :GHOST
	pkmn5.dynamax_able = false
	pkmn5.calc_stats
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:AMOONGUSS,5)
	pkmn6.item = :COVERTCLOAK
	pkmn6.ability_index = 3 # Regenerator
	pkmn6.nature = :BOLD
	pkmn6.learn_move(:PROTECT)
	pkmn6.learn_move(:RAGEPOWDER)
	pkmn6.learn_move(:SPORE)
	pkmn6.learn_move(:POLLENPUFF)
	pkmn6.ev[:HP] = 240
	pkmn6.ev[:DEFENSE] = 236
	pkmn6.ev[:SPECIAL_DEFENSE] = 36
	pkmn6.iv[:SPEED] = 27
	pkmn6.tera_type = :WATER
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen3GrassPartyQuickStart5 # Poke Paste: https://pokepast.es/6aaf2d2cce90681e
	pkmn1 = Pokemon.new(:WEEZING_1,5)
	pkmn1.item = :TERRAINEXTENDER
	pkmn1.ability_index = 4 # MISTYSURGE
	pkmn1.nature = :BOLD
	pkmn1.learn_move(:STRANGESTEAM)
	pkmn1.learn_move(:FLAMETHROWER)
	pkmn1.learn_move(:TAUNT)
	pkmn1.learn_move(:MEMENTO)
	pkmn1.ev[:HP] = 256
	pkmn1.ev[:ATTACK] = 0 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn1.ev[:DEFENSE] = 172
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 84
	pkmn1.tera_type = :STEEL
	pkmn1.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:SCEPTILE,5)
	pkmn2.item = :MISTYSEED
	pkmn2.ability_index = 5 # UNBURDEN
	pkmn2.nature = :ADAMANT
	pkmn2.learn_move(:SWORDSDANCE)
	pkmn2.learn_move(:LEAFBLADE)
	pkmn2.learn_move(:ACROBATICS)
	pkmn2.learn_move(:EGGBOMB)
	pkmn2.ev[:HP] = 240
	pkmn2.ev[:ATTACK] = 252
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 20
	pkmn2.tera_type = :ICE
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:FERALIGATR,5)
	pkmn3.item = :LIFEORB
	pkmn3.ability_index = 0 # SHEERFORCE
	pkmn3.nature = :JOLLY
	pkmn3.learn_move(:LIQUIDATION)
	pkmn3.learn_move(:CRUNCH)
	pkmn3.learn_move(:DRAGONDANCE)
	pkmn3.learn_move(:ICEPUNCH)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :WATER
	pkmn3.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:SLITHERWING,5)
	pkmn4.item = :BOOSTERENERGY
	pkmn4.ability_index = 0 # PROTOSYNTHESIS
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:VICTORYDANCE)
	pkmn4.learn_move(:LEECHLIFE)
	pkmn4.learn_move(:SUBMISSION)
	pkmn4.learn_move(:SACREDFIRE)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :FIRE
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:BISHARP,5)
	pkmn5.item = :EVIOLITE
	pkmn5.ability_index = 2 # BATTLEARMOR
	pkmn5.nature = :JOLLY
	pkmn5.learn_move(:SWORDSDANCE)
	pkmn5.learn_move(:SUCKERPUNCH)
	pkmn5.learn_move(:IRONHEAD)
	pkmn5.learn_move(:LOWKICK)
	pkmn5.ev[:HP] = 84
	pkmn5.ev[:ATTACK] = 252
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 176
	pkmn5.tera_type = :FLYING
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:NECROZMA,5)
	pkmn6.item = :ROCKYHELMET
	pkmn6.ability_index = 0 # PRISMARMOR
	pkmn6.nature = :IMPISH
	pkmn6.learn_move(:STEALTHROCK)
	pkmn6.learn_move(:MOONLIGHT)
	pkmn6.learn_move(:KNOCKOFF)
	pkmn6.learn_move(:PSYSHIELDBASH)
	pkmn6.ev[:HP] = 252
	pkmn6.iv[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 72
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 184
	pkmn6.tera_type = :FAIRY
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen3FirePartyQuickStart5 # Poke Paste: https://pokepast.es/f0391b5ee43ffe02
	pkmn1 = Pokemon.new(:DRAGONITE,5)
	pkmn1.item = :LOADEDDICE
	pkmn1.ability_index = 0 # MULTISCALE
	pkmn1.nature = :ADAMANT
	pkmn1.learn_move(:PROTECT)
	pkmn1.learn_move(:SCALESHOT)
	pkmn1.learn_move(:TAILWIND)
	pkmn1.learn_move(:STOMPINGTANTRUM)
	pkmn1.ev[:HP] = 196
	pkmn1.ev[:ATTACK] = 252 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn1.ev[:DEFENSE] = 4
	pkmn1.ev[:SPECIAL_DEFENSE] = 4
	pkmn1.ev[:SPEED] = 56
	pkmn1.tera_type = :STEEL
	pkmn1.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:BLAZIKEN,5)
	pkmn2.item = :FOCUSSASH
	pkmn2.ability_index = 6 # SPEEDBOOST
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:DETECT)
	pkmn2.learn_move(:COACHING)
	pkmn2.learn_move(:EGGBOMB)
	pkmn2.learn_move(:CLOSECOMBAT)
	pkmn2.ev[:HP] = 200
	pkmn2.ev[:ATTACK] = 68
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 244
	pkmn2.tera_type = :GRASS
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:RILLABOOM,5)
	pkmn3.item = :ASSAULTVEST
	pkmn3.ability_index = 0 # GRASSYSURGE
	pkmn3.nature = :ADAMANT
	pkmn3.learn_move(:FAKEOUT)
	pkmn3.learn_move(:DRUMBEATING)
	pkmn3.learn_move(:GRASSYGLIDE)
	pkmn3.learn_move(:UTURN)
	pkmn3.ev[:HP] = 244
	pkmn3.ev[:ATTACK] = 36 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn3.ev[:DEFENSE] = 4
	pkmn3.ev[:SPECIAL_DEFENSE] = 220
	pkmn3.ev[:SPEED] = 8
	pkmn3.tera_type = :FIRE
	pkmn3.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:KINGAMBIT,5)
	pkmn4.item = :BLACKGLASSES
	pkmn4.ability_index = 5 # DEFIANT
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:PROTECT)
	pkmn4.learn_move(:SUCKERPUNCH)
	pkmn4.learn_move(:IRONHEAD)
	pkmn4.learn_move(:KOWTOWCLEAVE)
	pkmn4.ev[:HP] = 256
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 0
	pkmn4.tera_type = :DARK
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:PRIMARINA,5)
	pkmn5.item = :THROATSPRAY
	pkmn5.ability_index = 6 # LIQUIDVOICE
	pkmn5.nature = :MODEST
	pkmn5.learn_move(:HYPERVOICE)
	pkmn5.learn_move(:MOONBLAST)
	pkmn5.learn_move(:HAZE)
	pkmn5.learn_move(:PROTECT)
	pkmn5.ev[:HP] = 240
	pkmn5.ev[:ATTACK] = 108
	pkmn5.ev[:DEFENSE] = 68
	pkmn5.ev[:SPECIAL_DEFENSE] = 12
	pkmn5.ev[:SPEED] = 84
	pkmn5.tera_type = :POISON
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:FARIGIRAF,5)
	pkmn6.item = :HONEY
	pkmn6.ability_index = 0 # ARMORTAIL
	pkmn6.nature = :CALM
	pkmn6.learn_move(:TRICKROOM)
	pkmn6.learn_move(:IMPRISON)
	pkmn6.learn_move(:TWINBEAM)
	pkmn6.learn_move(:DAZZLINGGLEAM)
	pkmn6.ev[:HP] = 232
	pkmn6.iv[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 100
	pkmn6.ev[:SPECIAL_DEFENSE] = 180
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :FAIRY
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen3WaterPartyQuickStart5 # Poke Paste: https://pokepast.es/56c33da1ecac96ae
	pkmn1 = Pokemon.new(:INCINEROAR,5)
	pkmn1.item = :ASSAULTVEST
	pkmn1.ability_index = 0 # INTIMIDATE
	pkmn1.nature = :IMPISH
	pkmn1.learn_move(:FAKEOUT)
	pkmn1.learn_move(:FLAREBLITZ)
	pkmn1.learn_move(:UTURN)
	pkmn1.learn_move(:KNOCKOFF)
	pkmn1.ev[:HP] = 256
	pkmn1.ev[:ATTACK] = 20 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn1.ev[:DEFENSE] = 156
	pkmn1.ev[:SPECIAL_DEFENSE] = 44
	pkmn1.ev[:SPEED] = 36
	pkmn1.tera_type = :WATER
	pkmn1.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:RILLABOOM,5)
	pkmn2.item = :MIRACLESEED
	pkmn2.ability_index = 0 # GRASSYSURGE
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:FAKEOUT)
	pkmn2.learn_move(:GRASSYGLIDE)
	pkmn2.learn_move(:WOODHAMMER)
	pkmn2.learn_move(:HIGHHORSEPOWER)
	pkmn2.ev[:HP] = 56
	pkmn2.ev[:ATTACK] = 116
	pkmn2.ev[:DEFENSE] = 52
	pkmn2.ev[:SPECIAL_DEFENSE] = 52
	pkmn2.ev[:SPEED] = 236
	pkmn2.tera_type = :FIRE
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:DRAGONITE,5)
	pkmn3.item = :LOADEDDICE
	pkmn3.ability_index = 0 # MULTISCALE
	pkmn3.nature = :ADAMANT
	pkmn3.learn_move(:PROTECT)
	pkmn3.learn_move(:SCALESHOT)
	pkmn3.learn_move(:TAILWIND)
	pkmn3.learn_move(:HAZE)
	pkmn3.ev[:HP] = 196
	pkmn3.ev[:ATTACK] = 252 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn3.ev[:DEFENSE] = 4
	pkmn3.ev[:SPECIAL_DEFENSE] = 4
	pkmn3.ev[:SPEED] = 56
	pkmn3.tera_type = :FAIRY
	pkmn3.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:SNEASLER,5)
	pkmn4.item = :GRASSYSEED
	pkmn4.ability_index = 0 # UNBURDEN
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:EGGBOMB)
	pkmn4.learn_move(:CLOSECOMBAT)
	pkmn4.learn_move(:POISONTAIL)
	pkmn4.learn_move(:PROTECT)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :DARK
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:GHOLDENGO,5)
	pkmn5.item = :LIFEORB
	pkmn5.ability_index = 0 # WONDERSKIN
	pkmn5.nature = :MODEST
	pkmn5.learn_move(:EGGBOMB)
	pkmn5.learn_move(:SHADOWBALL)
	pkmn5.learn_move(:POWERGEM)
	pkmn5.learn_move(:PROTECT)
	pkmn5.ev[:HP] = 252
	pkmn5.ev[:ATTACK] = 92
	pkmn5.ev[:DEFENSE] = 4
	pkmn5.ev[:SPECIAL_DEFENSE] = 44
	pkmn5.ev[:SPEED] = 120
	pkmn5.tera_type = :DRAGON
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:SWAMPERT,5)
	pkmn6.item = :HONEY
	pkmn6.ability_index = 2 # SHEERFORCE
	pkmn6.nature = :ADAMANT
	pkmn6.learn_move(:EGGBOMB)
	pkmn6.learn_move(:WATERFALL)
	pkmn6.learn_move(:BULKUP)
	pkmn6.learn_move(:WIDEGUARD)
	pkmn6.ev[:HP] = 240
	pkmn6.ev[:ATTACK] = 100
	pkmn6.ev[:DEFENSE] = 36
	pkmn6.ev[:SPECIAL_DEFENSE] = 92
	pkmn6.ev[:SPEED] = 44
	pkmn6.tera_type = :FLYING
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen4GrassPartyQuickStart5 # Poke Paste: https://pokepast.es/33d343e2f1d6c37b
	pkmn1 = Pokemon.new(:FARIGIRAF,5)
	pkmn1.item = :HONEY
	pkmn1.ability_index = 0 # ARMORTAIL
	pkmn1.nature = :CAREFUL
	pkmn1.learn_move(:TRICKROOM)
	pkmn1.learn_move(:HELPINGHAND)
	pkmn1.learn_move(:CURSE)
	pkmn1.learn_move(:BODYSLAM)
	pkmn1.ev[:HP] = 252
	pkmn1.ev[:ATTACK] = 76 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn1.ev[:DEFENSE] = 132
	pkmn1.ev[:SPECIAL_DEFENSE] = 52
	pkmn1.ev[:SPEED] = 0
	pkmn1.tera_type = :FAIRY
	pkmn1.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:URSALUNA,5)
	pkmn2.item = :FLAMEORB
	pkmn2.ability_index = 0 # GUTS
	pkmn2.nature = :BRAVE
	pkmn2.learn_move(:FACADE)
	pkmn2.learn_move(:HEADLONGRUSH)
	pkmn2.learn_move(:DRAINPUNCH)
	pkmn2.learn_move(:PROTECT)
	pkmn2.ev[:HP] = 144
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 44
	pkmn2.ev[:SPECIAL_DEFENSE] = 68
	pkmn2.ev[:SPEED] = 0
	pkmn2.tera_type = :NORMAL
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:INDEEDEE_1,5)
	pkmn3.makeFemale # Only done for Female Indeede, to make sure the correct form sprite is used
	pkmn3.item = :FOCUSSASH
	pkmn3.ability_index = 3 # OWNTEMPO
	pkmn3.nature = :BOLD
	pkmn3.learn_move(:FOLLOWME)
	pkmn3.learn_move(:HEALINGWISH)
	pkmn3.learn_move(:HEALPULSE)
	pkmn3.learn_move(:DAZZLINGGLEAM)
	pkmn3.ev[:HP] = 256
	pkmn3.ev[:ATTACK] = 0 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn3.ev[:DEFENSE] = 256
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 0
	pkmn3.tera_type = :WATER
	pkmn3.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:GALLADE,5)
	pkmn4.item = :MEGAITE
	pkmn4.ability_index = 0 # Base Ability: INTREPIDSWORD Mega Ability: SHARPNESS
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:VICTORYDANCE)
	pkmn4.learn_move(:SACREDSWORD)
	pkmn4.learn_move(:PSYCHOCUT)
	pkmn4.learn_move(:AQUACUTTER)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :DARK
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:TORTERRA,5)
	pkmn5.item = :EJECTPACK
	pkmn5.ability_index = 0 # SHELLARMOR
	pkmn5.nature = :ADAMANT
	pkmn5.learn_move(:HEADLONGRUSH)
	pkmn5.learn_move(:SAPPYSEED)
	pkmn5.learn_move(:SMACKDOWN)
	pkmn5.learn_move(:STEALTHROCK)
	pkmn5.ev[:HP] = 220
	pkmn5.ev[:ATTACK] = 212
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 80
	pkmn5.tera_type = :GHOST
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:DUSCLOPS,5)
	pkmn6.item = :EVIOLITE
	pkmn6.ability_index = 4 # INTIMIDATE
	pkmn6.nature = :CALM
	pkmn6.learn_move(:TRICKROOM)
	pkmn6.learn_move(:NIGHTSHADE)
	pkmn6.learn_move(:WILLOWISP)
	pkmn6.learn_move(:HELPINGHAND)
	pkmn6.ev[:HP] = 256
	pkmn6.iv[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 256
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :POISON
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen4FirePartyQuickStart5 # Poke Paste: https://pokepast.es/11fd54de4b4e6b9a
	pkmn1 = Pokemon.new(:INFERNAPE,5)
	pkmn1.item = :FOCUSSASH
	pkmn1.ability_index = 0 # DOWNLOAD (This ability has been renamed to Instinct, to allow more Pokemon to have this ability, than just technology Pokemon) 
	pkmn1.nature = :NAIVE # Because Instinct could boost Atk or Sp.Atk, This Nature Modifier is used, in order to not weaken Atk or Sp.Atk with a Jolly or Timid Nature Modifier
	pkmn1.learn_move(:FAKEOUT)
	pkmn1.learn_move(:OVERHEAT)
	pkmn1.learn_move(:CLOSECOMBAT)
	pkmn1.learn_move(:UTURN)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256 # Infernape's a prime example of a Pokemon who massively benefits from the EV Allowcator Overhaul 
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :ELECTRIC
	pkmn1.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:HYDREIGON,5)
	pkmn2.item = :LIFEORB
	pkmn2.ability_index = 4 # MEGALAUNCHER (Moves such as Flamethrower are now boosted by Mega Launcher)
	pkmn2.nature = :TIMID
	pkmn2.learn_move(:DRAGONPULSE)
	pkmn2.learn_move(:DARKPULSE)
	pkmn2.learn_move(:FLASHCANNON)
	pkmn2.learn_move(:FLAMETHROWER)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :STEEL
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:KILOWATTREL,5)
	pkmn3.item = :COVERTCLOAK
	pkmn3.ability_index = 0 # COMPETITIVE
	pkmn3.nature = :TIMID
	pkmn3.learn_move(:TAILWIND)
	pkmn3.learn_move(:THUNDERBOLT)
	pkmn3.learn_move(:EGGBOMB)
	pkmn3.learn_move(:VOLTSWITCH)
	pkmn3.ev[:HP] = 96
	pkmn3.ev[:ATTACK] = 160 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :GHOST
	pkmn3.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:GASTRODON,5)
	pkmn4.item = :HONEY
	pkmn4.ability_index = 4 # STORMDRAIN
	pkmn4.nature = :BOLD
	pkmn4.learn_move(:EARTHPOWER)
	pkmn4.learn_move(:MUDDYWATER)
	pkmn4.learn_move(:YAWN)
	pkmn4.learn_move(:PROTECT)
	pkmn4.ev[:HP] = 184
	pkmn4.ev[:ATTACK] = 0
	pkmn4.ev[:DEFENSE] = 204
	pkmn4.ev[:SPECIAL_DEFENSE] = 124
	pkmn4.ev[:SPEED] = 0
	pkmn4.tera_type = :BUG
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:RILLABOOM,5)
	pkmn5.item = :ASSAULTVEST
	pkmn5.ability_index = 0 # GRASSYSURGE
	pkmn5.nature = :ADAMANT
	pkmn5.learn_move(:WOODHAMMER)
	pkmn5.learn_move(:GRASSYGLIDE)
	pkmn5.learn_move(:FAKEOUT)
	pkmn5.learn_move(:UTURN)
	pkmn5.ev[:HP] = 204
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 52
	pkmn5.tera_type = :FIRE
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:MAGMAR,5)
	pkmn6.item = :EVIOLITE
	pkmn6.ability_index = 5 # FLASHFIRE
	pkmn6.nature = :CALM
	pkmn6.learn_move(:EMBER)
	pkmn6.learn_move(:CLEARSMOG)
	pkmn6.learn_move(:FOLLOWME)
	pkmn6.learn_move(:PROTECT)
	pkmn6.ev[:HP] = 256
	pkmn6.iv[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 236
	pkmn6.ev[:SPECIAL_DEFENSE] = 20
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :WATER
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen4WaterPartyQuickStart5 # Poke Paste: https://pokepast.es/34cd5ffd188f2107
	pkmn1 = Pokemon.new(:GHOLDENGO,5)
	pkmn1.item = :CHOICESCARF
	pkmn1.ability_index = 3 # ADAPTABILITY
	pkmn1.nature = :TIMID
	pkmn1.learn_move(:TRICK)
	pkmn1.learn_move(:SHADOWBALL)
	pkmn1.learn_move(:MAKEITRAIN)
	pkmn1.learn_move(:FOCUSBLAST)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :DARK
	pkmn1.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:GLISCOR,5)
	pkmn2.item = :ROCKYHELMET
	pkmn2.ability_index = 3 # LEVITATE
	pkmn2.nature = :CAREFUL
	pkmn2.learn_move(:KNOCKOFF)
	pkmn2.learn_move(:CROSSPOISON)
	pkmn2.learn_move(:SPIKES)
	pkmn2.learn_move(:ROOST)
	pkmn2.ev[:HP] = 248
	pkmn2.ev[:ATTACK] = 0
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 252
	pkmn2.ev[:SPEED] = 12
	pkmn2.tera_type = :FIRE
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:GARGANACL,5)
	pkmn3.item = :LEFTOVERS
	pkmn3.ability_index = 2 # WATERABSORB
	pkmn3.nature = :IMPISH
	pkmn3.learn_move(:CURSE)
	pkmn3.learn_move(:SALTCURE)
	pkmn3.learn_move(:EARTHQUAKE)
	pkmn3.learn_move(:RECOVER)
	pkmn3.ev[:HP] = 252
	pkmn3.ev[:ATTACK] = 0 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn3.ev[:DEFENSE] = 144
	pkmn3.ev[:SPECIAL_DEFENSE] = 116
	pkmn3.ev[:SPEED] = 0
	pkmn3.tera_type = :FAIRY
	pkmn3.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:EMPOLEON,5)
	pkmn4.item = :ASSAULTVEST
	pkmn4.ability_index = 4 # BATTLEARMOR
	pkmn4.nature = :MODEST
	pkmn4.learn_move(:EGGBOMB)
	pkmn4.learn_move(:SURF)
	pkmn4.learn_move(:ICEBEAM)
	pkmn4.learn_move(:VACUUMWAVE)
	pkmn4.ev[:HP] = 256
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 0
	pkmn4.tera_type = :FLYING
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:GREATTUSK,5)
	pkmn5.item = :HEAVYDUTYBOOTS
	pkmn5.ability_index = 5 # THICKFAT
	pkmn5.nature = :IMPISH
	pkmn5.learn_move(:RAPIDSPIN)
	pkmn5.learn_move(:ICESPINNER)
	pkmn5.learn_move(:STEALTHROCK)
	pkmn5.learn_move(:CLOSCOMBAT)
	pkmn5.ev[:HP] = 220
	pkmn5.ev[:ATTACK] = 0
	pkmn5.ev[:DEFENSE] = 252
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 40
	pkmn5.tera_type = :GRASS
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:ZAMAZENTA,5)
	pkmn6.item = :RUSTEDSHIELD
	pkmn6.ability_index = 2 # STAMINA
	pkmn6.nature = :CAREFUL
	pkmn6.learn_move(:EGGBOMB)
	pkmn6.learn_move(:BEHEMOTHBASH)
	pkmn6.learn_move(:REST)
	pkmn6.learn_move(:METALBURST)
	pkmn6.ev[:HP] = 256
	pkmn6.iv[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 64
	pkmn6.ev[:SPECIAL_DEFENSE] = 192
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :WATER
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen5GrassPartyQuickStart5 # Poke Paste: https://pokepast.es/93024247192aa5f0
	pkmn1 = Pokemon.new(:KOMMOO,5)
	pkmn1.item = :SAFETYGOGGLES
	pkmn1.ability_index = 6 # BATTLEARMOR
	pkmn1.nature = :IMPISH
	pkmn1.learn_move(:BODYPRESS)
	pkmn1.learn_move(:THROATCHOP)
	pkmn1.learn_move(:IRONDEFENSE)
	pkmn1.learn_move(:SLACKOFF)
	pkmn1.ev[:HP] = 256
	pkmn1.iv[:ATTACK] = 0
	pkmn1.ev[:DEFENSE] = 256
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 0
	pkmn1.tera_type = :FIGHTING
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:TYRANITAR,5)
	pkmn2.item = :ASSAULTVEST
	pkmn2.ability_index = 0 # SANDSTREAM
	pkmn2.nature = :ADAMANT
	pkmn2.learn_move(:KNOCKOFF)
	pkmn2.learn_move(:ROCKSLIDE)
	pkmn2.learn_move(:EGGBOMB)
	pkmn2.learn_move(:HIGHHORSEPOWER)
	pkmn2.ev[:HP] = 140
	pkmn2.ev[:ATTACK] = 252
	pkmn2.ev[:DEFENSE] = 4
	pkmn2.ev[:SPECIAL_DEFENSE] = 4
	pkmn2.ev[:SPEED] = 112
	pkmn2.tera_type = :FLYING
	pkmn2.dynamax_able = false
	pkmn2.calc_stats
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:SERPERIOR,5)
	pkmn3.item = :HONEY
	pkmn3.ability_index = 3 # CONTRARY
	pkmn3.nature = :TIMID
	pkmn3.learn_move(:LEAFSTORM)
	pkmn3.learn_move(:DRACOMETEOR)
	pkmn3.learn_move(:TAUNT)
	pkmn3.learn_move(:PROTECT)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :FIRE
	pkmn3.dynamax_able = false
	pkmn3.calc_stats
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:GRIMMSNARL,5)
	pkmn4.item = :LIGHTCLAY
	pkmn4.ability_index = 4 # PRANKSTER
	pkmn4.nature = :CAREFUL
	pkmn4.learn_move(:SPIRITBREAK)
	pkmn4.learn_move(:LIGHTSCREEN)
	pkmn4.learn_move(:REFLECT)
	pkmn4.learn_move(:PARTINGSHOT)
	pkmn4.ev[:HP] = 240
	pkmn4.iv[:ATTACK] = 0
	pkmn4.ev[:DEFENSE] = 156
	pkmn4.ev[:SPECIAL_DEFENSE] = 116
	pkmn4.ev[:SPEED] = 0
	pkmn4.tera_type = :GHOST
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:GHOLDENGO,5)
	pkmn5.item = :CHOICESCARF
	pkmn5.ability_index = 3 # ADAPTABILITY
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:PROTECT)
	pkmn5.learn_move(:SHADOWBALL)
	pkmn5.learn_move(:MAKEITRAIN)
	pkmn5.learn_move(:NASTYPLOT)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :STEEL
	pkmn5.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:PORYGON2,5)
	pkmn6.item = :EVIOLITE
	pkmn6.ability_index = 2 # TRACE
	pkmn6.nature = :BOLD
	pkmn6.learn_move(:THUNDERBOLT)
	pkmn6.learn_move(:ICEBEAM)
	pkmn6.learn_move(:TRICKROOM)
	pkmn6.learn_move(:RECOVER)
	pkmn6.ev[:HP] = 256
	pkmn6.ev[:ATTACK] = 0 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn6.ev[:DEFENSE] = 196
	pkmn6.ev[:SPECIAL_DEFENSE] = 60
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :ELECTRIC
	pkmn6.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen5FirePartyQuickStart5 # Poke Paste: https://pokepast.es/9de684bec8b65aa6
	pkmn1 = Pokemon.new(:EMBOAR,5)
	pkmn1.item = :CHOICESCARF
	pkmn1.ability_index = 0 # RECKLESS
	pkmn1.nature = :JOLLY
	pkmn1.learn_move(:HEADSMASH)
	pkmn1.learn_move(:FLAREBLITZ)
	pkmn1.learn_move(:DOUBLEEDGE)
	pkmn1.learn_move(:WILDCHARGE)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :GRASS
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:SABLEYE,5)
	pkmn2.item = :REDCARD
	pkmn2.ability_index = 4 # PRANKSTER
	pkmn2.nature = :CAREFUL
	pkmn2.learn_move(:SUNNYDAY)
	pkmn2.learn_move(:WILLOWISP)
	pkmn2.learn_move(:KNOCKOFF)
	pkmn2.learn_move(:SPIRITSHACKLE)
	pkmn2.ev[:HP] = 256
	pkmn2.iv[:ATTACK] = 4
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 252
	pkmn2.ev[:SPEED] = 0
	pkmn2.tera_type = :STEEL
	pkmn2.dynamax_able = false
	pkmn2.calc_stats
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:NINETALES,5)
	pkmn3.item = :HEATROCK
	pkmn3.ability_index = 0 # DROUGHT
	pkmn3.nature = :TIMID
	pkmn3.learn_move(:FLAMEBURST)
	pkmn3.learn_move(:SOLARBEAM)
	pkmn3.learn_move(:ENCORE)
	pkmn3.learn_move(:HEALINGWISH)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :FLYING
	pkmn3.dynamax_able = false
	pkmn3.calc_stats
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:EXEGGUTOR,5)
	pkmn4.item = :LUMBERRY
	pkmn4.ability_index = 3 # HARVEST
	pkmn4.nature = :MODEST
	pkmn4.learn_move(:REST)
	pkmn4.learn_move(:STUNSPORE)
	pkmn4.learn_move(:GIGADRAIN)
	pkmn4.learn_move(:PSYSHOCK)
	pkmn4.ev[:HP] = 252
	pkmn4.ev[:ATTACK] = 176
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 84
	pkmn4.tera_type = :WATER
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:VENUSAUR,5)
	pkmn5.item = :LIFEORB
	pkmn5.ability_index = 3 # CHLOROPHYLL
	pkmn5.nature = :MODEST
	pkmn5.learn_move(:GROWTH)
	pkmn5.learn_move(:SOLARBEAM)
	pkmn5.learn_move(:WEATHERBALL)
	pkmn5.learn_move(:ACIDSPRAY)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :FIRE
	pkmn5.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:SWAMPERT,5)
	pkmn6.item = :HONEY
	pkmn6.ability_index = 0 # REGENERATOR
	pkmn6.nature = :ADAMANT
	pkmn6.learn_move(:FLIPTURN)
	pkmn6.learn_move(:EGGBOMB)
	pkmn6.learn_move(:KNOCKOFF)
	pkmn6.learn_move(:STEALTHROCK)
	pkmn6.ev[:HP] = 256
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :POISON
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen5WaterPartyQuickStart5 # Poke Paste: https://pokepast.es/87d1f20a06b7af01 (Samurott needs to be tweaked to be it's base form)
	pkmn1 = Pokemon.new(:SAMUROTT,5)
	pkmn1.item = :ASSAULTVEST
	pkmn1.ability_index = 4 # SHARPNESS
	pkmn1.nature = :ADAMANT
	pkmn1.learn_move(:SLASH)
	pkmn1.learn_move(:RAZORSHELL)
	pkmn1.learn_move(:AQUAJET)
	pkmn1.learn_move(:CEASELESSEDGE)
	pkmn1.ev[:HP] = 248
	pkmn1.ev[:ATTACK] = 84
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 124
	pkmn1.ev[:SPEED] = 56
	pkmn1.tera_type = :GHOST
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:CLEFABLE,5)
	pkmn2.item = :HONEY
	pkmn2.ability_index = 3 # FRIENDGUARD
	pkmn2.nature = :BOLD
	pkmn2.learn_move(:MOONBLAST)
	pkmn2.learn_move(:MISTYTERRAIN)
	pkmn2.learn_move(:FOLLOWME)
	pkmn2.learn_move(:PROTECT)
	pkmn2.ev[:HP] = 248
	pkmn2.ev[:ATTACK] = 0
	pkmn2.ev[:DEFENSE] = 180
	pkmn2.ev[:SPECIAL_DEFENSE] = 84
	pkmn2.ev[:SPEED] = 0
	pkmn2.tera_type = :WATER
	pkmn2.dynamax_able = false
	pkmn2.calc_stats
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:GARCHOMP,5)
	pkmn3.item = :LIFEORB
	pkmn3.ability_index = 6 # HYPERCUTTER
	pkmn3.nature = :JOLLY
	pkmn3.learn_move(:PROTECT)
	pkmn3.learn_move(:SLASH)
	pkmn3.learn_move(:DRAGONCLAW)
	pkmn3.learn_move(:IRONTAIL)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :FIRE
	pkmn3.dynamax_able = false
	pkmn3.calc_stats
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:GHOLDENGO,5)
	pkmn4.item = :LEFTOVERS
	pkmn4.ability_index = 4 # RATTLED
	pkmn4.nature = :MODEST
	pkmn4.learn_move(:EGGBOMB)
	pkmn4.learn_move(:ASTRALBARRAGE)
	pkmn4.learn_move(:NASTYPLOT)
	pkmn4.learn_move(:PROTECT)
	pkmn4.ev[:HP] = 236
	pkmn4.ev[:ATTACK] = 52 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn4.ev[:DEFENSE] = 4
	pkmn4.ev[:SPECIAL_DEFENSE] = 52
	pkmn4.ev[:SPEED] = 168
	pkmn4.tera_type = :DRAGON
	pkmn4.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:HYDREIGON,5)
	pkmn5.item = :CHOICESPECS
	pkmn5.ability_index = 4 # MEGALAUNCHER (Moves such as Flamethrower are now boosted by Mega Launcher)
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:HYPERBEAM)
	pkmn5.learn_move(:DRACOMETEOR)
	pkmn5.learn_move(:FIREBLAST)
	pkmn5.learn_move(:FLASHCANNON)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :POISON
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:WHIMSICOTT,5)
	pkmn6.item = :FOCUSSASH
	pkmn6.ability_index = 0 # PRANKSTER
	pkmn6.nature = :TIMID
	pkmn6.learn_move(:EGGBOMB)
	pkmn6.learn_move(:TAILWIND)
	pkmn6.learn_move(:SUNNYDAY)
	pkmn6.learn_move(:ENCORE)
	pkmn6.ev[:HP] = 184
	pkmn6.ev[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 108
	pkmn6.ev[:SPEED] = 220
	pkmn6.tera_type = :DARK
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen6GrassPartyQuickStart5 # Poke Paste: https://pokepast.es/6f4e9f30a5729a02
	pkmn1 = Pokemon.new(:CHESNAUGHT,5)
	pkmn1.item = :LEFTOVERS
	pkmn1.ability_index = 3 # SHELLARMOR
	pkmn1.nature = :IMPISH
	pkmn1.learn_move(:REST)
	pkmn1.learn_move(:TAUNT)
	pkmn1.learn_move(:SAPPYSEED)
	pkmn1.learn_move(:METALBURST)
	pkmn1.ev[:HP] = 256
	pkmn1.ev[:ATTACK] = 0
	pkmn1.ev[:DEFENSE] = 80
	pkmn1.ev[:SPECIAL_DEFENSE] = 176
	pkmn1.ev[:SPEED] = 0
	pkmn1.tera_type = :WATER
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:ROARINGMOON,5)
	pkmn2.item = :BOOSTERENERGY
	pkmn2.ability_index = 0 # PROTOSYNTHESIS
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:DRAGONDANCE)
	pkmn2.learn_move(:KNOCKOFF)
	pkmn2.learn_move(:ACROBATICS)
	pkmn2.learn_move(:BRICKBREAK)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :FLYING
	pkmn2.dynamax_able = false
	pkmn2.calc_stats
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:GREATTUSK,5)
	pkmn3.item = :HEAVYDUTYBOOTS
	pkmn3.ability_index = 5 # THICKFAT
	pkmn3.nature = :JOLLY
	pkmn3.learn_move(:VICTORYDANCE)
	pkmn3.learn_move(:RAPIDSPIN)
	pkmn3.learn_move(:EGGBOMB)
	pkmn3.learn_move(:ICESPINNER)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :POISON
	pkmn3.dynamax_able = false
	pkmn3.calc_stats
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:RILLABOOM,5)
	pkmn4.item = :TERRAINEXTENDER
	pkmn4.ability_index = 0 # GRASSYSURGE
	pkmn4.nature = :ADAMANT
	pkmn4.learn_move(:UTURN)
	pkmn4.learn_move(:GRASSYGLIDE)
	pkmn4.learn_move(:TAUNT)
	pkmn4.learn_move(:KNOCKOFF)
	pkmn4.ev[:HP] = 240
	pkmn4.ev[:ATTACK] = 252 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 20
	pkmn4.tera_type = :GRASS
	pkmn4.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:HEATRAN,5)
	pkmn5.item = :AIRBALLOON
	pkmn5.ability_index = 6 # ROCKYPAYLOAD (Rocky Payload gives Rock STAB, and will set Stealth Rock if user is hit by a contact move
	pkmn5.nature = :BOLD
	pkmn5.learn_move(:EMBER)
	pkmn5.learn_move(:EARTHPOWER)
	pkmn5.learn_move(:MAGMASTORM)
	pkmn5.learn_move(:MORNINGSUN)
	pkmn5.ev[:HP] = 252
	pkmn5.ev[:ATTACK] = 0
	pkmn5.ev[:DEFENSE] = 88
	pkmn5.ev[:SPECIAL_DEFENSE] = 172
	pkmn5.ev[:SPEED] = 0
	pkmn5.tera_type = :GHOST
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:HAWLUCHA,5)
	pkmn6.item = :GRASSYSEED
	pkmn6.ability_index = 0 # UNBURDEN
	pkmn6.nature = :ADAMANT
	pkmn6.learn_move(:SWORDSDANCE)
	pkmn6.learn_move(:ENCORE)
	pkmn6.learn_move(:EGGBOMB)
	pkmn6.learn_move(:CLOSECOMBAT)
	pkmn6.ev[:HP] = 128
	pkmn6.ev[:ATTACK] = 252
	pkmn6.ev[:DEFENSE] = 4
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 128
	pkmn6.tera_type = :ELECTRIC
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen6FirePartyQuickStart5 # Poke Paste: https://pokepast.es/b601021be152e474
	pkmn1 = Pokemon.new(:DELPHOX,5)
	pkmn1.item = :LIFEORB
	pkmn1.ability_index = 2 # BATTLEBOND
	pkmn1.nature = :TIMID
	pkmn1.learn_move(:EXPANDINGFORCE)
	pkmn1.learn_move(:HEATWAVE)
	pkmn1.learn_move(:GRASSKNOT)
	pkmn1.learn_move(:PROTECT)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :GRASS
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:INDEEDEE,5)
	pkmn2.makeMale # Only done for Male Indeede, to make sure the correct form sprite is used
	pkmn2.item = :FOCUSSASH
	pkmn2.ability_index = 0 # PSYCHICSURGE
	pkmn2.nature = :TIMID
	pkmn2.learn_move(:EXPANDINGFORCE)
	pkmn2.learn_move(:TERABLAST)
	pkmn2.learn_move(:IMPRISON)
	pkmn2.learn_move(:TRICKROOM)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :FIGHTING
	pkmn2.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:SNEASLER,5)
	pkmn3.item = :PSYCHICSEED
	pkmn3.ability_index = 0 # UNBURDEN
	pkmn3.nature = :JOLLY
	pkmn3.learn_move(:EGGBOMB)
	pkmn3.learn_move(:CLOSECOMBAT)
	pkmn3.learn_move(:POISONTAIL)
	pkmn3.learn_move(:PROTECT)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :DARK
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:WHIMSICOTT,5)
	pkmn4.item = :FOCUSSASH
	pkmn4.ability_index = 0 # PRANKSTER
	pkmn4.nature = :TIMID
	pkmn4.learn_move(:EGGBOMB)
	pkmn4.learn_move(:TAILWIND)
	pkmn4.learn_move(:SUNNYDAY)
	pkmn4.learn_move(:ENCORE)
	pkmn4.ev[:HP] = 184
	pkmn4.ev[:ATTACK] = 0
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 108
	pkmn4.ev[:SPEED] = 220
	pkmn4.tera_type = :WATER
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:MAUSHOLD,5)
	pkmn5.item = :WIDELENS
	pkmn5.ability_index = 4 # TECHNICIAN 
	pkmn5.nature = :JOLLY
	pkmn5.learn_move(:POPULATIONBOMB)
	pkmn5.learn_move(:FOLLOWME)
	pkmn5.learn_move(:BITE)
	pkmn5.learn_move(:PROTECT)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :NORMAL
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:ANNIHILAPE,5)
	pkmn6.item = :ASSAULTVEST
	pkmn6.ability_index = 5 # MOXIE
	pkmn6.nature = :JOLLY
	pkmn6.learn_move(:FINALGAMBIT)
	pkmn6.learn_move(:DRAINPUNCH)
	pkmn6.learn_move(:MEGAPUNCH)
	pkmn6.learn_move(:ROCKTOMB)
	pkmn6.ev[:HP] = 252
	pkmn6.ev[:ATTACK] = 76
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 180
	pkmn6.tera_type = :FIRE
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen6WaterPartyQuickStart5 # Poke Paste: https://pokepast.es/5504c7ce0c736539
	pkmn1 = Pokemon.new(:GRENINJA,5)
	pkmn1.item = :MEGAITE
	pkmn1.ability_index = 0 # PROTEAN
	pkmn1.nature = :TIMID
	pkmn1.learn_move(:HYDROCANNON)
	pkmn1.learn_move(:EGGBOMB)
	pkmn1.learn_move(:AEROBLAST)
	pkmn1.learn_move(:EXTRASENSORY)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :WATER
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:CLODSIRE,5)
	pkmn2.item = :HEAVYDUTYBOOTS
	pkmn2.ability_index = 3 # WATERABSORB
	pkmn2.nature = :CAREFUL
	pkmn2.learn_move(:STEALTHROCK)
	pkmn2.learn_move(:RAPIDSPIN)
	pkmn2.learn_move(:SPIKES)
	pkmn2.learn_move(:RECOVER)
	pkmn2.ev[:HP] = 252
	pkmn2.ev[:ATTACK] = 0 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn2.ev[:DEFENSE] = 8
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 252
	pkmn2.tera_type = :DARK
	pkmn2.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:GHOLDENGO,5)
	pkmn3.item = :COVERTCLOAK
	pkmn3.ability_index = 5 # PRANKSTER
	pkmn3.nature = :TIMID
	pkmn3.learn_move(:SHADOWBALL)
	pkmn3.learn_move(:EGGBOMB)
	pkmn3.learn_move(:RECOVER)
	pkmn3.learn_move(:NASTYPLOT)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :FLYING
	pkmn3.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:IRONVALIANT,5)
	pkmn4.item = :CHOICESPECS
	pkmn4.ability_index = 4 # MOTORDRIVE
	pkmn4.nature = :TIMID
	pkmn4.learn_move(:SPARKLYSWIRL)
	pkmn4.learn_move(:PSYSHOCK)
	pkmn4.learn_move(:TRICK)
	pkmn4.learn_move(:THUNDERBOLT)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :FAIRY
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:GREATTUSK,5)
	pkmn5.item = :ROCKYHELMET
	pkmn5.ability_index = 4 # THICKFAT 
	pkmn5.nature = :IMPISH
	pkmn5.learn_move(:RAPIDSPIN)
	pkmn5.learn_move(:BULKUP)
	pkmn5.learn_move(:KNOCKOFF)
	pkmn5.learn_move(:BODYPRESS)
	pkmn5.ev[:HP] = 256
	pkmn5.ev[:ATTACK] = 0
	pkmn5.ev[:DEFENSE] = 216
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 40
	pkmn5.tera_type = :STEEL
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:CORVIKNIGHT,5)
	pkmn6.item = :LEFTOVERS
	pkmn6.ability_index = 0 # STAMINA
	pkmn6.nature = :CAREFUL
	pkmn6.learn_move(:DOUBLEEDGE)
	pkmn6.learn_move(:MEDITATE)
	pkmn6.learn_move(:ROOST)
	pkmn6.learn_move(:BODYPRESS)
	pkmn6.ev[:HP] = 256
	pkmn6.ev[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 4
	pkmn6.ev[:SPECIAL_DEFENSE] = 252
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :GROUND
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen7GrassPartyQuickStart5 # Poke Paste: https://pokepast.es/6b48dc53126cba80
	pkmn1 = Pokemon.new(:DECIDUEYE,5)
	pkmn1.item = :BIGROOT
	pkmn1.ability_index = 0 # LONGREACH
	pkmn1.nature = :JOLLY
	pkmn1.learn_move(:SAPPYSEED)
	pkmn1.learn_move(:UTURN)
	pkmn1.learn_move(:HAZE)
	pkmn1.learn_move(:TAILWIND)
	pkmn1.ev[:HP] = 20
	pkmn1.ev[:ATTACK] = 0
	pkmn1.ev[:DEFENSE] = 100
	pkmn1.ev[:SPECIAL_DEFENSE] = 144
	pkmn1.ev[:SPEED] = 248
	pkmn1.tera_type = :FAIRY
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:CERULEDGE,5)
	pkmn2.item = :LIFEORB
	pkmn2.ability_index = 0 # SHARPNESS
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:BITTERBLADE)
	pkmn2.learn_move(:SLASH)
	pkmn2.learn_move(:CLOSECOMAT)
	pkmn2.learn_move(:PROTECT)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :GRASS
	pkmn2.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:INCINEROAR,5)
	pkmn3.item = :SAFETYGOGGLES
	pkmn3.ability_index = 0 # Intimidate
	pkmn3.nature = :CAREFUL
	pkmn3.learn_move(:FAKEOUT)
	pkmn3.learn_move(:PARTINGSHOT)
	pkmn3.learn_move(:FLAREBLITZ)
	pkmn3.learn_move(:KNOCKOFF)
	pkmn3.ev[:HP] = 244
	pkmn3.ev[:ATTACK] = 4
	pkmn3.ev[:DEFENSE] = 132
	pkmn3.ev[:SPECIAL_DEFENSE] = 84
	pkmn3.ev[:SPEED] = 48
	pkmn3.tera_type = :GHOST
	pkmn3.dynamax_able = false
	pkmn3.calc_stats
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:URSALUNA,5)
	pkmn4.item = :FLAMEORB
	pkmn4.ability_index = 0 # GUTS
	pkmn4.nature = :BRAVE
	pkmn4.learn_move(:FACADE)
	pkmn4.learn_move(:HEADLONGRUSH)
	pkmn4.learn_move(:FIREPUNCH)
	pkmn4.learn_move(:PROTECT)
	pkmn4.ev[:HP] = 140
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 44
	pkmn4.ev[:SPECIAL_DEFENSE] = 68
	pkmn4.ev[:SPEED] = 0
	pkmn4.tera_type = :POISON
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:TORKOAL,5)
	pkmn5.item = :EJECTPACK
	pkmn5.ability_index = 2 # DROUGHT
	pkmn5.nature = :QUIET
	pkmn5.learn_move(:ERUPTION)
	pkmn5.learn_move(:OVERHEAT)
	pkmn5.learn_move(:HELPINGHAND)
	pkmn5.learn_move(:PROTECT)
	pkmn5.ev[:HP] = 176
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 72
	pkmn5.ev[:SPEED] = 0
	pkmn5.tera_type = :FIRE
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:PORYGON2,5)
	pkmn6.item = :EVIOLITE
	pkmn6.ability_index = 0 # ANALYTIC
	pkmn6.nature = :BOLD
	pkmn6.learn_move(:ICEBEAM)
	pkmn6.learn_move(:EGGBOMB)
	pkmn6.learn_move(:TRICKROOM)
	pkmn6.learn_move(:RECOVER)
	pkmn6.ev[:HP] = 256
	pkmn6.ev[:ATTACK] = 8
	pkmn6.ev[:DEFENSE] = 176
	pkmn6.ev[:SPECIAL_DEFENSE] = 72
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :FIGHTING
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen7FirePartyQuickStart5 # Poke Paste: https://pokepast.es/b7fb981ef157f4aa
	pkmn1 = Pokemon.new(:INCINEROAR,5)
	pkmn1.item = :SAFETYGOGGLES
	pkmn1.ability_index = 0 # Intimidate
	pkmn1.nature = :CAREFUL
	pkmn1.learn_move(:FAKEOUT)
	pkmn1.learn_move(:PARTINGSHOT)
	pkmn1.learn_move(:FLAREBLITZ)
	pkmn1.learn_move(:KNOCKOFF)
	pkmn1.ev[:HP] = 256
	pkmn1.ev[:ATTACK] = 0
	pkmn1.ev[:DEFENSE] = 164
	pkmn1.ev[:SPECIAL_DEFENSE] = 92
	pkmn1.ev[:SPEED] = 0
	pkmn1.tera_type = :GHOST
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:RILLABOOM,5)
	pkmn2.item = :ASSAULTVEST
	pkmn2.ability_index = 0 # GRASSYSURGE
	pkmn2.nature = :ADAMANT
	pkmn2.learn_move(:WOODHAMMER)
	pkmn2.learn_move(:GRASSYGLIDE)
	pkmn2.learn_move(:FAKEOUT)
	pkmn2.learn_move(:UTURN)
	pkmn2.ev[:HP] = 248
	pkmn2.ev[:ATTACK] = 116
	pkmn2.ev[:DEFENSE] = 12
	pkmn2.ev[:SPECIAL_DEFENSE] = 132
	pkmn2.ev[:SPEED] = 4
	pkmn2.tera_type = :POISON
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:FARIGIRAF,5)
	pkmn3.item = :THROATSPRAY
	pkmn3.ability_index = 0 # Armor Tail
	pkmn3.nature = :MODEST
	pkmn3.learn_move(:PROTECT)
	pkmn3.learn_move(:TRICKROOM)
	pkmn3.learn_move(:HYPERVOICE)
	pkmn3.learn_move(:PSYCHIC)
	pkmn3.ev[:HP] = 112
	pkmn3.ev[:ATTACK] = 156
	pkmn3.ev[:DEFENSE] = 44
	pkmn3.ev[:SPECIAL_DEFENSE] = 196
	pkmn3.ev[:SPEED] = 0
	pkmn3.iv[:ATTACK] = 0
	pkmn3.iv[:SPEED] = 27
	pkmn3.tera_type = :FAIRY
	pkmn3.dynamax_able = false
	pkmn3.calc_stats
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:FLUTTERMANE,50)
	pkmn4.item = :BOOSTERENERGY
	pkmn4.ability_index = 0 # Protosynthesis
	pkmn4.nature = :TIMID
	pkmn4.learn_move(:PROTECT)
	pkmn4.learn_move(:MOONBLAST)
	pkmn4.learn_move(:SHADOWBALL)
	pkmn4.learn_move(:CALMMIND)
	pkmn4.ev[:HP] = 164
	pkmn4.ev[:ATTACK] = 108
	pkmn4.ev[:DEFENSE] = 164
	pkmn4.ev[:SPECIAL_DEFENSE] = 4
	pkmn4.ev[:SPEED] = 72
	pkmn4.iv[:ATTACK] = 0
	pkmn4.tera_type = :GRASS
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:URSHIFU_1,5)
	pkmn5.item = :CHOICESCARF
	pkmn5.ability_index = 0 # Defiant
	pkmn5.nature = :ADAMANT
	pkmn5.learn_move(:SURGINGSTRIKES)
	pkmn5.learn_move(:CLOSECOMBAT)
	pkmn5.learn_move(:AQUAJET)
	pkmn5.learn_move(:UTURN)
	pkmn5.ev[:HP] = 44
	pkmn5.ev[:ATTACK] = 156
	pkmn5.ev[:DEFENSE] = 4
	pkmn5.ev[:SPECIAL_DEFENSE] = 92
	pkmn5.ev[:SPEED] = 216
	pkmn5.iv[:SPECIAL_ATTACK] = 0
	pkmn5.tera_type = :WATER
	pkmn5.dynamax_able = false
	pkmn5.calc_stats
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:OGERPON,5)
	pkmn6.item = :HEARTHFLAMEMASK
	pkmn6.nature = :JOLLY
	pkmn6.learn_move(:IVYCUDGEL)
	pkmn6.learn_move(:GRASSYGLIDE)
	pkmn6.learn_move(:SWORDSDANCE)
	pkmn6.learn_move(:SPIKYSHIELD)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.iv[:SPECIAL_ATTACK] = 0
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen7WaterPartyQuickStart5 # Poke Paste: https://pokepast.es/40b6bff80a7d28e3
	pkmn1 = Pokemon.new(:PRIMARINA,5)
	pkmn1.item = :CUSTAPBERRY
	pkmn1.ability_index = 4 # BATTLEBOND
	pkmn1.nature = :MODEST
	pkmn1.learn_move(:SPARKLYSWIRL)
	pkmn1.learn_move(:HYDROCANNON)
	pkmn1.learn_move(:ENCORE)
	pkmn1.learn_move(:CALMMIND)
	pkmn1.ev[:HP] = 76
	pkmn1.ev[:ATTACK] = 252
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 184
	pkmn1.tera_type = :STEEL
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:GLISCOR,5)
	pkmn2.item = :LEFTOVERS
	pkmn2.ability_index = 5 # PRANKSTER
	pkmn2.nature = :CAREFUL
	pkmn2.learn_move(:KNOCKOFF)
	pkmn2.learn_move(:POISONSTING)
	pkmn2.learn_move(:RAPIDSPIN)
	pkmn2.learn_move(:VENOMDRENCH)
	pkmn2.ev[:HP] = 248
	pkmn2.ev[:ATTACK] = 0
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 240
	pkmn2.ev[:SPEED] = 24
	pkmn2.tera_type = :FLYING
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:TINGLU,5)
	pkmn3.item = :ROCKYHELMET
	pkmn3.ability_index = 0 # VESSELOFRUIN
	pkmn3.nature = :CAREFUL
	pkmn3.learn_move(:STEALTHROCK)
	pkmn3.learn_move(:SPIKES)
	pkmn3.learn_move(:SANDATTACK)
	pkmn3.learn_move(:RUINATION)
	pkmn3.ev[:HP] = 248
	pkmn3.ev[:DEFENSE] = 16
	pkmn3.ev[:SPECIAL_DEFENSE] = 248
	pkmn3.ev[:SPEED] = 0
	pkmn3.tera_type = :WATER
	pkmn3.dynamax_able = false
	pkmn3.calc_stats
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:ZAPDOS,50)
	pkmn4.item = :HEAVYDUTYBOOTS
	pkmn4.ability_index = 0 # LIGHTNINGROD
	pkmn4.nature = :BOLD
	pkmn4.learn_move(:AEROBLAST)
	pkmn4.learn_move(:VOLTSWITCH)
	pkmn4.learn_move(:THUNDERWAVE)
	pkmn4.learn_move(:ROOST)
	pkmn4.ev[:HP] = 252
	pkmn4.ev[:ATTACK] = 0
	pkmn4.ev[:DEFENSE] = 244
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 16
	pkmn4.iv[:ATTACK] = 0
	pkmn4.tera_type = :DRAGON
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:GHOLDENGO,5)
	pkmn5.item = :SHUCABERRY
	pkmn5.ability_index = 4 # RATTLED
	pkmn5.nature = :MODEST
	pkmn5.learn_move(:SHADOWBALL)
	pkmn5.learn_move(:EGGBOMB)
	pkmn5.learn_move(:RECOVER)
	pkmn5.learn_move(:NASTYPLOT)
	pkmn5.ev[:HP] = 192
	pkmn5.ev[:ATTACK] = 152 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 16
	pkmn5.ev[:SPEED] = 152
	pkmn5.tera_type = :WATER
	pkmn5.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:DARKRAI,5)
	pkmn6.item = :LIFEORB
	pkmn6.nature = :TIMID
	pkmn6.learn_move(:BLOODMOON)
	pkmn6.learn_move(:MOONGEISTBEAM)
	pkmn6.learn_move(:SLUDGEBOMB)
	pkmn6.learn_move(:NASTYPLOT)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.iv[:ATTACK] = 0
	pkmn6.tera_type = :POISON
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen8GrassPartyQuickStart5 # Poke Paste: https://pokepast.es/8f4767c8ef7df026
	pkmn1 = Pokemon.new(:RILLABOOM,5)
	pkmn1.item = :CHOICEBAND
	pkmn1.ability_index = 0 # GRASSYSURGE
	pkmn1.nature = :ADAMANT
	pkmn1.learn_move(:WOODHAMMER)
	pkmn1.learn_move(:GRASSYGLIDE)
	pkmn1.learn_move(:UTURN)
	pkmn1.learn_move(:KNOCKOFF)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :GRASS
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:OGERPON,5)
	pkmn2.item = :CORNERSTONEMASK
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:IVYCUDGEL)
	pkmn2.learn_move(:POWERWHIP)
	pkmn2.learn_move(:SPIKES)
	pkmn2.learn_move(:TAUNT)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.iv[:SPECIAL_ATTACK] = 0
	pkmn2.dynamax_able = false
	pkmn2.calc_stats
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:RAGINGBOLT,5)
	pkmn3.item = :HONEY
	pkmn3.ability_index = 4 # INTIMIDATE
	pkmn3.nature = :MODEST
	pkmn3.learn_move(:THUNDERCLAP)
	pkmn3.learn_move(:HYPERBEAM)
	pkmn3.learn_move(:ANCIENTPOWER)
	pkmn3.learn_move(:CALMMIND)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn2.iv[:ATTACK] = 0
	pkmn3.tera_type = :WATER
	pkmn3.dynamax_able = false
	pkmn3.calc_stats
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:IRONMOTH,5)
	pkmn4.item = :PASSHOBERRY
	pkmn4.ability_index = 2 # LEVITATE
	pkmn4.nature = :TIMID
	pkmn4.learn_move(:QUIVERDANCE)
	pkmn4.learn_move(:SUBSTITUTE)
	pkmn4.learn_move(:EGGBOMB)
	pkmn4.learn_move(:EMBER)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 132
	pkmn4.ev[:DEFENSE] = 124
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :GHOST
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:IRONVALIANT,5)
	pkmn5.item = :BOOSTERENERGY
	pkmn5.ability_index = 0 # QUARKDRIVE
	pkmn5.nature = :JOLLY
	pkmn5.learn_move(:PLAYROUGH)
	pkmn5.learn_move(:COACHING)
	pkmn5.learn_move(:WIDEGUARD)
	pkmn5.learn_move(:ENCORE)
	pkmn5.ev[:HP] = 204
	pkmn5.ev[:ATTACK] = 4
	pkmn5.ev[:DEFENSE] = 100
	pkmn5.ev[:SPECIAL_DEFENSE] = 28
	pkmn5.ev[:SPEED] = 176
	pkmn5.tera_type = :ELECTRIC
	pkmn5.dynamax_able = false
	pkmn5.calc_stats
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:KINGAMBIT,5)
	pkmn6.item = :LUMBERRY
	pkmn6.nature = :JOLLY
	pkmn6.learn_move(:SWORDSDANCE)
	pkmn6.learn_move(:KOWTOWCLEAVE)
	pkmn6.learn_move(:SUCKERPUNCH)
	pkmn6.learn_move(:IRONHEAD)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.iv[:ATTACK] = 0
	pkmn6.tera_type = :DARK
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen8FirePartyQuickStart5 # Poke Paste: https://pokepast.es/999f4123b7a772e8
	pkmn1 = Pokemon.new(:CINDERACE,5)
	pkmn1.item = :GIGANTAITE
	pkmn1.ability_index = 4 # LIMBER
	pkmn1.nature = :JOLLY
	pkmn1.learn_move(:MEGAKICK)
	pkmn1.learn_move(:SUCKERPUNCH)
	pkmn1.learn_move(:UTURN)
	pkmn1.learn_move(:COURTCHANGE)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :WATER
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:SLOWKING_1,5)
	pkmn2.item = :HEAVYDUTYBOOTS
	pkmn2.ability_index = 4 # REGENERATOR
	pkmn2.nature = :RELAXED
	pkmn2.learn_move(:PSYCHICNOISE)
	pkmn2.learn_move(:EGGBOMB)
	pkmn2.learn_move(:ICEBEAM)
	pkmn2.learn_move(:UTURN)
	pkmn2.ev[:HP] = 252
	pkmn2.ev[:ATTACK] = 0
	pkmn2.ev[:DEFENSE] = 252
	pkmn2.ev[:SPECIAL_DEFENSE] = 8
	pkmn2.ev[:SPEED] = 0
	pkmn2.tera_type = :GRASS
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:TINGLU,5)
	pkmn3.item = :LEFTOVERS
	pkmn3.ability_index = 5 # ROCKYPAYLOAD
	pkmn3.nature = :CAREFUL
	pkmn3.learn_move(:REST)
	pkmn3.learn_move(:SPIKES)
	pkmn3.learn_move(:SANDATTACK)
	pkmn3.learn_move(:PAYPACK)
	pkmn3.ev[:HP] = 252
	pkmn3.ev[:DEFENSE] = 8
	pkmn3.ev[:SPECIAL_DEFENSE] = 252
	pkmn3.ev[:SPEED] = 0
	pkmn3.tera_type = :FAIRY
	pkmn3.dynamax_able = false
	pkmn3.calc_stats
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:CORVIKNIGHT,5)
	pkmn4.item = :ROCKYHELMET
	pkmn4.ability_index = 2 # PRESSURE
	pkmn4.nature = :IMPISH
	pkmn4.learn_move(:BODYPRESS)
	pkmn4.learn_move(:DEFOG)
	pkmn4.learn_move(:ROOST)
	pkmn4.learn_move(:UTURN)
	pkmn4.ev[:HP] = 252
	pkmn4.ev[:ATTACK] = 0
	pkmn4.ev[:DEFENSE] = 252
	pkmn4.ev[:SPECIAL_DEFENSE] = 8
	pkmn4.ev[:SPEED] = 0
	pkmn4.tera_type = :DRAGON
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:RAGINGBOLT,5)
	pkmn5.item = :CHOICESPECS
	pkmn5.ability_index = 4 # INTIMIDATE
	pkmn5.nature = :MODEST
	pkmn5.learn_move(:VOLTSWITCH)
	pkmn5.learn_move(:HYPERBEAM)
	pkmn5.learn_move(:THUNDERBOLT)
	pkmn5.learn_move(:THUNDERCLAP)
	pkmn5.ev[:HP] = 112
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 144
	pkmn5.iv[:ATTACK] = 0
	pkmn5.tera_type = :BUG
	pkmn5.dynamax_able = false
	pkmn5.calc_stats
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:OGERPON,5)
	pkmn6.item = :WELLSPRINGMASK
	pkmn6.nature = :JOLLY
	pkmn6.learn_move(:IVYCUDGEL)
	pkmn6.learn_move(:KNOCKOFF)
	pkmn6.learn_move(:UTURN)
	pkmn6.learn_move(:ENCORE)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.iv[:SPECIAL_ATTACK] = 0
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen8WaterPartyQuickStart5 # Poke Paste: https://pokepast.es/fa6099e03a99dbd5
	pkmn1 = Pokemon.new(:INTELEON,5)
	pkmn1.item = :SCOPELENS
	pkmn1.ability_index = 6 # SUPERLUCK
	pkmn1.nature = :TIMID
	pkmn1.learn_move(:SNIPESHOT)
	pkmn1.learn_move(:EGGBOMB)
	pkmn1.learn_move(:ICEBEAM)
	pkmn1.learn_move(:PROTECT)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :GROUND
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:MAUSHOLD,5)
	pkmn2.item = :FOCUSSASH
	pkmn2.ability_index = 4 # TECHNICIAN 
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:POPULATIONBOMB)
	pkmn2.learn_move(:FOLLOWME)
	pkmn2.learn_move(:PROTECT)
	pkmn2.learn_move(:TIDYUP)
	pkmn2.ev[:HP] = 4
	pkmn2.ev[:ATTACK] = 252
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :GHOST
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:GHOLDENGO,5)
	pkmn3.item = :LIFEORB
	pkmn3.ability_index = 0 # WONDERSKIN
	pkmn3.nature = :MODEST
	pkmn3.learn_move(:MAKEITRAIN)
	pkmn3.learn_move(:SHADOWBALL)
	pkmn3.learn_move(:NASTYPLOT)
	pkmn3.learn_move(:PROTECT)
	pkmn3.ev[:HP] = 252
	pkmn3.ev[:ATTACK] = 92
	pkmn3.ev[:DEFENSE] = 4
	pkmn3.ev[:SPECIAL_DEFENSE] = 44
	pkmn3.ev[:SPEED] = 120
	pkmn3.tera_type = :STEEL
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:INCINEROAR,5)
	pkmn4.item = :HONEY
	pkmn4.ability_index = 0 # INTIMIDATE
	pkmn4.nature = :CAREFUL
	pkmn4.learn_move(:FLAREBLITZ)
	pkmn4.learn_move(:KNOCKOFF)
	pkmn4.learn_move(:FAKEOUT)
	pkmn4.learn_move(:PARTINGSHOT)
	pkmn4.ev[:HP] = 248
	pkmn4.ev[:ATTACK] = 0
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 212
	pkmn4.ev[:SPEED] = 52
	pkmn4.tera_type = :WATER
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:RILLABOOM,5)
	pkmn5.item = :ASSAULTVEST
	pkmn5.ability_index = 0 # GRASSYSURGE
	pkmn5.nature = :ADAMANT
	pkmn5.learn_move(:WOODHAMMER)
	pkmn5.learn_move(:GRASSYGLIDE)
	pkmn5.learn_move(:FAKEOUT)
	pkmn5.learn_move(:UTURN)
	pkmn5.ev[:HP] = 204
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 52
	pkmn5.tera_type = :FIRE
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:SNEASLER,5)
	pkmn6.item = :GRASSYSEED
	pkmn6.ability_index = 0 # UNBURDEN
	pkmn6.nature = :JOLLY
	pkmn6.learn_move(:EGGBOMB)
	pkmn6.learn_move(:CLOSECOMBAT)
	pkmn6.learn_move(:POISONTAIL)
	pkmn6.learn_move(:FAKEOUT)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.tera_type = :FLYING
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen9GrassPartyQuickStart5 # Poke Paste: https://pokepast.es/9a7f780862533fde
	pkmn1 = Pokemon.new(:MEOWSCARADA,5)
	pkmn1.item = :FOCUSSASH
	pkmn1.ability_index = 6 # MAGICBOUNCE
	pkmn1.nature = :JOLLY
	pkmn1.learn_move(:KNOCKOFF)
	pkmn1.learn_move(:UTURN)
	pkmn1.learn_move(:TRIPLEAXEL)
	pkmn1.learn_move(:STEALTHROCK)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :GHOST
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:GLISCOR,5)
	pkmn2.item = :ROCKYHELMET
	pkmn2.ability_index = 3 # LEVITATE
	pkmn2.nature = :CAREFUL
	pkmn2.learn_move(:RAPIDSPIN)
	pkmn2.learn_move(:ROOST)
	pkmn2.learn_move(:SPIKES)
	pkmn2.learn_move(:POISONSTING)
	pkmn2.ev[:HP] = 248
	pkmn2.ev[:ATTACK] = 0
	pkmn2.ev[:DEFENSE] = 88
	pkmn2.ev[:SPECIAL_DEFENSE] = 176
	pkmn2.ev[:SPEED] = 0
	pkmn2.tera_type = :ELECTRIC
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:URSALUNA,5)
	pkmn3.item = :ASSAULTVEST
	pkmn3.ability_index = 6 # INTIMIDATE
	pkmn3.nature = :ADAMANT
	pkmn3.learn_move(:GIGAIMPACT)
	pkmn3.learn_move(:STOMPINGTANTRUM)
	pkmn3.learn_move(:AVALANCHE)
	pkmn3.learn_move(:DRAINPUNCH)
	pkmn3.ev[:HP] = 188
	pkmn3.ev[:ATTACK] = 56
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 208
	pkmn3.ev[:SPEED] = 60
	pkmn3.tera_type = :POISON
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:SKARMORY,5)
	pkmn4.item = :LEFTOVERS
	pkmn4.ability_index = 0 # BATTLEARMOR
	pkmn4.nature = :IMPISH
	pkmn4.learn_move(:BEAKBLAST)
	pkmn4.learn_move(:ROOST)
	pkmn4.learn_move(:WHIRLWIND)
	pkmn4.learn_move(:METALBURST)
	pkmn4.ev[:HP] = 244
	pkmn4.ev[:ATTACK] = 0
	pkmn4.ev[:DEFENSE] = 216
	pkmn4.ev[:SPECIAL_DEFENSE] = 44
	pkmn4.ev[:SPEED] = 8
	pkmn4.tera_type = :DRAGON
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:SLOWKING_1,5)
	pkmn5.item = :HEAVYDUTYBOOTS
	pkmn5.ability_index = 4 # REGENERATOR
	pkmn5.nature = :RELAXED
	pkmn5.learn_move(:PSYCHICNOISE)
	pkmn5.learn_move(:EGGBOMB)
	pkmn5.learn_move(:THUNDERWAVE)
	pkmn5.learn_move(:UTURN)
	pkmn5.ev[:HP] = 252
	pkmn5.ev[:ATTACK] = 0
	pkmn5.ev[:DEFENSE] = 8
	pkmn5.ev[:SPECIAL_DEFENSE] = 252
	pkmn5.ev[:SPEED] = 0
	pkmn5.tera_type = :WATER
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:DRAGAPULT,5)
	pkmn6.item = :LIFEORB
	pkmn6.ability_index = 6 # INFILTRATOR
	pkmn6.nature = :TIMID
	pkmn6.learn_move(:EGGBOMB)
	pkmn6.learn_move(:HEX)
	pkmn6.learn_move(:UTURN)
	pkmn6.learn_move(:WILLOWISP)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.tera_type = :FIRE
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen9FirePartyQuickStart5 # Poke Paste: https://pokepast.es/b8add99b4fadea57
	pkmn1 = Pokemon.new(:SKELEDIRGE,5)
	pkmn1.item = :HEAVYDUTYBOOTS
	pkmn1.ability_index = 0 # UNAWARE
	pkmn1.nature = :BOLD
	pkmn1.learn_move(:TORCHSONG)
	pkmn1.learn_move(:ALLURINGVOICE)
	pkmn1.learn_move(:WILLOWISP)
	pkmn1.learn_move(:SLACKOFF)
	pkmn1.ev[:HP] = 252
	pkmn1.ev[:ATTACK] = 0
	pkmn1.ev[:DEFENSE] = 16
	pkmn1.ev[:SPECIAL_DEFENSE] = 244
	pkmn1.ev[:SPEED] = 0
	pkmn1.tera_type = :FAIRY
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:IRONTREADS,5)
	pkmn2.item = :BOOSTERENERGY
	pkmn2.ability_index = 2 # STURDY
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:RAPIDSPIN)
	pkmn2.learn_move(:STEALTHROCK)
	pkmn2.learn_move(:HEADLONGRUSH)
	pkmn2.learn_move(:EGGBOMB)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :GRASS
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:ENAMORUS,5)
	pkmn3.item = :FOCUSSASH
	pkmn3.ability_index = 5 # QUEENLYMAJESTY
	pkmn3.nature = :MODEST
	pkmn3.learn_move(:MOONBLAST)
	pkmn3.learn_move(:EARTHPOWER)
	pkmn3.learn_move(:CALMMIND)
	pkmn3.learn_move(:TAUNT)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :GROUND
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:ROARINGMOON,5)
	pkmn4.item = :LIFEORB
	pkmn4.ability_index = 2 # INTIMIDATE
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:KNOCKOFF)
	pkmn4.learn_move(:PARTINGSHOT)
	pkmn4.learn_move(:DRAGONASCENT)
	pkmn4.learn_move(:IRONTAIL)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 220
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 36
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :STEEL
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:ZAMAZENTA,5)
	pkmn5.item = :RUSTEDSHIELD
	pkmn5.ability_index = 3 # BATTLEARMOR
	pkmn5.nature = :JOLLY
	pkmn5.learn_move(:BODYPRESS)
	pkmn5.learn_move(:CRUNCH)
	pkmn5.learn_move(:VICTORYDANCE)
	pkmn5.learn_move(:ROAR)
	pkmn5.ev[:HP] = 88
	pkmn5.iv[:ATTACK] = 0
	pkmn5.ev[:DEFENSE] = 252
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 172
	pkmn5.tera_type = :DRAGON
	pkmn5.dynamax_able = false
	pkmn5.calc_stats
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:OGERPON,5)
	pkmn6.item = :WELLSPRINGMASK
	pkmn6.nature = :JOLLY
	pkmn6.learn_move(:IVYCUDGEL)
	pkmn6.learn_move(:POWERWHIP)
	pkmn6.learn_move(:UTURN)
	pkmn6.learn_move(:ENCORE)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.iv[:SPECIAL_ATTACK] = 0
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen9WaterPartyQuickStart5 # Poke Paste: https://pokepast.es/2aaa84dab1d690bf
	pkmn1 = Pokemon.new(:QUAQUAVAL,5)
	pkmn1.item = :FOCUSSASH
	pkmn1.ability_index = 5 # DAZZLING
	pkmn1.nature = :JOLLY
	pkmn1.learn_move(:VICTORYDANCE)
	pkmn1.learn_move(:CLOSECOMAT)
	pkmn1.learn_move(:LIQUIDATION)
	pkmn1.learn_move(:ICESPINNER)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :STEEL
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:KINGDRA,5)
	pkmn2.item = :LIFEORB
	pkmn2.ability_index = 0 # SWIFTSWIM
	pkmn2.nature = :MODEST
	pkmn2.learn_move(:DRACOMETEOR)
	pkmn2.learn_move(:WEATHERBALL)
	pkmn2.learn_move(:MUDDYWATER)
	pkmn2.learn_move(:PROTECT)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :STELLAR
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:POLITOED,5)
	pkmn3.item = :HONEY
	pkmn3.ability_index = 4 # DRIZZLE
	pkmn3.nature = :BOLD
	pkmn3.learn_move(:WEATHERBALL)
	pkmn3.learn_move(:PERISHSONG)
	pkmn3.learn_move(:ENCORE)
	pkmn3.learn_move(:PROTECT)
	pkmn3.ev[:HP] = 256
	pkmn3.ev[:ATTACK] = 0
	pkmn3.ev[:DEFENSE] = 184
	pkmn3.ev[:SPECIAL_DEFENSE] = 72
	pkmn3.ev[:SPEED] = 0
	pkmn3.tera_type = :GRASS
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:GOTHITELLE,5)
	pkmn4.item = :LEFTOVERS
	pkmn4.ability_index = 3 # MAGICBOUNCE
	pkmn4.nature = :CALM
	pkmn4.learn_move(:PROTECT)
	pkmn4.learn_move(:PSYCHIC)
	pkmn4.learn_move(:FAKEOUT)
	pkmn4.learn_move(:TRICKROOM)
	pkmn4.ev[:HP] = 256
	pkmn4.ev[:DEFENSE] = 100
	pkmn4.ev[:SPECIAL_DEFENSE] = 156
	pkmn4.iv[:ATTACK] = 0
	pkmn4.tera_type = :DARK
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:INCINEROAR,5)
	pkmn5.item = :SAFETYGOGGLES
	pkmn5.ability_index = 0 # Intimidate
	pkmn5.nature = :CAREFUL
	pkmn5.learn_move(:FAKEOUT)
	pkmn5.learn_move(:PARTINGSHOT)
	pkmn5.learn_move(:KNOCKOFF)
	pkmn5.learn_move(:PROTECT)
	pkmn5.ev[:HP] = 244
	pkmn5.ev[:ATTACK] = 4
	pkmn5.ev[:DEFENSE] = 132
	pkmn5.ev[:SPECIAL_DEFENSE] = 84
	pkmn5.ev[:SPEED] = 48
	pkmn5.tera_type = :GHOST
	pkmn5.dynamax_able = false
	pkmn5.calc_stats
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:AMOONGUSS,50)
	pkmn6.item = :MENTALHERB
	pkmn6.ability_index = 3 # Regenerator
	pkmn6.nature = :BOLD
	pkmn6.learn_move(:PROTECT)
	pkmn6.learn_move(:RAGEPOWDER)
	pkmn6.learn_move(:SPORE)
	pkmn6.learn_move(:POLLENPUFF)
	pkmn6.ev[:HP] = 240
	pkmn6.ev[:DEFENSE] = 236
	pkmn6.ev[:SPECIAL_DEFENSE] = 36
	pkmn6.iv[:SPEED] = 0
	pkmn6.tera_type = :FAIRY
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen9FightingPartyQuickStart5 # Poke Paste: https://pokepast.es/74e2807d6251ac7c
	pkmn1 = Pokemon.new(:DECIDUEYE_1,5)
	pkmn1.item = :SCOPELENS
	pkmn1.ability_index = 3 # SCRAPPY
	pkmn1.nature = :JOLLY
	pkmn1.learn_move(:LEAFBLADE)
	pkmn1.learn_move(:TRIPLEARROWS)
	pkmn1.learn_move(:HAZE)
	pkmn1.learn_move(:PROTECT)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :FIRE
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:DRAGAPULT,5)
	pkmn2.item = :CHOICEBAND
	pkmn2.ability_index = 0 # PARENTALBOND
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:DRAGONDARTS)
	pkmn2.learn_move(:SHADOWFORCE)
	pkmn2.learn_move(:UTURN)
	pkmn2.learn_move(:PSYCHICFANGS)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :DRAGON
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:VOLCARONA,5)
	pkmn3.item = :HONEY
	pkmn3.ability_index = 0 # LEVITATE
	pkmn3.nature = :TIMID
	pkmn3.learn_move(:EMBER)
	pkmn3.learn_move(:GIGADRAIN)
	pkmn3.learn_move(:QUIVERDANCE)
	pkmn3.learn_move(:PROTECT)
	pkmn3.ev[:HP] = 248
	pkmn3.ev[:ATTACK] = 12
	pkmn3.ev[:DEFENSE] = 92
	pkmn3.ev[:SPECIAL_DEFENSE] = 28
	pkmn3.ev[:SPEED] = 132
	pkmn3.tera_type = :GRASS
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:HATTERENE,5)
	pkmn4.item = :LIFEORB
	pkmn4.ability_index = 0 # MAGICBOUNCE
	pkmn4.nature = :QUIET
	pkmn4.learn_move(:EXPANDINGFORCE)
	pkmn4.learn_move(:DAZZLINGGLEAM)
	pkmn4.learn_move(:TRICKROOM)
	pkmn4.learn_move(:PROTECT)
	pkmn4.ev[:HP] = 216
	pkmn4.ev[:ATTACK] = 204
	pkmn4.ev[:DEFENSE] = 68
	pkmn4.ev[:SPECIAL_DEFENSE] = 24
	pkmn4.iv[:ATTACK] = 0
	pkmn4.iv[:SPEED] = 0
	pkmn4.tera_type = :PSYCHIC
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:TYRANITAR,5)
	pkmn5.item = :ASSAULTVEST
	pkmn5.ability_index = 2 # SHEERFORCE
	pkmn5.nature = :SASSY
	pkmn5.learn_move(:ROCKSLIDE)
	pkmn5.learn_move(:KNOCKOFF)
	pkmn5.learn_move(:EGGBOMB)
	pkmn5.learn_move(:STRENGTH)
	pkmn5.ev[:HP] = 140
	pkmn5.ev[:ATTACK] = 252
	pkmn5.ev[:DEFENSE] = 4
	pkmn5.ev[:SPECIAL_DEFENSE] = 4
	pkmn5.ev[:SPEED] = 112
	pkmn5.tera_type = :FLYING
	pkmn5.dynamax_able = false
	pkmn5.calc_stats
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:INDEEDEE,5)
	pkmn6.makeMale # Only done for Male Indeede, to make sure the correct form sprite is used
	pkmn6.item = :LUMBERRY
	pkmn6.ability_index = 0 # PSYCHICSURGE
	pkmn6.nature = :RELAXED
	pkmn6.learn_move(:PSYCHIC)
	pkmn6.learn_move(:FOLLOWME)
	pkmn6.learn_move(:TRICKROOM)
	pkmn6.learn_move(:HELPINGHAND)
	pkmn6.ev[:HP] = 256
	pkmn6.ev[:ATTACK] = 0 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn6.ev[:DEFENSE] = 256
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :FAIRY
	pkmn6.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen9GhostPartyQuickStart5 # Poke Paste: https://pokepast.es/d0e936b567d7f639
	pkmn1 = Pokemon.new(:TYPHLOSION_1,5)
	pkmn1.item = :CHOICESCARF
	pkmn1.ability_index = 0 # SOULHEART
	pkmn1.nature = :TIMID
	pkmn1.learn_move(:OVERHEAT)
	pkmn1.learn_move(:ERUPTION)
	pkmn1.learn_move(:SHADOWBALL)
	pkmn1.learn_move(:HEATWAVE)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :FIRE
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:WEEZING_1,5)
	pkmn2.item = :CHOICESPECS
	pkmn2.ability_index = 2 # NEUTRALIZINGGAS
	pkmn2.nature = :MODEST
	pkmn2.learn_move(:EGGBOMB)
	pkmn2.learn_move(:STRANGESTEAM)
	pkmn2.learn_move(:DAZZLINGGLEAM)
	pkmn2.learn_move(:FLAMETHROWER)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :FLYING
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:GARCHOMP,5)
	pkmn3.item = :LIFEORB
	pkmn3.ability_index = 6 # HYPERCUTTER
	pkmn3.nature = :JOLLY
	pkmn3.learn_move(:PROTECT)
	pkmn3.learn_move(:SLASH)
	pkmn3.learn_move(:DRAGONCLAW)
	pkmn3.learn_move(:IRONTAIL)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :FIRE
	pkmn3.dynamax_able = false
	pkmn3.calc_stats
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:CORVIKNIGHT,5)
	pkmn4.item = :HONEY
	pkmn4.ability_index = 4 # MIRRORARMOR
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:DOUBLEEDGE)
	pkmn4.learn_move(:TAILWIND)
	pkmn4.learn_move(:ROOST)
	pkmn4.learn_move(:BULKUP)
	pkmn4.ev[:HP] = 252
	pkmn4.ev[:ATTACK] = 0
	pkmn4.ev[:DEFENSE] = 44
	pkmn4.ev[:SPECIAL_DEFENSE] = 144
	pkmn4.ev[:SPEED] = 72
	pkmn4.tera_type = :DRAGON
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:TOEDSCRUEL,5)
	pkmn5.item = :COVERTCLOAK
	pkmn5.ability_index = 5 # LONGREACH
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:EGGBOMB)
	pkmn5.learn_move(:ACIDSPRAY)
	pkmn5.learn_move(:STUNSPORE)
	pkmn5.learn_move(:RAGEPOWER)
	pkmn5.ev[:HP] = 180
	pkmn5.ev[:ATTACK] = 12
	pkmn5.ev[:DEFENSE] = 64
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :WATER
	pkmn5.dynamax_able = false
	pkmn5.calc_stats
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:BAXCALIBUR,5)
	pkmn6.item = :LOADEDDICE
	pkmn6.ability_index = 0 # THERMALEXCHANGE
	pkmn6.nature = :ADAMANT
	pkmn6.learn_move(:ICICLESPEAR)
	pkmn6.learn_move(:SCALESHOT)
	pkmn6.learn_move(:SWORDSDANCE)
	pkmn6.learn_move(:PROTECT)
	pkmn6.ev[:HP] = 256
	pkmn6.ev[:ATTACK] = 0 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.tera_type = :FAIRY
	pkmn6.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen9DarkPartyQuickStart5 # Poke Paste: https://pokepast.es/73c40bd837c0a2f0
	pkmn1 = Pokemon.new(:SAMUROTT_1,5)
	pkmn1.item = :ASSAULTVEST
	pkmn1.ability_index = 4 # SHARPNESS
	pkmn1.nature = :ADAMANT
	pkmn1.learn_move(:SLASH)
	pkmn1.learn_move(:RAZORSHELL)
	pkmn1.learn_move(:AQUAJET)
	pkmn1.learn_move(:CEASELESSEDGE)
	pkmn1.ev[:HP] = 248
	pkmn1.ev[:ATTACK] = 84
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 124
	pkmn1.ev[:SPEED] = 56
	pkmn1.tera_type = :FIRE
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:ZAMAZENTA,5)
	pkmn2.item = :RUSTEDSHIELD
	pkmn2.ability_index = 3 # BATTLEARMOR
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:BODYPRESS)
	pkmn2.learn_move(:STONEEDGE)
	pkmn2.learn_move(:VICTORYDANCE)
	pkmn2.learn_move(:IRONHEAD)
	pkmn2.ev[:HP] = 0
	pkmn2.iv[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :DRAGON
	pkmn2.dynamax_able = false
	pkmn2.calc_stats
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:CLEFABLE,5)
	pkmn3.item = :STICKYBARB
	pkmn3.ability_index = 2 # MAGICGUARD
	pkmn3.nature = :BOLD
	pkmn3.learn_move(:CALMMIND)
	pkmn3.learn_move(:FLAMETHROWER)
	pkmn3.learn_move(:MOONBLAST)
	pkmn3.learn_move(:MOONLIGHT)
	pkmn3.ev[:HP] = 252
	pkmn3.ev[:ATTACK] = 0
	pkmn3.ev[:DEFENSE] = 240
	pkmn3.ev[:SPECIAL_DEFENSE] = 8
	pkmn3.ev[:SPEED] = 20
	pkmn3.tera_type = :BUG
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:LANDORUS_1,5)
	pkmn4.item = :FOCUSSASH
	pkmn4.ability_index = 4 # INTIMIDATE
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:STEALTHROCK)
	pkmn4.learn_move(:EARTHQUAKE)
	pkmn4.learn_move(:SMACKDOWN)
	pkmn4.learn_move(:UTURN)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :GROUND
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:ROTOM_2,5)
	pkmn5.item = :COVERTCLOAK
	pkmn5.ability_index = 6 # SCREENCLEANER
	pkmn5.nature = :BOLD
	pkmn5.learn_move(:VOLTSWITCH)
	pkmn5.learn_move(:HYDROPUMP)
	pkmn5.learn_move(:SOAK)
	pkmn5.learn_move(:THUNDERWAVE)
	pkmn5.ev[:HP] = 256
	pkmn5.ev[:ATTACK] = 0
	pkmn5.ev[:DEFENSE] = 212
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 44
	pkmn5.tera_type = :FLYING
	pkmn5.dynamax_able = false
	pkmn5.calc_stats
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:DRAGAPULT,5)
	pkmn6.item = :HEAVYDUTYBOOTS
	pkmn6.ability_index = 6 # INFILTRATOR
	pkmn6.nature = :NAIVE
	pkmn6.learn_move(:DRAGONDARTS)
	pkmn6.learn_move(:HEX)
	pkmn6.learn_move(:WILLOWISP)
	pkmn6.learn_move(:UTURN)
	pkmn6.ev[:HP] = 60
	pkmn6.ev[:ATTACK] = 196
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.tera_type = :FAIRY
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoNormalPartyQuickStart5 # Poke Paste: https://pokepast.es/ac1b444e8fc174a9
	pkmn1 = Pokemon.new(:PIDGEOT,5)
	pkmn1.item = :HEAVYDUTYBOOTS
	pkmn1.ability_index = 3 # PICKUP
	pkmn1.nature = :IMPISH
	pkmn1.learn_move(:BRAVEBIRD)
	pkmn1.learn_move(:DEFOG)
	pkmn1.learn_move(:ROOST)
	pkmn1.learn_move(:UTURN)
	pkmn1.ev[:HP] = 252
	pkmn1.ev[:ATTACK] = 0
	pkmn1.ev[:DEFENSE] = 240
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 20
	pkmn1.tera_type = :FIGHTING
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:DITTO,5)
	pkmn2.item = :CHOICESCARF
	pkmn2.ability_index = 4 # IMPOSTER
	pkmn2.nature = :RELAXED
	pkmn2.learn_move(:TRANSFORM)
	pkmn2.ev[:HP] = 252
	pkmn2.iv[:ATTACK] = 8
	pkmn2.ev[:DEFENSE] = 252
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 0
	pkmn2.tera_type = :FAIRY
	pkmn2.dynamax_able = false
	pkmn2.calc_stats
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:TERAPAGOS,5)
	pkmn3.item = :WHITEHERB
	pkmn3.nature = :MODEST
	pkmn3.learn_move(:NORETREAT)
	pkmn3.learn_move(:SHELLSMASH)
	pkmn3.learn_move(:TAUNT)
	pkmn3.learn_move(:TERASTARSTORM)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:URSALUNA,5)
	pkmn4.item = :FLAMEORB
	pkmn4.ability_index = 0 # GUTS
	pkmn4.nature = :ADAMANT
	pkmn4.learn_move(:FACADE)
	pkmn4.learn_move(:HEADLONGRUSH)
	pkmn4.learn_move(:FIREPUNCH)
	pkmn4.learn_move(:SWORDSDANCE)
	pkmn4.ev[:HP] = 252
	pkmn4.ev[:ATTACK] = 252
	pkmn4.ev[:DEFENSE] = 8
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 0
	pkmn4.tera_type = :POISON
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:ZOROARK_1,5)
	pkmn5.item = :CHOICESPECS
	pkmn5.ability_index = 6 # INTIMIDATE
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:TRICK)
	pkmn5.learn_move(:MOONGEISTBEAM)
	pkmn5.learn_move(:HYPERBEAM)
	pkmn5.learn_move(:FOCUSBLAST)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :FAIRY
	pkmn5.dynamax_able = false
	pkmn5.calc_stats
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:BLISSEY,5)
	pkmn6.item = :LEFTOVERS
	pkmn6.ability_index = 3 # SCRAPPY
	pkmn6.nature = :BOLD
	pkmn6.learn_move(:SEISMICTOSS)
	pkmn6.learn_move(:SOFTBOILED)
	pkmn6.learn_move(:STEALTHROCK)
	pkmn6.learn_move(:THUNDERWAVE)
	pkmn6.ev[:HP] = 252
	pkmn6.ev[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 256
	pkmn6.ev[:SPECIAL_DEFENSE] = 4
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :GHOST
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoFightingPartyQuickStart5 # Poke Paste: https://pokepast.es/698aaabeafee46e1
	pkmn1 = Pokemon.new(:IRONVALIANT,5)
	pkmn1.item = :CHOICESCARF
	pkmn1.ability_index = 3 # SYNCHRONIZE
	pkmn1.nature = :NAIVE
	pkmn1.learn_move(:EGGBOMB)
	pkmn1.learn_move(:CLOSECOMAT)
	pkmn1.learn_move(:THUNDERBOLT)
	pkmn1.learn_move(:TRICK)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :GHOST
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:GREATTUSK,5)
	pkmn2.item = :ROCKYHELMET
	pkmn2.ability_index = 4 # THICKFAT 
	pkmn2.nature = :IMPISH
	pkmn2.learn_move(:EARTHQUAKE)
	pkmn2.learn_move(:VICTORYDANCE)
	pkmn2.learn_move(:KNOCKOFF)
	pkmn2.learn_move(:STEALTHROCK)
	pkmn2.ev[:HP] = 256
	pkmn2.ev[:ATTACK] = 0
	pkmn2.ev[:DEFENSE] = 156
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 100
	pkmn2.tera_type = :POISON
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:SCRAFTY,5)
	pkmn3.item = :LEFTOVERS
	pkmn3.ability_index = 2 # SHEDSKIN
	pkmn3.nature = :CAREFUL
	pkmn3.learn_move(:VICTORYDANCE)
	pkmn3.learn_move(:DRAINPUNCH)
	pkmn3.learn_move(:KNOCKOFF)
	pkmn3.learn_move(:REST)
	pkmn3.ev[:HP] = 252
	pkmn3.ev[:ATTACK] = 0
	pkmn3.ev[:DEFENSE] = 240
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 20
	pkmn3.tera_type = :FIGHTING
	pkmn3.dynamax_able = false
	pkmn3.calc_stats
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:IRONHANDS,5)
	pkmn4.item = :ASSAULTVEST
	pkmn4.ability_index = 2 # STEELWORKER
	pkmn4.nature = :CAREFUL
	pkmn4.learn_move(:DRAINPUNCH)
	pkmn4.learn_move(:ICEPUNCH)
	pkmn4.learn_move(:HEAVYSLAM)
	pkmn4.learn_move(:THUNDERPUNCH)
	pkmn4.ev[:HP] = 256
	pkmn4.ev[:ATTACK] = 4
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 252
	pkmn4.tera_type = :BUG
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:URSHIFU_1,5)
	pkmn5.item = :PUNCHINGGLOVE
	pkmn5.ability_index = 5 # TECHNICIAN
	pkmn5.nature = :JOLLY
	pkmn5.learn_move(:SURGINGSTRIKES)
	pkmn5.learn_move(:AQUAJET)
	pkmn5.learn_move(:VICTORYDANCE)
	pkmn5.learn_move(:TECHPOWERICE)
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.iv[:SPECIAL_ATTACK] = 0
	pkmn5.tera_type = :STELLAR
	pkmn5.dynamax_able = false
	pkmn5.calc_stats
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:SNEASLER,5)
	pkmn6.item = :AIRBALLOON
	pkmn6.ability_index = 0 # UNBURDEN
	pkmn6.nature = :ADAMANT
	pkmn6.learn_move(:EGGBOMB)
	pkmn6.learn_move(:CLOSECOMBAT)
	pkmn6.learn_move(:POISONTAIL)
	pkmn6.learn_move(:PROTECT)
	pkmn6.ev[:HP] = 144
	pkmn6.ev[:ATTACK] = 252
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 116
	pkmn6.tera_type = :DARK
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoFlyingPartyQuickStart5 # Poke Paste: https://pokepast.es/cb82e72f29563467
	pkmn1 = Pokemon.new(:SKARMORY,5)
	pkmn1.item = :ROCKYHELMET
	pkmn1.ability_index = 0 # BATTLEARMOR
	pkmn1.nature = :BOLD
	pkmn1.learn_move(:ROOST)
	pkmn1.learn_move(:IRONDEFENSE)
	pkmn1.learn_move(:WHIRLWIND)
	pkmn1.learn_move(:BODYPRESS)
	pkmn1.ev[:HP] = 256
	pkmn1.ev[:ATTACK] = 0
	pkmn1.ev[:DEFENSE] = 252
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 4
	pkmn1.tera_type = :GROUND
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:DRAGONITE,5)
	pkmn2.item = :CHOICEBAND
	pkmn2.ability_index = 0 # MULTISCALE 
	pkmn2.nature = :ADAMANT
	pkmn2.learn_move(:DRAGONASCENT)
	pkmn2.learn_move(:EXTREMESPEED)
	pkmn2.learn_move(:FIREPUNCH)
	pkmn2.learn_move(:EARTHQUAKE)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :FIGHTING
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:DODRIO,5)
	pkmn3.item = :LIFEORB
	pkmn3.ability_index = 5 # BIGPECKS
	pkmn3.nature = :JOLLY
	pkmn3.learn_move(:DOUBLEEDGE)
	pkmn3.learn_move(:SKYATTACK)
	pkmn3.learn_move(:KNOCKOFF)
	pkmn3.learn_move(:JUMPKICK)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :FIRE
	pkmn3.dynamax_able = false
	pkmn3.calc_stats
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:CORVIKNIGHT,5)
	pkmn4.item = :LEFTOVERS
	pkmn4.ability_index = 4 # MIRRORARMOR
	pkmn4.nature = :CAREFUL
	pkmn4.learn_move(:STEELWING)
	pkmn4.learn_move(:UTURN)
	pkmn4.learn_move(:DEFOG)
	pkmn4.learn_move(:ROOST)
	pkmn4.ev[:HP] = 252
	pkmn4.ev[:ATTACK] = 12
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 248
	pkmn4.tera_type = :DRAGON
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:TORNADUS_1,5)
	pkmn5.item = :ASSAULTVEST
	pkmn5.ability_index = 3 # REGENERATOR
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:UTURN)
	pkmn5.learn_move(:KNOCKOFF)
	pkmn5.learn_move(:AEROBLAST)
	pkmn5.learn_move(:HEATWAVE)
	pkmn5.ev[:HP] = 248
	pkmn5.ev[:ATTACK] = 0
	pkmn5.ev[:DEFENSE] = 12
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 252
	pkmn5.tera_type = :FLYING
	pkmn5.dynamax_able = false
	pkmn5.calc_stats
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:LANDORUS_1,5)
	pkmn6.item = :CHOICESCARF
	pkmn6.ability_index = 4 # INTIMIDATE
	pkmn6.nature = :JOLLY
	pkmn6.learn_move(:EARTHQUAKE)
	pkmn6.learn_move(:STONEEDGE)
	pkmn6.learn_move(:UTURN)
	pkmn6.learn_move(:STEALTHROCK)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.tera_type = :STEEL
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoPoisonPartyQuickStart5 # Poke Paste: https://pokepast.es/068863a5eb35a63c
	pkmn1 = Pokemon.new(:MUK_1,5)
	pkmn1.item = :BLACKSLUDGE
	pkmn1.ability_index = 0 # POISONTOUCH
	pkmn1.nature = :CAREFUL
	pkmn1.learn_move(:KNOCKOFF)
	pkmn1.learn_move(:DRAINPUNCH)
	pkmn1.learn_move(:POISONJAB)
	pkmn1.learn_move(:PROTECT)
	pkmn1.ev[:HP] = 256
	pkmn1.ev[:ATTACK] = 4
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 252
	pkmn1.ev[:SPEED] = 0
	pkmn1.tera_type = :POISON
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:SNEASLER,5)
	pkmn2.item = :AIRBALLOON
	pkmn2.ability_index = 0 # UNBURDEN
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:SWORDSDANCE)
	pkmn2.learn_move(:CLOSECOMBAT)
	pkmn2.learn_move(:EGGBOMB)
	pkmn2.learn_move(:ACROBATICS)
	pkmn2.ev[:HP] = 80
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 176
	pkmn2.tera_type = :DARK
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:SLOWKING_1,5)
	pkmn3.item = :ASSAULTVEST
	pkmn3.ability_index = 4 # REGENERATOR
	pkmn3.nature = :SASSY
	pkmn3.learn_move(:FUTURESIGHT)
	pkmn3.learn_move(:SLUDGEBOMB)
	pkmn3.learn_move(:ICEBEAM)
	pkmn3.learn_move(:FLAMETHROWER)
	pkmn3.ev[:HP] = 256
	pkmn3.ev[:ATTACK] = 60
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 196
	pkmn3.ev[:SPEED] = 0
	pkmn3.tera_type = :FLYING
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:CLODSIRE,5)
	pkmn4.item = :HEAVYDUTYBOOTS
	pkmn4.ability_index = 0 # UNAWARE
	pkmn4.nature = :IMPISH
	pkmn4.learn_move(:STEALTHROCK)
	pkmn4.learn_move(:RAPIDSPIN)
	pkmn4.learn_move(:TOXIC)
	pkmn4.learn_move(:RECOVER)
	pkmn4.ev[:HP] = 256
	pkmn4.ev[:ATTACK] = 0 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn4.ev[:DEFENSE] = 232
	pkmn4.ev[:SPECIAL_DEFENSE] = 24
	pkmn4.ev[:SPEED] = 0
	pkmn4.tera_type = :ICE
	pkmn4.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:IRONMOTH,5)
	pkmn5.item = :CHOICESPECS
	pkmn5.ability_index = 4 # SHADOWSHIELD
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:EGGBOMB)
	pkmn5.learn_move(:OVERHEAT)
	pkmn5.learn_move(:ENERGYBALL)
	pkmn5.learn_move(:THUNDERBOLT)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :FIRE
	pkmn5.dynamax_able = false
	pkmn5.calc_stats
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:WEEZING_1,5)
	pkmn6.item = :POWERHERB
	pkmn6.ability_index = 0 # LEVITATE
	pkmn6.nature = :BOLD
	pkmn6.learn_move(:GEOMANCY)
	pkmn6.learn_move(:DEFOG)
	pkmn6.learn_move(:WILLOWISP)
	pkmn6.learn_move(:MOONBLAST)
	pkmn6.ev[:HP] = 252
	pkmn6.ev[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 252
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 8
	pkmn6.tera_type = :ELECTRIC
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoGroundPartyQuickStart5 # Poke Paste: https://pokepast.es/0862ad1d0d311051
	pkmn1 = Pokemon.new(:HIPPOWDON,5)
	pkmn1.item = :EJECTBUTTON
	pkmn1.ability_index = 2 # SANDSTREAM
	pkmn1.nature = :IMPISH
	pkmn1.learn_move(:EARTHQUAKE)
	pkmn1.learn_move(:SLACKOFF)
	pkmn1.learn_move(:STEALTHROCK)
	pkmn1.learn_move(:WHIRLWIND)
	pkmn1.ev[:HP] = 256
	pkmn1.ev[:ATTACK] = 0
	pkmn1.ev[:DEFENSE] = 256
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 0
	pkmn1.tera_type = :POISON
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:EXCADRILL,5)
	pkmn2.item = :ASSAULTVEST
	pkmn2.ability_index = 2 # SANDFORCE
	pkmn2.nature = :ADAMANT
	pkmn2.learn_move(:RAPIDSPIN)
	pkmn2.learn_move(:EARTHQUAKE)
	pkmn2.learn_move(:ROCKCLIMB)
	pkmn2.learn_move(:SHADOWCLAW)
	pkmn2.ev[:HP] = 80
	pkmn2.ev[:ATTACK] = 176
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :FAIRY
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:LANDORUS,5)
	pkmn3.item = :LIFEORB
	pkmn3.ability_index = 2 # SHEERFORCE
	pkmn3.nature = :TIMID
	pkmn3.learn_move(:EARTHPOWER)
	pkmn3.learn_move(:FOCUSBLAST)
	pkmn3.learn_move(:PSYCHIC)
	pkmn3.learn_move(:GRAVITY)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :ICE
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:MAMOSWINE,5)
	pkmn4.item = :CHOICEBAND
	pkmn4.ability_index = 4 # SANDRUSH
	pkmn4.nature = :ADAMANT
	pkmn4.learn_move(:EGGBOMB)
	pkmn4.learn_move(:HEADLONGRUSH)
	pkmn4.learn_move(:ICESHARD)
	pkmn4.learn_move(:KNOCKOFF)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :FIRE
	pkmn4.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:CLODSIRE,5)
	pkmn5.item = :HEAVYDUTYBOOTS
	pkmn5.ability_index = 3 # WATERABSORB
	pkmn5.nature = :CAREFUL
	pkmn5.learn_move(:STEALTHROCK)
	pkmn5.learn_move(:SANDATTACK)
	pkmn5.learn_move(:MORTALSPIN)
	pkmn5.learn_move(:RECOVER)
	pkmn5.ev[:HP] = 252
	pkmn5.ev[:ATTACK] = 8 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 252
	pkmn5.ev[:SPEED] = 0
	pkmn5.tera_type = :DARK
	pkmn5.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:SANDYSHOCKS,5)
	pkmn6.item = :WEAKNESSPOLICY
	pkmn6.ability_index = 6 # FILTER
	pkmn6.nature = :TIMID
	pkmn6.learn_move(:EGGBOMB)
	pkmn6.learn_move(:THUNDERCLAP)
	pkmn6.learn_move(:GRAVITY)
	pkmn6.learn_move(:VOLTSWITCH)
	pkmn6.ev[:HP] = 52
	pkmn6.ev[:ATTACK] = 208
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 252
	pkmn6.tera_type = :ELECTRIC
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoRockPartyQuickStart5 # Poke Paste: https://pokepast.es/173aac7252c7b758
	pkmn1 = Pokemon.new(:IRONBOULDER,5)
	pkmn1.item = :CHOICESCARF
	pkmn1.ability_index = 2 # SHARPNESS
	pkmn1.nature = :JOLLY
	pkmn1.learn_move(:MIGHTYCLEAVE)
	pkmn1.learn_move(:PSYCHOCUT)
	pkmn1.learn_move(:SACREDSWORD)
	pkmn1.learn_move(:SLASH)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :FIRE
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:ARCANINE_1,5)
	pkmn2.item = :HEAVYDUTYBOOTS
	pkmn2.ability_index = 3 # ROCKHEAD
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:FLAREBLITZ)
	pkmn2.learn_move(:HEADSMASH)
	pkmn2.learn_move(:CLOSECOMAT)
	pkmn2.learn_move(:SUBSTITUTE)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :ROCK
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:GLIMMORA,5)
	pkmn3.item = :CHOICESPECS
	pkmn3.ability_index = 4 # LEVITATE
	pkmn3.nature = :TIMID
	pkmn3.learn_move(:HYPERBEAM)
	pkmn3.learn_move(:SLUDGEBOMB)
	pkmn3.learn_move(:ENERGYBALL)
	pkmn3.learn_move(:EARTHPOWER)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :ELECTRIC
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:MINIOR,5)
	pkmn4.item = :WHITEHERB
	pkmn4.ability_index = 0 # SHIELDSDOWN
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:EGGBOMB)
	pkmn4.learn_move(:STONEEDGE)
	pkmn4.learn_move(:EARTHQUAKE)
	pkmn4.learn_move(:SHELLSMASH)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :WATER
	pkmn4.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:GARGANACL,5)
	pkmn5.item = :LEFTOVERS
	pkmn5.ability_index = 0 # ROUGHSKIN
	pkmn5.nature = :CAREFUL
	pkmn5.learn_move(:STEALTHROCK)
	pkmn5.learn_move(:PROTECT)
	pkmn5.learn_move(:RECOVER)
	pkmn5.learn_move(:SALTCURE)
	pkmn5.ev[:HP] = 256
	pkmn5.ev[:ATTACK] = 0 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 256
	pkmn5.ev[:SPEED] = 0
	pkmn5.tera_type = :GHOST
	pkmn5.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:OGERPON,5)
	pkmn6.item = :CORNERSTONEMASK
	pkmn6.nature = :JOLLY
	pkmn6.learn_move(:IVYCUDGEL)
	pkmn6.learn_move(:HORNLEECH)
	pkmn6.learn_move(:SWORDSDANCE)
	pkmn6.learn_move(:SUPERPOWER)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.iv[:SPECIAL_ATTACK] = 0
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoBugPartyQuickStart5 # Poke Paste: https://pokepast.es/0a6ff83acecfc3b9
	pkmn1 = Pokemon.new(:VOLCARONA,5)
	pkmn1.item = :LEFTOVERS
	pkmn1.ability_index = 5 # FLASHFIRE
	pkmn1.nature = :TIMID
	pkmn1.learn_move(:QUIVERDANCE)
	pkmn1.learn_move(:EMBER)
	pkmn1.learn_move(:MORNINGSUN)
	pkmn1.learn_move(:PSYCHIC)
	pkmn1.ev[:HP] = 256
	pkmn1.ev[:ATTACK] = 28
	pkmn1.ev[:DEFENSE] = 176
	pkmn1.ev[:SPECIAL_DEFENSE] = 52
	pkmn1.ev[:SPEED] = 0
	pkmn1.tera_type = :POISON
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:FORRETRESS,5)
	pkmn2.item = :ROCKYHELMET
	pkmn2.ability_index = 6 # BATTLEARMOR
	pkmn2.nature = :IMPISH
	pkmn2.learn_move(:THUNDERWAVE)
	pkmn2.learn_move(:VOLTSWITCH)
	pkmn2.learn_move(:RAPIDSPIN)
	pkmn2.learn_move(:ICESPINNER)
	pkmn2.ev[:HP] = 256
	pkmn2.ev[:ATTACK] = 0
	pkmn2.ev[:DEFENSE] = 256
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 0
	pkmn2.tera_type = :ROCK
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:SCIZOR,5)
	pkmn3.item = :MEGAITE
	pkmn3.ability_index = 4 # INTIMIDATE
	pkmn3.nature = :ADAMANT
	pkmn3.learn_move(:SWORDSDANCE)
	pkmn3.learn_move(:BULLETPUNCH)
	pkmn3.learn_move(:KNOCKOFF)
	pkmn3.learn_move(:TRAILBLAZE)
	pkmn3.ev[:HP] = 124
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 132
	pkmn3.tera_type = :FIRE
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:KLEAVOR,5)
	pkmn4.item = :CHOICESCARF
	pkmn4.ability_index = 2 # SHARPNESS
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:STONEAXE)
	pkmn4.learn_move(:UTURN)
	pkmn4.learn_move(:NIGHTSLASH)
	pkmn4.learn_move(:SLASH)
	pkmn4.ev[:HP] = 256
	pkmn4.ev[:ATTACK] = 28
	pkmn4.ev[:DEFENSE] = 176
	pkmn4.ev[:SPECIAL_DEFENSE] = 52
	pkmn4.ev[:SPEED] = 0
	pkmn4.tera_type = :FIGHTING
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:YANMEGA,5)
	pkmn5.item = :CHOICESPECS
	pkmn5.ability_index = 5 # TINTEDLENS
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:AEROBLAST)
	pkmn5.learn_move(:EGGBOMB)
	pkmn5.learn_move(:DRACOMETEOR)
	pkmn5.learn_move(:UTURN)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :STEEL
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:ARAQUANID,5)
	pkmn6.item = :MENTALHERB
	pkmn6.ability_index = 0 # WATERBUBBLE
	pkmn6.nature = :ADAMANT
	pkmn6.learn_move(:LIQUIDATION)
	pkmn6.learn_move(:INFESTATION)
	pkmn6.learn_move(:STICKYWEB)
	pkmn6.learn_move(:MIRRORCOAT)
	pkmn6.ev[:HP] = 252
	pkmn6.ev[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 252
	pkmn6.ev[:SPECIAL_DEFENSE] = 8
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :GHOST
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoGhostPartyQuickStart5 # Poke Paste: https://pokepast.es/34eef7480aca0e56
	pkmn1 = Pokemon.new(:GHOLDENGO,5)
	pkmn1.item = :AIRBALLOON
	pkmn1.ability_index = 5 # PRANKSTER
	pkmn1.nature = :MODEST
	pkmn1.learn_move(:NASTYPLOT)
	pkmn1.learn_move(:SHADOWBALL)
	pkmn1.learn_move(:RECOVER)
	pkmn1.learn_move(:EGGBOMB)
	pkmn1.ev[:HP] = 136
	pkmn1.ev[:ATTACK] = 148
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 228
	pkmn1.tera_type = :FAIRY
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:CERULEDGE,5)
	pkmn2.item = :FOCUSSASH
	pkmn2.ability_index = 2 # WEAKARMOR
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:EGGBOMB)
	pkmn2.learn_move(:SACREDFIRE)
	pkmn2.learn_move(:SHADOWSNEAK)
	pkmn2.learn_move(:SWORDSDANCE)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :FIGHTING
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:FLUTTERMANE,5)
	pkmn3.item = :CHOICESPECS
	pkmn3.ability_index = 3 # INTIMIDATE
	pkmn3.nature = :TIMID
	pkmn3.learn_move(:EGGBOMB)
	pkmn3.learn_move(:MOONBLAST)
	pkmn3.learn_move(:THUNDERBOLT)
	pkmn3.learn_move(:POWERGEM)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :STELLAR
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:SPECTRIER,5)
	pkmn4.item = :LEFTOVERS
	pkmn4.ability_index = 5 # SHADOWSHIELD
	pkmn4.nature = :TIMID
	pkmn4.learn_move(:CALMMIND)
	pkmn4.learn_move(:SUBSTITUTE)
	pkmn4.learn_move(:WILLOWISP)
	pkmn4.learn_move(:HEX)
	pkmn4.ev[:HP] = 188
	pkmn4.ev[:ATTACK] = 0
	pkmn4.ev[:DEFENSE] = 124
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 200
	pkmn4.tera_type = :POISON
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:DRAGAPULT,5)
	pkmn5.item = :CHOICESCARF
	pkmn5.ability_index = 6 # INFILTRATOR
	pkmn5.nature = :NAIVE
	pkmn5.learn_move(:DRAGONDARTS)
	pkmn5.learn_move(:SHADOWBALL)
	pkmn5.learn_move(:UTURN)
	pkmn5.learn_move(:THUNDERWAVE)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :ELECTRIC
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:BRAMBLEGHAST,5)
	pkmn6.item = :ROCKYHELMET
	pkmn6.ability_index = 2 # IRONBARBS
	pkmn6.nature = :IMPISH
	pkmn6.learn_move(:SPIKES)
	pkmn6.learn_move(:RAPIDSPIN)
	pkmn6.learn_move(:STRENGTHSAP)
	pkmn6.learn_move(:SAPPYSEED)
	pkmn6.ev[:HP] = 256
	pkmn6.ev[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 240
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 16
	pkmn6.tera_type = :WATER
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoSteelPartyQuickStart5 # Poke Paste: https://pokepast.es/5b4e5ca4bee4d04d
	pkmn1 = Pokemon.new(:GHOLDENGO,5)
	pkmn1.item = :MENTALHERB
	pkmn1.ability_index = 5 # PRANKSTER
	pkmn1.nature = :MODEST
	pkmn1.learn_move(:NASTYPLOT)
	pkmn1.learn_move(:SHADOWBALL)
	pkmn1.learn_move(:RECOVER)
	pkmn1.learn_move(:EGGBOMB)
	pkmn1.ev[:HP] = 192
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 64
	pkmn1.tera_type = :FAIRY
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:HEATRAN,5)
	pkmn2.item = :AIRBALLOON
	pkmn2.ability_index = 6 # ROCKYPAYLOAD
	pkmn2.nature = :CALM
	pkmn2.learn_move(:ANCIENTPOWER)
	pkmn2.learn_move(:EARTHPOWER)
	pkmn2.learn_move(:LAVAPLUME)
	pkmn2.learn_move(:SLACKOFF)
	pkmn2.ev[:HP] = 228
	pkmn2.ev[:ATTACK] = 0
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 240
	pkmn2.ev[:SPEED] = 44
	pkmn2.tera_type = :GRASS
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:SKARMORY,5)
	pkmn3.item = :ROCKYHELMET
	pkmn3.ability_index = 5 # MIRRORARMOR
	pkmn3.nature = :BOLD
	pkmn3.learn_move(:SPIKES)
	pkmn3.learn_move(:ROOST)
	pkmn3.learn_move(:WHIRLWIND)
	pkmn3.learn_move(:BODYPRESS)
	pkmn3.ev[:HP] = 244
	pkmn3.ev[:ATTACK] = 0
	pkmn3.ev[:DEFENSE] = 172
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 96
	pkmn3.tera_type = :GROUND
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:ARCHALUDON,5)
	pkmn4.item = :CHOICESCARF
	pkmn4.ability_index = 0 # STAMINA
	pkmn4.nature = :TIMID
	pkmn4.learn_move(:BODYPRESS)
	pkmn4.learn_move(:DRACOMETEOR)
	pkmn4.learn_move(:HYPERBEAM)
	pkmn4.learn_move(:THUNDERBOLT)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :FLYING
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:IRONTREADS,5)
	pkmn5.item = :ASSAULTVEST
	pkmn5.ability_index = 3 # FILTER
	pkmn5.nature = :JOLLY
	pkmn5.learn_move(:RAPIDSPIN)
	pkmn5.learn_move(:KNOCKOFF)
	pkmn5.learn_move(:EARTHQUAKE)
	pkmn5.learn_move(:ICESPINNER)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :GHOST
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:SCIZOR,5)
	pkmn6.item = :POWERHERB
	pkmn6.ability_index = 0 # FULLMETALBODY
	pkmn6.nature = :ADAMANT
	pkmn6.learn_move(:GEOMANCY)
	pkmn6.learn_move(:SWORDSDANCE)
	pkmn6.learn_move(:DOUBLEHIT)
	pkmn6.learn_move(:FIRSTIMPRESSION)
	pkmn6.ev[:HP] = 252
	pkmn6.ev[:ATTACK] = 252
	pkmn6.ev[:DEFENSE] = 4
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 4
	pkmn6.tera_type = :FIRE
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoFirePartyQuickStart5 # Poke Paste: https://pokepast.es/57e510e3bdaf5c06
	pkmn1 = Pokemon.new(:CINDERACE,5)
	pkmn1.item = :MEGAITE
	pkmn1.ability_index = 4 # LIMBER
	pkmn1.nature = :JOLLY
	pkmn1.learn_move(:GIGAIMPACT)
	pkmn1.learn_move(:GUNKSHOT)
	pkmn1.learn_move(:HIGHJUMPKICK)
	pkmn1.learn_move(:UTURN)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :GRASS
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:CERULEDGE,5)
	pkmn2.item = :FOCUSSASH
	pkmn2.ability_index = 2 # WEAKARMOR
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:EGGBOMB)
	pkmn2.learn_move(:SACREDFIRE)
	pkmn2.learn_move(:SHADOWSNEAK)
	pkmn2.learn_move(:SWORDSDANCE)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :FIGHTING
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:TALONFLAME,5)
	pkmn3.item = :HEAVYDUTYBOOTS
	pkmn3.ability_index = 5 # FLAMEBODY
	pkmn3.nature = :TIMID
	pkmn3.learn_move(:AEROBLAST)
	pkmn3.learn_move(:UTURN)
	pkmn3.learn_move(:DEFOG)
	pkmn3.learn_move(:ROOST)
	pkmn3.ev[:HP] = 128
	pkmn3.ev[:ATTACK] = 0
	pkmn3.ev[:DEFENSE] = 252
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 132
	pkmn3.tera_type = :FAIRY
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:OGERPON,100)
	pkmn4.item = :HEARTHFLAMEMASK
	pkmn4.nature = :ADAMANT
	pkmn4.learn_move(:IVYCUDGEL)
	pkmn4.learn_move(:HORNLEECH)
	pkmn4.learn_move(:SWORDSDANCE)
	pkmn4.learn_move(:SUBSTITUTE)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.iv[:SPECIAL_ATTACK] = 0
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:VOLCANION,5)
	pkmn5.item = :HEATROCK
	pkmn5.ability_index = 3 # DROUGHT
	pkmn5.nature = :MODEST
	pkmn5.learn_move(:BLASTBURN)
	pkmn5.learn_move(:EARTHPOWER)
	pkmn5.learn_move(:SLUDGEBOMB)
	pkmn5.learn_move(:WHIRLPOOL)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :GROUND
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:HEATRAN,5)
	pkmn6.item = :LEFTOVERS
	pkmn6.ability_index = 0 # EARTHEATER
	pkmn6.nature = :CALM
	pkmn6.learn_move(:MAGMASTORM)
	pkmn6.learn_move(:EGGBOMB)
	pkmn6.learn_move(:EARTHPOWER)
	pkmn6.learn_move(:STEALTHROCK)
	pkmn6.ev[:HP] = 140
	pkmn6.ev[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 252
	pkmn6.ev[:SPEED] = 120
	pkmn6.tera_type = :ELECTRIC
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoWaterPartyQuickStart5 # Poke Paste: https://pokepast.es/46ba59df3fbabee0
	pkmn1 = Pokemon.new(:GRENINJA,5)
	pkmn1.item = :MEGAITE
	pkmn1.ability_index = 0 # PROTEAN
	pkmn1.nature = :TIMID
	pkmn1.learn_move(:HYDROCANNON)
	pkmn1.learn_move(:EGGBOMB)
	pkmn1.learn_move(:ICEBEAM)
	pkmn1.learn_move(:EXTRASENSORY)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :WATER
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:SUICUNE,5)
	pkmn2.item = :LEFTOVERS
	pkmn2.ability_index = 2 # PRESSURE
	pkmn2.nature = :BOLD
	pkmn2.learn_move(:SUBSTITUTE)
	pkmn2.learn_move(:CALMMIND)
	pkmn2.learn_move(:SCALD)
	pkmn2.learn_move(:REST)
	pkmn2.ev[:HP] = 256
	pkmn2.ev[:ATTACK] = 0
	pkmn2.ev[:DEFENSE] = 256
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 0
	pkmn2.tera_type = :FAIRY
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:TOXAPEX,5)
	pkmn3.item = :BINDINGBAND
	pkmn3.ability_index = 0 # TOXICDEBRIS
	pkmn3.nature = :BOLD
	pkmn3.learn_move(:TOXIC)
	pkmn3.learn_move(:HAZE)
	pkmn3.learn_move(:RECOVER)
	pkmn3.learn_move(:WHIRLPOOL)
	pkmn3.ev[:HP] = 256
	pkmn3.ev[:ATTACK] = 0
	pkmn3.ev[:DEFENSE] = 252
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 4
	pkmn3.tera_type = :DARK
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:EMPOLEON,100)
	pkmn4.item = :AIRBALLOON
	pkmn4.nature = :CALM
	pkmn4.learn_move(:STEALTHROCK)
	pkmn4.learn_move(:EGGBOMB)
	pkmn4.learn_move(:ROOST)
	pkmn4.learn_move(:ROAR)
	pkmn4.ev[:HP] = 256
	pkmn4.ev[:ATTACK] = 4
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 252
	pkmn4.ev[:SPEED] = 0
	pkmn4.tera_type = :GROUND
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:GASTRODON,5)
	pkmn5.item = :MENTALHERB
	pkmn5.ability_index = 6 # SHELLARMOR
	pkmn5.nature = :CALM
	pkmn5.learn_move(:SPIKES)
	pkmn5.learn_move(:EGGBOMB)
	pkmn5.learn_move(:HEALBELL)
	pkmn5.learn_move(:LUNARBLESSING)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :POISON
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:ALOMOMOLA,5)
	pkmn6.item = :GRIPCLAW
	pkmn6.ability_index = 0 # REGENERATOR
	pkmn6.nature = :SASSY
	pkmn6.learn_move(:FLIPTURN)
	pkmn6.learn_move(:WISH)
	pkmn6.learn_move(:PROTECT)
	pkmn6.learn_move(:WHIRLPOOL)
	pkmn6.ev[:HP] = 256
	pkmn6.ev[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 256
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :STEEL
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoGrassPartyQuickStart5 # Poke Paste: https://pokepast.es/4a7c53b5a7815701
	pkmn1 = Pokemon.new(:RILLABOOM,5)
	pkmn1.item = :MEGAITE
	pkmn1.ability_index = 5 # INTIMIDATE
	pkmn1.nature = :JOLLY
	pkmn1.learn_move(:DOUBLEHIT)
	pkmn1.learn_move(:KNOCKOFF)
	pkmn1.learn_move(:BODYPRESS)
	pkmn1.learn_move(:VICTORYDANCE)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :GRASS
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:MEOWSCARADA,5)
	pkmn2.item = :CHOICESCARF
	pkmn2.ability_index = 2 # BATTLEBOND
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:FLOWERTRICK)
	pkmn2.learn_move(:KNOCKOFF)
	pkmn2.learn_move(:PLAYROUGH)
	pkmn2.learn_move(:UTURN)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :GHOST
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:SINISTCHA,5)
	pkmn3.item = :LEFTOVERS
	pkmn3.ability_index = 0 # HEATPROOF
	pkmn3.nature = :BOLD
	pkmn3.learn_move(:CALMMIND)
	pkmn3.learn_move(:STRENGTHSAP)
	pkmn3.learn_move(:SHADOWBALL)
	pkmn3.learn_move(:MATCHAGOTHA)
	pkmn3.ev[:HP] = 252
	pkmn3.ev[:ATTACK] = 0
	pkmn3.ev[:DEFENSE] = 160
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 100
	pkmn3.tera_type = :POISON
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:OGERPON,100)
	pkmn4.item = :HEARTHFLAMEMASK
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:IVYCUDGEL)
	pkmn4.learn_move(:HORNLEECH)
	pkmn4.learn_move(:SWORDSDANCE)
	pkmn4.learn_move(:PLAYROUGH)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.iv[:SPECIAL_ATTACK] = 0
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:WHIMSICOTT,5)
	pkmn5.item = :PIXIEPLATE
	pkmn5.ability_index = 0 # PRANKSTER
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:MOONBLAST)
	pkmn5.learn_move(:ENERGYBALL)
	pkmn5.learn_move(:UTURN)
	pkmn5.learn_move(:MEMENTO)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :FLYING
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:AMOONGUSS,50)
	pkmn6.item = :ROCKYHELMET
	pkmn6.ability_index = 3 # Regenerator
	pkmn6.nature = :CALM
	pkmn6.learn_move(:FOULPLAY)
	pkmn6.learn_move(:SLUDGEBOMB)
	pkmn6.learn_move(:SYNTHESIS)
	pkmn6.learn_move(:SPORE)
	pkmn6.ev[:HP] = 244
	pkmn6.ev[:DEFENSE] = 164
	pkmn6.ev[:SPECIAL_DEFENSE] = 104
	pkmn6.iv[:SPEED] = 0
	pkmn6.tera_type = :FAIRY
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoElectricPartyQuickStart5 # Poke Paste: https://pokepast.es/240c891d4149ca55
	pkmn1 = Pokemon.new(:RAGINGBOLT,5)
	pkmn1.item = :ELECTRICSEED
	pkmn1.ability_index = 4 # INTIMIDATE
	pkmn1.nature = :MODEST
	pkmn1.learn_move(:THUNDER)
	pkmn1.learn_move(:EGGBOMB)
	pkmn1.learn_move(:THUNDERCLAP)
	pkmn1.learn_move(:CALMMIND)
	pkmn1.ev[:HP] = 124
	pkmn1.ev[:ATTACK] = 252
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 136
	pkmn1.tera_type = :BUG
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:IRONHANDS,5)
	pkmn2.item = :ASSAULTVEST
	pkmn2.ability_index = 0 # QUARKDRIVE
	pkmn2.nature = :CAREFUL
	pkmn2.learn_move(:DRAINPUNCH)
	pkmn2.learn_move(:WILDCHARGE)
	pkmn2.learn_move(:HEAVYSLAM)
	pkmn2.learn_move(:VOLTSWITCH)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 136
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 208
	pkmn2.ev[:SPEED] = 168
	pkmn2.tera_type = :GRASS
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:ROTOM_2,5)
	pkmn3.item = :DAMPROCK
	pkmn3.ability_index = 3 # DRIZZLE
	pkmn3.nature = :BOLD
	pkmn3.learn_move(:SOAK)
	pkmn3.learn_move(:HYDROPUMP)
	pkmn3.learn_move(:VOLTSWITCH)
	pkmn3.learn_move(:FOULPLAY)
	pkmn3.ev[:HP] = 248
	pkmn3.ev[:ATTACK] = 0
	pkmn3.ev[:DEFENSE] = 212
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 52
	pkmn3.tera_type = :WATER
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:REGIELEKI,100)
	pkmn4.item = :HEAVYDUTYBOOTS
	pkmn3.ability_index = 0 # ELECTRICSURGE
	pkmn4.nature = :TIMID
	pkmn4.learn_move(:THUNDER)
	pkmn4.learn_move(:VOLTSWITCH)
	pkmn4.learn_move(:RAPIDSPIN)
	pkmn4.learn_move(:THUNDERWAVE)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :ROCK
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:SANDYSHOCKS,5)
	pkmn5.item = :BOOSTERENERGY
	pkmn5.ability_index = 0 # PROTOSYNTHESIS
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:SPIKES)
	pkmn5.learn_move(:VOLTSWITCH)
	pkmn5.learn_move(:STEALTHROCK)
	pkmn5.learn_move(:EGGBOMB)
	pkmn5.ev[:HP] = 52
	pkmn5.ev[:ATTACK] = 208
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 252
	pkmn5.tera_type = :ICE
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:ZAPDOS,5)
	pkmn6.item = :LEFTOVERS
	pkmn6.ability_index = 4 # DELTASTREAM
	pkmn6.nature = :MODEST
	pkmn6.learn_move(:THUNDER)
	pkmn6.learn_move(:AEROBLAST)
	pkmn6.learn_move(:AGILITY)
	pkmn6.learn_move(:BATONPASS)
	pkmn6.ev[:HP] = 140
	pkmn6.ev[:ATTACK] = 252
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 120
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :FLYING
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoPsychicPartyQuickStart5 # Poke Paste: https://pokepast.es/d71fa8f1e1e7d611
	pkmn1 = Pokemon.new(:SLOWKING,5)
	pkmn1.item = :KASIBBERRY
	pkmn1.ability_index = 0 # REGENERATOR
	pkmn1.nature = :BOLD
	pkmn1.learn_move(:KINESIS)
	pkmn1.learn_move(:SCALD)
	pkmn1.learn_move(:THUNDERWAVE)
	pkmn1.learn_move(:LUNARBLESSING)
	pkmn1.ev[:HP] = 256
	pkmn1.ev[:ATTACK] = 0
	pkmn1.ev[:DEFENSE] = 256
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 0
	pkmn1.tera_type = :FAIRY
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:HATTERENE,5)
	pkmn2.item = :TERRAINEXTENDER
	pkmn2.ability_index = 3 # PSYCHICSURGE
	pkmn2.nature = :BOLD
	pkmn2.learn_move(:CALMMIND)
	pkmn2.learn_move(:PSYSHOCK)
	pkmn2.learn_move(:DRAININGKISS)
	pkmn2.learn_move(:GIGADRAIN)
	pkmn2.ev[:HP] = 256
	pkmn2.ev[:ATTACK] = 0
	pkmn2.ev[:DEFENSE] = 204
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 52
	pkmn2.tera_type = :WATER
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:HOOPA_1,5)
	pkmn3.item = :PSYCHICSEED
	pkmn3.ability_index = 4 # INTIMIDATE
	pkmn3.nature = :MILD
	pkmn3.learn_move(:EXPANDINGFORCE)
	pkmn3.learn_move(:KNOCKOFF)
	pkmn3.learn_move(:FOCUSBLAST)
	pkmn3.learn_move(:THUNDERBOLT)
	pkmn3.ev[:HP] = 240
	pkmn3.ev[:ATTACK] = 16
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 156
	pkmn3.ev[:SPEED] = 100
	pkmn3.tera_type = :POISON
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:IRONBOULDER,5)
	pkmn4.item = :RAZORCLAW
	pkmn3.ability_index = 2 # SHARPNESS
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:SWORDSDANCE)
	pkmn4.learn_move(:TAUNT)
	pkmn4.learn_move(:MIGHTYCLEAVE)
	pkmn4.learn_move(:EARTHQUAKE)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :ROCK
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:LATIOS,5)
	pkmn5.item = :MEGAITE
	pkmn5.ability_index = 0 # SPEEDBOOST
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:EXTRASENSORY)
	pkmn5.learn_move(:DRACOMETEOR)
	pkmn5.learn_move(:THUNDERBOLT)
	pkmn5.learn_move(:ICEBEAM)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :DRAGON
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:JIRACHI,5)
	pkmn6.item = :CHOICESCARF
	pkmn6.ability_index = 6 # MAGICBOUNCE
	pkmn6.nature = :JOLLY
	pkmn6.learn_move(:UTURN)
	pkmn6.learn_move(:BODYSLAM)
	pkmn6.learn_move(:STEALTHROCK)
	pkmn6.learn_move(:HEALINGWISH)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.tera_type = :FLYING
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoIcePartyQuickStart5 # Poke Paste: https://pokepast.es/9373088a9c4e8a75
	pkmn1 = Pokemon.new(:SANDSLASH_1,5)
	pkmn1.item = :HEAVYDUTYBOOTS
	pkmn1.ability_index = 0 # SLUSHRUSH
	pkmn1.nature = :JOLLY
	pkmn1.learn_move(:RAPIDSPIN)
	pkmn1.learn_move(:IRONHEAD)
	pkmn1.learn_move(:EARTHQUAKE)
	pkmn1.learn_move(:KNOCKOFF)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :GHOST
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:WEAVILE,5)
	pkmn2.item = :WIDELENS
	pkmn2.ability_index = 2 # TECHNICIAN
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:SWORDSDANCE)
	pkmn2.learn_move(:DOUBLEHIT)
	pkmn2.learn_move(:TRIPLEAXEL)
	pkmn2.learn_move(:ICESHARD)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :FLYING
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:NINETALES_1,5)
	pkmn3.item = :ICYROCK
	pkmn3.ability_index = 0 # SNOWWARNING
	pkmn3.nature = :TIMID
	pkmn3.learn_move(:AURORAVEIL)
	pkmn3.learn_move(:FREEZEDRY)
	pkmn3.learn_move(:MOONBLAST)
	pkmn3.learn_move(:ENCORE)
	pkmn3.ev[:HP] = 252
	pkmn3.ev[:ATTACK] = 0
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 4
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :PSYCHIC
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:MAMOSWINE,5)
	pkmn4.item = :LIFEORB
	pkmn3.ability_index = 6 # SHEERFORCE
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:HEADLONGRUSH)
	pkmn4.learn_move(:MOUNTAINGALE)
	pkmn4.learn_move(:ROCKCLIMB)
	pkmn4.learn_move(:IRONHEAD)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :FIRE
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:LAPRAS,5)
	pkmn5.item = :LEFTOVERS
	pkmn5.ability_index = 0 # SHELLARMOR
	pkmn5.nature = :ADAMANT
	pkmn5.learn_move(:LIQUIDATION)
	pkmn5.learn_move(:BODYSLAM)
	pkmn5.learn_move(:BULKUP)
	pkmn5.learn_move(:SHEERCOLD)
	pkmn5.ev[:HP] = 32
	pkmn5.ev[:ATTACK] = 252
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 228
	pkmn5.tera_type = :POISON
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:KYUREM,5)
	pkmn6.item = :CHOICESCARF
	pkmn6.ability_index = 2 # BEASTBOOST
	pkmn6.nature = :TIMID
	pkmn6.learn_move(:DRACOMETEOR)
	pkmn6.learn_move(:HYPERBEAM)
	pkmn6.learn_move(:FREEZEDRY)
	pkmn6.learn_move(:EARTHPOWER)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.tera_type = :FAIRY
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoDragonPartyQuickStart5 # Poke Paste: https://pokepast.es/b883849ca83b0402
	pkmn1 = Pokemon.new(:DURALUDON,5)
	pkmn1.item = :EVIOLITE
	pkmn1.ability_index = 4 # STAMINA
	pkmn1.nature = :BOLD
	pkmn1.learn_move(:BODYPRESS)
	pkmn1.learn_move(:FLASHCANNON)
	pkmn1.learn_move(:STEALTHROCK)
	pkmn1.learn_move(:THUNDERWAVE)
	pkmn1.ev[:HP] = 252
	pkmn1.ev[:ATTACK] = 0
	pkmn1.ev[:DEFENSE] = 44
	pkmn1.ev[:SPECIAL_DEFENSE] = 216
	pkmn1.ev[:SPEED] = 0
	pkmn1.tera_type = :GHOST
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:GOODRA_1,5)
	pkmn2.item = :LEFTOVERS
	pkmn2.ability_index = 6 # GOOEY
	pkmn2.nature = :CAREFUL
	pkmn2.learn_move(:HEAVYSLAM)
	pkmn2.learn_move(:KNOCKOFF)
	pkmn2.learn_move(:DRAGONTAIL)
	pkmn2.learn_move(:PROTECT)
	pkmn2.ev[:HP] = 248
	pkmn2.ev[:ATTACK] = 0
	pkmn2.ev[:DEFENSE] = 12
	pkmn2.ev[:SPECIAL_DEFENSE] = 252
	pkmn2.ev[:SPEED] = 0
	pkmn2.tera_type = :FLYING
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:LATIOS,5)
	pkmn3.item = :EXPERTBELT
	pkmn3.ability_index = 4 # NEUROFORCE
	pkmn3.nature = :TIMID
	pkmn3.learn_move(:EXTRASENSORY)
	pkmn3.learn_move(:THUNDERBOLT)
	pkmn3.learn_move(:ICEBEAM)
	pkmn3.learn_move(:ROOST)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :STEEL
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:GARCHOMP,5)
	pkmn4.item = :MEGAITE
	pkmn3.ability_index = 2 # EARTHEATER
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:VICTORYDANCE)
	pkmn4.learn_move(:EXTREMESPEED)
	pkmn4.learn_move(:DRAGONASCENT)
	pkmn4.learn_move(:IRONTAIL)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :ROCK
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:DRAGAPULT,5)
	pkmn5.item = :CHOICESPECS
	pkmn5.ability_index = 2 # MEGALAUNCHER
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:HYPERBEAM)
	pkmn5.learn_move(:SHADOWBALL)
	pkmn5.learn_move(:FLAMETHROWER)
	pkmn5.learn_move(:UTURN)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :DRAGON
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:ROARINGMOON,5)
	pkmn6.item = :CHOICESCARF
	pkmn6.ability_index = 6 # MOXIE
	pkmn6.nature = :JOLLY
	pkmn6.learn_move(:DRAGONASCENT)
	pkmn6.learn_move(:KNOCKOFF)
	pkmn6.learn_move(:EARTHQUAKE)
	pkmn6.learn_move(:UTURN)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.tera_type = :FIRE
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoDarkPartyQuickStart5 # Poke Paste: https://pokepast.es/4088d29463d73e7a
	pkmn1 = Pokemon.new(:TINGLU,5)
	pkmn1.item = :LEFTOVERS
	pkmn1.ability_index = 5 # ROCKYPAYLOAD
	pkmn1.nature = :CAREFUL
	pkmn1.learn_move(:BODYSLAM)
	pkmn1.learn_move(:WHIRLWIND)
	pkmn1.learn_move(:SPIKES)
	pkmn1.learn_move(:RUINATION)
	pkmn1.ev[:HP] = 252
	pkmn1.ev[:ATTACK] = 0
	pkmn1.ev[:DEFENSE] = 8
	pkmn1.ev[:SPECIAL_DEFENSE] = 252
	pkmn1.ev[:SPEED] = 0
	pkmn1.tera_type = :POISON
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:MEOWSCARADA,5)
	pkmn2.item = :CHOICESCARF
	pkmn2.ability_index = 6 # MAGICBOUNCE
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:FLOWERTRICK)
	pkmn2.learn_move(:TRIPLEAXEL)
	pkmn2.learn_move(:PLAYROUGH)
	pkmn2.learn_move(:UTURN)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :GRASS
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:SAMUROTT_1,5)
	pkmn3.item = :RAZORCLAW
	pkmn3.ability_index = 4 # SHARPNESS
	pkmn3.nature = :JOLLY
	pkmn3.learn_move(:VICTORYDANCE)
	pkmn3.learn_move(:SLASH)
	pkmn3.learn_move(:RAZORSHELL)
	pkmn3.learn_move(:SACREDSWORD)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :FIRE
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:MANDIBUZZ,5)
	pkmn4.item = :HEAVYDUTYBOOTS
	pkmn3.ability_index = 0 # LEVITATE
	pkmn4.nature = :IMPISH
	pkmn4.learn_move(:PUNISHMENT)
	pkmn4.learn_move(:ROOST)
	pkmn4.learn_move(:TOXIC)
	pkmn4.learn_move(:VENOMDRENCH)
	pkmn4.ev[:HP] = 252
	pkmn4.ev[:ATTACK] = 0
	pkmn4.ev[:DEFENSE] = 252
	pkmn4.ev[:SPECIAL_DEFENSE] = 8
	pkmn4.ev[:SPEED] = 0
	pkmn4.tera_type = :ELECTRIC
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:HOOPA_1,5)
	pkmn5.item = :ASSAULTVEST
	pkmn5.ability_index = 4 # INTIMIDATE
	pkmn5.nature = :CAREFUL
	pkmn5.learn_move(:PSYCHICNOISE)
	pkmn5.learn_move(:KNOCKOFF)
	pkmn5.learn_move(:GUNKSHOT)
	pkmn5.learn_move(:DRAINPUNCH)
	pkmn5.ev[:HP] = 252
	pkmn5.ev[:ATTACK] = 48
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 196
	pkmn5.ev[:SPEED] = 16
	pkmn5.tera_type = :STEEL
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:DARKRAI,5)
	pkmn6.item = :SALACBERRY
	pkmn6.ability_index = 5 # DARKAURA
	pkmn6.nature = :TIMID
	pkmn6.learn_move(:SUBSTITUTE)
	pkmn6.learn_move(:NASTYPLOT)
	pkmn6.learn_move(:EGGBOMB)
	pkmn6.learn_move(:FOCUSBLAST)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.tera_type = :FAIRY
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoFairyPartyQuickStart5 # Poke Paste: https://pokepast.es/7befb3cd43301b4b
	pkmn1 = Pokemon.new(:FLUTTERMANE,5)
	pkmn1.item = :POWERHERB
	pkmn1.ability_index = 3 # INTIMIDATE
	pkmn1.nature = :TIMID
	pkmn1.learn_move(:GEOMANCY)
	pkmn1.learn_move(:NASTYPLOT)
	pkmn1.learn_move(:SPARKLYSWIRL)
	pkmn1.learn_move(:MYSTICALFIRE)
	pkmn1.ev[:HP] = 244
	pkmn1.ev[:ATTACK] = 4
	pkmn1.ev[:DEFENSE] = 124
	pkmn1.ev[:SPECIAL_DEFENSE] = 4
	pkmn1.ev[:SPEED] = 136
	pkmn1.tera_type = :FIRE
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:KLEFKI,5)
	pkmn2.item = :LIGHTCLAY
	pkmn2.ability_index = 0 # LEVITATE
	pkmn2.nature = :BOLD
	pkmn2.learn_move(:FOULPLAY)
	pkmn2.learn_move(:REFLECT)
	pkmn2.learn_move(:LIGHTSCREEN)
	pkmn2.learn_move(:STEALTHROCK)
	pkmn2.ev[:HP] = 252
	pkmn2.ev[:ATTACK] = 0
	pkmn2.ev[:DEFENSE] = 204
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 56
	pkmn2.tera_type = :ELECTRIC
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:ENAMORUS,5)
	pkmn3.item = :CHOICESCARF
	pkmn3.ability_index = 2 # CONTRARY
	pkmn3.nature = :JOLLY
	pkmn3.learn_move(:PLAYROUGH)
	pkmn3.learn_move(:BODYSLAM)
	pkmn3.learn_move(:SUPERPOWER)
	pkmn3.learn_move(:HEALINGWISH)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :GROUND
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:IRONVALIANT,5)
	pkmn4.item = :BOOSTERENERGY
	pkmn4.ability_index = 0 # QUARKDRIVE
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:SWORDSDANCE)
	pkmn4.learn_move(:CLOSECOMAT)
	pkmn4.learn_move(:KNOCKOFF)
	pkmn4.learn_move(:SPIRITBREAK)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :STEEL
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:CLEFABLE,5)
	pkmn5.item = :LIFEORB
	pkmn5.ability_index = 2 # MAGICGUARD
	pkmn5.nature = :BOLD
	pkmn5.learn_move(:TRIATTACK)
	pkmn5.learn_move(:THUNDERBOLT)
	pkmn5.learn_move(:QUIVERDANCE)
	pkmn5.learn_move(:SOFTBOILED)
	pkmn5.ev[:HP] = 252
	pkmn5.ev[:ATTACK] = 0
	pkmn5.ev[:DEFENSE] = 132
	pkmn5.ev[:SPECIAL_DEFENSE] = 64
	pkmn5.ev[:SPEED] = 64
	pkmn5.tera_type = :POISON
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:AZUMARILL,5)
	pkmn6.item = :HONEY
	pkmn6.ability_index = 0 # HUGEPOWER
	pkmn6.nature = :ADAMANT
	pkmn6.learn_move(:EXTREMESPEED)
	pkmn6.learn_move(:LIQUIDATION)
	pkmn6.learn_move(:KNOCKOFF)
	pkmn6.learn_move(:BELLYDRUM)
	pkmn6.ev[:HP] = 80
	pkmn6.ev[:ATTACK] = 252
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 4
	pkmn6.ev[:SPEED] = 176
	pkmn6.tera_type = :PSYCHIC
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedRainWeatherPartyQuickStart5 # Pending Poke Paste: https://nuzlocke.app/guides/radical-red-hardcore
	pkmn1 = Pokemon.new(:THUNDURUS,5)
	pkmn1.item = :DAMPROCK
	pkmn1.ability_index = 3 # PRANKSTER
	pkmn1.nature = :BOLD
	pkmn1.learn_move(:VOLTSWITCH)
	pkmn1.learn_move(:RAINDANCE)
	pkmn1.learn_move(:THUNDERWAVE)
	pkmn1.learn_move(:TAUNT)
	pkmn1.ev[:HP] = 256
	pkmn1.ev[:ATTACK] = 4
	pkmn1.ev[:DEFENSE] = 156
	pkmn1.ev[:SPECIAL_DEFENSE] = 92
	pkmn1.ev[:SPEED] = 4
	pkmn1.tera_type = :DARK
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:JIRACHI,5)
	pkmn2.item = :TERRAINEXTENDER
	pkmn2.ability_index = 4 # MISTYSURGE
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:STEALTHROCK)
	pkmn2.learn_move(:ENCORE)
	pkmn2.learn_move(:TRICK)
	pkmn2.learn_move(:UTURN)
	pkmn2.ev[:HP] = 252
	pkmn2.ev[:ATTACK] = 0
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 32
	pkmn2.ev[:SPEED] = 228
	pkmn2.tera_type = :WATER
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:SEISMITOAD,5)
	pkmn3.item = :THROATSPRAY
	pkmn3.ability_index = 3 # SWIFTSWIM
	pkmn3.nature = :TIMID
	pkmn3.learn_move(:WATERGUN)
	pkmn3.learn_move(:HYPERVOICE)
	pkmn3.learn_move(:GRASSKNOT)
	pkmn3.learn_move(:FOCUSBLAST)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :POISON
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:MANTINE,5)
	pkmn4.item = :LEFTOVERS
	pkmn4.ability_index = 6 # HYDRATION
	pkmn4.nature = :TIMID
	pkmn4.learn_move(:QUIVERDANCE)
	pkmn4.learn_move(:SCALD)
	pkmn4.learn_move(:TRIATTACK)
	pkmn4.learn_move(:ROOST)
	pkmn4.ev[:HP] = 80
	pkmn4.ev[:ATTACK] = 252
	pkmn4.ev[:DEFENSE] = 4
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 176
	pkmn4.tera_type = :GROUND
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:KINGDRA,5)
	pkmn5.item = :WATERIUMZ
	pkmn5.ability_index = 0 # SWIFTSWIM
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:HYPERBEAM)
	pkmn5.learn_move(:WATERGUN)
	pkmn5.learn_move(:SPLASH)
	pkmn5.learn_move(:ICEBEAM)
	pkmn5.ev[:HP] = 104
	pkmn5.ev[:ATTACK] = 152
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :FLYING
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:GRENINJA,5)
	pkmn6.item = :MEGAITE
	pkmn6.ability_index = 0 # PROTEAN
	pkmn6.nature = :TIMID
	pkmn6.learn_move(:HYDROCANNON)
	pkmn6.learn_move(:EGGBOMB)
	pkmn6.learn_move(:ICEBEAM)
	pkmn6.learn_move(:EXTRASENSORY)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.tera_type = :WATER
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedSunWeatherPartyQuickStart5 # Pending Poke Paste: https://nuzlocke.app/guides/radical-red-hardcore
	pkmn1 = Pokemon.new(:CHARIZARD,5)
	pkmn1.item = :MEGAITEY
	pkmn1.ability_index = 4 # DROUGHT
	pkmn1.nature = :TIMID
	pkmn1.learn_move(:BLASTBURN)
	pkmn1.learn_move(:AEROBLAST)
	pkmn1.learn_move(:SCORCHINGSANDS)
	pkmn1.learn_move(:SOLARBEAM)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :FIRE
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:GROUDON,5)
	pkmn2.item = :REDORB
	pkmn2.ability_index = 4 # INTIMIDATE
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:ROCKPOLISH)
	pkmn2.learn_move(:SWORDSDANCE)
	pkmn2.learn_move(:PRECIPICEBLADES)
	pkmn2.learn_move(:HEATCRASH)
	pkmn2.ev[:HP] = 140
	pkmn2.ev[:ATTACK] = 252
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 120
	pkmn2.tera_type = :GROUND
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:HELIOLISK,5)
	pkmn3.item = :LIFEORB
	pkmn3.ability_index = 1 # SOLARPOWER
	pkmn3.nature = :TIMID
	pkmn3.learn_move(:WEATHERBALL)
	pkmn3.learn_move(:THUNDERCLAP)
	pkmn3.learn_move(:SOLARBEAM)
	pkmn3.learn_move(:QUIVERDANCE)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :FLYING
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:DARMANITAN_2,5)
	pkmn4.item = :SALACBERRY
	pkmn4.ability_index = 2 # ZENMODE
	pkmn4.nature = :ADAMANT
	pkmn4.learn_move(:BODYSLAM)
	pkmn4.learn_move(:FLAREBLITZ)
	pkmn4.learn_move(:ENDURE)
	pkmn4.learn_move(:REVERSAL)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :GRASS
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:HOOH,5)
	pkmn5.item = :HEAVYDUTYBOOTS
	pkmn5.ability_index = 2 # WINDRIDER
	pkmn5.nature = :ADAMANT
	pkmn5.learn_move(:SACREDFIRE)
	pkmn5.learn_move(:DOUBLEEDGE)
	pkmn5.learn_move(:EARTHQUAKE)
	pkmn5.learn_move(:TAILWIND)
	pkmn5.ev[:HP] = 252
	pkmn5.ev[:ATTACK] = 176
	pkmn5.ev[:DEFENSE] = 20
	pkmn5.ev[:SPECIAL_DEFENSE] = 56
	pkmn5.ev[:SPEED] = 8
	pkmn5.tera_type = :ELECTRIC
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:VENUSAUR,5)
	pkmn6.item = :FOCUSSASH
	pkmn6.ability_index = 3 # CHLOROPHYLL
	pkmn6.nature = :TIMID
	pkmn6.learn_move(:GROWTH)
	pkmn6.learn_move(:TRIATTACK)
	pkmn6.learn_move(:POISONPOWDER)
	pkmn6.learn_move(:WEATHERBALL)
	pkmn6.ev[:HP] = 72
	pkmn6.ev[:ATTACK] = 252
	pkmn6.ev[:DEFENSE] = 4
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 184
	pkmn6.tera_type = :ROCK
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedSandstormPartyQuickStart5 # Pending Poke Paste: https://nuzlocke.app/guides/radical-red-hardcore
	pkmn1 = Pokemon.new(:GIGALITH,5)
	pkmn1.item = :CUSTAPBERRY
	pkmn1.ability_index = 4 # SANDSTREAM
	pkmn1.nature = :ADAMANT
	pkmn1.learn_move(:EXPLOSION)
	pkmn1.learn_move(:STEALTHROCK)
	pkmn1.learn_move(:SANDTOMB)
	pkmn1.learn_move(:SANDSTORM)
	pkmn1.ev[:HP] = 256
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 0
	pkmn1.tera_type = :FLYING
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:LANDORUS_1,5)
	pkmn2.item = :SMOOTHROCK
	pkmn2.ability_index = 5 # SANDSTREAM
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:STEALTHROCK)
	pkmn2.learn_move(:TAUNT)
	pkmn2.learn_move(:UTURN)
	pkmn2.learn_move(:FLOATYFALL)
	pkmn2.ev[:HP] = 252
	pkmn2.ev[:ATTACK] = 0
	pkmn2.ev[:DEFENSE] = 4
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :GHOST
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:ZYGARDE,5)
	pkmn3.item = :LEFTOVERS
	pkmn3.ability_index = 0 # POWERCONSTRUCT
	pkmn3.nature = :IMPISH
	pkmn3.learn_move(:COIL)
	pkmn3.learn_move(:THOUSANDARROWS)
	pkmn3.learn_move(:REST)
	pkmn3.learn_move(:DRAGONTAIL)
	pkmn3.ev[:HP] = 256
	pkmn3.ev[:ATTACK] = 0
	pkmn3.ev[:DEFENSE] = 96
	pkmn3.ev[:SPECIAL_DEFENSE] = 108
	pkmn3.ev[:SPEED] = 52
	pkmn3.tera_type = :FAIRY
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:AERODACTYL,5)
	pkmn4.item = :MEGAITE
	pkmn4.ability_index = 3 # ROCKHEAD
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:DRAGONDANCE)
	pkmn4.learn_move(:ROCKCLIMB)
	pkmn4.learn_move(:EARTHQUAKE)
	pkmn4.learn_move(:FLOATYFALL)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :ROCK
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:EMPOLEON,5)
	pkmn5.item = :WEAKNESSPOLICY
	pkmn5.ability_index = 4 # BATTLEARMOR
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:AGILITY)
	pkmn5.learn_move(:ROOST)
	pkmn5.learn_move(:SCALD)
	pkmn5.learn_move(:ICEBEAM)
	pkmn5.ev[:HP] = 96
	pkmn5.ev[:ATTACK] = 252
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 164
	pkmn5.tera_type = :ELECTRIC
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:CRADILY,5)
	pkmn6.item = :BIGROOT
	pkmn6.ability_index = 0 # STORMDRAIN
	pkmn6.nature = :IMPISH
	pkmn6.learn_move(:SAPPYSEED)
	pkmn6.learn_move(:JUNGLEHEALING)
	pkmn6.learn_move(:INGRAIN)
	pkmn6.learn_move(:STOCKPILE)
	pkmn6.ev[:HP] = 256
	pkmn6.ev[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 92
	pkmn6.ev[:SPECIAL_DEFENSE] = 164
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :GROUND
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedHailstormPartyQuickStart5 # Pending Poke Paste: https://nuzlocke.app/guides/radical-red-hardcore
	pkmn1 = Pokemon.new(:SUICUNE,5)
	pkmn1.item = :ICYROCK
	pkmn1.ability_index = 4 # SNOWWARNING
	pkmn1.nature = :CALM
	pkmn1.learn_move(:AURORAVEIL)
	pkmn1.learn_move(:FLIPTURN)
	pkmn1.learn_move(:TAILWIND)
	pkmn1.learn_move(:ROAR)
	pkmn1.ev[:HP] = 256
	pkmn1.ev[:ATTACK] = 4
	pkmn1.ev[:DEFENSE] = 108
	pkmn1.ev[:SPECIAL_DEFENSE] = 60
	pkmn1.ev[:SPEED] = 84
	pkmn1.tera_type = :DARK
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:KYUREM_2,5)
	pkmn2.item = :LOADEDDICE
	pkmn2.ability_index = 3 # INTIMIDATE
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:DRAGONDANCE)
	pkmn2.learn_move(:EGGBOMB)
	pkmn2.learn_move(:SUBSTITUTE)
	pkmn2.learn_move(:DRAGONDANCE)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 252
	pkmn2.ev[:DEFENSE] = 94
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 168
	pkmn2.tera_type = :FAIRY
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:ARCTOZOLT,5)
	pkmn3.item = :HEAVYDUTYBOOTS
	pkmn3.ability_index = 0 # SLUSHRUSH
	pkmn3.nature = :ADAMANT
	pkmn3.learn_move(:SPARK)
	pkmn3.learn_move(:EGGBOMB)
	pkmn3.learn_move(:AURORAVEIL)
	pkmn3.learn_move(:SUBSTITUTE)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :WATER
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:GLALIE,5)
	pkmn4.item = :MEGAITE
	pkmn4.ability_index = 0 # LEVITATE
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:FAKEOUT)
	pkmn4.learn_move(:HEADSMASH)
	pkmn4.learn_move(:EXTREMESPEED)
	pkmn4.learn_move(:VICTORYDANCE)
	pkmn4.ev[:HP] = 80
	pkmn4.ev[:ATTACK] = 0
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 252
	pkmn4.ev[:SPEED] = 180
	pkmn4.tera_type = :PSYCHIC
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:CLEFABLE,5)
	pkmn5.item = :LIFEORB
	pkmn5.ability_index = 2 # MAGICGUARD
	pkmn5.nature = :BOLD
	pkmn5.learn_move(:TRIATTACK)
	pkmn5.learn_move(:FLAMETHROWER)
	pkmn5.learn_move(:QUIVERDANCE)
	pkmn5.learn_move(:SOFTBOILED)
	pkmn5.ev[:HP] = 252
	pkmn5.ev[:ATTACK] = 0
	pkmn5.ev[:DEFENSE] = 132
	pkmn5.ev[:SPECIAL_DEFENSE] = 64
	pkmn5.ev[:SPEED] = 64
	pkmn5.tera_type = :POISON
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:BEARTIC,5)
	pkmn6.item = :LEFTOVERS
	pkmn6.ability_index = 5 # DAMP
	pkmn6.nature = :ADAMANT
	pkmn6.learn_move(:VICTORYDANCE)
	pkmn6.learn_move(:SUBSTITUTE)
	pkmn6.learn_move(:ICICLECRASH)
	pkmn6.learn_move(:BODYSLAM)
	pkmn6.ev[:HP] = 132
	pkmn6.ev[:ATTACK] = 252
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 128
	pkmn6.tera_type = :GROUND
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedUtimatePartyQuickStart5 # Custom Team, mirror match of Dani, the Mono Stellar Type Master
	pkmn1 = Pokemon.new(:MEWTWO,5)
	pkmn1.item = :MEGAITEX
	pkmn1.ability_index = 3 # INTIMIDATE
	pkmn1.nature = :JOLLY
	pkmn1.learn_move(:PSYCHOCUT)
	pkmn1.learn_move(:VICTORYDANCE)
	pkmn1.learn_move(:DRAINPUNCH)
	pkmn1.learn_move(:SHEERCOLD)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 112
	pkmn1.ev[:DEFENSE] = 144
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :FIRE
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:MEW,5)
	pkmn2.item = :MEWNIUMZ
	pkmn2.ability_index = 5 # UNAWARE
	pkmn2.nature = :TIMID
	pkmn2.learn_move(:LUSTERPURGE)
	pkmn2.learn_move(:ECHOEDVOICE)
	pkmn2.learn_move(:WILLOWISP)
	pkmn2.learn_move(:QUIVERDANCE)
	pkmn2.ev[:HP] = 240
	pkmn2.ev[:ATTACK] = 52
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 220
	pkmn2.tera_type = :ICE
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:TERAPAGOS,5)
	pkmn3.item = :WHITEHERB
	pkmn3.nature = :BOLD
	pkmn3.learn_move(:NORETREAT)
	pkmn3.learn_move(:SHELLSMASH)
	pkmn3.learn_move(:TAUNT)
	pkmn3.learn_move(:TERASTARSTORM)
	pkmn3.ev[:HP] = 172
	pkmn3.ev[:ATTACK] = 68
	pkmn3.ev[:DEFENSE] = 204
	pkmn3.ev[:SPECIAL_DEFENSE] = 12
	pkmn3.ev[:SPEED] = 56
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:TYPENULL,5)
	pkmn4.item = :EVIOLITE
	pkmn4.ability_index = 0 # BATTLEARMOR
	pkmn4.nature = :CALM
	pkmn4.learn_move(:SALTCURE)
	pkmn4.learn_move(:REST)
	pkmn4.learn_move(:SAPPYSEED)
	pkmn4.learn_move(:BIND)
	pkmn4.ev[:HP] = 252
	pkmn4.ev[:ATTACK] = 0
	pkmn4.ev[:DEFENSE] = 252
	pkmn4.ev[:SPECIAL_DEFENSE] = 8
	pkmn4.ev[:SPEED] = 0
	#pkmn4.dynamax_able = false # Due to crashing issues from 2.0.0, Type Null cannot Dynamax at all
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:ARCEUS_17,5) # Tweaks to the Legend Plate mean Arceus's forms are obtainable without holding the type plates. Dark Form is chosen for Prankster Immunity, before the Legend Plate kicks in 
	pkmn5.item = :LEGENDPLATE # Changes Arceus to any optimal offense type when it uses Judgement
	pkmn5.ability_index = 0 # MULTITYPE
	pkmn5.nature = :MODEST
	pkmn5.learn_move(:JUDGMENT)
	pkmn5.learn_move(:NORETREAT)
	pkmn5.learn_move(:BATONPASS)
	pkmn5.learn_move(:TAUNT)
	pkmn5.ev[:HP] = 116
	pkmn5.ev[:ATTACK] = 116
	pkmn5.ev[:DEFENSE] = 76
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 204
	pkmn5.tera_type = :POISON
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:UNOWN,5)
	pkmn6.item = :TERRAINEXTENDER
	pkmn6.ability_index = 1 # PUREPOWER
	pkmn6.nature = :TIMID
	pkmn6.learn_move(:EXPANDINGFORCE)
	pkmn6.learn_move(:EARTHPOWER)
	pkmn6.learn_move(:ROAROFTIME)
	pkmn6.learn_move(:AEROBLAST)
	pkmn6.ev[:HP] = 12
	pkmn6.ev[:ATTACK] = 68
	pkmn6.ev[:DEFENSE] = 204
	pkmn6.ev[:SPECIAL_DEFENSE] = 56
	pkmn6.ev[:SPEED] = 172
	pkmn6.tera_type = :PSYCHIC
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

#===============================================================================
# Lvl.30 (Gen 1 to Gen 9 Pokemon Teams, this exists to allow playtesters to have Optimised teams,
# without wasting time setting up a fully trained competitive teams. It also serves to truly poke 
# and prod the 435 trainers of battle mode, in order to identify tedious filler text, and potential 
# bugs and crashes, rather than just sticking to the stock Metagame teams)
#===============================================================================
def pbOptimisedGen1GrassPartyQuickStart30 # Poke Paste: https://pokepast.es/796bf2bd36e89d42
	pkmn1 = Pokemon.new(:NINETALES,30)
	pkmn1.item = :HEATROCK
	pkmn1.ability_index = 0 # DROUGHT
	pkmn1.nature = :TIMID
	pkmn1.learn_move(:FLAMETHROWER)
	pkmn1.learn_move(:ENCORE)
	pkmn1.learn_move(:HEALINGWISH)
	pkmn1.learn_move(:WILLOWISP)
	pkmn1.ev[:HP] = 248
	pkmn1.ev[:ATTACK] = 0 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn1.ev[:DEFENSE] = 20
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 244
	pkmn1.tera_type = :GHOST
	pkmn1.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:CERULEDGE,30)
	pkmn2.item = :FOCUSSASH
	pkmn2.ability_index = 2 # WEAKARMOR
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:SWORDSDANCE)
	pkmn2.learn_move(:BITTERBLADE)
	pkmn2.learn_move(:SOLARBLADE)
	pkmn2.learn_move(:TERABLAST)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :FAIRY
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:VENUSAUR,30)
	pkmn3.item = :LIFEORB
	pkmn3.ability_index = 3 # CHLOROPHYLL
	pkmn3.nature = :MODEST
	pkmn3.learn_move(:GROWTH)
	pkmn3.learn_move(:GIGADRAIN)
	pkmn3.learn_move(:SLUDGEBOMB)
	pkmn3.learn_move(:WEATHERBALL)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 252
	pkmn3.ev[:DEFENSE] = 4
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :FIRE
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:HATTERENE,30)
	pkmn4.item = :EJECTBUTTON
	pkmn4.ability_index = 0 # MAGICBOUNCE
	pkmn4.nature = :BOLD
	pkmn4.learn_move(:HEALINGWISH)
	pkmn4.learn_move(:PSYCHICNOISE)
	pkmn4.learn_move(:DAZZLINGGLEAM)
	pkmn4.learn_move(:NUZZLE)
	pkmn4.ev[:HP] = 256
	pkmn4.ev[:ATTACK] = 0
	pkmn4.ev[:DEFENSE] = 176
	pkmn4.ev[:SPECIAL_DEFENSE] = 72
	pkmn4.ev[:SPEED] = 8
	pkmn4.tera_type = :STEEL
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:GREATTUSK,30)
	pkmn5.item = :ROCKYHELMET
	pkmn5.ability_index = 0 # PROTOSYNTHESIS
	pkmn5.nature = :JOLLY
	pkmn5.learn_move(:HEADLONGRUSH)
	pkmn5.learn_move(:ICESPINNER)
	pkmn5.learn_move(:RAPIDSPIN)
	pkmn5.learn_move(:STEALTHROCK)
	pkmn5.ev[:HP] = 252
	pkmn5.ev[:ATTACK] = 4
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :FIRE
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:WALKINGWAKE,30)
	pkmn6.item = :CHOICESPECS
	pkmn6.ability_index = 0 # PROTOSYNTHESIS
	pkmn6.nature = :MODEST
	pkmn6.learn_move(:HYDROSTEAM)
	pkmn6.learn_move(:DRACOMETEOR)
	pkmn6.learn_move(:FLAMETHROWER)
	pkmn6.learn_move(:DRAGONPULSE)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.tera_type = :WATER
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen1FirePartyQuickStart30 # Poke Paste: https://pokepast.es/e4bf2a1d848e8146
	pkmn1 = Pokemon.new(:CHARIZARD,30)
	pkmn1.item = :CHOICESPECS
	pkmn1.ability_index = 3 # SOLARPOWER
	pkmn1.nature = :TIMID
	pkmn1.learn_move(:HEATWAVE)
	pkmn1.learn_move(:OVERHEAT)
	pkmn1.learn_move(:WEATHERBALL)
	pkmn1.learn_move(:AEROBLAST)
	pkmn1.ev[:HP] = 0 # For IV's they can be set to 31 or 0 on the Info Summary Option Screen.
	pkmn1.ev[:ATTACK] = 256 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :GHOST
	pkmn1.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:TORKOAL,30)
	pkmn2.item = :EJECTPACK
	pkmn2.ability_index = 2 # DROUGHT
	pkmn2.nature = :QUIET
	pkmn2.learn_move(:ERUPTION)
	pkmn2.learn_move(:OVERHEAT)
	pkmn2.learn_move(:HELPINGHAND)
	pkmn2.learn_move(:PROTECT)
	pkmn2.ev[:HP] = 176
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 72
	pkmn2.ev[:SPEED] = 0
	pkmn2.tera_type = :FIRE
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:PORYGON2,30)
	pkmn3.item = :EVIOLITE
	pkmn3.ability_index = 0 # ANALYTIC
	pkmn3.nature = :BOLD
	pkmn3.learn_move(:ICEBEAM)
	pkmn3.learn_move(:EGGBOMB)
	pkmn3.learn_move(:TRICKROOM)
	pkmn3.learn_move(:RECOVER)
	pkmn3.ev[:HP] = 256
	pkmn3.ev[:ATTACK] = 8
	pkmn3.ev[:DEFENSE] = 176
	pkmn3.ev[:SPECIAL_DEFENSE] = 72
	pkmn3.ev[:SPEED] = 0
	pkmn3.tera_type = :FIGHTING
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:INCINEROAR,30)
	pkmn4.item = :HONEY
	pkmn4.ability_index = 0 # INTIMIDATE
	pkmn4.nature = :CAREFUL
	pkmn4.learn_move(:FLAREBLITZ)
	pkmn4.learn_move(:KNOCKOFF)
	pkmn4.learn_move(:FAKEOUT)
	pkmn4.learn_move(:PARTINGSHOT)
	pkmn4.ev[:HP] = 248
	pkmn4.ev[:ATTACK] = 0
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 212
	pkmn4.ev[:SPEED] = 52
	pkmn4.tera_type = :DRAGON
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:JUMPLUFF,30)
	pkmn5.item = :COVERTCLOAK
	pkmn5.ability_index = 2 # CHLOROPHYLL
	pkmn5.nature = :JOLLY
	pkmn5.learn_move(:EGGBOMB)
	pkmn5.learn_move(:SUNNYDAY)
	pkmn5.learn_move(:RAGEPOWDER)
	pkmn5.learn_move(:TAILWIND)
	pkmn5.ev[:HP] = 256
	pkmn5.ev[:ATTACK] = 0
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :WATER
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:URSALUNA,30)
	pkmn6.item = :FLAMEORB
	pkmn6.ability_index = 0 # GUTS
	pkmn6.nature = :BRAVE
	pkmn6.learn_move(:FACADE)
	pkmn6.learn_move(:HEADLONGRUSH)
	pkmn6.learn_move(:FIREPUNCH)
	pkmn6.learn_move(:PROTECT)
	pkmn6.ev[:HP] = 140
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 44
	pkmn6.ev[:SPECIAL_DEFENSE] = 68
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :FAIRY
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen1WaterPartyQuickStart30 # Poke Paste: https://pokepast.es/18734f48aa3bb354
	pkmn1 = Pokemon.new(:BASCULEGION,30)
	pkmn1.item = :LIFEORB
	pkmn1.ability_index = 5 # SWIFTSWIM
	pkmn1.nature = :ADAMANT
	pkmn1.learn_move(:LASTRESPECTS)
	pkmn1.learn_move(:WAVECRASH)
	pkmn1.learn_move(:AQUAJET)
	pkmn1.learn_move(:PROTECT)
	pkmn1.ev[:HP] = 28 # For IV's they can be set to 31 or 0 on the Info Summary Option Screen.
	pkmn1.ev[:ATTACK] = 220 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn1.ev[:DEFENSE] = 124
	pkmn1.ev[:SPECIAL_DEFENSE] = 4
	pkmn1.ev[:SPEED] = 136
	pkmn1.tera_type = :WATER
	pkmn1.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:BLASTOISE,30)
	pkmn2.item = :WHITEHERB
	pkmn2.ability_index = 2 # STORMDRAIN
	pkmn2.nature = :CALM
	pkmn2.learn_move(:FAKEOUT)
	pkmn2.learn_move(:BUBBLEBEAM)
	pkmn2.learn_move(:EGGBOMB)
	pkmn2.learn_move(:SHELLSMASH)
	pkmn2.ev[:HP] = 228
	pkmn2.ev[:ATTACK] = 192
	pkmn2.ev[:DEFENSE] = 12
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 80
	pkmn2.tera_type = :DRAGON
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:INCINEROAR,30)
	pkmn3.item = :HONEY
	pkmn3.ability_index = 0 # INTIMIDATE
	pkmn3.nature = :IMPISH
	pkmn3.learn_move(:FAKEOUT)
	pkmn3.learn_move(:DARKESTLARIAT)
	pkmn3.learn_move(:UTURN)
	pkmn3.learn_move(:FLAREBLITZ)
	pkmn3.ev[:HP] = 248
	pkmn3.ev[:ATTACK] = 4
	pkmn3.ev[:DEFENSE] = 188
	pkmn3.ev[:SPECIAL_DEFENSE] = 68
	pkmn3.ev[:SPEED] = 4
	pkmn3.tera_type = :BUG
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:PELIPPER,30)
	pkmn4.item = :FOCUSSASH
	pkmn4.ability_index = 0 # DRIZZLE
	pkmn4.nature = :MODEST
	pkmn4.learn_move(:HURRICANE)
	pkmn4.learn_move(:ICYWIND)
	pkmn4.learn_move(:TAILWIND)
	pkmn4.learn_move(:RAINDANCE)
	pkmn4.ev[:HP] = 4
	pkmn4.ev[:ATTACK] = 252
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :GROUND
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:URSALUNA_1,30)
	pkmn5.item = :CHOICESPECS
	pkmn5.ability_index = 0 # MINDSEYE
	pkmn5.nature = :MODEST
	pkmn5.learn_move(:HYPERVOICE)
	pkmn5.learn_move(:EARTHPOWER)
	pkmn5.learn_move(:SNARL)
	pkmn5.learn_move(:MOONBLAST)
	pkmn5.ev[:HP] = 256
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 0
	pkmn5.tera_type = :GHOST
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:OVERQWIL,30)
	pkmn6.item = :SAFETYGOGGLES
	pkmn6.ability_index = 3 # WATERBUBBLE
	pkmn6.nature = :JOLLY
	pkmn6.learn_move(:GUNKSHOT)
	pkmn6.learn_move(:EGGBOMB)
	pkmn6.learn_move(:ACIDSPRAY)
	pkmn6.learn_move(:LIQUIDATION)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.tera_type = :FLYING
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen1ElectricPartyQuickStart30 # Poke Paste: https://pokepast.es/1cd570d0b5e4d125
	pkmn1 = Pokemon.new(:CHARIZARD,30)
	pkmn1.item = :LIFEORB
	pkmn1.ability_index = 3 # SOLARPOWER
	pkmn1.nature = :TIMID
	pkmn1.learn_move(:FLAMETHROWER)
	pkmn1.learn_move(:AEROBLAST)
	pkmn1.learn_move(:SCORCHINGSANDS)
	pkmn1.learn_move(:PROTECT)
	pkmn1.ev[:HP] = 0 # For IV's they can be set to 31 or 0 on the Info Summary Option Screen.
	pkmn1.ev[:ATTACK] = 256 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :FIRE
	pkmn1.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:RAICHU,30)
	pkmn2.item = :FOCUSSASH
	pkmn2.ability_index = 0 # LIGHTNINGROD
	pkmn2.nature = :TIMID
	pkmn2.learn_move(:FAKEOUT)
	pkmn2.learn_move(:ENCORE)
	pkmn2.learn_move(:VOLTSWITCH)
	pkmn2.learn_move(:ENDEAVOR)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :FLYING
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:TORKOAL,30)
	pkmn3.item = :ASSAULTVEST
	pkmn3.ability_index = 2 # DROUGHT
	pkmn3.nature = :MODEST
	pkmn3.learn_move(:HEATWAVE)
	pkmn3.learn_move(:FLAMETHROWER)
	pkmn3.learn_move(:SOLARBEAM)
	pkmn3.learn_move(:CLEARSMOG)
	pkmn3.ev[:HP] = 208
	pkmn3.ev[:ATTACK] = 140
	pkmn3.ev[:DEFENSE] = 164
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 0
	pkmn3.tera_type = :GRASS
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:GASTRODON,30)
	pkmn4.item = :HONEY
	pkmn4.ability_index = 4 # STORMDRAIN
	pkmn4.nature = :BOLD
	pkmn4.learn_move(:EARTHPOWER)
	pkmn4.learn_move(:WEATHERBALL)
	pkmn4.learn_move(:YAWN)
	pkmn4.learn_move(:PROTECT)
	pkmn4.ev[:HP] = 256
	pkmn4.ev[:ATTACK] = 92
	pkmn4.ev[:DEFENSE] = 88
	pkmn4.ev[:SPECIAL_DEFENSE] = 76
	pkmn4.ev[:SPEED] = 0
	pkmn4.tera_type = :FIRE
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:TALONFLAME,30)
	pkmn5.item = :SAFETYGOGGLES
	pkmn5.ability_index = 0 # GALEWINGS
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:WILLOWISP)
	pkmn5.learn_move(:AIRSLASH)
	pkmn5.learn_move(:TAILWIND)
	pkmn5.learn_move(:TAUNT)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 252
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 64
	pkmn5.tera_type = :GHOST
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:TSAREENA,30)
	pkmn6.item = :ZOOMLENS
	pkmn6.ability_index = 0 # QUEENLYMAJESTY
	pkmn6.nature = :JOLLY
	pkmn6.learn_move(:POWERWHIP)
	pkmn6.learn_move(:MEGAKICK)
	pkmn6.learn_move(:TRIPLEAXEL)
	pkmn6.learn_move(:PROTECT)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.tera_type = :WATER
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen1FairyPartyQuickStart30 # Poke Paste: https://pokepast.es/5f79ccf1b3607ea3
	pkmn1 = Pokemon.new(:BLISSEY,30)
	pkmn1.item = :HEAVYDUTYBOOTS 
	pkmn1.ability_index = 4 # NATURALCURE 
	pkmn1.nature = :CALM
	pkmn1.learn_move(:CALMMIND)
	pkmn1.learn_move(:FLAMETHROWER)
	pkmn1.learn_move(:SEISMICTOSS)
	pkmn1.learn_move(:SOFTBOILED)
	pkmn1.ev[:HP] = 0 # For IV's they can be set to 31 or 0 on the Info Summary Option Screen.
	pkmn1.ev[:ATTACK] = 0 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn1.ev[:DEFENSE] = 256
	pkmn1.ev[:SPECIAL_DEFENSE] = 256
	pkmn1.ev[:SPEED] = 0
	pkmn1.tera_type = :DARK
	pkmn1.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:CLEFABLE,30)
	pkmn2.item = :STICKYBARB
	pkmn2.ability_index = 2 # MAGICGUARD
	pkmn2.nature = :BOLD
	pkmn2.learn_move(:KNOCKOFF)
	pkmn2.learn_move(:MOONBLAST)
	pkmn2.learn_move(:MOONLIGHT)
	pkmn2.learn_move(:WISH)
	pkmn2.ev[:HP] = 252
	pkmn2.ev[:ATTACK] = 0
	pkmn2.ev[:DEFENSE] = 252
	pkmn2.ev[:SPECIAL_DEFENSE] = 8
	pkmn2.ev[:SPEED] = 0
	pkmn2.tera_type = :STEEL
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:GLISCOR,30)
	pkmn3.item = :MENTALHERB
	pkmn3.ability_index = 3 # LEVITATE
	pkmn3.nature = :IMPISH
	pkmn3.learn_move(:RUINATION)
	pkmn3.learn_move(:TOXIC)
	pkmn3.learn_move(:SPIKES)
	pkmn3.learn_move(:PROTECT)
	pkmn3.ev[:HP] = 252
	pkmn3.ev[:ATTACK] = 0
	pkmn3.ev[:DEFENSE] = 252
	pkmn3.ev[:SPECIAL_DEFENSE] = 8
	pkmn3.ev[:SPEED] = 0
	pkmn3.tera_type = :ELECTRIC
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:TINGLU,30)
	pkmn4.item = :REDCARD
	pkmn4.ability_index = 0 # VESSELOFRUIN
	pkmn4.nature = :CAREFUL
	pkmn4.learn_move(:STEALTHROCK)
	pkmn4.learn_move(:EARTHQUAKE)
	pkmn4.learn_move(:REST)
	pkmn4.learn_move(:PROTECT)
	pkmn4.ev[:HP] = 252
	pkmn4.ev[:ATTACK] = 0
	pkmn4.ev[:DEFENSE] = 8
	pkmn4.ev[:SPECIAL_DEFENSE] = 252
	pkmn4.ev[:SPEED] = 0
	pkmn4.tera_type = :GHOST
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:DONDOZO,30)
	pkmn5.item = :CHESTOBERRY
	pkmn5.ability_index = 0 # UNAWARE
	pkmn5.nature = :IMPISH
	pkmn5.learn_move(:EGGBOMB)
	pkmn5.learn_move(:CURSE)
	pkmn5.learn_move(:BODYPRESS)
	pkmn5.learn_move(:REST)
	pkmn5.ev[:HP] = 256
	pkmn5.ev[:ATTACK] = 0
	pkmn5.ev[:DEFENSE] = 256
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 0
	pkmn5.tera_type = :FIGHTING
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:AMOONGUSS,30)
	pkmn6.item = :HONEY
	pkmn6.ability_index = 3 # REGENERATOR
	pkmn6.nature = :RELAXED
	pkmn6.learn_move(:TOXIC)
	pkmn6.learn_move(:FOULPLAY)
	pkmn6.learn_move(:STRENGTHSAP) # This is one of the universal Move Type Moves for Grass types. I do not care what specfic Pokemon get the universal type moves. I refuse to manually edit the Level Up/Tutor/Egg Moves of all 1025+ Pokemon. It's a waste of time, and not once in any Pokemon game have I liked any Pokemon's natural Level Up Movepool 
	pkmn6.learn_move(:CUT) # This is one of the universal Move Type Moves for Grass types. 
	pkmn6.ev[:HP] = 252
	pkmn6.ev[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 252
	pkmn6.ev[:SPECIAL_DEFENSE] = 8
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :STEEL
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen1NormalPartyQuickStart30 # Team Craft Info: https://www.smogon.com/forums/threads/the-infamous-evopass-a-sm-ubers-rmt.3591806/
	pkmn1 = Pokemon.new(:MEW,30)
	pkmn1.item = :FOCUSSASH
	pkmn1.ability_index = 3 # PRANKSTER 
	pkmn1.nature = :JOLLY
	pkmn1.learn_move(:TAUNT)
	pkmn1.learn_move(:TAILWIND)
	pkmn1.learn_move(:GRAVITY)
	pkmn1.learn_move(:EXPLOSION)
	pkmn1.ev[:HP] = 8 # For IV's they can be set to 31 or 0 on the Info Summary Option Screen.
	pkmn1.ev[:ATTACK] = 84 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn1.ev[:DEFENSE] = 164
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :STEEL
	pkmn1.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:EEVEE,30)
	pkmn2.item = :EEVIUMZ
	pkmn2.ability_index = 6 # SIMPLE 
	pkmn2.nature = :HARDY # A netural nature is used, because Eevee's job in this team is to send it's Evo boosts to it's teammates
	pkmn2.learn_move(:LASTRESORT)
	pkmn2.learn_move(:BATONPASS)
	pkmn2.learn_move(:TAUNT) # All 1025+ Pokemon Evolution lines have had their movepools fused together, via Egg Move links and Ultimate Move Tutor. Eevee and it's evolutions as a result, learn all each other's moves, such as Sappy Seed. This is the case for all Pokemon Evolution lines, and stacks on top of the universal type moves and VGC Starter moves. If using the Sleep Status, replace Taunt with Sing. SY uses the Drowzy status, due to Sleep's nature being highly abusable at the highest level
	pkmn2.learn_move(:SUBSTITUTE)
	pkmn2.ev[:HP] = 240 # For IV's they can be set to 31 or 0 on the Info Summary Option Screen.
	pkmn2.ev[:ATTACK] = 0 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn2.ev[:DEFENSE] = 36
	pkmn2.ev[:SPECIAL_DEFENSE] = 16
	pkmn2.ev[:SPEED] = 220
	pkmn2.tera_type = :GHOST
	pkmn2.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:ESPEON,30)
	pkmn3.item = :LEFTOVERS
	pkmn3.ability_index = 0 # MAGICBOUNCE
	pkmn3.nature = :BOLD
	pkmn3.learn_move(:DAZZLINGGLEAM)
	pkmn3.learn_move(:STOREDPOWER)
	pkmn3.learn_move(:CALMMIND)
	pkmn3.learn_move(:BATONPASS)
	pkmn3.ev[:HP] = 248
	pkmn3.ev[:ATTACK] = 12
	pkmn3.ev[:DEFENSE] = 252
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 0
	pkmn3.tera_type = :ELECTRIC
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:KROOKODILE,30)
	pkmn4.item = :CHOICEBAND
	pkmn4.ability_index = 0 # MOXIE
	pkmn4.nature = :ADAMANT
	pkmn4.learn_move(:POWERTRIP)
	pkmn4.learn_move(:BEATUP)
	pkmn4.learn_move(:PURSUIT)
	pkmn4.learn_move(:BODYSLAM)
	pkmn4.ev[:HP] = 112
	pkmn4.ev[:ATTACK] = 252
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 148
	pkmn4.tera_type = :POISON
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:ARCEUS_17,30) # Tweaks to the Legend Plate mean Arceus's forms are obtainable without holding the type plates. Dark Form is chosen for Prankster Immunity, before the Legend Plate kicks in 
	pkmn5.item = :LEGENDPLATE # Changes Arceus to any optimal offense type when it uses Judgement
	pkmn5.ability_index = 0 # MULTITYPE
	pkmn5.nature = :MODEST
	pkmn5.learn_move(:JUDGMENT)
	pkmn5.learn_move(:NORETREAT)
	pkmn5.learn_move(:BATONPASS)
	pkmn5.learn_move(:TAUNT)
	pkmn5.ev[:HP] = 116
	pkmn5.ev[:ATTACK] = 116
	pkmn5.ev[:DEFENSE] = 76
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 204
	pkmn5.tera_type = :STELLAR
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:DITTO,30)
	pkmn6.item = :CHOICESCARF
	pkmn6.ability_index = 4 # IMPOSTER
	pkmn6.nature = :RELAXED # This nature + the below EV Spread ensures 4 Struggle uses and minimum Struggle damage from opponent Ditto. Slowest speed stops user's Ditto from kicking in first, allowing transformed Ditto to have more PP.
	pkmn6.learn_move(:TRANSFORM)
	pkmn6.ev[:HP] = 256 # For IV's, they can be set to 31 or 0 on the Info Summary Option Screen.
	pkmn6.ev[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 256
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :FAIRY
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen2GrassPartyQuickStart30 # Poke Paste: https://pokepast.es/bf868cdeb163a7c9
	pkmn1 = Pokemon.new(:MEGANIUM,30)
	pkmn1.item = :POWERHERB
	pkmn1.ability_index = 2 # THICKFAT
	pkmn1.nature = :BOLD
	pkmn1.learn_move(:GEOMANCY)
	pkmn1.learn_move(:LEECHSEED)
	pkmn1.learn_move(:DRAGONTAIL)
	pkmn1.learn_move(:LUNARBLESSING)
	pkmn1.ev[:HP] = 252
	pkmn1.ev[:ATTACK] = 0 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn1.ev[:DEFENSE] = 8
	pkmn1.ev[:SPECIAL_DEFENSE] = 252
	pkmn1.ev[:SPEED] = 0
	pkmn1.tera_type = :POISON
	pkmn1.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:LILLIGANT_1,30)
	pkmn2.item = :FOCUSSASH
	pkmn2.ability_index = 1 # CHLOROPHYLL
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:AFTERYOU)
	pkmn2.learn_move(:LEAFBLADE)
	pkmn2.learn_move(:EGGBOMB)
	pkmn2.learn_move(:STUNSPORE)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :FIRE
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:DRAGAPULT,30)
	pkmn3.item = :LIFEORB
	pkmn3.ability_index = 5 # CLEARBODY
	pkmn3.nature = :JOLLY
	pkmn3.learn_move(:DRAGONDARTS)
	pkmn3.learn_move(:SHADOWFORCE)
	pkmn3.learn_move(:TERABLAST)
	pkmn3.learn_move(:PROTECT)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :FIGHTING
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:TORKOAL,30)
	pkmn4.item = :CHOICESPECS
	pkmn4.ability_index = 2 # DROUGHT
	pkmn4.nature = :MODEST
	pkmn4.learn_move(:ERUPTION)
	pkmn4.learn_move(:HEATWAVE)
	pkmn4.learn_move(:SOLARBEAM)
	pkmn4.learn_move(:EARTHPOWER)
	pkmn4.ev[:HP] = 256
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 0
	pkmn4.tera_type = :FLYING
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:TYPHLOSION_1,30)
	pkmn5.item = :CHOICESCARF
	pkmn5.ability_index = 0 # SOULHEART
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:ERUPTION)
	pkmn5.learn_move(:HEATWAVE)
	pkmn5.learn_move(:FLAMETHROWER)
	pkmn5.learn_move(:EGGBOMB)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :GRASS
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:WEEZING_1,30)
	pkmn6.item = :HONEY
	pkmn6.ability_index = 2 # NEUTRALIZINGGAS
	pkmn6.nature = :CALM
	pkmn6.learn_move(:TAUNT)
	pkmn6.learn_move(:WILLOWISP)
	pkmn6.learn_move(:STRANGESTEAM)
	pkmn6.learn_move(:PROTECT)
	pkmn6.ev[:HP] = 256
	pkmn6.ev[:ATTACK] = 4
	pkmn6.ev[:DEFENSE] = 52
	pkmn6.ev[:SPECIAL_DEFENSE] = 156
	pkmn6.ev[:SPEED] = 44
	pkmn6.tera_type = :DARK
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen2FirePartyQuickStart30 # Poke Paste: https://pokepast.es/0048bf1a01a173c2
	pkmn1 = Pokemon.new(:TYPHLOSION,30)
	pkmn1.item = :CHOICESPECS
	pkmn1.ability_index = 0 # SOULHEART
	pkmn1.nature = :TIMID
	pkmn1.learn_move(:ERUPTION)
	pkmn1.learn_move(:HEATWAVE)
	pkmn1.learn_move(:FOCUSBLAST)
	pkmn1.learn_move(:EGGBOMB)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :GRASS
	pkmn1.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:HITMONTOP,30)
	pkmn2.item = :ROCKYHELMET
	pkmn2.ability_index = 4 # INTIMIDATE
	pkmn2.nature = :ADAMANT
	pkmn2.learn_move(:FAKEOUT)
	pkmn2.learn_move(:REVENGE)
	pkmn2.learn_move(:WIDEGUARD)
	pkmn2.learn_move(:COACHING)
	pkmn2.ev[:HP] = 252
	pkmn2.ev[:ATTACK] = 56
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 204
	pkmn2.tera_type = :GROUND
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:DRAGONITE,30)
	pkmn3.item = :LOADEDDICE
	pkmn3.ability_index = 2 # INNERFOCUS
	pkmn3.nature = :ADAMANT
	pkmn3.learn_move(:SCALESHOT)
	pkmn3.learn_move(:DRAGONCHEER)
	pkmn3.learn_move(:TAILWIND)
	pkmn3.learn_move(:PROTECT)
	pkmn3.ev[:HP] = 196
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 4
	pkmn3.ev[:SPECIAL_DEFENSE] = 4
	pkmn3.ev[:SPEED] = 52
	pkmn3.tera_type = :FAIRY
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:DRAGAPULT,30)
	pkmn4.item = :CHOICEBAND
	pkmn4.ability_index = 5 # CLEARBODY
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:DRAGONDARTS)
	pkmn4.learn_move(:SHADOWFORCE)
	pkmn4.learn_move(:SUCKERPUNCH)
	pkmn4.learn_move(:UTURN)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :DRAGON
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:TORKOAL,30)
	pkmn5.item = :LIFEORB
	pkmn5.ability_index = 2 # DROUGHT
	pkmn5.nature = :MODEST
	pkmn5.learn_move(:HEATWAVE)
	pkmn5.learn_move(:CLEARSMOG)
	pkmn5.learn_move(:HELPINGHAND)
	pkmn5.learn_move(:PROTECT)
	pkmn5.ev[:HP] = 176
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 72
	pkmn5.ev[:SPEED] = 0
	pkmn5.tera_type = :FIRE
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:WHIMSICOTT,30)
	pkmn6.item = :COVERTCLOAK
	pkmn6.ability_index = 0 # Prankster
	pkmn6.nature = :TIMID
	pkmn6.learn_move(:MOONBLAST)
	pkmn6.learn_move(:TAILWIND)
	pkmn6.learn_move(:TRICKROOM)
	pkmn6.learn_move(:SUNNYDAY)
	pkmn6.ev[:HP] = 180
	pkmn6.iv[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 4
	pkmn6.ev[:SPECIAL_DEFENSE] = 108
	pkmn6.ev[:SPEED] = 220
	pkmn6.tera_type = :WATER
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen2WaterPartyQuickStart30 # Poke Paste: https://pokepast.es/7bd4be45d6b25451
	pkmn1 = Pokemon.new(:FERALIGATR,30)
	pkmn1.item = :LIFEORB
	pkmn1.ability_index = 0 # SHEERFORCE
	pkmn1.nature = :JOLLY
	pkmn1.learn_move(:LIQUIDATION)
	pkmn1.learn_move(:CRUNCH)
	pkmn1.learn_move(:DRAGONDANCE)
	pkmn1.learn_move(:PROTECT)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :DARK
	pkmn1.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:KOMMOO,30)
	pkmn2.item = :THROATSPRAY
	pkmn2.ability_index = 0 # MULTISCALE
	pkmn2.nature = :TIMID
	pkmn2.learn_move(:EGGBOMB)
	pkmn2.learn_move(:AURASPHERE)
	pkmn2.learn_move(:CLANGOROUSSOUL)
	pkmn2.learn_move(:PROTECT)
	pkmn2.ev[:HP] = 136
	pkmn2.ev[:ATTACK] = 204
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 172
	pkmn2.tera_type = :POISON
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:POLITOED,30)
	pkmn3.item = :HONEY
	pkmn3.ability_index = 4 # DRIZZLE
	pkmn3.nature = :BOLD
	pkmn3.learn_move(:WEATHERBALL)
	pkmn3.learn_move(:ICYWIND)
	pkmn3.learn_move(:HAZE)
	pkmn3.learn_move(:PROTECT)
	pkmn3.ev[:HP] = 256
	pkmn3.ev[:ATTACK] = 0
	pkmn3.ev[:DEFENSE] = 184
	pkmn3.ev[:SPECIAL_DEFENSE] = 72
	pkmn3.ev[:SPEED] = 0
	pkmn3.tera_type = :GRASS
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:RILLABOOM,30)
	pkmn4.item = :ASSAULTVEST
	pkmn4.ability_index = 0 # GRASSYSURGE
	pkmn4.nature = :ADAMANT
	pkmn4.learn_move(:WOODHAMMER)
	pkmn4.learn_move(:GRASSYGLIDE)
	pkmn4.learn_move(:FAKEOUT)
	pkmn4.learn_move(:UTURN)
	pkmn4.ev[:HP] = 204
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 52
	pkmn4.tera_type = :FIRE
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:INCINEROAR,30)
	pkmn5.item = :SAFETYGOGGLES
	pkmn5.ability_index = 0 # Intimidate
	pkmn5.nature = :CAREFUL
	pkmn5.learn_move(:FAKEOUT)
	pkmn5.learn_move(:PARTINGSHOT)
	pkmn5.learn_move(:TAUNT)
	pkmn5.learn_move(:KNOCKOFF)
	pkmn5.ev[:HP] = 256
	pkmn5.ev[:ATTACK] = 0
	pkmn5.ev[:DEFENSE] = 96
	pkmn5.ev[:SPECIAL_DEFENSE] = 160
	pkmn5.ev[:SPEED] = 0
	pkmn5.tera_type = :GHOST
	pkmn5.dynamax_able = false
	pkmn5.calc_stats
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:AMOONGUSS,30)
	pkmn6.item = :COVERTCLOAK
	pkmn6.ability_index = 3 # Regenerator
	pkmn6.nature = :BOLD
	pkmn6.learn_move(:PROTECT)
	pkmn6.learn_move(:RAGEPOWDER)
	pkmn6.learn_move(:SPORE)
	pkmn6.learn_move(:POLLENPUFF)
	pkmn6.ev[:HP] = 240
	pkmn6.ev[:DEFENSE] = 236
	pkmn6.ev[:SPECIAL_DEFENSE] = 36
	pkmn6.iv[:SPEED] = 27
	pkmn6.tera_type = :WATER
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen3GrassPartyQuickStart30 # Poke Paste: https://pokepast.es/6aaf2d2cce90681e
	pkmn1 = Pokemon.new(:WEEZING_1,30)
	pkmn1.item = :TERRAINEXTENDER
	pkmn1.ability_index = 4 # MISTYSURGE
	pkmn1.nature = :BOLD
	pkmn1.learn_move(:STRANGESTEAM)
	pkmn1.learn_move(:FLAMETHROWER)
	pkmn1.learn_move(:TAUNT)
	pkmn1.learn_move(:MEMENTO)
	pkmn1.ev[:HP] = 256
	pkmn1.ev[:ATTACK] = 0 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn1.ev[:DEFENSE] = 172
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 84
	pkmn1.tera_type = :STEEL
	pkmn1.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:SCEPTILE,30)
	pkmn2.item = :MISTYSEED
	pkmn2.ability_index = 5 # UNBURDEN
	pkmn2.nature = :ADAMANT
	pkmn2.learn_move(:SWORDSDANCE)
	pkmn2.learn_move(:LEAFBLADE)
	pkmn2.learn_move(:ACROBATICS)
	pkmn2.learn_move(:EGGBOMB)
	pkmn2.ev[:HP] = 240
	pkmn2.ev[:ATTACK] = 252
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 20
	pkmn2.tera_type = :ICE
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:FERALIGATR,30)
	pkmn3.item = :LIFEORB
	pkmn3.ability_index = 0 # SHEERFORCE
	pkmn3.nature = :JOLLY
	pkmn3.learn_move(:LIQUIDATION)
	pkmn3.learn_move(:CRUNCH)
	pkmn3.learn_move(:DRAGONDANCE)
	pkmn3.learn_move(:ICEPUNCH)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :WATER
	pkmn3.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:SLITHERWING,30)
	pkmn4.item = :BOOSTERENERGY
	pkmn4.ability_index = 0 # PROTOSYNTHESIS
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:VICTORYDANCE)
	pkmn4.learn_move(:LEECHLIFE)
	pkmn4.learn_move(:SUBMISSION)
	pkmn4.learn_move(:SACREDFIRE)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :FIRE
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:BISHARP,30)
	pkmn5.item = :EVIOLITE
	pkmn5.ability_index = 2 # BATTLEARMOR
	pkmn5.nature = :JOLLY
	pkmn5.learn_move(:SWORDSDANCE)
	pkmn5.learn_move(:SUCKERPUNCH)
	pkmn5.learn_move(:IRONHEAD)
	pkmn5.learn_move(:LOWKICK)
	pkmn5.ev[:HP] = 84
	pkmn5.ev[:ATTACK] = 252
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 176
	pkmn5.tera_type = :FLYING
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:NECROZMA,30)
	pkmn6.item = :ROCKYHELMET
	pkmn6.ability_index = 0 # PRISMARMOR
	pkmn6.nature = :IMPISH
	pkmn6.learn_move(:STEALTHROCK)
	pkmn6.learn_move(:MOONLIGHT)
	pkmn6.learn_move(:KNOCKOFF)
	pkmn6.learn_move(:PSYSHIELDBASH)
	pkmn6.ev[:HP] = 252
	pkmn6.iv[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 72
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 184
	pkmn6.tera_type = :FAIRY
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen3FirePartyQuickStart30 # Poke Paste: https://pokepast.es/f0391b5ee43ffe02
	pkmn1 = Pokemon.new(:DRAGONITE,30)
	pkmn1.item = :LOADEDDICE
	pkmn1.ability_index = 0 # MULTISCALE
	pkmn1.nature = :ADAMANT
	pkmn1.learn_move(:PROTECT)
	pkmn1.learn_move(:SCALESHOT)
	pkmn1.learn_move(:TAILWIND)
	pkmn1.learn_move(:STOMPINGTANTRUM)
	pkmn1.ev[:HP] = 196
	pkmn1.ev[:ATTACK] = 252 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn1.ev[:DEFENSE] = 4
	pkmn1.ev[:SPECIAL_DEFENSE] = 4
	pkmn1.ev[:SPEED] = 56
	pkmn1.tera_type = :STEEL
	pkmn1.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:BLAZIKEN,30)
	pkmn2.item = :FOCUSSASH
	pkmn2.ability_index = 6 # SPEEDBOOST
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:DETECT)
	pkmn2.learn_move(:COACHING)
	pkmn2.learn_move(:EGGBOMB)
	pkmn2.learn_move(:CLOSECOMBAT)
	pkmn2.ev[:HP] = 200
	pkmn2.ev[:ATTACK] = 68
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 244
	pkmn2.tera_type = :GRASS
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:RILLABOOM,30)
	pkmn3.item = :ASSAULTVEST
	pkmn3.ability_index = 0 # GRASSYSURGE
	pkmn3.nature = :ADAMANT
	pkmn3.learn_move(:FAKEOUT)
	pkmn3.learn_move(:DRUMBEATING)
	pkmn3.learn_move(:GRASSYGLIDE)
	pkmn3.learn_move(:UTURN)
	pkmn3.ev[:HP] = 244
	pkmn3.ev[:ATTACK] = 36 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn3.ev[:DEFENSE] = 4
	pkmn3.ev[:SPECIAL_DEFENSE] = 220
	pkmn3.ev[:SPEED] = 8
	pkmn3.tera_type = :FIRE
	pkmn3.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:KINGAMBIT,30)
	pkmn4.item = :BLACKGLASSES
	pkmn4.ability_index = 5 # DEFIANT
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:PROTECT)
	pkmn4.learn_move(:SUCKERPUNCH)
	pkmn4.learn_move(:IRONHEAD)
	pkmn4.learn_move(:KOWTOWCLEAVE)
	pkmn4.ev[:HP] = 256
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 0
	pkmn4.tera_type = :DARK
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:PRIMARINA,30)
	pkmn5.item = :THROATSPRAY
	pkmn5.ability_index = 6 # LIQUIDVOICE
	pkmn5.nature = :MODEST
	pkmn5.learn_move(:HYPERVOICE)
	pkmn5.learn_move(:MOONBLAST)
	pkmn5.learn_move(:HAZE)
	pkmn5.learn_move(:PROTECT)
	pkmn5.ev[:HP] = 240
	pkmn5.ev[:ATTACK] = 108
	pkmn5.ev[:DEFENSE] = 68
	pkmn5.ev[:SPECIAL_DEFENSE] = 12
	pkmn5.ev[:SPEED] = 84
	pkmn5.tera_type = :POISON
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:FARIGIRAF,30)
	pkmn6.item = :HONEY
	pkmn6.ability_index = 0 # ARMORTAIL
	pkmn6.nature = :CALM
	pkmn6.learn_move(:TRICKROOM)
	pkmn6.learn_move(:IMPRISON)
	pkmn6.learn_move(:TWINBEAM)
	pkmn6.learn_move(:DAZZLINGGLEAM)
	pkmn6.ev[:HP] = 232
	pkmn6.iv[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 100
	pkmn6.ev[:SPECIAL_DEFENSE] = 180
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :FAIRY
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen3WaterPartyQuickStart30 # Poke Paste: https://pokepast.es/56c33da1ecac96ae
	pkmn1 = Pokemon.new(:INCINEROAR,30)
	pkmn1.item = :ASSAULTVEST
	pkmn1.ability_index = 0 # INTIMIDATE
	pkmn1.nature = :IMPISH
	pkmn1.learn_move(:FAKEOUT)
	pkmn1.learn_move(:FLAREBLITZ)
	pkmn1.learn_move(:UTURN)
	pkmn1.learn_move(:KNOCKOFF)
	pkmn1.ev[:HP] = 256
	pkmn1.ev[:ATTACK] = 20 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn1.ev[:DEFENSE] = 156
	pkmn1.ev[:SPECIAL_DEFENSE] = 44
	pkmn1.ev[:SPEED] = 36
	pkmn1.tera_type = :WATER
	pkmn1.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:RILLABOOM,30)
	pkmn2.item = :MIRACLESEED
	pkmn2.ability_index = 0 # GRASSYSURGE
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:FAKEOUT)
	pkmn2.learn_move(:GRASSYGLIDE)
	pkmn2.learn_move(:WOODHAMMER)
	pkmn2.learn_move(:HIGHHORSEPOWER)
	pkmn2.ev[:HP] = 56
	pkmn2.ev[:ATTACK] = 116
	pkmn2.ev[:DEFENSE] = 52
	pkmn2.ev[:SPECIAL_DEFENSE] = 52
	pkmn2.ev[:SPEED] = 236
	pkmn2.tera_type = :FIRE
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:DRAGONITE,30)
	pkmn3.item = :LOADEDDICE
	pkmn3.ability_index = 0 # MULTISCALE
	pkmn3.nature = :ADAMANT
	pkmn3.learn_move(:PROTECT)
	pkmn3.learn_move(:SCALESHOT)
	pkmn3.learn_move(:TAILWIND)
	pkmn3.learn_move(:HAZE)
	pkmn3.ev[:HP] = 196
	pkmn3.ev[:ATTACK] = 252 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn3.ev[:DEFENSE] = 4
	pkmn3.ev[:SPECIAL_DEFENSE] = 4
	pkmn3.ev[:SPEED] = 56
	pkmn3.tera_type = :FAIRY
	pkmn3.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:SNEASLER,30)
	pkmn4.item = :GRASSYSEED
	pkmn4.ability_index = 0 # UNBURDEN
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:EGGBOMB)
	pkmn4.learn_move(:CLOSECOMBAT)
	pkmn4.learn_move(:POISONTAIL)
	pkmn4.learn_move(:PROTECT)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :DARK
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:GHOLDENGO,30)
	pkmn5.item = :LIFEORB
	pkmn5.ability_index = 0 # WONDERSKIN
	pkmn5.nature = :MODEST
	pkmn5.learn_move(:EGGBOMB)
	pkmn5.learn_move(:SHADOWBALL)
	pkmn5.learn_move(:POWERGEM)
	pkmn5.learn_move(:PROTECT)
	pkmn5.ev[:HP] = 252
	pkmn5.ev[:ATTACK] = 92
	pkmn5.ev[:DEFENSE] = 4
	pkmn5.ev[:SPECIAL_DEFENSE] = 44
	pkmn5.ev[:SPEED] = 120
	pkmn5.tera_type = :DRAGON
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:SWAMPERT,30)
	pkmn6.item = :HONEY
	pkmn6.ability_index = 2 # SHEERFORCE
	pkmn6.nature = :ADAMANT
	pkmn6.learn_move(:EGGBOMB)
	pkmn6.learn_move(:WATERFALL)
	pkmn6.learn_move(:BULKUP)
	pkmn6.learn_move(:WIDEGUARD)
	pkmn6.ev[:HP] = 240
	pkmn6.ev[:ATTACK] = 100
	pkmn6.ev[:DEFENSE] = 36
	pkmn6.ev[:SPECIAL_DEFENSE] = 92
	pkmn6.ev[:SPEED] = 44
	pkmn6.tera_type = :FLYING
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen4GrassPartyQuickStart30 # Poke Paste: https://pokepast.es/33d343e2f1d6c37b
	pkmn1 = Pokemon.new(:FARIGIRAF,30)
	pkmn1.item = :HONEY
	pkmn1.ability_index = 0 # ARMORTAIL
	pkmn1.nature = :CAREFUL
	pkmn1.learn_move(:TRICKROOM)
	pkmn1.learn_move(:HELPINGHAND)
	pkmn1.learn_move(:CURSE)
	pkmn1.learn_move(:BODYSLAM)
	pkmn1.ev[:HP] = 252
	pkmn1.ev[:ATTACK] = 76 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn1.ev[:DEFENSE] = 132
	pkmn1.ev[:SPECIAL_DEFENSE] = 52
	pkmn1.ev[:SPEED] = 0
	pkmn1.tera_type = :FAIRY
	pkmn1.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:URSALUNA,30)
	pkmn2.item = :FLAMEORB
	pkmn2.ability_index = 0 # GUTS
	pkmn2.nature = :BRAVE
	pkmn2.learn_move(:FACADE)
	pkmn2.learn_move(:HEADLONGRUSH)
	pkmn2.learn_move(:DRAINPUNCH)
	pkmn2.learn_move(:PROTECT)
	pkmn2.ev[:HP] = 144
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 44
	pkmn2.ev[:SPECIAL_DEFENSE] = 68
	pkmn2.ev[:SPEED] = 0
	pkmn2.tera_type = :NORMAL
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:INDEEDEE_1,30)
	pkmn3.makeFemale # Only done for Female Indeede, to make sure the correct form sprite is used
	pkmn3.item = :FOCUSSASH
	pkmn3.ability_index = 3 # OWNTEMPO
	pkmn3.nature = :BOLD
	pkmn3.learn_move(:FOLLOWME)
	pkmn3.learn_move(:HEALINGWISH)
	pkmn3.learn_move(:HEALPULSE)
	pkmn3.learn_move(:DAZZLINGGLEAM)
	pkmn3.ev[:HP] = 256
	pkmn3.ev[:ATTACK] = 0 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn3.ev[:DEFENSE] = 256
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 0
	pkmn3.tera_type = :WATER
	pkmn3.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:GALLADE,30)
	pkmn4.item = :MEGAITE
	pkmn4.ability_index = 0 # Base Ability: INTREPIDSWORD Mega Ability: SHARPNESS
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:VICTORYDANCE)
	pkmn4.learn_move(:SACREDSWORD)
	pkmn4.learn_move(:PSYCHOCUT)
	pkmn4.learn_move(:AQUACUTTER)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :DARK
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:TORTERRA,30)
	pkmn5.item = :EJECTPACK
	pkmn5.ability_index = 0 # SHELLARMOR
	pkmn5.nature = :ADAMANT
	pkmn5.learn_move(:HEADLONGRUSH)
	pkmn5.learn_move(:SAPPYSEED)
	pkmn5.learn_move(:SMACKDOWN)
	pkmn5.learn_move(:STEALTHROCK)
	pkmn5.ev[:HP] = 220
	pkmn5.ev[:ATTACK] = 212
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 80
	pkmn5.tera_type = :GHOST
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:DUSCLOPS,30)
	pkmn6.item = :EVIOLITE
	pkmn6.ability_index = 4 # INTIMIDATE
	pkmn6.nature = :CALM
	pkmn6.learn_move(:TRICKROOM)
	pkmn6.learn_move(:NIGHTSHADE)
	pkmn6.learn_move(:WILLOWISP)
	pkmn6.learn_move(:HELPINGHAND)
	pkmn6.ev[:HP] = 256
	pkmn6.iv[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 256
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :POISON
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen4FirePartyQuickStart30 # Poke Paste: https://pokepast.es/11fd54de4b4e6b9a
	pkmn1 = Pokemon.new(:INFERNAPE,30)
	pkmn1.item = :FOCUSSASH
	pkmn1.ability_index = 0 # DOWNLOAD (This ability has been renamed to Instinct, to allow more Pokemon to have this ability, than just technology Pokemon) 
	pkmn1.nature = :NAIVE # Because Instinct could boost Atk or Sp.Atk, This Nature Modifier is used, in order to not weaken Atk or Sp.Atk with a Jolly or Timid Nature Modifier
	pkmn1.learn_move(:FAKEOUT)
	pkmn1.learn_move(:OVERHEAT)
	pkmn1.learn_move(:CLOSECOMBAT)
	pkmn1.learn_move(:UTURN)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256 # Infernape's a prime example of a Pokemon who massively benefits from the EV Allowcator Overhaul 
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :ELECTRIC
	pkmn1.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:HYDREIGON,30)
	pkmn2.item = :LIFEORB
	pkmn2.ability_index = 4 # MEGALAUNCHER (Moves such as Flamethrower are now boosted by Mega Launcher)
	pkmn2.nature = :TIMID
	pkmn2.learn_move(:DRAGONPULSE)
	pkmn2.learn_move(:DARKPULSE)
	pkmn2.learn_move(:FLASHCANNON)
	pkmn2.learn_move(:FLAMETHROWER)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :STEEL
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:KILOWATTREL,30)
	pkmn3.item = :COVERTCLOAK
	pkmn3.ability_index = 0 # COMPETITIVE
	pkmn3.nature = :TIMID
	pkmn3.learn_move(:TAILWIND)
	pkmn3.learn_move(:THUNDERBOLT)
	pkmn3.learn_move(:EGGBOMB)
	pkmn3.learn_move(:VOLTSWITCH)
	pkmn3.ev[:HP] = 96
	pkmn3.ev[:ATTACK] = 160 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :GHOST
	pkmn3.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:GASTRODON,30)
	pkmn4.item = :HONEY
	pkmn4.ability_index = 4 # STORMDRAIN
	pkmn4.nature = :BOLD
	pkmn4.learn_move(:EARTHPOWER)
	pkmn4.learn_move(:MUDDYWATER)
	pkmn4.learn_move(:YAWN)
	pkmn4.learn_move(:PROTECT)
	pkmn4.ev[:HP] = 184
	pkmn4.ev[:ATTACK] = 0
	pkmn4.ev[:DEFENSE] = 204
	pkmn4.ev[:SPECIAL_DEFENSE] = 124
	pkmn4.ev[:SPEED] = 0
	pkmn4.tera_type = :BUG
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:RILLABOOM,30)
	pkmn5.item = :ASSAULTVEST
	pkmn5.ability_index = 0 # GRASSYSURGE
	pkmn5.nature = :ADAMANT
	pkmn5.learn_move(:WOODHAMMER)
	pkmn5.learn_move(:GRASSYGLIDE)
	pkmn5.learn_move(:FAKEOUT)
	pkmn5.learn_move(:UTURN)
	pkmn5.ev[:HP] = 204
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 52
	pkmn5.tera_type = :FIRE
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:MAGMAR,30)
	pkmn6.item = :EVIOLITE
	pkmn6.ability_index = 5 # FLASHFIRE
	pkmn6.nature = :CALM
	pkmn6.learn_move(:EMBER)
	pkmn6.learn_move(:CLEARSMOG)
	pkmn6.learn_move(:FOLLOWME)
	pkmn6.learn_move(:PROTECT)
	pkmn6.ev[:HP] = 256
	pkmn6.iv[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 236
	pkmn6.ev[:SPECIAL_DEFENSE] = 20
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :WATER
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen4WaterPartyQuickStart30 # Poke Paste: https://pokepast.es/34cd5ffd188f2107
	pkmn1 = Pokemon.new(:GHOLDENGO,30)
	pkmn1.item = :CHOICESCARF
	pkmn1.ability_index = 3 # ADAPTABILITY
	pkmn1.nature = :TIMID
	pkmn1.learn_move(:TRICK)
	pkmn1.learn_move(:SHADOWBALL)
	pkmn1.learn_move(:MAKEITRAIN)
	pkmn1.learn_move(:FOCUSBLAST)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :DARK
	pkmn1.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:GLISCOR,30)
	pkmn2.item = :ROCKYHELMET
	pkmn2.ability_index = 3 # LEVITATE
	pkmn2.nature = :CAREFUL
	pkmn2.learn_move(:KNOCKOFF)
	pkmn2.learn_move(:CROSSPOISON)
	pkmn2.learn_move(:SPIKES)
	pkmn2.learn_move(:ROOST)
	pkmn2.ev[:HP] = 248
	pkmn2.ev[:ATTACK] = 0
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 252
	pkmn2.ev[:SPEED] = 12
	pkmn2.tera_type = :FIRE
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:GARGANACL,30)
	pkmn3.item = :LEFTOVERS
	pkmn3.ability_index = 2 # WATERABSORB
	pkmn3.nature = :IMPISH
	pkmn3.learn_move(:CURSE)
	pkmn3.learn_move(:SALTCURE)
	pkmn3.learn_move(:EARTHQUAKE)
	pkmn3.learn_move(:RECOVER)
	pkmn3.ev[:HP] = 252
	pkmn3.ev[:ATTACK] = 0 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn3.ev[:DEFENSE] = 144
	pkmn3.ev[:SPECIAL_DEFENSE] = 116
	pkmn3.ev[:SPEED] = 0
	pkmn3.tera_type = :FAIRY
	pkmn3.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:EMPOLEON,30)
	pkmn4.item = :ASSAULTVEST
	pkmn4.ability_index = 4 # BATTLEARMOR
	pkmn4.nature = :MODEST
	pkmn4.learn_move(:EGGBOMB)
	pkmn4.learn_move(:SURF)
	pkmn4.learn_move(:ICEBEAM)
	pkmn4.learn_move(:VACUUMWAVE)
	pkmn4.ev[:HP] = 256
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 0
	pkmn4.tera_type = :FLYING
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:GREATTUSK,30)
	pkmn5.item = :HEAVYDUTYBOOTS
	pkmn5.ability_index = 5 # THICKFAT
	pkmn5.nature = :IMPISH
	pkmn5.learn_move(:RAPIDSPIN)
	pkmn5.learn_move(:ICESPINNER)
	pkmn5.learn_move(:STEALTHROCK)
	pkmn5.learn_move(:CLOSCOMBAT)
	pkmn5.ev[:HP] = 220
	pkmn5.ev[:ATTACK] = 0
	pkmn5.ev[:DEFENSE] = 252
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 40
	pkmn5.tera_type = :GRASS
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:ZAMAZENTA,30)
	pkmn6.item = :RUSTEDSHIELD
	pkmn6.ability_index = 2 # STAMINA
	pkmn6.nature = :CAREFUL
	pkmn6.learn_move(:EGGBOMB)
	pkmn6.learn_move(:BEHEMOTHBASH)
	pkmn6.learn_move(:REST)
	pkmn6.learn_move(:METALBURST)
	pkmn6.ev[:HP] = 256
	pkmn6.iv[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 64
	pkmn6.ev[:SPECIAL_DEFENSE] = 192
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :WATER
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen5GrassPartyQuickStart30 # Poke Paste: https://pokepast.es/93024247192aa5f0
	pkmn1 = Pokemon.new(:KOMMOO,30)
	pkmn1.item = :SAFETYGOGGLES
	pkmn1.ability_index = 6 # BATTLEARMOR
	pkmn1.nature = :IMPISH
	pkmn1.learn_move(:BODYPRESS)
	pkmn1.learn_move(:THROATCHOP)
	pkmn1.learn_move(:IRONDEFENSE)
	pkmn1.learn_move(:SLACKOFF)
	pkmn1.ev[:HP] = 256
	pkmn1.iv[:ATTACK] = 0
	pkmn1.ev[:DEFENSE] = 256
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 0
	pkmn1.tera_type = :FIGHTING
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:TYRANITAR,30)
	pkmn2.item = :ASSAULTVEST
	pkmn2.ability_index = 0 # SANDSTREAM
	pkmn2.nature = :ADAMANT
	pkmn2.learn_move(:KNOCKOFF)
	pkmn2.learn_move(:ROCKSLIDE)
	pkmn2.learn_move(:EGGBOMB)
	pkmn2.learn_move(:HIGHHORSEPOWER)
	pkmn2.ev[:HP] = 140
	pkmn2.ev[:ATTACK] = 252
	pkmn2.ev[:DEFENSE] = 4
	pkmn2.ev[:SPECIAL_DEFENSE] = 4
	pkmn2.ev[:SPEED] = 112
	pkmn2.tera_type = :FLYING
	pkmn2.dynamax_able = false
	pkmn2.calc_stats
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:SERPERIOR,30)
	pkmn3.item = :HONEY
	pkmn3.ability_index = 3 # CONTRARY
	pkmn3.nature = :TIMID
	pkmn3.learn_move(:LEAFSTORM)
	pkmn3.learn_move(:DRACOMETEOR)
	pkmn3.learn_move(:TAUNT)
	pkmn3.learn_move(:PROTECT)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :FIRE
	pkmn3.dynamax_able = false
	pkmn3.calc_stats
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:GRIMMSNARL,30)
	pkmn4.item = :LIGHTCLAY
	pkmn4.ability_index = 4 # PRANKSTER
	pkmn4.nature = :CAREFUL
	pkmn4.learn_move(:SPIRITBREAK)
	pkmn4.learn_move(:LIGHTSCREEN)
	pkmn4.learn_move(:REFLECT)
	pkmn4.learn_move(:PARTINGSHOT)
	pkmn4.ev[:HP] = 240
	pkmn4.iv[:ATTACK] = 0
	pkmn4.ev[:DEFENSE] = 156
	pkmn4.ev[:SPECIAL_DEFENSE] = 116
	pkmn4.ev[:SPEED] = 0
	pkmn4.tera_type = :GHOST
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:GHOLDENGO,30)
	pkmn5.item = :CHOICESCARF
	pkmn5.ability_index = 3 # ADAPTABILITY
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:PROTECT)
	pkmn5.learn_move(:SHADOWBALL)
	pkmn5.learn_move(:MAKEITRAIN)
	pkmn5.learn_move(:NASTYPLOT)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :STEEL
	pkmn5.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:PORYGON2,30)
	pkmn6.item = :EVIOLITE
	pkmn6.ability_index = 2 # TRACE
	pkmn6.nature = :BOLD
	pkmn6.learn_move(:THUNDERBOLT)
	pkmn6.learn_move(:ICEBEAM)
	pkmn6.learn_move(:TRICKROOM)
	pkmn6.learn_move(:RECOVER)
	pkmn6.ev[:HP] = 256
	pkmn6.ev[:ATTACK] = 0 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn6.ev[:DEFENSE] = 196
	pkmn6.ev[:SPECIAL_DEFENSE] = 60
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :ELECTRIC
	pkmn6.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen5FirePartyQuickStart30 # Poke Paste: https://pokepast.es/9de684bec8b65aa6
	pkmn1 = Pokemon.new(:EMBOAR,30)
	pkmn1.item = :CHOICESCARF
	pkmn1.ability_index = 0 # RECKLESS
	pkmn1.nature = :JOLLY
	pkmn1.learn_move(:HEADSMASH)
	pkmn1.learn_move(:FLAREBLITZ)
	pkmn1.learn_move(:DOUBLEEDGE)
	pkmn1.learn_move(:WILDCHARGE)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :GRASS
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:SABLEYE,30)
	pkmn2.item = :REDCARD
	pkmn2.ability_index = 4 # PRANKSTER
	pkmn2.nature = :CAREFUL
	pkmn2.learn_move(:SUNNYDAY)
	pkmn2.learn_move(:WILLOWISP)
	pkmn2.learn_move(:KNOCKOFF)
	pkmn2.learn_move(:SPIRITSHACKLE)
	pkmn2.ev[:HP] = 256
	pkmn2.iv[:ATTACK] = 4
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 252
	pkmn2.ev[:SPEED] = 0
	pkmn2.tera_type = :STEEL
	pkmn2.dynamax_able = false
	pkmn2.calc_stats
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:NINETALES,30)
	pkmn3.item = :HEATROCK
	pkmn3.ability_index = 0 # DROUGHT
	pkmn3.nature = :TIMID
	pkmn3.learn_move(:FLAMEBURST)
	pkmn3.learn_move(:SOLARBEAM)
	pkmn3.learn_move(:ENCORE)
	pkmn3.learn_move(:HEALINGWISH)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :FLYING
	pkmn3.dynamax_able = false
	pkmn3.calc_stats
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:EXEGGUTOR,30)
	pkmn4.item = :LUMBERRY
	pkmn4.ability_index = 3 # HARVEST
	pkmn4.nature = :MODEST
	pkmn4.learn_move(:REST)
	pkmn4.learn_move(:STUNSPORE)
	pkmn4.learn_move(:GIGADRAIN)
	pkmn4.learn_move(:PSYSHOCK)
	pkmn4.ev[:HP] = 252
	pkmn4.ev[:ATTACK] = 176
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 84
	pkmn4.tera_type = :WATER
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:VENUSAUR,30)
	pkmn5.item = :LIFEORB
	pkmn5.ability_index = 3 # CHLOROPHYLL
	pkmn5.nature = :MODEST
	pkmn5.learn_move(:GROWTH)
	pkmn5.learn_move(:SOLARBEAM)
	pkmn5.learn_move(:WEATHERBALL)
	pkmn5.learn_move(:ACIDSPRAY)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :FIRE
	pkmn5.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:SWAMPERT,30)
	pkmn6.item = :HONEY
	pkmn6.ability_index = 0 # REGENERATOR
	pkmn6.nature = :ADAMANT
	pkmn6.learn_move(:FLIPTURN)
	pkmn6.learn_move(:EGGBOMB)
	pkmn6.learn_move(:KNOCKOFF)
	pkmn6.learn_move(:STEALTHROCK)
	pkmn6.ev[:HP] = 256
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :POISON
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen5WaterPartyQuickStart30 # Poke Paste: https://pokepast.es/87d1f20a06b7af01 (Samurott needs to be tweaked to be it's base form)
	pkmn1 = Pokemon.new(:SAMUROTT,30)
	pkmn1.item = :ASSAULTVEST
	pkmn1.ability_index = 4 # SHARPNESS
	pkmn1.nature = :ADAMANT
	pkmn1.learn_move(:SLASH)
	pkmn1.learn_move(:RAZORSHELL)
	pkmn1.learn_move(:AQUAJET)
	pkmn1.learn_move(:CEASELESSEDGE)
	pkmn1.ev[:HP] = 248
	pkmn1.ev[:ATTACK] = 84
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 124
	pkmn1.ev[:SPEED] = 56
	pkmn1.tera_type = :GHOST
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:CLEFABLE,30)
	pkmn2.item = :HONEY
	pkmn2.ability_index = 3 # FRIENDGUARD
	pkmn2.nature = :BOLD
	pkmn2.learn_move(:MOONBLAST)
	pkmn2.learn_move(:MISTYTERRAIN)
	pkmn2.learn_move(:FOLLOWME)
	pkmn2.learn_move(:PROTECT)
	pkmn2.ev[:HP] = 248
	pkmn2.ev[:ATTACK] = 0
	pkmn2.ev[:DEFENSE] = 180
	pkmn2.ev[:SPECIAL_DEFENSE] = 84
	pkmn2.ev[:SPEED] = 0
	pkmn2.tera_type = :WATER
	pkmn2.dynamax_able = false
	pkmn2.calc_stats
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:GARCHOMP,30)
	pkmn3.item = :LIFEORB
	pkmn3.ability_index = 6 # HYPERCUTTER
	pkmn3.nature = :JOLLY
	pkmn3.learn_move(:PROTECT)
	pkmn3.learn_move(:SLASH)
	pkmn3.learn_move(:DRAGONCLAW)
	pkmn3.learn_move(:IRONTAIL)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :FIRE
	pkmn3.dynamax_able = false
	pkmn3.calc_stats
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:GHOLDENGO,30)
	pkmn4.item = :LEFTOVERS
	pkmn4.ability_index = 4 # RATTLED
	pkmn4.nature = :MODEST
	pkmn4.learn_move(:EGGBOMB)
	pkmn4.learn_move(:ASTRALBARRAGE)
	pkmn4.learn_move(:NASTYPLOT)
	pkmn4.learn_move(:PROTECT)
	pkmn4.ev[:HP] = 236
	pkmn4.ev[:ATTACK] = 52 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn4.ev[:DEFENSE] = 4
	pkmn4.ev[:SPECIAL_DEFENSE] = 52
	pkmn4.ev[:SPEED] = 168
	pkmn4.tera_type = :DRAGON
	pkmn4.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:HYDREIGON,30)
	pkmn5.item = :CHOICESPECS
	pkmn5.ability_index = 4 # MEGALAUNCHER (Moves such as Flamethrower are now boosted by Mega Launcher)
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:HYPERBEAM)
	pkmn5.learn_move(:DRACOMETEOR)
	pkmn5.learn_move(:FIREBLAST)
	pkmn5.learn_move(:FLASHCANNON)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :POISON
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:WHIMSICOTT,30)
	pkmn6.item = :FOCUSSASH
	pkmn6.ability_index = 0 # PRANKSTER
	pkmn6.nature = :TIMID
	pkmn6.learn_move(:EGGBOMB)
	pkmn6.learn_move(:TAILWIND)
	pkmn6.learn_move(:SUNNYDAY)
	pkmn6.learn_move(:ENCORE)
	pkmn6.ev[:HP] = 184
	pkmn6.ev[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 108
	pkmn6.ev[:SPEED] = 220
	pkmn6.tera_type = :DARK
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen6GrassPartyQuickStart30 # Poke Paste: https://pokepast.es/6f4e9f30a5729a02
	pkmn1 = Pokemon.new(:CHESNAUGHT,30)
	pkmn1.item = :LEFTOVERS
	pkmn1.ability_index = 3 # SHELLARMOR
	pkmn1.nature = :IMPISH
	pkmn1.learn_move(:REST)
	pkmn1.learn_move(:TAUNT)
	pkmn1.learn_move(:SAPPYSEED)
	pkmn1.learn_move(:METALBURST)
	pkmn1.ev[:HP] = 256
	pkmn1.ev[:ATTACK] = 0
	pkmn1.ev[:DEFENSE] = 80
	pkmn1.ev[:SPECIAL_DEFENSE] = 176
	pkmn1.ev[:SPEED] = 0
	pkmn1.tera_type = :WATER
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:ROARINGMOON,30)
	pkmn2.item = :BOOSTERENERGY
	pkmn2.ability_index = 0 # PROTOSYNTHESIS
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:DRAGONDANCE)
	pkmn2.learn_move(:KNOCKOFF)
	pkmn2.learn_move(:ACROBATICS)
	pkmn2.learn_move(:BRICKBREAK)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :FLYING
	pkmn2.dynamax_able = false
	pkmn2.calc_stats
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:GREATTUSK,30)
	pkmn3.item = :HEAVYDUTYBOOTS
	pkmn3.ability_index = 5 # THICKFAT
	pkmn3.nature = :JOLLY
	pkmn3.learn_move(:VICTORYDANCE)
	pkmn3.learn_move(:RAPIDSPIN)
	pkmn3.learn_move(:EGGBOMB)
	pkmn3.learn_move(:ICESPINNER)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :POISON
	pkmn3.dynamax_able = false
	pkmn3.calc_stats
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:RILLABOOM,30)
	pkmn4.item = :TERRAINEXTENDER
	pkmn4.ability_index = 0 # GRASSYSURGE
	pkmn4.nature = :ADAMANT
	pkmn4.learn_move(:UTURN)
	pkmn4.learn_move(:GRASSYGLIDE)
	pkmn4.learn_move(:TAUNT)
	pkmn4.learn_move(:KNOCKOFF)
	pkmn4.ev[:HP] = 240
	pkmn4.ev[:ATTACK] = 252 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 20
	pkmn4.tera_type = :GRASS
	pkmn4.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:HEATRAN,30)
	pkmn5.item = :AIRBALLOON
	pkmn5.ability_index = 6 # ROCKYPAYLOAD (Rocky Payload gives Rock STAB, and will set Stealth Rock if user is hit by a contact move
	pkmn5.nature = :BOLD
	pkmn5.learn_move(:EMBER)
	pkmn5.learn_move(:EARTHPOWER)
	pkmn5.learn_move(:MAGMASTORM)
	pkmn5.learn_move(:MORNINGSUN)
	pkmn5.ev[:HP] = 252
	pkmn5.ev[:ATTACK] = 0
	pkmn5.ev[:DEFENSE] = 88
	pkmn5.ev[:SPECIAL_DEFENSE] = 172
	pkmn5.ev[:SPEED] = 0
	pkmn5.tera_type = :GHOST
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:HAWLUCHA,30)
	pkmn6.item = :GRASSYSEED
	pkmn6.ability_index = 0 # UNBURDEN
	pkmn6.nature = :ADAMANT
	pkmn6.learn_move(:SWORDSDANCE)
	pkmn6.learn_move(:ENCORE)
	pkmn6.learn_move(:EGGBOMB)
	pkmn6.learn_move(:CLOSECOMBAT)
	pkmn6.ev[:HP] = 128
	pkmn6.ev[:ATTACK] = 252
	pkmn6.ev[:DEFENSE] = 4
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 128
	pkmn6.tera_type = :ELECTRIC
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen6FirePartyQuickStart30 # Poke Paste: https://pokepast.es/b601021be152e474
	pkmn1 = Pokemon.new(:DELPHOX,30)
	pkmn1.item = :LIFEORB
	pkmn1.ability_index = 2 # BATTLEBOND
	pkmn1.nature = :TIMID
	pkmn1.learn_move(:EXPANDINGFORCE)
	pkmn1.learn_move(:HEATWAVE)
	pkmn1.learn_move(:GRASSKNOT)
	pkmn1.learn_move(:PROTECT)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :GRASS
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:INDEEDEE,30)
	pkmn2.makeMale # Only done for Male Indeede, to make sure the correct form sprite is used
	pkmn2.item = :FOCUSSASH
	pkmn2.ability_index = 0 # PSYCHICSURGE
	pkmn2.nature = :TIMID
	pkmn2.learn_move(:EXPANDINGFORCE)
	pkmn2.learn_move(:TERABLAST)
	pkmn2.learn_move(:IMPRISON)
	pkmn2.learn_move(:TRICKROOM)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :FIGHTING
	pkmn2.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:SNEASLER,30)
	pkmn3.item = :PSYCHICSEED
	pkmn3.ability_index = 0 # UNBURDEN
	pkmn3.nature = :JOLLY
	pkmn3.learn_move(:EGGBOMB)
	pkmn3.learn_move(:CLOSECOMBAT)
	pkmn3.learn_move(:POISONTAIL)
	pkmn3.learn_move(:PROTECT)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :DARK
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:WHIMSICOTT,30)
	pkmn4.item = :FOCUSSASH
	pkmn4.ability_index = 0 # PRANKSTER
	pkmn4.nature = :TIMID
	pkmn4.learn_move(:EGGBOMB)
	pkmn4.learn_move(:TAILWIND)
	pkmn4.learn_move(:SUNNYDAY)
	pkmn4.learn_move(:ENCORE)
	pkmn4.ev[:HP] = 184
	pkmn4.ev[:ATTACK] = 0
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 108
	pkmn4.ev[:SPEED] = 220
	pkmn4.tera_type = :WATER
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:MAUSHOLD,30)
	pkmn5.item = :WIDELENS
	pkmn5.ability_index = 4 # TECHNICIAN 
	pkmn5.nature = :JOLLY
	pkmn5.learn_move(:POPULATIONBOMB)
	pkmn5.learn_move(:FOLLOWME)
	pkmn5.learn_move(:BITE)
	pkmn5.learn_move(:PROTECT)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :NORMAL
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:ANNIHILAPE,30)
	pkmn6.item = :ASSAULTVEST
	pkmn6.ability_index = 5 # MOXIE
	pkmn6.nature = :JOLLY
	pkmn6.learn_move(:FINALGAMBIT)
	pkmn6.learn_move(:DRAINPUNCH)
	pkmn6.learn_move(:MEGAPUNCH)
	pkmn6.learn_move(:ROCKTOMB)
	pkmn6.ev[:HP] = 252
	pkmn6.ev[:ATTACK] = 76
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 180
	pkmn6.tera_type = :FIRE
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen6WaterPartyQuickStart30 # Poke Paste: https://pokepast.es/5504c7ce0c736539
	pkmn1 = Pokemon.new(:GRENINJA,30)
	pkmn1.item = :MEGAITE
	pkmn1.ability_index = 0 # PROTEAN
	pkmn1.nature = :TIMID
	pkmn1.learn_move(:HYDROCANNON)
	pkmn1.learn_move(:EGGBOMB)
	pkmn1.learn_move(:AEROBLAST)
	pkmn1.learn_move(:EXTRASENSORY)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :WATER
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:CLODSIRE,30)
	pkmn2.item = :HEAVYDUTYBOOTS
	pkmn2.ability_index = 3 # WATERABSORB
	pkmn2.nature = :CAREFUL
	pkmn2.learn_move(:STEALTHROCK)
	pkmn2.learn_move(:RAPIDSPIN)
	pkmn2.learn_move(:SPIKES)
	pkmn2.learn_move(:RECOVER)
	pkmn2.ev[:HP] = 252
	pkmn2.ev[:ATTACK] = 0 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn2.ev[:DEFENSE] = 8
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 252
	pkmn2.tera_type = :DARK
	pkmn2.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:GHOLDENGO,30)
	pkmn3.item = :COVERTCLOAK
	pkmn3.ability_index = 5 # PRANKSTER
	pkmn3.nature = :TIMID
	pkmn3.learn_move(:SHADOWBALL)
	pkmn3.learn_move(:EGGBOMB)
	pkmn3.learn_move(:RECOVER)
	pkmn3.learn_move(:NASTYPLOT)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :FLYING
	pkmn3.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:IRONVALIANT,30)
	pkmn4.item = :CHOICESPECS
	pkmn4.ability_index = 4 # MOTORDRIVE
	pkmn4.nature = :TIMID
	pkmn4.learn_move(:SPARKLYSWIRL)
	pkmn4.learn_move(:PSYSHOCK)
	pkmn4.learn_move(:TRICK)
	pkmn4.learn_move(:THUNDERBOLT)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :FAIRY
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:GREATTUSK,30)
	pkmn5.item = :ROCKYHELMET
	pkmn5.ability_index = 4 # THICKFAT 
	pkmn5.nature = :IMPISH
	pkmn5.learn_move(:RAPIDSPIN)
	pkmn5.learn_move(:BULKUP)
	pkmn5.learn_move(:KNOCKOFF)
	pkmn5.learn_move(:BODYPRESS)
	pkmn5.ev[:HP] = 256
	pkmn5.ev[:ATTACK] = 0
	pkmn5.ev[:DEFENSE] = 216
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 40
	pkmn5.tera_type = :STEEL
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:CORVIKNIGHT,30)
	pkmn6.item = :LEFTOVERS
	pkmn6.ability_index = 0 # STAMINA
	pkmn6.nature = :CAREFUL
	pkmn6.learn_move(:DOUBLEEDGE)
	pkmn6.learn_move(:MEDITATE)
	pkmn6.learn_move(:ROOST)
	pkmn6.learn_move(:BODYPRESS)
	pkmn6.ev[:HP] = 256
	pkmn6.ev[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 4
	pkmn6.ev[:SPECIAL_DEFENSE] = 252
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :GROUND
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen7GrassPartyQuickStart30 # Poke Paste: https://pokepast.es/6b48dc53126cba80
	pkmn1 = Pokemon.new(:DECIDUEYE,30)
	pkmn1.item = :BIGROOT
	pkmn1.ability_index = 0 # LONGREACH
	pkmn1.nature = :JOLLY
	pkmn1.learn_move(:SAPPYSEED)
	pkmn1.learn_move(:UTURN)
	pkmn1.learn_move(:HAZE)
	pkmn1.learn_move(:TAILWIND)
	pkmn1.ev[:HP] = 20
	pkmn1.ev[:ATTACK] = 0
	pkmn1.ev[:DEFENSE] = 100
	pkmn1.ev[:SPECIAL_DEFENSE] = 144
	pkmn1.ev[:SPEED] = 248
	pkmn1.tera_type = :FAIRY
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:CERULEDGE,30)
	pkmn2.item = :LIFEORB
	pkmn2.ability_index = 0 # SHARPNESS
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:BITTERBLADE)
	pkmn2.learn_move(:SLASH)
	pkmn2.learn_move(:CLOSECOMAT)
	pkmn2.learn_move(:PROTECT)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :GRASS
	pkmn2.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:INCINEROAR,30)
	pkmn3.item = :SAFETYGOGGLES
	pkmn3.ability_index = 0 # Intimidate
	pkmn3.nature = :CAREFUL
	pkmn3.learn_move(:FAKEOUT)
	pkmn3.learn_move(:PARTINGSHOT)
	pkmn3.learn_move(:FLAREBLITZ)
	pkmn3.learn_move(:KNOCKOFF)
	pkmn3.ev[:HP] = 244
	pkmn3.ev[:ATTACK] = 4
	pkmn3.ev[:DEFENSE] = 132
	pkmn3.ev[:SPECIAL_DEFENSE] = 84
	pkmn3.ev[:SPEED] = 48
	pkmn3.tera_type = :GHOST
	pkmn3.dynamax_able = false
	pkmn3.calc_stats
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:URSALUNA,30)
	pkmn4.item = :FLAMEORB
	pkmn4.ability_index = 0 # GUTS
	pkmn4.nature = :BRAVE
	pkmn4.learn_move(:FACADE)
	pkmn4.learn_move(:HEADLONGRUSH)
	pkmn4.learn_move(:FIREPUNCH)
	pkmn4.learn_move(:PROTECT)
	pkmn4.ev[:HP] = 140
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 44
	pkmn4.ev[:SPECIAL_DEFENSE] = 68
	pkmn4.ev[:SPEED] = 0
	pkmn4.tera_type = :POISON
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:TORKOAL,30)
	pkmn5.item = :EJECTPACK
	pkmn5.ability_index = 2 # DROUGHT
	pkmn5.nature = :QUIET
	pkmn5.learn_move(:ERUPTION)
	pkmn5.learn_move(:OVERHEAT)
	pkmn5.learn_move(:HELPINGHAND)
	pkmn5.learn_move(:PROTECT)
	pkmn5.ev[:HP] = 176
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 72
	pkmn5.ev[:SPEED] = 0
	pkmn5.tera_type = :FIRE
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:PORYGON2,30)
	pkmn6.item = :EVIOLITE
	pkmn6.ability_index = 0 # ANALYTIC
	pkmn6.nature = :BOLD
	pkmn6.learn_move(:ICEBEAM)
	pkmn6.learn_move(:EGGBOMB)
	pkmn6.learn_move(:TRICKROOM)
	pkmn6.learn_move(:RECOVER)
	pkmn6.ev[:HP] = 256
	pkmn6.ev[:ATTACK] = 8
	pkmn6.ev[:DEFENSE] = 176
	pkmn6.ev[:SPECIAL_DEFENSE] = 72
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :FIGHTING
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen7FirePartyQuickStart30 # Poke Paste: https://pokepast.es/b7fb981ef157f4aa
	pkmn1 = Pokemon.new(:INCINEROAR,30)
	pkmn1.item = :SAFETYGOGGLES
	pkmn1.ability_index = 0 # Intimidate
	pkmn1.nature = :CAREFUL
	pkmn1.learn_move(:FAKEOUT)
	pkmn1.learn_move(:PARTINGSHOT)
	pkmn1.learn_move(:FLAREBLITZ)
	pkmn1.learn_move(:KNOCKOFF)
	pkmn1.ev[:HP] = 256
	pkmn1.ev[:ATTACK] = 0
	pkmn1.ev[:DEFENSE] = 164
	pkmn1.ev[:SPECIAL_DEFENSE] = 92
	pkmn1.ev[:SPEED] = 0
	pkmn1.tera_type = :GHOST
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:RILLABOOM,30)
	pkmn2.item = :ASSAULTVEST
	pkmn2.ability_index = 0 # GRASSYSURGE
	pkmn2.nature = :ADAMANT
	pkmn2.learn_move(:WOODHAMMER)
	pkmn2.learn_move(:GRASSYGLIDE)
	pkmn2.learn_move(:FAKEOUT)
	pkmn2.learn_move(:UTURN)
	pkmn2.ev[:HP] = 248
	pkmn2.ev[:ATTACK] = 116
	pkmn2.ev[:DEFENSE] = 12
	pkmn2.ev[:SPECIAL_DEFENSE] = 132
	pkmn2.ev[:SPEED] = 4
	pkmn2.tera_type = :POISON
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:FARIGIRAF,30)
	pkmn3.item = :THROATSPRAY
	pkmn3.ability_index = 0 # Armor Tail
	pkmn3.nature = :MODEST
	pkmn3.learn_move(:PROTECT)
	pkmn3.learn_move(:TRICKROOM)
	pkmn3.learn_move(:HYPERVOICE)
	pkmn3.learn_move(:PSYCHIC)
	pkmn3.ev[:HP] = 112
	pkmn3.ev[:ATTACK] = 156
	pkmn3.ev[:DEFENSE] = 44
	pkmn3.ev[:SPECIAL_DEFENSE] = 196
	pkmn3.ev[:SPEED] = 0
	pkmn3.iv[:ATTACK] = 0
	pkmn3.iv[:SPEED] = 27
	pkmn3.tera_type = :FAIRY
	pkmn3.dynamax_able = false
	pkmn3.calc_stats
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:FLUTTERMANE,30)
	pkmn4.item = :BOOSTERENERGY
	pkmn4.ability_index = 0 # Protosynthesis
	pkmn4.nature = :TIMID
	pkmn4.learn_move(:PROTECT)
	pkmn4.learn_move(:MOONBLAST)
	pkmn4.learn_move(:SHADOWBALL)
	pkmn4.learn_move(:CALMMIND)
	pkmn4.ev[:HP] = 164
	pkmn4.ev[:ATTACK] = 108
	pkmn4.ev[:DEFENSE] = 164
	pkmn4.ev[:SPECIAL_DEFENSE] = 4
	pkmn4.ev[:SPEED] = 72
	pkmn4.iv[:ATTACK] = 0
	pkmn4.tera_type = :GRASS
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:URSHIFU_1,30)
	pkmn5.item = :CHOICESCARF
	pkmn5.ability_index = 0 # Defiant
	pkmn5.nature = :ADAMANT
	pkmn5.learn_move(:SURGINGSTRIKES)
	pkmn5.learn_move(:CLOSECOMBAT)
	pkmn5.learn_move(:AQUAJET)
	pkmn5.learn_move(:UTURN)
	pkmn5.ev[:HP] = 44
	pkmn5.ev[:ATTACK] = 156
	pkmn5.ev[:DEFENSE] = 4
	pkmn5.ev[:SPECIAL_DEFENSE] = 92
	pkmn5.ev[:SPEED] = 216
	pkmn5.iv[:SPECIAL_ATTACK] = 0
	pkmn5.tera_type = :WATER
	pkmn5.dynamax_able = false
	pkmn5.calc_stats
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:OGERPON,30)
	pkmn6.item = :HEARTHFLAMEMASK
	pkmn6.nature = :JOLLY
	pkmn6.learn_move(:IVYCUDGEL)
	pkmn6.learn_move(:GRASSYGLIDE)
	pkmn6.learn_move(:SWORDSDANCE)
	pkmn6.learn_move(:SPIKYSHIELD)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.iv[:SPECIAL_ATTACK] = 0
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen7WaterPartyQuickStart30 # Poke Paste: https://pokepast.es/40b6bff80a7d28e3
	pkmn1 = Pokemon.new(:PRIMARINA,30)
	pkmn1.item = :CUSTAPBERRY
	pkmn1.ability_index = 4 # BATTLEBOND
	pkmn1.nature = :MODEST
	pkmn1.learn_move(:SPARKLYSWIRL)
	pkmn1.learn_move(:HYDROCANNON)
	pkmn1.learn_move(:ENCORE)
	pkmn1.learn_move(:CALMMIND)
	pkmn1.ev[:HP] = 76
	pkmn1.ev[:ATTACK] = 252
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 184
	pkmn1.tera_type = :STEEL
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:GLISCOR,30)
	pkmn2.item = :LEFTOVERS
	pkmn2.ability_index = 5 # PRANKSTER
	pkmn2.nature = :CAREFUL
	pkmn2.learn_move(:KNOCKOFF)
	pkmn2.learn_move(:POISONSTING)
	pkmn2.learn_move(:RAPIDSPIN)
	pkmn2.learn_move(:VENOMDRENCH)
	pkmn2.ev[:HP] = 248
	pkmn2.ev[:ATTACK] = 0
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 240
	pkmn2.ev[:SPEED] = 24
	pkmn2.tera_type = :FLYING
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:TINGLU,30)
	pkmn3.item = :ROCKYHELMET
	pkmn3.ability_index = 0 # VESSELOFRUIN
	pkmn3.nature = :CAREFUL
	pkmn3.learn_move(:STEALTHROCK)
	pkmn3.learn_move(:SPIKES)
	pkmn3.learn_move(:SANDATTACK)
	pkmn3.learn_move(:RUINATION)
	pkmn3.ev[:HP] = 248
	pkmn3.ev[:DEFENSE] = 16
	pkmn3.ev[:SPECIAL_DEFENSE] = 248
	pkmn3.ev[:SPEED] = 0
	pkmn3.tera_type = :WATER
	pkmn3.dynamax_able = false
	pkmn3.calc_stats
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:ZAPDOS,30)
	pkmn4.item = :HEAVYDUTYBOOTS
	pkmn4.ability_index = 0 # LIGHTNINGROD
	pkmn4.nature = :BOLD
	pkmn4.learn_move(:AEROBLAST)
	pkmn4.learn_move(:VOLTSWITCH)
	pkmn4.learn_move(:THUNDERWAVE)
	pkmn4.learn_move(:ROOST)
	pkmn4.ev[:HP] = 252
	pkmn4.ev[:ATTACK] = 0
	pkmn4.ev[:DEFENSE] = 244
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 16
	pkmn4.iv[:ATTACK] = 0
	pkmn4.tera_type = :DRAGON
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:GHOLDENGO,30)
	pkmn5.item = :SHUCABERRY
	pkmn5.ability_index = 4 # RATTLED
	pkmn5.nature = :MODEST
	pkmn5.learn_move(:SHADOWBALL)
	pkmn5.learn_move(:EGGBOMB)
	pkmn5.learn_move(:RECOVER)
	pkmn5.learn_move(:NASTYPLOT)
	pkmn5.ev[:HP] = 192
	pkmn5.ev[:ATTACK] = 152 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 16
	pkmn5.ev[:SPEED] = 152
	pkmn5.tera_type = :WATER
	pkmn5.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:DARKRAI,30)
	pkmn6.item = :LIFEORB
	pkmn6.nature = :TIMID
	pkmn6.learn_move(:BLOODMOON)
	pkmn6.learn_move(:MOONGEISTBEAM)
	pkmn6.learn_move(:SLUDGEBOMB)
	pkmn6.learn_move(:NASTYPLOT)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.iv[:ATTACK] = 0
	pkmn6.tera_type = :POISON
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen8GrassPartyQuickStart30 # Poke Paste: https://pokepast.es/8f4767c8ef7df026
	pkmn1 = Pokemon.new(:RILLABOOM,30)
	pkmn1.item = :CHOICEBAND
	pkmn1.ability_index = 0 # GRASSYSURGE
	pkmn1.nature = :ADAMANT
	pkmn1.learn_move(:WOODHAMMER)
	pkmn1.learn_move(:GRASSYGLIDE)
	pkmn1.learn_move(:UTURN)
	pkmn1.learn_move(:KNOCKOFF)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :GRASS
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:OGERPON,30)
	pkmn2.item = :CORNERSTONEMASK
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:IVYCUDGEL)
	pkmn2.learn_move(:POWERWHIP)
	pkmn2.learn_move(:SPIKES)
	pkmn2.learn_move(:TAUNT)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.iv[:SPECIAL_ATTACK] = 0
	pkmn2.dynamax_able = false
	pkmn2.calc_stats
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:RAGINGBOLT,30)
	pkmn3.item = :HONEY
	pkmn3.ability_index = 4 # INTIMIDATE
	pkmn3.nature = :MODEST
	pkmn3.learn_move(:THUNDERCLAP)
	pkmn3.learn_move(:HYPERBEAM)
	pkmn3.learn_move(:ANCIENTPOWER)
	pkmn3.learn_move(:CALMMIND)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn2.iv[:ATTACK] = 0
	pkmn3.tera_type = :WATER
	pkmn3.dynamax_able = false
	pkmn3.calc_stats
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:IRONMOTH,30)
	pkmn4.item = :PASSHOBERRY
	pkmn4.ability_index = 2 # LEVITATE
	pkmn4.nature = :TIMID
	pkmn4.learn_move(:QUIVERDANCE)
	pkmn4.learn_move(:SUBSTITUTE)
	pkmn4.learn_move(:EGGBOMB)
	pkmn4.learn_move(:EMBER)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 132
	pkmn4.ev[:DEFENSE] = 124
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :GHOST
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:IRONVALIANT,30)
	pkmn5.item = :BOOSTERENERGY
	pkmn5.ability_index = 0 # QUARKDRIVE
	pkmn5.nature = :JOLLY
	pkmn5.learn_move(:PLAYROUGH)
	pkmn5.learn_move(:COACHING)
	pkmn5.learn_move(:WIDEGUARD)
	pkmn5.learn_move(:ENCORE)
	pkmn5.ev[:HP] = 204
	pkmn5.ev[:ATTACK] = 4
	pkmn5.ev[:DEFENSE] = 100
	pkmn5.ev[:SPECIAL_DEFENSE] = 28
	pkmn5.ev[:SPEED] = 176
	pkmn5.tera_type = :ELECTRIC
	pkmn5.dynamax_able = false
	pkmn5.calc_stats
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:KINGAMBIT,30)
	pkmn6.item = :LUMBERRY
	pkmn6.nature = :JOLLY
	pkmn6.learn_move(:SWORDSDANCE)
	pkmn6.learn_move(:KOWTOWCLEAVE)
	pkmn6.learn_move(:SUCKERPUNCH)
	pkmn6.learn_move(:IRONHEAD)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.iv[:ATTACK] = 0
	pkmn6.tera_type = :DARK
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen8FirePartyQuickStart30 # Poke Paste: https://pokepast.es/999f4123b7a772e8
	pkmn1 = Pokemon.new(:CINDERACE,30)
	pkmn1.item = :GIGANTAITE
	pkmn1.ability_index = 4 # LIMBER
	pkmn1.nature = :JOLLY
	pkmn1.learn_move(:MEGAKICK)
	pkmn1.learn_move(:SUCKERPUNCH)
	pkmn1.learn_move(:UTURN)
	pkmn1.learn_move(:COURTCHANGE)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :WATER
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:SLOWKING_1,30)
	pkmn2.item = :HEAVYDUTYBOOTS
	pkmn2.ability_index = 4 # REGENERATOR
	pkmn2.nature = :RELAXED
	pkmn2.learn_move(:PSYCHICNOISE)
	pkmn2.learn_move(:EGGBOMB)
	pkmn2.learn_move(:ICEBEAM)
	pkmn2.learn_move(:UTURN)
	pkmn2.ev[:HP] = 252
	pkmn2.ev[:ATTACK] = 0
	pkmn2.ev[:DEFENSE] = 252
	pkmn2.ev[:SPECIAL_DEFENSE] = 8
	pkmn2.ev[:SPEED] = 0
	pkmn2.tera_type = :GRASS
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:TINGLU,30)
	pkmn3.item = :LEFTOVERS
	pkmn3.ability_index = 5 # ROCKYPAYLOAD
	pkmn3.nature = :CAREFUL
	pkmn3.learn_move(:REST)
	pkmn3.learn_move(:SPIKES)
	pkmn3.learn_move(:SANDATTACK)
	pkmn3.learn_move(:PAYPACK)
	pkmn3.ev[:HP] = 252
	pkmn3.ev[:DEFENSE] = 8
	pkmn3.ev[:SPECIAL_DEFENSE] = 252
	pkmn3.ev[:SPEED] = 0
	pkmn3.tera_type = :FAIRY
	pkmn3.dynamax_able = false
	pkmn3.calc_stats
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:CORVIKNIGHT,30)
	pkmn4.item = :ROCKYHELMET
	pkmn4.ability_index = 2 # PRESSURE
	pkmn4.nature = :IMPISH
	pkmn4.learn_move(:BODYPRESS)
	pkmn4.learn_move(:DEFOG)
	pkmn4.learn_move(:ROOST)
	pkmn4.learn_move(:UTURN)
	pkmn4.ev[:HP] = 252
	pkmn4.ev[:ATTACK] = 0
	pkmn4.ev[:DEFENSE] = 252
	pkmn4.ev[:SPECIAL_DEFENSE] = 8
	pkmn4.ev[:SPEED] = 0
	pkmn4.tera_type = :DRAGON
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:RAGINGBOLT,30)
	pkmn5.item = :CHOICESPECS
	pkmn5.ability_index = 4 # INTIMIDATE
	pkmn5.nature = :MODEST
	pkmn5.learn_move(:VOLTSWITCH)
	pkmn5.learn_move(:HYPERBEAM)
	pkmn5.learn_move(:THUNDERBOLT)
	pkmn5.learn_move(:THUNDERCLAP)
	pkmn5.ev[:HP] = 112
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 144
	pkmn5.iv[:ATTACK] = 0
	pkmn5.tera_type = :BUG
	pkmn5.dynamax_able = false
	pkmn5.calc_stats
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:OGERPON,30)
	pkmn6.item = :WELLSPRINGMASK
	pkmn6.nature = :JOLLY
	pkmn6.learn_move(:IVYCUDGEL)
	pkmn6.learn_move(:KNOCKOFF)
	pkmn6.learn_move(:UTURN)
	pkmn6.learn_move(:ENCORE)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.iv[:SPECIAL_ATTACK] = 0
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen8WaterPartyQuickStart30 # Poke Paste: https://pokepast.es/fa6099e03a99dbd5
	pkmn1 = Pokemon.new(:INTELEON,30)
	pkmn1.item = :SCOPELENS
	pkmn1.ability_index = 6 # SUPERLUCK
	pkmn1.nature = :TIMID
	pkmn1.learn_move(:SNIPESHOT)
	pkmn1.learn_move(:EGGBOMB)
	pkmn1.learn_move(:ICEBEAM)
	pkmn1.learn_move(:PROTECT)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :GROUND
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:MAUSHOLD,30)
	pkmn2.item = :FOCUSSASH
	pkmn2.ability_index = 4 # TECHNICIAN 
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:POPULATIONBOMB)
	pkmn2.learn_move(:FOLLOWME)
	pkmn2.learn_move(:PROTECT)
	pkmn2.learn_move(:TIDYUP)
	pkmn2.ev[:HP] = 4
	pkmn2.ev[:ATTACK] = 252
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :GHOST
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:GHOLDENGO,30)
	pkmn3.item = :LIFEORB
	pkmn3.ability_index = 0 # WONDERSKIN
	pkmn3.nature = :MODEST
	pkmn3.learn_move(:MAKEITRAIN)
	pkmn3.learn_move(:SHADOWBALL)
	pkmn3.learn_move(:NASTYPLOT)
	pkmn3.learn_move(:PROTECT)
	pkmn3.ev[:HP] = 252
	pkmn3.ev[:ATTACK] = 92
	pkmn3.ev[:DEFENSE] = 4
	pkmn3.ev[:SPECIAL_DEFENSE] = 44
	pkmn3.ev[:SPEED] = 120
	pkmn3.tera_type = :STEEL
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:INCINEROAR,30)
	pkmn4.item = :HONEY
	pkmn4.ability_index = 0 # INTIMIDATE
	pkmn4.nature = :CAREFUL
	pkmn4.learn_move(:FLAREBLITZ)
	pkmn4.learn_move(:KNOCKOFF)
	pkmn4.learn_move(:FAKEOUT)
	pkmn4.learn_move(:PARTINGSHOT)
	pkmn4.ev[:HP] = 248
	pkmn4.ev[:ATTACK] = 0
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 212
	pkmn4.ev[:SPEED] = 52
	pkmn4.tera_type = :WATER
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:RILLABOOM,30)
	pkmn5.item = :ASSAULTVEST
	pkmn5.ability_index = 0 # GRASSYSURGE
	pkmn5.nature = :ADAMANT
	pkmn5.learn_move(:WOODHAMMER)
	pkmn5.learn_move(:GRASSYGLIDE)
	pkmn5.learn_move(:FAKEOUT)
	pkmn5.learn_move(:UTURN)
	pkmn5.ev[:HP] = 204
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 52
	pkmn5.tera_type = :FIRE
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:SNEASLER,30)
	pkmn6.item = :GRASSYSEED
	pkmn6.ability_index = 0 # UNBURDEN
	pkmn6.nature = :JOLLY
	pkmn6.learn_move(:EGGBOMB)
	pkmn6.learn_move(:CLOSECOMBAT)
	pkmn6.learn_move(:POISONTAIL)
	pkmn6.learn_move(:FAKEOUT)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.tera_type = :FLYING
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen9GrassPartyQuickStart30 # Poke Paste: https://pokepast.es/9a7f780862533fde
	pkmn1 = Pokemon.new(:MEOWSCARADA,30)
	pkmn1.item = :FOCUSSASH
	pkmn1.ability_index = 6 # MAGICBOUNCE
	pkmn1.nature = :JOLLY
	pkmn1.learn_move(:KNOCKOFF)
	pkmn1.learn_move(:UTURN)
	pkmn1.learn_move(:TRIPLEAXEL)
	pkmn1.learn_move(:STEALTHROCK)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :GHOST
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:GLISCOR,30)
	pkmn2.item = :ROCKYHELMET
	pkmn2.ability_index = 3 # LEVITATE
	pkmn2.nature = :CAREFUL
	pkmn2.learn_move(:RAPIDSPIN)
	pkmn2.learn_move(:ROOST)
	pkmn2.learn_move(:SPIKES)
	pkmn2.learn_move(:POISONSTING)
	pkmn2.ev[:HP] = 248
	pkmn2.ev[:ATTACK] = 0
	pkmn2.ev[:DEFENSE] = 88
	pkmn2.ev[:SPECIAL_DEFENSE] = 176
	pkmn2.ev[:SPEED] = 0
	pkmn2.tera_type = :ELECTRIC
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:URSALUNA,30)
	pkmn3.item = :ASSAULTVEST
	pkmn3.ability_index = 6 # INTIMIDATE
	pkmn3.nature = :ADAMANT
	pkmn3.learn_move(:GIGAIMPACT)
	pkmn3.learn_move(:STOMPINGTANTRUM)
	pkmn3.learn_move(:AVALANCHE)
	pkmn3.learn_move(:DRAINPUNCH)
	pkmn3.ev[:HP] = 188
	pkmn3.ev[:ATTACK] = 56
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 208
	pkmn3.ev[:SPEED] = 60
	pkmn3.tera_type = :POISON
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:SKARMORY,30)
	pkmn4.item = :LEFTOVERS
	pkmn4.ability_index = 0 # BATTLEARMOR
	pkmn4.nature = :IMPISH
	pkmn4.learn_move(:BEAKBLAST)
	pkmn4.learn_move(:ROOST)
	pkmn4.learn_move(:WHIRLWIND)
	pkmn4.learn_move(:METALBURST)
	pkmn4.ev[:HP] = 244
	pkmn4.ev[:ATTACK] = 0
	pkmn4.ev[:DEFENSE] = 216
	pkmn4.ev[:SPECIAL_DEFENSE] = 44
	pkmn4.ev[:SPEED] = 8
	pkmn4.tera_type = :DRAGON
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:SLOWKING_1,30)
	pkmn5.item = :HEAVYDUTYBOOTS
	pkmn5.ability_index = 4 # REGENERATOR
	pkmn5.nature = :RELAXED
	pkmn5.learn_move(:PSYCHICNOISE)
	pkmn5.learn_move(:EGGBOMB)
	pkmn5.learn_move(:THUNDERWAVE)
	pkmn5.learn_move(:UTURN)
	pkmn5.ev[:HP] = 252
	pkmn5.ev[:ATTACK] = 0
	pkmn5.ev[:DEFENSE] = 8
	pkmn5.ev[:SPECIAL_DEFENSE] = 252
	pkmn5.ev[:SPEED] = 0
	pkmn5.tera_type = :WATER
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:DRAGAPULT,30)
	pkmn6.item = :LIFEORB
	pkmn6.ability_index = 6 # INFILTRATOR
	pkmn6.nature = :TIMID
	pkmn6.learn_move(:EGGBOMB)
	pkmn6.learn_move(:HEX)
	pkmn6.learn_move(:UTURN)
	pkmn6.learn_move(:WILLOWISP)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.tera_type = :FIRE
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen9FirePartyQuickStart30 # Poke Paste: https://pokepast.es/b8add99b4fadea57
	pkmn1 = Pokemon.new(:SKELEDIRGE,30)
	pkmn1.item = :HEAVYDUTYBOOTS
	pkmn1.ability_index = 0 # UNAWARE
	pkmn1.nature = :BOLD
	pkmn1.learn_move(:TORCHSONG)
	pkmn1.learn_move(:ALLURINGVOICE)
	pkmn1.learn_move(:WILLOWISP)
	pkmn1.learn_move(:SLACKOFF)
	pkmn1.ev[:HP] = 252
	pkmn1.ev[:ATTACK] = 0
	pkmn1.ev[:DEFENSE] = 16
	pkmn1.ev[:SPECIAL_DEFENSE] = 244
	pkmn1.ev[:SPEED] = 0
	pkmn1.tera_type = :FAIRY
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:IRONTREADS,30)
	pkmn2.item = :BOOSTERENERGY
	pkmn2.ability_index = 2 # STURDY
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:RAPIDSPIN)
	pkmn2.learn_move(:STEALTHROCK)
	pkmn2.learn_move(:HEADLONGRUSH)
	pkmn2.learn_move(:EGGBOMB)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :GRASS
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:ENAMORUS,30)
	pkmn3.item = :FOCUSSASH
	pkmn3.ability_index = 5 # QUEENLYMAJESTY
	pkmn3.nature = :MODEST
	pkmn3.learn_move(:MOONBLAST)
	pkmn3.learn_move(:EARTHPOWER)
	pkmn3.learn_move(:CALMMIND)
	pkmn3.learn_move(:TAUNT)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :GROUND
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:ROARINGMOON,30)
	pkmn4.item = :LIFEORB
	pkmn4.ability_index = 2 # INTIMIDATE
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:KNOCKOFF)
	pkmn4.learn_move(:PARTINGSHOT)
	pkmn4.learn_move(:DRAGONASCENT)
	pkmn4.learn_move(:IRONTAIL)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 220
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 36
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :STEEL
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:ZAMAZENTA,30)
	pkmn5.item = :RUSTEDSHIELD
	pkmn5.ability_index = 3 # BATTLEARMOR
	pkmn5.nature = :JOLLY
	pkmn5.learn_move(:BODYPRESS)
	pkmn5.learn_move(:CRUNCH)
	pkmn5.learn_move(:VICTORYDANCE)
	pkmn5.learn_move(:ROAR)
	pkmn5.ev[:HP] = 88
	pkmn5.iv[:ATTACK] = 0
	pkmn5.ev[:DEFENSE] = 252
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 172
	pkmn5.tera_type = :DRAGON
	pkmn5.dynamax_able = false
	pkmn5.calc_stats
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:OGERPON,30)
	pkmn6.item = :WELLSPRINGMASK
	pkmn6.nature = :JOLLY
	pkmn6.learn_move(:IVYCUDGEL)
	pkmn6.learn_move(:POWERWHIP)
	pkmn6.learn_move(:UTURN)
	pkmn6.learn_move(:ENCORE)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.iv[:SPECIAL_ATTACK] = 0
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen9WaterPartyQuickStart30 # Poke Paste: https://pokepast.es/2aaa84dab1d690bf
	pkmn1 = Pokemon.new(:QUAQUAVAL,30)
	pkmn1.item = :FOCUSSASH
	pkmn1.ability_index = 5 # DAZZLING
	pkmn1.nature = :JOLLY
	pkmn1.learn_move(:VICTORYDANCE)
	pkmn1.learn_move(:CLOSECOMAT)
	pkmn1.learn_move(:LIQUIDATION)
	pkmn1.learn_move(:ICESPINNER)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :STEEL
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:KINGDRA,30)
	pkmn2.item = :LIFEORB
	pkmn2.ability_index = 0 # SWIFTSWIM
	pkmn2.nature = :MODEST
	pkmn2.learn_move(:DRACOMETEOR)
	pkmn2.learn_move(:WEATHERBALL)
	pkmn2.learn_move(:MUDDYWATER)
	pkmn2.learn_move(:PROTECT)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :STELLAR
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:POLITOED,30)
	pkmn3.item = :HONEY
	pkmn3.ability_index = 4 # DRIZZLE
	pkmn3.nature = :BOLD
	pkmn3.learn_move(:WEATHERBALL)
	pkmn3.learn_move(:PERISHSONG)
	pkmn3.learn_move(:ENCORE)
	pkmn3.learn_move(:PROTECT)
	pkmn3.ev[:HP] = 256
	pkmn3.ev[:ATTACK] = 0
	pkmn3.ev[:DEFENSE] = 184
	pkmn3.ev[:SPECIAL_DEFENSE] = 72
	pkmn3.ev[:SPEED] = 0
	pkmn3.tera_type = :GRASS
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:GOTHITELLE,30)
	pkmn4.item = :LEFTOVERS
	pkmn4.ability_index = 3 # MAGICBOUNCE
	pkmn4.nature = :CALM
	pkmn4.learn_move(:PROTECT)
	pkmn4.learn_move(:PSYCHIC)
	pkmn4.learn_move(:FAKEOUT)
	pkmn4.learn_move(:TRICKROOM)
	pkmn4.ev[:HP] = 256
	pkmn4.ev[:DEFENSE] = 100
	pkmn4.ev[:SPECIAL_DEFENSE] = 156
	pkmn4.iv[:ATTACK] = 0
	pkmn4.tera_type = :DARK
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:INCINEROAR,30)
	pkmn5.item = :SAFETYGOGGLES
	pkmn5.ability_index = 0 # Intimidate
	pkmn5.nature = :CAREFUL
	pkmn5.learn_move(:FAKEOUT)
	pkmn5.learn_move(:PARTINGSHOT)
	pkmn5.learn_move(:KNOCKOFF)
	pkmn5.learn_move(:PROTECT)
	pkmn5.ev[:HP] = 244
	pkmn5.ev[:ATTACK] = 4
	pkmn5.ev[:DEFENSE] = 132
	pkmn5.ev[:SPECIAL_DEFENSE] = 84
	pkmn5.ev[:SPEED] = 48
	pkmn5.tera_type = :GHOST
	pkmn5.dynamax_able = false
	pkmn5.calc_stats
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:AMOONGUSS,30)
	pkmn6.item = :MENTALHERB
	pkmn6.ability_index = 3 # Regenerator
	pkmn6.nature = :BOLD
	pkmn6.learn_move(:PROTECT)
	pkmn6.learn_move(:RAGEPOWDER)
	pkmn6.learn_move(:SPORE)
	pkmn6.learn_move(:POLLENPUFF)
	pkmn6.ev[:HP] = 240
	pkmn6.ev[:DEFENSE] = 236
	pkmn6.ev[:SPECIAL_DEFENSE] = 36
	pkmn6.iv[:SPEED] = 0
	pkmn6.tera_type = :FAIRY
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen9FightingPartyQuickStart30 # Poke Paste: https://pokepast.es/74e2807d6251ac7c
	pkmn1 = Pokemon.new(:DECIDUEYE_1,30)
	pkmn1.item = :SCOPELENS
	pkmn1.ability_index = 3 # SCRAPPY
	pkmn1.nature = :JOLLY
	pkmn1.learn_move(:LEAFBLADE)
	pkmn1.learn_move(:TRIPLEARROWS)
	pkmn1.learn_move(:HAZE)
	pkmn1.learn_move(:PROTECT)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :FIRE
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:DRAGAPULT,30)
	pkmn2.item = :CHOICEBAND
	pkmn2.ability_index = 0 # PARENTALBOND
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:DRAGONDARTS)
	pkmn2.learn_move(:SHADOWFORCE)
	pkmn2.learn_move(:UTURN)
	pkmn2.learn_move(:PSYCHICFANGS)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :DRAGON
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:VOLCARONA,30)
	pkmn3.item = :HONEY
	pkmn3.ability_index = 0 # LEVITATE
	pkmn3.nature = :TIMID
	pkmn3.learn_move(:EMBER)
	pkmn3.learn_move(:GIGADRAIN)
	pkmn3.learn_move(:QUIVERDANCE)
	pkmn3.learn_move(:PROTECT)
	pkmn3.ev[:HP] = 248
	pkmn3.ev[:ATTACK] = 12
	pkmn3.ev[:DEFENSE] = 92
	pkmn3.ev[:SPECIAL_DEFENSE] = 28
	pkmn3.ev[:SPEED] = 132
	pkmn3.tera_type = :GRASS
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:HATTERENE,30)
	pkmn4.item = :LIFEORB
	pkmn4.ability_index = 0 # MAGICBOUNCE
	pkmn4.nature = :QUIET
	pkmn4.learn_move(:EXPANDINGFORCE)
	pkmn4.learn_move(:DAZZLINGGLEAM)
	pkmn4.learn_move(:TRICKROOM)
	pkmn4.learn_move(:PROTECT)
	pkmn4.ev[:HP] = 216
	pkmn4.ev[:ATTACK] = 204
	pkmn4.ev[:DEFENSE] = 68
	pkmn4.ev[:SPECIAL_DEFENSE] = 24
	pkmn4.iv[:ATTACK] = 0
	pkmn4.iv[:SPEED] = 0
	pkmn4.tera_type = :PSYCHIC
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:TYRANITAR,30)
	pkmn5.item = :ASSAULTVEST
	pkmn5.ability_index = 2 # SHEERFORCE
	pkmn5.nature = :SASSY
	pkmn5.learn_move(:ROCKSLIDE)
	pkmn5.learn_move(:KNOCKOFF)
	pkmn5.learn_move(:EGGBOMB)
	pkmn5.learn_move(:STRENGTH)
	pkmn5.ev[:HP] = 140
	pkmn5.ev[:ATTACK] = 252
	pkmn5.ev[:DEFENSE] = 4
	pkmn5.ev[:SPECIAL_DEFENSE] = 4
	pkmn5.ev[:SPEED] = 112
	pkmn5.tera_type = :FLYING
	pkmn5.dynamax_able = false
	pkmn5.calc_stats
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:INDEEDEE,30)
	pkmn6.makeMale # Only done for Male Indeede, to make sure the correct form sprite is used
	pkmn6.item = :LUMBERRY
	pkmn6.ability_index = 0 # PSYCHICSURGE
	pkmn6.nature = :RELAXED
	pkmn6.learn_move(:PSYCHIC)
	pkmn6.learn_move(:FOLLOWME)
	pkmn6.learn_move(:TRICKROOM)
	pkmn6.learn_move(:HELPINGHAND)
	pkmn6.ev[:HP] = 256
	pkmn6.ev[:ATTACK] = 0 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn6.ev[:DEFENSE] = 256
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :FAIRY
	pkmn6.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen9GhostPartyQuickStart30 # Poke Paste: https://pokepast.es/d0e936b567d7f639
	pkmn1 = Pokemon.new(:TYPHLOSION_1,30)
	pkmn1.item = :CHOICESCARF
	pkmn1.ability_index = 0 # SOULHEART
	pkmn1.nature = :TIMID
	pkmn1.learn_move(:OVERHEAT)
	pkmn1.learn_move(:ERUPTION)
	pkmn1.learn_move(:SHADOWBALL)
	pkmn1.learn_move(:HEATWAVE)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :FIRE
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:WEEZING_1,30)
	pkmn2.item = :CHOICESPECS
	pkmn2.ability_index = 2 # NEUTRALIZINGGAS
	pkmn2.nature = :MODEST
	pkmn2.learn_move(:EGGBOMB)
	pkmn2.learn_move(:STRANGESTEAM)
	pkmn2.learn_move(:DAZZLINGGLEAM)
	pkmn2.learn_move(:FLAMETHROWER)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :FLYING
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:GARCHOMP,30)
	pkmn3.item = :LIFEORB
	pkmn3.ability_index = 6 # HYPERCUTTER
	pkmn3.nature = :JOLLY
	pkmn3.learn_move(:PROTECT)
	pkmn3.learn_move(:SLASH)
	pkmn3.learn_move(:DRAGONCLAW)
	pkmn3.learn_move(:IRONTAIL)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :FIRE
	pkmn3.dynamax_able = false
	pkmn3.calc_stats
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:CORVIKNIGHT,30)
	pkmn4.item = :HONEY
	pkmn4.ability_index = 4 # MIRRORARMOR
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:DOUBLEEDGE)
	pkmn4.learn_move(:TAILWIND)
	pkmn4.learn_move(:ROOST)
	pkmn4.learn_move(:BULKUP)
	pkmn4.ev[:HP] = 252
	pkmn4.ev[:ATTACK] = 0
	pkmn4.ev[:DEFENSE] = 44
	pkmn4.ev[:SPECIAL_DEFENSE] = 144
	pkmn4.ev[:SPEED] = 72
	pkmn4.tera_type = :DRAGON
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:TOEDSCRUEL,30)
	pkmn5.item = :COVERTCLOAK
	pkmn5.ability_index = 5 # LONGREACH
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:EGGBOMB)
	pkmn5.learn_move(:ACIDSPRAY)
	pkmn5.learn_move(:STUNSPORE)
	pkmn5.learn_move(:RAGEPOWER)
	pkmn5.ev[:HP] = 180
	pkmn5.ev[:ATTACK] = 12
	pkmn5.ev[:DEFENSE] = 64
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :WATER
	pkmn5.dynamax_able = false
	pkmn5.calc_stats
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:BAXCALIBUR,30)
	pkmn6.item = :LOADEDDICE
	pkmn6.ability_index = 0 # THERMALEXCHANGE
	pkmn6.nature = :ADAMANT
	pkmn6.learn_move(:ICICLESPEAR)
	pkmn6.learn_move(:SCALESHOT)
	pkmn6.learn_move(:SWORDSDANCE)
	pkmn6.learn_move(:PROTECT)
	pkmn6.ev[:HP] = 256
	pkmn6.ev[:ATTACK] = 0 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.tera_type = :FAIRY
	pkmn6.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen9DarkPartyQuickStart30 # Poke Paste: https://pokepast.es/73c40bd837c0a2f0
	pkmn1 = Pokemon.new(:SAMUROTT_1,30)
	pkmn1.item = :ASSAULTVEST
	pkmn1.ability_index = 4 # SHARPNESS
	pkmn1.nature = :ADAMANT
	pkmn1.learn_move(:SLASH)
	pkmn1.learn_move(:RAZORSHELL)
	pkmn1.learn_move(:AQUAJET)
	pkmn1.learn_move(:CEASELESSEDGE)
	pkmn1.ev[:HP] = 248
	pkmn1.ev[:ATTACK] = 84
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 124
	pkmn1.ev[:SPEED] = 56
	pkmn1.tera_type = :FIRE
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:ZAMAZENTA,30)
	pkmn2.item = :RUSTEDSHIELD
	pkmn2.ability_index = 3 # BATTLEARMOR
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:BODYPRESS)
	pkmn2.learn_move(:STONEEDGE)
	pkmn2.learn_move(:VICTORYDANCE)
	pkmn2.learn_move(:IRONHEAD)
	pkmn2.ev[:HP] = 0
	pkmn2.iv[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :DRAGON
	pkmn2.dynamax_able = false
	pkmn2.calc_stats
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:CLEFABLE,30)
	pkmn3.item = :STICKYBARB
	pkmn3.ability_index = 2 # MAGICGUARD
	pkmn3.nature = :BOLD
	pkmn3.learn_move(:CALMMIND)
	pkmn3.learn_move(:FLAMETHROWER)
	pkmn3.learn_move(:MOONBLAST)
	pkmn3.learn_move(:MOONLIGHT)
	pkmn3.ev[:HP] = 252
	pkmn3.ev[:ATTACK] = 0
	pkmn3.ev[:DEFENSE] = 240
	pkmn3.ev[:SPECIAL_DEFENSE] = 8
	pkmn3.ev[:SPEED] = 20
	pkmn3.tera_type = :BUG
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:LANDORUS_1,30)
	pkmn4.item = :FOCUSSASH
	pkmn4.ability_index = 4 # INTIMIDATE
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:STEALTHROCK)
	pkmn4.learn_move(:EARTHQUAKE)
	pkmn4.learn_move(:SMACKDOWN)
	pkmn4.learn_move(:UTURN)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :GROUND
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:ROTOM_2,30)
	pkmn5.item = :COVERTCLOAK
	pkmn5.ability_index = 6 # SCREENCLEANER
	pkmn5.nature = :BOLD
	pkmn5.learn_move(:VOLTSWITCH)
	pkmn5.learn_move(:HYDROPUMP)
	pkmn5.learn_move(:SOAK)
	pkmn5.learn_move(:THUNDERWAVE)
	pkmn5.ev[:HP] = 256
	pkmn5.ev[:ATTACK] = 0
	pkmn5.ev[:DEFENSE] = 212
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 44
	pkmn5.tera_type = :FLYING
	pkmn5.dynamax_able = false
	pkmn5.calc_stats
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:DRAGAPULT,30)
	pkmn6.item = :HEAVYDUTYBOOTS
	pkmn6.ability_index = 6 # INFILTRATOR
	pkmn6.nature = :NAIVE
	pkmn6.learn_move(:DRAGONDARTS)
	pkmn6.learn_move(:HEX)
	pkmn6.learn_move(:WILLOWISP)
	pkmn6.learn_move(:UTURN)
	pkmn6.ev[:HP] = 60
	pkmn6.ev[:ATTACK] = 196
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.tera_type = :FAIRY
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoNormalPartyQuickStart30 # Poke Paste: https://pokepast.es/ac1b444e8fc174a9
	pkmn1 = Pokemon.new(:PIDGEOT,30)
	pkmn1.item = :HEAVYDUTYBOOTS
	pkmn1.ability_index = 3 # PICKUP
	pkmn1.nature = :IMPISH
	pkmn1.learn_move(:BRAVEBIRD)
	pkmn1.learn_move(:DEFOG)
	pkmn1.learn_move(:ROOST)
	pkmn1.learn_move(:UTURN)
	pkmn1.ev[:HP] = 252
	pkmn1.ev[:ATTACK] = 0
	pkmn1.ev[:DEFENSE] = 240
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 20
	pkmn1.tera_type = :FIGHTING
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:DITTO,30)
	pkmn2.item = :CHOICESCARF
	pkmn2.ability_index = 4 # IMPOSTER
	pkmn2.nature = :RELAXED
	pkmn2.learn_move(:TRANSFORM)
	pkmn2.ev[:HP] = 252
	pkmn2.iv[:ATTACK] = 8
	pkmn2.ev[:DEFENSE] = 252
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 0
	pkmn2.tera_type = :FAIRY
	pkmn2.dynamax_able = false
	pkmn2.calc_stats
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:TERAPAGOS,30)
	pkmn3.item = :WHITEHERB
	pkmn3.nature = :MODEST
	pkmn3.learn_move(:NORETREAT)
	pkmn3.learn_move(:SHELLSMASH)
	pkmn3.learn_move(:TAUNT)
	pkmn3.learn_move(:TERASTARSTORM)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:URSALUNA,30)
	pkmn4.item = :FLAMEORB
	pkmn4.ability_index = 0 # GUTS
	pkmn4.nature = :ADAMANT
	pkmn4.learn_move(:FACADE)
	pkmn4.learn_move(:HEADLONGRUSH)
	pkmn4.learn_move(:FIREPUNCH)
	pkmn4.learn_move(:SWORDSDANCE)
	pkmn4.ev[:HP] = 252
	pkmn4.ev[:ATTACK] = 252
	pkmn4.ev[:DEFENSE] = 8
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 0
	pkmn4.tera_type = :POISON
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:ZOROARK_1,30)
	pkmn5.item = :CHOICESPECS
	pkmn5.ability_index = 6 # INTIMIDATE
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:TRICK)
	pkmn5.learn_move(:MOONGEISTBEAM)
	pkmn5.learn_move(:HYPERBEAM)
	pkmn5.learn_move(:FOCUSBLAST)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :FAIRY
	pkmn5.dynamax_able = false
	pkmn5.calc_stats
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:BLISSEY,30)
	pkmn6.item = :LEFTOVERS
	pkmn6.ability_index = 3 # SCRAPPY
	pkmn6.nature = :BOLD
	pkmn6.learn_move(:SEISMICTOSS)
	pkmn6.learn_move(:SOFTBOILED)
	pkmn6.learn_move(:STEALTHROCK)
	pkmn6.learn_move(:THUNDERWAVE)
	pkmn6.ev[:HP] = 252
	pkmn6.ev[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 256
	pkmn6.ev[:SPECIAL_DEFENSE] = 4
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :GHOST
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoFightingPartyQuickStart30 # Poke Paste: https://pokepast.es/698aaabeafee46e1
	pkmn1 = Pokemon.new(:IRONVALIANT,30)
	pkmn1.item = :CHOICESCARF
	pkmn1.ability_index = 3 # SYNCHRONIZE
	pkmn1.nature = :NAIVE
	pkmn1.learn_move(:EGGBOMB)
	pkmn1.learn_move(:CLOSECOMAT)
	pkmn1.learn_move(:THUNDERBOLT)
	pkmn1.learn_move(:TRICK)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :GHOST
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:GREATTUSK,30)
	pkmn2.item = :ROCKYHELMET
	pkmn2.ability_index = 4 # THICKFAT 
	pkmn2.nature = :IMPISH
	pkmn2.learn_move(:EARTHQUAKE)
	pkmn2.learn_move(:VICTORYDANCE)
	pkmn2.learn_move(:KNOCKOFF)
	pkmn2.learn_move(:STEALTHROCK)
	pkmn2.ev[:HP] = 256
	pkmn2.ev[:ATTACK] = 0
	pkmn2.ev[:DEFENSE] = 156
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 100
	pkmn2.tera_type = :POISON
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:SCRAFTY,30)
	pkmn3.item = :LEFTOVERS
	pkmn3.ability_index = 2 # SHEDSKIN
	pkmn3.nature = :CAREFUL
	pkmn3.learn_move(:VICTORYDANCE)
	pkmn3.learn_move(:DRAINPUNCH)
	pkmn3.learn_move(:KNOCKOFF)
	pkmn3.learn_move(:REST)
	pkmn3.ev[:HP] = 252
	pkmn3.ev[:ATTACK] = 0
	pkmn3.ev[:DEFENSE] = 240
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 20
	pkmn3.tera_type = :FIGHTING
	pkmn3.dynamax_able = false
	pkmn3.calc_stats
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:IRONHANDS,30)
	pkmn4.item = :ASSAULTVEST
	pkmn4.ability_index = 2 # STEELWORKER
	pkmn4.nature = :CAREFUL
	pkmn4.learn_move(:DRAINPUNCH)
	pkmn4.learn_move(:ICEPUNCH)
	pkmn4.learn_move(:HEAVYSLAM)
	pkmn4.learn_move(:THUNDERPUNCH)
	pkmn4.ev[:HP] = 256
	pkmn4.ev[:ATTACK] = 4
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 252
	pkmn4.tera_type = :BUG
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:URSHIFU_1,30)
	pkmn5.item = :PUNCHINGGLOVE
	pkmn5.ability_index = 5 # TECHNICIAN
	pkmn5.nature = :JOLLY
	pkmn5.learn_move(:SURGINGSTRIKES)
	pkmn5.learn_move(:AQUAJET)
	pkmn5.learn_move(:VICTORYDANCE)
	pkmn5.learn_move(:TECHPOWERICE)
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.iv[:SPECIAL_ATTACK] = 0
	pkmn5.tera_type = :STELLAR
	pkmn5.dynamax_able = false
	pkmn5.calc_stats
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:SNEASLER,30)
	pkmn6.item = :AIRBALLOON
	pkmn6.ability_index = 0 # UNBURDEN
	pkmn6.nature = :ADAMANT
	pkmn6.learn_move(:EGGBOMB)
	pkmn6.learn_move(:CLOSECOMBAT)
	pkmn6.learn_move(:POISONTAIL)
	pkmn6.learn_move(:PROTECT)
	pkmn6.ev[:HP] = 144
	pkmn6.ev[:ATTACK] = 252
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 116
	pkmn6.tera_type = :DARK
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoFlyingPartyQuickStart30 # Poke Paste: https://pokepast.es/cb82e72f29563467
	pkmn1 = Pokemon.new(:SKARMORY,30)
	pkmn1.item = :ROCKYHELMET
	pkmn1.ability_index = 0 # BATTLEARMOR
	pkmn1.nature = :BOLD
	pkmn1.learn_move(:ROOST)
	pkmn1.learn_move(:IRONDEFENSE)
	pkmn1.learn_move(:WHIRLWIND)
	pkmn1.learn_move(:BODYPRESS)
	pkmn1.ev[:HP] = 256
	pkmn1.ev[:ATTACK] = 0
	pkmn1.ev[:DEFENSE] = 252
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 4
	pkmn1.tera_type = :GROUND
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:DRAGONITE,30)
	pkmn2.item = :CHOICEBAND
	pkmn2.ability_index = 0 # MULTISCALE 
	pkmn2.nature = :ADAMANT
	pkmn2.learn_move(:DRAGONASCENT)
	pkmn2.learn_move(:EXTREMESPEED)
	pkmn2.learn_move(:FIREPUNCH)
	pkmn2.learn_move(:EARTHQUAKE)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :FIGHTING
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:DODRIO,30)
	pkmn3.item = :LIFEORB
	pkmn3.ability_index = 5 # BIGPECKS
	pkmn3.nature = :JOLLY
	pkmn3.learn_move(:DOUBLEEDGE)
	pkmn3.learn_move(:SKYATTACK)
	pkmn3.learn_move(:KNOCKOFF)
	pkmn3.learn_move(:JUMPKICK)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :FIRE
	pkmn3.dynamax_able = false
	pkmn3.calc_stats
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:CORVIKNIGHT,30)
	pkmn4.item = :LEFTOVERS
	pkmn4.ability_index = 4 # MIRRORARMOR
	pkmn4.nature = :CAREFUL
	pkmn4.learn_move(:STEELWING)
	pkmn4.learn_move(:UTURN)
	pkmn4.learn_move(:DEFOG)
	pkmn4.learn_move(:ROOST)
	pkmn4.ev[:HP] = 252
	pkmn4.ev[:ATTACK] = 12
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 248
	pkmn4.tera_type = :DRAGON
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:TORNADUS_1,30)
	pkmn5.item = :ASSAULTVEST
	pkmn5.ability_index = 3 # REGENERATOR
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:UTURN)
	pkmn5.learn_move(:KNOCKOFF)
	pkmn5.learn_move(:AEROBLAST)
	pkmn5.learn_move(:HEATWAVE)
	pkmn5.ev[:HP] = 248
	pkmn5.ev[:ATTACK] = 0
	pkmn5.ev[:DEFENSE] = 12
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 252
	pkmn5.tera_type = :FLYING
	pkmn5.dynamax_able = false
	pkmn5.calc_stats
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:LANDORUS_1,30)
	pkmn6.item = :CHOICESCARF
	pkmn6.ability_index = 4 # INTIMIDATE
	pkmn6.nature = :JOLLY
	pkmn6.learn_move(:EARTHQUAKE)
	pkmn6.learn_move(:STONEEDGE)
	pkmn6.learn_move(:UTURN)
	pkmn6.learn_move(:STEALTHROCK)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.tera_type = :STEEL
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoPoisonPartyQuickStart30 # Poke Paste: https://pokepast.es/068863a5eb35a63c
	pkmn1 = Pokemon.new(:MUK_1,30)
	pkmn1.item = :BLACKSLUDGE
	pkmn1.ability_index = 0 # POISONTOUCH
	pkmn1.nature = :CAREFUL
	pkmn1.learn_move(:KNOCKOFF)
	pkmn1.learn_move(:DRAINPUNCH)
	pkmn1.learn_move(:POISONJAB)
	pkmn1.learn_move(:PROTECT)
	pkmn1.ev[:HP] = 256
	pkmn1.ev[:ATTACK] = 4
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 252
	pkmn1.ev[:SPEED] = 0
	pkmn1.tera_type = :POISON
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:SNEASLER,30)
	pkmn2.item = :AIRBALLOON
	pkmn2.ability_index = 0 # UNBURDEN
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:SWORDSDANCE)
	pkmn2.learn_move(:CLOSECOMBAT)
	pkmn2.learn_move(:EGGBOMB)
	pkmn2.learn_move(:ACROBATICS)
	pkmn2.ev[:HP] = 80
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 176
	pkmn2.tera_type = :DARK
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:SLOWKING_1,30)
	pkmn3.item = :ASSAULTVEST
	pkmn3.ability_index = 4 # REGENERATOR
	pkmn3.nature = :SASSY
	pkmn3.learn_move(:FUTURESIGHT)
	pkmn3.learn_move(:SLUDGEBOMB)
	pkmn3.learn_move(:ICEBEAM)
	pkmn3.learn_move(:FLAMETHROWER)
	pkmn3.ev[:HP] = 256
	pkmn3.ev[:ATTACK] = 60
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 196
	pkmn3.ev[:SPEED] = 0
	pkmn3.tera_type = :FLYING
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:CLODSIRE,30)
	pkmn4.item = :HEAVYDUTYBOOTS
	pkmn4.ability_index = 0 # UNAWARE
	pkmn4.nature = :IMPISH
	pkmn4.learn_move(:STEALTHROCK)
	pkmn4.learn_move(:RAPIDSPIN)
	pkmn4.learn_move(:TOXIC)
	pkmn4.learn_move(:RECOVER)
	pkmn4.ev[:HP] = 256
	pkmn4.ev[:ATTACK] = 0 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn4.ev[:DEFENSE] = 232
	pkmn4.ev[:SPECIAL_DEFENSE] = 24
	pkmn4.ev[:SPEED] = 0
	pkmn4.tera_type = :ICE
	pkmn4.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:IRONMOTH,30)
	pkmn5.item = :CHOICESPECS
	pkmn5.ability_index = 4 # SHADOWSHIELD
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:EGGBOMB)
	pkmn5.learn_move(:OVERHEAT)
	pkmn5.learn_move(:ENERGYBALL)
	pkmn5.learn_move(:THUNDERBOLT)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :FIRE
	pkmn5.dynamax_able = false
	pkmn5.calc_stats
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:WEEZING_1,30)
	pkmn6.item = :POWERHERB
	pkmn6.ability_index = 0 # LEVITATE
	pkmn6.nature = :BOLD
	pkmn6.learn_move(:GEOMANCY)
	pkmn6.learn_move(:DEFOG)
	pkmn6.learn_move(:WILLOWISP)
	pkmn6.learn_move(:MOONBLAST)
	pkmn6.ev[:HP] = 252
	pkmn6.ev[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 252
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 8
	pkmn6.tera_type = :ELECTRIC
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoGroundPartyQuickStart30 # Poke Paste: https://pokepast.es/0862ad1d0d311051
	pkmn1 = Pokemon.new(:HIPPOWDON,30)
	pkmn1.item = :EJECTBUTTON
	pkmn1.ability_index = 2 # SANDSTREAM
	pkmn1.nature = :IMPISH
	pkmn1.learn_move(:EARTHQUAKE)
	pkmn1.learn_move(:SLACKOFF)
	pkmn1.learn_move(:STEALTHROCK)
	pkmn1.learn_move(:WHIRLWIND)
	pkmn1.ev[:HP] = 256
	pkmn1.ev[:ATTACK] = 0
	pkmn1.ev[:DEFENSE] = 256
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 0
	pkmn1.tera_type = :POISON
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:EXCADRILL,30)
	pkmn2.item = :ASSAULTVEST
	pkmn2.ability_index = 2 # SANDFORCE
	pkmn2.nature = :ADAMANT
	pkmn2.learn_move(:RAPIDSPIN)
	pkmn2.learn_move(:EARTHQUAKE)
	pkmn2.learn_move(:ROCKCLIMB)
	pkmn2.learn_move(:SHADOWCLAW)
	pkmn2.ev[:HP] = 80
	pkmn2.ev[:ATTACK] = 176
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :FAIRY
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:LANDORUS,30)
	pkmn3.item = :LIFEORB
	pkmn3.ability_index = 2 # SHEERFORCE
	pkmn3.nature = :TIMID
	pkmn3.learn_move(:EARTHPOWER)
	pkmn3.learn_move(:FOCUSBLAST)
	pkmn3.learn_move(:PSYCHIC)
	pkmn3.learn_move(:GRAVITY)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :ICE
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:MAMOSWINE,30)
	pkmn4.item = :CHOICEBAND
	pkmn4.ability_index = 4 # SANDRUSH
	pkmn4.nature = :ADAMANT
	pkmn4.learn_move(:EGGBOMB)
	pkmn4.learn_move(:HEADLONGRUSH)
	pkmn4.learn_move(:ICESHARD)
	pkmn4.learn_move(:KNOCKOFF)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :FIRE
	pkmn4.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:CLODSIRE,30)
	pkmn5.item = :HEAVYDUTYBOOTS
	pkmn5.ability_index = 3 # WATERABSORB
	pkmn5.nature = :CAREFUL
	pkmn5.learn_move(:STEALTHROCK)
	pkmn5.learn_move(:SANDATTACK)
	pkmn5.learn_move(:MORTALSPIN)
	pkmn5.learn_move(:RECOVER)
	pkmn5.ev[:HP] = 252
	pkmn5.ev[:ATTACK] = 8 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 252
	pkmn5.ev[:SPEED] = 0
	pkmn5.tera_type = :DARK
	pkmn5.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:SANDYSHOCKS,30)
	pkmn6.item = :WEAKNESSPOLICY
	pkmn6.ability_index = 6 # FILTER
	pkmn6.nature = :TIMID
	pkmn6.learn_move(:EGGBOMB)
	pkmn6.learn_move(:THUNDERCLAP)
	pkmn6.learn_move(:GRAVITY)
	pkmn6.learn_move(:VOLTSWITCH)
	pkmn6.ev[:HP] = 52
	pkmn6.ev[:ATTACK] = 208
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 252
	pkmn6.tera_type = :ELECTRIC
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoRockPartyQuickStart30 # Poke Paste: https://pokepast.es/173aac7252c7b758
	pkmn1 = Pokemon.new(:IRONBOULDER,30)
	pkmn1.item = :CHOICESCARF
	pkmn1.ability_index = 2 # SHARPNESS
	pkmn1.nature = :JOLLY
	pkmn1.learn_move(:MIGHTYCLEAVE)
	pkmn1.learn_move(:PSYCHOCUT)
	pkmn1.learn_move(:SACREDSWORD)
	pkmn1.learn_move(:SLASH)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :FIRE
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:ARCANINE_1,30)
	pkmn2.item = :HEAVYDUTYBOOTS
	pkmn2.ability_index = 3 # ROCKHEAD
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:FLAREBLITZ)
	pkmn2.learn_move(:HEADSMASH)
	pkmn2.learn_move(:CLOSECOMAT)
	pkmn2.learn_move(:SUBSTITUTE)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :ROCK
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:GLIMMORA,30)
	pkmn3.item = :CHOICESPECS
	pkmn3.ability_index = 4 # LEVITATE
	pkmn3.nature = :TIMID
	pkmn3.learn_move(:HYPERBEAM)
	pkmn3.learn_move(:SLUDGEBOMB)
	pkmn3.learn_move(:ENERGYBALL)
	pkmn3.learn_move(:EARTHPOWER)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :ELECTRIC
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:MINIOR,30)
	pkmn4.item = :WHITEHERB
	pkmn4.ability_index = 0 # SHIELDSDOWN
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:EGGBOMB)
	pkmn4.learn_move(:STONEEDGE)
	pkmn4.learn_move(:EARTHQUAKE)
	pkmn4.learn_move(:SHELLSMASH)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :WATER
	pkmn4.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:GARGANACL,30)
	pkmn5.item = :LEFTOVERS
	pkmn5.ability_index = 0 # ROUGHSKIN
	pkmn5.nature = :CAREFUL
	pkmn5.learn_move(:STEALTHROCK)
	pkmn5.learn_move(:PROTECT)
	pkmn5.learn_move(:RECOVER)
	pkmn5.learn_move(:SALTCURE)
	pkmn5.ev[:HP] = 256
	pkmn5.ev[:ATTACK] = 0 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 256
	pkmn5.ev[:SPEED] = 0
	pkmn5.tera_type = :GHOST
	pkmn5.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:OGERPON,30)
	pkmn6.item = :CORNERSTONEMASK
	pkmn6.nature = :JOLLY
	pkmn6.learn_move(:IVYCUDGEL)
	pkmn6.learn_move(:HORNLEECH)
	pkmn6.learn_move(:SWORDSDANCE)
	pkmn6.learn_move(:SUPERPOWER)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.iv[:SPECIAL_ATTACK] = 0
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoBugPartyQuickStart30 # Poke Paste: https://pokepast.es/0a6ff83acecfc3b9
	pkmn1 = Pokemon.new(:VOLCARONA,30)
	pkmn1.item = :LEFTOVERS
	pkmn1.ability_index = 5 # FLASHFIRE
	pkmn1.nature = :TIMID
	pkmn1.learn_move(:QUIVERDANCE)
	pkmn1.learn_move(:EMBER)
	pkmn1.learn_move(:MORNINGSUN)
	pkmn1.learn_move(:PSYCHIC)
	pkmn1.ev[:HP] = 256
	pkmn1.ev[:ATTACK] = 28
	pkmn1.ev[:DEFENSE] = 176
	pkmn1.ev[:SPECIAL_DEFENSE] = 52
	pkmn1.ev[:SPEED] = 0
	pkmn1.tera_type = :POISON
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:FORRETRESS,30)
	pkmn2.item = :ROCKYHELMET
	pkmn2.ability_index = 6 # BATTLEARMOR
	pkmn2.nature = :IMPISH
	pkmn2.learn_move(:THUNDERWAVE)
	pkmn2.learn_move(:VOLTSWITCH)
	pkmn2.learn_move(:RAPIDSPIN)
	pkmn2.learn_move(:ICESPINNER)
	pkmn2.ev[:HP] = 256
	pkmn2.ev[:ATTACK] = 0
	pkmn2.ev[:DEFENSE] = 256
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 0
	pkmn2.tera_type = :ROCK
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:SCIZOR,30)
	pkmn3.item = :MEGAITE
	pkmn3.ability_index = 4 # INTIMIDATE
	pkmn3.nature = :ADAMANT
	pkmn3.learn_move(:SWORDSDANCE)
	pkmn3.learn_move(:BULLETPUNCH)
	pkmn3.learn_move(:KNOCKOFF)
	pkmn3.learn_move(:TRAILBLAZE)
	pkmn3.ev[:HP] = 124
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 132
	pkmn3.tera_type = :FIRE
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:KLEAVOR,30)
	pkmn4.item = :CHOICESCARF
	pkmn4.ability_index = 2 # SHARPNESS
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:STONEAXE)
	pkmn4.learn_move(:UTURN)
	pkmn4.learn_move(:NIGHTSLASH)
	pkmn4.learn_move(:SLASH)
	pkmn4.ev[:HP] = 256
	pkmn4.ev[:ATTACK] = 28
	pkmn4.ev[:DEFENSE] = 176
	pkmn4.ev[:SPECIAL_DEFENSE] = 52
	pkmn4.ev[:SPEED] = 0
	pkmn4.tera_type = :FIGHTING
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:YANMEGA,30)
	pkmn5.item = :CHOICESPECS
	pkmn5.ability_index = 5 # TINTEDLENS
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:AEROBLAST)
	pkmn5.learn_move(:EGGBOMB)
	pkmn5.learn_move(:DRACOMETEOR)
	pkmn5.learn_move(:UTURN)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :STEEL
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:ARAQUANID,30)
	pkmn6.item = :MENTALHERB
	pkmn6.ability_index = 0 # WATERBUBBLE
	pkmn6.nature = :ADAMANT
	pkmn6.learn_move(:LIQUIDATION)
	pkmn6.learn_move(:INFESTATION)
	pkmn6.learn_move(:STICKYWEB)
	pkmn6.learn_move(:MIRRORCOAT)
	pkmn6.ev[:HP] = 252
	pkmn6.ev[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 252
	pkmn6.ev[:SPECIAL_DEFENSE] = 8
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :GHOST
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoGhostPartyQuickStart30 # Poke Paste: https://pokepast.es/34eef7480aca0e56
	pkmn1 = Pokemon.new(:GHOLDENGO,30)
	pkmn1.item = :AIRBALLOON
	pkmn1.ability_index = 5 # PRANKSTER
	pkmn1.nature = :MODEST
	pkmn1.learn_move(:NASTYPLOT)
	pkmn1.learn_move(:SHADOWBALL)
	pkmn1.learn_move(:RECOVER)
	pkmn1.learn_move(:EGGBOMB)
	pkmn1.ev[:HP] = 136
	pkmn1.ev[:ATTACK] = 148
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 228
	pkmn1.tera_type = :FAIRY
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:CERULEDGE,30)
	pkmn2.item = :FOCUSSASH
	pkmn2.ability_index = 2 # WEAKARMOR
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:EGGBOMB)
	pkmn2.learn_move(:SACREDFIRE)
	pkmn2.learn_move(:SHADOWSNEAK)
	pkmn2.learn_move(:SWORDSDANCE)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :FIGHTING
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:FLUTTERMANE,30)
	pkmn3.item = :CHOICESPECS
	pkmn3.ability_index = 3 # INTIMIDATE
	pkmn3.nature = :TIMID
	pkmn3.learn_move(:EGGBOMB)
	pkmn3.learn_move(:MOONBLAST)
	pkmn3.learn_move(:THUNDERBOLT)
	pkmn3.learn_move(:POWERGEM)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :STELLAR
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:SPECTRIER,30)
	pkmn4.item = :LEFTOVERS
	pkmn4.ability_index = 5 # SHADOWSHIELD
	pkmn4.nature = :TIMID
	pkmn4.learn_move(:CALMMIND)
	pkmn4.learn_move(:SUBSTITUTE)
	pkmn4.learn_move(:WILLOWISP)
	pkmn4.learn_move(:HEX)
	pkmn4.ev[:HP] = 188
	pkmn4.ev[:ATTACK] = 0
	pkmn4.ev[:DEFENSE] = 124
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 200
	pkmn4.tera_type = :POISON
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:DRAGAPULT,30)
	pkmn5.item = :CHOICESCARF
	pkmn5.ability_index = 6 # INFILTRATOR
	pkmn5.nature = :NAIVE
	pkmn5.learn_move(:DRAGONDARTS)
	pkmn5.learn_move(:SHADOWBALL)
	pkmn5.learn_move(:UTURN)
	pkmn5.learn_move(:THUNDERWAVE)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :ELECTRIC
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:BRAMBLEGHAST,30)
	pkmn6.item = :ROCKYHELMET
	pkmn6.ability_index = 2 # IRONBARBS
	pkmn6.nature = :IMPISH
	pkmn6.learn_move(:SPIKES)
	pkmn6.learn_move(:RAPIDSPIN)
	pkmn6.learn_move(:STRENGTHSAP)
	pkmn6.learn_move(:SAPPYSEED)
	pkmn6.ev[:HP] = 256
	pkmn6.ev[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 240
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 16
	pkmn6.tera_type = :WATER
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoSteelPartyQuickStart30 # Poke Paste: https://pokepast.es/5b4e5ca4bee4d04d
	pkmn1 = Pokemon.new(:GHOLDENGO,30)
	pkmn1.item = :MENTALHERB
	pkmn1.ability_index = 5 # PRANKSTER
	pkmn1.nature = :MODEST
	pkmn1.learn_move(:NASTYPLOT)
	pkmn1.learn_move(:SHADOWBALL)
	pkmn1.learn_move(:RECOVER)
	pkmn1.learn_move(:EGGBOMB)
	pkmn1.ev[:HP] = 192
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 64
	pkmn1.tera_type = :FAIRY
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:HEATRAN,30)
	pkmn2.item = :AIRBALLOON
	pkmn2.ability_index = 6 # ROCKYPAYLOAD
	pkmn2.nature = :CALM
	pkmn2.learn_move(:ANCIENTPOWER)
	pkmn2.learn_move(:EARTHPOWER)
	pkmn2.learn_move(:LAVAPLUME)
	pkmn2.learn_move(:SLACKOFF)
	pkmn2.ev[:HP] = 228
	pkmn2.ev[:ATTACK] = 0
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 240
	pkmn2.ev[:SPEED] = 44
	pkmn2.tera_type = :GRASS
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:SKARMORY,30)
	pkmn3.item = :ROCKYHELMET
	pkmn3.ability_index = 5 # MIRRORARMOR
	pkmn3.nature = :BOLD
	pkmn3.learn_move(:SPIKES)
	pkmn3.learn_move(:ROOST)
	pkmn3.learn_move(:WHIRLWIND)
	pkmn3.learn_move(:BODYPRESS)
	pkmn3.ev[:HP] = 244
	pkmn3.ev[:ATTACK] = 0
	pkmn3.ev[:DEFENSE] = 172
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 96
	pkmn3.tera_type = :GROUND
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:ARCHALUDON,30)
	pkmn4.item = :CHOICESCARF
	pkmn4.ability_index = 0 # STAMINA
	pkmn4.nature = :TIMID
	pkmn4.learn_move(:BODYPRESS)
	pkmn4.learn_move(:DRACOMETEOR)
	pkmn4.learn_move(:HYPERBEAM)
	pkmn4.learn_move(:THUNDERBOLT)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :FLYING
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:IRONTREADS,30)
	pkmn5.item = :ASSAULTVEST
	pkmn5.ability_index = 3 # FILTER
	pkmn5.nature = :JOLLY
	pkmn5.learn_move(:RAPIDSPIN)
	pkmn5.learn_move(:KNOCKOFF)
	pkmn5.learn_move(:EARTHQUAKE)
	pkmn5.learn_move(:ICESPINNER)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :GHOST
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:SCIZOR,30)
	pkmn6.item = :POWERHERB
	pkmn6.ability_index = 0 # FULLMETALBODY
	pkmn6.nature = :ADAMANT
	pkmn6.learn_move(:GEOMANCY)
	pkmn6.learn_move(:SWORDSDANCE)
	pkmn6.learn_move(:DOUBLEHIT)
	pkmn6.learn_move(:FIRSTIMPRESSION)
	pkmn6.ev[:HP] = 252
	pkmn6.ev[:ATTACK] = 252
	pkmn6.ev[:DEFENSE] = 4
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 4
	pkmn6.tera_type = :FIRE
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoFirePartyQuickStart30 # Poke Paste: https://pokepast.es/57e510e3bdaf5c06
	pkmn1 = Pokemon.new(:CINDERACE,30)
	pkmn1.item = :MEGAITE
	pkmn1.ability_index = 4 # LIMBER
	pkmn1.nature = :JOLLY
	pkmn1.learn_move(:GIGAIMPACT)
	pkmn1.learn_move(:GUNKSHOT)
	pkmn1.learn_move(:HIGHJUMPKICK)
	pkmn1.learn_move(:UTURN)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :GRASS
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:CERULEDGE,30)
	pkmn2.item = :FOCUSSASH
	pkmn2.ability_index = 2 # WEAKARMOR
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:EGGBOMB)
	pkmn2.learn_move(:SACREDFIRE)
	pkmn2.learn_move(:SHADOWSNEAK)
	pkmn2.learn_move(:SWORDSDANCE)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :FIGHTING
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:TALONFLAME,30)
	pkmn3.item = :HEAVYDUTYBOOTS
	pkmn3.ability_index = 5 # FLAMEBODY
	pkmn3.nature = :TIMID
	pkmn3.learn_move(:AEROBLAST)
	pkmn3.learn_move(:UTURN)
	pkmn3.learn_move(:DEFOG)
	pkmn3.learn_move(:ROOST)
	pkmn3.ev[:HP] = 128
	pkmn3.ev[:ATTACK] = 0
	pkmn3.ev[:DEFENSE] = 252
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 132
	pkmn3.tera_type = :FAIRY
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:OGERPON,100)
	pkmn4.item = :HEARTHFLAMEMASK
	pkmn4.nature = :ADAMANT
	pkmn4.learn_move(:IVYCUDGEL)
	pkmn4.learn_move(:HORNLEECH)
	pkmn4.learn_move(:SWORDSDANCE)
	pkmn4.learn_move(:SUBSTITUTE)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.iv[:SPECIAL_ATTACK] = 0
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:VOLCANION,30)
	pkmn5.item = :HEATROCK
	pkmn5.ability_index = 3 # DROUGHT
	pkmn5.nature = :MODEST
	pkmn5.learn_move(:BLASTBURN)
	pkmn5.learn_move(:EARTHPOWER)
	pkmn5.learn_move(:SLUDGEBOMB)
	pkmn5.learn_move(:WHIRLPOOL)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :GROUND
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:HEATRAN,30)
	pkmn6.item = :LEFTOVERS
	pkmn6.ability_index = 0 # EARTHEATER
	pkmn6.nature = :CALM
	pkmn6.learn_move(:MAGMASTORM)
	pkmn6.learn_move(:EGGBOMB)
	pkmn6.learn_move(:EARTHPOWER)
	pkmn6.learn_move(:STEALTHROCK)
	pkmn6.ev[:HP] = 140
	pkmn6.ev[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 252
	pkmn6.ev[:SPEED] = 120
	pkmn6.tera_type = :ELECTRIC
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoWaterPartyQuickStart30 # Poke Paste: https://pokepast.es/46ba59df3fbabee0
	pkmn1 = Pokemon.new(:GRENINJA,30)
	pkmn1.item = :MEGAITE
	pkmn1.ability_index = 0 # PROTEAN
	pkmn1.nature = :TIMID
	pkmn1.learn_move(:HYDROCANNON)
	pkmn1.learn_move(:EGGBOMB)
	pkmn1.learn_move(:ICEBEAM)
	pkmn1.learn_move(:EXTRASENSORY)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :WATER
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:SUICUNE,30)
	pkmn2.item = :LEFTOVERS
	pkmn2.ability_index = 2 # PRESSURE
	pkmn2.nature = :BOLD
	pkmn2.learn_move(:SUBSTITUTE)
	pkmn2.learn_move(:CALMMIND)
	pkmn2.learn_move(:SCALD)
	pkmn2.learn_move(:REST)
	pkmn2.ev[:HP] = 256
	pkmn2.ev[:ATTACK] = 0
	pkmn2.ev[:DEFENSE] = 256
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 0
	pkmn2.tera_type = :FAIRY
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:TOXAPEX,30)
	pkmn3.item = :BINDINGBAND
	pkmn3.ability_index = 0 # TOXICDEBRIS
	pkmn3.nature = :BOLD
	pkmn3.learn_move(:TOXIC)
	pkmn3.learn_move(:HAZE)
	pkmn3.learn_move(:RECOVER)
	pkmn3.learn_move(:WHIRLPOOL)
	pkmn3.ev[:HP] = 256
	pkmn3.ev[:ATTACK] = 0
	pkmn3.ev[:DEFENSE] = 252
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 4
	pkmn3.tera_type = :DARK
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:EMPOLEON,100)
	pkmn4.item = :AIRBALLOON
	pkmn4.nature = :CALM
	pkmn4.learn_move(:STEALTHROCK)
	pkmn4.learn_move(:EGGBOMB)
	pkmn4.learn_move(:ROOST)
	pkmn4.learn_move(:ROAR)
	pkmn4.ev[:HP] = 256
	pkmn4.ev[:ATTACK] = 4
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 252
	pkmn4.ev[:SPEED] = 0
	pkmn4.tera_type = :GROUND
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:GASTRODON,30)
	pkmn5.item = :MENTALHERB
	pkmn5.ability_index = 6 # SHELLARMOR
	pkmn5.nature = :CALM
	pkmn5.learn_move(:SPIKES)
	pkmn5.learn_move(:EGGBOMB)
	pkmn5.learn_move(:HEALBELL)
	pkmn5.learn_move(:LUNARBLESSING)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :POISON
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:ALOMOMOLA,30)
	pkmn6.item = :GRIPCLAW
	pkmn6.ability_index = 0 # REGENERATOR
	pkmn6.nature = :SASSY
	pkmn6.learn_move(:FLIPTURN)
	pkmn6.learn_move(:WISH)
	pkmn6.learn_move(:PROTECT)
	pkmn6.learn_move(:WHIRLPOOL)
	pkmn6.ev[:HP] = 256
	pkmn6.ev[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 256
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :STEEL
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoGrassPartyQuickStart30 # Poke Paste: https://pokepast.es/4a7c53b5a7815701
	pkmn1 = Pokemon.new(:RILLABOOM,30)
	pkmn1.item = :MEGAITE
	pkmn1.ability_index = 5 # INTIMIDATE
	pkmn1.nature = :JOLLY
	pkmn1.learn_move(:DOUBLEHIT)
	pkmn1.learn_move(:KNOCKOFF)
	pkmn1.learn_move(:BODYPRESS)
	pkmn1.learn_move(:VICTORYDANCE)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :GRASS
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:MEOWSCARADA,30)
	pkmn2.item = :CHOICESCARF
	pkmn2.ability_index = 2 # BATTLEBOND
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:FLOWERTRICK)
	pkmn2.learn_move(:KNOCKOFF)
	pkmn2.learn_move(:PLAYROUGH)
	pkmn2.learn_move(:UTURN)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :GHOST
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:SINISTCHA,30)
	pkmn3.item = :LEFTOVERS
	pkmn3.ability_index = 0 # HEATPROOF
	pkmn3.nature = :BOLD
	pkmn3.learn_move(:CALMMIND)
	pkmn3.learn_move(:STRENGTHSAP)
	pkmn3.learn_move(:SHADOWBALL)
	pkmn3.learn_move(:MATCHAGOTHA)
	pkmn3.ev[:HP] = 252
	pkmn3.ev[:ATTACK] = 0
	pkmn3.ev[:DEFENSE] = 160
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 100
	pkmn3.tera_type = :POISON
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:OGERPON,100)
	pkmn4.item = :HEARTHFLAMEMASK
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:IVYCUDGEL)
	pkmn4.learn_move(:HORNLEECH)
	pkmn4.learn_move(:SWORDSDANCE)
	pkmn4.learn_move(:PLAYROUGH)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.iv[:SPECIAL_ATTACK] = 0
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:WHIMSICOTT,30)
	pkmn5.item = :PIXIEPLATE
	pkmn5.ability_index = 0 # PRANKSTER
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:MOONBLAST)
	pkmn5.learn_move(:ENERGYBALL)
	pkmn5.learn_move(:UTURN)
	pkmn5.learn_move(:MEMENTO)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :FLYING
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:AMOONGUSS,30)
	pkmn6.item = :ROCKYHELMET
	pkmn6.ability_index = 3 # Regenerator
	pkmn6.nature = :CALM
	pkmn6.learn_move(:FOULPLAY)
	pkmn6.learn_move(:SLUDGEBOMB)
	pkmn6.learn_move(:SYNTHESIS)
	pkmn6.learn_move(:SPORE)
	pkmn6.ev[:HP] = 244
	pkmn6.ev[:DEFENSE] = 164
	pkmn6.ev[:SPECIAL_DEFENSE] = 104
	pkmn6.iv[:SPEED] = 0
	pkmn6.tera_type = :FAIRY
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoElectricPartyQuickStart30 # Poke Paste: https://pokepast.es/240c891d4149ca55
	pkmn1 = Pokemon.new(:RAGINGBOLT,30)
	pkmn1.item = :ELECTRICSEED
	pkmn1.ability_index = 4 # INTIMIDATE
	pkmn1.nature = :MODEST
	pkmn1.learn_move(:THUNDER)
	pkmn1.learn_move(:EGGBOMB)
	pkmn1.learn_move(:THUNDERCLAP)
	pkmn1.learn_move(:CALMMIND)
	pkmn1.ev[:HP] = 124
	pkmn1.ev[:ATTACK] = 252
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 136
	pkmn1.tera_type = :BUG
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:IRONHANDS,30)
	pkmn2.item = :ASSAULTVEST
	pkmn2.ability_index = 0 # QUARKDRIVE
	pkmn2.nature = :CAREFUL
	pkmn2.learn_move(:DRAINPUNCH)
	pkmn2.learn_move(:WILDCHARGE)
	pkmn2.learn_move(:HEAVYSLAM)
	pkmn2.learn_move(:VOLTSWITCH)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 136
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 208
	pkmn2.ev[:SPEED] = 168
	pkmn2.tera_type = :GRASS
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:ROTOM_2,30)
	pkmn3.item = :DAMPROCK
	pkmn3.ability_index = 3 # DRIZZLE
	pkmn3.nature = :BOLD
	pkmn3.learn_move(:SOAK)
	pkmn3.learn_move(:HYDROPUMP)
	pkmn3.learn_move(:VOLTSWITCH)
	pkmn3.learn_move(:FOULPLAY)
	pkmn3.ev[:HP] = 248
	pkmn3.ev[:ATTACK] = 0
	pkmn3.ev[:DEFENSE] = 212
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 52
	pkmn3.tera_type = :WATER
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:REGIELEKI,100)
	pkmn4.item = :HEAVYDUTYBOOTS
	pkmn3.ability_index = 0 # ELECTRICSURGE
	pkmn4.nature = :TIMID
	pkmn4.learn_move(:THUNDER)
	pkmn4.learn_move(:VOLTSWITCH)
	pkmn4.learn_move(:RAPIDSPIN)
	pkmn4.learn_move(:THUNDERWAVE)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :ROCK
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:SANDYSHOCKS,30)
	pkmn5.item = :BOOSTERENERGY
	pkmn5.ability_index = 0 # PROTOSYNTHESIS
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:SPIKES)
	pkmn5.learn_move(:VOLTSWITCH)
	pkmn5.learn_move(:STEALTHROCK)
	pkmn5.learn_move(:EGGBOMB)
	pkmn5.ev[:HP] = 52
	pkmn5.ev[:ATTACK] = 208
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 252
	pkmn5.tera_type = :ICE
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:ZAPDOS,30)
	pkmn6.item = :LEFTOVERS
	pkmn6.ability_index = 4 # DELTASTREAM
	pkmn6.nature = :MODEST
	pkmn6.learn_move(:THUNDER)
	pkmn6.learn_move(:AEROBLAST)
	pkmn6.learn_move(:AGILITY)
	pkmn6.learn_move(:BATONPASS)
	pkmn6.ev[:HP] = 140
	pkmn6.ev[:ATTACK] = 252
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 120
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :FLYING
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoPsychicPartyQuickStart30 # Poke Paste: https://pokepast.es/d71fa8f1e1e7d611
	pkmn1 = Pokemon.new(:SLOWKING,30)
	pkmn1.item = :KASIBBERRY
	pkmn1.ability_index = 0 # REGENERATOR
	pkmn1.nature = :BOLD
	pkmn1.learn_move(:KINESIS)
	pkmn1.learn_move(:SCALD)
	pkmn1.learn_move(:THUNDERWAVE)
	pkmn1.learn_move(:LUNARBLESSING)
	pkmn1.ev[:HP] = 256
	pkmn1.ev[:ATTACK] = 0
	pkmn1.ev[:DEFENSE] = 256
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 0
	pkmn1.tera_type = :FAIRY
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:HATTERENE,30)
	pkmn2.item = :TERRAINEXTENDER
	pkmn2.ability_index = 3 # PSYCHICSURGE
	pkmn2.nature = :BOLD
	pkmn2.learn_move(:CALMMIND)
	pkmn2.learn_move(:PSYSHOCK)
	pkmn2.learn_move(:DRAININGKISS)
	pkmn2.learn_move(:GIGADRAIN)
	pkmn2.ev[:HP] = 256
	pkmn2.ev[:ATTACK] = 0
	pkmn2.ev[:DEFENSE] = 204
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 52
	pkmn2.tera_type = :WATER
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:HOOPA_1,30)
	pkmn3.item = :PSYCHICSEED
	pkmn3.ability_index = 4 # INTIMIDATE
	pkmn3.nature = :MILD
	pkmn3.learn_move(:EXPANDINGFORCE)
	pkmn3.learn_move(:KNOCKOFF)
	pkmn3.learn_move(:FOCUSBLAST)
	pkmn3.learn_move(:THUNDERBOLT)
	pkmn3.ev[:HP] = 240
	pkmn3.ev[:ATTACK] = 16
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 156
	pkmn3.ev[:SPEED] = 100
	pkmn3.tera_type = :POISON
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:IRONBOULDER,30)
	pkmn4.item = :RAZORCLAW
	pkmn3.ability_index = 2 # SHARPNESS
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:SWORDSDANCE)
	pkmn4.learn_move(:TAUNT)
	pkmn4.learn_move(:MIGHTYCLEAVE)
	pkmn4.learn_move(:EARTHQUAKE)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :ROCK
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:LATIOS,30)
	pkmn5.item = :MEGAITE
	pkmn5.ability_index = 0 # SPEEDBOOST
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:EXTRASENSORY)
	pkmn5.learn_move(:DRACOMETEOR)
	pkmn5.learn_move(:THUNDERBOLT)
	pkmn5.learn_move(:ICEBEAM)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :DRAGON
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:JIRACHI,30)
	pkmn6.item = :CHOICESCARF
	pkmn6.ability_index = 6 # MAGICBOUNCE
	pkmn6.nature = :JOLLY
	pkmn6.learn_move(:UTURN)
	pkmn6.learn_move(:BODYSLAM)
	pkmn6.learn_move(:STEALTHROCK)
	pkmn6.learn_move(:HEALINGWISH)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.tera_type = :FLYING
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoIcePartyQuickStart30 # Poke Paste: https://pokepast.es/9373088a9c4e8a75
	pkmn1 = Pokemon.new(:SANDSLASH_1,30)
	pkmn1.item = :HEAVYDUTYBOOTS
	pkmn1.ability_index = 0 # SLUSHRUSH
	pkmn1.nature = :JOLLY
	pkmn1.learn_move(:RAPIDSPIN)
	pkmn1.learn_move(:IRONHEAD)
	pkmn1.learn_move(:EARTHQUAKE)
	pkmn1.learn_move(:KNOCKOFF)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :GHOST
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:WEAVILE,30)
	pkmn2.item = :WIDELENS
	pkmn2.ability_index = 2 # TECHNICIAN
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:SWORDSDANCE)
	pkmn2.learn_move(:DOUBLEHIT)
	pkmn2.learn_move(:TRIPLEAXEL)
	pkmn2.learn_move(:ICESHARD)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :FLYING
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:NINETALES_1,30)
	pkmn3.item = :ICYROCK
	pkmn3.ability_index = 0 # SNOWWARNING
	pkmn3.nature = :TIMID
	pkmn3.learn_move(:AURORAVEIL)
	pkmn3.learn_move(:FREEZEDRY)
	pkmn3.learn_move(:MOONBLAST)
	pkmn3.learn_move(:ENCORE)
	pkmn3.ev[:HP] = 252
	pkmn3.ev[:ATTACK] = 0
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 4
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :PSYCHIC
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:MAMOSWINE,30)
	pkmn4.item = :LIFEORB
	pkmn3.ability_index = 6 # SHEERFORCE
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:HEADLONGRUSH)
	pkmn4.learn_move(:MOUNTAINGALE)
	pkmn4.learn_move(:ROCKCLIMB)
	pkmn4.learn_move(:IRONHEAD)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :FIRE
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:LAPRAS,30)
	pkmn5.item = :LEFTOVERS
	pkmn5.ability_index = 0 # SHELLARMOR
	pkmn5.nature = :ADAMANT
	pkmn5.learn_move(:LIQUIDATION)
	pkmn5.learn_move(:BODYSLAM)
	pkmn5.learn_move(:BULKUP)
	pkmn5.learn_move(:SHEERCOLD)
	pkmn5.ev[:HP] = 32
	pkmn5.ev[:ATTACK] = 252
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 228
	pkmn5.tera_type = :POISON
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:KYUREM,30)
	pkmn6.item = :CHOICESCARF
	pkmn6.ability_index = 2 # BEASTBOOST
	pkmn6.nature = :TIMID
	pkmn6.learn_move(:DRACOMETEOR)
	pkmn6.learn_move(:HYPERBEAM)
	pkmn6.learn_move(:FREEZEDRY)
	pkmn6.learn_move(:EARTHPOWER)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.tera_type = :FAIRY
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoDragonPartyQuickStart30 # Poke Paste: https://pokepast.es/b883849ca83b0402
	pkmn1 = Pokemon.new(:DURALUDON,30)
	pkmn1.item = :EVIOLITE
	pkmn1.ability_index = 4 # STAMINA
	pkmn1.nature = :BOLD
	pkmn1.learn_move(:BODYPRESS)
	pkmn1.learn_move(:FLASHCANNON)
	pkmn1.learn_move(:STEALTHROCK)
	pkmn1.learn_move(:THUNDERWAVE)
	pkmn1.ev[:HP] = 252
	pkmn1.ev[:ATTACK] = 0
	pkmn1.ev[:DEFENSE] = 44
	pkmn1.ev[:SPECIAL_DEFENSE] = 216
	pkmn1.ev[:SPEED] = 0
	pkmn1.tera_type = :GHOST
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:GOODRA_1,30)
	pkmn2.item = :LEFTOVERS
	pkmn2.ability_index = 6 # GOOEY
	pkmn2.nature = :CAREFUL
	pkmn2.learn_move(:HEAVYSLAM)
	pkmn2.learn_move(:KNOCKOFF)
	pkmn2.learn_move(:DRAGONTAIL)
	pkmn2.learn_move(:PROTECT)
	pkmn2.ev[:HP] = 248
	pkmn2.ev[:ATTACK] = 0
	pkmn2.ev[:DEFENSE] = 12
	pkmn2.ev[:SPECIAL_DEFENSE] = 252
	pkmn2.ev[:SPEED] = 0
	pkmn2.tera_type = :FLYING
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:LATIOS,30)
	pkmn3.item = :EXPERTBELT
	pkmn3.ability_index = 4 # NEUROFORCE
	pkmn3.nature = :TIMID
	pkmn3.learn_move(:EXTRASENSORY)
	pkmn3.learn_move(:THUNDERBOLT)
	pkmn3.learn_move(:ICEBEAM)
	pkmn3.learn_move(:ROOST)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :STEEL
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:GARCHOMP,30)
	pkmn4.item = :MEGAITE
	pkmn3.ability_index = 2 # EARTHEATER
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:VICTORYDANCE)
	pkmn4.learn_move(:EXTREMESPEED)
	pkmn4.learn_move(:DRAGONASCENT)
	pkmn4.learn_move(:IRONTAIL)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :ROCK
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:DRAGAPULT,30)
	pkmn5.item = :CHOICESPECS
	pkmn5.ability_index = 2 # MEGALAUNCHER
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:HYPERBEAM)
	pkmn5.learn_move(:SHADOWBALL)
	pkmn5.learn_move(:FLAMETHROWER)
	pkmn5.learn_move(:UTURN)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :DRAGON
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:ROARINGMOON,30)
	pkmn6.item = :CHOICESCARF
	pkmn6.ability_index = 6 # MOXIE
	pkmn6.nature = :JOLLY
	pkmn6.learn_move(:DRAGONASCENT)
	pkmn6.learn_move(:KNOCKOFF)
	pkmn6.learn_move(:EARTHQUAKE)
	pkmn6.learn_move(:UTURN)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.tera_type = :FIRE
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoDarkPartyQuickStart30 # Poke Paste: https://pokepast.es/4088d29463d73e7a
	pkmn1 = Pokemon.new(:TINGLU,30)
	pkmn1.item = :LEFTOVERS
	pkmn1.ability_index = 5 # ROCKYPAYLOAD
	pkmn1.nature = :CAREFUL
	pkmn1.learn_move(:BODYSLAM)
	pkmn1.learn_move(:WHIRLWIND)
	pkmn1.learn_move(:SPIKES)
	pkmn1.learn_move(:RUINATION)
	pkmn1.ev[:HP] = 252
	pkmn1.ev[:ATTACK] = 0
	pkmn1.ev[:DEFENSE] = 8
	pkmn1.ev[:SPECIAL_DEFENSE] = 252
	pkmn1.ev[:SPEED] = 0
	pkmn1.tera_type = :POISON
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:MEOWSCARADA,30)
	pkmn2.item = :CHOICESCARF
	pkmn2.ability_index = 6 # MAGICBOUNCE
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:FLOWERTRICK)
	pkmn2.learn_move(:TRIPLEAXEL)
	pkmn2.learn_move(:PLAYROUGH)
	pkmn2.learn_move(:UTURN)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :GRASS
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:SAMUROTT_1,30)
	pkmn3.item = :RAZORCLAW
	pkmn3.ability_index = 4 # SHARPNESS
	pkmn3.nature = :JOLLY
	pkmn3.learn_move(:VICTORYDANCE)
	pkmn3.learn_move(:SLASH)
	pkmn3.learn_move(:RAZORSHELL)
	pkmn3.learn_move(:SACREDSWORD)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :FIRE
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:MANDIBUZZ,30)
	pkmn4.item = :HEAVYDUTYBOOTS
	pkmn3.ability_index = 0 # LEVITATE
	pkmn4.nature = :IMPISH
	pkmn4.learn_move(:PUNISHMENT)
	pkmn4.learn_move(:ROOST)
	pkmn4.learn_move(:TOXIC)
	pkmn4.learn_move(:VENOMDRENCH)
	pkmn4.ev[:HP] = 252
	pkmn4.ev[:ATTACK] = 0
	pkmn4.ev[:DEFENSE] = 252
	pkmn4.ev[:SPECIAL_DEFENSE] = 8
	pkmn4.ev[:SPEED] = 0
	pkmn4.tera_type = :ELECTRIC
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:HOOPA_1,30)
	pkmn5.item = :ASSAULTVEST
	pkmn5.ability_index = 4 # INTIMIDATE
	pkmn5.nature = :CAREFUL
	pkmn5.learn_move(:PSYCHICNOISE)
	pkmn5.learn_move(:KNOCKOFF)
	pkmn5.learn_move(:GUNKSHOT)
	pkmn5.learn_move(:DRAINPUNCH)
	pkmn5.ev[:HP] = 252
	pkmn5.ev[:ATTACK] = 48
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 196
	pkmn5.ev[:SPEED] = 16
	pkmn5.tera_type = :STEEL
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:DARKRAI,30)
	pkmn6.item = :SALACBERRY
	pkmn6.ability_index = 5 # DARKAURA
	pkmn6.nature = :TIMID
	pkmn6.learn_move(:SUBSTITUTE)
	pkmn6.learn_move(:NASTYPLOT)
	pkmn6.learn_move(:EGGBOMB)
	pkmn6.learn_move(:FOCUSBLAST)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.tera_type = :FAIRY
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoFairyPartyQuickStart30 # Poke Paste: https://pokepast.es/7befb3cd43301b4b
	pkmn1 = Pokemon.new(:FLUTTERMANE,30)
	pkmn1.item = :POWERHERB
	pkmn1.ability_index = 3 # INTIMIDATE
	pkmn1.nature = :TIMID
	pkmn1.learn_move(:GEOMANCY)
	pkmn1.learn_move(:NASTYPLOT)
	pkmn1.learn_move(:SPARKLYSWIRL)
	pkmn1.learn_move(:MYSTICALFIRE)
	pkmn1.ev[:HP] = 244
	pkmn1.ev[:ATTACK] = 4
	pkmn1.ev[:DEFENSE] = 124
	pkmn1.ev[:SPECIAL_DEFENSE] = 4
	pkmn1.ev[:SPEED] = 136
	pkmn1.tera_type = :FIRE
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:KLEFKI,30)
	pkmn2.item = :LIGHTCLAY
	pkmn2.ability_index = 0 # LEVITATE
	pkmn2.nature = :BOLD
	pkmn2.learn_move(:FOULPLAY)
	pkmn2.learn_move(:REFLECT)
	pkmn2.learn_move(:LIGHTSCREEN)
	pkmn2.learn_move(:STEALTHROCK)
	pkmn2.ev[:HP] = 252
	pkmn2.ev[:ATTACK] = 0
	pkmn2.ev[:DEFENSE] = 204
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 56
	pkmn2.tera_type = :ELECTRIC
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:ENAMORUS,30)
	pkmn3.item = :CHOICESCARF
	pkmn3.ability_index = 2 # CONTRARY
	pkmn3.nature = :JOLLY
	pkmn3.learn_move(:PLAYROUGH)
	pkmn3.learn_move(:BODYSLAM)
	pkmn3.learn_move(:SUPERPOWER)
	pkmn3.learn_move(:HEALINGWISH)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :GROUND
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:IRONVALIANT,30)
	pkmn4.item = :BOOSTERENERGY
	pkmn4.ability_index = 0 # QUARKDRIVE
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:SWORDSDANCE)
	pkmn4.learn_move(:CLOSECOMAT)
	pkmn4.learn_move(:KNOCKOFF)
	pkmn4.learn_move(:SPIRITBREAK)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :STEEL
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:CLEFABLE,30)
	pkmn5.item = :LIFEORB
	pkmn5.ability_index = 2 # MAGICGUARD
	pkmn5.nature = :BOLD
	pkmn5.learn_move(:TRIATTACK)
	pkmn5.learn_move(:THUNDERBOLT)
	pkmn5.learn_move(:QUIVERDANCE)
	pkmn5.learn_move(:SOFTBOILED)
	pkmn5.ev[:HP] = 252
	pkmn5.ev[:ATTACK] = 0
	pkmn5.ev[:DEFENSE] = 132
	pkmn5.ev[:SPECIAL_DEFENSE] = 64
	pkmn5.ev[:SPEED] = 64
	pkmn5.tera_type = :POISON
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:AZUMARILL,30)
	pkmn6.item = :HONEY
	pkmn6.ability_index = 0 # HUGEPOWER
	pkmn6.nature = :ADAMANT
	pkmn6.learn_move(:EXTREMESPEED)
	pkmn6.learn_move(:LIQUIDATION)
	pkmn6.learn_move(:KNOCKOFF)
	pkmn6.learn_move(:BELLYDRUM)
	pkmn6.ev[:HP] = 80
	pkmn6.ev[:ATTACK] = 252
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 4
	pkmn6.ev[:SPEED] = 176
	pkmn6.tera_type = :PSYCHIC
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedRainWeatherPartyQuickStart30 # Pending Poke Paste: https://nuzlocke.app/guides/radical-red-hardcore
	pkmn1 = Pokemon.new(:THUNDURUS,30)
	pkmn1.item = :DAMPROCK
	pkmn1.ability_index = 3 # PRANKSTER
	pkmn1.nature = :BOLD
	pkmn1.learn_move(:VOLTSWITCH)
	pkmn1.learn_move(:RAINDANCE)
	pkmn1.learn_move(:THUNDERWAVE)
	pkmn1.learn_move(:TAUNT)
	pkmn1.ev[:HP] = 256
	pkmn1.ev[:ATTACK] = 4
	pkmn1.ev[:DEFENSE] = 156
	pkmn1.ev[:SPECIAL_DEFENSE] = 92
	pkmn1.ev[:SPEED] = 4
	pkmn1.tera_type = :DARK
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:JIRACHI,30)
	pkmn2.item = :TERRAINEXTENDER
	pkmn2.ability_index = 4 # MISTYSURGE
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:STEALTHROCK)
	pkmn2.learn_move(:ENCORE)
	pkmn2.learn_move(:TRICK)
	pkmn2.learn_move(:UTURN)
	pkmn2.ev[:HP] = 252
	pkmn2.ev[:ATTACK] = 0
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 32
	pkmn2.ev[:SPEED] = 228
	pkmn2.tera_type = :WATER
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:SEISMITOAD,30)
	pkmn3.item = :THROATSPRAY
	pkmn3.ability_index = 3 # SWIFTSWIM
	pkmn3.nature = :TIMID
	pkmn3.learn_move(:WATERGUN)
	pkmn3.learn_move(:HYPERVOICE)
	pkmn3.learn_move(:GRASSKNOT)
	pkmn3.learn_move(:FOCUSBLAST)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :POISON
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:MANTINE,30)
	pkmn4.item = :LEFTOVERS
	pkmn4.ability_index = 6 # HYDRATION
	pkmn4.nature = :TIMID
	pkmn4.learn_move(:QUIVERDANCE)
	pkmn4.learn_move(:SCALD)
	pkmn4.learn_move(:TRIATTACK)
	pkmn4.learn_move(:ROOST)
	pkmn4.ev[:HP] = 80
	pkmn4.ev[:ATTACK] = 252
	pkmn4.ev[:DEFENSE] = 4
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 176
	pkmn4.tera_type = :GROUND
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:KINGDRA,30)
	pkmn5.item = :WATERIUMZ
	pkmn5.ability_index = 0 # SWIFTSWIM
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:HYPERBEAM)
	pkmn5.learn_move(:WATERGUN)
	pkmn5.learn_move(:SPLASH)
	pkmn5.learn_move(:ICEBEAM)
	pkmn5.ev[:HP] = 104
	pkmn5.ev[:ATTACK] = 152
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :FLYING
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:GRENINJA,30)
	pkmn6.item = :MEGAITE
	pkmn6.ability_index = 0 # PROTEAN
	pkmn6.nature = :TIMID
	pkmn6.learn_move(:HYDROCANNON)
	pkmn6.learn_move(:EGGBOMB)
	pkmn6.learn_move(:ICEBEAM)
	pkmn6.learn_move(:EXTRASENSORY)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.tera_type = :WATER
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedSunWeatherPartyQuickStart30 # Pending Poke Paste: https://nuzlocke.app/guides/radical-red-hardcore
	pkmn1 = Pokemon.new(:CHARIZARD,30)
	pkmn1.item = :MEGAITEY
	pkmn1.ability_index = 4 # DROUGHT
	pkmn1.nature = :TIMID
	pkmn1.learn_move(:BLASTBURN)
	pkmn1.learn_move(:AEROBLAST)
	pkmn1.learn_move(:SCORCHINGSANDS)
	pkmn1.learn_move(:SOLARBEAM)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :FIRE
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:GROUDON,30)
	pkmn2.item = :REDORB
	pkmn2.ability_index = 4 # INTIMIDATE
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:ROCKPOLISH)
	pkmn2.learn_move(:SWORDSDANCE)
	pkmn2.learn_move(:PRECIPICEBLADES)
	pkmn2.learn_move(:HEATCRASH)
	pkmn2.ev[:HP] = 140
	pkmn2.ev[:ATTACK] = 252
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 120
	pkmn2.tera_type = :GROUND
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:HELIOLISK,30)
	pkmn3.item = :LIFEORB
	pkmn3.ability_index = 1 # SOLARPOWER
	pkmn3.nature = :TIMID
	pkmn3.learn_move(:WEATHERBALL)
	pkmn3.learn_move(:THUNDERCLAP)
	pkmn3.learn_move(:SOLARBEAM)
	pkmn3.learn_move(:QUIVERDANCE)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :FLYING
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:DARMANITAN_2,30)
	pkmn4.item = :SALACBERRY
	pkmn4.ability_index = 2 # ZENMODE
	pkmn4.nature = :ADAMANT
	pkmn4.learn_move(:BODYSLAM)
	pkmn4.learn_move(:FLAREBLITZ)
	pkmn4.learn_move(:ENDURE)
	pkmn4.learn_move(:REVERSAL)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :GRASS
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:HOOH,30)
	pkmn5.item = :HEAVYDUTYBOOTS
	pkmn5.ability_index = 2 # WINDRIDER
	pkmn5.nature = :ADAMANT
	pkmn5.learn_move(:SACREDFIRE)
	pkmn5.learn_move(:DOUBLEEDGE)
	pkmn5.learn_move(:EARTHQUAKE)
	pkmn5.learn_move(:TAILWIND)
	pkmn5.ev[:HP] = 252
	pkmn5.ev[:ATTACK] = 176
	pkmn5.ev[:DEFENSE] = 20
	pkmn5.ev[:SPECIAL_DEFENSE] = 56
	pkmn5.ev[:SPEED] = 8
	pkmn5.tera_type = :ELECTRIC
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:VENUSAUR,30)
	pkmn6.item = :FOCUSSASH
	pkmn6.ability_index = 3 # CHLOROPHYLL
	pkmn6.nature = :TIMID
	pkmn6.learn_move(:GROWTH)
	pkmn6.learn_move(:TRIATTACK)
	pkmn6.learn_move(:POISONPOWDER)
	pkmn6.learn_move(:WEATHERBALL)
	pkmn6.ev[:HP] = 72
	pkmn6.ev[:ATTACK] = 252
	pkmn6.ev[:DEFENSE] = 4
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 184
	pkmn6.tera_type = :ROCK
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedSandstormPartyQuickStart30 # Pending Poke Paste: https://nuzlocke.app/guides/radical-red-hardcore
	pkmn1 = Pokemon.new(:GIGALITH,30)
	pkmn1.item = :CUSTAPBERRY
	pkmn1.ability_index = 4 # SANDSTREAM
	pkmn1.nature = :ADAMANT
	pkmn1.learn_move(:EXPLOSION)
	pkmn1.learn_move(:STEALTHROCK)
	pkmn1.learn_move(:SANDTOMB)
	pkmn1.learn_move(:SANDSTORM)
	pkmn1.ev[:HP] = 256
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 0
	pkmn1.tera_type = :FLYING
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:LANDORUS_1,30)
	pkmn2.item = :SMOOTHROCK
	pkmn2.ability_index = 5 # SANDSTREAM
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:STEALTHROCK)
	pkmn2.learn_move(:TAUNT)
	pkmn2.learn_move(:UTURN)
	pkmn2.learn_move(:FLOATYFALL)
	pkmn2.ev[:HP] = 252
	pkmn2.ev[:ATTACK] = 0
	pkmn2.ev[:DEFENSE] = 4
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :GHOST
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:ZYGARDE,30)
	pkmn3.item = :LEFTOVERS
	pkmn3.ability_index = 0 # POWERCONSTRUCT
	pkmn3.nature = :IMPISH
	pkmn3.learn_move(:COIL)
	pkmn3.learn_move(:THOUSANDARROWS)
	pkmn3.learn_move(:REST)
	pkmn3.learn_move(:DRAGONTAIL)
	pkmn3.ev[:HP] = 256
	pkmn3.ev[:ATTACK] = 0
	pkmn3.ev[:DEFENSE] = 96
	pkmn3.ev[:SPECIAL_DEFENSE] = 108
	pkmn3.ev[:SPEED] = 52
	pkmn3.tera_type = :FAIRY
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:AERODACTYL,30)
	pkmn4.item = :MEGAITE
	pkmn4.ability_index = 3 # ROCKHEAD
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:DRAGONDANCE)
	pkmn4.learn_move(:ROCKCLIMB)
	pkmn4.learn_move(:EARTHQUAKE)
	pkmn4.learn_move(:FLOATYFALL)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :ROCK
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:EMPOLEON,30)
	pkmn5.item = :WEAKNESSPOLICY
	pkmn5.ability_index = 4 # BATTLEARMOR
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:AGILITY)
	pkmn5.learn_move(:ROOST)
	pkmn5.learn_move(:SCALD)
	pkmn5.learn_move(:ICEBEAM)
	pkmn5.ev[:HP] = 96
	pkmn5.ev[:ATTACK] = 252
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 164
	pkmn5.tera_type = :ELECTRIC
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:CRADILY,30)
	pkmn6.item = :BIGROOT
	pkmn6.ability_index = 0 # STORMDRAIN
	pkmn6.nature = :IMPISH
	pkmn6.learn_move(:SAPPYSEED)
	pkmn6.learn_move(:JUNGLEHEALING)
	pkmn6.learn_move(:INGRAIN)
	pkmn6.learn_move(:STOCKPILE)
	pkmn6.ev[:HP] = 256
	pkmn6.ev[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 92
	pkmn6.ev[:SPECIAL_DEFENSE] = 164
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :GROUND
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedHailstormPartyQuickStart30 # Pending Poke Paste: https://nuzlocke.app/guides/radical-red-hardcore
	pkmn1 = Pokemon.new(:SUICUNE,30)
	pkmn1.item = :ICYROCK
	pkmn1.ability_index = 4 # SNOWWARNING
	pkmn1.nature = :CALM
	pkmn1.learn_move(:AURORAVEIL)
	pkmn1.learn_move(:FLIPTURN)
	pkmn1.learn_move(:TAILWIND)
	pkmn1.learn_move(:ROAR)
	pkmn1.ev[:HP] = 256
	pkmn1.ev[:ATTACK] = 4
	pkmn1.ev[:DEFENSE] = 108
	pkmn1.ev[:SPECIAL_DEFENSE] = 60
	pkmn1.ev[:SPEED] = 84
	pkmn1.tera_type = :DARK
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:KYUREM_2,30)
	pkmn2.item = :LOADEDDICE
	pkmn2.ability_index = 3 # INTIMIDATE
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:DRAGONDANCE)
	pkmn2.learn_move(:EGGBOMB)
	pkmn2.learn_move(:SUBSTITUTE)
	pkmn2.learn_move(:DRAGONDANCE)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 252
	pkmn2.ev[:DEFENSE] = 94
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 168
	pkmn2.tera_type = :FAIRY
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:ARCTOZOLT,30)
	pkmn3.item = :HEAVYDUTYBOOTS
	pkmn3.ability_index = 0 # SLUSHRUSH
	pkmn3.nature = :ADAMANT
	pkmn3.learn_move(:SPARK)
	pkmn3.learn_move(:EGGBOMB)
	pkmn3.learn_move(:AURORAVEIL)
	pkmn3.learn_move(:SUBSTITUTE)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :WATER
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:GLALIE,30)
	pkmn4.item = :MEGAITE
	pkmn4.ability_index = 0 # LEVITATE
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:FAKEOUT)
	pkmn4.learn_move(:HEADSMASH)
	pkmn4.learn_move(:EXTREMESPEED)
	pkmn4.learn_move(:VICTORYDANCE)
	pkmn4.ev[:HP] = 80
	pkmn4.ev[:ATTACK] = 0
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 252
	pkmn4.ev[:SPEED] = 180
	pkmn4.tera_type = :PSYCHIC
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:CLEFABLE,30)
	pkmn5.item = :LIFEORB
	pkmn5.ability_index = 2 # MAGICGUARD
	pkmn5.nature = :BOLD
	pkmn5.learn_move(:TRIATTACK)
	pkmn5.learn_move(:FLAMETHROWER)
	pkmn5.learn_move(:QUIVERDANCE)
	pkmn5.learn_move(:SOFTBOILED)
	pkmn5.ev[:HP] = 252
	pkmn5.ev[:ATTACK] = 0
	pkmn5.ev[:DEFENSE] = 132
	pkmn5.ev[:SPECIAL_DEFENSE] = 64
	pkmn5.ev[:SPEED] = 64
	pkmn5.tera_type = :POISON
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:BEARTIC,30)
	pkmn6.item = :LEFTOVERS
	pkmn6.ability_index = 5 # DAMP
	pkmn6.nature = :ADAMANT
	pkmn6.learn_move(:VICTORYDANCE)
	pkmn6.learn_move(:SUBSTITUTE)
	pkmn6.learn_move(:ICICLECRASH)
	pkmn6.learn_move(:BODYSLAM)
	pkmn6.ev[:HP] = 132
	pkmn6.ev[:ATTACK] = 252
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 128
	pkmn6.tera_type = :GROUND
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedUtimatePartyQuickStart30 # Custom Team, mirror match of Dani, the Mono Stellar Type Master
	pkmn1 = Pokemon.new(:MEWTWO,30)
	pkmn1.item = :MEGAITEX
	pkmn1.ability_index = 3 # INTIMIDATE
	pkmn1.nature = :JOLLY
	pkmn1.learn_move(:PSYCHOCUT)
	pkmn1.learn_move(:VICTORYDANCE)
	pkmn1.learn_move(:DRAINPUNCH)
	pkmn1.learn_move(:SHEERCOLD)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 112
	pkmn1.ev[:DEFENSE] = 144
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :FIRE
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:MEW,30)
	pkmn2.item = :MEWNIUMZ
	pkmn2.ability_index = 5 # UNAWARE
	pkmn2.nature = :TIMID
	pkmn2.learn_move(:LUSTERPURGE)
	pkmn2.learn_move(:ECHOEDVOICE)
	pkmn2.learn_move(:WILLOWISP)
	pkmn2.learn_move(:QUIVERDANCE)
	pkmn2.ev[:HP] = 240
	pkmn2.ev[:ATTACK] = 52
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 220
	pkmn2.tera_type = :ICE
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:TERAPAGOS,30)
	pkmn3.item = :WHITEHERB
	pkmn3.nature = :BOLD
	pkmn3.learn_move(:NORETREAT)
	pkmn3.learn_move(:SHELLSMASH)
	pkmn3.learn_move(:TAUNT)
	pkmn3.learn_move(:TERASTARSTORM)
	pkmn3.ev[:HP] = 172
	pkmn3.ev[:ATTACK] = 68
	pkmn3.ev[:DEFENSE] = 204
	pkmn3.ev[:SPECIAL_DEFENSE] = 12
	pkmn3.ev[:SPEED] = 56
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:TYPENULL,30)
	pkmn4.item = :EVIOLITE
	pkmn4.ability_index = 0 # BATTLEARMOR
	pkmn4.nature = :CALM
	pkmn4.learn_move(:SALTCURE)
	pkmn4.learn_move(:REST)
	pkmn4.learn_move(:SAPPYSEED)
	pkmn4.learn_move(:BIND)
	pkmn4.ev[:HP] = 252
	pkmn4.ev[:ATTACK] = 0
	pkmn4.ev[:DEFENSE] = 252
	pkmn4.ev[:SPECIAL_DEFENSE] = 8
	pkmn4.ev[:SPEED] = 0
	#pkmn4.dynamax_able = false # Due to crashing issues from 2.0.0, Type Null cannot Dynamax at all
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:ARCEUS_17,30) # Tweaks to the Legend Plate mean Arceus's forms are obtainable without holding the type plates. Dark Form is chosen for Prankster Immunity, before the Legend Plate kicks in 
	pkmn5.item = :LEGENDPLATE # Changes Arceus to any optimal offense type when it uses Judgement
	pkmn5.ability_index = 0 # MULTITYPE
	pkmn5.nature = :MODEST
	pkmn5.learn_move(:JUDGMENT)
	pkmn5.learn_move(:NORETREAT)
	pkmn5.learn_move(:BATONPASS)
	pkmn5.learn_move(:TAUNT)
	pkmn5.ev[:HP] = 116
	pkmn5.ev[:ATTACK] = 116
	pkmn5.ev[:DEFENSE] = 76
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 204
	pkmn5.tera_type = :POISON
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:UNOWN,30)
	pkmn6.item = :TERRAINEXTENDER
	pkmn6.ability_index = 1 # PUREPOWER
	pkmn6.nature = :TIMID
	pkmn6.learn_move(:EXPANDINGFORCE)
	pkmn6.learn_move(:EARTHPOWER)
	pkmn6.learn_move(:ROAROFTIME)
	pkmn6.learn_move(:AEROBLAST)
	pkmn6.ev[:HP] = 12
	pkmn6.ev[:ATTACK] = 68
	pkmn6.ev[:DEFENSE] = 204
	pkmn6.ev[:SPECIAL_DEFENSE] = 56
	pkmn6.ev[:SPEED] = 172
	pkmn6.tera_type = :PSYCHIC
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

#===============================================================================
# Lvl.50 (Gen 1 to Gen 9 Pokemon Teams, this exists to allow playtesters to have Optimised teams,
# without wasting time setting up a fully trained competitive teams. It also serves to truly poke 
# and prod the 435 trainers of battle mode, in order to identify tedious filler text, and potential 
# bugs and crashes, rather than just sticking to the stock Metagame teams)
#===============================================================================
def pbOptimisedGen1GrassPartyQuickStart50 # Poke Paste: https://pokepast.es/796bf2bd36e89d42
	pkmn1 = Pokemon.new(:NINETALES,50)
	pkmn1.item = :HEATROCK
	pkmn1.ability_index = 0 # DROUGHT
	pkmn1.nature = :TIMID
	pkmn1.learn_move(:FLAMETHROWER)
	pkmn1.learn_move(:ENCORE)
	pkmn1.learn_move(:HEALINGWISH)
	pkmn1.learn_move(:WILLOWISP)
	pkmn1.ev[:HP] = 248
	pkmn1.ev[:ATTACK] = 0 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn1.ev[:DEFENSE] = 20
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 244
	pkmn1.tera_type = :GHOST
	pkmn1.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:CERULEDGE,50)
	pkmn2.item = :FOCUSSASH
	pkmn2.ability_index = 2 # WEAKARMOR
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:SWORDSDANCE)
	pkmn2.learn_move(:BITTERBLADE)
	pkmn2.learn_move(:SOLARBLADE)
	pkmn2.learn_move(:TERABLAST)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :FAIRY
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:VENUSAUR,50)
	pkmn3.item = :LIFEORB
	pkmn3.ability_index = 3 # CHLOROPHYLL
	pkmn3.nature = :MODEST
	pkmn3.learn_move(:GROWTH)
	pkmn3.learn_move(:GIGADRAIN)
	pkmn3.learn_move(:SLUDGEBOMB)
	pkmn3.learn_move(:WEATHERBALL)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 252
	pkmn3.ev[:DEFENSE] = 4
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :FIRE
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:HATTERENE,50)
	pkmn4.item = :EJECTBUTTON
	pkmn4.ability_index = 0 # MAGICBOUNCE
	pkmn4.nature = :BOLD
	pkmn4.learn_move(:HEALINGWISH)
	pkmn4.learn_move(:PSYCHICNOISE)
	pkmn4.learn_move(:DAZZLINGGLEAM)
	pkmn4.learn_move(:NUZZLE)
	pkmn4.ev[:HP] = 256
	pkmn4.ev[:ATTACK] = 0
	pkmn4.ev[:DEFENSE] = 176
	pkmn4.ev[:SPECIAL_DEFENSE] = 72
	pkmn4.ev[:SPEED] = 8
	pkmn4.tera_type = :STEEL
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:GREATTUSK,50)
	pkmn5.item = :ROCKYHELMET
	pkmn5.ability_index = 0 # PROTOSYNTHESIS
	pkmn5.nature = :JOLLY
	pkmn5.learn_move(:HEADLONGRUSH)
	pkmn5.learn_move(:ICESPINNER)
	pkmn5.learn_move(:RAPIDSPIN)
	pkmn5.learn_move(:STEALTHROCK)
	pkmn5.ev[:HP] = 252
	pkmn5.ev[:ATTACK] = 4
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :FIRE
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:WALKINGWAKE,50)
	pkmn6.item = :CHOICESPECS
	pkmn6.ability_index = 0 # PROTOSYNTHESIS
	pkmn6.nature = :MODEST
	pkmn6.learn_move(:HYDROSTEAM)
	pkmn6.learn_move(:DRACOMETEOR)
	pkmn6.learn_move(:FLAMETHROWER)
	pkmn6.learn_move(:DRAGONPULSE)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.tera_type = :WATER
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen1FirePartyQuickStart50 # Poke Paste: https://pokepast.es/e4bf2a1d848e8146
	pkmn1 = Pokemon.new(:CHARIZARD,50)
	pkmn1.item = :CHOICESPECS
	pkmn1.ability_index = 3 # SOLARPOWER
	pkmn1.nature = :TIMID
	pkmn1.learn_move(:HEATWAVE)
	pkmn1.learn_move(:OVERHEAT)
	pkmn1.learn_move(:WEATHERBALL)
	pkmn1.learn_move(:AEROBLAST)
	pkmn1.ev[:HP] = 0 # For IV's they can be set to 31 or 0 on the Info Summary Option Screen.
	pkmn1.ev[:ATTACK] = 256 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :GHOST
	pkmn1.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:TORKOAL,50)
	pkmn2.item = :EJECTPACK
	pkmn2.ability_index = 2 # DROUGHT
	pkmn2.nature = :QUIET
	pkmn2.learn_move(:ERUPTION)
	pkmn2.learn_move(:OVERHEAT)
	pkmn2.learn_move(:HELPINGHAND)
	pkmn2.learn_move(:PROTECT)
	pkmn2.ev[:HP] = 176
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 72
	pkmn2.ev[:SPEED] = 0
	pkmn2.tera_type = :FIRE
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:PORYGON2,50)
	pkmn3.item = :EVIOLITE
	pkmn3.ability_index = 0 # ANALYTIC
	pkmn3.nature = :BOLD
	pkmn3.learn_move(:ICEBEAM)
	pkmn3.learn_move(:EGGBOMB)
	pkmn3.learn_move(:TRICKROOM)
	pkmn3.learn_move(:RECOVER)
	pkmn3.ev[:HP] = 256
	pkmn3.ev[:ATTACK] = 8
	pkmn3.ev[:DEFENSE] = 176
	pkmn3.ev[:SPECIAL_DEFENSE] = 72
	pkmn3.ev[:SPEED] = 0
	pkmn3.tera_type = :FIGHTING
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:INCINEROAR,50)
	pkmn4.item = :HONEY
	pkmn4.ability_index = 0 # INTIMIDATE
	pkmn4.nature = :CAREFUL
	pkmn4.learn_move(:FLAREBLITZ)
	pkmn4.learn_move(:KNOCKOFF)
	pkmn4.learn_move(:FAKEOUT)
	pkmn4.learn_move(:PARTINGSHOT)
	pkmn4.ev[:HP] = 248
	pkmn4.ev[:ATTACK] = 0
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 212
	pkmn4.ev[:SPEED] = 52
	pkmn4.tera_type = :DRAGON
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:JUMPLUFF,50)
	pkmn5.item = :COVERTCLOAK
	pkmn5.ability_index = 2 # CHLOROPHYLL
	pkmn5.nature = :JOLLY
	pkmn5.learn_move(:EGGBOMB)
	pkmn5.learn_move(:SUNNYDAY)
	pkmn5.learn_move(:RAGEPOWDER)
	pkmn5.learn_move(:TAILWIND)
	pkmn5.ev[:HP] = 256
	pkmn5.ev[:ATTACK] = 0
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :WATER
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:URSALUNA,50)
	pkmn6.item = :FLAMEORB
	pkmn6.ability_index = 0 # GUTS
	pkmn6.nature = :BRAVE
	pkmn6.learn_move(:FACADE)
	pkmn6.learn_move(:HEADLONGRUSH)
	pkmn6.learn_move(:FIREPUNCH)
	pkmn6.learn_move(:PROTECT)
	pkmn6.ev[:HP] = 140
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 44
	pkmn6.ev[:SPECIAL_DEFENSE] = 68
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :FAIRY
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen1WaterPartyQuickStart50 # Poke Paste: https://pokepast.es/18734f48aa3bb354
	pkmn1 = Pokemon.new(:BASCULEGION,50)
	pkmn1.item = :LIFEORB
	pkmn1.ability_index = 5 # SWIFTSWIM
	pkmn1.nature = :ADAMANT
	pkmn1.learn_move(:LASTRESPECTS)
	pkmn1.learn_move(:WAVECRASH)
	pkmn1.learn_move(:AQUAJET)
	pkmn1.learn_move(:PROTECT)
	pkmn1.ev[:HP] = 28 # For IV's they can be set to 31 or 0 on the Info Summary Option Screen.
	pkmn1.ev[:ATTACK] = 220 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn1.ev[:DEFENSE] = 124
	pkmn1.ev[:SPECIAL_DEFENSE] = 4
	pkmn1.ev[:SPEED] = 136
	pkmn1.tera_type = :WATER
	pkmn1.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:BLASTOISE,50)
	pkmn2.item = :WHITEHERB
	pkmn2.ability_index = 2 # STORMDRAIN
	pkmn2.nature = :CALM
	pkmn2.learn_move(:FAKEOUT)
	pkmn2.learn_move(:BUBBLEBEAM)
	pkmn2.learn_move(:EGGBOMB)
	pkmn2.learn_move(:SHELLSMASH)
	pkmn2.ev[:HP] = 228
	pkmn2.ev[:ATTACK] = 192
	pkmn2.ev[:DEFENSE] = 12
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 80
	pkmn2.tera_type = :DRAGON
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:INCINEROAR,50)
	pkmn3.item = :HONEY
	pkmn3.ability_index = 0 # INTIMIDATE
	pkmn3.nature = :IMPISH
	pkmn3.learn_move(:FAKEOUT)
	pkmn3.learn_move(:DARKESTLARIAT)
	pkmn3.learn_move(:UTURN)
	pkmn3.learn_move(:FLAREBLITZ)
	pkmn3.ev[:HP] = 248
	pkmn3.ev[:ATTACK] = 4
	pkmn3.ev[:DEFENSE] = 188
	pkmn3.ev[:SPECIAL_DEFENSE] = 68
	pkmn3.ev[:SPEED] = 4
	pkmn3.tera_type = :BUG
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:PELIPPER,50)
	pkmn4.item = :FOCUSSASH
	pkmn4.ability_index = 0 # DRIZZLE
	pkmn4.nature = :MODEST
	pkmn4.learn_move(:HURRICANE)
	pkmn4.learn_move(:ICYWIND)
	pkmn4.learn_move(:TAILWIND)
	pkmn4.learn_move(:RAINDANCE)
	pkmn4.ev[:HP] = 4
	pkmn4.ev[:ATTACK] = 252
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :GROUND
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:URSALUNA_1,50)
	pkmn5.item = :CHOICESPECS
	pkmn5.ability_index = 0 # MINDSEYE
	pkmn5.nature = :MODEST
	pkmn5.learn_move(:HYPERVOICE)
	pkmn5.learn_move(:EARTHPOWER)
	pkmn5.learn_move(:SNARL)
	pkmn5.learn_move(:MOONBLAST)
	pkmn5.ev[:HP] = 256
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 0
	pkmn5.tera_type = :GHOST
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:OVERQWIL,50)
	pkmn6.item = :SAFETYGOGGLES
	pkmn6.ability_index = 3 # WATERBUBBLE
	pkmn6.nature = :JOLLY
	pkmn6.learn_move(:GUNKSHOT)
	pkmn6.learn_move(:EGGBOMB)
	pkmn6.learn_move(:ACIDSPRAY)
	pkmn6.learn_move(:LIQUIDATION)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.tera_type = :FLYING
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen1ElectricPartyQuickStart50 # Poke Paste: https://pokepast.es/1cd570d0b5e4d125
	pkmn1 = Pokemon.new(:CHARIZARD,50)
	pkmn1.item = :LIFEORB
	pkmn1.ability_index = 3 # SOLARPOWER
	pkmn1.nature = :TIMID
	pkmn1.learn_move(:FLAMETHROWER)
	pkmn1.learn_move(:AEROBLAST)
	pkmn1.learn_move(:SCORCHINGSANDS)
	pkmn1.learn_move(:PROTECT)
	pkmn1.ev[:HP] = 0 # For IV's they can be set to 31 or 0 on the Info Summary Option Screen.
	pkmn1.ev[:ATTACK] = 256 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :FIRE
	pkmn1.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:RAICHU,50)
	pkmn2.item = :FOCUSSASH
	pkmn2.ability_index = 0 # LIGHTNINGROD
	pkmn2.nature = :TIMID
	pkmn2.learn_move(:FAKEOUT)
	pkmn2.learn_move(:ENCORE)
	pkmn2.learn_move(:VOLTSWITCH)
	pkmn2.learn_move(:ENDEAVOR)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :FLYING
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:TORKOAL,50)
	pkmn3.item = :ASSAULTVEST
	pkmn3.ability_index = 2 # DROUGHT
	pkmn3.nature = :MODEST
	pkmn3.learn_move(:HEATWAVE)
	pkmn3.learn_move(:FLAMETHROWER)
	pkmn3.learn_move(:SOLARBEAM)
	pkmn3.learn_move(:CLEARSMOG)
	pkmn3.ev[:HP] = 208
	pkmn3.ev[:ATTACK] = 140
	pkmn3.ev[:DEFENSE] = 164
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 0
	pkmn3.tera_type = :GRASS
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:GASTRODON,50)
	pkmn4.item = :HONEY
	pkmn4.ability_index = 4 # STORMDRAIN
	pkmn4.nature = :BOLD
	pkmn4.learn_move(:EARTHPOWER)
	pkmn4.learn_move(:WEATHERBALL)
	pkmn4.learn_move(:YAWN)
	pkmn4.learn_move(:PROTECT)
	pkmn4.ev[:HP] = 256
	pkmn4.ev[:ATTACK] = 92
	pkmn4.ev[:DEFENSE] = 88
	pkmn4.ev[:SPECIAL_DEFENSE] = 76
	pkmn4.ev[:SPEED] = 0
	pkmn4.tera_type = :FIRE
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:TALONFLAME,50)
	pkmn5.item = :SAFETYGOGGLES
	pkmn5.ability_index = 0 # GALEWINGS
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:WILLOWISP)
	pkmn5.learn_move(:AIRSLASH)
	pkmn5.learn_move(:TAILWIND)
	pkmn5.learn_move(:TAUNT)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 252
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 64
	pkmn5.tera_type = :GHOST
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:TSAREENA,50)
	pkmn6.item = :ZOOMLENS
	pkmn6.ability_index = 0 # QUEENLYMAJESTY
	pkmn6.nature = :JOLLY
	pkmn6.learn_move(:POWERWHIP)
	pkmn6.learn_move(:MEGAKICK)
	pkmn6.learn_move(:TRIPLEAXEL)
	pkmn6.learn_move(:PROTECT)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.tera_type = :WATER
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen1FairyPartyQuickStart50 # Poke Paste: https://pokepast.es/5f79ccf1b3607ea3
	pkmn1 = Pokemon.new(:BLISSEY,50)
	pkmn1.item = :HEAVYDUTYBOOTS 
	pkmn1.ability_index = 4 # NATURALCURE 
	pkmn1.nature = :CALM
	pkmn1.learn_move(:CALMMIND)
	pkmn1.learn_move(:FLAMETHROWER)
	pkmn1.learn_move(:SEISMICTOSS)
	pkmn1.learn_move(:SOFTBOILED)
	pkmn1.ev[:HP] = 0 # For IV's they can be set to 31 or 0 on the Info Summary Option Screen.
	pkmn1.ev[:ATTACK] = 0 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn1.ev[:DEFENSE] = 256
	pkmn1.ev[:SPECIAL_DEFENSE] = 256
	pkmn1.ev[:SPEED] = 0
	pkmn1.tera_type = :DARK
	pkmn1.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:CLEFABLE,50)
	pkmn2.item = :STICKYBARB
	pkmn2.ability_index = 2 # MAGICGUARD
	pkmn2.nature = :BOLD
	pkmn2.learn_move(:KNOCKOFF)
	pkmn2.learn_move(:MOONBLAST)
	pkmn2.learn_move(:MOONLIGHT)
	pkmn2.learn_move(:WISH)
	pkmn2.ev[:HP] = 252
	pkmn2.ev[:ATTACK] = 0
	pkmn2.ev[:DEFENSE] = 252
	pkmn2.ev[:SPECIAL_DEFENSE] = 8
	pkmn2.ev[:SPEED] = 0
	pkmn2.tera_type = :STEEL
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:GLISCOR,50)
	pkmn3.item = :MENTALHERB
	pkmn3.ability_index = 3 # LEVITATE
	pkmn3.nature = :IMPISH
	pkmn3.learn_move(:RUINATION)
	pkmn3.learn_move(:TOXIC)
	pkmn3.learn_move(:SPIKES)
	pkmn3.learn_move(:PROTECT)
	pkmn3.ev[:HP] = 252
	pkmn3.ev[:ATTACK] = 0
	pkmn3.ev[:DEFENSE] = 252
	pkmn3.ev[:SPECIAL_DEFENSE] = 8
	pkmn3.ev[:SPEED] = 0
	pkmn3.tera_type = :ELECTRIC
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:TINGLU,50)
	pkmn4.item = :REDCARD
	pkmn4.ability_index = 0 # VESSELOFRUIN
	pkmn4.nature = :CAREFUL
	pkmn4.learn_move(:STEALTHROCK)
	pkmn4.learn_move(:EARTHQUAKE)
	pkmn4.learn_move(:REST)
	pkmn4.learn_move(:PROTECT)
	pkmn4.ev[:HP] = 252
	pkmn4.ev[:ATTACK] = 0
	pkmn4.ev[:DEFENSE] = 8
	pkmn4.ev[:SPECIAL_DEFENSE] = 252
	pkmn4.ev[:SPEED] = 0
	pkmn4.tera_type = :GHOST
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:DONDOZO,50)
	pkmn5.item = :CHESTOBERRY
	pkmn5.ability_index = 0 # UNAWARE
	pkmn5.nature = :IMPISH
	pkmn5.learn_move(:EGGBOMB)
	pkmn5.learn_move(:CURSE)
	pkmn5.learn_move(:BODYPRESS)
	pkmn5.learn_move(:REST)
	pkmn5.ev[:HP] = 256
	pkmn5.ev[:ATTACK] = 0
	pkmn5.ev[:DEFENSE] = 256
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 0
	pkmn5.tera_type = :FIGHTING
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:AMOONGUSS,50)
	pkmn6.item = :HONEY
	pkmn6.ability_index = 3 # REGENERATOR
	pkmn6.nature = :RELAXED
	pkmn6.learn_move(:TOXIC)
	pkmn6.learn_move(:FOULPLAY)
	pkmn6.learn_move(:STRENGTHSAP) # This is one of the universal Move Type Moves for Grass types. I do not care what specfic Pokemon get the universal type moves. I refuse to manually edit the Level Up/Tutor/Egg Moves of all 1025+ Pokemon. It's a waste of time, and not once in any Pokemon game have I liked any Pokemon's natural Level Up Movepool 
	pkmn6.learn_move(:CUT) # This is one of the universal Move Type Moves for Grass types. 
	pkmn6.ev[:HP] = 252
	pkmn6.ev[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 252
	pkmn6.ev[:SPECIAL_DEFENSE] = 8
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :STEEL
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen1NormalPartyQuickStart50 # Team Craft Info: https://www.smogon.com/forums/threads/the-infamous-evopass-a-sm-ubers-rmt.3591806/
	pkmn1 = Pokemon.new(:MEW,50)
	pkmn1.item = :FOCUSSASH
	pkmn1.ability_index = 3 # PRANKSTER 
	pkmn1.nature = :JOLLY
	pkmn1.learn_move(:TAUNT)
	pkmn1.learn_move(:TAILWIND)
	pkmn1.learn_move(:GRAVITY)
	pkmn1.learn_move(:EXPLOSION)
	pkmn1.ev[:HP] = 8 # For IV's they can be set to 31 or 0 on the Info Summary Option Screen.
	pkmn1.ev[:ATTACK] = 84 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn1.ev[:DEFENSE] = 164
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :STEEL
	pkmn1.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:EEVEE,50)
	pkmn2.item = :EEVIUMZ
	pkmn2.ability_index = 6 # SIMPLE 
	pkmn2.nature = :HARDY # A netural nature is used, because Eevee's job in this team is to send it's Evo boosts to it's teammates
	pkmn2.learn_move(:LASTRESORT)
	pkmn2.learn_move(:BATONPASS)
	pkmn2.learn_move(:TAUNT) # All 1025+ Pokemon Evolution lines have had their movepools fused together, via Egg Move links and Ultimate Move Tutor. Eevee and it's evolutions as a result, learn all each other's moves, such as Sappy Seed. This is the case for all Pokemon Evolution lines, and stacks on top of the universal type moves and VGC Starter moves. If using the Sleep Status, replace Taunt with Sing. SY uses the Drowzy status, due to Sleep's nature being highly abusable at the highest level
	pkmn2.learn_move(:SUBSTITUTE)
	pkmn2.ev[:HP] = 240 # For IV's they can be set to 31 or 0 on the Info Summary Option Screen.
	pkmn2.ev[:ATTACK] = 0 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn2.ev[:DEFENSE] = 36
	pkmn2.ev[:SPECIAL_DEFENSE] = 16
	pkmn2.ev[:SPEED] = 220
	pkmn2.tera_type = :GHOST
	pkmn2.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:ESPEON,50)
	pkmn3.item = :LEFTOVERS
	pkmn3.ability_index = 0 # MAGICBOUNCE
	pkmn3.nature = :BOLD
	pkmn3.learn_move(:DAZZLINGGLEAM)
	pkmn3.learn_move(:STOREDPOWER)
	pkmn3.learn_move(:CALMMIND)
	pkmn3.learn_move(:BATONPASS)
	pkmn3.ev[:HP] = 248
	pkmn3.ev[:ATTACK] = 12
	pkmn3.ev[:DEFENSE] = 252
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 0
	pkmn3.tera_type = :ELECTRIC
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:KROOKODILE,50)
	pkmn4.item = :CHOICEBAND
	pkmn4.ability_index = 0 # MOXIE
	pkmn4.nature = :ADAMANT
	pkmn4.learn_move(:POWERTRIP)
	pkmn4.learn_move(:BEATUP)
	pkmn4.learn_move(:PURSUIT)
	pkmn4.learn_move(:BODYSLAM)
	pkmn4.ev[:HP] = 112
	pkmn4.ev[:ATTACK] = 252
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 148
	pkmn4.tera_type = :POISON
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:ARCEUS_17,50) # Tweaks to the Legend Plate mean Arceus's forms are obtainable without holding the type plates. Dark Form is chosen for Prankster Immunity, before the Legend Plate kicks in 
	pkmn5.item = :LEGENDPLATE # Changes Arceus to any optimal offense type when it uses Judgement
	pkmn5.ability_index = 0 # MULTITYPE
	pkmn5.nature = :MODEST
	pkmn5.learn_move(:JUDGMENT)
	pkmn5.learn_move(:NORETREAT)
	pkmn5.learn_move(:BATONPASS)
	pkmn5.learn_move(:TAUNT)
	pkmn5.ev[:HP] = 116
	pkmn5.ev[:ATTACK] = 116
	pkmn5.ev[:DEFENSE] = 76
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 204
	pkmn5.tera_type = :STELLAR
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:DITTO,50)
	pkmn6.item = :CHOICESCARF
	pkmn6.ability_index = 4 # IMPOSTER
	pkmn6.nature = :RELAXED # This nature + the below EV Spread ensures 4 Struggle uses and minimum Struggle damage from opponent Ditto. Slowest speed stops user's Ditto from kicking in first, allowing transformed Ditto to have more PP.
	pkmn6.learn_move(:TRANSFORM)
	pkmn6.ev[:HP] = 256 # For IV's, they can be set to 31 or 0 on the Info Summary Option Screen.
	pkmn6.ev[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 256
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :FAIRY
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen2GrassPartyQuickStart50 # Poke Paste: https://pokepast.es/bf868cdeb163a7c9
	pkmn1 = Pokemon.new(:MEGANIUM,50)
	pkmn1.item = :POWERHERB
	pkmn1.ability_index = 2 # THICKFAT
	pkmn1.nature = :BOLD
	pkmn1.learn_move(:GEOMANCY)
	pkmn1.learn_move(:LEECHSEED)
	pkmn1.learn_move(:DRAGONTAIL)
	pkmn1.learn_move(:LUNARBLESSING)
	pkmn1.ev[:HP] = 252
	pkmn1.ev[:ATTACK] = 0 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn1.ev[:DEFENSE] = 8
	pkmn1.ev[:SPECIAL_DEFENSE] = 252
	pkmn1.ev[:SPEED] = 0
	pkmn1.tera_type = :POISON
	pkmn1.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:LILLIGANT_1,50)
	pkmn2.item = :FOCUSSASH
	pkmn2.ability_index = 1 # CHLOROPHYLL
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:AFTERYOU)
	pkmn2.learn_move(:LEAFBLADE)
	pkmn2.learn_move(:EGGBOMB)
	pkmn2.learn_move(:STUNSPORE)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :FIRE
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:DRAGAPULT,50)
	pkmn3.item = :LIFEORB
	pkmn3.ability_index = 5 # CLEARBODY
	pkmn3.nature = :JOLLY
	pkmn3.learn_move(:DRAGONDARTS)
	pkmn3.learn_move(:SHADOWFORCE)
	pkmn3.learn_move(:TERABLAST)
	pkmn3.learn_move(:PROTECT)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :FIGHTING
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:TORKOAL,50)
	pkmn4.item = :CHOICESPECS
	pkmn4.ability_index = 2 # DROUGHT
	pkmn4.nature = :MODEST
	pkmn4.learn_move(:ERUPTION)
	pkmn4.learn_move(:HEATWAVE)
	pkmn4.learn_move(:SOLARBEAM)
	pkmn4.learn_move(:EARTHPOWER)
	pkmn4.ev[:HP] = 256
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 0
	pkmn4.tera_type = :FLYING
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:TYPHLOSION_1,50)
	pkmn5.item = :CHOICESCARF
	pkmn5.ability_index = 0 # SOULHEART
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:ERUPTION)
	pkmn5.learn_move(:HEATWAVE)
	pkmn5.learn_move(:FLAMETHROWER)
	pkmn5.learn_move(:EGGBOMB)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :GRASS
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:WEEZING_1,50)
	pkmn6.item = :HONEY
	pkmn6.ability_index = 2 # NEUTRALIZINGGAS
	pkmn6.nature = :CALM
	pkmn6.learn_move(:TAUNT)
	pkmn6.learn_move(:WILLOWISP)
	pkmn6.learn_move(:STRANGESTEAM)
	pkmn6.learn_move(:PROTECT)
	pkmn6.ev[:HP] = 256
	pkmn6.ev[:ATTACK] = 4
	pkmn6.ev[:DEFENSE] = 52
	pkmn6.ev[:SPECIAL_DEFENSE] = 156
	pkmn6.ev[:SPEED] = 44
	pkmn6.tera_type = :DARK
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen2FirePartyQuickStart50 # Poke Paste: https://pokepast.es/0048bf1a01a173c2
	pkmn1 = Pokemon.new(:TYPHLOSION,50)
	pkmn1.item = :CHOICESPECS
	pkmn1.ability_index = 0 # SOULHEART
	pkmn1.nature = :TIMID
	pkmn1.learn_move(:ERUPTION)
	pkmn1.learn_move(:HEATWAVE)
	pkmn1.learn_move(:FOCUSBLAST)
	pkmn1.learn_move(:EGGBOMB)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :GRASS
	pkmn1.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:HITMONTOP,50)
	pkmn2.item = :ROCKYHELMET
	pkmn2.ability_index = 4 # INTIMIDATE
	pkmn2.nature = :ADAMANT
	pkmn2.learn_move(:FAKEOUT)
	pkmn2.learn_move(:REVENGE)
	pkmn2.learn_move(:WIDEGUARD)
	pkmn2.learn_move(:COACHING)
	pkmn2.ev[:HP] = 252
	pkmn2.ev[:ATTACK] = 56
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 204
	pkmn2.tera_type = :GROUND
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:DRAGONITE,50)
	pkmn3.item = :LOADEDDICE
	pkmn3.ability_index = 2 # INNERFOCUS
	pkmn3.nature = :ADAMANT
	pkmn3.learn_move(:SCALESHOT)
	pkmn3.learn_move(:DRAGONCHEER)
	pkmn3.learn_move(:TAILWIND)
	pkmn3.learn_move(:PROTECT)
	pkmn3.ev[:HP] = 196
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 4
	pkmn3.ev[:SPECIAL_DEFENSE] = 4
	pkmn3.ev[:SPEED] = 52
	pkmn3.tera_type = :FAIRY
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:DRAGAPULT,50)
	pkmn4.item = :CHOICEBAND
	pkmn4.ability_index = 5 # CLEARBODY
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:DRAGONDARTS)
	pkmn4.learn_move(:SHADOWFORCE)
	pkmn4.learn_move(:SUCKERPUNCH)
	pkmn4.learn_move(:UTURN)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :DRAGON
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:TORKOAL,50)
	pkmn5.item = :LIFEORB
	pkmn5.ability_index = 2 # DROUGHT
	pkmn5.nature = :MODEST
	pkmn5.learn_move(:HEATWAVE)
	pkmn5.learn_move(:CLEARSMOG)
	pkmn5.learn_move(:HELPINGHAND)
	pkmn5.learn_move(:PROTECT)
	pkmn5.ev[:HP] = 176
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 72
	pkmn5.ev[:SPEED] = 0
	pkmn5.tera_type = :FIRE
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:WHIMSICOTT,50)
	pkmn6.item = :COVERTCLOAK
	pkmn6.ability_index = 0 # Prankster
	pkmn6.nature = :TIMID
	pkmn6.learn_move(:MOONBLAST)
	pkmn6.learn_move(:TAILWIND)
	pkmn6.learn_move(:TRICKROOM)
	pkmn6.learn_move(:SUNNYDAY)
	pkmn6.ev[:HP] = 180
	pkmn6.iv[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 4
	pkmn6.ev[:SPECIAL_DEFENSE] = 108
	pkmn6.ev[:SPEED] = 220
	pkmn6.tera_type = :WATER
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen2WaterPartyQuickStart50 # Poke Paste: https://pokepast.es/7bd4be45d6b25451
	pkmn1 = Pokemon.new(:FERALIGATR,50)
	pkmn1.item = :LIFEORB
	pkmn1.ability_index = 0 # SHEERFORCE
	pkmn1.nature = :JOLLY
	pkmn1.learn_move(:LIQUIDATION)
	pkmn1.learn_move(:CRUNCH)
	pkmn1.learn_move(:DRAGONDANCE)
	pkmn1.learn_move(:PROTECT)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :DARK
	pkmn1.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:KOMMOO,50)
	pkmn2.item = :THROATSPRAY
	pkmn2.ability_index = 0 # MULTISCALE
	pkmn2.nature = :TIMID
	pkmn2.learn_move(:EGGBOMB)
	pkmn2.learn_move(:AURASPHERE)
	pkmn2.learn_move(:CLANGOROUSSOUL)
	pkmn2.learn_move(:PROTECT)
	pkmn2.ev[:HP] = 136
	pkmn2.ev[:ATTACK] = 204
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 172
	pkmn2.tera_type = :POISON
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:POLITOED,50)
	pkmn3.item = :HONEY
	pkmn3.ability_index = 4 # DRIZZLE
	pkmn3.nature = :BOLD
	pkmn3.learn_move(:WEATHERBALL)
	pkmn3.learn_move(:ICYWIND)
	pkmn3.learn_move(:HAZE)
	pkmn3.learn_move(:PROTECT)
	pkmn3.ev[:HP] = 256
	pkmn3.ev[:ATTACK] = 0
	pkmn3.ev[:DEFENSE] = 184
	pkmn3.ev[:SPECIAL_DEFENSE] = 72
	pkmn3.ev[:SPEED] = 0
	pkmn3.tera_type = :GRASS
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:RILLABOOM,50)
	pkmn4.item = :ASSAULTVEST
	pkmn4.ability_index = 0 # GRASSYSURGE
	pkmn4.nature = :ADAMANT
	pkmn4.learn_move(:WOODHAMMER)
	pkmn4.learn_move(:GRASSYGLIDE)
	pkmn4.learn_move(:FAKEOUT)
	pkmn4.learn_move(:UTURN)
	pkmn4.ev[:HP] = 204
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 52
	pkmn4.tera_type = :FIRE
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:INCINEROAR,50)
	pkmn5.item = :SAFETYGOGGLES
	pkmn5.ability_index = 0 # Intimidate
	pkmn5.nature = :CAREFUL
	pkmn5.learn_move(:FAKEOUT)
	pkmn5.learn_move(:PARTINGSHOT)
	pkmn5.learn_move(:TAUNT)
	pkmn5.learn_move(:KNOCKOFF)
	pkmn5.ev[:HP] = 256
	pkmn5.ev[:ATTACK] = 0
	pkmn5.ev[:DEFENSE] = 96
	pkmn5.ev[:SPECIAL_DEFENSE] = 160
	pkmn5.ev[:SPEED] = 0
	pkmn5.tera_type = :GHOST
	pkmn5.dynamax_able = false
	pkmn5.calc_stats
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:AMOONGUSS,50)
	pkmn6.item = :COVERTCLOAK
	pkmn6.ability_index = 3 # Regenerator
	pkmn6.nature = :BOLD
	pkmn6.learn_move(:PROTECT)
	pkmn6.learn_move(:RAGEPOWDER)
	pkmn6.learn_move(:SPORE)
	pkmn6.learn_move(:POLLENPUFF)
	pkmn6.ev[:HP] = 240
	pkmn6.ev[:DEFENSE] = 236
	pkmn6.ev[:SPECIAL_DEFENSE] = 36
	pkmn6.iv[:SPEED] = 27
	pkmn6.tera_type = :WATER
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen3GrassPartyQuickStart50 # Poke Paste: https://pokepast.es/6aaf2d2cce90681e
	pkmn1 = Pokemon.new(:WEEZING_1,50)
	pkmn1.item = :TERRAINEXTENDER
	pkmn1.ability_index = 4 # MISTYSURGE
	pkmn1.nature = :BOLD
	pkmn1.learn_move(:STRANGESTEAM)
	pkmn1.learn_move(:FLAMETHROWER)
	pkmn1.learn_move(:TAUNT)
	pkmn1.learn_move(:MEMENTO)
	pkmn1.ev[:HP] = 256
	pkmn1.ev[:ATTACK] = 0 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn1.ev[:DEFENSE] = 172
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 84
	pkmn1.tera_type = :STEEL
	pkmn1.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:SCEPTILE,50)
	pkmn2.item = :MISTYSEED
	pkmn2.ability_index = 5 # UNBURDEN
	pkmn2.nature = :ADAMANT
	pkmn2.learn_move(:SWORDSDANCE)
	pkmn2.learn_move(:LEAFBLADE)
	pkmn2.learn_move(:ACROBATICS)
	pkmn2.learn_move(:EGGBOMB)
	pkmn2.ev[:HP] = 240
	pkmn2.ev[:ATTACK] = 252
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 20
	pkmn2.tera_type = :ICE
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:FERALIGATR,50)
	pkmn3.item = :LIFEORB
	pkmn3.ability_index = 0 # SHEERFORCE
	pkmn3.nature = :JOLLY
	pkmn3.learn_move(:LIQUIDATION)
	pkmn3.learn_move(:CRUNCH)
	pkmn3.learn_move(:DRAGONDANCE)
	pkmn3.learn_move(:ICEPUNCH)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :WATER
	pkmn3.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:SLITHERWING,50)
	pkmn4.item = :BOOSTERENERGY
	pkmn4.ability_index = 0 # PROTOSYNTHESIS
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:VICTORYDANCE)
	pkmn4.learn_move(:LEECHLIFE)
	pkmn4.learn_move(:SUBMISSION)
	pkmn4.learn_move(:SACREDFIRE)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :FIRE
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:BISHARP,50)
	pkmn5.item = :EVIOLITE
	pkmn5.ability_index = 2 # BATTLEARMOR
	pkmn5.nature = :JOLLY
	pkmn5.learn_move(:SWORDSDANCE)
	pkmn5.learn_move(:SUCKERPUNCH)
	pkmn5.learn_move(:IRONHEAD)
	pkmn5.learn_move(:LOWKICK)
	pkmn5.ev[:HP] = 84
	pkmn5.ev[:ATTACK] = 252
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 176
	pkmn5.tera_type = :FLYING
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:NECROZMA,50)
	pkmn6.item = :ROCKYHELMET
	pkmn6.ability_index = 0 # PRISMARMOR
	pkmn6.nature = :IMPISH
	pkmn6.learn_move(:STEALTHROCK)
	pkmn6.learn_move(:MOONLIGHT)
	pkmn6.learn_move(:KNOCKOFF)
	pkmn6.learn_move(:PSYSHIELDBASH)
	pkmn6.ev[:HP] = 252
	pkmn6.iv[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 72
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 184
	pkmn6.tera_type = :FAIRY
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen3FirePartyQuickStart50 # Poke Paste: https://pokepast.es/f0391b5ee43ffe02
	pkmn1 = Pokemon.new(:DRAGONITE,50)
	pkmn1.item = :LOADEDDICE
	pkmn1.ability_index = 0 # MULTISCALE
	pkmn1.nature = :ADAMANT
	pkmn1.learn_move(:PROTECT)
	pkmn1.learn_move(:SCALESHOT)
	pkmn1.learn_move(:TAILWIND)
	pkmn1.learn_move(:STOMPINGTANTRUM)
	pkmn1.ev[:HP] = 196
	pkmn1.ev[:ATTACK] = 252 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn1.ev[:DEFENSE] = 4
	pkmn1.ev[:SPECIAL_DEFENSE] = 4
	pkmn1.ev[:SPEED] = 56
	pkmn1.tera_type = :STEEL
	pkmn1.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:BLAZIKEN,50)
	pkmn2.item = :FOCUSSASH
	pkmn2.ability_index = 6 # SPEEDBOOST
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:DETECT)
	pkmn2.learn_move(:COACHING)
	pkmn2.learn_move(:EGGBOMB)
	pkmn2.learn_move(:CLOSECOMBAT)
	pkmn2.ev[:HP] = 200
	pkmn2.ev[:ATTACK] = 68
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 244
	pkmn2.tera_type = :GRASS
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:RILLABOOM,50)
	pkmn3.item = :ASSAULTVEST
	pkmn3.ability_index = 0 # GRASSYSURGE
	pkmn3.nature = :ADAMANT
	pkmn3.learn_move(:FAKEOUT)
	pkmn3.learn_move(:DRUMBEATING)
	pkmn3.learn_move(:GRASSYGLIDE)
	pkmn3.learn_move(:UTURN)
	pkmn3.ev[:HP] = 244
	pkmn3.ev[:ATTACK] = 36 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn3.ev[:DEFENSE] = 4
	pkmn3.ev[:SPECIAL_DEFENSE] = 220
	pkmn3.ev[:SPEED] = 8
	pkmn3.tera_type = :FIRE
	pkmn3.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:KINGAMBIT,50)
	pkmn4.item = :BLACKGLASSES
	pkmn4.ability_index = 5 # DEFIANT
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:PROTECT)
	pkmn4.learn_move(:SUCKERPUNCH)
	pkmn4.learn_move(:IRONHEAD)
	pkmn4.learn_move(:KOWTOWCLEAVE)
	pkmn4.ev[:HP] = 256
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 0
	pkmn4.tera_type = :DARK
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:PRIMARINA,50)
	pkmn5.item = :THROATSPRAY
	pkmn5.ability_index = 6 # LIQUIDVOICE
	pkmn5.nature = :MODEST
	pkmn5.learn_move(:HYPERVOICE)
	pkmn5.learn_move(:MOONBLAST)
	pkmn5.learn_move(:HAZE)
	pkmn5.learn_move(:PROTECT)
	pkmn5.ev[:HP] = 240
	pkmn5.ev[:ATTACK] = 108
	pkmn5.ev[:DEFENSE] = 68
	pkmn5.ev[:SPECIAL_DEFENSE] = 12
	pkmn5.ev[:SPEED] = 84
	pkmn5.tera_type = :POISON
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:FARIGIRAF,50)
	pkmn6.item = :HONEY
	pkmn6.ability_index = 0 # ARMORTAIL
	pkmn6.nature = :CALM
	pkmn6.learn_move(:TRICKROOM)
	pkmn6.learn_move(:IMPRISON)
	pkmn6.learn_move(:TWINBEAM)
	pkmn6.learn_move(:DAZZLINGGLEAM)
	pkmn6.ev[:HP] = 232
	pkmn6.iv[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 100
	pkmn6.ev[:SPECIAL_DEFENSE] = 180
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :FAIRY
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen3WaterPartyQuickStart50 # Poke Paste: https://pokepast.es/56c33da1ecac96ae
	pkmn1 = Pokemon.new(:INCINEROAR,50)
	pkmn1.item = :ASSAULTVEST
	pkmn1.ability_index = 0 # INTIMIDATE
	pkmn1.nature = :IMPISH
	pkmn1.learn_move(:FAKEOUT)
	pkmn1.learn_move(:FLAREBLITZ)
	pkmn1.learn_move(:UTURN)
	pkmn1.learn_move(:KNOCKOFF)
	pkmn1.ev[:HP] = 256
	pkmn1.ev[:ATTACK] = 20 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn1.ev[:DEFENSE] = 156
	pkmn1.ev[:SPECIAL_DEFENSE] = 44
	pkmn1.ev[:SPEED] = 36
	pkmn1.tera_type = :WATER
	pkmn1.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:RILLABOOM,50)
	pkmn2.item = :MIRACLESEED
	pkmn2.ability_index = 0 # GRASSYSURGE
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:FAKEOUT)
	pkmn2.learn_move(:GRASSYGLIDE)
	pkmn2.learn_move(:WOODHAMMER)
	pkmn2.learn_move(:HIGHHORSEPOWER)
	pkmn2.ev[:HP] = 56
	pkmn2.ev[:ATTACK] = 116
	pkmn2.ev[:DEFENSE] = 52
	pkmn2.ev[:SPECIAL_DEFENSE] = 52
	pkmn2.ev[:SPEED] = 236
	pkmn2.tera_type = :FIRE
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:DRAGONITE,50)
	pkmn3.item = :LOADEDDICE
	pkmn3.ability_index = 0 # MULTISCALE
	pkmn3.nature = :ADAMANT
	pkmn3.learn_move(:PROTECT)
	pkmn3.learn_move(:SCALESHOT)
	pkmn3.learn_move(:TAILWIND)
	pkmn3.learn_move(:HAZE)
	pkmn3.ev[:HP] = 196
	pkmn3.ev[:ATTACK] = 252 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn3.ev[:DEFENSE] = 4
	pkmn3.ev[:SPECIAL_DEFENSE] = 4
	pkmn3.ev[:SPEED] = 56
	pkmn3.tera_type = :FAIRY
	pkmn3.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:SNEASLER,50)
	pkmn4.item = :GRASSYSEED
	pkmn4.ability_index = 0 # UNBURDEN
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:EGGBOMB)
	pkmn4.learn_move(:CLOSECOMBAT)
	pkmn4.learn_move(:POISONTAIL)
	pkmn4.learn_move(:PROTECT)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :DARK
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:GHOLDENGO,50)
	pkmn5.item = :LIFEORB
	pkmn5.ability_index = 0 # WONDERSKIN
	pkmn5.nature = :MODEST
	pkmn5.learn_move(:EGGBOMB)
	pkmn5.learn_move(:SHADOWBALL)
	pkmn5.learn_move(:POWERGEM)
	pkmn5.learn_move(:PROTECT)
	pkmn5.ev[:HP] = 252
	pkmn5.ev[:ATTACK] = 92
	pkmn5.ev[:DEFENSE] = 4
	pkmn5.ev[:SPECIAL_DEFENSE] = 44
	pkmn5.ev[:SPEED] = 120
	pkmn5.tera_type = :DRAGON
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:SWAMPERT,50)
	pkmn6.item = :HONEY
	pkmn6.ability_index = 2 # SHEERFORCE
	pkmn6.nature = :ADAMANT
	pkmn6.learn_move(:EGGBOMB)
	pkmn6.learn_move(:WATERFALL)
	pkmn6.learn_move(:BULKUP)
	pkmn6.learn_move(:WIDEGUARD)
	pkmn6.ev[:HP] = 240
	pkmn6.ev[:ATTACK] = 100
	pkmn6.ev[:DEFENSE] = 36
	pkmn6.ev[:SPECIAL_DEFENSE] = 92
	pkmn6.ev[:SPEED] = 44
	pkmn6.tera_type = :FLYING
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen4GrassPartyQuickStart50 # Poke Paste: https://pokepast.es/33d343e2f1d6c37b
	pkmn1 = Pokemon.new(:FARIGIRAF,50)
	pkmn1.item = :HONEY
	pkmn1.ability_index = 0 # ARMORTAIL
	pkmn1.nature = :CAREFUL
	pkmn1.learn_move(:TRICKROOM)
	pkmn1.learn_move(:HELPINGHAND)
	pkmn1.learn_move(:CURSE)
	pkmn1.learn_move(:BODYSLAM)
	pkmn1.ev[:HP] = 252
	pkmn1.ev[:ATTACK] = 76 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn1.ev[:DEFENSE] = 132
	pkmn1.ev[:SPECIAL_DEFENSE] = 52
	pkmn1.ev[:SPEED] = 0
	pkmn1.tera_type = :FAIRY
	pkmn1.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:URSALUNA,50)
	pkmn2.item = :FLAMEORB
	pkmn2.ability_index = 0 # GUTS
	pkmn2.nature = :BRAVE
	pkmn2.learn_move(:FACADE)
	pkmn2.learn_move(:HEADLONGRUSH)
	pkmn2.learn_move(:DRAINPUNCH)
	pkmn2.learn_move(:PROTECT)
	pkmn2.ev[:HP] = 144
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 44
	pkmn2.ev[:SPECIAL_DEFENSE] = 68
	pkmn2.ev[:SPEED] = 0
	pkmn2.tera_type = :NORMAL
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:INDEEDEE_1,50)
	pkmn3.makeFemale # Only done for Female Indeede, to make sure the correct form sprite is used
	pkmn3.item = :FOCUSSASH
	pkmn3.ability_index = 3 # OWNTEMPO
	pkmn3.nature = :BOLD
	pkmn3.learn_move(:FOLLOWME)
	pkmn3.learn_move(:HEALINGWISH)
	pkmn3.learn_move(:HEALPULSE)
	pkmn3.learn_move(:DAZZLINGGLEAM)
	pkmn3.ev[:HP] = 256
	pkmn3.ev[:ATTACK] = 0 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn3.ev[:DEFENSE] = 256
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 0
	pkmn3.tera_type = :WATER
	pkmn3.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:GALLADE,50)
	pkmn4.item = :MEGAITE
	pkmn4.ability_index = 0 # Base Ability: INTREPIDSWORD Mega Ability: SHARPNESS
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:VICTORYDANCE)
	pkmn4.learn_move(:SACREDSWORD)
	pkmn4.learn_move(:PSYCHOCUT)
	pkmn4.learn_move(:AQUACUTTER)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :DARK
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:TORTERRA,50)
	pkmn5.item = :EJECTPACK
	pkmn5.ability_index = 0 # SHELLARMOR
	pkmn5.nature = :ADAMANT
	pkmn5.learn_move(:HEADLONGRUSH)
	pkmn5.learn_move(:SAPPYSEED)
	pkmn5.learn_move(:SMACKDOWN)
	pkmn5.learn_move(:STEALTHROCK)
	pkmn5.ev[:HP] = 220
	pkmn5.ev[:ATTACK] = 212
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 80
	pkmn5.tera_type = :GHOST
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:DUSCLOPS,50)
	pkmn6.item = :EVIOLITE
	pkmn6.ability_index = 4 # INTIMIDATE
	pkmn6.nature = :CALM
	pkmn6.learn_move(:TRICKROOM)
	pkmn6.learn_move(:NIGHTSHADE)
	pkmn6.learn_move(:WILLOWISP)
	pkmn6.learn_move(:HELPINGHAND)
	pkmn6.ev[:HP] = 256
	pkmn6.iv[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 256
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :POISON
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen4FirePartyQuickStart50 # Poke Paste: https://pokepast.es/11fd54de4b4e6b9a
	pkmn1 = Pokemon.new(:INFERNAPE,50)
	pkmn1.item = :FOCUSSASH
	pkmn1.ability_index = 0 # DOWNLOAD (This ability has been renamed to Instinct, to allow more Pokemon to have this ability, than just technology Pokemon) 
	pkmn1.nature = :NAIVE # Because Instinct could boost Atk or Sp.Atk, This Nature Modifier is used, in order to not weaken Atk or Sp.Atk with a Jolly or Timid Nature Modifier
	pkmn1.learn_move(:FAKEOUT)
	pkmn1.learn_move(:OVERHEAT)
	pkmn1.learn_move(:CLOSECOMBAT)
	pkmn1.learn_move(:UTURN)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256 # Infernape's a prime example of a Pokemon who massively benefits from the EV Allowcator Overhaul 
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :ELECTRIC
	pkmn1.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:HYDREIGON,50)
	pkmn2.item = :LIFEORB
	pkmn2.ability_index = 4 # MEGALAUNCHER (Moves such as Flamethrower are now boosted by Mega Launcher)
	pkmn2.nature = :TIMID
	pkmn2.learn_move(:DRAGONPULSE)
	pkmn2.learn_move(:DARKPULSE)
	pkmn2.learn_move(:FLASHCANNON)
	pkmn2.learn_move(:FLAMETHROWER)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :STEEL
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:KILOWATTREL,50)
	pkmn3.item = :COVERTCLOAK
	pkmn3.ability_index = 0 # COMPETITIVE
	pkmn3.nature = :TIMID
	pkmn3.learn_move(:TAILWIND)
	pkmn3.learn_move(:THUNDERBOLT)
	pkmn3.learn_move(:EGGBOMB)
	pkmn3.learn_move(:VOLTSWITCH)
	pkmn3.ev[:HP] = 96
	pkmn3.ev[:ATTACK] = 160 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :GHOST
	pkmn3.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:GASTRODON,50)
	pkmn4.item = :HONEY
	pkmn4.ability_index = 4 # STORMDRAIN
	pkmn4.nature = :BOLD
	pkmn4.learn_move(:EARTHPOWER)
	pkmn4.learn_move(:MUDDYWATER)
	pkmn4.learn_move(:YAWN)
	pkmn4.learn_move(:PROTECT)
	pkmn4.ev[:HP] = 184
	pkmn4.ev[:ATTACK] = 0
	pkmn4.ev[:DEFENSE] = 204
	pkmn4.ev[:SPECIAL_DEFENSE] = 124
	pkmn4.ev[:SPEED] = 0
	pkmn4.tera_type = :BUG
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:RILLABOOM,50)
	pkmn5.item = :ASSAULTVEST
	pkmn5.ability_index = 0 # GRASSYSURGE
	pkmn5.nature = :ADAMANT
	pkmn5.learn_move(:WOODHAMMER)
	pkmn5.learn_move(:GRASSYGLIDE)
	pkmn5.learn_move(:FAKEOUT)
	pkmn5.learn_move(:UTURN)
	pkmn5.ev[:HP] = 204
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 52
	pkmn5.tera_type = :FIRE
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:MAGMAR,50)
	pkmn6.item = :EVIOLITE
	pkmn6.ability_index = 5 # FLASHFIRE
	pkmn6.nature = :CALM
	pkmn6.learn_move(:EMBER)
	pkmn6.learn_move(:CLEARSMOG)
	pkmn6.learn_move(:FOLLOWME)
	pkmn6.learn_move(:PROTECT)
	pkmn6.ev[:HP] = 256
	pkmn6.iv[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 236
	pkmn6.ev[:SPECIAL_DEFENSE] = 20
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :WATER
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen4WaterPartyQuickStart50 # Poke Paste: https://pokepast.es/34cd5ffd188f2107
	pkmn1 = Pokemon.new(:GHOLDENGO,50)
	pkmn1.item = :CHOICESCARF
	pkmn1.ability_index = 3 # ADAPTABILITY
	pkmn1.nature = :TIMID
	pkmn1.learn_move(:TRICK)
	pkmn1.learn_move(:SHADOWBALL)
	pkmn1.learn_move(:MAKEITRAIN)
	pkmn1.learn_move(:FOCUSBLAST)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :DARK
	pkmn1.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:GLISCOR,50)
	pkmn2.item = :ROCKYHELMET
	pkmn2.ability_index = 3 # LEVITATE
	pkmn2.nature = :CAREFUL
	pkmn2.learn_move(:KNOCKOFF)
	pkmn2.learn_move(:CROSSPOISON)
	pkmn2.learn_move(:SPIKES)
	pkmn2.learn_move(:ROOST)
	pkmn2.ev[:HP] = 248
	pkmn2.ev[:ATTACK] = 0
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 252
	pkmn2.ev[:SPEED] = 12
	pkmn2.tera_type = :FIRE
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:GARGANACL,50)
	pkmn3.item = :LEFTOVERS
	pkmn3.ability_index = 2 # WATERABSORB
	pkmn3.nature = :IMPISH
	pkmn3.learn_move(:CURSE)
	pkmn3.learn_move(:SALTCURE)
	pkmn3.learn_move(:EARTHQUAKE)
	pkmn3.learn_move(:RECOVER)
	pkmn3.ev[:HP] = 252
	pkmn3.ev[:ATTACK] = 0 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn3.ev[:DEFENSE] = 144
	pkmn3.ev[:SPECIAL_DEFENSE] = 116
	pkmn3.ev[:SPEED] = 0
	pkmn3.tera_type = :FAIRY
	pkmn3.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:EMPOLEON,50)
	pkmn4.item = :ASSAULTVEST
	pkmn4.ability_index = 4 # BATTLEARMOR
	pkmn4.nature = :MODEST
	pkmn4.learn_move(:EGGBOMB)
	pkmn4.learn_move(:SURF)
	pkmn4.learn_move(:ICEBEAM)
	pkmn4.learn_move(:VACUUMWAVE)
	pkmn4.ev[:HP] = 256
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 0
	pkmn4.tera_type = :FLYING
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:GREATTUSK,50)
	pkmn5.item = :HEAVYDUTYBOOTS
	pkmn5.ability_index = 5 # THICKFAT
	pkmn5.nature = :IMPISH
	pkmn5.learn_move(:RAPIDSPIN)
	pkmn5.learn_move(:ICESPINNER)
	pkmn5.learn_move(:STEALTHROCK)
	pkmn5.learn_move(:CLOSCOMBAT)
	pkmn5.ev[:HP] = 220
	pkmn5.ev[:ATTACK] = 0
	pkmn5.ev[:DEFENSE] = 252
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 40
	pkmn5.tera_type = :GRASS
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:ZAMAZENTA,50)
	pkmn6.item = :RUSTEDSHIELD
	pkmn6.ability_index = 2 # STAMINA
	pkmn6.nature = :CAREFUL
	pkmn6.learn_move(:EGGBOMB)
	pkmn6.learn_move(:BEHEMOTHBASH)
	pkmn6.learn_move(:REST)
	pkmn6.learn_move(:METALBURST)
	pkmn6.ev[:HP] = 256
	pkmn6.iv[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 64
	pkmn6.ev[:SPECIAL_DEFENSE] = 192
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :WATER
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen5GrassPartyQuickStart50 # Poke Paste: https://pokepast.es/93024247192aa5f0
	pkmn1 = Pokemon.new(:KOMMOO,50)
	pkmn1.item = :SAFETYGOGGLES
	pkmn1.ability_index = 6 # BATTLEARMOR
	pkmn1.nature = :IMPISH
	pkmn1.learn_move(:BODYPRESS)
	pkmn1.learn_move(:THROATCHOP)
	pkmn1.learn_move(:IRONDEFENSE)
	pkmn1.learn_move(:SLACKOFF)
	pkmn1.ev[:HP] = 256
	pkmn1.iv[:ATTACK] = 0
	pkmn1.ev[:DEFENSE] = 256
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 0
	pkmn1.tera_type = :FIGHTING
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:TYRANITAR,50)
	pkmn2.item = :ASSAULTVEST
	pkmn2.ability_index = 0 # SANDSTREAM
	pkmn2.nature = :ADAMANT
	pkmn2.learn_move(:KNOCKOFF)
	pkmn2.learn_move(:ROCKSLIDE)
	pkmn2.learn_move(:EGGBOMB)
	pkmn2.learn_move(:HIGHHORSEPOWER)
	pkmn2.ev[:HP] = 140
	pkmn2.ev[:ATTACK] = 252
	pkmn2.ev[:DEFENSE] = 4
	pkmn2.ev[:SPECIAL_DEFENSE] = 4
	pkmn2.ev[:SPEED] = 112
	pkmn2.tera_type = :FLYING
	pkmn2.dynamax_able = false
	pkmn2.calc_stats
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:SERPERIOR,50)
	pkmn3.item = :HONEY
	pkmn3.ability_index = 3 # CONTRARY
	pkmn3.nature = :TIMID
	pkmn3.learn_move(:LEAFSTORM)
	pkmn3.learn_move(:DRACOMETEOR)
	pkmn3.learn_move(:TAUNT)
	pkmn3.learn_move(:PROTECT)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :FIRE
	pkmn3.dynamax_able = false
	pkmn3.calc_stats
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:GRIMMSNARL,50)
	pkmn4.item = :LIGHTCLAY
	pkmn4.ability_index = 4 # PRANKSTER
	pkmn4.nature = :CAREFUL
	pkmn4.learn_move(:SPIRITBREAK)
	pkmn4.learn_move(:LIGHTSCREEN)
	pkmn4.learn_move(:REFLECT)
	pkmn4.learn_move(:PARTINGSHOT)
	pkmn4.ev[:HP] = 240
	pkmn4.iv[:ATTACK] = 0
	pkmn4.ev[:DEFENSE] = 156
	pkmn4.ev[:SPECIAL_DEFENSE] = 116
	pkmn4.ev[:SPEED] = 0
	pkmn4.tera_type = :GHOST
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:GHOLDENGO,50)
	pkmn5.item = :CHOICESCARF
	pkmn5.ability_index = 3 # ADAPTABILITY
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:PROTECT)
	pkmn5.learn_move(:SHADOWBALL)
	pkmn5.learn_move(:MAKEITRAIN)
	pkmn5.learn_move(:NASTYPLOT)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :STEEL
	pkmn5.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:PORYGON2,50)
	pkmn6.item = :EVIOLITE
	pkmn6.ability_index = 2 # TRACE
	pkmn6.nature = :BOLD
	pkmn6.learn_move(:THUNDERBOLT)
	pkmn6.learn_move(:ICEBEAM)
	pkmn6.learn_move(:TRICKROOM)
	pkmn6.learn_move(:RECOVER)
	pkmn6.ev[:HP] = 256
	pkmn6.ev[:ATTACK] = 0 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn6.ev[:DEFENSE] = 196
	pkmn6.ev[:SPECIAL_DEFENSE] = 60
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :ELECTRIC
	pkmn6.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen5FirePartyQuickStart50 # Poke Paste: https://pokepast.es/9de684bec8b65aa6
	pkmn1 = Pokemon.new(:EMBOAR,50)
	pkmn1.item = :CHOICESCARF
	pkmn1.ability_index = 0 # RECKLESS
	pkmn1.nature = :JOLLY
	pkmn1.learn_move(:HEADSMASH)
	pkmn1.learn_move(:FLAREBLITZ)
	pkmn1.learn_move(:DOUBLEEDGE)
	pkmn1.learn_move(:WILDCHARGE)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :GRASS
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:SABLEYE,50)
	pkmn2.item = :REDCARD
	pkmn2.ability_index = 4 # PRANKSTER
	pkmn2.nature = :CAREFUL
	pkmn2.learn_move(:SUNNYDAY)
	pkmn2.learn_move(:WILLOWISP)
	pkmn2.learn_move(:KNOCKOFF)
	pkmn2.learn_move(:SPIRITSHACKLE)
	pkmn2.ev[:HP] = 256
	pkmn2.iv[:ATTACK] = 4
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 252
	pkmn2.ev[:SPEED] = 0
	pkmn2.tera_type = :STEEL
	pkmn2.dynamax_able = false
	pkmn2.calc_stats
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:NINETALES,50)
	pkmn3.item = :HEATROCK
	pkmn3.ability_index = 0 # DROUGHT
	pkmn3.nature = :TIMID
	pkmn3.learn_move(:FLAMEBURST)
	pkmn3.learn_move(:SOLARBEAM)
	pkmn3.learn_move(:ENCORE)
	pkmn3.learn_move(:HEALINGWISH)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :FLYING
	pkmn3.dynamax_able = false
	pkmn3.calc_stats
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:EXEGGUTOR,50)
	pkmn4.item = :LUMBERRY
	pkmn4.ability_index = 3 # HARVEST
	pkmn4.nature = :MODEST
	pkmn4.learn_move(:REST)
	pkmn4.learn_move(:STUNSPORE)
	pkmn4.learn_move(:GIGADRAIN)
	pkmn4.learn_move(:PSYSHOCK)
	pkmn4.ev[:HP] = 252
	pkmn4.ev[:ATTACK] = 176
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 84
	pkmn4.tera_type = :WATER
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:VENUSAUR,50)
	pkmn5.item = :LIFEORB
	pkmn5.ability_index = 3 # CHLOROPHYLL
	pkmn5.nature = :MODEST
	pkmn5.learn_move(:GROWTH)
	pkmn5.learn_move(:SOLARBEAM)
	pkmn5.learn_move(:WEATHERBALL)
	pkmn5.learn_move(:ACIDSPRAY)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :FIRE
	pkmn5.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:SWAMPERT,50)
	pkmn6.item = :HONEY
	pkmn6.ability_index = 0 # REGENERATOR
	pkmn6.nature = :ADAMANT
	pkmn6.learn_move(:FLIPTURN)
	pkmn6.learn_move(:EGGBOMB)
	pkmn6.learn_move(:KNOCKOFF)
	pkmn6.learn_move(:STEALTHROCK)
	pkmn6.ev[:HP] = 256
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :POISON
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen5WaterPartyQuickStart50 # Poke Paste: https://pokepast.es/87d1f20a06b7af01 (Samurott needs to be tweaked to be it's base form)
	pkmn1 = Pokemon.new(:SAMUROTT,50)
	pkmn1.item = :ASSAULTVEST
	pkmn1.ability_index = 4 # SHARPNESS
	pkmn1.nature = :ADAMANT
	pkmn1.learn_move(:SLASH)
	pkmn1.learn_move(:RAZORSHELL)
	pkmn1.learn_move(:AQUAJET)
	pkmn1.learn_move(:CEASELESSEDGE)
	pkmn1.ev[:HP] = 248
	pkmn1.ev[:ATTACK] = 84
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 124
	pkmn1.ev[:SPEED] = 56
	pkmn1.tera_type = :GHOST
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:CLEFABLE,50)
	pkmn2.item = :HONEY
	pkmn2.ability_index = 3 # FRIENDGUARD
	pkmn2.nature = :BOLD
	pkmn2.learn_move(:MOONBLAST)
	pkmn2.learn_move(:MISTYTERRAIN)
	pkmn2.learn_move(:FOLLOWME)
	pkmn2.learn_move(:PROTECT)
	pkmn2.ev[:HP] = 248
	pkmn2.ev[:ATTACK] = 0
	pkmn2.ev[:DEFENSE] = 180
	pkmn2.ev[:SPECIAL_DEFENSE] = 84
	pkmn2.ev[:SPEED] = 0
	pkmn2.tera_type = :WATER
	pkmn2.dynamax_able = false
	pkmn2.calc_stats
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:GARCHOMP,50)
	pkmn3.item = :LIFEORB
	pkmn3.ability_index = 6 # HYPERCUTTER
	pkmn3.nature = :JOLLY
	pkmn3.learn_move(:PROTECT)
	pkmn3.learn_move(:SLASH)
	pkmn3.learn_move(:DRAGONCLAW)
	pkmn3.learn_move(:IRONTAIL)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :FIRE
	pkmn3.dynamax_able = false
	pkmn3.calc_stats
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:GHOLDENGO,50)
	pkmn4.item = :LEFTOVERS
	pkmn4.ability_index = 4 # RATTLED
	pkmn4.nature = :MODEST
	pkmn4.learn_move(:EGGBOMB)
	pkmn4.learn_move(:ASTRALBARRAGE)
	pkmn4.learn_move(:NASTYPLOT)
	pkmn4.learn_move(:PROTECT)
	pkmn4.ev[:HP] = 236
	pkmn4.ev[:ATTACK] = 52 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn4.ev[:DEFENSE] = 4
	pkmn4.ev[:SPECIAL_DEFENSE] = 52
	pkmn4.ev[:SPEED] = 168
	pkmn4.tera_type = :DRAGON
	pkmn4.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:HYDREIGON,50)
	pkmn5.item = :CHOICESPECS
	pkmn5.ability_index = 4 # MEGALAUNCHER (Moves such as Flamethrower are now boosted by Mega Launcher)
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:HYPERBEAM)
	pkmn5.learn_move(:DRACOMETEOR)
	pkmn5.learn_move(:FIREBLAST)
	pkmn5.learn_move(:FLASHCANNON)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :POISON
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:WHIMSICOTT,50)
	pkmn6.item = :FOCUSSASH
	pkmn6.ability_index = 0 # PRANKSTER
	pkmn6.nature = :TIMID
	pkmn6.learn_move(:EGGBOMB)
	pkmn6.learn_move(:TAILWIND)
	pkmn6.learn_move(:SUNNYDAY)
	pkmn6.learn_move(:ENCORE)
	pkmn6.ev[:HP] = 184
	pkmn6.ev[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 108
	pkmn6.ev[:SPEED] = 220
	pkmn6.tera_type = :DARK
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen6GrassPartyQuickStart50 # Poke Paste: https://pokepast.es/6f4e9f30a5729a02
	pkmn1 = Pokemon.new(:CHESNAUGHT,50)
	pkmn1.item = :LEFTOVERS
	pkmn1.ability_index = 3 # SHELLARMOR
	pkmn1.nature = :IMPISH
	pkmn1.learn_move(:REST)
	pkmn1.learn_move(:TAUNT)
	pkmn1.learn_move(:SAPPYSEED)
	pkmn1.learn_move(:METALBURST)
	pkmn1.ev[:HP] = 256
	pkmn1.ev[:ATTACK] = 0
	pkmn1.ev[:DEFENSE] = 80
	pkmn1.ev[:SPECIAL_DEFENSE] = 176
	pkmn1.ev[:SPEED] = 0
	pkmn1.tera_type = :WATER
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:ROARINGMOON,50)
	pkmn2.item = :BOOSTERENERGY
	pkmn2.ability_index = 0 # PROTOSYNTHESIS
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:DRAGONDANCE)
	pkmn2.learn_move(:KNOCKOFF)
	pkmn2.learn_move(:ACROBATICS)
	pkmn2.learn_move(:BRICKBREAK)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :FLYING
	pkmn2.dynamax_able = false
	pkmn2.calc_stats
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:GREATTUSK,50)
	pkmn3.item = :HEAVYDUTYBOOTS
	pkmn3.ability_index = 5 # THICKFAT
	pkmn3.nature = :JOLLY
	pkmn3.learn_move(:VICTORYDANCE)
	pkmn3.learn_move(:RAPIDSPIN)
	pkmn3.learn_move(:EGGBOMB)
	pkmn3.learn_move(:ICESPINNER)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :POISON
	pkmn3.dynamax_able = false
	pkmn3.calc_stats
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:RILLABOOM,50)
	pkmn4.item = :TERRAINEXTENDER
	pkmn4.ability_index = 0 # GRASSYSURGE
	pkmn4.nature = :ADAMANT
	pkmn4.learn_move(:UTURN)
	pkmn4.learn_move(:GRASSYGLIDE)
	pkmn4.learn_move(:TAUNT)
	pkmn4.learn_move(:KNOCKOFF)
	pkmn4.ev[:HP] = 240
	pkmn4.ev[:ATTACK] = 252 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 20
	pkmn4.tera_type = :GRASS
	pkmn4.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:HEATRAN,50)
	pkmn5.item = :AIRBALLOON
	pkmn5.ability_index = 6 # ROCKYPAYLOAD (Rocky Payload gives Rock STAB, and will set Stealth Rock if user is hit by a contact move
	pkmn5.nature = :BOLD
	pkmn5.learn_move(:EMBER)
	pkmn5.learn_move(:EARTHPOWER)
	pkmn5.learn_move(:MAGMASTORM)
	pkmn5.learn_move(:MORNINGSUN)
	pkmn5.ev[:HP] = 252
	pkmn5.ev[:ATTACK] = 0
	pkmn5.ev[:DEFENSE] = 88
	pkmn5.ev[:SPECIAL_DEFENSE] = 172
	pkmn5.ev[:SPEED] = 0
	pkmn5.tera_type = :GHOST
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:HAWLUCHA,50)
	pkmn6.item = :GRASSYSEED
	pkmn6.ability_index = 0 # UNBURDEN
	pkmn6.nature = :ADAMANT
	pkmn6.learn_move(:SWORDSDANCE)
	pkmn6.learn_move(:ENCORE)
	pkmn6.learn_move(:EGGBOMB)
	pkmn6.learn_move(:CLOSECOMBAT)
	pkmn6.ev[:HP] = 128
	pkmn6.ev[:ATTACK] = 252
	pkmn6.ev[:DEFENSE] = 4
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 128
	pkmn6.tera_type = :ELECTRIC
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen6FirePartyQuickStart50 # Poke Paste: https://pokepast.es/b601021be152e474
	pkmn1 = Pokemon.new(:DELPHOX,50)
	pkmn1.item = :LIFEORB
	pkmn1.ability_index = 2 # BATTLEBOND
	pkmn1.nature = :TIMID
	pkmn1.learn_move(:EXPANDINGFORCE)
	pkmn1.learn_move(:HEATWAVE)
	pkmn1.learn_move(:GRASSKNOT)
	pkmn1.learn_move(:PROTECT)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :GRASS
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:INDEEDEE,50)
	pkmn2.makeMale # Only done for Male Indeede, to make sure the correct form sprite is used
	pkmn2.item = :FOCUSSASH
	pkmn2.ability_index = 0 # PSYCHICSURGE
	pkmn2.nature = :TIMID
	pkmn2.learn_move(:EXPANDINGFORCE)
	pkmn2.learn_move(:TERABLAST)
	pkmn2.learn_move(:IMPRISON)
	pkmn2.learn_move(:TRICKROOM)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :FIGHTING
	pkmn2.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:SNEASLER,50)
	pkmn3.item = :PSYCHICSEED
	pkmn3.ability_index = 0 # UNBURDEN
	pkmn3.nature = :JOLLY
	pkmn3.learn_move(:EGGBOMB)
	pkmn3.learn_move(:CLOSECOMBAT)
	pkmn3.learn_move(:POISONTAIL)
	pkmn3.learn_move(:PROTECT)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :DARK
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:WHIMSICOTT,50)
	pkmn4.item = :FOCUSSASH
	pkmn4.ability_index = 0 # PRANKSTER
	pkmn4.nature = :TIMID
	pkmn4.learn_move(:EGGBOMB)
	pkmn4.learn_move(:TAILWIND)
	pkmn4.learn_move(:SUNNYDAY)
	pkmn4.learn_move(:ENCORE)
	pkmn4.ev[:HP] = 184
	pkmn4.ev[:ATTACK] = 0
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 108
	pkmn4.ev[:SPEED] = 220
	pkmn4.tera_type = :WATER
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:MAUSHOLD,50)
	pkmn5.item = :WIDELENS
	pkmn5.ability_index = 4 # TECHNICIAN 
	pkmn5.nature = :JOLLY
	pkmn5.learn_move(:POPULATIONBOMB)
	pkmn5.learn_move(:FOLLOWME)
	pkmn5.learn_move(:BITE)
	pkmn5.learn_move(:PROTECT)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :NORMAL
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:ANNIHILAPE,50)
	pkmn6.item = :ASSAULTVEST
	pkmn6.ability_index = 5 # MOXIE
	pkmn6.nature = :JOLLY
	pkmn6.learn_move(:FINALGAMBIT)
	pkmn6.learn_move(:DRAINPUNCH)
	pkmn6.learn_move(:MEGAPUNCH)
	pkmn6.learn_move(:ROCKTOMB)
	pkmn6.ev[:HP] = 252
	pkmn6.ev[:ATTACK] = 76
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 180
	pkmn6.tera_type = :FIRE
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen6WaterPartyQuickStart50 # Poke Paste: https://pokepast.es/5504c7ce0c736539
	pkmn1 = Pokemon.new(:GRENINJA,50)
	pkmn1.item = :MEGAITE
	pkmn1.ability_index = 0 # PROTEAN
	pkmn1.nature = :TIMID
	pkmn1.learn_move(:HYDROCANNON)
	pkmn1.learn_move(:EGGBOMB)
	pkmn1.learn_move(:AEROBLAST)
	pkmn1.learn_move(:EXTRASENSORY)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :WATER
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:CLODSIRE,50)
	pkmn2.item = :HEAVYDUTYBOOTS
	pkmn2.ability_index = 3 # WATERABSORB
	pkmn2.nature = :CAREFUL
	pkmn2.learn_move(:STEALTHROCK)
	pkmn2.learn_move(:RAPIDSPIN)
	pkmn2.learn_move(:SPIKES)
	pkmn2.learn_move(:RECOVER)
	pkmn2.ev[:HP] = 252
	pkmn2.ev[:ATTACK] = 0 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn2.ev[:DEFENSE] = 8
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 252
	pkmn2.tera_type = :DARK
	pkmn2.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:GHOLDENGO,50)
	pkmn3.item = :COVERTCLOAK
	pkmn3.ability_index = 5 # PRANKSTER
	pkmn3.nature = :TIMID
	pkmn3.learn_move(:SHADOWBALL)
	pkmn3.learn_move(:EGGBOMB)
	pkmn3.learn_move(:RECOVER)
	pkmn3.learn_move(:NASTYPLOT)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :FLYING
	pkmn3.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:IRONVALIANT,50)
	pkmn4.item = :CHOICESPECS
	pkmn4.ability_index = 4 # MOTORDRIVE
	pkmn4.nature = :TIMID
	pkmn4.learn_move(:SPARKLYSWIRL)
	pkmn4.learn_move(:PSYSHOCK)
	pkmn4.learn_move(:TRICK)
	pkmn4.learn_move(:THUNDERBOLT)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :FAIRY
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:GREATTUSK,50)
	pkmn5.item = :ROCKYHELMET
	pkmn5.ability_index = 4 # THICKFAT 
	pkmn5.nature = :IMPISH
	pkmn5.learn_move(:RAPIDSPIN)
	pkmn5.learn_move(:BULKUP)
	pkmn5.learn_move(:KNOCKOFF)
	pkmn5.learn_move(:BODYPRESS)
	pkmn5.ev[:HP] = 256
	pkmn5.ev[:ATTACK] = 0
	pkmn5.ev[:DEFENSE] = 216
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 40
	pkmn5.tera_type = :STEEL
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:CORVIKNIGHT,50)
	pkmn6.item = :LEFTOVERS
	pkmn6.ability_index = 0 # STAMINA
	pkmn6.nature = :CAREFUL
	pkmn6.learn_move(:DOUBLEEDGE)
	pkmn6.learn_move(:MEDITATE)
	pkmn6.learn_move(:ROOST)
	pkmn6.learn_move(:BODYPRESS)
	pkmn6.ev[:HP] = 256
	pkmn6.ev[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 4
	pkmn6.ev[:SPECIAL_DEFENSE] = 252
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :GROUND
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen7GrassPartyQuickStart50 # Poke Paste: https://pokepast.es/6b48dc53126cba80
	pkmn1 = Pokemon.new(:DECIDUEYE,50)
	pkmn1.item = :BIGROOT
	pkmn1.ability_index = 0 # LONGREACH
	pkmn1.nature = :JOLLY
	pkmn1.learn_move(:SAPPYSEED)
	pkmn1.learn_move(:UTURN)
	pkmn1.learn_move(:HAZE)
	pkmn1.learn_move(:TAILWIND)
	pkmn1.ev[:HP] = 20
	pkmn1.ev[:ATTACK] = 0
	pkmn1.ev[:DEFENSE] = 100
	pkmn1.ev[:SPECIAL_DEFENSE] = 144
	pkmn1.ev[:SPEED] = 248
	pkmn1.tera_type = :FAIRY
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:CERULEDGE,50)
	pkmn2.item = :LIFEORB
	pkmn2.ability_index = 0 # SHARPNESS
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:BITTERBLADE)
	pkmn2.learn_move(:SLASH)
	pkmn2.learn_move(:CLOSECOMAT)
	pkmn2.learn_move(:PROTECT)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :GRASS
	pkmn2.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:INCINEROAR,50)
	pkmn3.item = :SAFETYGOGGLES
	pkmn3.ability_index = 0 # Intimidate
	pkmn3.nature = :CAREFUL
	pkmn3.learn_move(:FAKEOUT)
	pkmn3.learn_move(:PARTINGSHOT)
	pkmn3.learn_move(:FLAREBLITZ)
	pkmn3.learn_move(:KNOCKOFF)
	pkmn3.ev[:HP] = 244
	pkmn3.ev[:ATTACK] = 4
	pkmn3.ev[:DEFENSE] = 132
	pkmn3.ev[:SPECIAL_DEFENSE] = 84
	pkmn3.ev[:SPEED] = 48
	pkmn3.tera_type = :GHOST
	pkmn3.dynamax_able = false
	pkmn3.calc_stats
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:URSALUNA,50)
	pkmn4.item = :FLAMEORB
	pkmn4.ability_index = 0 # GUTS
	pkmn4.nature = :BRAVE
	pkmn4.learn_move(:FACADE)
	pkmn4.learn_move(:HEADLONGRUSH)
	pkmn4.learn_move(:FIREPUNCH)
	pkmn4.learn_move(:PROTECT)
	pkmn4.ev[:HP] = 140
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 44
	pkmn4.ev[:SPECIAL_DEFENSE] = 68
	pkmn4.ev[:SPEED] = 0
	pkmn4.tera_type = :POISON
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:TORKOAL,50)
	pkmn5.item = :EJECTPACK
	pkmn5.ability_index = 2 # DROUGHT
	pkmn5.nature = :QUIET
	pkmn5.learn_move(:ERUPTION)
	pkmn5.learn_move(:OVERHEAT)
	pkmn5.learn_move(:HELPINGHAND)
	pkmn5.learn_move(:PROTECT)
	pkmn5.ev[:HP] = 176
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 72
	pkmn5.ev[:SPEED] = 0
	pkmn5.tera_type = :FIRE
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:PORYGON2,50)
	pkmn6.item = :EVIOLITE
	pkmn6.ability_index = 0 # ANALYTIC
	pkmn6.nature = :BOLD
	pkmn6.learn_move(:ICEBEAM)
	pkmn6.learn_move(:EGGBOMB)
	pkmn6.learn_move(:TRICKROOM)
	pkmn6.learn_move(:RECOVER)
	pkmn6.ev[:HP] = 256
	pkmn6.ev[:ATTACK] = 8
	pkmn6.ev[:DEFENSE] = 176
	pkmn6.ev[:SPECIAL_DEFENSE] = 72
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :FIGHTING
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen7FirePartyQuickStart50 # Poke Paste: https://pokepast.es/b7fb981ef157f4aa
	pkmn1 = Pokemon.new(:INCINEROAR,50)
	pkmn1.item = :SAFETYGOGGLES
	pkmn1.ability_index = 0 # Intimidate
	pkmn1.nature = :CAREFUL
	pkmn1.learn_move(:FAKEOUT)
	pkmn1.learn_move(:PARTINGSHOT)
	pkmn1.learn_move(:FLAREBLITZ)
	pkmn1.learn_move(:KNOCKOFF)
	pkmn1.ev[:HP] = 256
	pkmn1.ev[:ATTACK] = 0
	pkmn1.ev[:DEFENSE] = 164
	pkmn1.ev[:SPECIAL_DEFENSE] = 92
	pkmn1.ev[:SPEED] = 0
	pkmn1.tera_type = :GHOST
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:RILLABOOM,50)
	pkmn2.item = :ASSAULTVEST
	pkmn2.ability_index = 0 # GRASSYSURGE
	pkmn2.nature = :ADAMANT
	pkmn2.learn_move(:WOODHAMMER)
	pkmn2.learn_move(:GRASSYGLIDE)
	pkmn2.learn_move(:FAKEOUT)
	pkmn2.learn_move(:UTURN)
	pkmn2.ev[:HP] = 248
	pkmn2.ev[:ATTACK] = 116
	pkmn2.ev[:DEFENSE] = 12
	pkmn2.ev[:SPECIAL_DEFENSE] = 132
	pkmn2.ev[:SPEED] = 4
	pkmn2.tera_type = :POISON
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:FARIGIRAF,50)
	pkmn3.item = :THROATSPRAY
	pkmn3.ability_index = 0 # Armor Tail
	pkmn3.nature = :MODEST
	pkmn3.learn_move(:PROTECT)
	pkmn3.learn_move(:TRICKROOM)
	pkmn3.learn_move(:HYPERVOICE)
	pkmn3.learn_move(:PSYCHIC)
	pkmn3.ev[:HP] = 112
	pkmn3.ev[:ATTACK] = 156
	pkmn3.ev[:DEFENSE] = 44
	pkmn3.ev[:SPECIAL_DEFENSE] = 196
	pkmn3.ev[:SPEED] = 0
	pkmn3.iv[:ATTACK] = 0
	pkmn3.iv[:SPEED] = 27
	pkmn3.tera_type = :FAIRY
	pkmn3.dynamax_able = false
	pkmn3.calc_stats
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:FLUTTERMANE,50)
	pkmn4.item = :BOOSTERENERGY
	pkmn4.ability_index = 0 # Protosynthesis
	pkmn4.nature = :TIMID
	pkmn4.learn_move(:PROTECT)
	pkmn4.learn_move(:MOONBLAST)
	pkmn4.learn_move(:SHADOWBALL)
	pkmn4.learn_move(:CALMMIND)
	pkmn4.ev[:HP] = 164
	pkmn4.ev[:ATTACK] = 108
	pkmn4.ev[:DEFENSE] = 164
	pkmn4.ev[:SPECIAL_DEFENSE] = 4
	pkmn4.ev[:SPEED] = 72
	pkmn4.iv[:ATTACK] = 0
	pkmn4.tera_type = :GRASS
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:URSHIFU_1,50)
	pkmn5.item = :CHOICESCARF
	pkmn5.ability_index = 0 # Defiant
	pkmn5.nature = :ADAMANT
	pkmn5.learn_move(:SURGINGSTRIKES)
	pkmn5.learn_move(:CLOSECOMBAT)
	pkmn5.learn_move(:AQUAJET)
	pkmn5.learn_move(:UTURN)
	pkmn5.ev[:HP] = 44
	pkmn5.ev[:ATTACK] = 156
	pkmn5.ev[:DEFENSE] = 4
	pkmn5.ev[:SPECIAL_DEFENSE] = 92
	pkmn5.ev[:SPEED] = 216
	pkmn5.iv[:SPECIAL_ATTACK] = 0
	pkmn5.tera_type = :WATER
	pkmn5.dynamax_able = false
	pkmn5.calc_stats
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:OGERPON,50)
	pkmn6.item = :HEARTHFLAMEMASK
	pkmn6.nature = :JOLLY
	pkmn6.learn_move(:IVYCUDGEL)
	pkmn6.learn_move(:GRASSYGLIDE)
	pkmn6.learn_move(:SWORDSDANCE)
	pkmn6.learn_move(:SPIKYSHIELD)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.iv[:SPECIAL_ATTACK] = 0
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen7WaterPartyQuickStart50 # Poke Paste: https://pokepast.es/40b6bff80a7d28e3
	pkmn1 = Pokemon.new(:PRIMARINA,50)
	pkmn1.item = :CUSTAPBERRY
	pkmn1.ability_index = 4 # BATTLEBOND
	pkmn1.nature = :MODEST
	pkmn1.learn_move(:SPARKLYSWIRL)
	pkmn1.learn_move(:HYDROCANNON)
	pkmn1.learn_move(:ENCORE)
	pkmn1.learn_move(:CALMMIND)
	pkmn1.ev[:HP] = 76
	pkmn1.ev[:ATTACK] = 252
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 184
	pkmn1.tera_type = :STEEL
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:GLISCOR,50)
	pkmn2.item = :LEFTOVERS
	pkmn2.ability_index = 5 # PRANKSTER
	pkmn2.nature = :CAREFUL
	pkmn2.learn_move(:KNOCKOFF)
	pkmn2.learn_move(:POISONSTING)
	pkmn2.learn_move(:RAPIDSPIN)
	pkmn2.learn_move(:VENOMDRENCH)
	pkmn2.ev[:HP] = 248
	pkmn2.ev[:ATTACK] = 0
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 240
	pkmn2.ev[:SPEED] = 24
	pkmn2.tera_type = :FLYING
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:TINGLU,50)
	pkmn3.item = :ROCKYHELMET
	pkmn3.ability_index = 0 # VESSELOFRUIN
	pkmn3.nature = :CAREFUL
	pkmn3.learn_move(:STEALTHROCK)
	pkmn3.learn_move(:SPIKES)
	pkmn3.learn_move(:SANDATTACK)
	pkmn3.learn_move(:RUINATION)
	pkmn3.ev[:HP] = 248
	pkmn3.ev[:DEFENSE] = 16
	pkmn3.ev[:SPECIAL_DEFENSE] = 248
	pkmn3.ev[:SPEED] = 0
	pkmn3.tera_type = :WATER
	pkmn3.dynamax_able = false
	pkmn3.calc_stats
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:ZAPDOS,50)
	pkmn4.item = :HEAVYDUTYBOOTS
	pkmn4.ability_index = 0 # LIGHTNINGROD
	pkmn4.nature = :BOLD
	pkmn4.learn_move(:AEROBLAST)
	pkmn4.learn_move(:VOLTSWITCH)
	pkmn4.learn_move(:THUNDERWAVE)
	pkmn4.learn_move(:ROOST)
	pkmn4.ev[:HP] = 252
	pkmn4.ev[:ATTACK] = 0
	pkmn4.ev[:DEFENSE] = 244
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 16
	pkmn4.iv[:ATTACK] = 0
	pkmn4.tera_type = :DRAGON
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:GHOLDENGO,50)
	pkmn5.item = :SHUCABERRY
	pkmn5.ability_index = 4 # RATTLED
	pkmn5.nature = :MODEST
	pkmn5.learn_move(:SHADOWBALL)
	pkmn5.learn_move(:EGGBOMB)
	pkmn5.learn_move(:RECOVER)
	pkmn5.learn_move(:NASTYPLOT)
	pkmn5.ev[:HP] = 192
	pkmn5.ev[:ATTACK] = 152 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 16
	pkmn5.ev[:SPEED] = 152
	pkmn5.tera_type = :WATER
	pkmn5.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:DARKRAI,50)
	pkmn6.item = :LIFEORB
	pkmn6.nature = :TIMID
	pkmn6.learn_move(:BLOODMOON)
	pkmn6.learn_move(:MOONGEISTBEAM)
	pkmn6.learn_move(:SLUDGEBOMB)
	pkmn6.learn_move(:NASTYPLOT)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.iv[:ATTACK] = 0
	pkmn6.tera_type = :POISON
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen8GrassPartyQuickStart50 # Poke Paste: https://pokepast.es/8f4767c8ef7df026
	pkmn1 = Pokemon.new(:RILLABOOM,50)
	pkmn1.item = :CHOICEBAND
	pkmn1.ability_index = 0 # GRASSYSURGE
	pkmn1.nature = :ADAMANT
	pkmn1.learn_move(:WOODHAMMER)
	pkmn1.learn_move(:GRASSYGLIDE)
	pkmn1.learn_move(:UTURN)
	pkmn1.learn_move(:KNOCKOFF)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :GRASS
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:OGERPON,50)
	pkmn2.item = :CORNERSTONEMASK
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:IVYCUDGEL)
	pkmn2.learn_move(:POWERWHIP)
	pkmn2.learn_move(:SPIKES)
	pkmn2.learn_move(:TAUNT)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.iv[:SPECIAL_ATTACK] = 0
	pkmn2.dynamax_able = false
	pkmn2.calc_stats
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:RAGINGBOLT,50)
	pkmn3.item = :HONEY
	pkmn3.ability_index = 4 # INTIMIDATE
	pkmn3.nature = :MODEST
	pkmn3.learn_move(:THUNDERCLAP)
	pkmn3.learn_move(:HYPERBEAM)
	pkmn3.learn_move(:ANCIENTPOWER)
	pkmn3.learn_move(:CALMMIND)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn2.iv[:ATTACK] = 0
	pkmn3.tera_type = :WATER
	pkmn3.dynamax_able = false
	pkmn3.calc_stats
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:IRONMOTH,50)
	pkmn4.item = :PASSHOBERRY
	pkmn4.ability_index = 2 # LEVITATE
	pkmn4.nature = :TIMID
	pkmn4.learn_move(:QUIVERDANCE)
	pkmn4.learn_move(:SUBSTITUTE)
	pkmn4.learn_move(:EGGBOMB)
	pkmn4.learn_move(:EMBER)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 132
	pkmn4.ev[:DEFENSE] = 124
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :GHOST
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:IRONVALIANT,50)
	pkmn5.item = :BOOSTERENERGY
	pkmn5.ability_index = 0 # QUARKDRIVE
	pkmn5.nature = :JOLLY
	pkmn5.learn_move(:PLAYROUGH)
	pkmn5.learn_move(:COACHING)
	pkmn5.learn_move(:WIDEGUARD)
	pkmn5.learn_move(:ENCORE)
	pkmn5.ev[:HP] = 204
	pkmn5.ev[:ATTACK] = 4
	pkmn5.ev[:DEFENSE] = 100
	pkmn5.ev[:SPECIAL_DEFENSE] = 28
	pkmn5.ev[:SPEED] = 176
	pkmn5.tera_type = :ELECTRIC
	pkmn5.dynamax_able = false
	pkmn5.calc_stats
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:KINGAMBIT,50)
	pkmn6.item = :LUMBERRY
	pkmn6.nature = :JOLLY
	pkmn6.learn_move(:SWORDSDANCE)
	pkmn6.learn_move(:KOWTOWCLEAVE)
	pkmn6.learn_move(:SUCKERPUNCH)
	pkmn6.learn_move(:IRONHEAD)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.iv[:ATTACK] = 0
	pkmn6.tera_type = :DARK
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen8FirePartyQuickStart50 # Poke Paste: https://pokepast.es/999f4123b7a772e8
	pkmn1 = Pokemon.new(:CINDERACE,50)
	pkmn1.item = :GIGANTAITE
	pkmn1.ability_index = 4 # LIMBER
	pkmn1.nature = :JOLLY
	pkmn1.learn_move(:MEGAKICK)
	pkmn1.learn_move(:SUCKERPUNCH)
	pkmn1.learn_move(:UTURN)
	pkmn1.learn_move(:COURTCHANGE)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :WATER
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:SLOWKING_1,50)
	pkmn2.item = :HEAVYDUTYBOOTS
	pkmn2.ability_index = 4 # REGENERATOR
	pkmn2.nature = :RELAXED
	pkmn2.learn_move(:PSYCHICNOISE)
	pkmn2.learn_move(:EGGBOMB)
	pkmn2.learn_move(:ICEBEAM)
	pkmn2.learn_move(:UTURN)
	pkmn2.ev[:HP] = 252
	pkmn2.ev[:ATTACK] = 0
	pkmn2.ev[:DEFENSE] = 252
	pkmn2.ev[:SPECIAL_DEFENSE] = 8
	pkmn2.ev[:SPEED] = 0
	pkmn2.tera_type = :GRASS
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:TINGLU,50)
	pkmn3.item = :LEFTOVERS
	pkmn3.ability_index = 5 # ROCKYPAYLOAD
	pkmn3.nature = :CAREFUL
	pkmn3.learn_move(:REST)
	pkmn3.learn_move(:SPIKES)
	pkmn3.learn_move(:SANDATTACK)
	pkmn3.learn_move(:PAYPACK)
	pkmn3.ev[:HP] = 252
	pkmn3.ev[:DEFENSE] = 8
	pkmn3.ev[:SPECIAL_DEFENSE] = 252
	pkmn3.ev[:SPEED] = 0
	pkmn3.tera_type = :FAIRY
	pkmn3.dynamax_able = false
	pkmn3.calc_stats
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:CORVIKNIGHT,50)
	pkmn4.item = :ROCKYHELMET
	pkmn4.ability_index = 2 # PRESSURE
	pkmn4.nature = :IMPISH
	pkmn4.learn_move(:BODYPRESS)
	pkmn4.learn_move(:DEFOG)
	pkmn4.learn_move(:ROOST)
	pkmn4.learn_move(:UTURN)
	pkmn4.ev[:HP] = 252
	pkmn4.ev[:ATTACK] = 0
	pkmn4.ev[:DEFENSE] = 252
	pkmn4.ev[:SPECIAL_DEFENSE] = 8
	pkmn4.ev[:SPEED] = 0
	pkmn4.tera_type = :DRAGON
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:RAGINGBOLT,50)
	pkmn5.item = :CHOICESPECS
	pkmn5.ability_index = 4 # INTIMIDATE
	pkmn5.nature = :MODEST
	pkmn5.learn_move(:VOLTSWITCH)
	pkmn5.learn_move(:HYPERBEAM)
	pkmn5.learn_move(:THUNDERBOLT)
	pkmn5.learn_move(:THUNDERCLAP)
	pkmn5.ev[:HP] = 112
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 144
	pkmn5.iv[:ATTACK] = 0
	pkmn5.tera_type = :BUG
	pkmn5.dynamax_able = false
	pkmn5.calc_stats
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:OGERPON,50)
	pkmn6.item = :WELLSPRINGMASK
	pkmn6.nature = :JOLLY
	pkmn6.learn_move(:IVYCUDGEL)
	pkmn6.learn_move(:KNOCKOFF)
	pkmn6.learn_move(:UTURN)
	pkmn6.learn_move(:ENCORE)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.iv[:SPECIAL_ATTACK] = 0
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen8WaterPartyQuickStart50 # Poke Paste: https://pokepast.es/fa6099e03a99dbd5
	pkmn1 = Pokemon.new(:INTELEON,50)
	pkmn1.item = :SCOPELENS
	pkmn1.ability_index = 6 # SUPERLUCK
	pkmn1.nature = :TIMID
	pkmn1.learn_move(:SNIPESHOT)
	pkmn1.learn_move(:EGGBOMB)
	pkmn1.learn_move(:ICEBEAM)
	pkmn1.learn_move(:PROTECT)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :GROUND
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:MAUSHOLD,50)
	pkmn2.item = :FOCUSSASH
	pkmn2.ability_index = 4 # TECHNICIAN 
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:POPULATIONBOMB)
	pkmn2.learn_move(:FOLLOWME)
	pkmn2.learn_move(:PROTECT)
	pkmn2.learn_move(:TIDYUP)
	pkmn2.ev[:HP] = 4
	pkmn2.ev[:ATTACK] = 252
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :GHOST
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:GHOLDENGO,50)
	pkmn3.item = :LIFEORB
	pkmn3.ability_index = 0 # WONDERSKIN
	pkmn3.nature = :MODEST
	pkmn3.learn_move(:MAKEITRAIN)
	pkmn3.learn_move(:SHADOWBALL)
	pkmn3.learn_move(:NASTYPLOT)
	pkmn3.learn_move(:PROTECT)
	pkmn3.ev[:HP] = 252
	pkmn3.ev[:ATTACK] = 92
	pkmn3.ev[:DEFENSE] = 4
	pkmn3.ev[:SPECIAL_DEFENSE] = 44
	pkmn3.ev[:SPEED] = 120
	pkmn3.tera_type = :STEEL
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:INCINEROAR,50)
	pkmn4.item = :HONEY
	pkmn4.ability_index = 0 # INTIMIDATE
	pkmn4.nature = :CAREFUL
	pkmn4.learn_move(:FLAREBLITZ)
	pkmn4.learn_move(:KNOCKOFF)
	pkmn4.learn_move(:FAKEOUT)
	pkmn4.learn_move(:PARTINGSHOT)
	pkmn4.ev[:HP] = 248
	pkmn4.ev[:ATTACK] = 0
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 212
	pkmn4.ev[:SPEED] = 52
	pkmn4.tera_type = :WATER
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:RILLABOOM,50)
	pkmn5.item = :ASSAULTVEST
	pkmn5.ability_index = 0 # GRASSYSURGE
	pkmn5.nature = :ADAMANT
	pkmn5.learn_move(:WOODHAMMER)
	pkmn5.learn_move(:GRASSYGLIDE)
	pkmn5.learn_move(:FAKEOUT)
	pkmn5.learn_move(:UTURN)
	pkmn5.ev[:HP] = 204
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 52
	pkmn5.tera_type = :FIRE
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:SNEASLER,50)
	pkmn6.item = :GRASSYSEED
	pkmn6.ability_index = 0 # UNBURDEN
	pkmn6.nature = :JOLLY
	pkmn6.learn_move(:EGGBOMB)
	pkmn6.learn_move(:CLOSECOMBAT)
	pkmn6.learn_move(:POISONTAIL)
	pkmn6.learn_move(:FAKEOUT)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.tera_type = :FLYING
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen9GrassPartyQuickStart50 # Poke Paste: https://pokepast.es/9a7f780862533fde
	pkmn1 = Pokemon.new(:MEOWSCARADA,50)
	pkmn1.item = :FOCUSSASH
	pkmn1.ability_index = 6 # MAGICBOUNCE
	pkmn1.nature = :JOLLY
	pkmn1.learn_move(:KNOCKOFF)
	pkmn1.learn_move(:UTURN)
	pkmn1.learn_move(:TRIPLEAXEL)
	pkmn1.learn_move(:STEALTHROCK)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :GHOST
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:GLISCOR,50)
	pkmn2.item = :ROCKYHELMET
	pkmn2.ability_index = 3 # LEVITATE
	pkmn2.nature = :CAREFUL
	pkmn2.learn_move(:RAPIDSPIN)
	pkmn2.learn_move(:ROOST)
	pkmn2.learn_move(:SPIKES)
	pkmn2.learn_move(:POISONSTING)
	pkmn2.ev[:HP] = 248
	pkmn2.ev[:ATTACK] = 0
	pkmn2.ev[:DEFENSE] = 88
	pkmn2.ev[:SPECIAL_DEFENSE] = 176
	pkmn2.ev[:SPEED] = 0
	pkmn2.tera_type = :ELECTRIC
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:URSALUNA,50)
	pkmn3.item = :ASSAULTVEST
	pkmn3.ability_index = 6 # INTIMIDATE
	pkmn3.nature = :ADAMANT
	pkmn3.learn_move(:GIGAIMPACT)
	pkmn3.learn_move(:STOMPINGTANTRUM)
	pkmn3.learn_move(:AVALANCHE)
	pkmn3.learn_move(:DRAINPUNCH)
	pkmn3.ev[:HP] = 188
	pkmn3.ev[:ATTACK] = 56
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 208
	pkmn3.ev[:SPEED] = 60
	pkmn3.tera_type = :POISON
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:SKARMORY,50)
	pkmn4.item = :LEFTOVERS
	pkmn4.ability_index = 0 # BATTLEARMOR
	pkmn4.nature = :IMPISH
	pkmn4.learn_move(:BEAKBLAST)
	pkmn4.learn_move(:ROOST)
	pkmn4.learn_move(:WHIRLWIND)
	pkmn4.learn_move(:METALBURST)
	pkmn4.ev[:HP] = 244
	pkmn4.ev[:ATTACK] = 0
	pkmn4.ev[:DEFENSE] = 216
	pkmn4.ev[:SPECIAL_DEFENSE] = 44
	pkmn4.ev[:SPEED] = 8
	pkmn4.tera_type = :DRAGON
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:SLOWKING_1,50)
	pkmn5.item = :HEAVYDUTYBOOTS
	pkmn5.ability_index = 4 # REGENERATOR
	pkmn5.nature = :RELAXED
	pkmn5.learn_move(:PSYCHICNOISE)
	pkmn5.learn_move(:EGGBOMB)
	pkmn5.learn_move(:THUNDERWAVE)
	pkmn5.learn_move(:UTURN)
	pkmn5.ev[:HP] = 252
	pkmn5.ev[:ATTACK] = 0
	pkmn5.ev[:DEFENSE] = 8
	pkmn5.ev[:SPECIAL_DEFENSE] = 252
	pkmn5.ev[:SPEED] = 0
	pkmn5.tera_type = :WATER
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:DRAGAPULT,50)
	pkmn6.item = :LIFEORB
	pkmn6.ability_index = 6 # INFILTRATOR
	pkmn6.nature = :TIMID
	pkmn6.learn_move(:EGGBOMB)
	pkmn6.learn_move(:HEX)
	pkmn6.learn_move(:UTURN)
	pkmn6.learn_move(:WILLOWISP)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.tera_type = :FIRE
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen9FirePartyQuickStart50 # Poke Paste: https://pokepast.es/b8add99b4fadea57
	pkmn1 = Pokemon.new(:SKELEDIRGE,50)
	pkmn1.item = :HEAVYDUTYBOOTS
	pkmn1.ability_index = 0 # UNAWARE
	pkmn1.nature = :BOLD
	pkmn1.learn_move(:TORCHSONG)
	pkmn1.learn_move(:ALLURINGVOICE)
	pkmn1.learn_move(:WILLOWISP)
	pkmn1.learn_move(:SLACKOFF)
	pkmn1.ev[:HP] = 252
	pkmn1.ev[:ATTACK] = 0
	pkmn1.ev[:DEFENSE] = 16
	pkmn1.ev[:SPECIAL_DEFENSE] = 244
	pkmn1.ev[:SPEED] = 0
	pkmn1.tera_type = :FAIRY
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:IRONTREADS,50)
	pkmn2.item = :BOOSTERENERGY
	pkmn2.ability_index = 2 # STURDY
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:RAPIDSPIN)
	pkmn2.learn_move(:STEALTHROCK)
	pkmn2.learn_move(:HEADLONGRUSH)
	pkmn2.learn_move(:EGGBOMB)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :GRASS
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:ENAMORUS,50)
	pkmn3.item = :FOCUSSASH
	pkmn3.ability_index = 5 # QUEENLYMAJESTY
	pkmn3.nature = :MODEST
	pkmn3.learn_move(:MOONBLAST)
	pkmn3.learn_move(:EARTHPOWER)
	pkmn3.learn_move(:CALMMIND)
	pkmn3.learn_move(:TAUNT)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :GROUND
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:ROARINGMOON,50)
	pkmn4.item = :LIFEORB
	pkmn4.ability_index = 2 # INTIMIDATE
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:KNOCKOFF)
	pkmn4.learn_move(:PARTINGSHOT)
	pkmn4.learn_move(:DRAGONASCENT)
	pkmn4.learn_move(:IRONTAIL)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 220
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 36
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :STEEL
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:ZAMAZENTA,50)
	pkmn5.item = :RUSTEDSHIELD
	pkmn5.ability_index = 3 # BATTLEARMOR
	pkmn5.nature = :JOLLY
	pkmn5.learn_move(:BODYPRESS)
	pkmn5.learn_move(:CRUNCH)
	pkmn5.learn_move(:VICTORYDANCE)
	pkmn5.learn_move(:ROAR)
	pkmn5.ev[:HP] = 88
	pkmn5.iv[:ATTACK] = 0
	pkmn5.ev[:DEFENSE] = 252
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 172
	pkmn5.tera_type = :DRAGON
	pkmn5.dynamax_able = false
	pkmn5.calc_stats
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:OGERPON,50)
	pkmn6.item = :WELLSPRINGMASK
	pkmn6.nature = :JOLLY
	pkmn6.learn_move(:IVYCUDGEL)
	pkmn6.learn_move(:POWERWHIP)
	pkmn6.learn_move(:UTURN)
	pkmn6.learn_move(:ENCORE)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.iv[:SPECIAL_ATTACK] = 0
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen9WaterPartyQuickStart50 # Poke Paste: https://pokepast.es/2aaa84dab1d690bf
	pkmn1 = Pokemon.new(:QUAQUAVAL,50)
	pkmn1.item = :FOCUSSASH
	pkmn1.ability_index = 5 # DAZZLING
	pkmn1.nature = :JOLLY
	pkmn1.learn_move(:VICTORYDANCE)
	pkmn1.learn_move(:CLOSECOMAT)
	pkmn1.learn_move(:LIQUIDATION)
	pkmn1.learn_move(:ICESPINNER)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :STEEL
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:KINGDRA,50)
	pkmn2.item = :LIFEORB
	pkmn2.ability_index = 0 # SWIFTSWIM
	pkmn2.nature = :MODEST
	pkmn2.learn_move(:DRACOMETEOR)
	pkmn2.learn_move(:WEATHERBALL)
	pkmn2.learn_move(:MUDDYWATER)
	pkmn2.learn_move(:PROTECT)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :STELLAR
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:POLITOED,50)
	pkmn3.item = :HONEY
	pkmn3.ability_index = 4 # DRIZZLE
	pkmn3.nature = :BOLD
	pkmn3.learn_move(:WEATHERBALL)
	pkmn3.learn_move(:PERISHSONG)
	pkmn3.learn_move(:ENCORE)
	pkmn3.learn_move(:PROTECT)
	pkmn3.ev[:HP] = 256
	pkmn3.ev[:ATTACK] = 0
	pkmn3.ev[:DEFENSE] = 184
	pkmn3.ev[:SPECIAL_DEFENSE] = 72
	pkmn3.ev[:SPEED] = 0
	pkmn3.tera_type = :GRASS
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:GOTHITELLE,50)
	pkmn4.item = :LEFTOVERS
	pkmn4.ability_index = 3 # MAGICBOUNCE
	pkmn4.nature = :CALM
	pkmn4.learn_move(:PROTECT)
	pkmn4.learn_move(:PSYCHIC)
	pkmn4.learn_move(:FAKEOUT)
	pkmn4.learn_move(:TRICKROOM)
	pkmn4.ev[:HP] = 256
	pkmn4.ev[:DEFENSE] = 100
	pkmn4.ev[:SPECIAL_DEFENSE] = 156
	pkmn4.iv[:ATTACK] = 0
	pkmn4.tera_type = :DARK
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:INCINEROAR,50)
	pkmn5.item = :SAFETYGOGGLES
	pkmn5.ability_index = 0 # Intimidate
	pkmn5.nature = :CAREFUL
	pkmn5.learn_move(:FAKEOUT)
	pkmn5.learn_move(:PARTINGSHOT)
	pkmn5.learn_move(:KNOCKOFF)
	pkmn5.learn_move(:PROTECT)
	pkmn5.ev[:HP] = 244
	pkmn5.ev[:ATTACK] = 4
	pkmn5.ev[:DEFENSE] = 132
	pkmn5.ev[:SPECIAL_DEFENSE] = 84
	pkmn5.ev[:SPEED] = 48
	pkmn5.tera_type = :GHOST
	pkmn5.dynamax_able = false
	pkmn5.calc_stats
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:AMOONGUSS,50)
	pkmn6.item = :MENTALHERB
	pkmn6.ability_index = 3 # Regenerator
	pkmn6.nature = :BOLD
	pkmn6.learn_move(:PROTECT)
	pkmn6.learn_move(:RAGEPOWDER)
	pkmn6.learn_move(:SPORE)
	pkmn6.learn_move(:POLLENPUFF)
	pkmn6.ev[:HP] = 240
	pkmn6.ev[:DEFENSE] = 236
	pkmn6.ev[:SPECIAL_DEFENSE] = 36
	pkmn6.iv[:SPEED] = 0
	pkmn6.tera_type = :FAIRY
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen9FightingPartyQuickStart50 # Poke Paste: https://pokepast.es/74e2807d6251ac7c
	pkmn1 = Pokemon.new(:DECIDUEYE_1,50)
	pkmn1.item = :SCOPELENS
	pkmn1.ability_index = 3 # SCRAPPY
	pkmn1.nature = :JOLLY
	pkmn1.learn_move(:LEAFBLADE)
	pkmn1.learn_move(:TRIPLEARROWS)
	pkmn1.learn_move(:HAZE)
	pkmn1.learn_move(:PROTECT)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :FIRE
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:DRAGAPULT,50)
	pkmn2.item = :CHOICEBAND
	pkmn2.ability_index = 0 # PARENTALBOND
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:DRAGONDARTS)
	pkmn2.learn_move(:SHADOWFORCE)
	pkmn2.learn_move(:UTURN)
	pkmn2.learn_move(:PSYCHICFANGS)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :DRAGON
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:VOLCARONA,50)
	pkmn3.item = :HONEY
	pkmn3.ability_index = 0 # LEVITATE
	pkmn3.nature = :TIMID
	pkmn3.learn_move(:EMBER)
	pkmn3.learn_move(:GIGADRAIN)
	pkmn3.learn_move(:QUIVERDANCE)
	pkmn3.learn_move(:PROTECT)
	pkmn3.ev[:HP] = 248
	pkmn3.ev[:ATTACK] = 12
	pkmn3.ev[:DEFENSE] = 92
	pkmn3.ev[:SPECIAL_DEFENSE] = 28
	pkmn3.ev[:SPEED] = 132
	pkmn3.tera_type = :GRASS
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:HATTERENE,50)
	pkmn4.item = :LIFEORB
	pkmn4.ability_index = 0 # MAGICBOUNCE
	pkmn4.nature = :QUIET
	pkmn4.learn_move(:EXPANDINGFORCE)
	pkmn4.learn_move(:DAZZLINGGLEAM)
	pkmn4.learn_move(:TRICKROOM)
	pkmn4.learn_move(:PROTECT)
	pkmn4.ev[:HP] = 216
	pkmn4.ev[:ATTACK] = 204
	pkmn4.ev[:DEFENSE] = 68
	pkmn4.ev[:SPECIAL_DEFENSE] = 24
	pkmn4.iv[:ATTACK] = 0
	pkmn4.iv[:SPEED] = 0
	pkmn4.tera_type = :PSYCHIC
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:TYRANITAR,50)
	pkmn5.item = :ASSAULTVEST
	pkmn5.ability_index = 2 # SHEERFORCE
	pkmn5.nature = :SASSY
	pkmn5.learn_move(:ROCKSLIDE)
	pkmn5.learn_move(:KNOCKOFF)
	pkmn5.learn_move(:EGGBOMB)
	pkmn5.learn_move(:STRENGTH)
	pkmn5.ev[:HP] = 140
	pkmn5.ev[:ATTACK] = 252
	pkmn5.ev[:DEFENSE] = 4
	pkmn5.ev[:SPECIAL_DEFENSE] = 4
	pkmn5.ev[:SPEED] = 112
	pkmn5.tera_type = :FLYING
	pkmn5.dynamax_able = false
	pkmn5.calc_stats
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:INDEEDEE,50)
	pkmn6.makeMale # Only done for Male Indeede, to make sure the correct form sprite is used
	pkmn6.item = :LUMBERRY
	pkmn6.ability_index = 0 # PSYCHICSURGE
	pkmn6.nature = :RELAXED
	pkmn6.learn_move(:PSYCHIC)
	pkmn6.learn_move(:FOLLOWME)
	pkmn6.learn_move(:TRICKROOM)
	pkmn6.learn_move(:HELPINGHAND)
	pkmn6.ev[:HP] = 256
	pkmn6.ev[:ATTACK] = 0 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn6.ev[:DEFENSE] = 256
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :FAIRY
	pkmn6.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen9GhostPartyQuickStart50 # Poke Paste: https://pokepast.es/d0e936b567d7f639
	pkmn1 = Pokemon.new(:TYPHLOSION_1,50)
	pkmn1.item = :CHOICESCARF
	pkmn1.ability_index = 0 # SOULHEART
	pkmn1.nature = :TIMID
	pkmn1.learn_move(:OVERHEAT)
	pkmn1.learn_move(:ERUPTION)
	pkmn1.learn_move(:SHADOWBALL)
	pkmn1.learn_move(:HEATWAVE)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :FIRE
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:WEEZING_1,50)
	pkmn2.item = :CHOICESPECS
	pkmn2.ability_index = 2 # NEUTRALIZINGGAS
	pkmn2.nature = :MODEST
	pkmn2.learn_move(:EGGBOMB)
	pkmn2.learn_move(:STRANGESTEAM)
	pkmn2.learn_move(:DAZZLINGGLEAM)
	pkmn2.learn_move(:FLAMETHROWER)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :FLYING
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:GARCHOMP,50)
	pkmn3.item = :LIFEORB
	pkmn3.ability_index = 6 # HYPERCUTTER
	pkmn3.nature = :JOLLY
	pkmn3.learn_move(:PROTECT)
	pkmn3.learn_move(:SLASH)
	pkmn3.learn_move(:DRAGONCLAW)
	pkmn3.learn_move(:IRONTAIL)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :FIRE
	pkmn3.dynamax_able = false
	pkmn3.calc_stats
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:CORVIKNIGHT,50)
	pkmn4.item = :HONEY
	pkmn4.ability_index = 4 # MIRRORARMOR
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:DOUBLEEDGE)
	pkmn4.learn_move(:TAILWIND)
	pkmn4.learn_move(:ROOST)
	pkmn4.learn_move(:BULKUP)
	pkmn4.ev[:HP] = 252
	pkmn4.ev[:ATTACK] = 0
	pkmn4.ev[:DEFENSE] = 44
	pkmn4.ev[:SPECIAL_DEFENSE] = 144
	pkmn4.ev[:SPEED] = 72
	pkmn4.tera_type = :DRAGON
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:TOEDSCRUEL,50)
	pkmn5.item = :COVERTCLOAK
	pkmn5.ability_index = 5 # LONGREACH
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:EGGBOMB)
	pkmn5.learn_move(:ACIDSPRAY)
	pkmn5.learn_move(:STUNSPORE)
	pkmn5.learn_move(:RAGEPOWER)
	pkmn5.ev[:HP] = 180
	pkmn5.ev[:ATTACK] = 12
	pkmn5.ev[:DEFENSE] = 64
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :WATER
	pkmn5.dynamax_able = false
	pkmn5.calc_stats
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:BAXCALIBUR,50)
	pkmn6.item = :LOADEDDICE
	pkmn6.ability_index = 0 # THERMALEXCHANGE
	pkmn6.nature = :ADAMANT
	pkmn6.learn_move(:ICICLESPEAR)
	pkmn6.learn_move(:SCALESHOT)
	pkmn6.learn_move(:SWORDSDANCE)
	pkmn6.learn_move(:PROTECT)
	pkmn6.ev[:HP] = 256
	pkmn6.ev[:ATTACK] = 0 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.tera_type = :FAIRY
	pkmn6.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen9DarkPartyQuickStart50 # Poke Paste: https://pokepast.es/73c40bd837c0a2f0
	pkmn1 = Pokemon.new(:SAMUROTT_1,50)
	pkmn1.item = :ASSAULTVEST
	pkmn1.ability_index = 4 # SHARPNESS
	pkmn1.nature = :ADAMANT
	pkmn1.learn_move(:SLASH)
	pkmn1.learn_move(:RAZORSHELL)
	pkmn1.learn_move(:AQUAJET)
	pkmn1.learn_move(:CEASELESSEDGE)
	pkmn1.ev[:HP] = 248
	pkmn1.ev[:ATTACK] = 84
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 124
	pkmn1.ev[:SPEED] = 56
	pkmn1.tera_type = :FIRE
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:ZAMAZENTA,50)
	pkmn2.item = :RUSTEDSHIELD
	pkmn2.ability_index = 3 # BATTLEARMOR
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:BODYPRESS)
	pkmn2.learn_move(:STONEEDGE)
	pkmn2.learn_move(:VICTORYDANCE)
	pkmn2.learn_move(:IRONHEAD)
	pkmn2.ev[:HP] = 0
	pkmn2.iv[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :DRAGON
	pkmn2.dynamax_able = false
	pkmn2.calc_stats
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:CLEFABLE,50)
	pkmn3.item = :STICKYBARB
	pkmn3.ability_index = 2 # MAGICGUARD
	pkmn3.nature = :BOLD
	pkmn3.learn_move(:CALMMIND)
	pkmn3.learn_move(:FLAMETHROWER)
	pkmn3.learn_move(:MOONBLAST)
	pkmn3.learn_move(:MOONLIGHT)
	pkmn3.ev[:HP] = 252
	pkmn3.ev[:ATTACK] = 0
	pkmn3.ev[:DEFENSE] = 240
	pkmn3.ev[:SPECIAL_DEFENSE] = 8
	pkmn3.ev[:SPEED] = 20
	pkmn3.tera_type = :BUG
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:LANDORUS_1,50)
	pkmn4.item = :FOCUSSASH
	pkmn4.ability_index = 4 # INTIMIDATE
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:STEALTHROCK)
	pkmn4.learn_move(:EARTHQUAKE)
	pkmn4.learn_move(:SMACKDOWN)
	pkmn4.learn_move(:UTURN)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :GROUND
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:ROTOM_2,50)
	pkmn5.item = :COVERTCLOAK
	pkmn5.ability_index = 6 # SCREENCLEANER
	pkmn5.nature = :BOLD
	pkmn5.learn_move(:VOLTSWITCH)
	pkmn5.learn_move(:HYDROPUMP)
	pkmn5.learn_move(:SOAK)
	pkmn5.learn_move(:THUNDERWAVE)
	pkmn5.ev[:HP] = 256
	pkmn5.ev[:ATTACK] = 0
	pkmn5.ev[:DEFENSE] = 212
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 44
	pkmn5.tera_type = :FLYING
	pkmn5.dynamax_able = false
	pkmn5.calc_stats
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:DRAGAPULT,50)
	pkmn6.item = :HEAVYDUTYBOOTS
	pkmn6.ability_index = 6 # INFILTRATOR
	pkmn6.nature = :NAIVE
	pkmn6.learn_move(:DRAGONDARTS)
	pkmn6.learn_move(:HEX)
	pkmn6.learn_move(:WILLOWISP)
	pkmn6.learn_move(:UTURN)
	pkmn6.ev[:HP] = 60
	pkmn6.ev[:ATTACK] = 196
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.tera_type = :FAIRY
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoNormalPartyQuickStart50 # Poke Paste: https://pokepast.es/ac1b444e8fc174a9
	pkmn1 = Pokemon.new(:PIDGEOT,50)
	pkmn1.item = :HEAVYDUTYBOOTS
	pkmn1.ability_index = 3 # PICKUP
	pkmn1.nature = :IMPISH
	pkmn1.learn_move(:BRAVEBIRD)
	pkmn1.learn_move(:DEFOG)
	pkmn1.learn_move(:ROOST)
	pkmn1.learn_move(:UTURN)
	pkmn1.ev[:HP] = 252
	pkmn1.ev[:ATTACK] = 0
	pkmn1.ev[:DEFENSE] = 240
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 20
	pkmn1.tera_type = :FIGHTING
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:DITTO,50)
	pkmn2.item = :CHOICESCARF
	pkmn2.ability_index = 4 # IMPOSTER
	pkmn2.nature = :RELAXED
	pkmn2.learn_move(:TRANSFORM)
	pkmn2.ev[:HP] = 252
	pkmn2.iv[:ATTACK] = 8
	pkmn2.ev[:DEFENSE] = 252
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 0
	pkmn2.tera_type = :FAIRY
	pkmn2.dynamax_able = false
	pkmn2.calc_stats
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:TERAPAGOS,50)
	pkmn3.item = :WHITEHERB
	pkmn3.nature = :MODEST
	pkmn3.learn_move(:NORETREAT)
	pkmn3.learn_move(:SHELLSMASH)
	pkmn3.learn_move(:TAUNT)
	pkmn3.learn_move(:TERASTARSTORM)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:URSALUNA,50)
	pkmn4.item = :FLAMEORB
	pkmn4.ability_index = 0 # GUTS
	pkmn4.nature = :ADAMANT
	pkmn4.learn_move(:FACADE)
	pkmn4.learn_move(:HEADLONGRUSH)
	pkmn4.learn_move(:FIREPUNCH)
	pkmn4.learn_move(:SWORDSDANCE)
	pkmn4.ev[:HP] = 252
	pkmn4.ev[:ATTACK] = 252
	pkmn4.ev[:DEFENSE] = 8
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 0
	pkmn4.tera_type = :POISON
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:ZOROARK_1,50)
	pkmn5.item = :CHOICESPECS
	pkmn5.ability_index = 6 # INTIMIDATE
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:TRICK)
	pkmn5.learn_move(:MOONGEISTBEAM)
	pkmn5.learn_move(:HYPERBEAM)
	pkmn5.learn_move(:FOCUSBLAST)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :FAIRY
	pkmn5.dynamax_able = false
	pkmn5.calc_stats
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:BLISSEY,50)
	pkmn6.item = :LEFTOVERS
	pkmn6.ability_index = 3 # SCRAPPY
	pkmn6.nature = :BOLD
	pkmn6.learn_move(:SEISMICTOSS)
	pkmn6.learn_move(:SOFTBOILED)
	pkmn6.learn_move(:STEALTHROCK)
	pkmn6.learn_move(:THUNDERWAVE)
	pkmn6.ev[:HP] = 252
	pkmn6.ev[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 256
	pkmn6.ev[:SPECIAL_DEFENSE] = 4
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :GHOST
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoFightingPartyQuickStart50 # Poke Paste: https://pokepast.es/698aaabeafee46e1
	pkmn1 = Pokemon.new(:IRONVALIANT,50)
	pkmn1.item = :CHOICESCARF
	pkmn1.ability_index = 3 # SYNCHRONIZE
	pkmn1.nature = :NAIVE
	pkmn1.learn_move(:EGGBOMB)
	pkmn1.learn_move(:CLOSECOMAT)
	pkmn1.learn_move(:THUNDERBOLT)
	pkmn1.learn_move(:TRICK)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :GHOST
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:GREATTUSK,50)
	pkmn2.item = :ROCKYHELMET
	pkmn2.ability_index = 4 # THICKFAT 
	pkmn2.nature = :IMPISH
	pkmn2.learn_move(:EARTHQUAKE)
	pkmn2.learn_move(:VICTORYDANCE)
	pkmn2.learn_move(:KNOCKOFF)
	pkmn2.learn_move(:STEALTHROCK)
	pkmn2.ev[:HP] = 256
	pkmn2.ev[:ATTACK] = 0
	pkmn2.ev[:DEFENSE] = 156
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 100
	pkmn2.tera_type = :POISON
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:SCRAFTY,50)
	pkmn3.item = :LEFTOVERS
	pkmn3.ability_index = 2 # SHEDSKIN
	pkmn3.nature = :CAREFUL
	pkmn3.learn_move(:VICTORYDANCE)
	pkmn3.learn_move(:DRAINPUNCH)
	pkmn3.learn_move(:KNOCKOFF)
	pkmn3.learn_move(:REST)
	pkmn3.ev[:HP] = 252
	pkmn3.ev[:ATTACK] = 0
	pkmn3.ev[:DEFENSE] = 240
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 20
	pkmn3.tera_type = :FIGHTING
	pkmn3.dynamax_able = false
	pkmn3.calc_stats
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:IRONHANDS,50)
	pkmn4.item = :ASSAULTVEST
	pkmn4.ability_index = 2 # STEELWORKER
	pkmn4.nature = :CAREFUL
	pkmn4.learn_move(:DRAINPUNCH)
	pkmn4.learn_move(:ICEPUNCH)
	pkmn4.learn_move(:HEAVYSLAM)
	pkmn4.learn_move(:THUNDERPUNCH)
	pkmn4.ev[:HP] = 256
	pkmn4.ev[:ATTACK] = 4
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 252
	pkmn4.tera_type = :BUG
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:URSHIFU_1,50)
	pkmn5.item = :PUNCHINGGLOVE
	pkmn5.ability_index = 5 # TECHNICIAN
	pkmn5.nature = :JOLLY
	pkmn5.learn_move(:SURGINGSTRIKES)
	pkmn5.learn_move(:AQUAJET)
	pkmn5.learn_move(:VICTORYDANCE)
	pkmn5.learn_move(:TECHPOWERICE)
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.iv[:SPECIAL_ATTACK] = 0
	pkmn5.tera_type = :STELLAR
	pkmn5.dynamax_able = false
	pkmn5.calc_stats
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:SNEASLER,50)
	pkmn6.item = :AIRBALLOON
	pkmn6.ability_index = 0 # UNBURDEN
	pkmn6.nature = :ADAMANT
	pkmn6.learn_move(:EGGBOMB)
	pkmn6.learn_move(:CLOSECOMBAT)
	pkmn6.learn_move(:POISONTAIL)
	pkmn6.learn_move(:PROTECT)
	pkmn6.ev[:HP] = 144
	pkmn6.ev[:ATTACK] = 252
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 116
	pkmn6.tera_type = :DARK
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoFlyingPartyQuickStart50 # Poke Paste: https://pokepast.es/cb82e72f29563467
	pkmn1 = Pokemon.new(:SKARMORY,50)
	pkmn1.item = :ROCKYHELMET
	pkmn1.ability_index = 0 # BATTLEARMOR
	pkmn1.nature = :BOLD
	pkmn1.learn_move(:ROOST)
	pkmn1.learn_move(:IRONDEFENSE)
	pkmn1.learn_move(:WHIRLWIND)
	pkmn1.learn_move(:BODYPRESS)
	pkmn1.ev[:HP] = 256
	pkmn1.ev[:ATTACK] = 0
	pkmn1.ev[:DEFENSE] = 252
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 4
	pkmn1.tera_type = :GROUND
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:DRAGONITE,50)
	pkmn2.item = :CHOICEBAND
	pkmn2.ability_index = 0 # MULTISCALE 
	pkmn2.nature = :ADAMANT
	pkmn2.learn_move(:DRAGONASCENT)
	pkmn2.learn_move(:EXTREMESPEED)
	pkmn2.learn_move(:FIREPUNCH)
	pkmn2.learn_move(:EARTHQUAKE)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :FIGHTING
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:DODRIO,50)
	pkmn3.item = :LIFEORB
	pkmn3.ability_index = 5 # BIGPECKS
	pkmn3.nature = :JOLLY
	pkmn3.learn_move(:DOUBLEEDGE)
	pkmn3.learn_move(:SKYATTACK)
	pkmn3.learn_move(:KNOCKOFF)
	pkmn3.learn_move(:JUMPKICK)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :FIRE
	pkmn3.dynamax_able = false
	pkmn3.calc_stats
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:CORVIKNIGHT,50)
	pkmn4.item = :LEFTOVERS
	pkmn4.ability_index = 4 # MIRRORARMOR
	pkmn4.nature = :CAREFUL
	pkmn4.learn_move(:STEELWING)
	pkmn4.learn_move(:UTURN)
	pkmn4.learn_move(:DEFOG)
	pkmn4.learn_move(:ROOST)
	pkmn4.ev[:HP] = 252
	pkmn4.ev[:ATTACK] = 12
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 248
	pkmn4.tera_type = :DRAGON
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:TORNADUS_1,50)
	pkmn5.item = :ASSAULTVEST
	pkmn5.ability_index = 3 # REGENERATOR
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:UTURN)
	pkmn5.learn_move(:KNOCKOFF)
	pkmn5.learn_move(:AEROBLAST)
	pkmn5.learn_move(:HEATWAVE)
	pkmn5.ev[:HP] = 248
	pkmn5.ev[:ATTACK] = 0
	pkmn5.ev[:DEFENSE] = 12
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 252
	pkmn5.tera_type = :FLYING
	pkmn5.dynamax_able = false
	pkmn5.calc_stats
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:LANDORUS_1,50)
	pkmn6.item = :CHOICESCARF
	pkmn6.ability_index = 4 # INTIMIDATE
	pkmn6.nature = :JOLLY
	pkmn6.learn_move(:EARTHQUAKE)
	pkmn6.learn_move(:STONEEDGE)
	pkmn6.learn_move(:UTURN)
	pkmn6.learn_move(:STEALTHROCK)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.tera_type = :STEEL
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoPoisonPartyQuickStart50 # Poke Paste: https://pokepast.es/068863a5eb35a63c
	pkmn1 = Pokemon.new(:MUK_1,50)
	pkmn1.item = :BLACKSLUDGE
	pkmn1.ability_index = 0 # POISONTOUCH
	pkmn1.nature = :CAREFUL
	pkmn1.learn_move(:KNOCKOFF)
	pkmn1.learn_move(:DRAINPUNCH)
	pkmn1.learn_move(:POISONJAB)
	pkmn1.learn_move(:PROTECT)
	pkmn1.ev[:HP] = 256
	pkmn1.ev[:ATTACK] = 4
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 252
	pkmn1.ev[:SPEED] = 0
	pkmn1.tera_type = :POISON
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:SNEASLER,50)
	pkmn2.item = :AIRBALLOON
	pkmn2.ability_index = 0 # UNBURDEN
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:SWORDSDANCE)
	pkmn2.learn_move(:CLOSECOMBAT)
	pkmn2.learn_move(:EGGBOMB)
	pkmn2.learn_move(:ACROBATICS)
	pkmn2.ev[:HP] = 80
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 176
	pkmn2.tera_type = :DARK
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:SLOWKING_1,50)
	pkmn3.item = :ASSAULTVEST
	pkmn3.ability_index = 4 # REGENERATOR
	pkmn3.nature = :SASSY
	pkmn3.learn_move(:FUTURESIGHT)
	pkmn3.learn_move(:SLUDGEBOMB)
	pkmn3.learn_move(:ICEBEAM)
	pkmn3.learn_move(:FLAMETHROWER)
	pkmn3.ev[:HP] = 256
	pkmn3.ev[:ATTACK] = 60
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 196
	pkmn3.ev[:SPEED] = 0
	pkmn3.tera_type = :FLYING
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:CLODSIRE,50)
	pkmn4.item = :HEAVYDUTYBOOTS
	pkmn4.ability_index = 0 # UNAWARE
	pkmn4.nature = :IMPISH
	pkmn4.learn_move(:STEALTHROCK)
	pkmn4.learn_move(:RAPIDSPIN)
	pkmn4.learn_move(:TOXIC)
	pkmn4.learn_move(:RECOVER)
	pkmn4.ev[:HP] = 256
	pkmn4.ev[:ATTACK] = 0 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn4.ev[:DEFENSE] = 232
	pkmn4.ev[:SPECIAL_DEFENSE] = 24
	pkmn4.ev[:SPEED] = 0
	pkmn4.tera_type = :ICE
	pkmn4.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:IRONMOTH,50)
	pkmn5.item = :CHOICESPECS
	pkmn5.ability_index = 4 # SHADOWSHIELD
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:EGGBOMB)
	pkmn5.learn_move(:OVERHEAT)
	pkmn5.learn_move(:ENERGYBALL)
	pkmn5.learn_move(:THUNDERBOLT)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :FIRE
	pkmn5.dynamax_able = false
	pkmn5.calc_stats
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:WEEZING_1,50)
	pkmn6.item = :POWERHERB
	pkmn6.ability_index = 0 # LEVITATE
	pkmn6.nature = :BOLD
	pkmn6.learn_move(:GEOMANCY)
	pkmn6.learn_move(:DEFOG)
	pkmn6.learn_move(:WILLOWISP)
	pkmn6.learn_move(:MOONBLAST)
	pkmn6.ev[:HP] = 252
	pkmn6.ev[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 252
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 8
	pkmn6.tera_type = :ELECTRIC
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoGroundPartyQuickStart50 # Poke Paste: https://pokepast.es/0862ad1d0d311051
	pkmn1 = Pokemon.new(:HIPPOWDON,50)
	pkmn1.item = :EJECTBUTTON
	pkmn1.ability_index = 2 # SANDSTREAM
	pkmn1.nature = :IMPISH
	pkmn1.learn_move(:EARTHQUAKE)
	pkmn1.learn_move(:SLACKOFF)
	pkmn1.learn_move(:STEALTHROCK)
	pkmn1.learn_move(:WHIRLWIND)
	pkmn1.ev[:HP] = 256
	pkmn1.ev[:ATTACK] = 0
	pkmn1.ev[:DEFENSE] = 256
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 0
	pkmn1.tera_type = :POISON
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:EXCADRILL,50)
	pkmn2.item = :ASSAULTVEST
	pkmn2.ability_index = 2 # SANDFORCE
	pkmn2.nature = :ADAMANT
	pkmn2.learn_move(:RAPIDSPIN)
	pkmn2.learn_move(:EARTHQUAKE)
	pkmn2.learn_move(:ROCKCLIMB)
	pkmn2.learn_move(:SHADOWCLAW)
	pkmn2.ev[:HP] = 80
	pkmn2.ev[:ATTACK] = 176
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :FAIRY
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:LANDORUS,50)
	pkmn3.item = :LIFEORB
	pkmn3.ability_index = 2 # SHEERFORCE
	pkmn3.nature = :TIMID
	pkmn3.learn_move(:EARTHPOWER)
	pkmn3.learn_move(:FOCUSBLAST)
	pkmn3.learn_move(:PSYCHIC)
	pkmn3.learn_move(:GRAVITY)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :ICE
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:MAMOSWINE,50)
	pkmn4.item = :CHOICEBAND
	pkmn4.ability_index = 4 # SANDRUSH
	pkmn4.nature = :ADAMANT
	pkmn4.learn_move(:EGGBOMB)
	pkmn4.learn_move(:HEADLONGRUSH)
	pkmn4.learn_move(:ICESHARD)
	pkmn4.learn_move(:KNOCKOFF)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :FIRE
	pkmn4.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:CLODSIRE,50)
	pkmn5.item = :HEAVYDUTYBOOTS
	pkmn5.ability_index = 3 # WATERABSORB
	pkmn5.nature = :CAREFUL
	pkmn5.learn_move(:STEALTHROCK)
	pkmn5.learn_move(:SANDATTACK)
	pkmn5.learn_move(:MORTALSPIN)
	pkmn5.learn_move(:RECOVER)
	pkmn5.ev[:HP] = 252
	pkmn5.ev[:ATTACK] = 8 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 252
	pkmn5.ev[:SPEED] = 0
	pkmn5.tera_type = :DARK
	pkmn5.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:SANDYSHOCKS,50)
	pkmn6.item = :WEAKNESSPOLICY
	pkmn6.ability_index = 6 # FILTER
	pkmn6.nature = :TIMID
	pkmn6.learn_move(:EGGBOMB)
	pkmn6.learn_move(:THUNDERCLAP)
	pkmn6.learn_move(:GRAVITY)
	pkmn6.learn_move(:VOLTSWITCH)
	pkmn6.ev[:HP] = 52
	pkmn6.ev[:ATTACK] = 208
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 252
	pkmn6.tera_type = :ELECTRIC
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoRockPartyQuickStart50 # Poke Paste: https://pokepast.es/173aac7252c7b758
	pkmn1 = Pokemon.new(:IRONBOULDER,50)
	pkmn1.item = :CHOICESCARF
	pkmn1.ability_index = 2 # SHARPNESS
	pkmn1.nature = :JOLLY
	pkmn1.learn_move(:MIGHTYCLEAVE)
	pkmn1.learn_move(:PSYCHOCUT)
	pkmn1.learn_move(:SACREDSWORD)
	pkmn1.learn_move(:SLASH)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :FIRE
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:ARCANINE_1,50)
	pkmn2.item = :HEAVYDUTYBOOTS
	pkmn2.ability_index = 3 # ROCKHEAD
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:FLAREBLITZ)
	pkmn2.learn_move(:HEADSMASH)
	pkmn2.learn_move(:CLOSECOMAT)
	pkmn2.learn_move(:SUBSTITUTE)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :ROCK
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:GLIMMORA,50)
	pkmn3.item = :CHOICESPECS
	pkmn3.ability_index = 4 # LEVITATE
	pkmn3.nature = :TIMID
	pkmn3.learn_move(:HYPERBEAM)
	pkmn3.learn_move(:SLUDGEBOMB)
	pkmn3.learn_move(:ENERGYBALL)
	pkmn3.learn_move(:EARTHPOWER)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :ELECTRIC
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:MINIOR,50)
	pkmn4.item = :WHITEHERB
	pkmn4.ability_index = 0 # SHIELDSDOWN
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:EGGBOMB)
	pkmn4.learn_move(:STONEEDGE)
	pkmn4.learn_move(:EARTHQUAKE)
	pkmn4.learn_move(:SHELLSMASH)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :WATER
	pkmn4.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:GARGANACL,50)
	pkmn5.item = :LEFTOVERS
	pkmn5.ability_index = 0 # ROUGHSKIN
	pkmn5.nature = :CAREFUL
	pkmn5.learn_move(:STEALTHROCK)
	pkmn5.learn_move(:PROTECT)
	pkmn5.learn_move(:RECOVER)
	pkmn5.learn_move(:SALTCURE)
	pkmn5.ev[:HP] = 256
	pkmn5.ev[:ATTACK] = 0 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 256
	pkmn5.ev[:SPEED] = 0
	pkmn5.tera_type = :GHOST
	pkmn5.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:OGERPON,50)
	pkmn6.item = :CORNERSTONEMASK
	pkmn6.nature = :JOLLY
	pkmn6.learn_move(:IVYCUDGEL)
	pkmn6.learn_move(:HORNLEECH)
	pkmn6.learn_move(:SWORDSDANCE)
	pkmn6.learn_move(:SUPERPOWER)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.iv[:SPECIAL_ATTACK] = 0
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoBugPartyQuickStart50 # Poke Paste: https://pokepast.es/0a6ff83acecfc3b9
	pkmn1 = Pokemon.new(:VOLCARONA,50)
	pkmn1.item = :LEFTOVERS
	pkmn1.ability_index = 5 # FLASHFIRE
	pkmn1.nature = :TIMID
	pkmn1.learn_move(:QUIVERDANCE)
	pkmn1.learn_move(:EMBER)
	pkmn1.learn_move(:MORNINGSUN)
	pkmn1.learn_move(:PSYCHIC)
	pkmn1.ev[:HP] = 256
	pkmn1.ev[:ATTACK] = 28
	pkmn1.ev[:DEFENSE] = 176
	pkmn1.ev[:SPECIAL_DEFENSE] = 52
	pkmn1.ev[:SPEED] = 0
	pkmn1.tera_type = :POISON
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:FORRETRESS,50)
	pkmn2.item = :ROCKYHELMET
	pkmn2.ability_index = 6 # BATTLEARMOR
	pkmn2.nature = :IMPISH
	pkmn2.learn_move(:THUNDERWAVE)
	pkmn2.learn_move(:VOLTSWITCH)
	pkmn2.learn_move(:RAPIDSPIN)
	pkmn2.learn_move(:ICESPINNER)
	pkmn2.ev[:HP] = 256
	pkmn2.ev[:ATTACK] = 0
	pkmn2.ev[:DEFENSE] = 256
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 0
	pkmn2.tera_type = :ROCK
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:SCIZOR,50)
	pkmn3.item = :MEGAITE
	pkmn3.ability_index = 4 # INTIMIDATE
	pkmn3.nature = :ADAMANT
	pkmn3.learn_move(:SWORDSDANCE)
	pkmn3.learn_move(:BULLETPUNCH)
	pkmn3.learn_move(:KNOCKOFF)
	pkmn3.learn_move(:TRAILBLAZE)
	pkmn3.ev[:HP] = 124
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 132
	pkmn3.tera_type = :FIRE
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:KLEAVOR,50)
	pkmn4.item = :CHOICESCARF
	pkmn4.ability_index = 2 # SHARPNESS
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:STONEAXE)
	pkmn4.learn_move(:UTURN)
	pkmn4.learn_move(:NIGHTSLASH)
	pkmn4.learn_move(:SLASH)
	pkmn4.ev[:HP] = 256
	pkmn4.ev[:ATTACK] = 28
	pkmn4.ev[:DEFENSE] = 176
	pkmn4.ev[:SPECIAL_DEFENSE] = 52
	pkmn4.ev[:SPEED] = 0
	pkmn4.tera_type = :FIGHTING
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:YANMEGA,50)
	pkmn5.item = :CHOICESPECS
	pkmn5.ability_index = 5 # TINTEDLENS
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:AEROBLAST)
	pkmn5.learn_move(:EGGBOMB)
	pkmn5.learn_move(:DRACOMETEOR)
	pkmn5.learn_move(:UTURN)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :STEEL
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:ARAQUANID,50)
	pkmn6.item = :MENTALHERB
	pkmn6.ability_index = 0 # WATERBUBBLE
	pkmn6.nature = :ADAMANT
	pkmn6.learn_move(:LIQUIDATION)
	pkmn6.learn_move(:INFESTATION)
	pkmn6.learn_move(:STICKYWEB)
	pkmn6.learn_move(:MIRRORCOAT)
	pkmn6.ev[:HP] = 252
	pkmn6.ev[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 252
	pkmn6.ev[:SPECIAL_DEFENSE] = 8
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :GHOST
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoGhostPartyQuickStart50 # Poke Paste: https://pokepast.es/34eef7480aca0e56
	pkmn1 = Pokemon.new(:GHOLDENGO,50)
	pkmn1.item = :AIRBALLOON
	pkmn1.ability_index = 5 # PRANKSTER
	pkmn1.nature = :MODEST
	pkmn1.learn_move(:NASTYPLOT)
	pkmn1.learn_move(:SHADOWBALL)
	pkmn1.learn_move(:RECOVER)
	pkmn1.learn_move(:EGGBOMB)
	pkmn1.ev[:HP] = 136
	pkmn1.ev[:ATTACK] = 148
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 228
	pkmn1.tera_type = :FAIRY
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:CERULEDGE,50)
	pkmn2.item = :FOCUSSASH
	pkmn2.ability_index = 2 # WEAKARMOR
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:EGGBOMB)
	pkmn2.learn_move(:SACREDFIRE)
	pkmn2.learn_move(:SHADOWSNEAK)
	pkmn2.learn_move(:SWORDSDANCE)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :FIGHTING
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:FLUTTERMANE,50)
	pkmn3.item = :CHOICESPECS
	pkmn3.ability_index = 3 # INTIMIDATE
	pkmn3.nature = :TIMID
	pkmn3.learn_move(:EGGBOMB)
	pkmn3.learn_move(:MOONBLAST)
	pkmn3.learn_move(:THUNDERBOLT)
	pkmn3.learn_move(:POWERGEM)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :STELLAR
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:SPECTRIER,50)
	pkmn4.item = :LEFTOVERS
	pkmn4.ability_index = 5 # SHADOWSHIELD
	pkmn4.nature = :TIMID
	pkmn4.learn_move(:CALMMIND)
	pkmn4.learn_move(:SUBSTITUTE)
	pkmn4.learn_move(:WILLOWISP)
	pkmn4.learn_move(:HEX)
	pkmn4.ev[:HP] = 188
	pkmn4.ev[:ATTACK] = 0
	pkmn4.ev[:DEFENSE] = 124
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 200
	pkmn4.tera_type = :POISON
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:DRAGAPULT,50)
	pkmn5.item = :CHOICESCARF
	pkmn5.ability_index = 6 # INFILTRATOR
	pkmn5.nature = :NAIVE
	pkmn5.learn_move(:DRAGONDARTS)
	pkmn5.learn_move(:SHADOWBALL)
	pkmn5.learn_move(:UTURN)
	pkmn5.learn_move(:THUNDERWAVE)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :ELECTRIC
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:BRAMBLEGHAST,50)
	pkmn6.item = :ROCKYHELMET
	pkmn6.ability_index = 2 # IRONBARBS
	pkmn6.nature = :IMPISH
	pkmn6.learn_move(:SPIKES)
	pkmn6.learn_move(:RAPIDSPIN)
	pkmn6.learn_move(:STRENGTHSAP)
	pkmn6.learn_move(:SAPPYSEED)
	pkmn6.ev[:HP] = 256
	pkmn6.ev[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 240
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 16
	pkmn6.tera_type = :WATER
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoSteelPartyQuickStart50 # Poke Paste: https://pokepast.es/5b4e5ca4bee4d04d
	pkmn1 = Pokemon.new(:GHOLDENGO,50)
	pkmn1.item = :MENTALHERB
	pkmn1.ability_index = 5 # PRANKSTER
	pkmn1.nature = :MODEST
	pkmn1.learn_move(:NASTYPLOT)
	pkmn1.learn_move(:SHADOWBALL)
	pkmn1.learn_move(:RECOVER)
	pkmn1.learn_move(:EGGBOMB)
	pkmn1.ev[:HP] = 192
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 64
	pkmn1.tera_type = :FAIRY
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:HEATRAN,50)
	pkmn2.item = :AIRBALLOON
	pkmn2.ability_index = 6 # ROCKYPAYLOAD
	pkmn2.nature = :CALM
	pkmn2.learn_move(:ANCIENTPOWER)
	pkmn2.learn_move(:EARTHPOWER)
	pkmn2.learn_move(:LAVAPLUME)
	pkmn2.learn_move(:SLACKOFF)
	pkmn2.ev[:HP] = 228
	pkmn2.ev[:ATTACK] = 0
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 240
	pkmn2.ev[:SPEED] = 44
	pkmn2.tera_type = :GRASS
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:SKARMORY,50)
	pkmn3.item = :ROCKYHELMET
	pkmn3.ability_index = 5 # MIRRORARMOR
	pkmn3.nature = :BOLD
	pkmn3.learn_move(:SPIKES)
	pkmn3.learn_move(:ROOST)
	pkmn3.learn_move(:WHIRLWIND)
	pkmn3.learn_move(:BODYPRESS)
	pkmn3.ev[:HP] = 244
	pkmn3.ev[:ATTACK] = 0
	pkmn3.ev[:DEFENSE] = 172
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 96
	pkmn3.tera_type = :GROUND
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:ARCHALUDON,50)
	pkmn4.item = :CHOICESCARF
	pkmn4.ability_index = 0 # STAMINA
	pkmn4.nature = :TIMID
	pkmn4.learn_move(:BODYPRESS)
	pkmn4.learn_move(:DRACOMETEOR)
	pkmn4.learn_move(:HYPERBEAM)
	pkmn4.learn_move(:THUNDERBOLT)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :FLYING
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:IRONTREADS,50)
	pkmn5.item = :ASSAULTVEST
	pkmn5.ability_index = 3 # FILTER
	pkmn5.nature = :JOLLY
	pkmn5.learn_move(:RAPIDSPIN)
	pkmn5.learn_move(:KNOCKOFF)
	pkmn5.learn_move(:EARTHQUAKE)
	pkmn5.learn_move(:ICESPINNER)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :GHOST
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:SCIZOR,50)
	pkmn6.item = :POWERHERB
	pkmn6.ability_index = 0 # FULLMETALBODY
	pkmn6.nature = :ADAMANT
	pkmn6.learn_move(:GEOMANCY)
	pkmn6.learn_move(:SWORDSDANCE)
	pkmn6.learn_move(:DOUBLEHIT)
	pkmn6.learn_move(:FIRSTIMPRESSION)
	pkmn6.ev[:HP] = 252
	pkmn6.ev[:ATTACK] = 252
	pkmn6.ev[:DEFENSE] = 4
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 4
	pkmn6.tera_type = :FIRE
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoFirePartyQuickStart50 # Poke Paste: https://pokepast.es/57e510e3bdaf5c06
	pkmn1 = Pokemon.new(:CINDERACE,50)
	pkmn1.item = :MEGAITE
	pkmn1.ability_index = 4 # LIMBER
	pkmn1.nature = :JOLLY
	pkmn1.learn_move(:GIGAIMPACT)
	pkmn1.learn_move(:GUNKSHOT)
	pkmn1.learn_move(:HIGHJUMPKICK)
	pkmn1.learn_move(:UTURN)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :GRASS
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:CERULEDGE,50)
	pkmn2.item = :FOCUSSASH
	pkmn2.ability_index = 2 # WEAKARMOR
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:EGGBOMB)
	pkmn2.learn_move(:SACREDFIRE)
	pkmn2.learn_move(:SHADOWSNEAK)
	pkmn2.learn_move(:SWORDSDANCE)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :FIGHTING
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:TALONFLAME,50)
	pkmn3.item = :HEAVYDUTYBOOTS
	pkmn3.ability_index = 5 # FLAMEBODY
	pkmn3.nature = :TIMID
	pkmn3.learn_move(:AEROBLAST)
	pkmn3.learn_move(:UTURN)
	pkmn3.learn_move(:DEFOG)
	pkmn3.learn_move(:ROOST)
	pkmn3.ev[:HP] = 128
	pkmn3.ev[:ATTACK] = 0
	pkmn3.ev[:DEFENSE] = 252
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 132
	pkmn3.tera_type = :FAIRY
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:OGERPON,100)
	pkmn4.item = :HEARTHFLAMEMASK
	pkmn4.nature = :ADAMANT
	pkmn4.learn_move(:IVYCUDGEL)
	pkmn4.learn_move(:HORNLEECH)
	pkmn4.learn_move(:SWORDSDANCE)
	pkmn4.learn_move(:SUBSTITUTE)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.iv[:SPECIAL_ATTACK] = 0
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:VOLCANION,50)
	pkmn5.item = :HEATROCK
	pkmn5.ability_index = 3 # DROUGHT
	pkmn5.nature = :MODEST
	pkmn5.learn_move(:BLASTBURN)
	pkmn5.learn_move(:EARTHPOWER)
	pkmn5.learn_move(:SLUDGEBOMB)
	pkmn5.learn_move(:WHIRLPOOL)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :GROUND
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:HEATRAN,50)
	pkmn6.item = :LEFTOVERS
	pkmn6.ability_index = 0 # EARTHEATER
	pkmn6.nature = :CALM
	pkmn6.learn_move(:MAGMASTORM)
	pkmn6.learn_move(:EGGBOMB)
	pkmn6.learn_move(:EARTHPOWER)
	pkmn6.learn_move(:STEALTHROCK)
	pkmn6.ev[:HP] = 140
	pkmn6.ev[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 252
	pkmn6.ev[:SPEED] = 120
	pkmn6.tera_type = :ELECTRIC
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoWaterPartyQuickStart50 # Poke Paste: https://pokepast.es/46ba59df3fbabee0
	pkmn1 = Pokemon.new(:GRENINJA,50)
	pkmn1.item = :MEGAITE
	pkmn1.ability_index = 0 # PROTEAN
	pkmn1.nature = :TIMID
	pkmn1.learn_move(:HYDROCANNON)
	pkmn1.learn_move(:EGGBOMB)
	pkmn1.learn_move(:ICEBEAM)
	pkmn1.learn_move(:EXTRASENSORY)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :WATER
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:SUICUNE,50)
	pkmn2.item = :LEFTOVERS
	pkmn2.ability_index = 2 # PRESSURE
	pkmn2.nature = :BOLD
	pkmn2.learn_move(:SUBSTITUTE)
	pkmn2.learn_move(:CALMMIND)
	pkmn2.learn_move(:SCALD)
	pkmn2.learn_move(:REST)
	pkmn2.ev[:HP] = 256
	pkmn2.ev[:ATTACK] = 0
	pkmn2.ev[:DEFENSE] = 256
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 0
	pkmn2.tera_type = :FAIRY
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:TOXAPEX,50)
	pkmn3.item = :BINDINGBAND
	pkmn3.ability_index = 0 # TOXICDEBRIS
	pkmn3.nature = :BOLD
	pkmn3.learn_move(:TOXIC)
	pkmn3.learn_move(:HAZE)
	pkmn3.learn_move(:RECOVER)
	pkmn3.learn_move(:WHIRLPOOL)
	pkmn3.ev[:HP] = 256
	pkmn3.ev[:ATTACK] = 0
	pkmn3.ev[:DEFENSE] = 252
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 4
	pkmn3.tera_type = :DARK
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:EMPOLEON,100)
	pkmn4.item = :AIRBALLOON
	pkmn4.nature = :CALM
	pkmn4.learn_move(:STEALTHROCK)
	pkmn4.learn_move(:EGGBOMB)
	pkmn4.learn_move(:ROOST)
	pkmn4.learn_move(:ROAR)
	pkmn4.ev[:HP] = 256
	pkmn4.ev[:ATTACK] = 4
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 252
	pkmn4.ev[:SPEED] = 0
	pkmn4.tera_type = :GROUND
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:GASTRODON,50)
	pkmn5.item = :MENTALHERB
	pkmn5.ability_index = 6 # SHELLARMOR
	pkmn5.nature = :CALM
	pkmn5.learn_move(:SPIKES)
	pkmn5.learn_move(:EGGBOMB)
	pkmn5.learn_move(:HEALBELL)
	pkmn5.learn_move(:LUNARBLESSING)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :POISON
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:ALOMOMOLA,50)
	pkmn6.item = :GRIPCLAW
	pkmn6.ability_index = 0 # REGENERATOR
	pkmn6.nature = :SASSY
	pkmn6.learn_move(:FLIPTURN)
	pkmn6.learn_move(:WISH)
	pkmn6.learn_move(:PROTECT)
	pkmn6.learn_move(:WHIRLPOOL)
	pkmn6.ev[:HP] = 256
	pkmn6.ev[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 256
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :STEEL
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoGrassPartyQuickStart50 # Poke Paste: https://pokepast.es/4a7c53b5a7815701
	pkmn1 = Pokemon.new(:RILLABOOM,50)
	pkmn1.item = :MEGAITE
	pkmn1.ability_index = 5 # INTIMIDATE
	pkmn1.nature = :JOLLY
	pkmn1.learn_move(:DOUBLEHIT)
	pkmn1.learn_move(:KNOCKOFF)
	pkmn1.learn_move(:BODYPRESS)
	pkmn1.learn_move(:VICTORYDANCE)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :GRASS
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:MEOWSCARADA,50)
	pkmn2.item = :CHOICESCARF
	pkmn2.ability_index = 2 # BATTLEBOND
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:FLOWERTRICK)
	pkmn2.learn_move(:KNOCKOFF)
	pkmn2.learn_move(:PLAYROUGH)
	pkmn2.learn_move(:UTURN)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :GHOST
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:SINISTCHA,50)
	pkmn3.item = :LEFTOVERS
	pkmn3.ability_index = 0 # HEATPROOF
	pkmn3.nature = :BOLD
	pkmn3.learn_move(:CALMMIND)
	pkmn3.learn_move(:STRENGTHSAP)
	pkmn3.learn_move(:SHADOWBALL)
	pkmn3.learn_move(:MATCHAGOTHA)
	pkmn3.ev[:HP] = 252
	pkmn3.ev[:ATTACK] = 0
	pkmn3.ev[:DEFENSE] = 160
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 100
	pkmn3.tera_type = :POISON
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:OGERPON,100)
	pkmn4.item = :HEARTHFLAMEMASK
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:IVYCUDGEL)
	pkmn4.learn_move(:HORNLEECH)
	pkmn4.learn_move(:SWORDSDANCE)
	pkmn4.learn_move(:PLAYROUGH)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.iv[:SPECIAL_ATTACK] = 0
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:WHIMSICOTT,50)
	pkmn5.item = :PIXIEPLATE
	pkmn5.ability_index = 0 # PRANKSTER
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:MOONBLAST)
	pkmn5.learn_move(:ENERGYBALL)
	pkmn5.learn_move(:UTURN)
	pkmn5.learn_move(:MEMENTO)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :FLYING
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:AMOONGUSS,50)
	pkmn6.item = :ROCKYHELMET
	pkmn6.ability_index = 3 # Regenerator
	pkmn6.nature = :CALM
	pkmn6.learn_move(:FOULPLAY)
	pkmn6.learn_move(:SLUDGEBOMB)
	pkmn6.learn_move(:SYNTHESIS)
	pkmn6.learn_move(:SPORE)
	pkmn6.ev[:HP] = 244
	pkmn6.ev[:DEFENSE] = 164
	pkmn6.ev[:SPECIAL_DEFENSE] = 104
	pkmn6.iv[:SPEED] = 0
	pkmn6.tera_type = :FAIRY
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoElectricPartyQuickStart50 # Poke Paste: https://pokepast.es/240c891d4149ca55
	pkmn1 = Pokemon.new(:RAGINGBOLT,50)
	pkmn1.item = :ELECTRICSEED
	pkmn1.ability_index = 4 # INTIMIDATE
	pkmn1.nature = :MODEST
	pkmn1.learn_move(:THUNDER)
	pkmn1.learn_move(:EGGBOMB)
	pkmn1.learn_move(:THUNDERCLAP)
	pkmn1.learn_move(:CALMMIND)
	pkmn1.ev[:HP] = 124
	pkmn1.ev[:ATTACK] = 252
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 136
	pkmn1.tera_type = :BUG
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:IRONHANDS,50)
	pkmn2.item = :ASSAULTVEST
	pkmn2.ability_index = 0 # QUARKDRIVE
	pkmn2.nature = :CAREFUL
	pkmn2.learn_move(:DRAINPUNCH)
	pkmn2.learn_move(:WILDCHARGE)
	pkmn2.learn_move(:HEAVYSLAM)
	pkmn2.learn_move(:VOLTSWITCH)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 136
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 208
	pkmn2.ev[:SPEED] = 168
	pkmn2.tera_type = :GRASS
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:ROTOM_2,50)
	pkmn3.item = :DAMPROCK
	pkmn3.ability_index = 3 # DRIZZLE
	pkmn3.nature = :BOLD
	pkmn3.learn_move(:SOAK)
	pkmn3.learn_move(:HYDROPUMP)
	pkmn3.learn_move(:VOLTSWITCH)
	pkmn3.learn_move(:FOULPLAY)
	pkmn3.ev[:HP] = 248
	pkmn3.ev[:ATTACK] = 0
	pkmn3.ev[:DEFENSE] = 212
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 52
	pkmn3.tera_type = :WATER
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:REGIELEKI,100)
	pkmn4.item = :HEAVYDUTYBOOTS
	pkmn3.ability_index = 0 # ELECTRICSURGE
	pkmn4.nature = :TIMID
	pkmn4.learn_move(:THUNDER)
	pkmn4.learn_move(:VOLTSWITCH)
	pkmn4.learn_move(:RAPIDSPIN)
	pkmn4.learn_move(:THUNDERWAVE)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :ROCK
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:SANDYSHOCKS,50)
	pkmn5.item = :BOOSTERENERGY
	pkmn5.ability_index = 0 # PROTOSYNTHESIS
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:SPIKES)
	pkmn5.learn_move(:VOLTSWITCH)
	pkmn5.learn_move(:STEALTHROCK)
	pkmn5.learn_move(:EGGBOMB)
	pkmn5.ev[:HP] = 52
	pkmn5.ev[:ATTACK] = 208
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 252
	pkmn5.tera_type = :ICE
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:ZAPDOS,50)
	pkmn6.item = :LEFTOVERS
	pkmn6.ability_index = 4 # DELTASTREAM
	pkmn6.nature = :MODEST
	pkmn6.learn_move(:THUNDER)
	pkmn6.learn_move(:AEROBLAST)
	pkmn6.learn_move(:AGILITY)
	pkmn6.learn_move(:BATONPASS)
	pkmn6.ev[:HP] = 140
	pkmn6.ev[:ATTACK] = 252
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 120
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :FLYING
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoPsychicPartyQuickStart50 # Poke Paste: https://pokepast.es/d71fa8f1e1e7d611
	pkmn1 = Pokemon.new(:SLOWKING,50)
	pkmn1.item = :KASIBBERRY
	pkmn1.ability_index = 0 # REGENERATOR
	pkmn1.nature = :BOLD
	pkmn1.learn_move(:KINESIS)
	pkmn1.learn_move(:SCALD)
	pkmn1.learn_move(:THUNDERWAVE)
	pkmn1.learn_move(:LUNARBLESSING)
	pkmn1.ev[:HP] = 256
	pkmn1.ev[:ATTACK] = 0
	pkmn1.ev[:DEFENSE] = 256
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 0
	pkmn1.tera_type = :FAIRY
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:HATTERENE,50)
	pkmn2.item = :TERRAINEXTENDER
	pkmn2.ability_index = 3 # PSYCHICSURGE
	pkmn2.nature = :BOLD
	pkmn2.learn_move(:CALMMIND)
	pkmn2.learn_move(:PSYSHOCK)
	pkmn2.learn_move(:DRAININGKISS)
	pkmn2.learn_move(:GIGADRAIN)
	pkmn2.ev[:HP] = 256
	pkmn2.ev[:ATTACK] = 0
	pkmn2.ev[:DEFENSE] = 204
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 52
	pkmn2.tera_type = :WATER
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:HOOPA_1,50)
	pkmn3.item = :PSYCHICSEED
	pkmn3.ability_index = 4 # INTIMIDATE
	pkmn3.nature = :MILD
	pkmn3.learn_move(:EXPANDINGFORCE)
	pkmn3.learn_move(:KNOCKOFF)
	pkmn3.learn_move(:FOCUSBLAST)
	pkmn3.learn_move(:THUNDERBOLT)
	pkmn3.ev[:HP] = 240
	pkmn3.ev[:ATTACK] = 16
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 156
	pkmn3.ev[:SPEED] = 100
	pkmn3.tera_type = :POISON
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:IRONBOULDER,50)
	pkmn4.item = :RAZORCLAW
	pkmn3.ability_index = 2 # SHARPNESS
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:SWORDSDANCE)
	pkmn4.learn_move(:TAUNT)
	pkmn4.learn_move(:MIGHTYCLEAVE)
	pkmn4.learn_move(:EARTHQUAKE)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :ROCK
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:LATIOS,50)
	pkmn5.item = :MEGAITE
	pkmn5.ability_index = 0 # SPEEDBOOST
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:EXTRASENSORY)
	pkmn5.learn_move(:DRACOMETEOR)
	pkmn5.learn_move(:THUNDERBOLT)
	pkmn5.learn_move(:ICEBEAM)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :DRAGON
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:JIRACHI,50)
	pkmn6.item = :CHOICESCARF
	pkmn6.ability_index = 6 # MAGICBOUNCE
	pkmn6.nature = :JOLLY
	pkmn6.learn_move(:UTURN)
	pkmn6.learn_move(:BODYSLAM)
	pkmn6.learn_move(:STEALTHROCK)
	pkmn6.learn_move(:HEALINGWISH)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.tera_type = :FLYING
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoIcePartyQuickStart50 # Poke Paste: https://pokepast.es/9373088a9c4e8a75
	pkmn1 = Pokemon.new(:SANDSLASH_1,50)
	pkmn1.item = :HEAVYDUTYBOOTS
	pkmn1.ability_index = 0 # SLUSHRUSH
	pkmn1.nature = :JOLLY
	pkmn1.learn_move(:RAPIDSPIN)
	pkmn1.learn_move(:IRONHEAD)
	pkmn1.learn_move(:EARTHQUAKE)
	pkmn1.learn_move(:KNOCKOFF)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :GHOST
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:WEAVILE,50)
	pkmn2.item = :WIDELENS
	pkmn2.ability_index = 2 # TECHNICIAN
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:SWORDSDANCE)
	pkmn2.learn_move(:DOUBLEHIT)
	pkmn2.learn_move(:TRIPLEAXEL)
	pkmn2.learn_move(:ICESHARD)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :FLYING
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:NINETALES_1,50)
	pkmn3.item = :ICYROCK
	pkmn3.ability_index = 0 # SNOWWARNING
	pkmn3.nature = :TIMID
	pkmn3.learn_move(:AURORAVEIL)
	pkmn3.learn_move(:FREEZEDRY)
	pkmn3.learn_move(:MOONBLAST)
	pkmn3.learn_move(:ENCORE)
	pkmn3.ev[:HP] = 252
	pkmn3.ev[:ATTACK] = 0
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 4
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :PSYCHIC
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:MAMOSWINE,50)
	pkmn4.item = :LIFEORB
	pkmn3.ability_index = 6 # SHEERFORCE
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:HEADLONGRUSH)
	pkmn4.learn_move(:MOUNTAINGALE)
	pkmn4.learn_move(:ROCKCLIMB)
	pkmn4.learn_move(:IRONHEAD)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :FIRE
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:LAPRAS,50)
	pkmn5.item = :LEFTOVERS
	pkmn5.ability_index = 0 # SHELLARMOR
	pkmn5.nature = :ADAMANT
	pkmn5.learn_move(:LIQUIDATION)
	pkmn5.learn_move(:BODYSLAM)
	pkmn5.learn_move(:BULKUP)
	pkmn5.learn_move(:SHEERCOLD)
	pkmn5.ev[:HP] = 32
	pkmn5.ev[:ATTACK] = 252
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 228
	pkmn5.tera_type = :POISON
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:KYUREM,50)
	pkmn6.item = :CHOICESCARF
	pkmn6.ability_index = 2 # BEASTBOOST
	pkmn6.nature = :TIMID
	pkmn6.learn_move(:DRACOMETEOR)
	pkmn6.learn_move(:HYPERBEAM)
	pkmn6.learn_move(:FREEZEDRY)
	pkmn6.learn_move(:EARTHPOWER)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.tera_type = :FAIRY
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoDragonPartyQuickStart50 # Poke Paste: https://pokepast.es/b883849ca83b0402
	pkmn1 = Pokemon.new(:DURALUDON,50)
	pkmn1.item = :EVIOLITE
	pkmn1.ability_index = 4 # STAMINA
	pkmn1.nature = :BOLD
	pkmn1.learn_move(:BODYPRESS)
	pkmn1.learn_move(:FLASHCANNON)
	pkmn1.learn_move(:STEALTHROCK)
	pkmn1.learn_move(:THUNDERWAVE)
	pkmn1.ev[:HP] = 252
	pkmn1.ev[:ATTACK] = 0
	pkmn1.ev[:DEFENSE] = 44
	pkmn1.ev[:SPECIAL_DEFENSE] = 216
	pkmn1.ev[:SPEED] = 0
	pkmn1.tera_type = :GHOST
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:GOODRA_1,50)
	pkmn2.item = :LEFTOVERS
	pkmn2.ability_index = 6 # GOOEY
	pkmn2.nature = :CAREFUL
	pkmn2.learn_move(:HEAVYSLAM)
	pkmn2.learn_move(:KNOCKOFF)
	pkmn2.learn_move(:DRAGONTAIL)
	pkmn2.learn_move(:PROTECT)
	pkmn2.ev[:HP] = 248
	pkmn2.ev[:ATTACK] = 0
	pkmn2.ev[:DEFENSE] = 12
	pkmn2.ev[:SPECIAL_DEFENSE] = 252
	pkmn2.ev[:SPEED] = 0
	pkmn2.tera_type = :FLYING
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:LATIOS,50)
	pkmn3.item = :EXPERTBELT
	pkmn3.ability_index = 4 # NEUROFORCE
	pkmn3.nature = :TIMID
	pkmn3.learn_move(:EXTRASENSORY)
	pkmn3.learn_move(:THUNDERBOLT)
	pkmn3.learn_move(:ICEBEAM)
	pkmn3.learn_move(:ROOST)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :STEEL
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:GARCHOMP,50)
	pkmn4.item = :MEGAITE
	pkmn3.ability_index = 2 # EARTHEATER
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:VICTORYDANCE)
	pkmn4.learn_move(:EXTREMESPEED)
	pkmn4.learn_move(:DRAGONASCENT)
	pkmn4.learn_move(:IRONTAIL)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :ROCK
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:DRAGAPULT,50)
	pkmn5.item = :CHOICESPECS
	pkmn5.ability_index = 2 # MEGALAUNCHER
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:HYPERBEAM)
	pkmn5.learn_move(:SHADOWBALL)
	pkmn5.learn_move(:FLAMETHROWER)
	pkmn5.learn_move(:UTURN)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :DRAGON
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:ROARINGMOON,50)
	pkmn6.item = :CHOICESCARF
	pkmn6.ability_index = 6 # MOXIE
	pkmn6.nature = :JOLLY
	pkmn6.learn_move(:DRAGONASCENT)
	pkmn6.learn_move(:KNOCKOFF)
	pkmn6.learn_move(:EARTHQUAKE)
	pkmn6.learn_move(:UTURN)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.tera_type = :FIRE
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoDarkPartyQuickStart50 # Poke Paste: https://pokepast.es/4088d29463d73e7a
	pkmn1 = Pokemon.new(:TINGLU,50)
	pkmn1.item = :LEFTOVERS
	pkmn1.ability_index = 5 # ROCKYPAYLOAD
	pkmn1.nature = :CAREFUL
	pkmn1.learn_move(:BODYSLAM)
	pkmn1.learn_move(:WHIRLWIND)
	pkmn1.learn_move(:SPIKES)
	pkmn1.learn_move(:RUINATION)
	pkmn1.ev[:HP] = 252
	pkmn1.ev[:ATTACK] = 0
	pkmn1.ev[:DEFENSE] = 8
	pkmn1.ev[:SPECIAL_DEFENSE] = 252
	pkmn1.ev[:SPEED] = 0
	pkmn1.tera_type = :POISON
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:MEOWSCARADA,50)
	pkmn2.item = :CHOICESCARF
	pkmn2.ability_index = 6 # MAGICBOUNCE
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:FLOWERTRICK)
	pkmn2.learn_move(:TRIPLEAXEL)
	pkmn2.learn_move(:PLAYROUGH)
	pkmn2.learn_move(:UTURN)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :GRASS
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:SAMUROTT_1,50)
	pkmn3.item = :RAZORCLAW
	pkmn3.ability_index = 4 # SHARPNESS
	pkmn3.nature = :JOLLY
	pkmn3.learn_move(:VICTORYDANCE)
	pkmn3.learn_move(:SLASH)
	pkmn3.learn_move(:RAZORSHELL)
	pkmn3.learn_move(:SACREDSWORD)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :FIRE
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:MANDIBUZZ,50)
	pkmn4.item = :HEAVYDUTYBOOTS
	pkmn3.ability_index = 0 # LEVITATE
	pkmn4.nature = :IMPISH
	pkmn4.learn_move(:PUNISHMENT)
	pkmn4.learn_move(:ROOST)
	pkmn4.learn_move(:TOXIC)
	pkmn4.learn_move(:VENOMDRENCH)
	pkmn4.ev[:HP] = 252
	pkmn4.ev[:ATTACK] = 0
	pkmn4.ev[:DEFENSE] = 252
	pkmn4.ev[:SPECIAL_DEFENSE] = 8
	pkmn4.ev[:SPEED] = 0
	pkmn4.tera_type = :ELECTRIC
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:HOOPA_1,50)
	pkmn5.item = :ASSAULTVEST
	pkmn5.ability_index = 4 # INTIMIDATE
	pkmn5.nature = :CAREFUL
	pkmn5.learn_move(:PSYCHICNOISE)
	pkmn5.learn_move(:KNOCKOFF)
	pkmn5.learn_move(:GUNKSHOT)
	pkmn5.learn_move(:DRAINPUNCH)
	pkmn5.ev[:HP] = 252
	pkmn5.ev[:ATTACK] = 48
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 196
	pkmn5.ev[:SPEED] = 16
	pkmn5.tera_type = :STEEL
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:DARKRAI,50)
	pkmn6.item = :SALACBERRY
	pkmn6.ability_index = 5 # DARKAURA
	pkmn6.nature = :TIMID
	pkmn6.learn_move(:SUBSTITUTE)
	pkmn6.learn_move(:NASTYPLOT)
	pkmn6.learn_move(:EGGBOMB)
	pkmn6.learn_move(:FOCUSBLAST)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.tera_type = :FAIRY
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoFairyPartyQuickStart50 # Poke Paste: https://pokepast.es/7befb3cd43301b4b
	pkmn1 = Pokemon.new(:FLUTTERMANE,50)
	pkmn1.item = :POWERHERB
	pkmn1.ability_index = 3 # INTIMIDATE
	pkmn1.nature = :TIMID
	pkmn1.learn_move(:GEOMANCY)
	pkmn1.learn_move(:NASTYPLOT)
	pkmn1.learn_move(:SPARKLYSWIRL)
	pkmn1.learn_move(:MYSTICALFIRE)
	pkmn1.ev[:HP] = 244
	pkmn1.ev[:ATTACK] = 4
	pkmn1.ev[:DEFENSE] = 124
	pkmn1.ev[:SPECIAL_DEFENSE] = 4
	pkmn1.ev[:SPEED] = 136
	pkmn1.tera_type = :FIRE
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:KLEFKI,50)
	pkmn2.item = :LIGHTCLAY
	pkmn2.ability_index = 0 # LEVITATE
	pkmn2.nature = :BOLD
	pkmn2.learn_move(:FOULPLAY)
	pkmn2.learn_move(:REFLECT)
	pkmn2.learn_move(:LIGHTSCREEN)
	pkmn2.learn_move(:STEALTHROCK)
	pkmn2.ev[:HP] = 252
	pkmn2.ev[:ATTACK] = 0
	pkmn2.ev[:DEFENSE] = 204
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 56
	pkmn2.tera_type = :ELECTRIC
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:ENAMORUS,50)
	pkmn3.item = :CHOICESCARF
	pkmn3.ability_index = 2 # CONTRARY
	pkmn3.nature = :JOLLY
	pkmn3.learn_move(:PLAYROUGH)
	pkmn3.learn_move(:BODYSLAM)
	pkmn3.learn_move(:SUPERPOWER)
	pkmn3.learn_move(:HEALINGWISH)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :GROUND
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:IRONVALIANT,50)
	pkmn4.item = :BOOSTERENERGY
	pkmn4.ability_index = 0 # QUARKDRIVE
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:SWORDSDANCE)
	pkmn4.learn_move(:CLOSECOMAT)
	pkmn4.learn_move(:KNOCKOFF)
	pkmn4.learn_move(:SPIRITBREAK)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :STEEL
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:CLEFABLE,50)
	pkmn5.item = :LIFEORB
	pkmn5.ability_index = 2 # MAGICGUARD
	pkmn5.nature = :BOLD
	pkmn5.learn_move(:TRIATTACK)
	pkmn5.learn_move(:THUNDERBOLT)
	pkmn5.learn_move(:QUIVERDANCE)
	pkmn5.learn_move(:SOFTBOILED)
	pkmn5.ev[:HP] = 252
	pkmn5.ev[:ATTACK] = 0
	pkmn5.ev[:DEFENSE] = 132
	pkmn5.ev[:SPECIAL_DEFENSE] = 64
	pkmn5.ev[:SPEED] = 64
	pkmn5.tera_type = :POISON
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:AZUMARILL,50)
	pkmn6.item = :HONEY
	pkmn6.ability_index = 0 # HUGEPOWER
	pkmn6.nature = :ADAMANT
	pkmn6.learn_move(:EXTREMESPEED)
	pkmn6.learn_move(:LIQUIDATION)
	pkmn6.learn_move(:KNOCKOFF)
	pkmn6.learn_move(:BELLYDRUM)
	pkmn6.ev[:HP] = 80
	pkmn6.ev[:ATTACK] = 252
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 4
	pkmn6.ev[:SPEED] = 176
	pkmn6.tera_type = :PSYCHIC
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedRainWeatherPartyQuickStart50 # Pending Poke Paste: https://nuzlocke.app/guides/radical-red-hardcore
	pkmn1 = Pokemon.new(:THUNDURUS,50)
	pkmn1.item = :DAMPROCK
	pkmn1.ability_index = 3 # PRANKSTER
	pkmn1.nature = :BOLD
	pkmn1.learn_move(:VOLTSWITCH)
	pkmn1.learn_move(:RAINDANCE)
	pkmn1.learn_move(:THUNDERWAVE)
	pkmn1.learn_move(:TAUNT)
	pkmn1.ev[:HP] = 256
	pkmn1.ev[:ATTACK] = 4
	pkmn1.ev[:DEFENSE] = 156
	pkmn1.ev[:SPECIAL_DEFENSE] = 92
	pkmn1.ev[:SPEED] = 4
	pkmn1.tera_type = :DARK
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:JIRACHI,50)
	pkmn2.item = :TERRAINEXTENDER
	pkmn2.ability_index = 4 # MISTYSURGE
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:STEALTHROCK)
	pkmn2.learn_move(:ENCORE)
	pkmn2.learn_move(:TRICK)
	pkmn2.learn_move(:UTURN)
	pkmn2.ev[:HP] = 252
	pkmn2.ev[:ATTACK] = 0
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 32
	pkmn2.ev[:SPEED] = 228
	pkmn2.tera_type = :WATER
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:SEISMITOAD,50)
	pkmn3.item = :THROATSPRAY
	pkmn3.ability_index = 3 # SWIFTSWIM
	pkmn3.nature = :TIMID
	pkmn3.learn_move(:WATERGUN)
	pkmn3.learn_move(:HYPERVOICE)
	pkmn3.learn_move(:GRASSKNOT)
	pkmn3.learn_move(:FOCUSBLAST)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :POISON
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:MANTINE,50)
	pkmn4.item = :LEFTOVERS
	pkmn4.ability_index = 6 # HYDRATION
	pkmn4.nature = :TIMID
	pkmn4.learn_move(:QUIVERDANCE)
	pkmn4.learn_move(:SCALD)
	pkmn4.learn_move(:TRIATTACK)
	pkmn4.learn_move(:ROOST)
	pkmn4.ev[:HP] = 80
	pkmn4.ev[:ATTACK] = 252
	pkmn4.ev[:DEFENSE] = 4
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 176
	pkmn4.tera_type = :GROUND
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:KINGDRA,50)
	pkmn5.item = :WATERIUMZ
	pkmn5.ability_index = 0 # SWIFTSWIM
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:HYPERBEAM)
	pkmn5.learn_move(:WATERGUN)
	pkmn5.learn_move(:SPLASH)
	pkmn5.learn_move(:ICEBEAM)
	pkmn5.ev[:HP] = 104
	pkmn5.ev[:ATTACK] = 152
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :FLYING
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:GRENINJA,50)
	pkmn6.item = :MEGAITE
	pkmn6.ability_index = 0 # PROTEAN
	pkmn6.nature = :TIMID
	pkmn6.learn_move(:HYDROCANNON)
	pkmn6.learn_move(:EGGBOMB)
	pkmn6.learn_move(:ICEBEAM)
	pkmn6.learn_move(:EXTRASENSORY)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.tera_type = :WATER
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedSunWeatherPartyQuickStart50 # Pending Poke Paste: https://nuzlocke.app/guides/radical-red-hardcore
	pkmn1 = Pokemon.new(:CHARIZARD,50)
	pkmn1.item = :MEGAITEY
	pkmn1.ability_index = 4 # DROUGHT
	pkmn1.nature = :TIMID
	pkmn1.learn_move(:BLASTBURN)
	pkmn1.learn_move(:AEROBLAST)
	pkmn1.learn_move(:SCORCHINGSANDS)
	pkmn1.learn_move(:SOLARBEAM)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :FIRE
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:GROUDON,50)
	pkmn2.item = :REDORB
	pkmn2.ability_index = 4 # INTIMIDATE
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:ROCKPOLISH)
	pkmn2.learn_move(:SWORDSDANCE)
	pkmn2.learn_move(:PRECIPICEBLADES)
	pkmn2.learn_move(:HEATCRASH)
	pkmn2.ev[:HP] = 140
	pkmn2.ev[:ATTACK] = 252
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 120
	pkmn2.tera_type = :GROUND
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:HELIOLISK,50)
	pkmn3.item = :LIFEORB
	pkmn3.ability_index = 1 # SOLARPOWER
	pkmn3.nature = :TIMID
	pkmn3.learn_move(:WEATHERBALL)
	pkmn3.learn_move(:THUNDERCLAP)
	pkmn3.learn_move(:SOLARBEAM)
	pkmn3.learn_move(:QUIVERDANCE)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :FLYING
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:DARMANITAN_2,50)
	pkmn4.item = :SALACBERRY
	pkmn4.ability_index = 2 # ZENMODE
	pkmn4.nature = :ADAMANT
	pkmn4.learn_move(:BODYSLAM)
	pkmn4.learn_move(:FLAREBLITZ)
	pkmn4.learn_move(:ENDURE)
	pkmn4.learn_move(:REVERSAL)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :GRASS
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:HOOH,50)
	pkmn5.item = :HEAVYDUTYBOOTS
	pkmn5.ability_index = 2 # WINDRIDER
	pkmn5.nature = :ADAMANT
	pkmn5.learn_move(:SACREDFIRE)
	pkmn5.learn_move(:DOUBLEEDGE)
	pkmn5.learn_move(:EARTHQUAKE)
	pkmn5.learn_move(:TAILWIND)
	pkmn5.ev[:HP] = 252
	pkmn5.ev[:ATTACK] = 176
	pkmn5.ev[:DEFENSE] = 20
	pkmn5.ev[:SPECIAL_DEFENSE] = 56
	pkmn5.ev[:SPEED] = 8
	pkmn5.tera_type = :ELECTRIC
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:VENUSAUR,50)
	pkmn6.item = :FOCUSSASH
	pkmn6.ability_index = 3 # CHLOROPHYLL
	pkmn6.nature = :TIMID
	pkmn6.learn_move(:GROWTH)
	pkmn6.learn_move(:TRIATTACK)
	pkmn6.learn_move(:POISONPOWDER)
	pkmn6.learn_move(:WEATHERBALL)
	pkmn6.ev[:HP] = 72
	pkmn6.ev[:ATTACK] = 252
	pkmn6.ev[:DEFENSE] = 4
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 184
	pkmn6.tera_type = :ROCK
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedSandstormPartyQuickStart50 # Pending Poke Paste: https://nuzlocke.app/guides/radical-red-hardcore
	pkmn1 = Pokemon.new(:GIGALITH,50)
	pkmn1.item = :CUSTAPBERRY
	pkmn1.ability_index = 4 # SANDSTREAM
	pkmn1.nature = :ADAMANT
	pkmn1.learn_move(:EXPLOSION)
	pkmn1.learn_move(:STEALTHROCK)
	pkmn1.learn_move(:SANDTOMB)
	pkmn1.learn_move(:SANDSTORM)
	pkmn1.ev[:HP] = 256
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 0
	pkmn1.tera_type = :FLYING
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:LANDORUS_1,50)
	pkmn2.item = :SMOOTHROCK
	pkmn2.ability_index = 5 # SANDSTREAM
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:STEALTHROCK)
	pkmn2.learn_move(:TAUNT)
	pkmn2.learn_move(:UTURN)
	pkmn2.learn_move(:FLOATYFALL)
	pkmn2.ev[:HP] = 252
	pkmn2.ev[:ATTACK] = 0
	pkmn2.ev[:DEFENSE] = 4
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :GHOST
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:ZYGARDE,50)
	pkmn3.item = :LEFTOVERS
	pkmn3.ability_index = 0 # POWERCONSTRUCT
	pkmn3.nature = :IMPISH
	pkmn3.learn_move(:COIL)
	pkmn3.learn_move(:THOUSANDARROWS)
	pkmn3.learn_move(:REST)
	pkmn3.learn_move(:DRAGONTAIL)
	pkmn3.ev[:HP] = 256
	pkmn3.ev[:ATTACK] = 0
	pkmn3.ev[:DEFENSE] = 96
	pkmn3.ev[:SPECIAL_DEFENSE] = 108
	pkmn3.ev[:SPEED] = 52
	pkmn3.tera_type = :FAIRY
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:AERODACTYL,50)
	pkmn4.item = :MEGAITE
	pkmn4.ability_index = 3 # ROCKHEAD
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:DRAGONDANCE)
	pkmn4.learn_move(:ROCKCLIMB)
	pkmn4.learn_move(:EARTHQUAKE)
	pkmn4.learn_move(:FLOATYFALL)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :ROCK
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:EMPOLEON,50)
	pkmn5.item = :WEAKNESSPOLICY
	pkmn5.ability_index = 4 # BATTLEARMOR
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:AGILITY)
	pkmn5.learn_move(:ROOST)
	pkmn5.learn_move(:SCALD)
	pkmn5.learn_move(:ICEBEAM)
	pkmn5.ev[:HP] = 96
	pkmn5.ev[:ATTACK] = 252
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 164
	pkmn5.tera_type = :ELECTRIC
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:CRADILY,50)
	pkmn6.item = :BIGROOT
	pkmn6.ability_index = 0 # STORMDRAIN
	pkmn6.nature = :IMPISH
	pkmn6.learn_move(:SAPPYSEED)
	pkmn6.learn_move(:JUNGLEHEALING)
	pkmn6.learn_move(:INGRAIN)
	pkmn6.learn_move(:STOCKPILE)
	pkmn6.ev[:HP] = 256
	pkmn6.ev[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 92
	pkmn6.ev[:SPECIAL_DEFENSE] = 164
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :GROUND
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedHailstormPartyQuickStart50 # Pending Poke Paste: https://nuzlocke.app/guides/radical-red-hardcore
	pkmn1 = Pokemon.new(:SUICUNE,50)
	pkmn1.item = :ICYROCK
	pkmn1.ability_index = 4 # SNOWWARNING
	pkmn1.nature = :CALM
	pkmn1.learn_move(:AURORAVEIL)
	pkmn1.learn_move(:FLIPTURN)
	pkmn1.learn_move(:TAILWIND)
	pkmn1.learn_move(:ROAR)
	pkmn1.ev[:HP] = 256
	pkmn1.ev[:ATTACK] = 4
	pkmn1.ev[:DEFENSE] = 108
	pkmn1.ev[:SPECIAL_DEFENSE] = 60
	pkmn1.ev[:SPEED] = 84
	pkmn1.tera_type = :DARK
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:KYUREM_2,50)
	pkmn2.item = :LOADEDDICE
	pkmn2.ability_index = 3 # INTIMIDATE
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:DRAGONDANCE)
	pkmn2.learn_move(:EGGBOMB)
	pkmn2.learn_move(:SUBSTITUTE)
	pkmn2.learn_move(:DRAGONDANCE)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 252
	pkmn2.ev[:DEFENSE] = 94
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 168
	pkmn2.tera_type = :FAIRY
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:ARCTOZOLT,50)
	pkmn3.item = :HEAVYDUTYBOOTS
	pkmn3.ability_index = 0 # SLUSHRUSH
	pkmn3.nature = :ADAMANT
	pkmn3.learn_move(:SPARK)
	pkmn3.learn_move(:EGGBOMB)
	pkmn3.learn_move(:AURORAVEIL)
	pkmn3.learn_move(:SUBSTITUTE)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :WATER
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:GLALIE,50)
	pkmn4.item = :MEGAITE
	pkmn4.ability_index = 0 # LEVITATE
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:FAKEOUT)
	pkmn4.learn_move(:HEADSMASH)
	pkmn4.learn_move(:EXTREMESPEED)
	pkmn4.learn_move(:VICTORYDANCE)
	pkmn4.ev[:HP] = 80
	pkmn4.ev[:ATTACK] = 0
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 252
	pkmn4.ev[:SPEED] = 180
	pkmn4.tera_type = :PSYCHIC
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:CLEFABLE,50)
	pkmn5.item = :LIFEORB
	pkmn5.ability_index = 2 # MAGICGUARD
	pkmn5.nature = :BOLD
	pkmn5.learn_move(:TRIATTACK)
	pkmn5.learn_move(:FLAMETHROWER)
	pkmn5.learn_move(:QUIVERDANCE)
	pkmn5.learn_move(:SOFTBOILED)
	pkmn5.ev[:HP] = 252
	pkmn5.ev[:ATTACK] = 0
	pkmn5.ev[:DEFENSE] = 132
	pkmn5.ev[:SPECIAL_DEFENSE] = 64
	pkmn5.ev[:SPEED] = 64
	pkmn5.tera_type = :POISON
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:BEARTIC,50)
	pkmn6.item = :LEFTOVERS
	pkmn6.ability_index = 5 # DAMP
	pkmn6.nature = :ADAMANT
	pkmn6.learn_move(:VICTORYDANCE)
	pkmn6.learn_move(:SUBSTITUTE)
	pkmn6.learn_move(:ICICLECRASH)
	pkmn6.learn_move(:BODYSLAM)
	pkmn6.ev[:HP] = 132
	pkmn6.ev[:ATTACK] = 252
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 128
	pkmn6.tera_type = :GROUND
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedUtimatePartyQuickStart50 # Custom Team, mirror match of Dani, the Mono Stellar Type Master
	pkmn1 = Pokemon.new(:MEWTWO,50)
	pkmn1.item = :MEGAITEX
	pkmn1.ability_index = 3 # INTIMIDATE
	pkmn1.nature = :JOLLY
	pkmn1.learn_move(:PSYCHOCUT)
	pkmn1.learn_move(:VICTORYDANCE)
	pkmn1.learn_move(:DRAINPUNCH)
	pkmn1.learn_move(:SHEERCOLD)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 112
	pkmn1.ev[:DEFENSE] = 144
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :FIRE
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:MEW,50)
	pkmn2.item = :MEWNIUMZ
	pkmn2.ability_index = 5 # UNAWARE
	pkmn2.nature = :TIMID
	pkmn2.learn_move(:LUSTERPURGE)
	pkmn2.learn_move(:ECHOEDVOICE)
	pkmn2.learn_move(:WILLOWISP)
	pkmn2.learn_move(:QUIVERDANCE)
	pkmn2.ev[:HP] = 240
	pkmn2.ev[:ATTACK] = 52
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 220
	pkmn2.tera_type = :ICE
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:TERAPAGOS,50)
	pkmn3.item = :WHITEHERB
	pkmn3.nature = :BOLD
	pkmn3.learn_move(:NORETREAT)
	pkmn3.learn_move(:SHELLSMASH)
	pkmn3.learn_move(:TAUNT)
	pkmn3.learn_move(:TERASTARSTORM)
	pkmn3.ev[:HP] = 172
	pkmn3.ev[:ATTACK] = 68
	pkmn3.ev[:DEFENSE] = 204
	pkmn3.ev[:SPECIAL_DEFENSE] = 12
	pkmn3.ev[:SPEED] = 56
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:TYPENULL,50)
	pkmn4.item = :EVIOLITE
	pkmn4.ability_index = 0 # BATTLEARMOR
	pkmn4.nature = :CALM
	pkmn4.learn_move(:SALTCURE)
	pkmn4.learn_move(:REST)
	pkmn4.learn_move(:SAPPYSEED)
	pkmn4.learn_move(:BIND)
	pkmn4.ev[:HP] = 252
	pkmn4.ev[:ATTACK] = 0
	pkmn4.ev[:DEFENSE] = 252
	pkmn4.ev[:SPECIAL_DEFENSE] = 8
	pkmn4.ev[:SPEED] = 0
	#pkmn4.dynamax_able = false # Due to crashing issues from 2.0.0, Type Null cannot Dynamax at all
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:ARCEUS_17,50) # Tweaks to the Legend Plate mean Arceus's forms are obtainable without holding the type plates. Dark Form is chosen for Prankster Immunity, before the Legend Plate kicks in 
	pkmn5.item = :LEGENDPLATE # Changes Arceus to any optimal offense type when it uses Judgement
	pkmn5.ability_index = 0 # MULTITYPE
	pkmn5.nature = :MODEST
	pkmn5.learn_move(:JUDGMENT)
	pkmn5.learn_move(:NORETREAT)
	pkmn5.learn_move(:BATONPASS)
	pkmn5.learn_move(:TAUNT)
	pkmn5.ev[:HP] = 116
	pkmn5.ev[:ATTACK] = 116
	pkmn5.ev[:DEFENSE] = 76
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 204
	pkmn5.tera_type = :POISON
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:UNOWN,50)
	pkmn6.item = :TERRAINEXTENDER
	pkmn6.ability_index = 1 # PUREPOWER
	pkmn6.nature = :TIMID
	pkmn6.learn_move(:EXPANDINGFORCE)
	pkmn6.learn_move(:EARTHPOWER)
	pkmn6.learn_move(:ROAROFTIME)
	pkmn6.learn_move(:AEROBLAST)
	pkmn6.ev[:HP] = 12
	pkmn6.ev[:ATTACK] = 68
	pkmn6.ev[:DEFENSE] = 204
	pkmn6.ev[:SPECIAL_DEFENSE] = 56
	pkmn6.ev[:SPEED] = 172
	pkmn6.tera_type = :PSYCHIC
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

#===============================================================================
# Lvl.100 (Gen 1 to Gen 9 Pokemon Teams, this exists to allow playtesters to have Optimised teams,
# without wasting time setting up a fully trained competitive teams. It also serves to truly poke 
# and prod the 435 trainers of battle mode, in order to identify tedious filler text, and potential 
# bugs and crashes, rather than just sticking to the stock Metagame teams)
#===============================================================================
def pbOptimisedGen1GrassPartyQuickStart100 # Poke Paste: https://pokepast.es/796bf2bd36e89d42
	pkmn1 = Pokemon.new(:NINETALES,100)
	pkmn1.item = :HEATROCK
	pkmn1.ability_index = 0 # DROUGHT
	pkmn1.nature = :TIMID
	pkmn1.learn_move(:FLAMETHROWER)
	pkmn1.learn_move(:ENCORE)
	pkmn1.learn_move(:HEALINGWISH)
	pkmn1.learn_move(:WILLOWISP)
	pkmn1.ev[:HP] = 248
	pkmn1.ev[:ATTACK] = 0 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn1.ev[:DEFENSE] = 20
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 244
	pkmn1.tera_type = :GHOST
	pkmn1.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:CERULEDGE,100)
	pkmn2.item = :FOCUSSASH
	pkmn2.ability_index = 2 # WEAKARMOR
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:SWORDSDANCE)
	pkmn2.learn_move(:BITTERBLADE)
	pkmn2.learn_move(:SOLARBLADE)
	pkmn2.learn_move(:TERABLAST)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :FAIRY
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:VENUSAUR,100)
	pkmn3.item = :LIFEORB
	pkmn3.ability_index = 3 # CHLOROPHYLL
	pkmn3.nature = :MODEST
	pkmn3.learn_move(:GROWTH)
	pkmn3.learn_move(:GIGADRAIN)
	pkmn3.learn_move(:SLUDGEBOMB)
	pkmn3.learn_move(:WEATHERBALL)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 252
	pkmn3.ev[:DEFENSE] = 4
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :FIRE
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:HATTERENE,100)
	pkmn4.item = :EJECTBUTTON
	pkmn4.ability_index = 0 # MAGICBOUNCE
	pkmn4.nature = :BOLD
	pkmn4.learn_move(:HEALINGWISH)
	pkmn4.learn_move(:PSYCHICNOISE)
	pkmn4.learn_move(:DAZZLINGGLEAM)
	pkmn4.learn_move(:NUZZLE)
	pkmn4.ev[:HP] = 256
	pkmn4.ev[:ATTACK] = 0
	pkmn4.ev[:DEFENSE] = 176
	pkmn4.ev[:SPECIAL_DEFENSE] = 72
	pkmn4.ev[:SPEED] = 8
	pkmn4.tera_type = :STEEL
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:GREATTUSK,100)
	pkmn5.item = :ROCKYHELMET
	pkmn5.ability_index = 0 # PROTOSYNTHESIS
	pkmn5.nature = :JOLLY
	pkmn5.learn_move(:HEADLONGRUSH)
	pkmn5.learn_move(:ICESPINNER)
	pkmn5.learn_move(:RAPIDSPIN)
	pkmn5.learn_move(:STEALTHROCK)
	pkmn5.ev[:HP] = 252
	pkmn5.ev[:ATTACK] = 4
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :FIRE
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:WALKINGWAKE,100)
	pkmn6.item = :CHOICESPECS
	pkmn6.ability_index = 0 # PROTOSYNTHESIS
	pkmn6.nature = :MODEST
	pkmn6.learn_move(:HYDROSTEAM)
	pkmn6.learn_move(:DRACOMETEOR)
	pkmn6.learn_move(:FLAMETHROWER)
	pkmn6.learn_move(:DRAGONPULSE)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.tera_type = :WATER
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen1FirePartyQuickStart100 # Poke Paste: https://pokepast.es/e4bf2a1d848e8146
	pkmn1 = Pokemon.new(:CHARIZARD,100)
	pkmn1.item = :CHOICESPECS
	pkmn1.ability_index = 3 # SOLARPOWER
	pkmn1.nature = :TIMID
	pkmn1.learn_move(:HEATWAVE)
	pkmn1.learn_move(:OVERHEAT)
	pkmn1.learn_move(:WEATHERBALL)
	pkmn1.learn_move(:AEROBLAST)
	pkmn1.ev[:HP] = 0 # For IV's they can be set to 31 or 0 on the Info Summary Option Screen.
	pkmn1.ev[:ATTACK] = 256 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :GHOST
	pkmn1.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:TORKOAL,100)
	pkmn2.item = :EJECTPACK
	pkmn2.ability_index = 2 # DROUGHT
	pkmn2.nature = :QUIET
	pkmn2.learn_move(:ERUPTION)
	pkmn2.learn_move(:OVERHEAT)
	pkmn2.learn_move(:HELPINGHAND)
	pkmn2.learn_move(:PROTECT)
	pkmn2.ev[:HP] = 176
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 72
	pkmn2.ev[:SPEED] = 0
	pkmn2.tera_type = :FIRE
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:PORYGON2,100)
	pkmn3.item = :EVIOLITE
	pkmn3.ability_index = 0 # ANALYTIC
	pkmn3.nature = :BOLD
	pkmn3.learn_move(:ICEBEAM)
	pkmn3.learn_move(:EGGBOMB)
	pkmn3.learn_move(:TRICKROOM)
	pkmn3.learn_move(:RECOVER)
	pkmn3.ev[:HP] = 256
	pkmn3.ev[:ATTACK] = 8
	pkmn3.ev[:DEFENSE] = 176
	pkmn3.ev[:SPECIAL_DEFENSE] = 72
	pkmn3.ev[:SPEED] = 0
	pkmn3.tera_type = :FIGHTING
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:INCINEROAR,100)
	pkmn4.item = :HONEY
	pkmn4.ability_index = 0 # INTIMIDATE
	pkmn4.nature = :CAREFUL
	pkmn4.learn_move(:FLAREBLITZ)
	pkmn4.learn_move(:KNOCKOFF)
	pkmn4.learn_move(:FAKEOUT)
	pkmn4.learn_move(:PARTINGSHOT)
	pkmn4.ev[:HP] = 248
	pkmn4.ev[:ATTACK] = 0
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 212
	pkmn4.ev[:SPEED] = 52
	pkmn4.tera_type = :DRAGON
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:JUMPLUFF,100)
	pkmn5.item = :COVERTCLOAK
	pkmn5.ability_index = 2 # CHLOROPHYLL
	pkmn5.nature = :JOLLY
	pkmn5.learn_move(:EGGBOMB)
	pkmn5.learn_move(:SUNNYDAY)
	pkmn5.learn_move(:RAGEPOWDER)
	pkmn5.learn_move(:TAILWIND)
	pkmn5.ev[:HP] = 256
	pkmn5.ev[:ATTACK] = 0
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :WATER
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:URSALUNA,100)
	pkmn6.item = :FLAMEORB
	pkmn6.ability_index = 0 # GUTS
	pkmn6.nature = :BRAVE
	pkmn6.learn_move(:FACADE)
	pkmn6.learn_move(:HEADLONGRUSH)
	pkmn6.learn_move(:FIREPUNCH)
	pkmn6.learn_move(:PROTECT)
	pkmn6.ev[:HP] = 140
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 44
	pkmn6.ev[:SPECIAL_DEFENSE] = 68
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :FAIRY
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen1WaterPartyQuickStart100 # Poke Paste: https://pokepast.es/18734f48aa3bb354
	pkmn1 = Pokemon.new(:BASCULEGION,100)
	pkmn1.item = :LIFEORB
	pkmn1.ability_index = 5 # SWIFTSWIM
	pkmn1.nature = :ADAMANT
	pkmn1.learn_move(:LASTRESPECTS)
	pkmn1.learn_move(:WAVECRASH)
	pkmn1.learn_move(:AQUAJET)
	pkmn1.learn_move(:PROTECT)
	pkmn1.ev[:HP] = 28 # For IV's they can be set to 31 or 0 on the Info Summary Option Screen.
	pkmn1.ev[:ATTACK] = 220 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn1.ev[:DEFENSE] = 124
	pkmn1.ev[:SPECIAL_DEFENSE] = 4
	pkmn1.ev[:SPEED] = 136
	pkmn1.tera_type = :WATER
	pkmn1.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:BLASTOISE,100)
	pkmn2.item = :WHITEHERB
	pkmn2.ability_index = 2 # STORMDRAIN
	pkmn2.nature = :CALM
	pkmn2.learn_move(:FAKEOUT)
	pkmn2.learn_move(:BUBBLEBEAM)
	pkmn2.learn_move(:EGGBOMB)
	pkmn2.learn_move(:SHELLSMASH)
	pkmn2.ev[:HP] = 228
	pkmn2.ev[:ATTACK] = 192
	pkmn2.ev[:DEFENSE] = 12
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 80
	pkmn2.tera_type = :DRAGON
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:INCINEROAR,100)
	pkmn3.item = :HONEY
	pkmn3.ability_index = 0 # INTIMIDATE
	pkmn3.nature = :IMPISH
	pkmn3.learn_move(:FAKEOUT)
	pkmn3.learn_move(:DARKESTLARIAT)
	pkmn3.learn_move(:UTURN)
	pkmn3.learn_move(:FLAREBLITZ)
	pkmn3.ev[:HP] = 248
	pkmn3.ev[:ATTACK] = 4
	pkmn3.ev[:DEFENSE] = 188
	pkmn3.ev[:SPECIAL_DEFENSE] = 68
	pkmn3.ev[:SPEED] = 4
	pkmn3.tera_type = :BUG
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:PELIPPER,100)
	pkmn4.item = :FOCUSSASH
	pkmn4.ability_index = 0 # DRIZZLE
	pkmn4.nature = :MODEST
	pkmn4.learn_move(:HURRICANE)
	pkmn4.learn_move(:ICYWIND)
	pkmn4.learn_move(:TAILWIND)
	pkmn4.learn_move(:RAINDANCE)
	pkmn4.ev[:HP] = 4
	pkmn4.ev[:ATTACK] = 252
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :GROUND
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:URSALUNA_1,100)
	pkmn5.item = :CHOICESPECS
	pkmn5.ability_index = 0 # MINDSEYE
	pkmn5.nature = :MODEST
	pkmn5.learn_move(:HYPERVOICE)
	pkmn5.learn_move(:EARTHPOWER)
	pkmn5.learn_move(:SNARL)
	pkmn5.learn_move(:MOONBLAST)
	pkmn5.ev[:HP] = 256
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 0
	pkmn5.tera_type = :GHOST
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:OVERQWIL,100)
	pkmn6.item = :SAFETYGOGGLES
	pkmn6.ability_index = 3 # WATERBUBBLE
	pkmn6.nature = :JOLLY
	pkmn6.learn_move(:GUNKSHOT)
	pkmn6.learn_move(:EGGBOMB)
	pkmn6.learn_move(:ACIDSPRAY)
	pkmn6.learn_move(:LIQUIDATION)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.tera_type = :FLYING
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen1ElectricPartyQuickStart100 # Poke Paste: https://pokepast.es/1cd570d0b5e4d125
	pkmn1 = Pokemon.new(:CHARIZARD,100)
	pkmn1.item = :LIFEORB
	pkmn1.ability_index = 3 # SOLARPOWER
	pkmn1.nature = :TIMID
	pkmn1.learn_move(:FLAMETHROWER)
	pkmn1.learn_move(:AEROBLAST)
	pkmn1.learn_move(:SCORCHINGSANDS)
	pkmn1.learn_move(:PROTECT)
	pkmn1.ev[:HP] = 0 # For IV's they can be set to 31 or 0 on the Info Summary Option Screen.
	pkmn1.ev[:ATTACK] = 256 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :FIRE
	pkmn1.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:RAICHU,100)
	pkmn2.item = :FOCUSSASH
	pkmn2.ability_index = 0 # LIGHTNINGROD
	pkmn2.nature = :TIMID
	pkmn2.learn_move(:FAKEOUT)
	pkmn2.learn_move(:ENCORE)
	pkmn2.learn_move(:VOLTSWITCH)
	pkmn2.learn_move(:ENDEAVOR)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :FLYING
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:TORKOAL,100)
	pkmn3.item = :ASSAULTVEST
	pkmn3.ability_index = 2 # DROUGHT
	pkmn3.nature = :MODEST
	pkmn3.learn_move(:HEATWAVE)
	pkmn3.learn_move(:FLAMETHROWER)
	pkmn3.learn_move(:SOLARBEAM)
	pkmn3.learn_move(:CLEARSMOG)
	pkmn3.ev[:HP] = 208
	pkmn3.ev[:ATTACK] = 140
	pkmn3.ev[:DEFENSE] = 164
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 0
	pkmn3.tera_type = :GRASS
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:GASTRODON,100)
	pkmn4.item = :HONEY
	pkmn4.ability_index = 4 # STORMDRAIN
	pkmn4.nature = :BOLD
	pkmn4.learn_move(:EARTHPOWER)
	pkmn4.learn_move(:WEATHERBALL)
	pkmn4.learn_move(:YAWN)
	pkmn4.learn_move(:PROTECT)
	pkmn4.ev[:HP] = 256
	pkmn4.ev[:ATTACK] = 92
	pkmn4.ev[:DEFENSE] = 88
	pkmn4.ev[:SPECIAL_DEFENSE] = 76
	pkmn4.ev[:SPEED] = 0
	pkmn4.tera_type = :FIRE
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:TALONFLAME,100)
	pkmn5.item = :SAFETYGOGGLES
	pkmn5.ability_index = 0 # GALEWINGS
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:WILLOWISP)
	pkmn5.learn_move(:AIRSLASH)
	pkmn5.learn_move(:TAILWIND)
	pkmn5.learn_move(:TAUNT)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 252
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 64
	pkmn5.tera_type = :GHOST
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:TSAREENA,100)
	pkmn6.item = :ZOOMLENS
	pkmn6.ability_index = 0 # QUEENLYMAJESTY
	pkmn6.nature = :JOLLY
	pkmn6.learn_move(:POWERWHIP)
	pkmn6.learn_move(:MEGAKICK)
	pkmn6.learn_move(:TRIPLEAXEL)
	pkmn6.learn_move(:PROTECT)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.tera_type = :WATER
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen1FairyPartyQuickStart100 # Poke Paste: https://pokepast.es/5f79ccf1b3607ea3
	pkmn1 = Pokemon.new(:BLISSEY,100)
	pkmn1.item = :HEAVYDUTYBOOTS 
	pkmn1.ability_index = 4 # NATURALCURE 
	pkmn1.nature = :CALM
	pkmn1.learn_move(:CALMMIND)
	pkmn1.learn_move(:FLAMETHROWER)
	pkmn1.learn_move(:SEISMICTOSS)
	pkmn1.learn_move(:SOFTBOILED)
	pkmn1.ev[:HP] = 0 # For IV's they can be set to 31 or 0 on the Info Summary Option Screen.
	pkmn1.ev[:ATTACK] = 0 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn1.ev[:DEFENSE] = 256
	pkmn1.ev[:SPECIAL_DEFENSE] = 256
	pkmn1.ev[:SPEED] = 0
	pkmn1.tera_type = :DARK
	pkmn1.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:CLEFABLE,100)
	pkmn2.item = :STICKYBARB
	pkmn2.ability_index = 2 # MAGICGUARD
	pkmn2.nature = :BOLD
	pkmn2.learn_move(:KNOCKOFF)
	pkmn2.learn_move(:MOONBLAST)
	pkmn2.learn_move(:MOONLIGHT)
	pkmn2.learn_move(:WISH)
	pkmn2.ev[:HP] = 252
	pkmn2.ev[:ATTACK] = 0
	pkmn2.ev[:DEFENSE] = 252
	pkmn2.ev[:SPECIAL_DEFENSE] = 8
	pkmn2.ev[:SPEED] = 0
	pkmn2.tera_type = :STEEL
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:GLISCOR,100)
	pkmn3.item = :MENTALHERB
	pkmn3.ability_index = 3 # LEVITATE
	pkmn3.nature = :IMPISH
	pkmn3.learn_move(:RUINATION)
	pkmn3.learn_move(:TOXIC)
	pkmn3.learn_move(:SPIKES)
	pkmn3.learn_move(:PROTECT)
	pkmn3.ev[:HP] = 252
	pkmn3.ev[:ATTACK] = 0
	pkmn3.ev[:DEFENSE] = 252
	pkmn3.ev[:SPECIAL_DEFENSE] = 8
	pkmn3.ev[:SPEED] = 0
	pkmn3.tera_type = :ELECTRIC
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:TINGLU,100)
	pkmn4.item = :REDCARD
	pkmn4.ability_index = 0 # VESSELOFRUIN
	pkmn4.nature = :CAREFUL
	pkmn4.learn_move(:STEALTHROCK)
	pkmn4.learn_move(:EARTHQUAKE)
	pkmn4.learn_move(:REST)
	pkmn4.learn_move(:PROTECT)
	pkmn4.ev[:HP] = 252
	pkmn4.ev[:ATTACK] = 0
	pkmn4.ev[:DEFENSE] = 8
	pkmn4.ev[:SPECIAL_DEFENSE] = 252
	pkmn4.ev[:SPEED] = 0
	pkmn4.tera_type = :GHOST
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:DONDOZO,100)
	pkmn5.item = :CHESTOBERRY
	pkmn5.ability_index = 0 # UNAWARE
	pkmn5.nature = :IMPISH
	pkmn5.learn_move(:EGGBOMB)
	pkmn5.learn_move(:CURSE)
	pkmn5.learn_move(:BODYPRESS)
	pkmn5.learn_move(:REST)
	pkmn5.ev[:HP] = 256
	pkmn5.ev[:ATTACK] = 0
	pkmn5.ev[:DEFENSE] = 256
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 0
	pkmn5.tera_type = :FIGHTING
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:AMOONGUSS,100)
	pkmn6.item = :HONEY
	pkmn6.ability_index = 3 # REGENERATOR
	pkmn6.nature = :RELAXED
	pkmn6.learn_move(:TOXIC)
	pkmn6.learn_move(:FOULPLAY)
	pkmn6.learn_move(:STRENGTHSAP) # This is one of the universal Move Type Moves for Grass types. I do not care what specfic Pokemon get the universal type moves. I refuse to manually edit the Level Up/Tutor/Egg Moves of all 1025+ Pokemon. It's a waste of time, and not once in any Pokemon game have I liked any Pokemon's natural Level Up Movepool 
	pkmn6.learn_move(:CUT) # This is one of the universal Move Type Moves for Grass types. 
	pkmn6.ev[:HP] = 252
	pkmn6.ev[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 252
	pkmn6.ev[:SPECIAL_DEFENSE] = 8
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :STEEL
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen1NormalPartyQuickStart100 # Team Craft Info: https://www.smogon.com/forums/threads/the-infamous-evopass-a-sm-ubers-rmt.3591806/
	pkmn1 = Pokemon.new(:MEW,100)
	pkmn1.item = :FOCUSSASH
	pkmn1.ability_index = 3 # PRANKSTER 
	pkmn1.nature = :JOLLY
	pkmn1.learn_move(:TAUNT)
	pkmn1.learn_move(:TAILWIND)
	pkmn1.learn_move(:GRAVITY)
	pkmn1.learn_move(:EXPLOSION)
	pkmn1.ev[:HP] = 8 # For IV's they can be set to 31 or 0 on the Info Summary Option Screen.
	pkmn1.ev[:ATTACK] = 84 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn1.ev[:DEFENSE] = 164
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :STEEL
	pkmn1.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:EEVEE,100)
	pkmn2.item = :EEVIUMZ
	pkmn2.ability_index = 6 # SIMPLE 
	pkmn2.nature = :HARDY # A netural nature is used, because Eevee's job in this team is to send it's Evo boosts to it's teammates
	pkmn2.learn_move(:LASTRESORT)
	pkmn2.learn_move(:BATONPASS)
	pkmn2.learn_move(:TAUNT) # All 1025+ Pokemon Evolution lines have had their movepools fused together, via Egg Move links and Ultimate Move Tutor. Eevee and it's evolutions as a result, learn all each other's moves, such as Sappy Seed. This is the case for all Pokemon Evolution lines, and stacks on top of the universal type moves and VGC Starter moves. If using the Sleep Status, replace Taunt with Sing. SY uses the Drowzy status, due to Sleep's nature being highly abusable at the highest level
	pkmn2.learn_move(:SUBSTITUTE)
	pkmn2.ev[:HP] = 240 # For IV's they can be set to 31 or 0 on the Info Summary Option Screen.
	pkmn2.ev[:ATTACK] = 0 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn2.ev[:DEFENSE] = 36
	pkmn2.ev[:SPECIAL_DEFENSE] = 16
	pkmn2.ev[:SPEED] = 220
	pkmn2.tera_type = :GHOST
	pkmn2.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:ESPEON,100)
	pkmn3.item = :LEFTOVERS
	pkmn3.ability_index = 0 # MAGICBOUNCE
	pkmn3.nature = :BOLD
	pkmn3.learn_move(:DAZZLINGGLEAM)
	pkmn3.learn_move(:STOREDPOWER)
	pkmn3.learn_move(:CALMMIND)
	pkmn3.learn_move(:BATONPASS)
	pkmn3.ev[:HP] = 248
	pkmn3.ev[:ATTACK] = 12
	pkmn3.ev[:DEFENSE] = 252
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 0
	pkmn3.tera_type = :ELECTRIC
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:KROOKODILE,100)
	pkmn4.item = :CHOICEBAND
	pkmn4.ability_index = 0 # MOXIE
	pkmn4.nature = :ADAMANT
	pkmn4.learn_move(:POWERTRIP)
	pkmn4.learn_move(:BEATUP)
	pkmn4.learn_move(:PURSUIT)
	pkmn4.learn_move(:BODYSLAM)
	pkmn4.ev[:HP] = 112
	pkmn4.ev[:ATTACK] = 252
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 148
	pkmn4.tera_type = :POISON
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:ARCEUS_17,100) # Tweaks to the Legend Plate mean Arceus's forms are obtainable without holding the type plates. Dark Form is chosen for Prankster Immunity, before the Legend Plate kicks in 
	pkmn5.item = :LEGENDPLATE # Changes Arceus to any optimal offense type when it uses Judgement
	pkmn5.ability_index = 0 # MULTITYPE
	pkmn5.nature = :MODEST
	pkmn5.learn_move(:JUDGMENT)
	pkmn5.learn_move(:NORETREAT)
	pkmn5.learn_move(:BATONPASS)
	pkmn5.learn_move(:TAUNT)
	pkmn5.ev[:HP] = 116
	pkmn5.ev[:ATTACK] = 116
	pkmn5.ev[:DEFENSE] = 76
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 204
	pkmn5.tera_type = :STELLAR
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:DITTO,100)
	pkmn6.item = :CHOICESCARF
	pkmn6.ability_index = 4 # IMPOSTER
	pkmn6.nature = :RELAXED # This nature + the below EV Spread ensures 4 Struggle uses and minimum Struggle damage from opponent Ditto. Slowest speed stops user's Ditto from kicking in first, allowing transformed Ditto to have more PP.
	pkmn6.learn_move(:TRANSFORM)
	pkmn6.ev[:HP] = 256 # For IV's, they can be set to 31 or 0 on the Info Summary Option Screen.
	pkmn6.ev[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 256
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :FAIRY
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen2GrassPartyQuickStart100 # Poke Paste: https://pokepast.es/bf868cdeb163a7c9
	pkmn1 = Pokemon.new(:MEGANIUM,100)
	pkmn1.item = :POWERHERB
	pkmn1.ability_index = 2 # THICKFAT
	pkmn1.nature = :BOLD
	pkmn1.learn_move(:GEOMANCY)
	pkmn1.learn_move(:LEECHSEED)
	pkmn1.learn_move(:DRAGONTAIL)
	pkmn1.learn_move(:LUNARBLESSING)
	pkmn1.ev[:HP] = 252
	pkmn1.ev[:ATTACK] = 0 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn1.ev[:DEFENSE] = 8
	pkmn1.ev[:SPECIAL_DEFENSE] = 252
	pkmn1.ev[:SPEED] = 0
	pkmn1.tera_type = :POISON
	pkmn1.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:LILLIGANT_1,100)
	pkmn2.item = :FOCUSSASH
	pkmn2.ability_index = 1 # CHLOROPHYLL
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:AFTERYOU)
	pkmn2.learn_move(:LEAFBLADE)
	pkmn2.learn_move(:EGGBOMB)
	pkmn2.learn_move(:STUNSPORE)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :FIRE
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:DRAGAPULT,100)
	pkmn3.item = :LIFEORB
	pkmn3.ability_index = 5 # CLEARBODY
	pkmn3.nature = :JOLLY
	pkmn3.learn_move(:DRAGONDARTS)
	pkmn3.learn_move(:SHADOWFORCE)
	pkmn3.learn_move(:TERABLAST)
	pkmn3.learn_move(:PROTECT)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :FIGHTING
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:TORKOAL,100)
	pkmn4.item = :CHOICESPECS
	pkmn4.ability_index = 2 # DROUGHT
	pkmn4.nature = :MODEST
	pkmn4.learn_move(:ERUPTION)
	pkmn4.learn_move(:HEATWAVE)
	pkmn4.learn_move(:SOLARBEAM)
	pkmn4.learn_move(:EARTHPOWER)
	pkmn4.ev[:HP] = 256
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 0
	pkmn4.tera_type = :FLYING
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:TYPHLOSION_1,100)
	pkmn5.item = :CHOICESCARF
	pkmn5.ability_index = 0 # SOULHEART
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:ERUPTION)
	pkmn5.learn_move(:HEATWAVE)
	pkmn5.learn_move(:FLAMETHROWER)
	pkmn5.learn_move(:EGGBOMB)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :GRASS
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:WEEZING_1,100)
	pkmn6.item = :HONEY
	pkmn6.ability_index = 2 # NEUTRALIZINGGAS
	pkmn6.nature = :CALM
	pkmn6.learn_move(:TAUNT)
	pkmn6.learn_move(:WILLOWISP)
	pkmn6.learn_move(:STRANGESTEAM)
	pkmn6.learn_move(:PROTECT)
	pkmn6.ev[:HP] = 256
	pkmn6.ev[:ATTACK] = 4
	pkmn6.ev[:DEFENSE] = 52
	pkmn6.ev[:SPECIAL_DEFENSE] = 156
	pkmn6.ev[:SPEED] = 44
	pkmn6.tera_type = :DARK
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen2FirePartyQuickStart100 # Poke Paste: https://pokepast.es/0048bf1a01a173c2
	pkmn1 = Pokemon.new(:TYPHLOSION,100)
	pkmn1.item = :CHOICESPECS
	pkmn1.ability_index = 0 # SOULHEART
	pkmn1.nature = :TIMID
	pkmn1.learn_move(:ERUPTION)
	pkmn1.learn_move(:HEATWAVE)
	pkmn1.learn_move(:FOCUSBLAST)
	pkmn1.learn_move(:EGGBOMB)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :GRASS
	pkmn1.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:HITMONTOP,100)
	pkmn2.item = :ROCKYHELMET
	pkmn2.ability_index = 4 # INTIMIDATE
	pkmn2.nature = :ADAMANT
	pkmn2.learn_move(:FAKEOUT)
	pkmn2.learn_move(:REVENGE)
	pkmn2.learn_move(:WIDEGUARD)
	pkmn2.learn_move(:COACHING)
	pkmn2.ev[:HP] = 252
	pkmn2.ev[:ATTACK] = 56
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 204
	pkmn2.tera_type = :GROUND
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:DRAGONITE,100)
	pkmn3.item = :LOADEDDICE
	pkmn3.ability_index = 2 # INNERFOCUS
	pkmn3.nature = :ADAMANT
	pkmn3.learn_move(:SCALESHOT)
	pkmn3.learn_move(:DRAGONCHEER)
	pkmn3.learn_move(:TAILWIND)
	pkmn3.learn_move(:PROTECT)
	pkmn3.ev[:HP] = 196
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 4
	pkmn3.ev[:SPECIAL_DEFENSE] = 4
	pkmn3.ev[:SPEED] = 52
	pkmn3.tera_type = :FAIRY
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:DRAGAPULT,100)
	pkmn4.item = :CHOICEBAND
	pkmn4.ability_index = 5 # CLEARBODY
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:DRAGONDARTS)
	pkmn4.learn_move(:SHADOWFORCE)
	pkmn4.learn_move(:SUCKERPUNCH)
	pkmn4.learn_move(:UTURN)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :DRAGON
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:TORKOAL,100)
	pkmn5.item = :LIFEORB
	pkmn5.ability_index = 2 # DROUGHT
	pkmn5.nature = :MODEST
	pkmn5.learn_move(:HEATWAVE)
	pkmn5.learn_move(:CLEARSMOG)
	pkmn5.learn_move(:HELPINGHAND)
	pkmn5.learn_move(:PROTECT)
	pkmn5.ev[:HP] = 176
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 72
	pkmn5.ev[:SPEED] = 0
	pkmn5.tera_type = :FIRE
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:WHIMSICOTT,100)
	pkmn6.item = :COVERTCLOAK
	pkmn6.ability_index = 0 # Prankster
	pkmn6.nature = :TIMID
	pkmn6.learn_move(:MOONBLAST)
	pkmn6.learn_move(:TAILWIND)
	pkmn6.learn_move(:TRICKROOM)
	pkmn6.learn_move(:SUNNYDAY)
	pkmn6.ev[:HP] = 180
	pkmn6.iv[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 4
	pkmn6.ev[:SPECIAL_DEFENSE] = 108
	pkmn6.ev[:SPEED] = 220
	pkmn6.tera_type = :WATER
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen2WaterPartyQuickStart100 # Poke Paste: https://pokepast.es/7bd4be45d6b25451
	pkmn1 = Pokemon.new(:FERALIGATR,100)
	pkmn1.item = :LIFEORB
	pkmn1.ability_index = 0 # SHEERFORCE
	pkmn1.nature = :JOLLY
	pkmn1.learn_move(:LIQUIDATION)
	pkmn1.learn_move(:CRUNCH)
	pkmn1.learn_move(:DRAGONDANCE)
	pkmn1.learn_move(:PROTECT)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :DARK
	pkmn1.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:KOMMOO,100)
	pkmn2.item = :THROATSPRAY
	pkmn2.ability_index = 0 # MULTISCALE
	pkmn2.nature = :TIMID
	pkmn2.learn_move(:EGGBOMB)
	pkmn2.learn_move(:AURASPHERE)
	pkmn2.learn_move(:CLANGOROUSSOUL)
	pkmn2.learn_move(:PROTECT)
	pkmn2.ev[:HP] = 136
	pkmn2.ev[:ATTACK] = 204
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 172
	pkmn2.tera_type = :POISON
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:POLITOED,100)
	pkmn3.item = :HONEY
	pkmn3.ability_index = 4 # DRIZZLE
	pkmn3.nature = :BOLD
	pkmn3.learn_move(:WEATHERBALL)
	pkmn3.learn_move(:ICYWIND)
	pkmn3.learn_move(:HAZE)
	pkmn3.learn_move(:PROTECT)
	pkmn3.ev[:HP] = 256
	pkmn3.ev[:ATTACK] = 0
	pkmn3.ev[:DEFENSE] = 184
	pkmn3.ev[:SPECIAL_DEFENSE] = 72
	pkmn3.ev[:SPEED] = 0
	pkmn3.tera_type = :GRASS
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:RILLABOOM,100)
	pkmn4.item = :ASSAULTVEST
	pkmn4.ability_index = 0 # GRASSYSURGE
	pkmn4.nature = :ADAMANT
	pkmn4.learn_move(:WOODHAMMER)
	pkmn4.learn_move(:GRASSYGLIDE)
	pkmn4.learn_move(:FAKEOUT)
	pkmn4.learn_move(:UTURN)
	pkmn4.ev[:HP] = 204
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 52
	pkmn4.tera_type = :FIRE
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:INCINEROAR,100)
	pkmn5.item = :SAFETYGOGGLES
	pkmn5.ability_index = 0 # Intimidate
	pkmn5.nature = :CAREFUL
	pkmn5.learn_move(:FAKEOUT)
	pkmn5.learn_move(:PARTINGSHOT)
	pkmn5.learn_move(:TAUNT)
	pkmn5.learn_move(:KNOCKOFF)
	pkmn5.ev[:HP] = 256
	pkmn5.ev[:ATTACK] = 0
	pkmn5.ev[:DEFENSE] = 96
	pkmn5.ev[:SPECIAL_DEFENSE] = 160
	pkmn5.ev[:SPEED] = 0
	pkmn5.tera_type = :GHOST
	pkmn5.dynamax_able = false
	pkmn5.calc_stats
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:AMOONGUSS,100)
	pkmn6.item = :COVERTCLOAK
	pkmn6.ability_index = 3 # Regenerator
	pkmn6.nature = :BOLD
	pkmn6.learn_move(:PROTECT)
	pkmn6.learn_move(:RAGEPOWDER)
	pkmn6.learn_move(:SPORE)
	pkmn6.learn_move(:POLLENPUFF)
	pkmn6.ev[:HP] = 240
	pkmn6.ev[:DEFENSE] = 236
	pkmn6.ev[:SPECIAL_DEFENSE] = 36
	pkmn6.iv[:SPEED] = 27
	pkmn6.tera_type = :WATER
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen3GrassPartyQuickStart100 # Poke Paste: https://pokepast.es/6aaf2d2cce90681e
	pkmn1 = Pokemon.new(:WEEZING_1,100)
	pkmn1.item = :TERRAINEXTENDER
	pkmn1.ability_index = 4 # MISTYSURGE
	pkmn1.nature = :BOLD
	pkmn1.learn_move(:STRANGESTEAM)
	pkmn1.learn_move(:FLAMETHROWER)
	pkmn1.learn_move(:TAUNT)
	pkmn1.learn_move(:MEMENTO)
	pkmn1.ev[:HP] = 256
	pkmn1.ev[:ATTACK] = 0 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn1.ev[:DEFENSE] = 172
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 84
	pkmn1.tera_type = :STEEL
	pkmn1.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:SCEPTILE,100)
	pkmn2.item = :MISTYSEED
	pkmn2.ability_index = 5 # UNBURDEN
	pkmn2.nature = :ADAMANT
	pkmn2.learn_move(:SWORDSDANCE)
	pkmn2.learn_move(:LEAFBLADE)
	pkmn2.learn_move(:ACROBATICS)
	pkmn2.learn_move(:EGGBOMB)
	pkmn2.ev[:HP] = 240
	pkmn2.ev[:ATTACK] = 252
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 20
	pkmn2.tera_type = :ICE
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:FERALIGATR,100)
	pkmn3.item = :LIFEORB
	pkmn3.ability_index = 0 # SHEERFORCE
	pkmn3.nature = :JOLLY
	pkmn3.learn_move(:LIQUIDATION)
	pkmn3.learn_move(:CRUNCH)
	pkmn3.learn_move(:DRAGONDANCE)
	pkmn3.learn_move(:ICEPUNCH)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :WATER
	pkmn3.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:SLITHERWING,100)
	pkmn4.item = :BOOSTERENERGY
	pkmn4.ability_index = 0 # PROTOSYNTHESIS
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:VICTORYDANCE)
	pkmn4.learn_move(:LEECHLIFE)
	pkmn4.learn_move(:SUBMISSION)
	pkmn4.learn_move(:SACREDFIRE)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :FIRE
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:BISHARP,100)
	pkmn5.item = :EVIOLITE
	pkmn5.ability_index = 2 # BATTLEARMOR
	pkmn5.nature = :JOLLY
	pkmn5.learn_move(:SWORDSDANCE)
	pkmn5.learn_move(:SUCKERPUNCH)
	pkmn5.learn_move(:IRONHEAD)
	pkmn5.learn_move(:LOWKICK)
	pkmn5.ev[:HP] = 84
	pkmn5.ev[:ATTACK] = 252
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 176
	pkmn5.tera_type = :FLYING
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:NECROZMA,100)
	pkmn6.item = :ROCKYHELMET
	pkmn6.ability_index = 0 # PRISMARMOR
	pkmn6.nature = :IMPISH
	pkmn6.learn_move(:STEALTHROCK)
	pkmn6.learn_move(:MOONLIGHT)
	pkmn6.learn_move(:KNOCKOFF)
	pkmn6.learn_move(:PSYSHIELDBASH)
	pkmn6.ev[:HP] = 252
	pkmn6.iv[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 72
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 184
	pkmn6.tera_type = :FAIRY
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen3FirePartyQuickStart100 # Poke Paste: https://pokepast.es/f0391b5ee43ffe02
	pkmn1 = Pokemon.new(:DRAGONITE,100)
	pkmn1.item = :LOADEDDICE
	pkmn1.ability_index = 0 # MULTISCALE
	pkmn1.nature = :ADAMANT
	pkmn1.learn_move(:PROTECT)
	pkmn1.learn_move(:SCALESHOT)
	pkmn1.learn_move(:TAILWIND)
	pkmn1.learn_move(:STOMPINGTANTRUM)
	pkmn1.ev[:HP] = 196
	pkmn1.ev[:ATTACK] = 252 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn1.ev[:DEFENSE] = 4
	pkmn1.ev[:SPECIAL_DEFENSE] = 4
	pkmn1.ev[:SPEED] = 56
	pkmn1.tera_type = :STEEL
	pkmn1.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:BLAZIKEN,100)
	pkmn2.item = :FOCUSSASH
	pkmn2.ability_index = 6 # SPEEDBOOST
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:DETECT)
	pkmn2.learn_move(:COACHING)
	pkmn2.learn_move(:EGGBOMB)
	pkmn2.learn_move(:CLOSECOMBAT)
	pkmn2.ev[:HP] = 200
	pkmn2.ev[:ATTACK] = 68
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 244
	pkmn2.tera_type = :GRASS
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:RILLABOOM,100)
	pkmn3.item = :ASSAULTVEST
	pkmn3.ability_index = 0 # GRASSYSURGE
	pkmn3.nature = :ADAMANT
	pkmn3.learn_move(:FAKEOUT)
	pkmn3.learn_move(:DRUMBEATING)
	pkmn3.learn_move(:GRASSYGLIDE)
	pkmn3.learn_move(:UTURN)
	pkmn3.ev[:HP] = 244
	pkmn3.ev[:ATTACK] = 36 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn3.ev[:DEFENSE] = 4
	pkmn3.ev[:SPECIAL_DEFENSE] = 220
	pkmn3.ev[:SPEED] = 8
	pkmn3.tera_type = :FIRE
	pkmn3.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:KINGAMBIT,100)
	pkmn4.item = :BLACKGLASSES
	pkmn4.ability_index = 5 # DEFIANT
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:PROTECT)
	pkmn4.learn_move(:SUCKERPUNCH)
	pkmn4.learn_move(:IRONHEAD)
	pkmn4.learn_move(:KOWTOWCLEAVE)
	pkmn4.ev[:HP] = 256
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 0
	pkmn4.tera_type = :DARK
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:PRIMARINA,100)
	pkmn5.item = :THROATSPRAY
	pkmn5.ability_index = 6 # LIQUIDVOICE
	pkmn5.nature = :MODEST
	pkmn5.learn_move(:HYPERVOICE)
	pkmn5.learn_move(:MOONBLAST)
	pkmn5.learn_move(:HAZE)
	pkmn5.learn_move(:PROTECT)
	pkmn5.ev[:HP] = 240
	pkmn5.ev[:ATTACK] = 108
	pkmn5.ev[:DEFENSE] = 68
	pkmn5.ev[:SPECIAL_DEFENSE] = 12
	pkmn5.ev[:SPEED] = 84
	pkmn5.tera_type = :POISON
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:FARIGIRAF,100)
	pkmn6.item = :HONEY
	pkmn6.ability_index = 0 # ARMORTAIL
	pkmn6.nature = :CALM
	pkmn6.learn_move(:TRICKROOM)
	pkmn6.learn_move(:IMPRISON)
	pkmn6.learn_move(:TWINBEAM)
	pkmn6.learn_move(:DAZZLINGGLEAM)
	pkmn6.ev[:HP] = 232
	pkmn6.iv[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 100
	pkmn6.ev[:SPECIAL_DEFENSE] = 180
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :FAIRY
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen3WaterPartyQuickStart100 # Poke Paste: https://pokepast.es/56c33da1ecac96ae
	pkmn1 = Pokemon.new(:INCINEROAR,100)
	pkmn1.item = :ASSAULTVEST
	pkmn1.ability_index = 0 # INTIMIDATE
	pkmn1.nature = :IMPISH
	pkmn1.learn_move(:FAKEOUT)
	pkmn1.learn_move(:FLAREBLITZ)
	pkmn1.learn_move(:UTURN)
	pkmn1.learn_move(:KNOCKOFF)
	pkmn1.ev[:HP] = 256
	pkmn1.ev[:ATTACK] = 20 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn1.ev[:DEFENSE] = 156
	pkmn1.ev[:SPECIAL_DEFENSE] = 44
	pkmn1.ev[:SPEED] = 36
	pkmn1.tera_type = :WATER
	pkmn1.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:RILLABOOM,100)
	pkmn2.item = :MIRACLESEED
	pkmn2.ability_index = 0 # GRASSYSURGE
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:FAKEOUT)
	pkmn2.learn_move(:GRASSYGLIDE)
	pkmn2.learn_move(:WOODHAMMER)
	pkmn2.learn_move(:HIGHHORSEPOWER)
	pkmn2.ev[:HP] = 56
	pkmn2.ev[:ATTACK] = 116
	pkmn2.ev[:DEFENSE] = 52
	pkmn2.ev[:SPECIAL_DEFENSE] = 52
	pkmn2.ev[:SPEED] = 236
	pkmn2.tera_type = :FIRE
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:DRAGONITE,100)
	pkmn3.item = :LOADEDDICE
	pkmn3.ability_index = 0 # MULTISCALE
	pkmn3.nature = :ADAMANT
	pkmn3.learn_move(:PROTECT)
	pkmn3.learn_move(:SCALESHOT)
	pkmn3.learn_move(:TAILWIND)
	pkmn3.learn_move(:HAZE)
	pkmn3.ev[:HP] = 196
	pkmn3.ev[:ATTACK] = 252 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn3.ev[:DEFENSE] = 4
	pkmn3.ev[:SPECIAL_DEFENSE] = 4
	pkmn3.ev[:SPEED] = 56
	pkmn3.tera_type = :FAIRY
	pkmn3.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:SNEASLER,100)
	pkmn4.item = :GRASSYSEED
	pkmn4.ability_index = 0 # UNBURDEN
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:EGGBOMB)
	pkmn4.learn_move(:CLOSECOMBAT)
	pkmn4.learn_move(:POISONTAIL)
	pkmn4.learn_move(:PROTECT)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :DARK
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:GHOLDENGO,100)
	pkmn5.item = :LIFEORB
	pkmn5.ability_index = 0 # WONDERSKIN
	pkmn5.nature = :MODEST
	pkmn5.learn_move(:EGGBOMB)
	pkmn5.learn_move(:SHADOWBALL)
	pkmn5.learn_move(:POWERGEM)
	pkmn5.learn_move(:PROTECT)
	pkmn5.ev[:HP] = 252
	pkmn5.ev[:ATTACK] = 92
	pkmn5.ev[:DEFENSE] = 4
	pkmn5.ev[:SPECIAL_DEFENSE] = 44
	pkmn5.ev[:SPEED] = 120
	pkmn5.tera_type = :DRAGON
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:SWAMPERT,100)
	pkmn6.item = :HONEY
	pkmn6.ability_index = 2 # SHEERFORCE
	pkmn6.nature = :ADAMANT
	pkmn6.learn_move(:EGGBOMB)
	pkmn6.learn_move(:WATERFALL)
	pkmn6.learn_move(:BULKUP)
	pkmn6.learn_move(:WIDEGUARD)
	pkmn6.ev[:HP] = 240
	pkmn6.ev[:ATTACK] = 100
	pkmn6.ev[:DEFENSE] = 36
	pkmn6.ev[:SPECIAL_DEFENSE] = 92
	pkmn6.ev[:SPEED] = 44
	pkmn6.tera_type = :FLYING
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen4GrassPartyQuickStart100 # Poke Paste: https://pokepast.es/33d343e2f1d6c37b
	pkmn1 = Pokemon.new(:FARIGIRAF,100)
	pkmn1.item = :HONEY
	pkmn1.ability_index = 0 # ARMORTAIL
	pkmn1.nature = :CAREFUL
	pkmn1.learn_move(:TRICKROOM)
	pkmn1.learn_move(:HELPINGHAND)
	pkmn1.learn_move(:CURSE)
	pkmn1.learn_move(:BODYSLAM)
	pkmn1.ev[:HP] = 252
	pkmn1.ev[:ATTACK] = 76 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn1.ev[:DEFENSE] = 132
	pkmn1.ev[:SPECIAL_DEFENSE] = 52
	pkmn1.ev[:SPEED] = 0
	pkmn1.tera_type = :FAIRY
	pkmn1.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:URSALUNA,100)
	pkmn2.item = :FLAMEORB
	pkmn2.ability_index = 0 # GUTS
	pkmn2.nature = :BRAVE
	pkmn2.learn_move(:FACADE)
	pkmn2.learn_move(:HEADLONGRUSH)
	pkmn2.learn_move(:DRAINPUNCH)
	pkmn2.learn_move(:PROTECT)
	pkmn2.ev[:HP] = 144
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 44
	pkmn2.ev[:SPECIAL_DEFENSE] = 68
	pkmn2.ev[:SPEED] = 0
	pkmn2.tera_type = :NORMAL
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:INDEEDEE_1,100)
	pkmn3.makeFemale # Only done for Female Indeede, to make sure the correct form sprite is used
	pkmn3.item = :FOCUSSASH
	pkmn3.ability_index = 3 # OWNTEMPO
	pkmn3.nature = :BOLD
	pkmn3.learn_move(:FOLLOWME)
	pkmn3.learn_move(:HEALINGWISH)
	pkmn3.learn_move(:HEALPULSE)
	pkmn3.learn_move(:DAZZLINGGLEAM)
	pkmn3.ev[:HP] = 256
	pkmn3.ev[:ATTACK] = 0 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn3.ev[:DEFENSE] = 256
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 0
	pkmn3.tera_type = :WATER
	pkmn3.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:GALLADE,100)
	pkmn4.item = :MEGAITE
	pkmn4.ability_index = 0 # Base Ability: INTREPIDSWORD Mega Ability: SHARPNESS
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:VICTORYDANCE)
	pkmn4.learn_move(:SACREDSWORD)
	pkmn4.learn_move(:PSYCHOCUT)
	pkmn4.learn_move(:AQUACUTTER)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :DARK
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:TORTERRA,100)
	pkmn5.item = :EJECTPACK
	pkmn5.ability_index = 0 # SHELLARMOR
	pkmn5.nature = :ADAMANT
	pkmn5.learn_move(:HEADLONGRUSH)
	pkmn5.learn_move(:SAPPYSEED)
	pkmn5.learn_move(:SMACKDOWN)
	pkmn5.learn_move(:STEALTHROCK)
	pkmn5.ev[:HP] = 220
	pkmn5.ev[:ATTACK] = 212
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 80
	pkmn5.tera_type = :GHOST
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:DUSCLOPS,100)
	pkmn6.item = :EVIOLITE
	pkmn6.ability_index = 4 # INTIMIDATE
	pkmn6.nature = :CALM
	pkmn6.learn_move(:TRICKROOM)
	pkmn6.learn_move(:NIGHTSHADE)
	pkmn6.learn_move(:WILLOWISP)
	pkmn6.learn_move(:HELPINGHAND)
	pkmn6.ev[:HP] = 256
	pkmn6.iv[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 256
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :POISON
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen4FirePartyQuickStart100 # Poke Paste: https://pokepast.es/11fd54de4b4e6b9a
	pkmn1 = Pokemon.new(:INFERNAPE,100)
	pkmn1.item = :FOCUSSASH
	pkmn1.ability_index = 0 # DOWNLOAD (This ability has been renamed to Instinct, to allow more Pokemon to have this ability, than just technology Pokemon) 
	pkmn1.nature = :NAIVE # Because Instinct could boost Atk or Sp.Atk, This Nature Modifier is used, in order to not weaken Atk or Sp.Atk with a Jolly or Timid Nature Modifier
	pkmn1.learn_move(:FAKEOUT)
	pkmn1.learn_move(:OVERHEAT)
	pkmn1.learn_move(:CLOSECOMBAT)
	pkmn1.learn_move(:UTURN)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256 # Infernape's a prime example of a Pokemon who massively benefits from the EV Allowcator Overhaul 
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :ELECTRIC
	pkmn1.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:HYDREIGON,100)
	pkmn2.item = :LIFEORB
	pkmn2.ability_index = 4 # MEGALAUNCHER (Moves such as Flamethrower are now boosted by Mega Launcher)
	pkmn2.nature = :TIMID
	pkmn2.learn_move(:DRAGONPULSE)
	pkmn2.learn_move(:DARKPULSE)
	pkmn2.learn_move(:FLASHCANNON)
	pkmn2.learn_move(:FLAMETHROWER)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :STEEL
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:KILOWATTREL,100)
	pkmn3.item = :COVERTCLOAK
	pkmn3.ability_index = 0 # COMPETITIVE
	pkmn3.nature = :TIMID
	pkmn3.learn_move(:TAILWIND)
	pkmn3.learn_move(:THUNDERBOLT)
	pkmn3.learn_move(:EGGBOMB)
	pkmn3.learn_move(:VOLTSWITCH)
	pkmn3.ev[:HP] = 96
	pkmn3.ev[:ATTACK] = 160 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :GHOST
	pkmn3.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:GASTRODON,100)
	pkmn4.item = :HONEY
	pkmn4.ability_index = 4 # STORMDRAIN
	pkmn4.nature = :BOLD
	pkmn4.learn_move(:EARTHPOWER)
	pkmn4.learn_move(:MUDDYWATER)
	pkmn4.learn_move(:YAWN)
	pkmn4.learn_move(:PROTECT)
	pkmn4.ev[:HP] = 184
	pkmn4.ev[:ATTACK] = 0
	pkmn4.ev[:DEFENSE] = 204
	pkmn4.ev[:SPECIAL_DEFENSE] = 124
	pkmn4.ev[:SPEED] = 0
	pkmn4.tera_type = :BUG
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:RILLABOOM,100)
	pkmn5.item = :ASSAULTVEST
	pkmn5.ability_index = 0 # GRASSYSURGE
	pkmn5.nature = :ADAMANT
	pkmn5.learn_move(:WOODHAMMER)
	pkmn5.learn_move(:GRASSYGLIDE)
	pkmn5.learn_move(:FAKEOUT)
	pkmn5.learn_move(:UTURN)
	pkmn5.ev[:HP] = 204
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 52
	pkmn5.tera_type = :FIRE
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:MAGMAR,100)
	pkmn6.item = :EVIOLITE
	pkmn6.ability_index = 5 # FLASHFIRE
	pkmn6.nature = :CALM
	pkmn6.learn_move(:EMBER)
	pkmn6.learn_move(:CLEARSMOG)
	pkmn6.learn_move(:FOLLOWME)
	pkmn6.learn_move(:PROTECT)
	pkmn6.ev[:HP] = 256
	pkmn6.iv[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 236
	pkmn6.ev[:SPECIAL_DEFENSE] = 20
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :WATER
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen4WaterPartyQuickStart100 # Poke Paste: https://pokepast.es/34cd5ffd188f2107
	pkmn1 = Pokemon.new(:GHOLDENGO,100)
	pkmn1.item = :CHOICESCARF
	pkmn1.ability_index = 3 # ADAPTABILITY
	pkmn1.nature = :TIMID
	pkmn1.learn_move(:TRICK)
	pkmn1.learn_move(:SHADOWBALL)
	pkmn1.learn_move(:MAKEITRAIN)
	pkmn1.learn_move(:FOCUSBLAST)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :DARK
	pkmn1.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn1.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:GLISCOR,100)
	pkmn2.item = :ROCKYHELMET
	pkmn2.ability_index = 3 # LEVITATE
	pkmn2.nature = :CAREFUL
	pkmn2.learn_move(:KNOCKOFF)
	pkmn2.learn_move(:CROSSPOISON)
	pkmn2.learn_move(:SPIKES)
	pkmn2.learn_move(:ROOST)
	pkmn2.ev[:HP] = 248
	pkmn2.ev[:ATTACK] = 0
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 252
	pkmn2.ev[:SPEED] = 12
	pkmn2.tera_type = :FIRE
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:GARGANACL,100)
	pkmn3.item = :LEFTOVERS
	pkmn3.ability_index = 2 # WATERABSORB
	pkmn3.nature = :IMPISH
	pkmn3.learn_move(:CURSE)
	pkmn3.learn_move(:SALTCURE)
	pkmn3.learn_move(:EARTHQUAKE)
	pkmn3.learn_move(:RECOVER)
	pkmn3.ev[:HP] = 252
	pkmn3.ev[:ATTACK] = 0 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn3.ev[:DEFENSE] = 144
	pkmn3.ev[:SPECIAL_DEFENSE] = 116
	pkmn3.ev[:SPEED] = 0
	pkmn3.tera_type = :FAIRY
	pkmn3.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:EMPOLEON,100)
	pkmn4.item = :ASSAULTVEST
	pkmn4.ability_index = 4 # BATTLEARMOR
	pkmn4.nature = :MODEST
	pkmn4.learn_move(:EGGBOMB)
	pkmn4.learn_move(:SURF)
	pkmn4.learn_move(:ICEBEAM)
	pkmn4.learn_move(:VACUUMWAVE)
	pkmn4.ev[:HP] = 256
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 0
	pkmn4.tera_type = :FLYING
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:GREATTUSK,100)
	pkmn5.item = :HEAVYDUTYBOOTS
	pkmn5.ability_index = 5 # THICKFAT
	pkmn5.nature = :IMPISH
	pkmn5.learn_move(:RAPIDSPIN)
	pkmn5.learn_move(:ICESPINNER)
	pkmn5.learn_move(:STEALTHROCK)
	pkmn5.learn_move(:CLOSCOMBAT)
	pkmn5.ev[:HP] = 220
	pkmn5.ev[:ATTACK] = 0
	pkmn5.ev[:DEFENSE] = 252
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 40
	pkmn5.tera_type = :GRASS
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:ZAMAZENTA,100)
	pkmn6.item = :RUSTEDSHIELD
	pkmn6.ability_index = 2 # STAMINA
	pkmn6.nature = :CAREFUL
	pkmn6.learn_move(:EGGBOMB)
	pkmn6.learn_move(:BEHEMOTHBASH)
	pkmn6.learn_move(:REST)
	pkmn6.learn_move(:METALBURST)
	pkmn6.ev[:HP] = 256
	pkmn6.iv[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 64
	pkmn6.ev[:SPECIAL_DEFENSE] = 192
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :WATER
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen5GrassPartyQuickStart100 # Poke Paste: https://pokepast.es/93024247192aa5f0
	pkmn1 = Pokemon.new(:KOMMOO,100)
	pkmn1.item = :SAFETYGOGGLES
	pkmn1.ability_index = 6 # BATTLEARMOR
	pkmn1.nature = :IMPISH
	pkmn1.learn_move(:BODYPRESS)
	pkmn1.learn_move(:THROATCHOP)
	pkmn1.learn_move(:IRONDEFENSE)
	pkmn1.learn_move(:SLACKOFF)
	pkmn1.ev[:HP] = 256
	pkmn1.iv[:ATTACK] = 0
	pkmn1.ev[:DEFENSE] = 256
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 0
	pkmn1.tera_type = :FIGHTING
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:TYRANITAR,100)
	pkmn2.item = :ASSAULTVEST
	pkmn2.ability_index = 0 # SANDSTREAM
	pkmn2.nature = :ADAMANT
	pkmn2.learn_move(:KNOCKOFF)
	pkmn2.learn_move(:ROCKSLIDE)
	pkmn2.learn_move(:EGGBOMB)
	pkmn2.learn_move(:HIGHHORSEPOWER)
	pkmn2.ev[:HP] = 140
	pkmn2.ev[:ATTACK] = 252
	pkmn2.ev[:DEFENSE] = 4
	pkmn2.ev[:SPECIAL_DEFENSE] = 4
	pkmn2.ev[:SPEED] = 112
	pkmn2.tera_type = :FLYING
	pkmn2.dynamax_able = false
	pkmn2.calc_stats
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:SERPERIOR,100)
	pkmn3.item = :HONEY
	pkmn3.ability_index = 3 # CONTRARY
	pkmn3.nature = :TIMID
	pkmn3.learn_move(:LEAFSTORM)
	pkmn3.learn_move(:DRACOMETEOR)
	pkmn3.learn_move(:TAUNT)
	pkmn3.learn_move(:PROTECT)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :FIRE
	pkmn3.dynamax_able = false
	pkmn3.calc_stats
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:GRIMMSNARL,100)
	pkmn4.item = :LIGHTCLAY
	pkmn4.ability_index = 4 # PRANKSTER
	pkmn4.nature = :CAREFUL
	pkmn4.learn_move(:SPIRITBREAK)
	pkmn4.learn_move(:LIGHTSCREEN)
	pkmn4.learn_move(:REFLECT)
	pkmn4.learn_move(:PARTINGSHOT)
	pkmn4.ev[:HP] = 240
	pkmn4.iv[:ATTACK] = 0
	pkmn4.ev[:DEFENSE] = 156
	pkmn4.ev[:SPECIAL_DEFENSE] = 116
	pkmn4.ev[:SPEED] = 0
	pkmn4.tera_type = :GHOST
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:GHOLDENGO,100)
	pkmn5.item = :CHOICESCARF
	pkmn5.ability_index = 3 # ADAPTABILITY
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:PROTECT)
	pkmn5.learn_move(:SHADOWBALL)
	pkmn5.learn_move(:MAKEITRAIN)
	pkmn5.learn_move(:NASTYPLOT)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :STEEL
	pkmn5.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:PORYGON2,100)
	pkmn6.item = :EVIOLITE
	pkmn6.ability_index = 2 # TRACE
	pkmn6.nature = :BOLD
	pkmn6.learn_move(:THUNDERBOLT)
	pkmn6.learn_move(:ICEBEAM)
	pkmn6.learn_move(:TRICKROOM)
	pkmn6.learn_move(:RECOVER)
	pkmn6.ev[:HP] = 256
	pkmn6.ev[:ATTACK] = 0 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn6.ev[:DEFENSE] = 196
	pkmn6.ev[:SPECIAL_DEFENSE] = 60
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :ELECTRIC
	pkmn6.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen5FirePartyQuickStart100 # Poke Paste: https://pokepast.es/9de684bec8b65aa6
	pkmn1 = Pokemon.new(:EMBOAR,100)
	pkmn1.item = :CHOICESCARF
	pkmn1.ability_index = 0 # RECKLESS
	pkmn1.nature = :JOLLY
	pkmn1.learn_move(:HEADSMASH)
	pkmn1.learn_move(:FLAREBLITZ)
	pkmn1.learn_move(:DOUBLEEDGE)
	pkmn1.learn_move(:WILDCHARGE)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :GRASS
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:SABLEYE,100)
	pkmn2.item = :REDCARD
	pkmn2.ability_index = 4 # PRANKSTER
	pkmn2.nature = :CAREFUL
	pkmn2.learn_move(:SUNNYDAY)
	pkmn2.learn_move(:WILLOWISP)
	pkmn2.learn_move(:KNOCKOFF)
	pkmn2.learn_move(:SPIRITSHACKLE)
	pkmn2.ev[:HP] = 256
	pkmn2.iv[:ATTACK] = 4
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 252
	pkmn2.ev[:SPEED] = 0
	pkmn2.tera_type = :STEEL
	pkmn2.dynamax_able = false
	pkmn2.calc_stats
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:NINETALES,100)
	pkmn3.item = :HEATROCK
	pkmn3.ability_index = 0 # DROUGHT
	pkmn3.nature = :TIMID
	pkmn3.learn_move(:FLAMEBURST)
	pkmn3.learn_move(:SOLARBEAM)
	pkmn3.learn_move(:ENCORE)
	pkmn3.learn_move(:HEALINGWISH)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :FLYING
	pkmn3.dynamax_able = false
	pkmn3.calc_stats
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:EXEGGUTOR,100)
	pkmn4.item = :LUMBERRY
	pkmn4.ability_index = 3 # HARVEST
	pkmn4.nature = :MODEST
	pkmn4.learn_move(:REST)
	pkmn4.learn_move(:STUNSPORE)
	pkmn4.learn_move(:GIGADRAIN)
	pkmn4.learn_move(:PSYSHOCK)
	pkmn4.ev[:HP] = 252
	pkmn4.ev[:ATTACK] = 176
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 84
	pkmn4.tera_type = :WATER
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:VENUSAUR,100)
	pkmn5.item = :LIFEORB
	pkmn5.ability_index = 3 # CHLOROPHYLL
	pkmn5.nature = :MODEST
	pkmn5.learn_move(:GROWTH)
	pkmn5.learn_move(:SOLARBEAM)
	pkmn5.learn_move(:WEATHERBALL)
	pkmn5.learn_move(:ACIDSPRAY)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :FIRE
	pkmn5.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:SWAMPERT,100)
	pkmn6.item = :HONEY
	pkmn6.ability_index = 0 # REGENERATOR
	pkmn6.nature = :ADAMANT
	pkmn6.learn_move(:FLIPTURN)
	pkmn6.learn_move(:EGGBOMB)
	pkmn6.learn_move(:KNOCKOFF)
	pkmn6.learn_move(:STEALTHROCK)
	pkmn6.ev[:HP] = 256
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :POISON
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen5WaterPartyQuickStart100 # Poke Paste: https://pokepast.es/87d1f20a06b7af01 (Samurott needs to be tweaked to be it's base form)
	pkmn1 = Pokemon.new(:SAMUROTT,100)
	pkmn1.item = :ASSAULTVEST
	pkmn1.ability_index = 4 # SHARPNESS
	pkmn1.nature = :ADAMANT
	pkmn1.learn_move(:SLASH)
	pkmn1.learn_move(:RAZORSHELL)
	pkmn1.learn_move(:AQUAJET)
	pkmn1.learn_move(:CEASELESSEDGE)
	pkmn1.ev[:HP] = 248
	pkmn1.ev[:ATTACK] = 84
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 124
	pkmn1.ev[:SPEED] = 56
	pkmn1.tera_type = :GHOST
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:CLEFABLE,100)
	pkmn2.item = :HONEY
	pkmn2.ability_index = 3 # FRIENDGUARD
	pkmn2.nature = :BOLD
	pkmn2.learn_move(:MOONBLAST)
	pkmn2.learn_move(:MISTYTERRAIN)
	pkmn2.learn_move(:FOLLOWME)
	pkmn2.learn_move(:PROTECT)
	pkmn2.ev[:HP] = 248
	pkmn2.ev[:ATTACK] = 0
	pkmn2.ev[:DEFENSE] = 180
	pkmn2.ev[:SPECIAL_DEFENSE] = 84
	pkmn2.ev[:SPEED] = 0
	pkmn2.tera_type = :WATER
	pkmn2.dynamax_able = false
	pkmn2.calc_stats
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:GARCHOMP,100)
	pkmn3.item = :LIFEORB
	pkmn3.ability_index = 6 # HYPERCUTTER
	pkmn3.nature = :JOLLY
	pkmn3.learn_move(:PROTECT)
	pkmn3.learn_move(:SLASH)
	pkmn3.learn_move(:DRAGONCLAW)
	pkmn3.learn_move(:IRONTAIL)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :FIRE
	pkmn3.dynamax_able = false
	pkmn3.calc_stats
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:GHOLDENGO,100)
	pkmn4.item = :LEFTOVERS
	pkmn4.ability_index = 4 # RATTLED
	pkmn4.nature = :MODEST
	pkmn4.learn_move(:EGGBOMB)
	pkmn4.learn_move(:ASTRALBARRAGE)
	pkmn4.learn_move(:NASTYPLOT)
	pkmn4.learn_move(:PROTECT)
	pkmn4.ev[:HP] = 236
	pkmn4.ev[:ATTACK] = 52 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn4.ev[:DEFENSE] = 4
	pkmn4.ev[:SPECIAL_DEFENSE] = 52
	pkmn4.ev[:SPEED] = 168
	pkmn4.tera_type = :DRAGON
	pkmn4.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:HYDREIGON,100)
	pkmn5.item = :CHOICESPECS
	pkmn5.ability_index = 4 # MEGALAUNCHER (Moves such as Flamethrower are now boosted by Mega Launcher)
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:HYPERBEAM)
	pkmn5.learn_move(:DRACOMETEOR)
	pkmn5.learn_move(:FIREBLAST)
	pkmn5.learn_move(:FLASHCANNON)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :POISON
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:WHIMSICOTT,100)
	pkmn6.item = :FOCUSSASH
	pkmn6.ability_index = 0 # PRANKSTER
	pkmn6.nature = :TIMID
	pkmn6.learn_move(:EGGBOMB)
	pkmn6.learn_move(:TAILWIND)
	pkmn6.learn_move(:SUNNYDAY)
	pkmn6.learn_move(:ENCORE)
	pkmn6.ev[:HP] = 184
	pkmn6.ev[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 108
	pkmn6.ev[:SPEED] = 220
	pkmn6.tera_type = :DARK
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen6GrassPartyQuickStart100 # Poke Paste: https://pokepast.es/6f4e9f30a5729a02
	pkmn1 = Pokemon.new(:CHESNAUGHT,100)
	pkmn1.item = :LEFTOVERS
	pkmn1.ability_index = 3 # SHELLARMOR
	pkmn1.nature = :IMPISH
	pkmn1.learn_move(:REST)
	pkmn1.learn_move(:TAUNT)
	pkmn1.learn_move(:SAPPYSEED)
	pkmn1.learn_move(:METALBURST)
	pkmn1.ev[:HP] = 256
	pkmn1.ev[:ATTACK] = 0
	pkmn1.ev[:DEFENSE] = 80
	pkmn1.ev[:SPECIAL_DEFENSE] = 176
	pkmn1.ev[:SPEED] = 0
	pkmn1.tera_type = :WATER
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:ROARINGMOON,100)
	pkmn2.item = :BOOSTERENERGY
	pkmn2.ability_index = 0 # PROTOSYNTHESIS
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:DRAGONDANCE)
	pkmn2.learn_move(:KNOCKOFF)
	pkmn2.learn_move(:ACROBATICS)
	pkmn2.learn_move(:BRICKBREAK)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :FLYING
	pkmn2.dynamax_able = false
	pkmn2.calc_stats
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:GREATTUSK,100)
	pkmn3.item = :HEAVYDUTYBOOTS
	pkmn3.ability_index = 5 # THICKFAT
	pkmn3.nature = :JOLLY
	pkmn3.learn_move(:VICTORYDANCE)
	pkmn3.learn_move(:RAPIDSPIN)
	pkmn3.learn_move(:EGGBOMB)
	pkmn3.learn_move(:ICESPINNER)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :POISON
	pkmn3.dynamax_able = false
	pkmn3.calc_stats
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:RILLABOOM,100)
	pkmn4.item = :TERRAINEXTENDER
	pkmn4.ability_index = 0 # GRASSYSURGE
	pkmn4.nature = :ADAMANT
	pkmn4.learn_move(:UTURN)
	pkmn4.learn_move(:GRASSYGLIDE)
	pkmn4.learn_move(:TAUNT)
	pkmn4.learn_move(:KNOCKOFF)
	pkmn4.ev[:HP] = 240
	pkmn4.ev[:ATTACK] = 252 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 20
	pkmn4.tera_type = :GRASS
	pkmn4.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:HEATRAN,100)
	pkmn5.item = :AIRBALLOON
	pkmn5.ability_index = 6 # ROCKYPAYLOAD (Rocky Payload gives Rock STAB, and will set Stealth Rock if user is hit by a contact move
	pkmn5.nature = :BOLD
	pkmn5.learn_move(:EMBER)
	pkmn5.learn_move(:EARTHPOWER)
	pkmn5.learn_move(:MAGMASTORM)
	pkmn5.learn_move(:MORNINGSUN)
	pkmn5.ev[:HP] = 252
	pkmn5.ev[:ATTACK] = 0
	pkmn5.ev[:DEFENSE] = 88
	pkmn5.ev[:SPECIAL_DEFENSE] = 172
	pkmn5.ev[:SPEED] = 0
	pkmn5.tera_type = :GHOST
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:HAWLUCHA,100)
	pkmn6.item = :GRASSYSEED
	pkmn6.ability_index = 0 # UNBURDEN
	pkmn6.nature = :ADAMANT
	pkmn6.learn_move(:SWORDSDANCE)
	pkmn6.learn_move(:ENCORE)
	pkmn6.learn_move(:EGGBOMB)
	pkmn6.learn_move(:CLOSECOMBAT)
	pkmn6.ev[:HP] = 128
	pkmn6.ev[:ATTACK] = 252
	pkmn6.ev[:DEFENSE] = 4
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 128
	pkmn6.tera_type = :ELECTRIC
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen6FirePartyQuickStart100 # Poke Paste: https://pokepast.es/b601021be152e474
	pkmn1 = Pokemon.new(:DELPHOX,100)
	pkmn1.item = :LIFEORB
	pkmn1.ability_index = 2 # BATTLEBOND
	pkmn1.nature = :TIMID
	pkmn1.learn_move(:EXPANDINGFORCE)
	pkmn1.learn_move(:HEATWAVE)
	pkmn1.learn_move(:GRASSKNOT)
	pkmn1.learn_move(:PROTECT)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :GRASS
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:INDEEDEE,100)
	pkmn2.makeMale # Only done for Male Indeede, to make sure the correct form sprite is used
	pkmn2.item = :FOCUSSASH
	pkmn2.ability_index = 0 # PSYCHICSURGE
	pkmn2.nature = :TIMID
	pkmn2.learn_move(:EXPANDINGFORCE)
	pkmn2.learn_move(:TERABLAST)
	pkmn2.learn_move(:IMPRISON)
	pkmn2.learn_move(:TRICKROOM)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :FIGHTING
	pkmn2.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:SNEASLER,100)
	pkmn3.item = :PSYCHICSEED
	pkmn3.ability_index = 0 # UNBURDEN
	pkmn3.nature = :JOLLY
	pkmn3.learn_move(:EGGBOMB)
	pkmn3.learn_move(:CLOSECOMBAT)
	pkmn3.learn_move(:POISONTAIL)
	pkmn3.learn_move(:PROTECT)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :DARK
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:WHIMSICOTT,100)
	pkmn4.item = :FOCUSSASH
	pkmn4.ability_index = 0 # PRANKSTER
	pkmn4.nature = :TIMID
	pkmn4.learn_move(:EGGBOMB)
	pkmn4.learn_move(:TAILWIND)
	pkmn4.learn_move(:SUNNYDAY)
	pkmn4.learn_move(:ENCORE)
	pkmn4.ev[:HP] = 184
	pkmn4.ev[:ATTACK] = 0
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 108
	pkmn4.ev[:SPEED] = 220
	pkmn4.tera_type = :WATER
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:MAUSHOLD,100)
	pkmn5.item = :WIDELENS
	pkmn5.ability_index = 4 # TECHNICIAN 
	pkmn5.nature = :JOLLY
	pkmn5.learn_move(:POPULATIONBOMB)
	pkmn5.learn_move(:FOLLOWME)
	pkmn5.learn_move(:BITE)
	pkmn5.learn_move(:PROTECT)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :NORMAL
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:ANNIHILAPE,100)
	pkmn6.item = :ASSAULTVEST
	pkmn6.ability_index = 5 # MOXIE
	pkmn6.nature = :JOLLY
	pkmn6.learn_move(:FINALGAMBIT)
	pkmn6.learn_move(:DRAINPUNCH)
	pkmn6.learn_move(:MEGAPUNCH)
	pkmn6.learn_move(:ROCKTOMB)
	pkmn6.ev[:HP] = 252
	pkmn6.ev[:ATTACK] = 76
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 180
	pkmn6.tera_type = :FIRE
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen6WaterPartyQuickStart100 # Poke Paste: https://pokepast.es/5504c7ce0c736539
	pkmn1 = Pokemon.new(:GRENINJA,100)
	pkmn1.item = :MEGAITE
	pkmn1.ability_index = 0 # PROTEAN
	pkmn1.nature = :TIMID
	pkmn1.learn_move(:HYDROCANNON)
	pkmn1.learn_move(:EGGBOMB)
	pkmn1.learn_move(:AEROBLAST)
	pkmn1.learn_move(:EXTRASENSORY)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :WATER
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:CLODSIRE,100)
	pkmn2.item = :HEAVYDUTYBOOTS
	pkmn2.ability_index = 3 # WATERABSORB
	pkmn2.nature = :CAREFUL
	pkmn2.learn_move(:STEALTHROCK)
	pkmn2.learn_move(:RAPIDSPIN)
	pkmn2.learn_move(:SPIKES)
	pkmn2.learn_move(:RECOVER)
	pkmn2.ev[:HP] = 252
	pkmn2.ev[:ATTACK] = 0 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn2.ev[:DEFENSE] = 8
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 252
	pkmn2.tera_type = :DARK
	pkmn2.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:GHOLDENGO,100)
	pkmn3.item = :COVERTCLOAK
	pkmn3.ability_index = 5 # PRANKSTER
	pkmn3.nature = :TIMID
	pkmn3.learn_move(:SHADOWBALL)
	pkmn3.learn_move(:EGGBOMB)
	pkmn3.learn_move(:RECOVER)
	pkmn3.learn_move(:NASTYPLOT)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :FLYING
	pkmn3.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:IRONVALIANT,100)
	pkmn4.item = :CHOICESPECS
	pkmn4.ability_index = 4 # MOTORDRIVE
	pkmn4.nature = :TIMID
	pkmn4.learn_move(:SPARKLYSWIRL)
	pkmn4.learn_move(:PSYSHOCK)
	pkmn4.learn_move(:TRICK)
	pkmn4.learn_move(:THUNDERBOLT)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :FAIRY
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:GREATTUSK,100)
	pkmn5.item = :ROCKYHELMET
	pkmn5.ability_index = 4 # THICKFAT 
	pkmn5.nature = :IMPISH
	pkmn5.learn_move(:RAPIDSPIN)
	pkmn5.learn_move(:BULKUP)
	pkmn5.learn_move(:KNOCKOFF)
	pkmn5.learn_move(:BODYPRESS)
	pkmn5.ev[:HP] = 256
	pkmn5.ev[:ATTACK] = 0
	pkmn5.ev[:DEFENSE] = 216
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 40
	pkmn5.tera_type = :STEEL
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:CORVIKNIGHT,100)
	pkmn6.item = :LEFTOVERS
	pkmn6.ability_index = 0 # STAMINA
	pkmn6.nature = :CAREFUL
	pkmn6.learn_move(:DOUBLEEDGE)
	pkmn6.learn_move(:MEDITATE)
	pkmn6.learn_move(:ROOST)
	pkmn6.learn_move(:BODYPRESS)
	pkmn6.ev[:HP] = 256
	pkmn6.ev[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 4
	pkmn6.ev[:SPECIAL_DEFENSE] = 252
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :GROUND
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen7GrassPartyQuickStart100 # Poke Paste: https://pokepast.es/6b48dc53126cba80
	pkmn1 = Pokemon.new(:DECIDUEYE,100)
	pkmn1.item = :BIGROOT
	pkmn1.ability_index = 0 # LONGREACH
	pkmn1.nature = :JOLLY
	pkmn1.learn_move(:SAPPYSEED)
	pkmn1.learn_move(:UTURN)
	pkmn1.learn_move(:HAZE)
	pkmn1.learn_move(:TAILWIND)
	pkmn1.ev[:HP] = 20
	pkmn1.ev[:ATTACK] = 0
	pkmn1.ev[:DEFENSE] = 100
	pkmn1.ev[:SPECIAL_DEFENSE] = 144
	pkmn1.ev[:SPEED] = 248
	pkmn1.tera_type = :FAIRY
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:CERULEDGE,100)
	pkmn2.item = :LIFEORB
	pkmn2.ability_index = 0 # SHARPNESS
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:BITTERBLADE)
	pkmn2.learn_move(:SLASH)
	pkmn2.learn_move(:CLOSECOMAT)
	pkmn2.learn_move(:PROTECT)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :GRASS
	pkmn2.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:INCINEROAR,100)
	pkmn3.item = :SAFETYGOGGLES
	pkmn3.ability_index = 0 # Intimidate
	pkmn3.nature = :CAREFUL
	pkmn3.learn_move(:FAKEOUT)
	pkmn3.learn_move(:PARTINGSHOT)
	pkmn3.learn_move(:FLAREBLITZ)
	pkmn3.learn_move(:KNOCKOFF)
	pkmn3.ev[:HP] = 244
	pkmn3.ev[:ATTACK] = 4
	pkmn3.ev[:DEFENSE] = 132
	pkmn3.ev[:SPECIAL_DEFENSE] = 84
	pkmn3.ev[:SPEED] = 48
	pkmn3.tera_type = :GHOST
	pkmn3.dynamax_able = false
	pkmn3.calc_stats
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:URSALUNA,100)
	pkmn4.item = :FLAMEORB
	pkmn4.ability_index = 0 # GUTS
	pkmn4.nature = :BRAVE
	pkmn4.learn_move(:FACADE)
	pkmn4.learn_move(:HEADLONGRUSH)
	pkmn4.learn_move(:FIREPUNCH)
	pkmn4.learn_move(:PROTECT)
	pkmn4.ev[:HP] = 140
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 44
	pkmn4.ev[:SPECIAL_DEFENSE] = 68
	pkmn4.ev[:SPEED] = 0
	pkmn4.tera_type = :POISON
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:TORKOAL,100)
	pkmn5.item = :EJECTPACK
	pkmn5.ability_index = 2 # DROUGHT
	pkmn5.nature = :QUIET
	pkmn5.learn_move(:ERUPTION)
	pkmn5.learn_move(:OVERHEAT)
	pkmn5.learn_move(:HELPINGHAND)
	pkmn5.learn_move(:PROTECT)
	pkmn5.ev[:HP] = 176
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 72
	pkmn5.ev[:SPEED] = 0
	pkmn5.tera_type = :FIRE
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:PORYGON2,100)
	pkmn6.item = :EVIOLITE
	pkmn6.ability_index = 0 # ANALYTIC
	pkmn6.nature = :BOLD
	pkmn6.learn_move(:ICEBEAM)
	pkmn6.learn_move(:EGGBOMB)
	pkmn6.learn_move(:TRICKROOM)
	pkmn6.learn_move(:RECOVER)
	pkmn6.ev[:HP] = 256
	pkmn6.ev[:ATTACK] = 8
	pkmn6.ev[:DEFENSE] = 176
	pkmn6.ev[:SPECIAL_DEFENSE] = 72
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :FIGHTING
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen7FirePartyQuickStart100 # Poke Paste: https://pokepast.es/b7fb981ef157f4aa
	pkmn1 = Pokemon.new(:INCINEROAR,100)
	pkmn1.item = :SAFETYGOGGLES
	pkmn1.ability_index = 0 # Intimidate
	pkmn1.nature = :CAREFUL
	pkmn1.learn_move(:FAKEOUT)
	pkmn1.learn_move(:PARTINGSHOT)
	pkmn1.learn_move(:FLAREBLITZ)
	pkmn1.learn_move(:KNOCKOFF)
	pkmn1.ev[:HP] = 256
	pkmn1.ev[:ATTACK] = 0
	pkmn1.ev[:DEFENSE] = 164
	pkmn1.ev[:SPECIAL_DEFENSE] = 92
	pkmn1.ev[:SPEED] = 0
	pkmn1.tera_type = :GHOST
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:RILLABOOM,100)
	pkmn2.item = :ASSAULTVEST
	pkmn2.ability_index = 0 # GRASSYSURGE
	pkmn2.nature = :ADAMANT
	pkmn2.learn_move(:WOODHAMMER)
	pkmn2.learn_move(:GRASSYGLIDE)
	pkmn2.learn_move(:FAKEOUT)
	pkmn2.learn_move(:UTURN)
	pkmn2.ev[:HP] = 248
	pkmn2.ev[:ATTACK] = 116
	pkmn2.ev[:DEFENSE] = 12
	pkmn2.ev[:SPECIAL_DEFENSE] = 132
	pkmn2.ev[:SPEED] = 4
	pkmn2.tera_type = :POISON
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:FARIGIRAF,100)
	pkmn3.item = :THROATSPRAY
	pkmn3.ability_index = 0 # Armor Tail
	pkmn3.nature = :MODEST
	pkmn3.learn_move(:PROTECT)
	pkmn3.learn_move(:TRICKROOM)
	pkmn3.learn_move(:HYPERVOICE)
	pkmn3.learn_move(:PSYCHIC)
	pkmn3.ev[:HP] = 112
	pkmn3.ev[:ATTACK] = 156
	pkmn3.ev[:DEFENSE] = 44
	pkmn3.ev[:SPECIAL_DEFENSE] = 196
	pkmn3.ev[:SPEED] = 0
	pkmn3.iv[:ATTACK] = 0
	pkmn3.iv[:SPEED] = 27
	pkmn3.tera_type = :FAIRY
	pkmn3.dynamax_able = false
	pkmn3.calc_stats
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:FLUTTERMANE,100)
	pkmn4.item = :BOOSTERENERGY
	pkmn4.ability_index = 0 # Protosynthesis
	pkmn4.nature = :TIMID
	pkmn4.learn_move(:PROTECT)
	pkmn4.learn_move(:MOONBLAST)
	pkmn4.learn_move(:SHADOWBALL)
	pkmn4.learn_move(:CALMMIND)
	pkmn4.ev[:HP] = 164
	pkmn4.ev[:ATTACK] = 108
	pkmn4.ev[:DEFENSE] = 164
	pkmn4.ev[:SPECIAL_DEFENSE] = 4
	pkmn4.ev[:SPEED] = 72
	pkmn4.iv[:ATTACK] = 0
	pkmn4.tera_type = :GRASS
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:URSHIFU_1,100)
	pkmn5.item = :CHOICESCARF
	pkmn5.ability_index = 0 # Defiant
	pkmn5.nature = :ADAMANT
	pkmn5.learn_move(:SURGINGSTRIKES)
	pkmn5.learn_move(:CLOSECOMBAT)
	pkmn5.learn_move(:AQUAJET)
	pkmn5.learn_move(:UTURN)
	pkmn5.ev[:HP] = 44
	pkmn5.ev[:ATTACK] = 156
	pkmn5.ev[:DEFENSE] = 4
	pkmn5.ev[:SPECIAL_DEFENSE] = 92
	pkmn5.ev[:SPEED] = 216
	pkmn5.iv[:SPECIAL_ATTACK] = 0
	pkmn5.tera_type = :WATER
	pkmn5.dynamax_able = false
	pkmn5.calc_stats
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:OGERPON,100)
	pkmn6.item = :HEARTHFLAMEMASK
	pkmn6.nature = :JOLLY
	pkmn6.learn_move(:IVYCUDGEL)
	pkmn6.learn_move(:GRASSYGLIDE)
	pkmn6.learn_move(:SWORDSDANCE)
	pkmn6.learn_move(:SPIKYSHIELD)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.iv[:SPECIAL_ATTACK] = 0
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen7WaterPartyQuickStart100 # Poke Paste: https://pokepast.es/40b6bff80a7d28e3
	pkmn1 = Pokemon.new(:PRIMARINA,100)
	pkmn1.item = :CUSTAPBERRY
	pkmn1.ability_index = 4 # BATTLEBOND
	pkmn1.nature = :MODEST
	pkmn1.learn_move(:SPARKLYSWIRL)
	pkmn1.learn_move(:HYDROCANNON)
	pkmn1.learn_move(:ENCORE)
	pkmn1.learn_move(:CALMMIND)
	pkmn1.ev[:HP] = 76
	pkmn1.ev[:ATTACK] = 252
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 184
	pkmn1.tera_type = :STEEL
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:GLISCOR,100)
	pkmn2.item = :LEFTOVERS
	pkmn2.ability_index = 5 # PRANKSTER
	pkmn2.nature = :CAREFUL
	pkmn2.learn_move(:KNOCKOFF)
	pkmn2.learn_move(:POISONSTING)
	pkmn2.learn_move(:RAPIDSPIN)
	pkmn2.learn_move(:VENOMDRENCH)
	pkmn2.ev[:HP] = 248
	pkmn2.ev[:ATTACK] = 0
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 240
	pkmn2.ev[:SPEED] = 24
	pkmn2.tera_type = :FLYING
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:TINGLU,100)
	pkmn3.item = :ROCKYHELMET
	pkmn3.ability_index = 0 # VESSELOFRUIN
	pkmn3.nature = :CAREFUL
	pkmn3.learn_move(:STEALTHROCK)
	pkmn3.learn_move(:SPIKES)
	pkmn3.learn_move(:SANDATTACK)
	pkmn3.learn_move(:RUINATION)
	pkmn3.ev[:HP] = 248
	pkmn3.ev[:DEFENSE] = 16
	pkmn3.ev[:SPECIAL_DEFENSE] = 248
	pkmn3.ev[:SPEED] = 0
	pkmn3.tera_type = :WATER
	pkmn3.dynamax_able = false
	pkmn3.calc_stats
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:ZAPDOS,100)
	pkmn4.item = :HEAVYDUTYBOOTS
	pkmn4.ability_index = 0 # LIGHTNINGROD
	pkmn4.nature = :BOLD
	pkmn4.learn_move(:AEROBLAST)
	pkmn4.learn_move(:VOLTSWITCH)
	pkmn4.learn_move(:THUNDERWAVE)
	pkmn4.learn_move(:ROOST)
	pkmn4.ev[:HP] = 252
	pkmn4.ev[:ATTACK] = 0
	pkmn4.ev[:DEFENSE] = 244
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 16
	pkmn4.iv[:ATTACK] = 0
	pkmn4.tera_type = :DRAGON
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:GHOLDENGO,100)
	pkmn5.item = :SHUCABERRY
	pkmn5.ability_index = 4 # RATTLED
	pkmn5.nature = :MODEST
	pkmn5.learn_move(:SHADOWBALL)
	pkmn5.learn_move(:EGGBOMB)
	pkmn5.learn_move(:RECOVER)
	pkmn5.learn_move(:NASTYPLOT)
	pkmn5.ev[:HP] = 192
	pkmn5.ev[:ATTACK] = 152 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 16
	pkmn5.ev[:SPEED] = 152
	pkmn5.tera_type = :WATER
	pkmn5.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:DARKRAI,100)
	pkmn6.item = :LIFEORB
	pkmn6.nature = :TIMID
	pkmn6.learn_move(:BLOODMOON)
	pkmn6.learn_move(:MOONGEISTBEAM)
	pkmn6.learn_move(:SLUDGEBOMB)
	pkmn6.learn_move(:NASTYPLOT)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.iv[:ATTACK] = 0
	pkmn6.tera_type = :POISON
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen8GrassPartyQuickStart100 # Poke Paste: https://pokepast.es/8f4767c8ef7df026
	pkmn1 = Pokemon.new(:RILLABOOM,100)
	pkmn1.item = :CHOICEBAND
	pkmn1.ability_index = 0 # GRASSYSURGE
	pkmn1.nature = :ADAMANT
	pkmn1.learn_move(:WOODHAMMER)
	pkmn1.learn_move(:GRASSYGLIDE)
	pkmn1.learn_move(:UTURN)
	pkmn1.learn_move(:KNOCKOFF)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :GRASS
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:OGERPON,100)
	pkmn2.item = :CORNERSTONEMASK
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:IVYCUDGEL)
	pkmn2.learn_move(:POWERWHIP)
	pkmn2.learn_move(:SPIKES)
	pkmn2.learn_move(:TAUNT)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.iv[:SPECIAL_ATTACK] = 0
	pkmn2.dynamax_able = false
	pkmn2.calc_stats
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:RAGINGBOLT,100)
	pkmn3.item = :HONEY
	pkmn3.ability_index = 4 # INTIMIDATE
	pkmn3.nature = :MODEST
	pkmn3.learn_move(:THUNDERCLAP)
	pkmn3.learn_move(:HYPERBEAM)
	pkmn3.learn_move(:ANCIENTPOWER)
	pkmn3.learn_move(:CALMMIND)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn2.iv[:ATTACK] = 0
	pkmn3.tera_type = :WATER
	pkmn3.dynamax_able = false
	pkmn3.calc_stats
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:IRONMOTH,100)
	pkmn4.item = :PASSHOBERRY
	pkmn4.ability_index = 2 # LEVITATE
	pkmn4.nature = :TIMID
	pkmn4.learn_move(:QUIVERDANCE)
	pkmn4.learn_move(:SUBSTITUTE)
	pkmn4.learn_move(:EGGBOMB)
	pkmn4.learn_move(:EMBER)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 132
	pkmn4.ev[:DEFENSE] = 124
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :GHOST
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:IRONVALIANT,100)
	pkmn5.item = :BOOSTERENERGY
	pkmn5.ability_index = 0 # QUARKDRIVE
	pkmn5.nature = :JOLLY
	pkmn5.learn_move(:PLAYROUGH)
	pkmn5.learn_move(:COACHING)
	pkmn5.learn_move(:WIDEGUARD)
	pkmn5.learn_move(:ENCORE)
	pkmn5.ev[:HP] = 204
	pkmn5.ev[:ATTACK] = 4
	pkmn5.ev[:DEFENSE] = 100
	pkmn5.ev[:SPECIAL_DEFENSE] = 28
	pkmn5.ev[:SPEED] = 176
	pkmn5.tera_type = :ELECTRIC
	pkmn5.dynamax_able = false
	pkmn5.calc_stats
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:KINGAMBIT,100)
	pkmn6.item = :LUMBERRY
	pkmn6.nature = :JOLLY
	pkmn6.learn_move(:SWORDSDANCE)
	pkmn6.learn_move(:KOWTOWCLEAVE)
	pkmn6.learn_move(:SUCKERPUNCH)
	pkmn6.learn_move(:IRONHEAD)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.iv[:ATTACK] = 0
	pkmn6.tera_type = :DARK
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen8FirePartyQuickStart100 # Poke Paste: https://pokepast.es/999f4123b7a772e8
	pkmn1 = Pokemon.new(:CINDERACE,100)
	pkmn1.item = :GIGANTAITE
	pkmn1.ability_index = 4 # LIMBER
	pkmn1.nature = :JOLLY
	pkmn1.learn_move(:MEGAKICK)
	pkmn1.learn_move(:SUCKERPUNCH)
	pkmn1.learn_move(:UTURN)
	pkmn1.learn_move(:COURTCHANGE)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :WATER
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:SLOWKING_1,100)
	pkmn2.item = :HEAVYDUTYBOOTS
	pkmn2.ability_index = 4 # REGENERATOR
	pkmn2.nature = :RELAXED
	pkmn2.learn_move(:PSYCHICNOISE)
	pkmn2.learn_move(:EGGBOMB)
	pkmn2.learn_move(:ICEBEAM)
	pkmn2.learn_move(:UTURN)
	pkmn2.ev[:HP] = 252
	pkmn2.ev[:ATTACK] = 0
	pkmn2.ev[:DEFENSE] = 252
	pkmn2.ev[:SPECIAL_DEFENSE] = 8
	pkmn2.ev[:SPEED] = 0
	pkmn2.tera_type = :GRASS
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:TINGLU,100)
	pkmn3.item = :LEFTOVERS
	pkmn3.ability_index = 5 # ROCKYPAYLOAD
	pkmn3.nature = :CAREFUL
	pkmn3.learn_move(:REST)
	pkmn3.learn_move(:SPIKES)
	pkmn3.learn_move(:SANDATTACK)
	pkmn3.learn_move(:PAYPACK)
	pkmn3.ev[:HP] = 252
	pkmn3.ev[:DEFENSE] = 8
	pkmn3.ev[:SPECIAL_DEFENSE] = 252
	pkmn3.ev[:SPEED] = 0
	pkmn3.tera_type = :FAIRY
	pkmn3.dynamax_able = false
	pkmn3.calc_stats
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:CORVIKNIGHT,100)
	pkmn4.item = :ROCKYHELMET
	pkmn4.ability_index = 2 # PRESSURE
	pkmn4.nature = :IMPISH
	pkmn4.learn_move(:BODYPRESS)
	pkmn4.learn_move(:DEFOG)
	pkmn4.learn_move(:ROOST)
	pkmn4.learn_move(:UTURN)
	pkmn4.ev[:HP] = 252
	pkmn4.ev[:ATTACK] = 0
	pkmn4.ev[:DEFENSE] = 252
	pkmn4.ev[:SPECIAL_DEFENSE] = 8
	pkmn4.ev[:SPEED] = 0
	pkmn4.tera_type = :DRAGON
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:RAGINGBOLT,100)
	pkmn5.item = :CHOICESPECS
	pkmn5.ability_index = 4 # INTIMIDATE
	pkmn5.nature = :MODEST
	pkmn5.learn_move(:VOLTSWITCH)
	pkmn5.learn_move(:HYPERBEAM)
	pkmn5.learn_move(:THUNDERBOLT)
	pkmn5.learn_move(:THUNDERCLAP)
	pkmn5.ev[:HP] = 112
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 144
	pkmn5.iv[:ATTACK] = 0
	pkmn5.tera_type = :BUG
	pkmn5.dynamax_able = false
	pkmn5.calc_stats
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:OGERPON,100)
	pkmn6.item = :WELLSPRINGMASK
	pkmn6.nature = :JOLLY
	pkmn6.learn_move(:IVYCUDGEL)
	pkmn6.learn_move(:KNOCKOFF)
	pkmn6.learn_move(:UTURN)
	pkmn6.learn_move(:ENCORE)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.iv[:SPECIAL_ATTACK] = 0
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen8WaterPartyQuickStart100 # Poke Paste: https://pokepast.es/fa6099e03a99dbd5
	pkmn1 = Pokemon.new(:INTELEON,100)
	pkmn1.item = :SCOPELENS
	pkmn1.ability_index = 6 # SUPERLUCK
	pkmn1.nature = :TIMID
	pkmn1.learn_move(:SNIPESHOT)
	pkmn1.learn_move(:EGGBOMB)
	pkmn1.learn_move(:ICEBEAM)
	pkmn1.learn_move(:PROTECT)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :GROUND
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:MAUSHOLD,100)
	pkmn2.item = :FOCUSSASH
	pkmn2.ability_index = 4 # TECHNICIAN 
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:POPULATIONBOMB)
	pkmn2.learn_move(:FOLLOWME)
	pkmn2.learn_move(:PROTECT)
	pkmn2.learn_move(:TIDYUP)
	pkmn2.ev[:HP] = 4
	pkmn2.ev[:ATTACK] = 252
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :GHOST
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:GHOLDENGO,100)
	pkmn3.item = :LIFEORB
	pkmn3.ability_index = 0 # WONDERSKIN
	pkmn3.nature = :MODEST
	pkmn3.learn_move(:MAKEITRAIN)
	pkmn3.learn_move(:SHADOWBALL)
	pkmn3.learn_move(:NASTYPLOT)
	pkmn3.learn_move(:PROTECT)
	pkmn3.ev[:HP] = 252
	pkmn3.ev[:ATTACK] = 92
	pkmn3.ev[:DEFENSE] = 4
	pkmn3.ev[:SPECIAL_DEFENSE] = 44
	pkmn3.ev[:SPEED] = 120
	pkmn3.tera_type = :STEEL
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:INCINEROAR,100)
	pkmn4.item = :HONEY
	pkmn4.ability_index = 0 # INTIMIDATE
	pkmn4.nature = :CAREFUL
	pkmn4.learn_move(:FLAREBLITZ)
	pkmn4.learn_move(:KNOCKOFF)
	pkmn4.learn_move(:FAKEOUT)
	pkmn4.learn_move(:PARTINGSHOT)
	pkmn4.ev[:HP] = 248
	pkmn4.ev[:ATTACK] = 0
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 212
	pkmn4.ev[:SPEED] = 52
	pkmn4.tera_type = :WATER
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:RILLABOOM,100)
	pkmn5.item = :ASSAULTVEST
	pkmn5.ability_index = 0 # GRASSYSURGE
	pkmn5.nature = :ADAMANT
	pkmn5.learn_move(:WOODHAMMER)
	pkmn5.learn_move(:GRASSYGLIDE)
	pkmn5.learn_move(:FAKEOUT)
	pkmn5.learn_move(:UTURN)
	pkmn5.ev[:HP] = 204
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 52
	pkmn5.tera_type = :FIRE
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:SNEASLER,100)
	pkmn6.item = :GRASSYSEED
	pkmn6.ability_index = 0 # UNBURDEN
	pkmn6.nature = :JOLLY
	pkmn6.learn_move(:EGGBOMB)
	pkmn6.learn_move(:CLOSECOMBAT)
	pkmn6.learn_move(:POISONTAIL)
	pkmn6.learn_move(:FAKEOUT)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.tera_type = :FLYING
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen9GrassPartyQuickStart100 # Poke Paste: https://pokepast.es/9a7f780862533fde
	pkmn1 = Pokemon.new(:MEOWSCARADA,100)
	pkmn1.item = :FOCUSSASH
	pkmn1.ability_index = 6 # MAGICBOUNCE
	pkmn1.nature = :JOLLY
	pkmn1.learn_move(:KNOCKOFF)
	pkmn1.learn_move(:UTURN)
	pkmn1.learn_move(:TRIPLEAXEL)
	pkmn1.learn_move(:STEALTHROCK)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :GHOST
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:GLISCOR,100)
	pkmn2.item = :ROCKYHELMET
	pkmn2.ability_index = 3 # LEVITATE
	pkmn2.nature = :CAREFUL
	pkmn2.learn_move(:RAPIDSPIN)
	pkmn2.learn_move(:ROOST)
	pkmn2.learn_move(:SPIKES)
	pkmn2.learn_move(:POISONSTING)
	pkmn2.ev[:HP] = 248
	pkmn2.ev[:ATTACK] = 0
	pkmn2.ev[:DEFENSE] = 88
	pkmn2.ev[:SPECIAL_DEFENSE] = 176
	pkmn2.ev[:SPEED] = 0
	pkmn2.tera_type = :ELECTRIC
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:URSALUNA,100)
	pkmn3.item = :ASSAULTVEST
	pkmn3.ability_index = 6 # INTIMIDATE
	pkmn3.nature = :ADAMANT
	pkmn3.learn_move(:GIGAIMPACT)
	pkmn3.learn_move(:STOMPINGTANTRUM)
	pkmn3.learn_move(:AVALANCHE)
	pkmn3.learn_move(:DRAINPUNCH)
	pkmn3.ev[:HP] = 188
	pkmn3.ev[:ATTACK] = 56
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 208
	pkmn3.ev[:SPEED] = 60
	pkmn3.tera_type = :POISON
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:SKARMORY,100)
	pkmn4.item = :LEFTOVERS
	pkmn4.ability_index = 0 # BATTLEARMOR
	pkmn4.nature = :IMPISH
	pkmn4.learn_move(:BEAKBLAST)
	pkmn4.learn_move(:ROOST)
	pkmn4.learn_move(:WHIRLWIND)
	pkmn4.learn_move(:METALBURST)
	pkmn4.ev[:HP] = 244
	pkmn4.ev[:ATTACK] = 0
	pkmn4.ev[:DEFENSE] = 216
	pkmn4.ev[:SPECIAL_DEFENSE] = 44
	pkmn4.ev[:SPEED] = 8
	pkmn4.tera_type = :DRAGON
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:SLOWKING_1,100)
	pkmn5.item = :HEAVYDUTYBOOTS
	pkmn5.ability_index = 4 # REGENERATOR
	pkmn5.nature = :RELAXED
	pkmn5.learn_move(:PSYCHICNOISE)
	pkmn5.learn_move(:EGGBOMB)
	pkmn5.learn_move(:THUNDERWAVE)
	pkmn5.learn_move(:UTURN)
	pkmn5.ev[:HP] = 252
	pkmn5.ev[:ATTACK] = 0
	pkmn5.ev[:DEFENSE] = 8
	pkmn5.ev[:SPECIAL_DEFENSE] = 252
	pkmn5.ev[:SPEED] = 0
	pkmn5.tera_type = :WATER
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:DRAGAPULT,100)
	pkmn6.item = :LIFEORB
	pkmn6.ability_index = 6 # INFILTRATOR
	pkmn6.nature = :TIMID
	pkmn6.learn_move(:EGGBOMB)
	pkmn6.learn_move(:HEX)
	pkmn6.learn_move(:UTURN)
	pkmn6.learn_move(:WILLOWISP)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.tera_type = :FIRE
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen9FirePartyQuickStart100 # Poke Paste: https://pokepast.es/b8add99b4fadea57
	pkmn1 = Pokemon.new(:SKELEDIRGE,100)
	pkmn1.item = :HEAVYDUTYBOOTS
	pkmn1.ability_index = 0 # UNAWARE
	pkmn1.nature = :BOLD
	pkmn1.learn_move(:TORCHSONG)
	pkmn1.learn_move(:ALLURINGVOICE)
	pkmn1.learn_move(:WILLOWISP)
	pkmn1.learn_move(:SLACKOFF)
	pkmn1.ev[:HP] = 252
	pkmn1.ev[:ATTACK] = 0
	pkmn1.ev[:DEFENSE] = 16
	pkmn1.ev[:SPECIAL_DEFENSE] = 244
	pkmn1.ev[:SPEED] = 0
	pkmn1.tera_type = :FAIRY
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:IRONTREADS,100)
	pkmn2.item = :BOOSTERENERGY
	pkmn2.ability_index = 2 # STURDY
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:RAPIDSPIN)
	pkmn2.learn_move(:STEALTHROCK)
	pkmn2.learn_move(:HEADLONGRUSH)
	pkmn2.learn_move(:EGGBOMB)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :GRASS
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:ENAMORUS,100)
	pkmn3.item = :FOCUSSASH
	pkmn3.ability_index = 5 # QUEENLYMAJESTY
	pkmn3.nature = :MODEST
	pkmn3.learn_move(:MOONBLAST)
	pkmn3.learn_move(:EARTHPOWER)
	pkmn3.learn_move(:CALMMIND)
	pkmn3.learn_move(:TAUNT)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :GROUND
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:ROARINGMOON,100)
	pkmn4.item = :LIFEORB
	pkmn4.ability_index = 2 # INTIMIDATE
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:KNOCKOFF)
	pkmn4.learn_move(:PARTINGSHOT)
	pkmn4.learn_move(:DRAGONASCENT)
	pkmn4.learn_move(:IRONTAIL)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 220
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 36
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :STEEL
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:ZAMAZENTA,100)
	pkmn5.item = :RUSTEDSHIELD
	pkmn5.ability_index = 3 # BATTLEARMOR
	pkmn5.nature = :JOLLY
	pkmn5.learn_move(:BODYPRESS)
	pkmn5.learn_move(:CRUNCH)
	pkmn5.learn_move(:VICTORYDANCE)
	pkmn5.learn_move(:ROAR)
	pkmn5.ev[:HP] = 88
	pkmn5.iv[:ATTACK] = 0
	pkmn5.ev[:DEFENSE] = 252
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 172
	pkmn5.tera_type = :DRAGON
	pkmn5.dynamax_able = false
	pkmn5.calc_stats
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:OGERPON,100)
	pkmn6.item = :WELLSPRINGMASK
	pkmn6.nature = :JOLLY
	pkmn6.learn_move(:IVYCUDGEL)
	pkmn6.learn_move(:POWERWHIP)
	pkmn6.learn_move(:UTURN)
	pkmn6.learn_move(:ENCORE)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.iv[:SPECIAL_ATTACK] = 0
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen9WaterPartyQuickStart100 # Poke Paste: https://pokepast.es/2aaa84dab1d690bf
	pkmn1 = Pokemon.new(:QUAQUAVAL,100)
	pkmn1.item = :FOCUSSASH
	pkmn1.ability_index = 5 # DAZZLING
	pkmn1.nature = :JOLLY
	pkmn1.learn_move(:VICTORYDANCE)
	pkmn1.learn_move(:CLOSECOMAT)
	pkmn1.learn_move(:LIQUIDATION)
	pkmn1.learn_move(:ICESPINNER)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :STEEL
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:KINGDRA,100)
	pkmn2.item = :LIFEORB
	pkmn2.ability_index = 0 # SWIFTSWIM
	pkmn2.nature = :MODEST
	pkmn2.learn_move(:DRACOMETEOR)
	pkmn2.learn_move(:WEATHERBALL)
	pkmn2.learn_move(:MUDDYWATER)
	pkmn2.learn_move(:PROTECT)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :STELLAR
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:POLITOED,100)
	pkmn3.item = :HONEY
	pkmn3.ability_index = 4 # DRIZZLE
	pkmn3.nature = :BOLD
	pkmn3.learn_move(:WEATHERBALL)
	pkmn3.learn_move(:PERISHSONG)
	pkmn3.learn_move(:ENCORE)
	pkmn3.learn_move(:PROTECT)
	pkmn3.ev[:HP] = 256
	pkmn3.ev[:ATTACK] = 0
	pkmn3.ev[:DEFENSE] = 184
	pkmn3.ev[:SPECIAL_DEFENSE] = 72
	pkmn3.ev[:SPEED] = 0
	pkmn3.tera_type = :GRASS
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:GOTHITELLE,100)
	pkmn4.item = :LEFTOVERS
	pkmn4.ability_index = 3 # MAGICBOUNCE
	pkmn4.nature = :CALM
	pkmn4.learn_move(:PROTECT)
	pkmn4.learn_move(:PSYCHIC)
	pkmn4.learn_move(:FAKEOUT)
	pkmn4.learn_move(:TRICKROOM)
	pkmn4.ev[:HP] = 256
	pkmn4.ev[:DEFENSE] = 100
	pkmn4.ev[:SPECIAL_DEFENSE] = 156
	pkmn4.iv[:ATTACK] = 0
	pkmn4.tera_type = :DARK
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:INCINEROAR,100)
	pkmn5.item = :SAFETYGOGGLES
	pkmn5.ability_index = 0 # Intimidate
	pkmn5.nature = :CAREFUL
	pkmn5.learn_move(:FAKEOUT)
	pkmn5.learn_move(:PARTINGSHOT)
	pkmn5.learn_move(:KNOCKOFF)
	pkmn5.learn_move(:PROTECT)
	pkmn5.ev[:HP] = 244
	pkmn5.ev[:ATTACK] = 4
	pkmn5.ev[:DEFENSE] = 132
	pkmn5.ev[:SPECIAL_DEFENSE] = 84
	pkmn5.ev[:SPEED] = 48
	pkmn5.tera_type = :GHOST
	pkmn5.dynamax_able = false
	pkmn5.calc_stats
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:AMOONGUSS,100)
	pkmn6.item = :MENTALHERB
	pkmn6.ability_index = 3 # Regenerator
	pkmn6.nature = :BOLD
	pkmn6.learn_move(:PROTECT)
	pkmn6.learn_move(:RAGEPOWDER)
	pkmn6.learn_move(:SPORE)
	pkmn6.learn_move(:POLLENPUFF)
	pkmn6.ev[:HP] = 240
	pkmn6.ev[:DEFENSE] = 236
	pkmn6.ev[:SPECIAL_DEFENSE] = 36
	pkmn6.iv[:SPEED] = 0
	pkmn6.tera_type = :FAIRY
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen9FightingPartyQuickStart100 # Poke Paste: https://pokepast.es/74e2807d6251ac7c
	pkmn1 = Pokemon.new(:DECIDUEYE_1,100)
	pkmn1.item = :SCOPELENS
	pkmn1.ability_index = 3 # SCRAPPY
	pkmn1.nature = :JOLLY
	pkmn1.learn_move(:LEAFBLADE)
	pkmn1.learn_move(:TRIPLEARROWS)
	pkmn1.learn_move(:HAZE)
	pkmn1.learn_move(:PROTECT)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :FIRE
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:DRAGAPULT,100)
	pkmn2.item = :CHOICEBAND
	pkmn2.ability_index = 0 # PARENTALBOND
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:DRAGONDARTS)
	pkmn2.learn_move(:SHADOWFORCE)
	pkmn2.learn_move(:UTURN)
	pkmn2.learn_move(:PSYCHICFANGS)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :DRAGON
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:VOLCARONA,100)
	pkmn3.item = :HONEY
	pkmn3.ability_index = 0 # LEVITATE
	pkmn3.nature = :TIMID
	pkmn3.learn_move(:EMBER)
	pkmn3.learn_move(:GIGADRAIN)
	pkmn3.learn_move(:QUIVERDANCE)
	pkmn3.learn_move(:PROTECT)
	pkmn3.ev[:HP] = 248
	pkmn3.ev[:ATTACK] = 12
	pkmn3.ev[:DEFENSE] = 92
	pkmn3.ev[:SPECIAL_DEFENSE] = 28
	pkmn3.ev[:SPEED] = 132
	pkmn3.tera_type = :GRASS
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:HATTERENE,100)
	pkmn4.item = :LIFEORB
	pkmn4.ability_index = 0 # MAGICBOUNCE
	pkmn4.nature = :QUIET
	pkmn4.learn_move(:EXPANDINGFORCE)
	pkmn4.learn_move(:DAZZLINGGLEAM)
	pkmn4.learn_move(:TRICKROOM)
	pkmn4.learn_move(:PROTECT)
	pkmn4.ev[:HP] = 216
	pkmn4.ev[:ATTACK] = 204
	pkmn4.ev[:DEFENSE] = 68
	pkmn4.ev[:SPECIAL_DEFENSE] = 24
	pkmn4.iv[:ATTACK] = 0
	pkmn4.iv[:SPEED] = 0
	pkmn4.tera_type = :PSYCHIC
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:TYRANITAR,100)
	pkmn5.item = :ASSAULTVEST
	pkmn5.ability_index = 2 # SHEERFORCE
	pkmn5.nature = :SASSY
	pkmn5.learn_move(:ROCKSLIDE)
	pkmn5.learn_move(:KNOCKOFF)
	pkmn5.learn_move(:EGGBOMB)
	pkmn5.learn_move(:STRENGTH)
	pkmn5.ev[:HP] = 140
	pkmn5.ev[:ATTACK] = 252
	pkmn5.ev[:DEFENSE] = 4
	pkmn5.ev[:SPECIAL_DEFENSE] = 4
	pkmn5.ev[:SPEED] = 112
	pkmn5.tera_type = :FLYING
	pkmn5.dynamax_able = false
	pkmn5.calc_stats
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:INDEEDEE,100)
	pkmn6.makeMale # Only done for Male Indeede, to make sure the correct form sprite is used
	pkmn6.item = :LUMBERRY
	pkmn6.ability_index = 0 # PSYCHICSURGE
	pkmn6.nature = :RELAXED
	pkmn6.learn_move(:PSYCHIC)
	pkmn6.learn_move(:FOLLOWME)
	pkmn6.learn_move(:TRICKROOM)
	pkmn6.learn_move(:HELPINGHAND)
	pkmn6.ev[:HP] = 256
	pkmn6.ev[:ATTACK] = 0 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn6.ev[:DEFENSE] = 256
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :FAIRY
	pkmn6.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen9GhostPartyQuickStart100 # Poke Paste: https://pokepast.es/d0e936b567d7f639
	pkmn1 = Pokemon.new(:TYPHLOSION_1,100)
	pkmn1.item = :CHOICESCARF
	pkmn1.ability_index = 0 # SOULHEART
	pkmn1.nature = :TIMID
	pkmn1.learn_move(:OVERHEAT)
	pkmn1.learn_move(:ERUPTION)
	pkmn1.learn_move(:SHADOWBALL)
	pkmn1.learn_move(:HEATWAVE)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :FIRE
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:WEEZING_1,100)
	pkmn2.item = :CHOICESPECS
	pkmn2.ability_index = 2 # NEUTRALIZINGGAS
	pkmn2.nature = :MODEST
	pkmn2.learn_move(:EGGBOMB)
	pkmn2.learn_move(:STRANGESTEAM)
	pkmn2.learn_move(:DAZZLINGGLEAM)
	pkmn2.learn_move(:FLAMETHROWER)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :FLYING
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:GARCHOMP,100)
	pkmn3.item = :LIFEORB
	pkmn3.ability_index = 6 # HYPERCUTTER
	pkmn3.nature = :JOLLY
	pkmn3.learn_move(:PROTECT)
	pkmn3.learn_move(:SLASH)
	pkmn3.learn_move(:DRAGONCLAW)
	pkmn3.learn_move(:IRONTAIL)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :FIRE
	pkmn3.dynamax_able = false
	pkmn3.calc_stats
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:CORVIKNIGHT,100)
	pkmn4.item = :HONEY
	pkmn4.ability_index = 4 # MIRRORARMOR
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:DOUBLEEDGE)
	pkmn4.learn_move(:TAILWIND)
	pkmn4.learn_move(:ROOST)
	pkmn4.learn_move(:BULKUP)
	pkmn4.ev[:HP] = 252
	pkmn4.ev[:ATTACK] = 0
	pkmn4.ev[:DEFENSE] = 44
	pkmn4.ev[:SPECIAL_DEFENSE] = 144
	pkmn4.ev[:SPEED] = 72
	pkmn4.tera_type = :DRAGON
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:TOEDSCRUEL,100)
	pkmn5.item = :COVERTCLOAK
	pkmn5.ability_index = 5 # LONGREACH
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:EGGBOMB)
	pkmn5.learn_move(:ACIDSPRAY)
	pkmn5.learn_move(:STUNSPORE)
	pkmn5.learn_move(:RAGEPOWER)
	pkmn5.ev[:HP] = 180
	pkmn5.ev[:ATTACK] = 12
	pkmn5.ev[:DEFENSE] = 64
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :WATER
	pkmn5.dynamax_able = false
	pkmn5.calc_stats
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:BAXCALIBUR,100)
	pkmn6.item = :LOADEDDICE
	pkmn6.ability_index = 0 # THERMALEXCHANGE
	pkmn6.nature = :ADAMANT
	pkmn6.learn_move(:ICICLESPEAR)
	pkmn6.learn_move(:SCALESHOT)
	pkmn6.learn_move(:SWORDSDANCE)
	pkmn6.learn_move(:PROTECT)
	pkmn6.ev[:HP] = 256
	pkmn6.ev[:ATTACK] = 0 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.tera_type = :FAIRY
	pkmn6.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedGen9DarkPartyQuickStart100 # Poke Paste: https://pokepast.es/73c40bd837c0a2f0
	pkmn1 = Pokemon.new(:SAMUROTT_1,100)
	pkmn1.item = :ASSAULTVEST
	pkmn1.ability_index = 4 # SHARPNESS
	pkmn1.nature = :ADAMANT
	pkmn1.learn_move(:SLASH)
	pkmn1.learn_move(:RAZORSHELL)
	pkmn1.learn_move(:AQUAJET)
	pkmn1.learn_move(:CEASELESSEDGE)
	pkmn1.ev[:HP] = 248
	pkmn1.ev[:ATTACK] = 84
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 124
	pkmn1.ev[:SPEED] = 56
	pkmn1.tera_type = :FIRE
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:ZAMAZENTA,100)
	pkmn2.item = :RUSTEDSHIELD
	pkmn2.ability_index = 3 # BATTLEARMOR
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:BODYPRESS)
	pkmn2.learn_move(:STONEEDGE)
	pkmn2.learn_move(:VICTORYDANCE)
	pkmn2.learn_move(:IRONHEAD)
	pkmn2.ev[:HP] = 0
	pkmn2.iv[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :DRAGON
	pkmn2.dynamax_able = false
	pkmn2.calc_stats
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:CLEFABLE,100)
	pkmn3.item = :STICKYBARB
	pkmn3.ability_index = 2 # MAGICGUARD
	pkmn3.nature = :BOLD
	pkmn3.learn_move(:CALMMIND)
	pkmn3.learn_move(:FLAMETHROWER)
	pkmn3.learn_move(:MOONBLAST)
	pkmn3.learn_move(:MOONLIGHT)
	pkmn3.ev[:HP] = 252
	pkmn3.ev[:ATTACK] = 0
	pkmn3.ev[:DEFENSE] = 240
	pkmn3.ev[:SPECIAL_DEFENSE] = 8
	pkmn3.ev[:SPEED] = 20
	pkmn3.tera_type = :BUG
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:LANDORUS_1,100)
	pkmn4.item = :FOCUSSASH
	pkmn4.ability_index = 4 # INTIMIDATE
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:STEALTHROCK)
	pkmn4.learn_move(:EARTHQUAKE)
	pkmn4.learn_move(:SMACKDOWN)
	pkmn4.learn_move(:UTURN)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :GROUND
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:ROTOM_2,100)
	pkmn5.item = :COVERTCLOAK
	pkmn5.ability_index = 6 # SCREENCLEANER
	pkmn5.nature = :BOLD
	pkmn5.learn_move(:VOLTSWITCH)
	pkmn5.learn_move(:HYDROPUMP)
	pkmn5.learn_move(:SOAK)
	pkmn5.learn_move(:THUNDERWAVE)
	pkmn5.ev[:HP] = 256
	pkmn5.ev[:ATTACK] = 0
	pkmn5.ev[:DEFENSE] = 212
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 44
	pkmn5.tera_type = :FLYING
	pkmn5.dynamax_able = false
	pkmn5.calc_stats
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:DRAGAPULT,100)
	pkmn6.item = :HEAVYDUTYBOOTS
	pkmn6.ability_index = 6 # INFILTRATOR
	pkmn6.nature = :NAIVE
	pkmn6.learn_move(:DRAGONDARTS)
	pkmn6.learn_move(:HEX)
	pkmn6.learn_move(:WILLOWISP)
	pkmn6.learn_move(:UTURN)
	pkmn6.ev[:HP] = 60
	pkmn6.ev[:ATTACK] = 196
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.tera_type = :FAIRY
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoNormalPartyQuickStart100 # Poke Paste: https://pokepast.es/ac1b444e8fc174a9
	pkmn1 = Pokemon.new(:PIDGEOT,100)
	pkmn1.item = :HEAVYDUTYBOOTS
	pkmn1.ability_index = 3 # PICKUP
	pkmn1.nature = :IMPISH
	pkmn1.learn_move(:BRAVEBIRD)
	pkmn1.learn_move(:DEFOG)
	pkmn1.learn_move(:ROOST)
	pkmn1.learn_move(:UTURN)
	pkmn1.ev[:HP] = 252
	pkmn1.ev[:ATTACK] = 0
	pkmn1.ev[:DEFENSE] = 240
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 20
	pkmn1.tera_type = :FIGHTING
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:DITTO,100)
	pkmn2.item = :CHOICESCARF
	pkmn2.ability_index = 4 # IMPOSTER
	pkmn2.nature = :RELAXED
	pkmn2.learn_move(:TRANSFORM)
	pkmn2.ev[:HP] = 252
	pkmn2.iv[:ATTACK] = 8
	pkmn2.ev[:DEFENSE] = 252
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 0
	pkmn2.tera_type = :FAIRY
	pkmn2.dynamax_able = false
	pkmn2.calc_stats
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:TERAPAGOS,100)
	pkmn3.item = :WHITEHERB
	pkmn3.nature = :MODEST
	pkmn3.learn_move(:NORETREAT)
	pkmn3.learn_move(:SHELLSMASH)
	pkmn3.learn_move(:TAUNT)
	pkmn3.learn_move(:TERASTARSTORM)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:URSALUNA,100)
	pkmn4.item = :FLAMEORB
	pkmn4.ability_index = 0 # GUTS
	pkmn4.nature = :ADAMANT
	pkmn4.learn_move(:FACADE)
	pkmn4.learn_move(:HEADLONGRUSH)
	pkmn4.learn_move(:FIREPUNCH)
	pkmn4.learn_move(:SWORDSDANCE)
	pkmn4.ev[:HP] = 252
	pkmn4.ev[:ATTACK] = 252
	pkmn4.ev[:DEFENSE] = 8
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 0
	pkmn4.tera_type = :POISON
	pkmn4.dynamax_able = false
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:ZOROARK_1,100)
	pkmn5.item = :CHOICESPECS
	pkmn5.ability_index = 6 # INTIMIDATE
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:TRICK)
	pkmn5.learn_move(:MOONGEISTBEAM)
	pkmn5.learn_move(:HYPERBEAM)
	pkmn5.learn_move(:FOCUSBLAST)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :FAIRY
	pkmn5.dynamax_able = false
	pkmn5.calc_stats
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:BLISSEY,100)
	pkmn6.item = :LEFTOVERS
	pkmn6.ability_index = 3 # SCRAPPY
	pkmn6.nature = :BOLD
	pkmn6.learn_move(:SEISMICTOSS)
	pkmn6.learn_move(:SOFTBOILED)
	pkmn6.learn_move(:STEALTHROCK)
	pkmn6.learn_move(:THUNDERWAVE)
	pkmn6.ev[:HP] = 252
	pkmn6.ev[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 256
	pkmn6.ev[:SPECIAL_DEFENSE] = 4
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :GHOST
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoFightingPartyQuickStart100 # Poke Paste: https://pokepast.es/698aaabeafee46e1
	pkmn1 = Pokemon.new(:IRONVALIANT,100)
	pkmn1.item = :CHOICESCARF
	pkmn1.ability_index = 3 # SYNCHRONIZE
	pkmn1.nature = :NAIVE
	pkmn1.learn_move(:EGGBOMB)
	pkmn1.learn_move(:CLOSECOMAT)
	pkmn1.learn_move(:THUNDERBOLT)
	pkmn1.learn_move(:TRICK)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :GHOST
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:GREATTUSK,100)
	pkmn2.item = :ROCKYHELMET
	pkmn2.ability_index = 4 # THICKFAT 
	pkmn2.nature = :IMPISH
	pkmn2.learn_move(:EARTHQUAKE)
	pkmn2.learn_move(:VICTORYDANCE)
	pkmn2.learn_move(:KNOCKOFF)
	pkmn2.learn_move(:STEALTHROCK)
	pkmn2.ev[:HP] = 256
	pkmn2.ev[:ATTACK] = 0
	pkmn2.ev[:DEFENSE] = 156
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 100
	pkmn2.tera_type = :POISON
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:SCRAFTY,100)
	pkmn3.item = :LEFTOVERS
	pkmn3.ability_index = 2 # SHEDSKIN
	pkmn3.nature = :CAREFUL
	pkmn3.learn_move(:VICTORYDANCE)
	pkmn3.learn_move(:DRAINPUNCH)
	pkmn3.learn_move(:KNOCKOFF)
	pkmn3.learn_move(:REST)
	pkmn3.ev[:HP] = 252
	pkmn3.ev[:ATTACK] = 0
	pkmn3.ev[:DEFENSE] = 240
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 20
	pkmn3.tera_type = :FIGHTING
	pkmn3.dynamax_able = false
	pkmn3.calc_stats
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:IRONHANDS,100)
	pkmn4.item = :ASSAULTVEST
	pkmn4.ability_index = 2 # STEELWORKER
	pkmn4.nature = :CAREFUL
	pkmn4.learn_move(:DRAINPUNCH)
	pkmn4.learn_move(:ICEPUNCH)
	pkmn4.learn_move(:HEAVYSLAM)
	pkmn4.learn_move(:THUNDERPUNCH)
	pkmn4.ev[:HP] = 256
	pkmn4.ev[:ATTACK] = 4
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 252
	pkmn4.tera_type = :BUG
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:URSHIFU_1,100)
	pkmn5.item = :PUNCHINGGLOVE
	pkmn5.ability_index = 5 # TECHNICIAN
	pkmn5.nature = :JOLLY
	pkmn5.learn_move(:SURGINGSTRIKES)
	pkmn5.learn_move(:AQUAJET)
	pkmn5.learn_move(:VICTORYDANCE)
	pkmn5.learn_move(:TECHPOWERICE)
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.iv[:SPECIAL_ATTACK] = 0
	pkmn5.tera_type = :STELLAR
	pkmn5.dynamax_able = false
	pkmn5.calc_stats
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:SNEASLER,100)
	pkmn6.item = :AIRBALLOON
	pkmn6.ability_index = 0 # UNBURDEN
	pkmn6.nature = :ADAMANT
	pkmn6.learn_move(:EGGBOMB)
	pkmn6.learn_move(:CLOSECOMBAT)
	pkmn6.learn_move(:POISONTAIL)
	pkmn6.learn_move(:PROTECT)
	pkmn6.ev[:HP] = 144
	pkmn6.ev[:ATTACK] = 252
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 116
	pkmn6.tera_type = :DARK
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoFlyingPartyQuickStart100 # Poke Paste: https://pokepast.es/cb82e72f29563467
	pkmn1 = Pokemon.new(:SKARMORY,100)
	pkmn1.item = :ROCKYHELMET
	pkmn1.ability_index = 0 # BATTLEARMOR
	pkmn1.nature = :BOLD
	pkmn1.learn_move(:ROOST)
	pkmn1.learn_move(:IRONDEFENSE)
	pkmn1.learn_move(:WHIRLWIND)
	pkmn1.learn_move(:BODYPRESS)
	pkmn1.ev[:HP] = 256
	pkmn1.ev[:ATTACK] = 0
	pkmn1.ev[:DEFENSE] = 252
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 4
	pkmn1.tera_type = :GROUND
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:DRAGONITE,100)
	pkmn2.item = :CHOICEBAND
	pkmn2.ability_index = 0 # MULTISCALE 
	pkmn2.nature = :ADAMANT
	pkmn2.learn_move(:DRAGONASCENT)
	pkmn2.learn_move(:EXTREMESPEED)
	pkmn2.learn_move(:FIREPUNCH)
	pkmn2.learn_move(:EARTHQUAKE)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :FIGHTING
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:DODRIO,100)
	pkmn3.item = :LIFEORB
	pkmn3.ability_index = 5 # BIGPECKS
	pkmn3.nature = :JOLLY
	pkmn3.learn_move(:DOUBLEEDGE)
	pkmn3.learn_move(:SKYATTACK)
	pkmn3.learn_move(:KNOCKOFF)
	pkmn3.learn_move(:JUMPKICK)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :FIRE
	pkmn3.dynamax_able = false
	pkmn3.calc_stats
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:CORVIKNIGHT,100)
	pkmn4.item = :LEFTOVERS
	pkmn4.ability_index = 4 # MIRRORARMOR
	pkmn4.nature = :CAREFUL
	pkmn4.learn_move(:STEELWING)
	pkmn4.learn_move(:UTURN)
	pkmn4.learn_move(:DEFOG)
	pkmn4.learn_move(:ROOST)
	pkmn4.ev[:HP] = 252
	pkmn4.ev[:ATTACK] = 12
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 248
	pkmn4.tera_type = :DRAGON
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:TORNADUS_1,100)
	pkmn5.item = :ASSAULTVEST
	pkmn5.ability_index = 3 # REGENERATOR
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:UTURN)
	pkmn5.learn_move(:KNOCKOFF)
	pkmn5.learn_move(:AEROBLAST)
	pkmn5.learn_move(:HEATWAVE)
	pkmn5.ev[:HP] = 248
	pkmn5.ev[:ATTACK] = 0
	pkmn5.ev[:DEFENSE] = 12
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 252
	pkmn5.tera_type = :FLYING
	pkmn5.dynamax_able = false
	pkmn5.calc_stats
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:LANDORUS_1,100)
	pkmn6.item = :CHOICESCARF
	pkmn6.ability_index = 4 # INTIMIDATE
	pkmn6.nature = :JOLLY
	pkmn6.learn_move(:EARTHQUAKE)
	pkmn6.learn_move(:STONEEDGE)
	pkmn6.learn_move(:UTURN)
	pkmn6.learn_move(:STEALTHROCK)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.tera_type = :STEEL
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoPoisonPartyQuickStart100 # Poke Paste: https://pokepast.es/068863a5eb35a63c
	pkmn1 = Pokemon.new(:MUK_1,100)
	pkmn1.item = :BLACKSLUDGE
	pkmn1.ability_index = 0 # POISONTOUCH
	pkmn1.nature = :CAREFUL
	pkmn1.learn_move(:KNOCKOFF)
	pkmn1.learn_move(:DRAINPUNCH)
	pkmn1.learn_move(:POISONJAB)
	pkmn1.learn_move(:PROTECT)
	pkmn1.ev[:HP] = 256
	pkmn1.ev[:ATTACK] = 4
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 252
	pkmn1.ev[:SPEED] = 0
	pkmn1.tera_type = :POISON
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:SNEASLER,100)
	pkmn2.item = :AIRBALLOON
	pkmn2.ability_index = 0 # UNBURDEN
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:SWORDSDANCE)
	pkmn2.learn_move(:CLOSECOMBAT)
	pkmn2.learn_move(:EGGBOMB)
	pkmn2.learn_move(:ACROBATICS)
	pkmn2.ev[:HP] = 80
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 176
	pkmn2.tera_type = :DARK
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:SLOWKING_1,100)
	pkmn3.item = :ASSAULTVEST
	pkmn3.ability_index = 4 # REGENERATOR
	pkmn3.nature = :SASSY
	pkmn3.learn_move(:FUTURESIGHT)
	pkmn3.learn_move(:SLUDGEBOMB)
	pkmn3.learn_move(:ICEBEAM)
	pkmn3.learn_move(:FLAMETHROWER)
	pkmn3.ev[:HP] = 256
	pkmn3.ev[:ATTACK] = 60
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 196
	pkmn3.ev[:SPEED] = 0
	pkmn3.tera_type = :FLYING
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:CLODSIRE,100)
	pkmn4.item = :HEAVYDUTYBOOTS
	pkmn4.ability_index = 0 # UNAWARE
	pkmn4.nature = :IMPISH
	pkmn4.learn_move(:STEALTHROCK)
	pkmn4.learn_move(:RAPIDSPIN)
	pkmn4.learn_move(:TOXIC)
	pkmn4.learn_move(:RECOVER)
	pkmn4.ev[:HP] = 256
	pkmn4.ev[:ATTACK] = 0 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn4.ev[:DEFENSE] = 232
	pkmn4.ev[:SPECIAL_DEFENSE] = 24
	pkmn4.ev[:SPEED] = 0
	pkmn4.tera_type = :ICE
	pkmn4.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:IRONMOTH,100)
	pkmn5.item = :CHOICESPECS
	pkmn5.ability_index = 4 # SHADOWSHIELD
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:EGGBOMB)
	pkmn5.learn_move(:OVERHEAT)
	pkmn5.learn_move(:ENERGYBALL)
	pkmn5.learn_move(:THUNDERBOLT)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :FIRE
	pkmn5.dynamax_able = false
	pkmn5.calc_stats
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:WEEZING_1,100)
	pkmn6.item = :POWERHERB
	pkmn6.ability_index = 0 # LEVITATE
	pkmn6.nature = :BOLD
	pkmn6.learn_move(:GEOMANCY)
	pkmn6.learn_move(:DEFOG)
	pkmn6.learn_move(:WILLOWISP)
	pkmn6.learn_move(:MOONBLAST)
	pkmn6.ev[:HP] = 252
	pkmn6.ev[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 252
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 8
	pkmn6.tera_type = :ELECTRIC
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoGroundPartyQuickStart100 # Poke Paste: https://pokepast.es/0862ad1d0d311051
	pkmn1 = Pokemon.new(:HIPPOWDON,100)
	pkmn1.item = :EJECTBUTTON
	pkmn1.ability_index = 2 # SANDSTREAM
	pkmn1.nature = :IMPISH
	pkmn1.learn_move(:EARTHQUAKE)
	pkmn1.learn_move(:SLACKOFF)
	pkmn1.learn_move(:STEALTHROCK)
	pkmn1.learn_move(:WHIRLWIND)
	pkmn1.ev[:HP] = 256
	pkmn1.ev[:ATTACK] = 0
	pkmn1.ev[:DEFENSE] = 256
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 0
	pkmn1.tera_type = :POISON
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:EXCADRILL,100)
	pkmn2.item = :ASSAULTVEST
	pkmn2.ability_index = 2 # SANDFORCE
	pkmn2.nature = :ADAMANT
	pkmn2.learn_move(:RAPIDSPIN)
	pkmn2.learn_move(:EARTHQUAKE)
	pkmn2.learn_move(:ROCKCLIMB)
	pkmn2.learn_move(:SHADOWCLAW)
	pkmn2.ev[:HP] = 80
	pkmn2.ev[:ATTACK] = 176
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :FAIRY
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:LANDORUS,100)
	pkmn3.item = :LIFEORB
	pkmn3.ability_index = 2 # SHEERFORCE
	pkmn3.nature = :TIMID
	pkmn3.learn_move(:EARTHPOWER)
	pkmn3.learn_move(:FOCUSBLAST)
	pkmn3.learn_move(:PSYCHIC)
	pkmn3.learn_move(:GRAVITY)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :ICE
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:MAMOSWINE,100)
	pkmn4.item = :CHOICEBAND
	pkmn4.ability_index = 4 # SANDRUSH
	pkmn4.nature = :ADAMANT
	pkmn4.learn_move(:EGGBOMB)
	pkmn4.learn_move(:HEADLONGRUSH)
	pkmn4.learn_move(:ICESHARD)
	pkmn4.learn_move(:KNOCKOFF)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :FIRE
	pkmn4.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:CLODSIRE,100)
	pkmn5.item = :HEAVYDUTYBOOTS
	pkmn5.ability_index = 3 # WATERABSORB
	pkmn5.nature = :CAREFUL
	pkmn5.learn_move(:STEALTHROCK)
	pkmn5.learn_move(:SANDATTACK)
	pkmn5.learn_move(:MORTALSPIN)
	pkmn5.learn_move(:RECOVER)
	pkmn5.ev[:HP] = 252
	pkmn5.ev[:ATTACK] = 8 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 252
	pkmn5.ev[:SPEED] = 0
	pkmn5.tera_type = :DARK
	pkmn5.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:SANDYSHOCKS,100)
	pkmn6.item = :WEAKNESSPOLICY
	pkmn6.ability_index = 6 # FILTER
	pkmn6.nature = :TIMID
	pkmn6.learn_move(:EGGBOMB)
	pkmn6.learn_move(:THUNDERCLAP)
	pkmn6.learn_move(:GRAVITY)
	pkmn6.learn_move(:VOLTSWITCH)
	pkmn6.ev[:HP] = 52
	pkmn6.ev[:ATTACK] = 208
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 252
	pkmn6.tera_type = :ELECTRIC
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoRockPartyQuickStart100 # Poke Paste: https://pokepast.es/173aac7252c7b758
	pkmn1 = Pokemon.new(:IRONBOULDER,100)
	pkmn1.item = :CHOICESCARF
	pkmn1.ability_index = 2 # SHARPNESS
	pkmn1.nature = :JOLLY
	pkmn1.learn_move(:MIGHTYCLEAVE)
	pkmn1.learn_move(:PSYCHOCUT)
	pkmn1.learn_move(:SACREDSWORD)
	pkmn1.learn_move(:SLASH)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :FIRE
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:ARCANINE_1,100)
	pkmn2.item = :HEAVYDUTYBOOTS
	pkmn2.ability_index = 3 # ROCKHEAD
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:FLAREBLITZ)
	pkmn2.learn_move(:HEADSMASH)
	pkmn2.learn_move(:CLOSECOMAT)
	pkmn2.learn_move(:SUBSTITUTE)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :ROCK
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:GLIMMORA,100)
	pkmn3.item = :CHOICESPECS
	pkmn3.ability_index = 4 # LEVITATE
	pkmn3.nature = :TIMID
	pkmn3.learn_move(:HYPERBEAM)
	pkmn3.learn_move(:SLUDGEBOMB)
	pkmn3.learn_move(:ENERGYBALL)
	pkmn3.learn_move(:EARTHPOWER)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :ELECTRIC
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:MINIOR,100)
	pkmn4.item = :WHITEHERB
	pkmn4.ability_index = 0 # SHIELDSDOWN
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:EGGBOMB)
	pkmn4.learn_move(:STONEEDGE)
	pkmn4.learn_move(:EARTHQUAKE)
	pkmn4.learn_move(:SHELLSMASH)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :WATER
	pkmn4.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn4.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:GARGANACL,100)
	pkmn5.item = :LEFTOVERS
	pkmn5.ability_index = 0 # ROUGHSKIN
	pkmn5.nature = :CAREFUL
	pkmn5.learn_move(:STEALTHROCK)
	pkmn5.learn_move(:PROTECT)
	pkmn5.learn_move(:RECOVER)
	pkmn5.learn_move(:SALTCURE)
	pkmn5.ev[:HP] = 256
	pkmn5.ev[:ATTACK] = 0 # The EV Allocator Overhaul Plugin fuses Attack and Sp.Attack EV's into one. Change just Attack to affect both Sp.Atk and Attack
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 256
	pkmn5.ev[:SPEED] = 0
	pkmn5.tera_type = :GHOST
	pkmn5.dynamax_able = false # This is only done so players not used to Dynamax don't get confused when Dynamax activates first over Tera
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:OGERPON,100)
	pkmn6.item = :CORNERSTONEMASK
	pkmn6.nature = :JOLLY
	pkmn6.learn_move(:IVYCUDGEL)
	pkmn6.learn_move(:HORNLEECH)
	pkmn6.learn_move(:SWORDSDANCE)
	pkmn6.learn_move(:SUPERPOWER)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.iv[:SPECIAL_ATTACK] = 0
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoBugPartyQuickStart100 # Poke Paste: https://pokepast.es/0a6ff83acecfc3b9
	pkmn1 = Pokemon.new(:VOLCARONA,100)
	pkmn1.item = :LEFTOVERS
	pkmn1.ability_index = 5 # FLASHFIRE
	pkmn1.nature = :TIMID
	pkmn1.learn_move(:QUIVERDANCE)
	pkmn1.learn_move(:EMBER)
	pkmn1.learn_move(:MORNINGSUN)
	pkmn1.learn_move(:PSYCHIC)
	pkmn1.ev[:HP] = 256
	pkmn1.ev[:ATTACK] = 28
	pkmn1.ev[:DEFENSE] = 176
	pkmn1.ev[:SPECIAL_DEFENSE] = 52
	pkmn1.ev[:SPEED] = 0
	pkmn1.tera_type = :POISON
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:FORRETRESS,100)
	pkmn2.item = :ROCKYHELMET
	pkmn2.ability_index = 6 # BATTLEARMOR
	pkmn2.nature = :IMPISH
	pkmn2.learn_move(:THUNDERWAVE)
	pkmn2.learn_move(:VOLTSWITCH)
	pkmn2.learn_move(:RAPIDSPIN)
	pkmn2.learn_move(:ICESPINNER)
	pkmn2.ev[:HP] = 256
	pkmn2.ev[:ATTACK] = 0
	pkmn2.ev[:DEFENSE] = 256
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 0
	pkmn2.tera_type = :ROCK
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:SCIZOR,100)
	pkmn3.item = :MEGAITE
	pkmn3.ability_index = 4 # INTIMIDATE
	pkmn3.nature = :ADAMANT
	pkmn3.learn_move(:SWORDSDANCE)
	pkmn3.learn_move(:BULLETPUNCH)
	pkmn3.learn_move(:KNOCKOFF)
	pkmn3.learn_move(:TRAILBLAZE)
	pkmn3.ev[:HP] = 124
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 132
	pkmn3.tera_type = :FIRE
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:KLEAVOR,100)
	pkmn4.item = :CHOICESCARF
	pkmn4.ability_index = 2 # SHARPNESS
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:STONEAXE)
	pkmn4.learn_move(:UTURN)
	pkmn4.learn_move(:NIGHTSLASH)
	pkmn4.learn_move(:SLASH)
	pkmn4.ev[:HP] = 256
	pkmn4.ev[:ATTACK] = 28
	pkmn4.ev[:DEFENSE] = 176
	pkmn4.ev[:SPECIAL_DEFENSE] = 52
	pkmn4.ev[:SPEED] = 0
	pkmn4.tera_type = :FIGHTING
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:YANMEGA,100)
	pkmn5.item = :CHOICESPECS
	pkmn5.ability_index = 5 # TINTEDLENS
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:AEROBLAST)
	pkmn5.learn_move(:EGGBOMB)
	pkmn5.learn_move(:DRACOMETEOR)
	pkmn5.learn_move(:UTURN)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :STEEL
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:ARAQUANID,100)
	pkmn6.item = :MENTALHERB
	pkmn6.ability_index = 0 # WATERBUBBLE
	pkmn6.nature = :ADAMANT
	pkmn6.learn_move(:LIQUIDATION)
	pkmn6.learn_move(:INFESTATION)
	pkmn6.learn_move(:STICKYWEB)
	pkmn6.learn_move(:MIRRORCOAT)
	pkmn6.ev[:HP] = 252
	pkmn6.ev[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 252
	pkmn6.ev[:SPECIAL_DEFENSE] = 8
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :GHOST
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoGhostPartyQuickStart100 # Poke Paste: https://pokepast.es/34eef7480aca0e56
	pkmn1 = Pokemon.new(:GHOLDENGO,100)
	pkmn1.item = :AIRBALLOON
	pkmn1.ability_index = 5 # PRANKSTER
	pkmn1.nature = :MODEST
	pkmn1.learn_move(:NASTYPLOT)
	pkmn1.learn_move(:SHADOWBALL)
	pkmn1.learn_move(:RECOVER)
	pkmn1.learn_move(:EGGBOMB)
	pkmn1.ev[:HP] = 136
	pkmn1.ev[:ATTACK] = 148
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 228
	pkmn1.tera_type = :FAIRY
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:CERULEDGE,100)
	pkmn2.item = :FOCUSSASH
	pkmn2.ability_index = 2 # WEAKARMOR
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:EGGBOMB)
	pkmn2.learn_move(:SACREDFIRE)
	pkmn2.learn_move(:SHADOWSNEAK)
	pkmn2.learn_move(:SWORDSDANCE)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :FIGHTING
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:FLUTTERMANE,100)
	pkmn3.item = :CHOICESPECS
	pkmn3.ability_index = 3 # INTIMIDATE
	pkmn3.nature = :TIMID
	pkmn3.learn_move(:EGGBOMB)
	pkmn3.learn_move(:MOONBLAST)
	pkmn3.learn_move(:THUNDERBOLT)
	pkmn3.learn_move(:POWERGEM)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :STELLAR
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:SPECTRIER,100)
	pkmn4.item = :LEFTOVERS
	pkmn4.ability_index = 5 # SHADOWSHIELD
	pkmn4.nature = :TIMID
	pkmn4.learn_move(:CALMMIND)
	pkmn4.learn_move(:SUBSTITUTE)
	pkmn4.learn_move(:WILLOWISP)
	pkmn4.learn_move(:HEX)
	pkmn4.ev[:HP] = 188
	pkmn4.ev[:ATTACK] = 0
	pkmn4.ev[:DEFENSE] = 124
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 200
	pkmn4.tera_type = :POISON
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:DRAGAPULT,100)
	pkmn5.item = :CHOICESCARF
	pkmn5.ability_index = 6 # INFILTRATOR
	pkmn5.nature = :NAIVE
	pkmn5.learn_move(:DRAGONDARTS)
	pkmn5.learn_move(:SHADOWBALL)
	pkmn5.learn_move(:UTURN)
	pkmn5.learn_move(:THUNDERWAVE)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :ELECTRIC
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:BRAMBLEGHAST,100)
	pkmn6.item = :ROCKYHELMET
	pkmn6.ability_index = 2 # IRONBARBS
	pkmn6.nature = :IMPISH
	pkmn6.learn_move(:SPIKES)
	pkmn6.learn_move(:RAPIDSPIN)
	pkmn6.learn_move(:STRENGTHSAP)
	pkmn6.learn_move(:SAPPYSEED)
	pkmn6.ev[:HP] = 256
	pkmn6.ev[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 240
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 16
	pkmn6.tera_type = :WATER
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoSteelPartyQuickStart100 # Poke Paste: https://pokepast.es/5b4e5ca4bee4d04d
	pkmn1 = Pokemon.new(:GHOLDENGO,100)
	pkmn1.item = :MENTALHERB
	pkmn1.ability_index = 5 # PRANKSTER
	pkmn1.nature = :MODEST
	pkmn1.learn_move(:NASTYPLOT)
	pkmn1.learn_move(:SHADOWBALL)
	pkmn1.learn_move(:RECOVER)
	pkmn1.learn_move(:EGGBOMB)
	pkmn1.ev[:HP] = 192
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 64
	pkmn1.tera_type = :FAIRY
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:HEATRAN,100)
	pkmn2.item = :AIRBALLOON
	pkmn2.ability_index = 6 # ROCKYPAYLOAD
	pkmn2.nature = :CALM
	pkmn2.learn_move(:ANCIENTPOWER)
	pkmn2.learn_move(:EARTHPOWER)
	pkmn2.learn_move(:LAVAPLUME)
	pkmn2.learn_move(:SLACKOFF)
	pkmn2.ev[:HP] = 228
	pkmn2.ev[:ATTACK] = 0
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 240
	pkmn2.ev[:SPEED] = 44
	pkmn2.tera_type = :GRASS
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:SKARMORY,100)
	pkmn3.item = :ROCKYHELMET
	pkmn3.ability_index = 5 # MIRRORARMOR
	pkmn3.nature = :BOLD
	pkmn3.learn_move(:SPIKES)
	pkmn3.learn_move(:ROOST)
	pkmn3.learn_move(:WHIRLWIND)
	pkmn3.learn_move(:BODYPRESS)
	pkmn3.ev[:HP] = 244
	pkmn3.ev[:ATTACK] = 0
	pkmn3.ev[:DEFENSE] = 172
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 96
	pkmn3.tera_type = :GROUND
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:ARCHALUDON,100)
	pkmn4.item = :CHOICESCARF
	pkmn4.ability_index = 0 # STAMINA
	pkmn4.nature = :TIMID
	pkmn4.learn_move(:BODYPRESS)
	pkmn4.learn_move(:DRACOMETEOR)
	pkmn4.learn_move(:HYPERBEAM)
	pkmn4.learn_move(:THUNDERBOLT)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :FLYING
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:IRONTREADS,100)
	pkmn5.item = :ASSAULTVEST
	pkmn5.ability_index = 3 # FILTER
	pkmn5.nature = :JOLLY
	pkmn5.learn_move(:RAPIDSPIN)
	pkmn5.learn_move(:KNOCKOFF)
	pkmn5.learn_move(:EARTHQUAKE)
	pkmn5.learn_move(:ICESPINNER)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :GHOST
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:SCIZOR,100)
	pkmn6.item = :POWERHERB
	pkmn6.ability_index = 0 # FULLMETALBODY
	pkmn6.nature = :ADAMANT
	pkmn6.learn_move(:GEOMANCY)
	pkmn6.learn_move(:SWORDSDANCE)
	pkmn6.learn_move(:DOUBLEHIT)
	pkmn6.learn_move(:FIRSTIMPRESSION)
	pkmn6.ev[:HP] = 252
	pkmn6.ev[:ATTACK] = 252
	pkmn6.ev[:DEFENSE] = 4
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 4
	pkmn6.tera_type = :FIRE
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoFirePartyQuickStart100 # Poke Paste: https://pokepast.es/57e510e3bdaf5c06
	pkmn1 = Pokemon.new(:CINDERACE,100)
	pkmn1.item = :MEGAITE
	pkmn1.ability_index = 4 # LIMBER
	pkmn1.nature = :JOLLY
	pkmn1.learn_move(:GIGAIMPACT)
	pkmn1.learn_move(:GUNKSHOT)
	pkmn1.learn_move(:HIGHJUMPKICK)
	pkmn1.learn_move(:UTURN)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :GRASS
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:CERULEDGE,100)
	pkmn2.item = :FOCUSSASH
	pkmn2.ability_index = 2 # WEAKARMOR
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:EGGBOMB)
	pkmn2.learn_move(:SACREDFIRE)
	pkmn2.learn_move(:SHADOWSNEAK)
	pkmn2.learn_move(:SWORDSDANCE)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :FIGHTING
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:TALONFLAME,100)
	pkmn3.item = :HEAVYDUTYBOOTS
	pkmn3.ability_index = 5 # FLAMEBODY
	pkmn3.nature = :TIMID
	pkmn3.learn_move(:AEROBLAST)
	pkmn3.learn_move(:UTURN)
	pkmn3.learn_move(:DEFOG)
	pkmn3.learn_move(:ROOST)
	pkmn3.ev[:HP] = 128
	pkmn3.ev[:ATTACK] = 0
	pkmn3.ev[:DEFENSE] = 252
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 132
	pkmn3.tera_type = :FAIRY
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:OGERPON,100)
	pkmn4.item = :HEARTHFLAMEMASK
	pkmn4.nature = :ADAMANT
	pkmn4.learn_move(:IVYCUDGEL)
	pkmn4.learn_move(:HORNLEECH)
	pkmn4.learn_move(:SWORDSDANCE)
	pkmn4.learn_move(:SUBSTITUTE)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.iv[:SPECIAL_ATTACK] = 0
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:VOLCANION,100)
	pkmn5.item = :HEATROCK
	pkmn5.ability_index = 3 # DROUGHT
	pkmn5.nature = :MODEST
	pkmn5.learn_move(:BLASTBURN)
	pkmn5.learn_move(:EARTHPOWER)
	pkmn5.learn_move(:SLUDGEBOMB)
	pkmn5.learn_move(:WHIRLPOOL)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :GROUND
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:HEATRAN,100)
	pkmn6.item = :LEFTOVERS
	pkmn6.ability_index = 0 # EARTHEATER
	pkmn6.nature = :CALM
	pkmn6.learn_move(:MAGMASTORM)
	pkmn6.learn_move(:EGGBOMB)
	pkmn6.learn_move(:EARTHPOWER)
	pkmn6.learn_move(:STEALTHROCK)
	pkmn6.ev[:HP] = 140
	pkmn6.ev[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 252
	pkmn6.ev[:SPEED] = 120
	pkmn6.tera_type = :ELECTRIC
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoWaterPartyQuickStart100 # Poke Paste: https://pokepast.es/46ba59df3fbabee0
	pkmn1 = Pokemon.new(:GRENINJA,100)
	pkmn1.item = :MEGAITE
	pkmn1.ability_index = 0 # PROTEAN
	pkmn1.nature = :TIMID
	pkmn1.learn_move(:HYDROCANNON)
	pkmn1.learn_move(:EGGBOMB)
	pkmn1.learn_move(:ICEBEAM)
	pkmn1.learn_move(:EXTRASENSORY)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :WATER
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:SUICUNE,100)
	pkmn2.item = :LEFTOVERS
	pkmn2.ability_index = 2 # PRESSURE
	pkmn2.nature = :BOLD
	pkmn2.learn_move(:SUBSTITUTE)
	pkmn2.learn_move(:CALMMIND)
	pkmn2.learn_move(:SCALD)
	pkmn2.learn_move(:REST)
	pkmn2.ev[:HP] = 256
	pkmn2.ev[:ATTACK] = 0
	pkmn2.ev[:DEFENSE] = 256
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 0
	pkmn2.tera_type = :FAIRY
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:TOXAPEX,100)
	pkmn3.item = :BINDINGBAND
	pkmn3.ability_index = 0 # TOXICDEBRIS
	pkmn3.nature = :BOLD
	pkmn3.learn_move(:TOXIC)
	pkmn3.learn_move(:HAZE)
	pkmn3.learn_move(:RECOVER)
	pkmn3.learn_move(:WHIRLPOOL)
	pkmn3.ev[:HP] = 256
	pkmn3.ev[:ATTACK] = 0
	pkmn3.ev[:DEFENSE] = 252
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 4
	pkmn3.tera_type = :DARK
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:EMPOLEON,100)
	pkmn4.item = :AIRBALLOON
	pkmn4.nature = :CALM
	pkmn4.learn_move(:STEALTHROCK)
	pkmn4.learn_move(:EGGBOMB)
	pkmn4.learn_move(:ROOST)
	pkmn4.learn_move(:ROAR)
	pkmn4.ev[:HP] = 256
	pkmn4.ev[:ATTACK] = 4
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 252
	pkmn4.ev[:SPEED] = 0
	pkmn4.tera_type = :GROUND
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:GASTRODON,100)
	pkmn5.item = :MENTALHERB
	pkmn5.ability_index = 6 # SHELLARMOR
	pkmn5.nature = :CALM
	pkmn5.learn_move(:SPIKES)
	pkmn5.learn_move(:EGGBOMB)
	pkmn5.learn_move(:HEALBELL)
	pkmn5.learn_move(:LUNARBLESSING)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :POISON
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:ALOMOMOLA,100)
	pkmn6.item = :GRIPCLAW
	pkmn6.ability_index = 0 # REGENERATOR
	pkmn6.nature = :SASSY
	pkmn6.learn_move(:FLIPTURN)
	pkmn6.learn_move(:WISH)
	pkmn6.learn_move(:PROTECT)
	pkmn6.learn_move(:WHIRLPOOL)
	pkmn6.ev[:HP] = 256
	pkmn6.ev[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 256
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :STEEL
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoGrassPartyQuickStart100 # Poke Paste: https://pokepast.es/4a7c53b5a7815701
	pkmn1 = Pokemon.new(:RILLABOOM,100)
	pkmn1.item = :MEGAITE
	pkmn1.ability_index = 5 # INTIMIDATE
	pkmn1.nature = :JOLLY
	pkmn1.learn_move(:DOUBLEHIT)
	pkmn1.learn_move(:KNOCKOFF)
	pkmn1.learn_move(:BODYPRESS)
	pkmn1.learn_move(:VICTORYDANCE)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :GRASS
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:MEOWSCARADA,100)
	pkmn2.item = :CHOICESCARF
	pkmn2.ability_index = 2 # BATTLEBOND
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:FLOWERTRICK)
	pkmn2.learn_move(:KNOCKOFF)
	pkmn2.learn_move(:PLAYROUGH)
	pkmn2.learn_move(:UTURN)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :GHOST
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:SINISTCHA,100)
	pkmn3.item = :LEFTOVERS
	pkmn3.ability_index = 0 # HEATPROOF
	pkmn3.nature = :BOLD
	pkmn3.learn_move(:CALMMIND)
	pkmn3.learn_move(:STRENGTHSAP)
	pkmn3.learn_move(:SHADOWBALL)
	pkmn3.learn_move(:MATCHAGOTHA)
	pkmn3.ev[:HP] = 252
	pkmn3.ev[:ATTACK] = 0
	pkmn3.ev[:DEFENSE] = 160
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 100
	pkmn3.tera_type = :POISON
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:OGERPON,100)
	pkmn4.item = :HEARTHFLAMEMASK
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:IVYCUDGEL)
	pkmn4.learn_move(:HORNLEECH)
	pkmn4.learn_move(:SWORDSDANCE)
	pkmn4.learn_move(:PLAYROUGH)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.iv[:SPECIAL_ATTACK] = 0
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:WHIMSICOTT,100)
	pkmn5.item = :PIXIEPLATE
	pkmn5.ability_index = 0 # PRANKSTER
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:MOONBLAST)
	pkmn5.learn_move(:ENERGYBALL)
	pkmn5.learn_move(:UTURN)
	pkmn5.learn_move(:MEMENTO)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :FLYING
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:AMOONGUSS,100)
	pkmn6.item = :ROCKYHELMET
	pkmn6.ability_index = 3 # Regenerator
	pkmn6.nature = :CALM
	pkmn6.learn_move(:FOULPLAY)
	pkmn6.learn_move(:SLUDGEBOMB)
	pkmn6.learn_move(:SYNTHESIS)
	pkmn6.learn_move(:SPORE)
	pkmn6.ev[:HP] = 244
	pkmn6.ev[:DEFENSE] = 164
	pkmn6.ev[:SPECIAL_DEFENSE] = 104
	pkmn6.iv[:SPEED] = 0
	pkmn6.tera_type = :FAIRY
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoElectricPartyQuickStart100 # Poke Paste: https://pokepast.es/240c891d4149ca55
	pkmn1 = Pokemon.new(:RAGINGBOLT,100)
	pkmn1.item = :ELECTRICSEED
	pkmn1.ability_index = 4 # INTIMIDATE
	pkmn1.nature = :MODEST
	pkmn1.learn_move(:THUNDER)
	pkmn1.learn_move(:EGGBOMB)
	pkmn1.learn_move(:THUNDERCLAP)
	pkmn1.learn_move(:CALMMIND)
	pkmn1.ev[:HP] = 124
	pkmn1.ev[:ATTACK] = 252
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 136
	pkmn1.tera_type = :BUG
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:IRONHANDS,100)
	pkmn2.item = :ASSAULTVEST
	pkmn2.ability_index = 0 # QUARKDRIVE
	pkmn2.nature = :CAREFUL
	pkmn2.learn_move(:DRAINPUNCH)
	pkmn2.learn_move(:WILDCHARGE)
	pkmn2.learn_move(:HEAVYSLAM)
	pkmn2.learn_move(:VOLTSWITCH)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 136
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 208
	pkmn2.ev[:SPEED] = 168
	pkmn2.tera_type = :GRASS
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:ROTOM_2,100)
	pkmn3.item = :DAMPROCK
	pkmn3.ability_index = 3 # DRIZZLE
	pkmn3.nature = :BOLD
	pkmn3.learn_move(:SOAK)
	pkmn3.learn_move(:HYDROPUMP)
	pkmn3.learn_move(:VOLTSWITCH)
	pkmn3.learn_move(:FOULPLAY)
	pkmn3.ev[:HP] = 248
	pkmn3.ev[:ATTACK] = 0
	pkmn3.ev[:DEFENSE] = 212
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 52
	pkmn3.tera_type = :WATER
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:REGIELEKI,100)
	pkmn4.item = :HEAVYDUTYBOOTS
	pkmn3.ability_index = 0 # ELECTRICSURGE
	pkmn4.nature = :TIMID
	pkmn4.learn_move(:THUNDER)
	pkmn4.learn_move(:VOLTSWITCH)
	pkmn4.learn_move(:RAPIDSPIN)
	pkmn4.learn_move(:THUNDERWAVE)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :ROCK
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:SANDYSHOCKS,100)
	pkmn5.item = :BOOSTERENERGY
	pkmn5.ability_index = 0 # PROTOSYNTHESIS
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:SPIKES)
	pkmn5.learn_move(:VOLTSWITCH)
	pkmn5.learn_move(:STEALTHROCK)
	pkmn5.learn_move(:EGGBOMB)
	pkmn5.ev[:HP] = 52
	pkmn5.ev[:ATTACK] = 208
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 252
	pkmn5.tera_type = :ICE
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:ZAPDOS,100)
	pkmn6.item = :LEFTOVERS
	pkmn6.ability_index = 4 # DELTASTREAM
	pkmn6.nature = :MODEST
	pkmn6.learn_move(:THUNDER)
	pkmn6.learn_move(:AEROBLAST)
	pkmn6.learn_move(:AGILITY)
	pkmn6.learn_move(:BATONPASS)
	pkmn6.ev[:HP] = 140
	pkmn6.ev[:ATTACK] = 252
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 120
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :FLYING
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoPsychicPartyQuickStart100 # Poke Paste: https://pokepast.es/d71fa8f1e1e7d611
	pkmn1 = Pokemon.new(:SLOWKING,100)
	pkmn1.item = :KASIBBERRY
	pkmn1.ability_index = 0 # REGENERATOR
	pkmn1.nature = :BOLD
	pkmn1.learn_move(:KINESIS)
	pkmn1.learn_move(:SCALD)
	pkmn1.learn_move(:THUNDERWAVE)
	pkmn1.learn_move(:LUNARBLESSING)
	pkmn1.ev[:HP] = 256
	pkmn1.ev[:ATTACK] = 0
	pkmn1.ev[:DEFENSE] = 256
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 0
	pkmn1.tera_type = :FAIRY
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:HATTERENE,100)
	pkmn2.item = :TERRAINEXTENDER
	pkmn2.ability_index = 3 # PSYCHICSURGE
	pkmn2.nature = :BOLD
	pkmn2.learn_move(:CALMMIND)
	pkmn2.learn_move(:PSYSHOCK)
	pkmn2.learn_move(:DRAININGKISS)
	pkmn2.learn_move(:GIGADRAIN)
	pkmn2.ev[:HP] = 256
	pkmn2.ev[:ATTACK] = 0
	pkmn2.ev[:DEFENSE] = 204
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 52
	pkmn2.tera_type = :WATER
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:HOOPA_1,100)
	pkmn3.item = :PSYCHICSEED
	pkmn3.ability_index = 4 # INTIMIDATE
	pkmn3.nature = :MILD
	pkmn3.learn_move(:EXPANDINGFORCE)
	pkmn3.learn_move(:KNOCKOFF)
	pkmn3.learn_move(:FOCUSBLAST)
	pkmn3.learn_move(:THUNDERBOLT)
	pkmn3.ev[:HP] = 240
	pkmn3.ev[:ATTACK] = 16
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 156
	pkmn3.ev[:SPEED] = 100
	pkmn3.tera_type = :POISON
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:IRONBOULDER,100)
	pkmn4.item = :RAZORCLAW
	pkmn3.ability_index = 2 # SHARPNESS
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:SWORDSDANCE)
	pkmn4.learn_move(:TAUNT)
	pkmn4.learn_move(:MIGHTYCLEAVE)
	pkmn4.learn_move(:EARTHQUAKE)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :ROCK
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:LATIOS,100)
	pkmn5.item = :MEGAITE
	pkmn5.ability_index = 0 # SPEEDBOOST
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:EXTRASENSORY)
	pkmn5.learn_move(:DRACOMETEOR)
	pkmn5.learn_move(:THUNDERBOLT)
	pkmn5.learn_move(:ICEBEAM)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :DRAGON
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:JIRACHI,100)
	pkmn6.item = :CHOICESCARF
	pkmn6.ability_index = 6 # MAGICBOUNCE
	pkmn6.nature = :JOLLY
	pkmn6.learn_move(:UTURN)
	pkmn6.learn_move(:BODYSLAM)
	pkmn6.learn_move(:STEALTHROCK)
	pkmn6.learn_move(:HEALINGWISH)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.tera_type = :FLYING
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoIcePartyQuickStart100 # Poke Paste: https://pokepast.es/9373088a9c4e8a75
	pkmn1 = Pokemon.new(:SANDSLASH_1,100)
	pkmn1.item = :HEAVYDUTYBOOTS
	pkmn1.ability_index = 0 # SLUSHRUSH
	pkmn1.nature = :JOLLY
	pkmn1.learn_move(:RAPIDSPIN)
	pkmn1.learn_move(:IRONHEAD)
	pkmn1.learn_move(:EARTHQUAKE)
	pkmn1.learn_move(:KNOCKOFF)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :GHOST
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:WEAVILE,100)
	pkmn2.item = :WIDELENS
	pkmn2.ability_index = 2 # TECHNICIAN
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:SWORDSDANCE)
	pkmn2.learn_move(:DOUBLEHIT)
	pkmn2.learn_move(:TRIPLEAXEL)
	pkmn2.learn_move(:ICESHARD)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :FLYING
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:NINETALES_1,100)
	pkmn3.item = :ICYROCK
	pkmn3.ability_index = 0 # SNOWWARNING
	pkmn3.nature = :TIMID
	pkmn3.learn_move(:AURORAVEIL)
	pkmn3.learn_move(:FREEZEDRY)
	pkmn3.learn_move(:MOONBLAST)
	pkmn3.learn_move(:ENCORE)
	pkmn3.ev[:HP] = 252
	pkmn3.ev[:ATTACK] = 0
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 4
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :PSYCHIC
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:MAMOSWINE,100)
	pkmn4.item = :LIFEORB
	pkmn3.ability_index = 6 # SHEERFORCE
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:HEADLONGRUSH)
	pkmn4.learn_move(:MOUNTAINGALE)
	pkmn4.learn_move(:ROCKCLIMB)
	pkmn4.learn_move(:IRONHEAD)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :FIRE
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:LAPRAS,100)
	pkmn5.item = :LEFTOVERS
	pkmn5.ability_index = 0 # SHELLARMOR
	pkmn5.nature = :ADAMANT
	pkmn5.learn_move(:LIQUIDATION)
	pkmn5.learn_move(:BODYSLAM)
	pkmn5.learn_move(:BULKUP)
	pkmn5.learn_move(:SHEERCOLD)
	pkmn5.ev[:HP] = 32
	pkmn5.ev[:ATTACK] = 252
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 228
	pkmn5.tera_type = :POISON
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:KYUREM,100)
	pkmn6.item = :CHOICESCARF
	pkmn6.ability_index = 2 # BEASTBOOST
	pkmn6.nature = :TIMID
	pkmn6.learn_move(:DRACOMETEOR)
	pkmn6.learn_move(:HYPERBEAM)
	pkmn6.learn_move(:FREEZEDRY)
	pkmn6.learn_move(:EARTHPOWER)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.tera_type = :FAIRY
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoDragonPartyQuickStart100 # Poke Paste: https://pokepast.es/b883849ca83b0402
	pkmn1 = Pokemon.new(:DURALUDON,100)
	pkmn1.item = :EVIOLITE
	pkmn1.ability_index = 4 # STAMINA
	pkmn1.nature = :BOLD
	pkmn1.learn_move(:BODYPRESS)
	pkmn1.learn_move(:FLASHCANNON)
	pkmn1.learn_move(:STEALTHROCK)
	pkmn1.learn_move(:THUNDERWAVE)
	pkmn1.ev[:HP] = 252
	pkmn1.ev[:ATTACK] = 0
	pkmn1.ev[:DEFENSE] = 44
	pkmn1.ev[:SPECIAL_DEFENSE] = 216
	pkmn1.ev[:SPEED] = 0
	pkmn1.tera_type = :GHOST
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:GOODRA_1,100)
	pkmn2.item = :LEFTOVERS
	pkmn2.ability_index = 6 # GOOEY
	pkmn2.nature = :CAREFUL
	pkmn2.learn_move(:HEAVYSLAM)
	pkmn2.learn_move(:KNOCKOFF)
	pkmn2.learn_move(:DRAGONTAIL)
	pkmn2.learn_move(:PROTECT)
	pkmn2.ev[:HP] = 248
	pkmn2.ev[:ATTACK] = 0
	pkmn2.ev[:DEFENSE] = 12
	pkmn2.ev[:SPECIAL_DEFENSE] = 252
	pkmn2.ev[:SPEED] = 0
	pkmn2.tera_type = :FLYING
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:LATIOS,100)
	pkmn3.item = :EXPERTBELT
	pkmn3.ability_index = 4 # NEUROFORCE
	pkmn3.nature = :TIMID
	pkmn3.learn_move(:EXTRASENSORY)
	pkmn3.learn_move(:THUNDERBOLT)
	pkmn3.learn_move(:ICEBEAM)
	pkmn3.learn_move(:ROOST)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :STEEL
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:GARCHOMP,100)
	pkmn4.item = :MEGAITE
	pkmn3.ability_index = 2 # EARTHEATER
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:VICTORYDANCE)
	pkmn4.learn_move(:EXTREMESPEED)
	pkmn4.learn_move(:DRAGONASCENT)
	pkmn4.learn_move(:IRONTAIL)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :ROCK
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:DRAGAPULT,100)
	pkmn5.item = :CHOICESPECS
	pkmn5.ability_index = 2 # MEGALAUNCHER
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:HYPERBEAM)
	pkmn5.learn_move(:SHADOWBALL)
	pkmn5.learn_move(:FLAMETHROWER)
	pkmn5.learn_move(:UTURN)
	pkmn5.ev[:HP] = 0
	pkmn5.ev[:ATTACK] = 256
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :DRAGON
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:ROARINGMOON,100)
	pkmn6.item = :CHOICESCARF
	pkmn6.ability_index = 6 # MOXIE
	pkmn6.nature = :JOLLY
	pkmn6.learn_move(:DRAGONASCENT)
	pkmn6.learn_move(:KNOCKOFF)
	pkmn6.learn_move(:EARTHQUAKE)
	pkmn6.learn_move(:UTURN)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.tera_type = :FIRE
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoDarkPartyQuickStart100 # Poke Paste: https://pokepast.es/4088d29463d73e7a
	pkmn1 = Pokemon.new(:TINGLU,100)
	pkmn1.item = :LEFTOVERS
	pkmn1.ability_index = 5 # ROCKYPAYLOAD
	pkmn1.nature = :CAREFUL
	pkmn1.learn_move(:BODYSLAM)
	pkmn1.learn_move(:WHIRLWIND)
	pkmn1.learn_move(:SPIKES)
	pkmn1.learn_move(:RUINATION)
	pkmn1.ev[:HP] = 252
	pkmn1.ev[:ATTACK] = 0
	pkmn1.ev[:DEFENSE] = 8
	pkmn1.ev[:SPECIAL_DEFENSE] = 252
	pkmn1.ev[:SPEED] = 0
	pkmn1.tera_type = :POISON
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:MEOWSCARADA,100)
	pkmn2.item = :CHOICESCARF
	pkmn2.ability_index = 6 # MAGICBOUNCE
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:FLOWERTRICK)
	pkmn2.learn_move(:TRIPLEAXEL)
	pkmn2.learn_move(:PLAYROUGH)
	pkmn2.learn_move(:UTURN)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 256
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :GRASS
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:SAMUROTT_1,100)
	pkmn3.item = :RAZORCLAW
	pkmn3.ability_index = 4 # SHARPNESS
	pkmn3.nature = :JOLLY
	pkmn3.learn_move(:VICTORYDANCE)
	pkmn3.learn_move(:SLASH)
	pkmn3.learn_move(:RAZORSHELL)
	pkmn3.learn_move(:SACREDSWORD)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :FIRE
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:MANDIBUZZ,100)
	pkmn4.item = :HEAVYDUTYBOOTS
	pkmn3.ability_index = 0 # LEVITATE
	pkmn4.nature = :IMPISH
	pkmn4.learn_move(:PUNISHMENT)
	pkmn4.learn_move(:ROOST)
	pkmn4.learn_move(:TOXIC)
	pkmn4.learn_move(:VENOMDRENCH)
	pkmn4.ev[:HP] = 252
	pkmn4.ev[:ATTACK] = 0
	pkmn4.ev[:DEFENSE] = 252
	pkmn4.ev[:SPECIAL_DEFENSE] = 8
	pkmn4.ev[:SPEED] = 0
	pkmn4.tera_type = :ELECTRIC
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:HOOPA_1,100)
	pkmn5.item = :ASSAULTVEST
	pkmn5.ability_index = 4 # INTIMIDATE
	pkmn5.nature = :CAREFUL
	pkmn5.learn_move(:PSYCHICNOISE)
	pkmn5.learn_move(:KNOCKOFF)
	pkmn5.learn_move(:GUNKSHOT)
	pkmn5.learn_move(:DRAINPUNCH)
	pkmn5.ev[:HP] = 252
	pkmn5.ev[:ATTACK] = 48
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 196
	pkmn5.ev[:SPEED] = 16
	pkmn5.tera_type = :STEEL
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:DARKRAI,100)
	pkmn6.item = :SALACBERRY
	pkmn6.ability_index = 5 # DARKAURA
	pkmn6.nature = :TIMID
	pkmn6.learn_move(:SUBSTITUTE)
	pkmn6.learn_move(:NASTYPLOT)
	pkmn6.learn_move(:EGGBOMB)
	pkmn6.learn_move(:FOCUSBLAST)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.tera_type = :FAIRY
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedMonoFairyPartyQuickStart100 # Poke Paste: https://pokepast.es/7befb3cd43301b4b
	pkmn1 = Pokemon.new(:FLUTTERMANE,100)
	pkmn1.item = :POWERHERB
	pkmn1.ability_index = 3 # INTIMIDATE
	pkmn1.nature = :TIMID
	pkmn1.learn_move(:GEOMANCY)
	pkmn1.learn_move(:NASTYPLOT)
	pkmn1.learn_move(:SPARKLYSWIRL)
	pkmn1.learn_move(:MYSTICALFIRE)
	pkmn1.ev[:HP] = 244
	pkmn1.ev[:ATTACK] = 4
	pkmn1.ev[:DEFENSE] = 124
	pkmn1.ev[:SPECIAL_DEFENSE] = 4
	pkmn1.ev[:SPEED] = 136
	pkmn1.tera_type = :FIRE
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:KLEFKI,100)
	pkmn2.item = :LIGHTCLAY
	pkmn2.ability_index = 0 # LEVITATE
	pkmn2.nature = :BOLD
	pkmn2.learn_move(:FOULPLAY)
	pkmn2.learn_move(:REFLECT)
	pkmn2.learn_move(:LIGHTSCREEN)
	pkmn2.learn_move(:STEALTHROCK)
	pkmn2.ev[:HP] = 252
	pkmn2.ev[:ATTACK] = 0
	pkmn2.ev[:DEFENSE] = 204
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 56
	pkmn2.tera_type = :ELECTRIC
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:ENAMORUS,100)
	pkmn3.item = :CHOICESCARF
	pkmn3.ability_index = 2 # CONTRARY
	pkmn3.nature = :JOLLY
	pkmn3.learn_move(:PLAYROUGH)
	pkmn3.learn_move(:BODYSLAM)
	pkmn3.learn_move(:SUPERPOWER)
	pkmn3.learn_move(:HEALINGWISH)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :GROUND
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:IRONVALIANT,100)
	pkmn4.item = :BOOSTERENERGY
	pkmn4.ability_index = 0 # QUARKDRIVE
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:SWORDSDANCE)
	pkmn4.learn_move(:CLOSECOMAT)
	pkmn4.learn_move(:KNOCKOFF)
	pkmn4.learn_move(:SPIRITBREAK)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :STEEL
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:CLEFABLE,100)
	pkmn5.item = :LIFEORB
	pkmn5.ability_index = 2 # MAGICGUARD
	pkmn5.nature = :BOLD
	pkmn5.learn_move(:TRIATTACK)
	pkmn5.learn_move(:THUNDERBOLT)
	pkmn5.learn_move(:QUIVERDANCE)
	pkmn5.learn_move(:SOFTBOILED)
	pkmn5.ev[:HP] = 252
	pkmn5.ev[:ATTACK] = 0
	pkmn5.ev[:DEFENSE] = 132
	pkmn5.ev[:SPECIAL_DEFENSE] = 64
	pkmn5.ev[:SPEED] = 64
	pkmn5.tera_type = :POISON
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:AZUMARILL,100)
	pkmn6.item = :HONEY
	pkmn6.ability_index = 0 # HUGEPOWER
	pkmn6.nature = :ADAMANT
	pkmn6.learn_move(:EXTREMESPEED)
	pkmn6.learn_move(:LIQUIDATION)
	pkmn6.learn_move(:KNOCKOFF)
	pkmn6.learn_move(:BELLYDRUM)
	pkmn6.ev[:HP] = 80
	pkmn6.ev[:ATTACK] = 252
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 4
	pkmn6.ev[:SPEED] = 176
	pkmn6.tera_type = :PSYCHIC
	pkmn6.dynamax_able = false
	pkmn6.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedRainWeatherPartyQuickStart100 # Pending Poke Paste: https://nuzlocke.app/guides/radical-red-hardcore
	pkmn1 = Pokemon.new(:THUNDURUS,100)
	pkmn1.item = :DAMPROCK
	pkmn1.ability_index = 3 # PRANKSTER
	pkmn1.nature = :BOLD
	pkmn1.learn_move(:VOLTSWITCH)
	pkmn1.learn_move(:RAINDANCE)
	pkmn1.learn_move(:THUNDERWAVE)
	pkmn1.learn_move(:TAUNT)
	pkmn1.ev[:HP] = 256
	pkmn1.ev[:ATTACK] = 4
	pkmn1.ev[:DEFENSE] = 156
	pkmn1.ev[:SPECIAL_DEFENSE] = 92
	pkmn1.ev[:SPEED] = 4
	pkmn1.tera_type = :DARK
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:JIRACHI,100)
	pkmn2.item = :TERRAINEXTENDER
	pkmn2.ability_index = 4 # MISTYSURGE
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:STEALTHROCK)
	pkmn2.learn_move(:ENCORE)
	pkmn2.learn_move(:TRICK)
	pkmn2.learn_move(:UTURN)
	pkmn2.ev[:HP] = 252
	pkmn2.ev[:ATTACK] = 0
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 32
	pkmn2.ev[:SPEED] = 228
	pkmn2.tera_type = :WATER
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:SEISMITOAD,100)
	pkmn3.item = :THROATSPRAY
	pkmn3.ability_index = 3 # SWIFTSWIM
	pkmn3.nature = :TIMID
	pkmn3.learn_move(:WATERGUN)
	pkmn3.learn_move(:HYPERVOICE)
	pkmn3.learn_move(:GRASSKNOT)
	pkmn3.learn_move(:FOCUSBLAST)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :POISON
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:MANTINE,100)
	pkmn4.item = :LEFTOVERS
	pkmn4.ability_index = 6 # HYDRATION
	pkmn4.nature = :TIMID
	pkmn4.learn_move(:QUIVERDANCE)
	pkmn4.learn_move(:SCALD)
	pkmn4.learn_move(:TRIATTACK)
	pkmn4.learn_move(:ROOST)
	pkmn4.ev[:HP] = 80
	pkmn4.ev[:ATTACK] = 252
	pkmn4.ev[:DEFENSE] = 4
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 176
	pkmn4.tera_type = :GROUND
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:KINGDRA,100)
	pkmn5.item = :WATERIUMZ
	pkmn5.ability_index = 0 # SWIFTSWIM
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:HYPERBEAM)
	pkmn5.learn_move(:WATERGUN)
	pkmn5.learn_move(:SPLASH)
	pkmn5.learn_move(:ICEBEAM)
	pkmn5.ev[:HP] = 104
	pkmn5.ev[:ATTACK] = 152
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 256
	pkmn5.tera_type = :FLYING
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:GRENINJA,100)
	pkmn6.item = :MEGAITE
	pkmn6.ability_index = 0 # PROTEAN
	pkmn6.nature = :TIMID
	pkmn6.learn_move(:HYDROCANNON)
	pkmn6.learn_move(:EGGBOMB)
	pkmn6.learn_move(:ICEBEAM)
	pkmn6.learn_move(:EXTRASENSORY)
	pkmn6.ev[:HP] = 0
	pkmn6.ev[:ATTACK] = 256
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 256
	pkmn6.tera_type = :WATER
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedSunWeatherPartyQuickStart100 # Pending Poke Paste: https://nuzlocke.app/guides/radical-red-hardcore
	pkmn1 = Pokemon.new(:CHARIZARD,100)
	pkmn1.item = :MEGAITEY
	pkmn1.ability_index = 4 # DROUGHT
	pkmn1.nature = :TIMID
	pkmn1.learn_move(:BLASTBURN)
	pkmn1.learn_move(:AEROBLAST)
	pkmn1.learn_move(:SCORCHINGSANDS)
	pkmn1.learn_move(:SOLARBEAM)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :FIRE
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:GROUDON,100)
	pkmn2.item = :REDORB
	pkmn2.ability_index = 4 # INTIMIDATE
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:ROCKPOLISH)
	pkmn2.learn_move(:SWORDSDANCE)
	pkmn2.learn_move(:PRECIPICEBLADES)
	pkmn2.learn_move(:HEATCRASH)
	pkmn2.ev[:HP] = 140
	pkmn2.ev[:ATTACK] = 252
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 120
	pkmn2.tera_type = :GROUND
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:HELIOLISK,100)
	pkmn3.item = :LIFEORB
	pkmn3.ability_index = 1 # SOLARPOWER
	pkmn3.nature = :TIMID
	pkmn3.learn_move(:WEATHERBALL)
	pkmn3.learn_move(:THUNDERCLAP)
	pkmn3.learn_move(:SOLARBEAM)
	pkmn3.learn_move(:QUIVERDANCE)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :FLYING
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:DARMANITAN_2,100)
	pkmn4.item = :SALACBERRY
	pkmn4.ability_index = 2 # ZENMODE
	pkmn4.nature = :ADAMANT
	pkmn4.learn_move(:BODYSLAM)
	pkmn4.learn_move(:FLAREBLITZ)
	pkmn4.learn_move(:ENDURE)
	pkmn4.learn_move(:REVERSAL)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :GRASS
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:HOOH,100)
	pkmn5.item = :HEAVYDUTYBOOTS
	pkmn5.ability_index = 2 # WINDRIDER
	pkmn5.nature = :ADAMANT
	pkmn5.learn_move(:SACREDFIRE)
	pkmn5.learn_move(:DOUBLEEDGE)
	pkmn5.learn_move(:EARTHQUAKE)
	pkmn5.learn_move(:TAILWIND)
	pkmn5.ev[:HP] = 252
	pkmn5.ev[:ATTACK] = 176
	pkmn5.ev[:DEFENSE] = 20
	pkmn5.ev[:SPECIAL_DEFENSE] = 56
	pkmn5.ev[:SPEED] = 8
	pkmn5.tera_type = :ELECTRIC
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:VENUSAUR,100)
	pkmn6.item = :FOCUSSASH
	pkmn6.ability_index = 3 # CHLOROPHYLL
	pkmn6.nature = :TIMID
	pkmn6.learn_move(:GROWTH)
	pkmn6.learn_move(:TRIATTACK)
	pkmn6.learn_move(:POISONPOWDER)
	pkmn6.learn_move(:WEATHERBALL)
	pkmn6.ev[:HP] = 72
	pkmn6.ev[:ATTACK] = 252
	pkmn6.ev[:DEFENSE] = 4
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 184
	pkmn6.tera_type = :ROCK
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedSandstormPartyQuickStart100 # Pending Poke Paste: https://nuzlocke.app/guides/radical-red-hardcore
	pkmn1 = Pokemon.new(:GIGALITH,100)
	pkmn1.item = :CUSTAPBERRY
	pkmn1.ability_index = 4 # SANDSTREAM
	pkmn1.nature = :ADAMANT
	pkmn1.learn_move(:EXPLOSION)
	pkmn1.learn_move(:STEALTHROCK)
	pkmn1.learn_move(:SANDTOMB)
	pkmn1.learn_move(:SANDSTORM)
	pkmn1.ev[:HP] = 256
	pkmn1.ev[:ATTACK] = 256
	pkmn1.ev[:DEFENSE] = 0
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 0
	pkmn1.tera_type = :FLYING
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:LANDORUS_1,100)
	pkmn2.item = :SMOOTHROCK
	pkmn2.ability_index = 5 # SANDSTREAM
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:STEALTHROCK)
	pkmn2.learn_move(:TAUNT)
	pkmn2.learn_move(:UTURN)
	pkmn2.learn_move(:FLOATYFALL)
	pkmn2.ev[:HP] = 252
	pkmn2.ev[:ATTACK] = 0
	pkmn2.ev[:DEFENSE] = 4
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 256
	pkmn2.tera_type = :GHOST
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:ZYGARDE,100)
	pkmn3.item = :LEFTOVERS
	pkmn3.ability_index = 0 # POWERCONSTRUCT
	pkmn3.nature = :IMPISH
	pkmn3.learn_move(:COIL)
	pkmn3.learn_move(:THOUSANDARROWS)
	pkmn3.learn_move(:REST)
	pkmn3.learn_move(:DRAGONTAIL)
	pkmn3.ev[:HP] = 256
	pkmn3.ev[:ATTACK] = 0
	pkmn3.ev[:DEFENSE] = 96
	pkmn3.ev[:SPECIAL_DEFENSE] = 108
	pkmn3.ev[:SPEED] = 52
	pkmn3.tera_type = :FAIRY
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:AERODACTYL,100)
	pkmn4.item = :MEGAITE
	pkmn4.ability_index = 3 # ROCKHEAD
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:DRAGONDANCE)
	pkmn4.learn_move(:ROCKCLIMB)
	pkmn4.learn_move(:EARTHQUAKE)
	pkmn4.learn_move(:FLOATYFALL)
	pkmn4.ev[:HP] = 0
	pkmn4.ev[:ATTACK] = 256
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 0
	pkmn4.ev[:SPEED] = 256
	pkmn4.tera_type = :ROCK
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:EMPOLEON,100)
	pkmn5.item = :WEAKNESSPOLICY
	pkmn5.ability_index = 4 # BATTLEARMOR
	pkmn5.nature = :TIMID
	pkmn5.learn_move(:AGILITY)
	pkmn5.learn_move(:ROOST)
	pkmn5.learn_move(:SCALD)
	pkmn5.learn_move(:ICEBEAM)
	pkmn5.ev[:HP] = 96
	pkmn5.ev[:ATTACK] = 252
	pkmn5.ev[:DEFENSE] = 0
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 164
	pkmn5.tera_type = :ELECTRIC
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:CRADILY,100)
	pkmn6.item = :BIGROOT
	pkmn6.ability_index = 0 # STORMDRAIN
	pkmn6.nature = :IMPISH
	pkmn6.learn_move(:SAPPYSEED)
	pkmn6.learn_move(:JUNGLEHEALING)
	pkmn6.learn_move(:INGRAIN)
	pkmn6.learn_move(:STOCKPILE)
	pkmn6.ev[:HP] = 256
	pkmn6.ev[:ATTACK] = 0
	pkmn6.ev[:DEFENSE] = 92
	pkmn6.ev[:SPECIAL_DEFENSE] = 164
	pkmn6.ev[:SPEED] = 0
	pkmn6.tera_type = :GROUND
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedHailstormPartyQuickStart100 # Pending Poke Paste: https://nuzlocke.app/guides/radical-red-hardcore
	pkmn1 = Pokemon.new(:SUICUNE,100)
	pkmn1.item = :ICYROCK
	pkmn1.ability_index = 4 # SNOWWARNING
	pkmn1.nature = :CALM
	pkmn1.learn_move(:AURORAVEIL)
	pkmn1.learn_move(:FLIPTURN)
	pkmn1.learn_move(:TAILWIND)
	pkmn1.learn_move(:ROAR)
	pkmn1.ev[:HP] = 256
	pkmn1.ev[:ATTACK] = 4
	pkmn1.ev[:DEFENSE] = 108
	pkmn1.ev[:SPECIAL_DEFENSE] = 60
	pkmn1.ev[:SPEED] = 84
	pkmn1.tera_type = :DARK
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:KYUREM_2,100)
	pkmn2.item = :LOADEDDICE
	pkmn2.ability_index = 3 # INTIMIDATE
	pkmn2.nature = :JOLLY
	pkmn2.learn_move(:DRAGONDANCE)
	pkmn2.learn_move(:EGGBOMB)
	pkmn2.learn_move(:SUBSTITUTE)
	pkmn2.learn_move(:DRAGONDANCE)
	pkmn2.ev[:HP] = 0
	pkmn2.ev[:ATTACK] = 252
	pkmn2.ev[:DEFENSE] = 94
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 168
	pkmn2.tera_type = :FAIRY
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:ARCTOZOLT,100)
	pkmn3.item = :HEAVYDUTYBOOTS
	pkmn3.ability_index = 0 # SLUSHRUSH
	pkmn3.nature = :ADAMANT
	pkmn3.learn_move(:SPARK)
	pkmn3.learn_move(:EGGBOMB)
	pkmn3.learn_move(:AURORAVEIL)
	pkmn3.learn_move(:SUBSTITUTE)
	pkmn3.ev[:HP] = 0
	pkmn3.ev[:ATTACK] = 256
	pkmn3.ev[:DEFENSE] = 0
	pkmn3.ev[:SPECIAL_DEFENSE] = 0
	pkmn3.ev[:SPEED] = 256
	pkmn3.tera_type = :WATER
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:GLALIE,100)
	pkmn4.item = :MEGAITE
	pkmn4.ability_index = 0 # LEVITATE
	pkmn4.nature = :JOLLY
	pkmn4.learn_move(:FAKEOUT)
	pkmn4.learn_move(:HEADSMASH)
	pkmn4.learn_move(:EXTREMESPEED)
	pkmn4.learn_move(:VICTORYDANCE)
	pkmn4.ev[:HP] = 80
	pkmn4.ev[:ATTACK] = 0
	pkmn4.ev[:DEFENSE] = 0
	pkmn4.ev[:SPECIAL_DEFENSE] = 252
	pkmn4.ev[:SPEED] = 180
	pkmn4.tera_type = :PSYCHIC
	pkmn4.dynamax_able = false
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:CLEFABLE,100)
	pkmn5.item = :LIFEORB
	pkmn5.ability_index = 2 # MAGICGUARD
	pkmn5.nature = :BOLD
	pkmn5.learn_move(:TRIATTACK)
	pkmn5.learn_move(:FLAMETHROWER)
	pkmn5.learn_move(:QUIVERDANCE)
	pkmn5.learn_move(:SOFTBOILED)
	pkmn5.ev[:HP] = 252
	pkmn5.ev[:ATTACK] = 0
	pkmn5.ev[:DEFENSE] = 132
	pkmn5.ev[:SPECIAL_DEFENSE] = 64
	pkmn5.ev[:SPEED] = 64
	pkmn5.tera_type = :POISON
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:BEARTIC,100)
	pkmn6.item = :LEFTOVERS
	pkmn6.ability_index = 5 # DAMP
	pkmn6.nature = :ADAMANT
	pkmn6.learn_move(:VICTORYDANCE)
	pkmn6.learn_move(:SUBSTITUTE)
	pkmn6.learn_move(:ICICLECRASH)
	pkmn6.learn_move(:BODYSLAM)
	pkmn6.ev[:HP] = 132
	pkmn6.ev[:ATTACK] = 252
	pkmn6.ev[:DEFENSE] = 0
	pkmn6.ev[:SPECIAL_DEFENSE] = 0
	pkmn6.ev[:SPEED] = 128
	pkmn6.tera_type = :GROUND
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

def pbOptimisedUtimatePartyQuickStart100 # Custom Team, mirror match of Dani, the Mono Stellar Type Master
	pkmn1 = Pokemon.new(:MEWTWO,100)
	pkmn1.item = :MEGAITEX
	pkmn1.ability_index = 3 # INTIMIDATE
	pkmn1.nature = :JOLLY
	pkmn1.learn_move(:PSYCHOCUT)
	pkmn1.learn_move(:VICTORYDANCE)
	pkmn1.learn_move(:DRAINPUNCH)
	pkmn1.learn_move(:SHEERCOLD)
	pkmn1.ev[:HP] = 0
	pkmn1.ev[:ATTACK] = 112
	pkmn1.ev[:DEFENSE] = 144
	pkmn1.ev[:SPECIAL_DEFENSE] = 0
	pkmn1.ev[:SPEED] = 256
	pkmn1.tera_type = :FIRE
	pkmn1.dynamax_able = false
	pkmn1.calc_stats
	pbAddPokemonSilent(pkmn1)
	
	pkmn2 = Pokemon.new(:MEW,100)
	pkmn2.item = :MEWNIUMZ
	pkmn2.ability_index = 5 # UNAWARE
	pkmn2.nature = :TIMID
	pkmn2.learn_move(:LUSTERPURGE)
	pkmn2.learn_move(:ECHOEDVOICE)
	pkmn2.learn_move(:WILLOWISP)
	pkmn2.learn_move(:QUIVERDANCE)
	pkmn2.ev[:HP] = 240
	pkmn2.ev[:ATTACK] = 52
	pkmn2.ev[:DEFENSE] = 0
	pkmn2.ev[:SPECIAL_DEFENSE] = 0
	pkmn2.ev[:SPEED] = 220
	pkmn2.tera_type = :ICE
	pkmn2.dynamax_able = false
	pkmn2.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn2)
	
	pkmn3 = Pokemon.new(:TERAPAGOS,100)
	pkmn3.item = :WHITEHERB
	pkmn3.nature = :BOLD
	pkmn3.learn_move(:NORETREAT)
	pkmn3.learn_move(:SHELLSMASH)
	pkmn3.learn_move(:TAUNT)
	pkmn3.learn_move(:TERASTARSTORM)
	pkmn3.ev[:HP] = 172
	pkmn3.ev[:ATTACK] = 68
	pkmn3.ev[:DEFENSE] = 204
	pkmn3.ev[:SPECIAL_DEFENSE] = 12
	pkmn3.ev[:SPEED] = 56
	pkmn3.dynamax_able = false
	pkmn3.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn3)
	
	pkmn4 = Pokemon.new(:TYPENULL,100)
	pkmn4.item = :EVIOLITE
	pkmn4.ability_index = 0 # BATTLEARMOR
	pkmn4.nature = :CALM
	pkmn4.learn_move(:SALTCURE)
	pkmn4.learn_move(:REST)
	pkmn4.learn_move(:SAPPYSEED)
	pkmn4.learn_move(:BIND)
	pkmn4.ev[:HP] = 252
	pkmn4.ev[:ATTACK] = 0
	pkmn4.ev[:DEFENSE] = 252
	pkmn4.ev[:SPECIAL_DEFENSE] = 8
	pkmn4.ev[:SPEED] = 0
	#pkmn4.dynamax_able = false # Due to crashing issues from 2.0.0, Type Null cannot Dynamax at all
	pkmn4.calc_stats
	pbAddPokemonSilent(pkmn4)
	
	pkmn5 = Pokemon.new(:ARCEUS_17,100) # Tweaks to the Legend Plate mean Arceus's forms are obtainable without holding the type plates. Dark Form is chosen for Prankster Immunity, before the Legend Plate kicks in 
	pkmn5.item = :LEGENDPLATE # Changes Arceus to any optimal offense type when it uses Judgement
	pkmn5.ability_index = 0 # MULTITYPE
	pkmn5.nature = :MODEST
	pkmn5.learn_move(:JUDGMENT)
	pkmn5.learn_move(:NORETREAT)
	pkmn5.learn_move(:BATONPASS)
	pkmn5.learn_move(:TAUNT)
	pkmn5.ev[:HP] = 116
	pkmn5.ev[:ATTACK] = 116
	pkmn5.ev[:DEFENSE] = 76
	pkmn5.ev[:SPECIAL_DEFENSE] = 0
	pkmn5.ev[:SPEED] = 204
	pkmn5.tera_type = :POISON
	pkmn5.dynamax_able = false
	pkmn5.calc_stats # Refreshes this Pokemon, so the edits apply correctly
	pbAddPokemonSilent(pkmn5)
	
	pkmn6 = Pokemon.new(:UNOWN,100)
	pkmn6.item = :TERRAINEXTENDER
	pkmn6.ability_index = 1 # PUREPOWER
	pkmn6.nature = :TIMID
	pkmn6.learn_move(:EXPANDINGFORCE)
	pkmn6.learn_move(:EARTHPOWER)
	pkmn6.learn_move(:ROAROFTIME)
	pkmn6.learn_move(:AEROBLAST)
	pkmn6.ev[:HP] = 12
	pkmn6.ev[:ATTACK] = 68
	pkmn6.ev[:DEFENSE] = 204
	pkmn6.ev[:SPECIAL_DEFENSE] = 56
	pkmn6.ev[:SPEED] = 172
	pkmn6.tera_type = :PSYCHIC
	pkmn6.dynamax_able = false
	pkmn6.calc_stats
	pbAddPokemonSilent(pkmn6)
end

#===============================================================================

################################################################################
# 
# New Game Battle Mode setup (Takes care of all the basics required in one Script command)
# 
################################################################################

#===============================================================================
# Lvl.5 Battle Mode (Little Cup)
#===============================================================================
def pbBattleModeSetup5 
	$player.has_running_shoes = true	# Get this basic feature over and done with
	$player.has_pokegear = true			# Get this basic feature over and done with
	$player.has_exp_all = true 			# It is so dumb that $bag.has?(:EXPALL) is how features like this are handled. Decades has overhauled toggles like this, so they are actual player controlled toggles. Fuck Gen 9 for taking away the Set and Shift Option, and Gen 8 for taking away the Exp All Toggle.
	$player.pokedex.unlock(0) 			# Metagame Wiki Dex 
	$player.pokedex.unlock(1) 			# Organised PokeDex
	$player.pokedex.unlock(2) 			# Canon Mega Pokemon
	$player.pokedex.unlock(3) 			# Non Canon Mega Pokemon
	$player.pokedex.unlock(4) 			# All Moves/Abilities 
	$player.pokedex.unlock(5) 			# Normal Type Moves
	$player.pokedex.unlock(6) 			# Fire Type Moves
	$player.pokedex.unlock(7) 			# Fighting Type Moves
	$player.pokedex.unlock(8) 			# Water Type Moves
	$player.pokedex.unlock(9) 			# Flying Type Moves
	$player.pokedex.unlock(10) 			# Grass Type Moves
	$player.pokedex.unlock(11) 			# Poison Type Moves
	$player.pokedex.unlock(12) 			# Electric Type Moves
	$player.pokedex.unlock(13) 			# Ground Type Moves
	$player.pokedex.unlock(14) 			# Psychic Type Moves
	$player.pokedex.unlock(15) 			# Rock Type Moves
	$player.pokedex.unlock(16) 			# Ice Type Moves
	$player.pokedex.unlock(17) 			# Bug Type Moves
	$player.pokedex.unlock(18) 			# Dragon Type Moves
	$player.pokedex.unlock(19) 			# Ghost Type Moves
	$player.pokedex.unlock(20) 			# Dark Type Moves
	$player.pokedex.unlock(21) 			# Steel Type Moves
	$player.pokedex.unlock(22) 			# Fairy Type Moves
	$player.pokedex.unlock(23) 			# Non Level Evolution Pokemon (I refuse to make an online wiki I know damn well I cannot maintain)
	$player.pokedex.unlock(24) 			# Kanto Pokemon (This exists to allow People needing to find a specfic Pokemon from a region's game have an easier time finding them)
	$player.pokedex.unlock(25) 			# Johto Pokemon (This exists to allow People needing to find a specfic Pokemon from a region's game have an easier time finding them)
	$player.pokedex.unlock(26) 			# Hoenn Pokemon (This exists to allow People needing to find a specfic Pokemon from a region's game have an easier time finding them)
	$player.pokedex.unlock(27) 			# Sinnoh Pokemon (This exists to allow People needing to find a specfic Pokemon from a region's game have an easier time finding them)
	$player.pokedex.unlock(28) 			# Unova Pokemon (This exists to allow People needing to find a specfic Pokemon from a region's game have an easier time finding them)
	$player.pokedex.unlock(29) 			# Kalos Pokemon (This exists to allow People needing to find a specfic Pokemon from a region's game have an easier time finding them)
	$player.pokedex.unlock(30) 			# Alola Pokemon (This exists to allow People needing to find a specfic Pokemon from a region's game have an easier time finding them)
	$player.pokedex.unlock(31) 			# Galar Pokemon (This exists to allow People needing to find a specfic Pokemon from a region's game have an easier time finding them)
	$player.pokedex.unlock(32) 			# Paldea Pokemon (This exists to allow People needing to find a specfic Pokemon from a region's game have an easier time finding them)
	$player.pokedex.unlock(33) 			# Beatha Pokédex (I ended up needing to do this, to figure out what Pokemon are native to Beatha, in order to fill out the Safari and Mystery Zones, with Pokemon missing from Encounter Table 0)
	$player.pokedex.unlock(34) 			# No Clip Pokemon (This is where you can find Pokemon not native to the Beatha Region. Exists only to assist people who can't be fucked to use the Wild Adjuster)
	$player.pokedex.unlock(-1) 			# Gen 9 National Dex (0001 to 1025)
	$player.has_pokedex = true 			# Allows the player to have the dex (Do not forget to set [0029: Has National Dex] = ON above this script. Also set [0060: Pokedex Data Page] = ON above this script.
	$player.seen_storage_creator = true # Makes the Storage System display the creator's name as PSS (Pokemon Storage System)
	pbAllPokemonSetup5					# Gives every Pokemon's Base Form at Lvl.5, all 1025+ Pokemon, as of Gen 9 (The Form Trader Plugin deals with all Pokemon Forms)
	#pbClearAllPokemonSetup 			# Turned off for Battle Mode, use in Story Mode. Needed in Story Mode, to setup the Metagame Wiki Dex
	pbOptimisedPartyQuickStart5			# Gives the player a stock metagame Pokemon team, so they can jump straight in, if they cannot be fucked to fully train a Pokemon team
	

	# One of every Pokemon Form, as a failsafe/saving the player's time, if the Form Trader Plugin decides to stop working
	pbAddPokemonSilent(:RATTATA_1,5)
	pbAddPokemonSilent(:RATICATE_1,5)
	pbAddPokemonSilent(:PIKACHU_3,5)
	pbAddPokemonSilent(:PIKACHU_4,5)
	pbAddPokemonSilent(:PIKACHU_5,5)
	pbAddPokemonSilent(:PIKACHU_6,5)
	pbAddPokemonSilent(:PIKACHU_7,5)
	pbAddPokemonSilent(:PIKACHU_8,5)
	pbAddPokemonSilent(:PIKACHU_9,5)
	pbAddPokemonSilent(:PIKACHU_10,5)
	pbAddPokemonSilent(:PIKACHU_11,5)
	pbAddPokemonSilent(:PIKACHU_12,5)
	pbAddPokemonSilent(:PIKACHU_13,5)
	pbAddPokemonSilent(:PIKACHU_14,5)
	pbAddPokemonSilent(:PIKACHU_15,5)
	pbAddPokemonSilent(:RAICHU_1,5)
	pbAddPokemonSilent(:SANDSHREW_1,5)
	pbAddPokemonSilent(:SANDSLASH_1,5)
	pbAddPokemonSilent(:VULPIX_1,5)
	pbAddPokemonSilent(:NINETALES_1,5)
	pbAddPokemonSilent(:DIGLETT_1,5)
	pbAddPokemonSilent(:DUGTRIO_1,5)
	pbAddPokemonSilent(:MEOWTH_1,5)
	pbAddPokemonSilent(:MEOWTH_2,5)
	pbAddPokemonSilent(:PERSIAN_1,5)
	pbAddPokemonSilent(:GEODUDE_1,5)
	pbAddPokemonSilent(:GRAVELER_1,5)
	pbAddPokemonSilent(:GOLEM_1,5)
	pbAddPokemonSilent(:PONYTA_1,5)
	pbAddPokemonSilent(:RAPIDASH_1,5)
	pbAddPokemonSilent(:SLOWPOKE_1,5)
	pbAddPokemonSilent(:SLOWBRO_1,5)
	pbAddPokemonSilent(:FARFETCHD_1,5)
	pbAddPokemonSilent(:GRIMER_1,5)
	pbAddPokemonSilent(:MUK_1,5)
	pbAddPokemonSilent(:EXEGGUTOR_1,5)
	pbAddPokemonSilent(:MAROWAK_1,5)
	pbAddPokemonSilent(:WEEZING_1,5)
	pbAddPokemonSilent(:MRMIME_1,5)
	pbAddPokemonSilent(:ARTICUNO_1,5)
	pbAddPokemonSilent(:ZAPDOS_1,5)
	pbAddPokemonSilent(:MOLTRES_1,5)
	pbAddPokemonSilent(:PICHU_2,5)
	pbAddPokemonSilent(:SLOWKING_1,5)
	pbAddPokemonSilent(:CORSOLA_1,5)
	pbAddPokemonSilent(:ZIGZAGOON_1,5)
	pbAddPokemonSilent(:LINOONE_1,5)
	pbAddPokemonSilent(:CASTFORM_1,5)
	pbAddPokemonSilent(:CASTFORM_2,5)
	pbAddPokemonSilent(:CASTFORM_3,5)
	pbAddPokemonSilent(:DEOXYS_1,5)
	pbAddPokemonSilent(:DEOXYS_2,5)
	pbAddPokemonSilent(:DEOXYS_3,5)
	pbAddPokemonSilent(:WORMADAM_1,5)
	pbAddPokemonSilent(:WORMADAM_2,5)
	pbAddPokemonSilent(:ROTOM_1,5)
	pbAddPokemonSilent(:ROTOM_2,5)
	pbAddPokemonSilent(:ROTOM_3,5)
	pbAddPokemonSilent(:ROTOM_4,5)
	pbAddPokemonSilent(:ROTOM_5,5)
	pbAddPokemonSilent(:SHAYMIN_1,5)
	pbAddPokemonSilent(:ARCEUS_1,5)
	pbAddPokemonSilent(:ARCEUS_2,5)
	pbAddPokemonSilent(:ARCEUS_3,5)
	pbAddPokemonSilent(:ARCEUS_4,5)
	pbAddPokemonSilent(:ARCEUS_5,5)
	pbAddPokemonSilent(:ARCEUS_6,5)
	pbAddPokemonSilent(:ARCEUS_7,5)
	pbAddPokemonSilent(:ARCEUS_8,5)
	#pbAddPokemonSilent(:ARCEUS_9,5) This is the ??? Type form. Not added to the list, to avoid crashing issues with Dynamax
	pbAddPokemonSilent(:ARCEUS_10,5)
	pbAddPokemonSilent(:ARCEUS_11,5)
	pbAddPokemonSilent(:ARCEUS_12,5)
	pbAddPokemonSilent(:ARCEUS_13,5)
	pbAddPokemonSilent(:ARCEUS_14,5)
	pbAddPokemonSilent(:ARCEUS_15,5)
	pbAddPokemonSilent(:ARCEUS_16,5)
	pbAddPokemonSilent(:ARCEUS_17,5)
	pbAddPokemonSilent(:ARCEUS_18,5)
	pbAddPokemonSilent(:BASCULIN_1,5)
	pbAddPokemonSilent(:BASCULIN_2,5)
	pbAddPokemonSilent(:DARUMAKA_2,5)
	pbAddPokemonSilent(:DARMANITAN_2,5)
	pbAddPokemonSilent(:YAMASK_1,5)
	pbAddPokemonSilent(:SAWSBUCK,5)
	pbAddPokemonSilent(:SAWSBUCK_1,5)
	pbAddPokemonSilent(:SAWSBUCK_2,5)
	pbAddPokemonSilent(:SAWSBUCK_3,5)
	pbAddPokemonSilent(:STUNFISK_1,5)
	pbAddPokemonSilent(:KYUREM,5)
	pbAddPokemonSilent(:RESHIRAM,5)
	pbAddPokemonSilent(:KYUREM,5)
	pbAddPokemonSilent(:ZEKROM,5)
	pbAddPokemonSilent(:MELOETTA_1,5)
	pbAddPokemonSilent(:GENESECT_1,5)
	pbAddPokemonSilent(:GENESECT_2,5)
	pbAddPokemonSilent(:GENESECT_3,5)
	pbAddPokemonSilent(:GENESECT_4,5)
	pbAddPokemonSilent(:VIVILLON_1,5)
	pbAddPokemonSilent(:VIVILLON_2,5)
	pbAddPokemonSilent(:VIVILLON_3,5)
	pbAddPokemonSilent(:VIVILLON_6,5)
	pbAddPokemonSilent(:VIVILLON_7,5)
	pbAddPokemonSilent(:VIVILLON_9,5)
	pbAddPokemonSilent(:VIVILLON_10,5)
	pbAddPokemonSilent(:VIVILLON_12,5)
	pbAddPokemonSilent(:VIVILLON_14,5)
	pbAddPokemonSilent(:VIVILLON_16,5)
	pbAddPokemonSilent(:VIVILLON_17,5)
	pbAddPokemonSilent(:VIVILLON_18,5)
	pbAddPokemonSilent(:VIVILLON_19,5)
	pbAddPokemonSilent(:FLORGES_1,5)
	pbAddPokemonSilent(:FLORGES_2,5)
	pbAddPokemonSilent(:FLORGES_3,5)
	pbAddPokemonSilent(:FLORGES_4,5)
	pbAddPokemonSilent(:FURFROU_1,5)
	pbAddPokemonSilent(:FURFROU_2,5)
	pbAddPokemonSilent(:FURFROU_3,5)
	pbAddPokemonSilent(:FURFROU_4,5)
	pbAddPokemonSilent(:FURFROU_5,5)
	pbAddPokemonSilent(:FURFROU_6,5)
	pbAddPokemonSilent(:FURFROU_7,5)
	pbAddPokemonSilent(:FURFROU_8,5)
	pbAddPokemonSilent(:FURFROU_9,5)
	pbAddPokemonSilent(:HOOPA_1,5)
	pbAddPokemonSilent(:ORICORIO_1,5)
	pbAddPokemonSilent(:ORICORIO_2,5)
	pbAddPokemonSilent(:ORICORIO_3,5)
	pbAddPokemonSilent(:LYCANROC,5)
	pbAddPokemonSilent(:LYCANROC_1,5)
	pbAddPokemonSilent(:LYCANROC_2,5)
	pbAddPokemonSilent(:SILVALLY_1,5)
	pbAddPokemonSilent(:SILVALLY_2,5)
	pbAddPokemonSilent(:SILVALLY_3,5)
	pbAddPokemonSilent(:SILVALLY_4,5)
	pbAddPokemonSilent(:SILVALLY_5,5)
	pbAddPokemonSilent(:SILVALLY_6,5)
	pbAddPokemonSilent(:SILVALLY_7,5)
	pbAddPokemonSilent(:SILVALLY_8,5)
	#pbAddPokemonSilent(:SILVALLY_9,5) This is the ??? Type form. Not added to the list, to avoid crashing issues with Dynamax
	pbAddPokemonSilent(:SILVALLY_10,5)
	pbAddPokemonSilent(:SILVALLY_11,5)
	pbAddPokemonSilent(:SILVALLY_12,5)
	pbAddPokemonSilent(:SILVALLY_13,5)
	pbAddPokemonSilent(:SILVALLY_14,5)
	pbAddPokemonSilent(:SILVALLY_15,5)
	pbAddPokemonSilent(:SILVALLY_16,5)
	pbAddPokemonSilent(:SILVALLY_17,5)
	pbAddPokemonSilent(:SILVALLY_18,5)
	pbAddPokemonSilent(:MINIOR_7,5)
	pbAddPokemonSilent(:MINIOR_8,5)
	pbAddPokemonSilent(:MINIOR_9,5)
	pbAddPokemonSilent(:MINIOR_10,5)
	pbAddPokemonSilent(:MINIOR_11,5)
	pbAddPokemonSilent(:MINIOR_12,5)
	pbAddPokemonSilent(:MINIOR_13,5)
	pbAddPokemonSilent(:NECROZMA,5)
	pbAddPokemonSilent(:SOLGALEO,5)
	pbAddPokemonSilent(:NECROZMA,5)
	pbAddPokemonSilent(:LUNALA,5)
	pbAddPokemonSilent(:INDEEDEE_1,5)
	pbAddPokemonSilent(:KUBFU,5)
	pbAddPokemonSilent(:KUBFU,5)
	pbAddPokemonSilent(:CALYREX,5)
	pbAddPokemonSilent(:GLASTRIER,5)
	pbAddPokemonSilent(:CALYREX,5)
	pbAddPokemonSilent(:SPECTRIER,5)
	pbAddPokemonSilent(:TAUROS_1,5)
	pbAddPokemonSilent(:TAUROS_2,5)
	pbAddPokemonSilent(:TAUROS_3,5)
	pbAddPokemonSilent(:TYPHLOSION_1,5)
	pbAddPokemonSilent(:WOOPER_1,5)
	pbAddPokemonSilent(:QWILFISH_1,5)
	pbAddPokemonSilent(:SNEASEL_1,5)
	pbAddPokemonSilent(:SAMUROTT_1,5)
	pbAddPokemonSilent(:LILLIGANT_1,5)
	pbAddPokemonSilent(:BASCULIN_2,5)
	pbAddPokemonSilent(:ZORUA_1,5)
	pbAddPokemonSilent(:ZOROARK_1,5)
	pbAddPokemonSilent(:BRAVIARY_1,5)
	pbAddPokemonSilent(:SLIGGOO_1,5)
	pbAddPokemonSilent(:GOODRA_1,5)
	pbAddPokemonSilent(:AVALUGG_1,5)
	pbAddPokemonSilent(:DECIDUEYE_1,5)
	pbAddPokemonSilent(:URSALUNA_1,5)
	pbAddPokemonSilent(:REVAVROOM_1,5)
	pbAddPokemonSilent(:REVAVROOM_2,5)
	pbAddPokemonSilent(:REVAVROOM_3,5)
	pbAddPokemonSilent(:REVAVROOM_4,5)
	pbAddPokemonSilent(:REVAVROOM_5,5)
	pbAddPokemonSilent(:TATSUGIRI_1,5)
	pbAddPokemonSilent(:TATSUGIRI_2,5)
	pbAddPokemonSilent(:GIMMIGHOUL_1,5)
	pbAddPokemonSilent(:LUGIA_1,5)
	pbAddPokemonSilent(:MAGEARNA_1,5)
	
	# The playtester/time saving metagame teams. This consists of Gen 1-9 Starter Teams, 18 Monotype teams, 4 Weather teams, and an ultimate team, making for a total of 52 Pokemon teams, or 312 Fully optimsed Pokemon.
	# This exists to save time setting up a variety of competitive teams, and to make sure as much as possible is poked around in, rather than just using the stock metagame teams
	
	# Gen 1 Teams (6 Starters)
	pbOptimisedGen1GrassPartyQuickStart5
	pbOptimisedGen1FirePartyQuickStart5
	pbOptimisedGen1WaterPartyQuickStart5
	pbOptimisedGen1ElectricPartyQuickStart5
	pbOptimisedGen1FairyPartyQuickStart5
	pbOptimisedGen1NormalPartyQuickStart5
	
	# Gen 2 Teams (3 Starters)
	pbOptimisedGen2GrassPartyQuickStart5
	pbOptimisedGen2FirePartyQuickStart5
	pbOptimisedGen2WaterPartyQuickStart5
	
	# Gen 3 Teams (3 Starters)
	pbOptimisedGen3GrassPartyQuickStart5
	pbOptimisedGen3FirePartyQuickStart5
	pbOptimisedGen3WaterPartyQuickStart5
	
	# Gen 4 Teams (3 Starters)
	pbOptimisedGen4GrassPartyQuickStart5
	pbOptimisedGen4FirePartyQuickStart5
	pbOptimisedGen4WaterPartyQuickStart5
	
	# Gen 5 Teams (3 Starters)
	pbOptimisedGen5GrassPartyQuickStart5
	pbOptimisedGen5FirePartyQuickStart5
	pbOptimisedGen5WaterPartyQuickStart5
	
	# Gen 6 Teams (3 Starters)
	pbOptimisedGen6GrassPartyQuickStart5
	pbOptimisedGen6FirePartyQuickStart5
	pbOptimisedGen6WaterPartyQuickStart5
	
	# Gen 7 Teams (3 Starters)
	pbOptimisedGen7GrassPartyQuickStart5
	pbOptimisedGen7FirePartyQuickStart5
	pbOptimisedGen7WaterPartyQuickStart5
	
	# Gen 8 Teams (3 Starters)
	pbOptimisedGen8GrassPartyQuickStart5
	pbOptimisedGen8FirePartyQuickStart5
	pbOptimisedGen8WaterPartyQuickStart5
	
	# Gen 9 Teams (6 Starters)
	pbOptimisedGen9GrassPartyQuickStart5
	pbOptimisedGen9FirePartyQuickStart5
	pbOptimisedGen9WaterPartyQuickStart5
	
	pbOptimisedGen9FightingPartyQuickStart5
	pbOptimisedGen9GhostPartyQuickStart5
	pbOptimisedGen9DarkPartyQuickStart5
	
	# Mono Type Teams (18 Dedicated Type Teams)
	pbOptimisedMonoNormalPartyQuickStart5
	pbOptimisedMonoFightingPartyQuickStart5
	pbOptimisedMonoFlyingPartyQuickStart5
	
	pbOptimisedMonoPoisonPartyQuickStart5
	pbOptimisedMonoGroundPartyQuickStart5
	pbOptimisedMonoRockPartyQuickStart5
	
	pbOptimisedMonoBugPartyQuickStart5
	pbOptimisedMonoGhostPartyQuickStart5
	pbOptimisedMonoSteelPartyQuickStart5
	
	pbOptimisedMonoFirePartyQuickStart5
	pbOptimisedMonoWaterPartyQuickStart5
	pbOptimisedMonoGrassPartyQuickStart5
	
	pbOptimisedMonoElectricPartyQuickStart5
	pbOptimisedMonoPsychicPartyQuickStart5
	pbOptimisedMonoIcePartyQuickStart5
	
	pbOptimisedMonoDragonPartyQuickStart5
	pbOptimisedMonoDarkPartyQuickStart5
	pbOptimisedMonoFairyPartyQuickStart5
	
	# Weather Teams (4 Weathers)
	pbOptimisedRainWeatherPartyQuickStart5
	pbOptimisedSunWeatherPartyQuickStart5
	pbOptimisedSandstormPartyQuickStart5
	pbOptimisedHailstormPartyQuickStart5
	
	# Ultimate Team (Arceus's Legend Plate and Stellar Terapagos. And 4 Poke Gods for good measure)
	pbOptimisedUtimatePartyQuickStart5
	
	pbAddPokemonSilent(:FLOETTE_5,5) # I ended up forgetting about this one until now. Was until this point the only Pokemon missing. Added here, to not mess up the ordering of teams in the PSS
	
	# All PSS Wallpapers (Why are they not unlocked the second New Game is chosen?)
	pbUnlockWallpaper(16)
	pbUnlockWallpaper(17)
	pbUnlockWallpaper(18)
	pbUnlockWallpaper(19)
	pbUnlockWallpaper(20)
	pbUnlockWallpaper(21)
	pbUnlockWallpaper(22)
	pbUnlockWallpaper(23)
	pbUnlockWallpaper(24)
	pbUnlockWallpaper(25)
	pbUnlockWallpaper(26)
	pbUnlockWallpaper(27)
	pbUnlockWallpaper(28)
	pbUnlockWallpaper(29)
	pbUnlockWallpaper(30)
	pbUnlockWallpaper(31)
	pbUnlockWallpaper(32)
	pbUnlockWallpaper(33)
	pbUnlockWallpaper(34)
	pbUnlockWallpaper(35)
	pbUnlockWallpaper(36)
	pbUnlockWallpaper(37)
	pbUnlockWallpaper(38)
	pbUnlockWallpaper(39)
	pbUnlockWallpaper(40)
	pbUnlockWallpaper(41)
	pbUnlockWallpaper(42)
	pbUnlockWallpaper(43)
	pbUnlockWallpaper(44)
	pbUnlockWallpaper(45)
	pbUnlockWallpaper(46)
	pbUnlockWallpaper(47)
	pbUnlockWallpaper(48)
	pbUnlockWallpaper(49)
	pbUnlockWallpaper(50)
	pbUnlockWallpaper(51)
	pbUnlockWallpaper(52)
	pbUnlockWallpaper(53)
	pbUnlockWallpaper(54)
	pbUnlockWallpaper(55)
	pbUnlockWallpaper(56)
	pbUnlockWallpaper(57)
	pbUnlockWallpaper(58)
	pbUnlockWallpaper(59)
	
	# In the Event command after all the above is done, set up the following Switches/Variables:
	# [0034: (2) Ultimate Move Tutor] = ON (Sets up The Gen 9 More Relearner System, enhanced by Ultimate Move Tutor)
	# [0062: SOS Battles] = ON (The SOS Battle feature is active)
	# [0067: Dynamax On Any Map] = ON (Dynamax can be used anywhere. Makes using Megas, Z-Moves, Dynamax and Teras back to back a lot easier)
	# [0078: Level Scale Constant] = 100 (The default Level Scale Constant. Manual Level Scaling is required for Battle Mode)
	
	# Give the player every item, so no extra setup work in the map is required
	pbPumbInAllItems # Up to you to use this easy method, or setup a Poke Mart with Arcky's Poke Mart Plugin
end

#===============================================================================
# Lvl.30 Battle Mode (NFE Cup, Not Fully Evolved)
#===============================================================================
def pbBattleModeSetup30 
	$player.has_running_shoes = true	# Get this basic feature over and done with
	$player.has_pokegear = true			# Get this basic feature over and done with
	$player.has_exp_all = true 			# It is so dumb that $bag.has?(:EXPALL) is how features like this are handled. Decades has overhauled toggles like this, so they are actual player controlled toggles. Fuck Gen 9 for taking away the Set and Shift Option, and Gen 8 for taking away the Exp All Toggle.
	$player.pokedex.unlock(0) 			# Metagame Wiki Dex 
	$player.pokedex.unlock(1) 			# Organised PokeDex
	$player.pokedex.unlock(2) 			# Canon Mega Pokemon
	$player.pokedex.unlock(3) 			# Non Canon Mega Pokemon
	$player.pokedex.unlock(4) 			# All Moves/Abilities 
	$player.pokedex.unlock(5) 			# Normal Type Moves
	$player.pokedex.unlock(6) 			# Fire Type Moves
	$player.pokedex.unlock(7) 			# Fighting Type Moves
	$player.pokedex.unlock(8) 			# Water Type Moves
	$player.pokedex.unlock(9) 			# Flying Type Moves
	$player.pokedex.unlock(10) 			# Grass Type Moves
	$player.pokedex.unlock(11) 			# Poison Type Moves
	$player.pokedex.unlock(12) 			# Electric Type Moves
	$player.pokedex.unlock(13) 			# Ground Type Moves
	$player.pokedex.unlock(14) 			# Psychic Type Moves
	$player.pokedex.unlock(15) 			# Rock Type Moves
	$player.pokedex.unlock(16) 			# Ice Type Moves
	$player.pokedex.unlock(17) 			# Bug Type Moves
	$player.pokedex.unlock(18) 			# Dragon Type Moves
	$player.pokedex.unlock(19) 			# Ghost Type Moves
	$player.pokedex.unlock(20) 			# Dark Type Moves
	$player.pokedex.unlock(21) 			# Steel Type Moves
	$player.pokedex.unlock(22) 			# Fairy Type Moves
	$player.pokedex.unlock(23) 			# Non Level Evolution Pokemon (I refuse to make an online wiki I know damn well I cannot maintain)
	$player.pokedex.unlock(24) 		# Kanto Pokemon (This exists to allow People needing to find a specfic Pokemon from a region's game have an easier time finding them)
	$player.pokedex.unlock(25) 			# Johto Pokemon (This exists to allow People needing to find a specfic Pokemon from a region's game have an easier time finding them)
	$player.pokedex.unlock(26) 			# Hoenn Pokemon (This exists to allow People needing to find a specfic Pokemon from a region's game have an easier time finding them)
	$player.pokedex.unlock(27) 			# Sinnoh Pokemon (This exists to allow People needing to find a specfic Pokemon from a region's game have an easier time finding them)
	$player.pokedex.unlock(28) 			# Unova Pokemon (This exists to allow People needing to find a specfic Pokemon from a region's game have an easier time finding them)
	$player.pokedex.unlock(29) 			# Kalos Pokemon (This exists to allow People needing to find a specfic Pokemon from a region's game have an easier time finding them)
	$player.pokedex.unlock(30) 			# Alola Pokemon (This exists to allow People needing to find a specfic Pokemon from a region's game have an easier time finding them)
	$player.pokedex.unlock(31) 			# Galar Pokemon (This exists to allow People needing to find a specfic Pokemon from a region's game have an easier time finding them)
	$player.pokedex.unlock(32) 			# Paldea Pokemon (This exists to allow People needing to find a specfic Pokemon from a region's game have an easier time finding them)
	$player.pokedex.unlock(33) 			# Beatha Pokédex (I ended up needing to do this, to figure out what Pokemon are native to Beatha, in order to fill out the Safari and Mystery Zones, with Pokemon missing from Encounter Table 0)
	$player.pokedex.unlock(34) 			# No Clip Pokemon (This is where you can find Pokemon not native to the Beatha Region. Exists only to assist people who can't be fucked to use the Wild Adjuster)
	$player.pokedex.unlock(-1) 			# Gen 9 National Dex (0001 to 1025)
	$player.has_pokedex = true 			# Allows the player to have the dex (Do not forget to set [0029: Has National Dex] = ON above this script. Also set [0060: Pokedex Data Page] = ON above this script.
	$player.seen_storage_creator = true # Makes the Storage System display the creator's name as PSS (Pokemon Storage System)
	pbAllPokemonSetup30					# Gives every Pokemon's Base Form at Lvl.5, all 1025+ Pokemon, as of Gen 9 (The Form Trader Plugin deals with all Pokemon Forms)
	#pbClearAllPokemonSetup 			# Turned off for Battle Mode, use in Story Mode. Needed in Story Mode, to setup the Metagame Wiki Dex
	pbOptimisedPartyQuickStart30		# Gives the player a stock metagame Pokemon team, so they can jump straight in, if they cannot be fucked to fully train a Pokemon team

	# One of every Pokemon Form, as a failsafe/saving the player's time, if the Form Trader Plugin decides to stop working
	pbAddPokemonSilent(:RATTATA_1,30)
	pbAddPokemonSilent(:RATICATE_1,30)
	pbAddPokemonSilent(:PIKACHU_3,30)
	pbAddPokemonSilent(:PIKACHU_4,30)
	pbAddPokemonSilent(:PIKACHU_5,30)
	pbAddPokemonSilent(:PIKACHU_6,30)
	pbAddPokemonSilent(:PIKACHU_7,30)
	pbAddPokemonSilent(:PIKACHU_8,30)
	pbAddPokemonSilent(:PIKACHU_9,30)
	pbAddPokemonSilent(:PIKACHU_10,30)
	pbAddPokemonSilent(:PIKACHU_11,30)
	pbAddPokemonSilent(:PIKACHU_12,30)
	pbAddPokemonSilent(:PIKACHU_13,30)
	pbAddPokemonSilent(:PIKACHU_14,30)
	pbAddPokemonSilent(:PIKACHU_15,30)
	pbAddPokemonSilent(:RAICHU_1,30)
	pbAddPokemonSilent(:SANDSHREW_1,30)
	pbAddPokemonSilent(:SANDSLASH_1,30)
	pbAddPokemonSilent(:VULPIX_1,30)
	pbAddPokemonSilent(:NINETALES_1,30)
	pbAddPokemonSilent(:DIGLETT_1,30)
	pbAddPokemonSilent(:DUGTRIO_1,30)
	pbAddPokemonSilent(:MEOWTH_1,30)
	pbAddPokemonSilent(:MEOWTH_2,30)
	pbAddPokemonSilent(:PERSIAN_1,30)
	pbAddPokemonSilent(:GEODUDE_1,30)
	pbAddPokemonSilent(:GRAVELER_1,30)
	pbAddPokemonSilent(:GOLEM_1,30)
	pbAddPokemonSilent(:PONYTA_1,30)
	pbAddPokemonSilent(:RAPIDASH_1,30)
	pbAddPokemonSilent(:SLOWPOKE_1,30)
	pbAddPokemonSilent(:SLOWBRO_1,30)
	pbAddPokemonSilent(:FARFETCHD_1,30)
	pbAddPokemonSilent(:GRIMER_1,30)
	pbAddPokemonSilent(:MUK_1,30)
	pbAddPokemonSilent(:EXEGGUTOR_1,30)
	pbAddPokemonSilent(:MAROWAK_1,30)
	pbAddPokemonSilent(:WEEZING_1,30)
	pbAddPokemonSilent(:MRMIME_1,30)
	pbAddPokemonSilent(:ARTICUNO_1,30)
	pbAddPokemonSilent(:ZAPDOS_1,30)
	pbAddPokemonSilent(:MOLTRES_1,30)
	pbAddPokemonSilent(:PICHU_2,30)
	pbAddPokemonSilent(:SLOWKING_1,30)
	pbAddPokemonSilent(:CORSOLA_1,30)
	pbAddPokemonSilent(:ZIGZAGOON_1,30)
	pbAddPokemonSilent(:LINOONE_1,30)
	pbAddPokemonSilent(:CASTFORM_1,30)
	pbAddPokemonSilent(:CASTFORM_2,30)
	pbAddPokemonSilent(:CASTFORM_3,30)
	pbAddPokemonSilent(:DEOXYS_1,30)
	pbAddPokemonSilent(:DEOXYS_2,30)
	pbAddPokemonSilent(:DEOXYS_3,30)
	pbAddPokemonSilent(:WORMADAM_1,30)
	pbAddPokemonSilent(:WORMADAM_2,30)
	pbAddPokemonSilent(:ROTOM_1,30)
	pbAddPokemonSilent(:ROTOM_2,30)
	pbAddPokemonSilent(:ROTOM_3,30)
	pbAddPokemonSilent(:ROTOM_4,30)
	pbAddPokemonSilent(:ROTOM_5,30)
	pbAddPokemonSilent(:SHAYMIN_1,30)
	pbAddPokemonSilent(:ARCEUS_1,30)
	pbAddPokemonSilent(:ARCEUS_2,30)
	pbAddPokemonSilent(:ARCEUS_3,30)
	pbAddPokemonSilent(:ARCEUS_4,30)
	pbAddPokemonSilent(:ARCEUS_5,30)
	pbAddPokemonSilent(:ARCEUS_6,30)
	pbAddPokemonSilent(:ARCEUS_7,30)
	pbAddPokemonSilent(:ARCEUS_8,30)
	#pbAddPokemonSilent(:ARCEUS_9,5) This is the ??? Type form. Not added to the list, to avoid crashing issues with Dynamax
	pbAddPokemonSilent(:ARCEUS_10,30)
	pbAddPokemonSilent(:ARCEUS_11,30)
	pbAddPokemonSilent(:ARCEUS_12,30)
	pbAddPokemonSilent(:ARCEUS_13,30)
	pbAddPokemonSilent(:ARCEUS_14,30)
	pbAddPokemonSilent(:ARCEUS_15,30)
	pbAddPokemonSilent(:ARCEUS_16,30)
	pbAddPokemonSilent(:ARCEUS_17,30)
	pbAddPokemonSilent(:ARCEUS_18,30)
	pbAddPokemonSilent(:BASCULIN_1,30)
	pbAddPokemonSilent(:BASCULIN_2,30)
	pbAddPokemonSilent(:DARUMAKA_2,30)
	pbAddPokemonSilent(:DARMANITAN_2,30)
	pbAddPokemonSilent(:YAMASK_1,30)
	pbAddPokemonSilent(:SAWSBUCK,30)
	pbAddPokemonSilent(:SAWSBUCK_1,30)
	pbAddPokemonSilent(:SAWSBUCK_2,30)
	pbAddPokemonSilent(:SAWSBUCK_3,30)
	pbAddPokemonSilent(:STUNFISK_1,30)
	pbAddPokemonSilent(:KYUREM,30)
	pbAddPokemonSilent(:RESHIRAM,30)
	pbAddPokemonSilent(:KYUREM,30)
	pbAddPokemonSilent(:ZEKROM,30)
	pbAddPokemonSilent(:MELOETTA_1,30)
	pbAddPokemonSilent(:GENESECT_1,30)
	pbAddPokemonSilent(:GENESECT_2,30)
	pbAddPokemonSilent(:GENESECT_3,30)
	pbAddPokemonSilent(:GENESECT_4,30)
	pbAddPokemonSilent(:VIVILLON_1,30)
	pbAddPokemonSilent(:VIVILLON_2,30)
	pbAddPokemonSilent(:VIVILLON_3,30)
	pbAddPokemonSilent(:VIVILLON_6,30)
	pbAddPokemonSilent(:VIVILLON_7,30)
	pbAddPokemonSilent(:VIVILLON_9,30)
	pbAddPokemonSilent(:VIVILLON_10,30)
	pbAddPokemonSilent(:VIVILLON_12,30)
	pbAddPokemonSilent(:VIVILLON_14,30)
	pbAddPokemonSilent(:VIVILLON_16,30)
	pbAddPokemonSilent(:VIVILLON_17,30)
	pbAddPokemonSilent(:VIVILLON_18,30)
	pbAddPokemonSilent(:VIVILLON_19,30)
	pbAddPokemonSilent(:FLORGES_1,30)
	pbAddPokemonSilent(:FLORGES_2,30)
	pbAddPokemonSilent(:FLORGES_3,30)
	pbAddPokemonSilent(:FLORGES_4,30)
	pbAddPokemonSilent(:FURFROU_1,30)
	pbAddPokemonSilent(:FURFROU_2,30)
	pbAddPokemonSilent(:FURFROU_3,30)
	pbAddPokemonSilent(:FURFROU_4,30)
	pbAddPokemonSilent(:FURFROU_5,30)
	pbAddPokemonSilent(:FURFROU_6,30)
	pbAddPokemonSilent(:FURFROU_7,30)
	pbAddPokemonSilent(:FURFROU_8,30)
	pbAddPokemonSilent(:FURFROU_9,30)
	pbAddPokemonSilent(:HOOPA_1,30)
	pbAddPokemonSilent(:ORICORIO_1,30)
	pbAddPokemonSilent(:ORICORIO_2,30)
	pbAddPokemonSilent(:ORICORIO_3,30)
	pbAddPokemonSilent(:LYCANROC,30)
	pbAddPokemonSilent(:LYCANROC_1,30)
	pbAddPokemonSilent(:LYCANROC_2,30)
	pbAddPokemonSilent(:SILVALLY_1,30)
	pbAddPokemonSilent(:SILVALLY_2,30)
	pbAddPokemonSilent(:SILVALLY_3,30)
	pbAddPokemonSilent(:SILVALLY_4,30)
	pbAddPokemonSilent(:SILVALLY_5,30)
	pbAddPokemonSilent(:SILVALLY_6,30)
	pbAddPokemonSilent(:SILVALLY_7,30)
	pbAddPokemonSilent(:SILVALLY_8,30)
	#pbAddPokemonSilent(:ARCEUS_9,5) This is the ??? Type form. Not added to the list, to avoid crashing issues with Dynamax
	pbAddPokemonSilent(:SILVALLY_10,30)
	pbAddPokemonSilent(:SILVALLY_11,30)
	pbAddPokemonSilent(:SILVALLY_12,30)
	pbAddPokemonSilent(:SILVALLY_13,30)
	pbAddPokemonSilent(:SILVALLY_14,30)
	pbAddPokemonSilent(:SILVALLY_15,30)
	pbAddPokemonSilent(:SILVALLY_16,30)
	pbAddPokemonSilent(:SILVALLY_17,30)
	pbAddPokemonSilent(:SILVALLY_18,30)
	pbAddPokemonSilent(:MINIOR_7,30)
	pbAddPokemonSilent(:MINIOR_8,30)
	pbAddPokemonSilent(:MINIOR_9,30)
	pbAddPokemonSilent(:MINIOR_10,30)
	pbAddPokemonSilent(:MINIOR_11,30)
	pbAddPokemonSilent(:MINIOR_12,30)
	pbAddPokemonSilent(:MINIOR_13,30)
	pbAddPokemonSilent(:NECROZMA,30)
	pbAddPokemonSilent(:SOLGALEO,30)
	pbAddPokemonSilent(:NECROZMA,30)
	pbAddPokemonSilent(:LUNALA,30)
	pbAddPokemonSilent(:INDEEDEE_1,30)
	pbAddPokemonSilent(:KUBFU,30)
	pbAddPokemonSilent(:KUBFU,30)
	pbAddPokemonSilent(:CALYREX,30)
	pbAddPokemonSilent(:GLASTRIER,30)
	pbAddPokemonSilent(:CALYREX,30)
	pbAddPokemonSilent(:SPECTRIER,30)
	pbAddPokemonSilent(:TAUROS_1,30)
	pbAddPokemonSilent(:TAUROS_2,30)
	pbAddPokemonSilent(:TAUROS_3,30)
	pbAddPokemonSilent(:TYPHLOSION_1,30)
	pbAddPokemonSilent(:WOOPER_1,30)
	pbAddPokemonSilent(:QWILFISH_1,30)
	pbAddPokemonSilent(:SNEASEL_1,30)
	pbAddPokemonSilent(:SAMUROTT_1,30)
	pbAddPokemonSilent(:LILLIGANT_1,30)
	pbAddPokemonSilent(:BASCULIN_2,30)
	pbAddPokemonSilent(:ZORUA_1,30)
	pbAddPokemonSilent(:ZOROARK_1,30)
	pbAddPokemonSilent(:BRAVIARY_1,30)
	pbAddPokemonSilent(:SLIGGOO_1,30)
	pbAddPokemonSilent(:GOODRA_1,30)
	pbAddPokemonSilent(:AVALUGG_1,30)
	pbAddPokemonSilent(:DECIDUEYE_1,30)
	pbAddPokemonSilent(:URSALUNA_1,30)
	pbAddPokemonSilent(:REVAVROOM_1,30)
	pbAddPokemonSilent(:REVAVROOM_2,30)
	pbAddPokemonSilent(:REVAVROOM_3,30)
	pbAddPokemonSilent(:REVAVROOM_4,30)
	pbAddPokemonSilent(:REVAVROOM_5,30)
	pbAddPokemonSilent(:TATSUGIRI_1,30)
	pbAddPokemonSilent(:TATSUGIRI_2,30)
	pbAddPokemonSilent(:GIMMIGHOUL_1,30)
	pbAddPokemonSilent(:LUGIA_1,30)
	pbAddPokemonSilent(:MAGEARNA_1,30)
	#pbAddPokemonSilent(:FLOETTE_5,30) # I ended up forgetting about this one until now. Was until this point the only Pokemon missing
	
	# The playtester/time saving metagame teams. This consists of Gen 1-9 Starter Teams, 18 Monotype teams, 4 Weather teams, and an ultimate team, making for a total of 52 Pokemon teams, or 312 Fully optimsed Pokemon.
	# This exists to save time setting up a variety of competitive teams, and to make sure as much as possible is poked around in, rather than just using the stock metagame teams
	
	# Gen 1 Teams (6 Starters)
	pbOptimisedGen1GrassPartyQuickStart30
	pbOptimisedGen1FirePartyQuickStart30
	pbOptimisedGen1WaterPartyQuickStart30
	pbOptimisedGen1ElectricPartyQuickStart30
	pbOptimisedGen1FairyPartyQuickStart30
	pbOptimisedGen1NormalPartyQuickStart30
	
	# Gen 2 Teams (3 Starters)
	pbOptimisedGen2GrassPartyQuickStart30
	pbOptimisedGen2FirePartyQuickStart30
	pbOptimisedGen2WaterPartyQuickStart30
	
	# Gen 3 Teams (3 Starters)
	pbOptimisedGen3GrassPartyQuickStart30
	pbOptimisedGen3FirePartyQuickStart30
	pbOptimisedGen3WaterPartyQuickStart30
	
	# Gen 4 Teams (3 Starters)
	pbOptimisedGen4GrassPartyQuickStart30
	pbOptimisedGen4FirePartyQuickStart30
	pbOptimisedGen4WaterPartyQuickStart30
	
	# Gen 5 Teams (3 Starters)
	pbOptimisedGen5GrassPartyQuickStart30
	pbOptimisedGen5FirePartyQuickStart30
	pbOptimisedGen5WaterPartyQuickStart30
	
	# Gen 6 Teams (3 Starters)
	pbOptimisedGen6GrassPartyQuickStart30
	pbOptimisedGen6FirePartyQuickStart30
	pbOptimisedGen6WaterPartyQuickStart30
	
	# Gen 7 Teams (3 Starters)
	pbOptimisedGen7GrassPartyQuickStart30
	pbOptimisedGen7FirePartyQuickStart30
	pbOptimisedGen7WaterPartyQuickStart30
	
	# Gen 8 Teams (3 Starters)
	pbOptimisedGen8GrassPartyQuickStart30
	pbOptimisedGen8FirePartyQuickStart30
	pbOptimisedGen8WaterPartyQuickStart30
	
	# Gen 9 Teams (6 Starters)
	pbOptimisedGen9GrassPartyQuickStart30
	pbOptimisedGen9FirePartyQuickStart30
	pbOptimisedGen9WaterPartyQuickStart30
	
	pbOptimisedGen9FightingPartyQuickStart30
	pbOptimisedGen9GhostPartyQuickStart30
	pbOptimisedGen9DarkPartyQuickStart30
	
	# Mono Type Teams (18 Dedicated Type Teams)
	pbOptimisedMonoNormalPartyQuickStart30
	pbOptimisedMonoFightingPartyQuickStart30
	pbOptimisedMonoFlyingPartyQuickStart30
	
	pbOptimisedMonoPoisonPartyQuickStart30
	pbOptimisedMonoGroundPartyQuickStart30
	pbOptimisedMonoRockPartyQuickStart30
	
	pbOptimisedMonoBugPartyQuickStart30
	pbOptimisedMonoGhostPartyQuickStart30
	pbOptimisedMonoSteelPartyQuickStart30
	
	pbOptimisedMonoFirePartyQuickStart30
	pbOptimisedMonoWaterPartyQuickStart30
	pbOptimisedMonoGrassPartyQuickStart30
	
	pbOptimisedMonoElectricPartyQuickStart30
	pbOptimisedMonoPsychicPartyQuickStart30
	pbOptimisedMonoIcePartyQuickStart30
	
	pbOptimisedMonoDragonPartyQuickStart30
	pbOptimisedMonoDarkPartyQuickStart30
	pbOptimisedMonoFairyPartyQuickStart30
	
	# Weather Teams (4 Weathers)
	pbOptimisedRainWeatherPartyQuickStart30
	pbOptimisedSunWeatherPartyQuickStart30
	pbOptimisedSandstormPartyQuickStart30
	pbOptimisedHailstormPartyQuickStart30
	
	# Ultimate Team (Arceus's Legend Plate and Stellar Terapagos. And 4 Poke Gods for good measure)
	pbOptimisedUtimatePartyQuickStart30
	
	pbAddPokemonSilent(:FLOETTE_5,30) # I ended up forgetting about this one until now. Was until this point the only Pokemon missing. Added here, to not mess up the ordering of teams in the PSS
	
	# All PSS Wallpapers (Why are they not unlocked the second New Game is chosen?)
	pbUnlockWallpaper(16)
	pbUnlockWallpaper(17)
	pbUnlockWallpaper(18)
	pbUnlockWallpaper(19)
	pbUnlockWallpaper(20)
	pbUnlockWallpaper(21)
	pbUnlockWallpaper(22)
	pbUnlockWallpaper(23)
	pbUnlockWallpaper(24)
	pbUnlockWallpaper(25)
	pbUnlockWallpaper(26)
	pbUnlockWallpaper(27)
	pbUnlockWallpaper(28)
	pbUnlockWallpaper(29)
	pbUnlockWallpaper(30)
	pbUnlockWallpaper(31)
	pbUnlockWallpaper(32)
	pbUnlockWallpaper(33)
	pbUnlockWallpaper(34)
	pbUnlockWallpaper(35)
	pbUnlockWallpaper(36)
	pbUnlockWallpaper(37)
	pbUnlockWallpaper(38)
	pbUnlockWallpaper(39)
	pbUnlockWallpaper(40)
	pbUnlockWallpaper(41)
	pbUnlockWallpaper(42)
	pbUnlockWallpaper(43)
	pbUnlockWallpaper(44)
	pbUnlockWallpaper(45)
	pbUnlockWallpaper(46)
	pbUnlockWallpaper(47)
	pbUnlockWallpaper(48)
	pbUnlockWallpaper(49)
	pbUnlockWallpaper(50)
	pbUnlockWallpaper(51)
	pbUnlockWallpaper(52)
	pbUnlockWallpaper(53)
	pbUnlockWallpaper(54)
	pbUnlockWallpaper(55)
	pbUnlockWallpaper(56)
	pbUnlockWallpaper(57)
	pbUnlockWallpaper(58)
	pbUnlockWallpaper(59)
	
	# In the Event command after all the above is done, set up the following Switches/Variables:
	# [0034: (2) Ultimate Move Tutor] = ON (Sets up The Gen 9 More Relearner System, enhanced by Ultimate Move Tutor)
	# [0062: SOS Battles] = ON (The SOS Battle feature is active)
	# [0067: Dynamax On Any Map] = ON (Dynamax can be used anywhere. Makes using Megas, Z-Moves, Dynamax and Teras back to back a lot easier)
	# [0078: Level Scale Constant] = 100 (The default Level Scale Constant. Manual Level Scaling is required for Battle Mode)
	
	# Give the player every item, so no extra setup work in the map is required
	pbPumbInAllItems # Up to you to use this easy method, or setup a Poke Mart with Arcky's Poke Mart Plugin
end

#===============================================================================
# Lvl.50 Battle Mode (VGC Cup)
#===============================================================================
def pbBattleModeSetup50 
	$player.has_running_shoes = true	# Get this basic feature over and done with
	$player.has_pokegear = true			# Get this basic feature over and done with
	$player.has_exp_all = true 			# It is so dumb that $bag.has?(:EXPALL) is how features like this are handled. Decades has overhauled toggles like this, so they are actual player controlled toggles. Fuck Gen 9 for taking away the Set and Shift Option, and Gen 8 for taking away the Exp All Toggle.
	$player.pokedex.unlock(0) 			# Metagame Wiki Dex 
	$player.pokedex.unlock(1) 			# Organised PokeDex
	$player.pokedex.unlock(2) 			# Canon Mega Pokemon
	$player.pokedex.unlock(3) 			# Non Canon Mega Pokemon
	$player.pokedex.unlock(4) 			# All Moves/Abilities 
	$player.pokedex.unlock(5) 			# Normal Type Moves
	$player.pokedex.unlock(6) 			# Fire Type Moves
	$player.pokedex.unlock(7) 			# Fighting Type Moves
	$player.pokedex.unlock(8) 			# Water Type Moves
	$player.pokedex.unlock(9) 			# Flying Type Moves
	$player.pokedex.unlock(10) 			# Grass Type Moves
	$player.pokedex.unlock(11) 			# Poison Type Moves
	$player.pokedex.unlock(12) 			# Electric Type Moves
	$player.pokedex.unlock(13) 			# Ground Type Moves
	$player.pokedex.unlock(14) 			# Psychic Type Moves
	$player.pokedex.unlock(15) 			# Rock Type Moves
	$player.pokedex.unlock(16) 			# Ice Type Moves
	$player.pokedex.unlock(17) 			# Bug Type Moves
	$player.pokedex.unlock(18) 			# Dragon Type Moves
	$player.pokedex.unlock(19) 			# Ghost Type Moves
	$player.pokedex.unlock(20) 			# Dark Type Moves
	$player.pokedex.unlock(21) 			# Steel Type Moves
	$player.pokedex.unlock(22) 			# Fairy Type Moves
	$player.pokedex.unlock(23) 			# Non Level Evolution Pokemon (I refuse to make an online wiki I know damn well I cannot maintain)
	$player.pokedex.unlock(24) 			# Kanto Pokemon (This exists to allow People needing to find a specfic Pokemon from a region's game have an easier time finding them)
	$player.pokedex.unlock(25) 			# Johto Pokemon (This exists to allow People needing to find a specfic Pokemon from a region's game have an easier time finding them)
	$player.pokedex.unlock(26) 			# Hoenn Pokemon (This exists to allow People needing to find a specfic Pokemon from a region's game have an easier time finding them)
	$player.pokedex.unlock(27) 			# Sinnoh Pokemon (This exists to allow People needing to find a specfic Pokemon from a region's game have an easier time finding them)
	$player.pokedex.unlock(28) 			# Unova Pokemon (This exists to allow People needing to find a specfic Pokemon from a region's game have an easier time finding them)
	$player.pokedex.unlock(29) 			# Kalos Pokemon (This exists to allow People needing to find a specfic Pokemon from a region's game have an easier time finding them)
	$player.pokedex.unlock(30) 			# Alola Pokemon (This exists to allow People needing to find a specfic Pokemon from a region's game have an easier time finding them)
	$player.pokedex.unlock(31) 			# Galar Pokemon (This exists to allow People needing to find a specfic Pokemon from a region's game have an easier time finding them)
	$player.pokedex.unlock(32) 			# Paldea Pokemon (This exists to allow People needing to find a specfic Pokemon from a region's game have an easier time finding them)
	$player.pokedex.unlock(33) 			# Beatha Pokédex (I ended up needing to do this, to figure out what Pokemon are native to Beatha, in order to fill out the Safari and Mystery Zones, with Pokemon missing from Encounter Table 0)
	$player.pokedex.unlock(34) 			# No Clip Pokemon (This is where you can find Pokemon not native to the Beatha Region. Exists only to assist people who can't be fucked to use the Wild Adjuster)
	$player.pokedex.unlock(-1) 			# Gen 9 National Dex (0001 to 1025)
	$player.has_pokedex = true 			# Allows the player to have the dex (Do not forget to set [0029: Has National Dex] = ON above this script. Also set [0060: Pokedex Data Page] = ON above this script.
	$player.seen_storage_creator = true # Makes the Storage System display the creator's name as PSS (Pokemon Storage System)
	pbAllPokemonSetup50					# Gives every Pokemon's Base Form at Lvl.5, all 1025+ Pokemon, as of Gen 9 (The Form Trader Plugin deals with all Pokemon Forms)
	#pbClearAllPokemonSetup 			# Turned off for Battle Mode, use in Story Mode. Needed in Story Mode, to setup the Metagame Wiki Dex
	pbOptimisedPartyQuickStart50		# Gives the player a stock metagame Pokemon team, so they can jump straight in, if they cannot be fucked to fully train a Pokemon team

	# One of every Pokemon Form, as a failsafe/saving the player's time, if the Form Trader Plugin decides to stop working
	pbAddPokemonSilent(:RATTATA_1,50)
	pbAddPokemonSilent(:RATICATE_1,50)
	pbAddPokemonSilent(:PIKACHU_3,50)
	pbAddPokemonSilent(:PIKACHU_4,50)
	pbAddPokemonSilent(:PIKACHU_5,50)
	pbAddPokemonSilent(:PIKACHU_6,50)
	pbAddPokemonSilent(:PIKACHU_7,50)
	pbAddPokemonSilent(:PIKACHU_8,50)
	pbAddPokemonSilent(:PIKACHU_9,50)
	pbAddPokemonSilent(:PIKACHU_10,50)
	pbAddPokemonSilent(:PIKACHU_11,50)
	pbAddPokemonSilent(:PIKACHU_12,50)
	pbAddPokemonSilent(:PIKACHU_13,50)
	pbAddPokemonSilent(:PIKACHU_14,50)
	pbAddPokemonSilent(:PIKACHU_15,50)
	pbAddPokemonSilent(:RAICHU_1,50)
	pbAddPokemonSilent(:SANDSHREW_1,50)
	pbAddPokemonSilent(:SANDSLASH_1,50)
	pbAddPokemonSilent(:VULPIX_1,50)
	pbAddPokemonSilent(:NINETALES_1,50)
	pbAddPokemonSilent(:DIGLETT_1,50)
	pbAddPokemonSilent(:DUGTRIO_1,50)
	pbAddPokemonSilent(:MEOWTH_1,50)
	pbAddPokemonSilent(:MEOWTH_2,50)
	pbAddPokemonSilent(:PERSIAN_1,50)
	pbAddPokemonSilent(:GEODUDE_1,50)
	pbAddPokemonSilent(:GRAVELER_1,50)
	pbAddPokemonSilent(:GOLEM_1,50)
	pbAddPokemonSilent(:PONYTA_1,50)
	pbAddPokemonSilent(:RAPIDASH_1,50)
	pbAddPokemonSilent(:SLOWPOKE_1,50)
	pbAddPokemonSilent(:SLOWBRO_1,50)
	pbAddPokemonSilent(:FARFETCHD_1,50)
	pbAddPokemonSilent(:GRIMER_1,50)
	pbAddPokemonSilent(:MUK_1,50)
	pbAddPokemonSilent(:EXEGGUTOR_1,50)
	pbAddPokemonSilent(:MAROWAK_1,50)
	pbAddPokemonSilent(:WEEZING_1,50)
	pbAddPokemonSilent(:MRMIME_1,50)
	pbAddPokemonSilent(:ARTICUNO_1,50)
	pbAddPokemonSilent(:ZAPDOS_1,50)
	pbAddPokemonSilent(:MOLTRES_1,50)
	pbAddPokemonSilent(:PICHU_2,50)
	pbAddPokemonSilent(:SLOWKING_1,50)
	pbAddPokemonSilent(:CORSOLA_1,50)
	pbAddPokemonSilent(:ZIGZAGOON_1,50)
	pbAddPokemonSilent(:LINOONE_1,50)
	pbAddPokemonSilent(:CASTFORM_1,50)
	pbAddPokemonSilent(:CASTFORM_2,50)
	pbAddPokemonSilent(:CASTFORM_3,50)
	pbAddPokemonSilent(:DEOXYS_1,50)
	pbAddPokemonSilent(:DEOXYS_2,50)
	pbAddPokemonSilent(:DEOXYS_3,50)
	pbAddPokemonSilent(:WORMADAM_1,50)
	pbAddPokemonSilent(:WORMADAM_2,50)
	pbAddPokemonSilent(:ROTOM_1,50)
	pbAddPokemonSilent(:ROTOM_2,50)
	pbAddPokemonSilent(:ROTOM_3,50)
	pbAddPokemonSilent(:ROTOM_4,50)
	pbAddPokemonSilent(:ROTOM_5,50)
	pbAddPokemonSilent(:SHAYMIN_1,50)
	pbAddPokemonSilent(:ARCEUS_1,50)
	pbAddPokemonSilent(:ARCEUS_2,50)
	pbAddPokemonSilent(:ARCEUS_3,50)
	pbAddPokemonSilent(:ARCEUS_4,50)
	pbAddPokemonSilent(:ARCEUS_5,50)
	pbAddPokemonSilent(:ARCEUS_6,50)
	pbAddPokemonSilent(:ARCEUS_7,50)
	pbAddPokemonSilent(:ARCEUS_8,50)
	#pbAddPokemonSilent(:ARCEUS_9,5) This is the ??? Type form. Not added to the list, to avoid crashing issues with Dynamax
	pbAddPokemonSilent(:ARCEUS_10,50)
	pbAddPokemonSilent(:ARCEUS_11,50)
	pbAddPokemonSilent(:ARCEUS_12,50)
	pbAddPokemonSilent(:ARCEUS_13,50)
	pbAddPokemonSilent(:ARCEUS_14,50)
	pbAddPokemonSilent(:ARCEUS_15,50)
	pbAddPokemonSilent(:ARCEUS_16,50)
	pbAddPokemonSilent(:ARCEUS_17,50)
	pbAddPokemonSilent(:ARCEUS_18,50)
	pbAddPokemonSilent(:BASCULIN_1,50)
	pbAddPokemonSilent(:BASCULIN_2,50)
	pbAddPokemonSilent(:DARUMAKA_2,50)
	pbAddPokemonSilent(:DARMANITAN_2,50)
	pbAddPokemonSilent(:YAMASK_1,50)
	pbAddPokemonSilent(:SAWSBUCK,50)
	pbAddPokemonSilent(:SAWSBUCK_1,50)
	pbAddPokemonSilent(:SAWSBUCK_2,50)
	pbAddPokemonSilent(:SAWSBUCK_3,50)
	pbAddPokemonSilent(:STUNFISK_1,50)
	pbAddPokemonSilent(:KYUREM,50)
	pbAddPokemonSilent(:RESHIRAM,50)
	pbAddPokemonSilent(:KYUREM,50)
	pbAddPokemonSilent(:ZEKROM,50)
	pbAddPokemonSilent(:MELOETTA_1,50)
	pbAddPokemonSilent(:GENESECT_1,50)
	pbAddPokemonSilent(:GENESECT_2,50)
	pbAddPokemonSilent(:GENESECT_3,50)
	pbAddPokemonSilent(:GENESECT_4,50)
	pbAddPokemonSilent(:VIVILLON_1,50)
	pbAddPokemonSilent(:VIVILLON_2,50)
	pbAddPokemonSilent(:VIVILLON_3,50)
	pbAddPokemonSilent(:VIVILLON_6,50)
	pbAddPokemonSilent(:VIVILLON_7,50)
	pbAddPokemonSilent(:VIVILLON_9,50)
	pbAddPokemonSilent(:VIVILLON_10,50)
	pbAddPokemonSilent(:VIVILLON_12,50)
	pbAddPokemonSilent(:VIVILLON_14,50)
	pbAddPokemonSilent(:VIVILLON_16,50)
	pbAddPokemonSilent(:VIVILLON_17,50)
	pbAddPokemonSilent(:VIVILLON_18,50)
	pbAddPokemonSilent(:VIVILLON_19,50)
	pbAddPokemonSilent(:FLORGES_1,50)
	pbAddPokemonSilent(:FLORGES_2,50)
	pbAddPokemonSilent(:FLORGES_3,50)
	pbAddPokemonSilent(:FLORGES_4,50)
	pbAddPokemonSilent(:FURFROU_1,50)
	pbAddPokemonSilent(:FURFROU_2,50)
	pbAddPokemonSilent(:FURFROU_3,50)
	pbAddPokemonSilent(:FURFROU_4,50)
	pbAddPokemonSilent(:FURFROU_5,50)
	pbAddPokemonSilent(:FURFROU_6,50)
	pbAddPokemonSilent(:FURFROU_7,50)
	pbAddPokemonSilent(:FURFROU_8,50)
	pbAddPokemonSilent(:FURFROU_9,50)
	pbAddPokemonSilent(:HOOPA_1,50)
	pbAddPokemonSilent(:ORICORIO_1,50)
	pbAddPokemonSilent(:ORICORIO_2,50)
	pbAddPokemonSilent(:ORICORIO_3,50)
	pbAddPokemonSilent(:LYCANROC,50)
	pbAddPokemonSilent(:LYCANROC_1,50)
	pbAddPokemonSilent(:LYCANROC_2,50)
	pbAddPokemonSilent(:SILVALLY_1,50)
	pbAddPokemonSilent(:SILVALLY_2,50)
	pbAddPokemonSilent(:SILVALLY_3,50)
	pbAddPokemonSilent(:SILVALLY_4,50)
	pbAddPokemonSilent(:SILVALLY_5,50)
	pbAddPokemonSilent(:SILVALLY_6,50)
	pbAddPokemonSilent(:SILVALLY_7,50)
	pbAddPokemonSilent(:SILVALLY_8,50)
	#pbAddPokemonSilent(:ARCEUS_9,5) This is the ??? Type form. Not added to the list, to avoid crashing issues with Dynamax
	pbAddPokemonSilent(:SILVALLY_10,50)
	pbAddPokemonSilent(:SILVALLY_11,50)
	pbAddPokemonSilent(:SILVALLY_12,50)
	pbAddPokemonSilent(:SILVALLY_13,50)
	pbAddPokemonSilent(:SILVALLY_14,50)
	pbAddPokemonSilent(:SILVALLY_15,50)
	pbAddPokemonSilent(:SILVALLY_16,50)
	pbAddPokemonSilent(:SILVALLY_17,50)
	pbAddPokemonSilent(:SILVALLY_18,50)
	pbAddPokemonSilent(:MINIOR_7,50)
	pbAddPokemonSilent(:MINIOR_8,50)
	pbAddPokemonSilent(:MINIOR_9,50)
	pbAddPokemonSilent(:MINIOR_10,50)
	pbAddPokemonSilent(:MINIOR_11,50)
	pbAddPokemonSilent(:MINIOR_12,50)
	pbAddPokemonSilent(:MINIOR_13,50)
	pbAddPokemonSilent(:NECROZMA,50)
	pbAddPokemonSilent(:SOLGALEO,50)
	pbAddPokemonSilent(:NECROZMA,50)
	pbAddPokemonSilent(:LUNALA,50)
	pbAddPokemonSilent(:INDEEDEE_1,50)
	pbAddPokemonSilent(:KUBFU,50)
	pbAddPokemonSilent(:KUBFU,50)
	pbAddPokemonSilent(:CALYREX,50)
	pbAddPokemonSilent(:GLASTRIER,50)
	pbAddPokemonSilent(:CALYREX,50)
	pbAddPokemonSilent(:SPECTRIER,50)
	pbAddPokemonSilent(:TAUROS_1,50)
	pbAddPokemonSilent(:TAUROS_2,50)
	pbAddPokemonSilent(:TAUROS_3,50)
	pbAddPokemonSilent(:TYPHLOSION_1,50)
	pbAddPokemonSilent(:WOOPER_1,50)
	pbAddPokemonSilent(:QWILFISH_1,50)
	pbAddPokemonSilent(:SNEASEL_1,50)
	pbAddPokemonSilent(:SAMUROTT_1,50)
	pbAddPokemonSilent(:LILLIGANT_1,50)
	pbAddPokemonSilent(:BASCULIN_2,50)
	pbAddPokemonSilent(:ZORUA_1,50)
	pbAddPokemonSilent(:ZOROARK_1,50)
	pbAddPokemonSilent(:BRAVIARY_1,50)
	pbAddPokemonSilent(:SLIGGOO_1,50)
	pbAddPokemonSilent(:GOODRA_1,50)
	pbAddPokemonSilent(:AVALUGG_1,50)
	pbAddPokemonSilent(:DECIDUEYE_1,50)
	pbAddPokemonSilent(:URSALUNA_1,50)
	pbAddPokemonSilent(:REVAVROOM_1,50)
	pbAddPokemonSilent(:REVAVROOM_2,50)
	pbAddPokemonSilent(:REVAVROOM_3,50)
	pbAddPokemonSilent(:REVAVROOM_4,50)
	pbAddPokemonSilent(:REVAVROOM_5,50)
	pbAddPokemonSilent(:TATSUGIRI_1,50)
	pbAddPokemonSilent(:TATSUGIRI_2,50)
	pbAddPokemonSilent(:GIMMIGHOUL_1,50)
	pbAddPokemonSilent(:LUGIA_1,50)
	pbAddPokemonSilent(:MAGEARNA_1,50)
	#pbAddPokemonSilent(:FLOETTE_5,50) # I ended up forgetting about this one until now. Was until this point the only Pokemon missing
	
	# The playtester/time saving metagame teams. This consists of Gen 1-9 Starter Teams, 18 Monotype teams, 4 Weather teams, and an ultimate team, making for a total of 52 Pokemon teams, or 312 Fully optimsed Pokemon.
	# This exists to save time setting up a variety of competitive teams, and to make sure as much as possible is poked around in, rather than just using the stock metagame teams
	
	# Gen 1 Teams (6 Starters)
	pbOptimisedGen1GrassPartyQuickStart50
	pbOptimisedGen1FirePartyQuickStart50
	pbOptimisedGen1WaterPartyQuickStart50
	pbOptimisedGen1ElectricPartyQuickStart50
	pbOptimisedGen1FairyPartyQuickStart50
	pbOptimisedGen1NormalPartyQuickStart50
	
	# Gen 2 Teams (3 Starters)
	pbOptimisedGen2GrassPartyQuickStart50
	pbOptimisedGen2FirePartyQuickStart50
	pbOptimisedGen2WaterPartyQuickStart50
	
	# Gen 3 Teams (3 Starters)
	pbOptimisedGen3GrassPartyQuickStart50
	pbOptimisedGen3FirePartyQuickStart50
	pbOptimisedGen3WaterPartyQuickStart50
	
	# Gen 4 Teams (3 Starters)
	pbOptimisedGen4GrassPartyQuickStart50
	pbOptimisedGen4FirePartyQuickStart50
	pbOptimisedGen4WaterPartyQuickStart50
	
	# Gen 5 Teams (3 Starters)
	pbOptimisedGen5GrassPartyQuickStart50
	pbOptimisedGen5FirePartyQuickStart50
	pbOptimisedGen5WaterPartyQuickStart50
	
	# Gen 6 Teams (3 Starters)
	pbOptimisedGen6GrassPartyQuickStart50
	pbOptimisedGen6FirePartyQuickStart50
	pbOptimisedGen6WaterPartyQuickStart50
	
	# Gen 7 Teams (3 Starters)
	pbOptimisedGen7GrassPartyQuickStart50
	pbOptimisedGen7FirePartyQuickStart50
	pbOptimisedGen7WaterPartyQuickStart50
	
	# Gen 8 Teams (3 Starters)
	pbOptimisedGen8GrassPartyQuickStart50
	pbOptimisedGen8FirePartyQuickStart50
	pbOptimisedGen8WaterPartyQuickStart50
	
	# Gen 9 Teams (6 Starters)
	pbOptimisedGen9GrassPartyQuickStart50
	pbOptimisedGen9FirePartyQuickStart50
	pbOptimisedGen9WaterPartyQuickStart50
	
	pbOptimisedGen9FightingPartyQuickStart50
	pbOptimisedGen9GhostPartyQuickStart50
	pbOptimisedGen9DarkPartyQuickStart50
	
	# Mono Type Teams (18 Dedicated Type Teams)
	pbOptimisedMonoNormalPartyQuickStart50
	pbOptimisedMonoFightingPartyQuickStart50
	pbOptimisedMonoFlyingPartyQuickStart50
	
	pbOptimisedMonoPoisonPartyQuickStart50
	pbOptimisedMonoGroundPartyQuickStart50
	pbOptimisedMonoRockPartyQuickStart50
	
	pbOptimisedMonoBugPartyQuickStart50
	pbOptimisedMonoGhostPartyQuickStart50
	pbOptimisedMonoSteelPartyQuickStart50
	
	pbOptimisedMonoFirePartyQuickStart50
	pbOptimisedMonoWaterPartyQuickStart50
	pbOptimisedMonoGrassPartyQuickStart50
	
	pbOptimisedMonoElectricPartyQuickStart50
	pbOptimisedMonoPsychicPartyQuickStart50
	pbOptimisedMonoIcePartyQuickStart50
	
	pbOptimisedMonoDragonPartyQuickStart50
	pbOptimisedMonoDarkPartyQuickStart50
	pbOptimisedMonoFairyPartyQuickStart50
	
	# Weather Teams (4 Weathers)
	pbOptimisedRainWeatherPartyQuickStart50
	pbOptimisedSunWeatherPartyQuickStart50
	pbOptimisedSandstormPartyQuickStart50
	pbOptimisedHailstormPartyQuickStart50
	
	# Ultimate Team (Arceus's Legend Plate and Stellar Terapagos. And 4 Poke Gods for good measure)
	pbOptimisedUtimatePartyQuickStart50
	
	pbAddPokemonSilent(:FLOETTE_5,50) # I ended up forgetting about this one until now. Was until this point the only Pokemon missing. Added here, to not mess up the ordering of teams in the PSS
	
	# All PSS Wallpapers (Why are they not unlocked the second New Game is chosen?)
	pbUnlockWallpaper(16)
	pbUnlockWallpaper(17)
	pbUnlockWallpaper(18)
	pbUnlockWallpaper(19)
	pbUnlockWallpaper(20)
	pbUnlockWallpaper(21)
	pbUnlockWallpaper(22)
	pbUnlockWallpaper(23)
	pbUnlockWallpaper(24)
	pbUnlockWallpaper(25)
	pbUnlockWallpaper(26)
	pbUnlockWallpaper(27)
	pbUnlockWallpaper(28)
	pbUnlockWallpaper(29)
	pbUnlockWallpaper(30)
	pbUnlockWallpaper(31)
	pbUnlockWallpaper(32)
	pbUnlockWallpaper(33)
	pbUnlockWallpaper(34)
	pbUnlockWallpaper(35)
	pbUnlockWallpaper(36)
	pbUnlockWallpaper(37)
	pbUnlockWallpaper(38)
	pbUnlockWallpaper(39)
	pbUnlockWallpaper(40)
	pbUnlockWallpaper(41)
	pbUnlockWallpaper(42)
	pbUnlockWallpaper(43)
	pbUnlockWallpaper(44)
	pbUnlockWallpaper(45)
	pbUnlockWallpaper(46)
	pbUnlockWallpaper(47)
	pbUnlockWallpaper(48)
	pbUnlockWallpaper(49)
	pbUnlockWallpaper(50)
	pbUnlockWallpaper(51)
	pbUnlockWallpaper(52)
	pbUnlockWallpaper(53)
	pbUnlockWallpaper(54)
	pbUnlockWallpaper(55)
	pbUnlockWallpaper(56)
	pbUnlockWallpaper(57)
	pbUnlockWallpaper(58)
	pbUnlockWallpaper(59)
	
	# In the Event command after all the above is done, set up the following Switches/Variables:
	# [0034: (2) Ultimate Move Tutor] = ON (Sets up The Gen 9 More Relearner System, enhanced by Ultimate Move Tutor)
	# [0062: SOS Battles] = ON (The SOS Battle feature is active)
	# [0067: Dynamax On Any Map] = ON (Dynamax can be used anywhere. Makes using Megas, Z-Moves, Dynamax and Teras back to back a lot easier)
	# [0078: Level Scale Constant] = 100 (The default Level Scale Constant. Manual Level Scaling is required for Battle Mode)
	
	# Give the player every item, so no extra setup work in the map is required
	pbPumbInAllItems # Up to you to use this easy method, or setup a Poke Mart with Arcky's Poke Mart Plugin
end

#===============================================================================
# Lvl.100 Battle Mode (Open Level/Full Power Cup)
#===============================================================================
def pbBattleModeSetup100 
	$player.has_running_shoes = true	# Get this basic feature over and done with
	$player.has_pokegear = true			# Get this basic feature over and done with
	$player.has_exp_all = true 			# It is so dumb that $bag.has?(:EXPALL) is how features like this are handled. Decades has overhauled toggles like this, so they are actual player controlled toggles. Fuck Gen 9 for taking away the Set and Shift Option, and Gen 8 for taking away the Exp All Toggle.
	$player.pokedex.unlock(0) 			# Metagame Wiki Dex 
	$player.pokedex.unlock(1) 			# Organised PokeDex
	$player.pokedex.unlock(2) 			# Canon Mega Pokemon
	$player.pokedex.unlock(3) 			# Non Canon Mega Pokemon
	$player.pokedex.unlock(4) 			# All Moves/Abilities 
	$player.pokedex.unlock(5) 			# Normal Type Moves
	$player.pokedex.unlock(6) 			# Fire Type Moves
	$player.pokedex.unlock(7) 			# Fighting Type Moves
	$player.pokedex.unlock(8) 			# Water Type Moves
	$player.pokedex.unlock(9) 			# Flying Type Moves
	$player.pokedex.unlock(10) 			# Grass Type Moves
	$player.pokedex.unlock(11) 			# Poison Type Moves
	$player.pokedex.unlock(12) 			# Electric Type Moves
	$player.pokedex.unlock(13) 			# Ground Type Moves
	$player.pokedex.unlock(14) 			# Psychic Type Moves
	$player.pokedex.unlock(15) 			# Rock Type Moves
	$player.pokedex.unlock(16) 			# Ice Type Moves
	$player.pokedex.unlock(17) 			# Bug Type Moves
	$player.pokedex.unlock(18) 			# Dragon Type Moves
	$player.pokedex.unlock(19) 			# Ghost Type Moves
	$player.pokedex.unlock(20) 			# Dark Type Moves
	$player.pokedex.unlock(21) 			# Steel Type Moves
	$player.pokedex.unlock(22) 			# Fairy Type Moves
	$player.pokedex.unlock(23) 			# Non Level Evolution Pokemon (I refuse to make an online wiki I know damn well I cannot maintain)
	$player.pokedex.unlock(24) 			# Kanto Pokemon (This exists to allow People needing to find a specfic Pokemon from a region's game have an easier time finding them)
	$player.pokedex.unlock(25) 			# Johto Pokemon (This exists to allow People needing to find a specfic Pokemon from a region's game have an easier time finding them)
	$player.pokedex.unlock(26) 			# Hoenn Pokemon (This exists to allow People needing to find a specfic Pokemon from a region's game have an easier time finding them)
	$player.pokedex.unlock(27) 			# Sinnoh Pokemon (This exists to allow People needing to find a specfic Pokemon from a region's game have an easier time finding them)
	$player.pokedex.unlock(28) 			# Unova Pokemon (This exists to allow People needing to find a specfic Pokemon from a region's game have an easier time finding them)
	$player.pokedex.unlock(29) 			# Kalos Pokemon (This exists to allow People needing to find a specfic Pokemon from a region's game have an easier time finding them)
	$player.pokedex.unlock(30) 			# Alola Pokemon (This exists to allow People needing to find a specfic Pokemon from a region's game have an easier time finding them)
	$player.pokedex.unlock(31) 			# Galar Pokemon (This exists to allow People needing to find a specfic Pokemon from a region's game have an easier time finding them)
	$player.pokedex.unlock(32) 			# Paldea Pokemon (This exists to allow People needing to find a specfic Pokemon from a region's game have an easier time finding them)
	$player.pokedex.unlock(33) 			# Beatha Pokédex (I ended up needing to do this, to figure out what Pokemon are native to Beatha, in order to fill out the Safari and Mystery Zones, with Pokemon missing from Encounter Table 0)
	$player.pokedex.unlock(34) 			# No Clip Pokemon (This is where you can find Pokemon not native to the Beatha Region. Exists only to assist people who can't be fucked to use the Wild Adjuster)
	$player.pokedex.unlock(-1) 			# Gen 9 National Dex (0001 to 1025)
	$player.has_pokedex = true 			# Allows the player to have the dex (Do not forget to set [0029: Has National Dex] = ON above this script. Also set [0060: Pokedex Data Page] = ON above this script.
	$player.seen_storage_creator = true # Makes the Storage System display the creator's name as PSS (Pokemon Storage System)
	pbAllPokemonSetup100				# Gives every Pokemon's Base Form at Lvl.5, all 1025+ Pokemon, as of Gen 9 (The Form Trader Plugin deals with all Pokemon Forms)
	#pbClearAllPokemonSetup 			# Turned off for Battle Mode, use in Story Mode. Needed in Story Mode, to setup the Metagame Wiki Dex
	pbOptimisedPartyQuickStart100		# Gives the player a stock metagame Pokemon team, so they can jump straight in, if they cannot be fucked to fully train a Pokemon team

	# One of every Pokemon Form, as a failsafe/saving the player's time, if the Form Trader Plugin decides to stop working
	pbAddPokemonSilent(:RATTATA_1,100)
	pbAddPokemonSilent(:RATICATE_1,100)
	pbAddPokemonSilent(:PIKACHU_3,100)
	pbAddPokemonSilent(:PIKACHU_4,100)
	pbAddPokemonSilent(:PIKACHU_5,100)
	pbAddPokemonSilent(:PIKACHU_6,100)
	pbAddPokemonSilent(:PIKACHU_7,100)
	pbAddPokemonSilent(:PIKACHU_8,100)
	pbAddPokemonSilent(:PIKACHU_9,100)
	pbAddPokemonSilent(:PIKACHU_10,100)
	pbAddPokemonSilent(:PIKACHU_11,100)
	pbAddPokemonSilent(:PIKACHU_12,100)
	pbAddPokemonSilent(:PIKACHU_13,100)
	pbAddPokemonSilent(:PIKACHU_14,100)
	pbAddPokemonSilent(:PIKACHU_15,100)
	pbAddPokemonSilent(:RAICHU_1,100)
	pbAddPokemonSilent(:SANDSHREW_1,100)
	pbAddPokemonSilent(:SANDSLASH_1,100)
	pbAddPokemonSilent(:VULPIX_1,100)
	pbAddPokemonSilent(:NINETALES_1,100)
	pbAddPokemonSilent(:DIGLETT_1,100)
	pbAddPokemonSilent(:DUGTRIO_1,100)
	pbAddPokemonSilent(:MEOWTH_1,100)
	pbAddPokemonSilent(:MEOWTH_2,100)
	pbAddPokemonSilent(:PERSIAN_1,100)
	pbAddPokemonSilent(:GEODUDE_1,100)
	pbAddPokemonSilent(:GRAVELER_1,100)
	pbAddPokemonSilent(:GOLEM_1,100)
	pbAddPokemonSilent(:PONYTA_1,100)
	pbAddPokemonSilent(:RAPIDASH_1,100)
	pbAddPokemonSilent(:SLOWPOKE_1,100)
	pbAddPokemonSilent(:SLOWBRO_1,100)
	pbAddPokemonSilent(:FARFETCHD_1,100)
	pbAddPokemonSilent(:GRIMER_1,100)
	pbAddPokemonSilent(:MUK_1,100)
	pbAddPokemonSilent(:EXEGGUTOR_1,100)
	pbAddPokemonSilent(:MAROWAK_1,100)
	pbAddPokemonSilent(:WEEZING_1,100)
	pbAddPokemonSilent(:MRMIME_1,100)
	pbAddPokemonSilent(:ARTICUNO_1,100)
	pbAddPokemonSilent(:ZAPDOS_1,100)
	pbAddPokemonSilent(:MOLTRES_1,100)
	pbAddPokemonSilent(:PICHU_2,100)
	pbAddPokemonSilent(:SLOWKING_1,100)
	pbAddPokemonSilent(:CORSOLA_1,100)
	pbAddPokemonSilent(:ZIGZAGOON_1,100)
	pbAddPokemonSilent(:LINOONE_1,100)
	pbAddPokemonSilent(:CASTFORM_1,100)
	pbAddPokemonSilent(:CASTFORM_2,100)
	pbAddPokemonSilent(:CASTFORM_3,100)
	pbAddPokemonSilent(:DEOXYS_1,100)
	pbAddPokemonSilent(:DEOXYS_2,100)
	pbAddPokemonSilent(:DEOXYS_3,100)
	pbAddPokemonSilent(:WORMADAM_1,100)
	pbAddPokemonSilent(:WORMADAM_2,100)
	pbAddPokemonSilent(:ROTOM_1,100)
	pbAddPokemonSilent(:ROTOM_2,100)
	pbAddPokemonSilent(:ROTOM_3,100)
	pbAddPokemonSilent(:ROTOM_4,100)
	pbAddPokemonSilent(:ROTOM_5,100)
	pbAddPokemonSilent(:SHAYMIN_1,100)
	pbAddPokemonSilent(:ARCEUS_1,100)
	pbAddPokemonSilent(:ARCEUS_2,100)
	pbAddPokemonSilent(:ARCEUS_3,100)
	pbAddPokemonSilent(:ARCEUS_4,100)
	pbAddPokemonSilent(:ARCEUS_5,100)
	pbAddPokemonSilent(:ARCEUS_6,100)
	pbAddPokemonSilent(:ARCEUS_7,100)
	pbAddPokemonSilent(:ARCEUS_8,100)
	#pbAddPokemonSilent(:ARCEUS_9,5) This is the ??? Type form. Not added to the list, to avoid crashing issues with Dynamax
	pbAddPokemonSilent(:ARCEUS_10,100)
	pbAddPokemonSilent(:ARCEUS_11,100)
	pbAddPokemonSilent(:ARCEUS_12,100)
	pbAddPokemonSilent(:ARCEUS_13,100)
	pbAddPokemonSilent(:ARCEUS_14,100)
	pbAddPokemonSilent(:ARCEUS_15,100)
	pbAddPokemonSilent(:ARCEUS_16,100)
	pbAddPokemonSilent(:ARCEUS_17,100)
	pbAddPokemonSilent(:ARCEUS_18,100)
	pbAddPokemonSilent(:BASCULIN_1,100)
	pbAddPokemonSilent(:BASCULIN_2,100)
	pbAddPokemonSilent(:DARUMAKA_2,100)
	pbAddPokemonSilent(:DARMANITAN_2,100)
	pbAddPokemonSilent(:YAMASK_1,100)
	pbAddPokemonSilent(:SAWSBUCK,100)
	pbAddPokemonSilent(:SAWSBUCK_1,100)
	pbAddPokemonSilent(:SAWSBUCK_2,100)
	pbAddPokemonSilent(:SAWSBUCK_3,100)
	pbAddPokemonSilent(:STUNFISK_1,100)
	pbAddPokemonSilent(:KYUREM,100)
	pbAddPokemonSilent(:RESHIRAM,100)
	pbAddPokemonSilent(:KYUREM,100)
	pbAddPokemonSilent(:ZEKROM,100)
	pbAddPokemonSilent(:MELOETTA_1,100)
	pbAddPokemonSilent(:GENESECT_1,100)
	pbAddPokemonSilent(:GENESECT_2,100)
	pbAddPokemonSilent(:GENESECT_3,100)
	pbAddPokemonSilent(:GENESECT_4,100)
	pbAddPokemonSilent(:VIVILLON_1,100)
	pbAddPokemonSilent(:VIVILLON_2,100)
	pbAddPokemonSilent(:VIVILLON_3,100)
	pbAddPokemonSilent(:VIVILLON_6,100)
	pbAddPokemonSilent(:VIVILLON_7,100)
	pbAddPokemonSilent(:VIVILLON_9,100)
	pbAddPokemonSilent(:VIVILLON_10,100)
	pbAddPokemonSilent(:VIVILLON_12,100)
	pbAddPokemonSilent(:VIVILLON_14,100)
	pbAddPokemonSilent(:VIVILLON_16,100)
	pbAddPokemonSilent(:VIVILLON_17,100)
	pbAddPokemonSilent(:VIVILLON_18,100)
	pbAddPokemonSilent(:VIVILLON_19,100)
	pbAddPokemonSilent(:FLORGES_1,100)
	pbAddPokemonSilent(:FLORGES_2,100)
	pbAddPokemonSilent(:FLORGES_3,100)
	pbAddPokemonSilent(:FLORGES_4,100)
	pbAddPokemonSilent(:FURFROU_1,100)
	pbAddPokemonSilent(:FURFROU_2,100)
	pbAddPokemonSilent(:FURFROU_3,100)
	pbAddPokemonSilent(:FURFROU_4,100)
	pbAddPokemonSilent(:FURFROU_5,100)
	pbAddPokemonSilent(:FURFROU_6,100)
	pbAddPokemonSilent(:FURFROU_7,100)
	pbAddPokemonSilent(:FURFROU_8,100)
	pbAddPokemonSilent(:FURFROU_9,100)
	pbAddPokemonSilent(:HOOPA_1,100)
	pbAddPokemonSilent(:ORICORIO_1,100)
	pbAddPokemonSilent(:ORICORIO_2,100)
	pbAddPokemonSilent(:ORICORIO_3,100)
	pbAddPokemonSilent(:LYCANROC,100)
	pbAddPokemonSilent(:LYCANROC_1,100)
	pbAddPokemonSilent(:LYCANROC_2,100)
	pbAddPokemonSilent(:SILVALLY_1,100)
	pbAddPokemonSilent(:SILVALLY_2,100)
	pbAddPokemonSilent(:SILVALLY_3,100)
	pbAddPokemonSilent(:SILVALLY_4,100)
	pbAddPokemonSilent(:SILVALLY_5,100)
	pbAddPokemonSilent(:SILVALLY_6,100)
	pbAddPokemonSilent(:SILVALLY_7,100)
	pbAddPokemonSilent(:SILVALLY_8,100)
	#pbAddPokemonSilent(:ARCEUS_9,5) This is the ??? Type form. Not added to the list, to avoid crashing issues with Dynamax
	pbAddPokemonSilent(:SILVALLY_10,100)
	pbAddPokemonSilent(:SILVALLY_11,100)
	pbAddPokemonSilent(:SILVALLY_12,100)
	pbAddPokemonSilent(:SILVALLY_13,100)
	pbAddPokemonSilent(:SILVALLY_14,100)
	pbAddPokemonSilent(:SILVALLY_15,100)
	pbAddPokemonSilent(:SILVALLY_16,100)
	pbAddPokemonSilent(:SILVALLY_17,100)
	pbAddPokemonSilent(:SILVALLY_18,100)
	pbAddPokemonSilent(:MINIOR_7,100)
	pbAddPokemonSilent(:MINIOR_8,100)
	pbAddPokemonSilent(:MINIOR_9,100)
	pbAddPokemonSilent(:MINIOR_10,100)
	pbAddPokemonSilent(:MINIOR_11,100)
	pbAddPokemonSilent(:MINIOR_12,100)
	pbAddPokemonSilent(:MINIOR_13,100)
	pbAddPokemonSilent(:NECROZMA,100)
	pbAddPokemonSilent(:SOLGALEO,100)
	pbAddPokemonSilent(:NECROZMA,100)
	pbAddPokemonSilent(:LUNALA,100)
	pbAddPokemonSilent(:INDEEDEE_1,100)
	pbAddPokemonSilent(:KUBFU,100)
	pbAddPokemonSilent(:KUBFU,100)
	pbAddPokemonSilent(:CALYREX,100)
	pbAddPokemonSilent(:GLASTRIER,100)
	pbAddPokemonSilent(:CALYREX,100)
	pbAddPokemonSilent(:SPECTRIER,100)
	pbAddPokemonSilent(:TAUROS_1,100)
	pbAddPokemonSilent(:TAUROS_2,100)
	pbAddPokemonSilent(:TAUROS_3,100)
	pbAddPokemonSilent(:TYPHLOSION_1,100)
	pbAddPokemonSilent(:WOOPER_1,100)
	pbAddPokemonSilent(:QWILFISH_1,100)
	pbAddPokemonSilent(:SNEASEL_1,100)
	pbAddPokemonSilent(:SAMUROTT_1,100)
	pbAddPokemonSilent(:LILLIGANT_1,100)
	pbAddPokemonSilent(:BASCULIN_2,100)
	pbAddPokemonSilent(:ZORUA_1,100)
	pbAddPokemonSilent(:ZOROARK_1,100)
	pbAddPokemonSilent(:BRAVIARY_1,100)
	pbAddPokemonSilent(:SLIGGOO_1,100)
	pbAddPokemonSilent(:GOODRA_1,100)
	pbAddPokemonSilent(:AVALUGG_1,100)
	pbAddPokemonSilent(:DECIDUEYE_1,100)
	pbAddPokemonSilent(:URSALUNA_1,100)
	pbAddPokemonSilent(:REVAVROOM_1,100)
	pbAddPokemonSilent(:REVAVROOM_2,100)
	pbAddPokemonSilent(:REVAVROOM_3,100)
	pbAddPokemonSilent(:REVAVROOM_4,100)
	pbAddPokemonSilent(:REVAVROOM_5,100)
	pbAddPokemonSilent(:TATSUGIRI_1,100)
	pbAddPokemonSilent(:TATSUGIRI_2,100)
	pbAddPokemonSilent(:GIMMIGHOUL_1,100)
	pbAddPokemonSilent(:LUGIA_1,100)
	pbAddPokemonSilent(:MAGEARNA_1,100)
	#pbAddPokemonSilent(:FLOETTE_5,100) # I ended up forgetting about this one until now. Was until this point the only Pokemon missing
	
	# The playtester/time saving metagame teams. This consists of Gen 1-9 Starter Teams, 18 Monotype teams, 4 Weather teams, and an ultimate team, making for a total of 52 Pokemon teams, or 312 Fully optimsed Pokemon.
	# This exists to save time setting up a variety of competitive teams, and to make sure as much as possible is poked around in, rather than just using the stock metagame teams
	
	# Gen 1 Teams (6 Starters)
	pbOptimisedGen1GrassPartyQuickStart100
	pbOptimisedGen1FirePartyQuickStart100
	pbOptimisedGen1WaterPartyQuickStart100
	pbOptimisedGen1ElectricPartyQuickStart100
	pbOptimisedGen1FairyPartyQuickStart100
	pbOptimisedGen1NormalPartyQuickStart100
	
	# Gen 2 Teams (3 Starters)
	pbOptimisedGen2GrassPartyQuickStart100
	pbOptimisedGen2FirePartyQuickStart100
	pbOptimisedGen2WaterPartyQuickStart100
	
	# Gen 3 Teams (3 Starters)
	pbOptimisedGen3GrassPartyQuickStart100
	pbOptimisedGen3FirePartyQuickStart100
	pbOptimisedGen3WaterPartyQuickStart100
	
	# Gen 4 Teams (3 Starters)
	pbOptimisedGen4GrassPartyQuickStart100
	pbOptimisedGen4FirePartyQuickStart100
	pbOptimisedGen4WaterPartyQuickStart100
	
	# Gen 5 Teams (3 Starters)
	pbOptimisedGen5GrassPartyQuickStart100
	pbOptimisedGen5FirePartyQuickStart100
	pbOptimisedGen5WaterPartyQuickStart100
	
	# Gen 6 Teams (3 Starters)
	pbOptimisedGen6GrassPartyQuickStart100
	pbOptimisedGen6FirePartyQuickStart100
	pbOptimisedGen6WaterPartyQuickStart100
	
	# Gen 7 Teams (3 Starters)
	pbOptimisedGen7GrassPartyQuickStart100
	pbOptimisedGen7FirePartyQuickStart100
	pbOptimisedGen7WaterPartyQuickStart100
	
	# Gen 8 Teams (3 Starters)
	pbOptimisedGen8GrassPartyQuickStart100
	pbOptimisedGen8FirePartyQuickStart100
	pbOptimisedGen8WaterPartyQuickStart100
	
	# Gen 9 Teams (6 Starters)
	pbOptimisedGen9GrassPartyQuickStart100
	pbOptimisedGen9FirePartyQuickStart100
	pbOptimisedGen9WaterPartyQuickStart100
	
	pbOptimisedGen9FightingPartyQuickStart100
	pbOptimisedGen9GhostPartyQuickStart100
	pbOptimisedGen9DarkPartyQuickStart100
	
	# Mono Type Teams (18 Dedicated Type Teams)
	pbOptimisedMonoNormalPartyQuickStart100
	pbOptimisedMonoFightingPartyQuickStart100
	pbOptimisedMonoFlyingPartyQuickStart100
	
	pbOptimisedMonoPoisonPartyQuickStart100
	pbOptimisedMonoGroundPartyQuickStart100
	pbOptimisedMonoRockPartyQuickStart100
	
	pbOptimisedMonoBugPartyQuickStart100
	pbOptimisedMonoGhostPartyQuickStart100
	pbOptimisedMonoSteelPartyQuickStart100
	
	pbOptimisedMonoFirePartyQuickStart100
	pbOptimisedMonoWaterPartyQuickStart100
	pbOptimisedMonoGrassPartyQuickStart100
	
	pbOptimisedMonoElectricPartyQuickStart100
	pbOptimisedMonoPsychicPartyQuickStart100
	pbOptimisedMonoIcePartyQuickStart100
	
	pbOptimisedMonoDragonPartyQuickStart100
	pbOptimisedMonoDarkPartyQuickStart100
	pbOptimisedMonoFairyPartyQuickStart100
	
	# Weather Teams (4 Weathers)
	pbOptimisedRainWeatherPartyQuickStart100
	pbOptimisedSunWeatherPartyQuickStart100
	pbOptimisedSandstormPartyQuickStart100
	pbOptimisedHailstormPartyQuickStart100
	
	# Ultimate Team (Arceus's Legend Plate and Stellar Terapagos. And 4 Poke Gods for good measure)
	pbOptimisedUtimatePartyQuickStart100
	
	pbAddPokemonSilent(:FLOETTE_5,100) # I ended up forgetting about this one until now. Was until this point the only Pokemon missing. Added here, to not mess up the ordering of teams in the PSS
	
	# All PSS Wallpapers (Why are they not unlocked the second New Game is chosen?)
	pbUnlockWallpaper(16)
	pbUnlockWallpaper(17)
	pbUnlockWallpaper(18)
	pbUnlockWallpaper(19)
	pbUnlockWallpaper(20)
	pbUnlockWallpaper(21)
	pbUnlockWallpaper(22)
	pbUnlockWallpaper(23)
	pbUnlockWallpaper(24)
	pbUnlockWallpaper(25)
	pbUnlockWallpaper(26)
	pbUnlockWallpaper(27)
	pbUnlockWallpaper(28)
	pbUnlockWallpaper(29)
	pbUnlockWallpaper(30)
	pbUnlockWallpaper(31)
	pbUnlockWallpaper(32)
	pbUnlockWallpaper(33)
	pbUnlockWallpaper(34)
	pbUnlockWallpaper(35)
	pbUnlockWallpaper(36)
	pbUnlockWallpaper(37)
	pbUnlockWallpaper(38)
	pbUnlockWallpaper(39)
	pbUnlockWallpaper(40)
	pbUnlockWallpaper(41)
	pbUnlockWallpaper(42)
	pbUnlockWallpaper(43)
	pbUnlockWallpaper(44)
	pbUnlockWallpaper(45)
	pbUnlockWallpaper(46)
	pbUnlockWallpaper(47)
	pbUnlockWallpaper(48)
	pbUnlockWallpaper(49)
	pbUnlockWallpaper(50)
	pbUnlockWallpaper(51)
	pbUnlockWallpaper(52)
	pbUnlockWallpaper(53)
	pbUnlockWallpaper(54)
	pbUnlockWallpaper(55)
	pbUnlockWallpaper(56)
	pbUnlockWallpaper(57)
	pbUnlockWallpaper(58)
	pbUnlockWallpaper(59)
	
	# In the Event command after all the above is done, set up the following Switches/Variables:
	# [0034: (2) Ultimate Move Tutor] = ON (Sets up The Gen 9 More Relearner System, enhanced by Ultimate Move Tutor)
	# [0062: SOS Battles] = ON (The SOS Battle feature is active)
	# [0067: Dynamax On Any Map] = ON (Dynamax can be used anywhere. Makes using Megas, Z-Moves, Dynamax and Teras back to back a lot easier)
	# [0078: Level Scale Constant] = 100 (The default Level Scale Constant. Manual Level Scaling is required for Battle Mode)
	
	# Give the player every item, so no extra setup work in the map is required
	pbPumbInAllItems # Up to you to use this easy method, or setup a Poke Mart with Arcky's Poke Mart Plugin
end
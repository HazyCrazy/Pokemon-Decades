#====================================== Settings ======================================#
  # Turn certain settings on/off according to your preferences.

  module ARMSettings
    #=============================== Grid Settings ================================#

      # change the square size for each tile on the Region Map here.
      # (I don't recommend changing this but it's here in case you want to anyway.)
      SquareWidth  = 16
      SquareHeight = 16

    #========================== Progress Counter settings =========================#

      # true = enabled: Keeps track of visited maps, wild pokemon (seen and caught), trainers and items.
      # false = disabled: In case you would still have issues with this feature, make sure to tell me them.
      ProgressCounter = true

      # Below I've provided a setting for each counter that the Progress Counter is using.
      # If you wish to not use one or more of these, you can turn them off here (or in case you would have an issue with one of them).

      # true = enabled: Counting Found Items (requires "item" in the event's name).
      # false = disabled.
      ProgressCountItems = false

      # true = enabled: Counting Defeated Trainers (requires "trainer" in the event's name).
      # false = disabled.
      ProgressCountTrainers = false

      # true = enabled: Counting Seen and Caught Pokemon.
      # false = disabled.
      ProgressCountSpecies = true

      # true = enabled: Counting Visited Locations (only those that are shown on the Region Map and matches that name. For POI, only those maps included in the LinkPoiToMap setting).
      # false = disabled.
      ProgressCountVisitedLocations = false

      # true = enabled: The percentage next to the Region/District name will not be shown.
      # false = disabled: The percentage next to the Region/District name will be shown.
      DisableProgressCounterPercentage = false

      # true = enabled: The percentage next to the map's name in the extended preview will not be shown.
      # false = disabled; The percentage next to the map's name in the extended preview will be shown.
      DisableExtendedPreviewPercentage = false

    #============================== Location Settings =============================#

      #======================= No Unvisited Location Info =======================#

        # true = enabled: Unvisited Locations will be displayed with "???" if not visited.
        # false = disabled.
        NoUnvistedMapInfo = false

        # Change this to any text you want for Unvisited Locations.
        UnvisitedMapText = "???"

        # Change this to any text you want to Unvisited Point of Interests.
        UnvisitedPoiText = "???"

        # You can link each Point of Interest you have on your Town Map to a certain Game Map ID. (from v2.6 this is also used for renaming Locations used by the Extended Preview)
        # If this map is then visited, the Point of Interest will be revealed, otherwise it'll revealed together with the location.
        # Be careful the name here must match the POI, it's case sensitive! (Only applies for replacing the unvisted POI's with UnvisitedPoiText and revealing them.)

        LinkPoiToMap = {
          #"Oak's Lab" => 4,
          #"Kurt's House" => 6,
          #"\v[12]'s house" => 8, # Using a variable will show the content for the Location name in the Extended Preview. This won't effect anything else.
          #"Cedolan Dept. Store" => 14,
          #"Ice Cave" => 34,
          #"Rock Cave 1F" => 49,
          #"Rock Cave B1F" => 50,
          #"Dungeon" => 51,
          #"Diving area" => 70,
          #"Cedolan City Gym" => 10
        }

        #LinkPoiToMap = {

        #}

      #============================= Fake Locations =============================#

        # Add a Map ID, a Game Variable and a value for each map position.
        # The map ID will prevent a map position being used by the script on another map.
        # Set up: Map ID => { Game Variable => value => [region, x, y] } }
        # Example: 14 => { 98 => { 1 => [0, 1, 1] } } :
        # When the Current Game Map ID is 14 and Game Variable 98 has a value of 1, the Map Position shown on the Region Map will be 1 for the x value and 1 for the y value on Region 0.
        # It is not recommended to use multiple Game Variables for a same map because it might cause problems. If Game Variable 98 is 3 and Game Variable 99 is 2, there'll be no problem.
        # But you can use the same Game Variable for multiple Maps and they may even have the same value because only the map position of the current Game Map will be used if there's a match.
        FakeRegionLocations = {

        }
      #======================== Hidden Location Settings ========================#

        # A set of arrays, each containing details of a graphic to be shown on the
        # Region Map if appropriate. The values for each array are as follows:
        # - Region number.
        # - Game Switch; The graphic is shown if this is ON (non-wall maps only unless you set the last setting to nil).
        # - X coordinate of the graphic on the map, in squares.
        # - Y coordinate of the graphic on the map, in squares.
        # - Name of the graphic, found in the Graphics/Pictures folder.
        # - The graphic will always (true), never (false) or only when the switch is ON (nil) be shown on a wall map.
        RegionMapExtras = [

        ]

      #======================== Location Search Settings ========================#

        # true or 0 = enabled: This feature can be used.
        # false or -1 = disabled.
        # Switch ID = enabled if this Switch is ON.
        CanLocationSearch = true

        # true = enabled: Include unvisited maps in the list of Locations.
        # false = disblaed: Don't include unvisited maps in the list of Locations.
        # The maps listed are taken from the townmap.txt PBS file. (if you linked the POI to a map ID, these will be included as well)
        IncludeUnvisitedMaps = false

        # Set the minimum of maps that have to be visited in order to use the Location Search Feature.
        MinimumMapsCount = 0#10

        # Choose which button will activate the Location Search Feature.
        # Be careful with what you've set for Region map changing, mode changing and location preview as it might conflict with those.
        LocationSearchButton = Input::SPECIAL

        # Choose which button will activate the Quick Search Feature.
        # This may be the same button as you've set for LocationSearchButton but don't set this to the BACK or the USE button
        QuickSearchButton = Input::ACTION

        # Choose which button will sort the list with locations.
        # If you set this to the same button as LocationSearchButton, make sure QuickSearchButton is set to a different one to avoid problems.
        OrderSearchButton = Input::SPECIAL

      #=========================== Highlight Settings ===========================#

        # Change the opacity of the Highlight images to any value between 0 and 100 in steps of 5.
        # Possible values: 0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100.
        # Any other values than the one mentioned above will be converted to the closest one accepted.
        # For example 97 will be converted to 95 which will result in the Highlight Images having an opacity of 95%.
        # Any values higher than 100 will be converted to 100%.
        HighlightOpacity = 90

      #=========================== Decoration Settings ==========================#

        # Add Decoration Graphics above the Region Map Graphic itself which will render above the highlighting of a Location.
        # - region number
        # - Game Switch; The graphic will not show anymore if this is ON or make this nil to make it always show.
        # - X coordinate of the graphic on the map, in squares.
        # - Y coordinate of the graphic on the map, in squares.
        # - Name of the graphic, found in the Graphics/Pictures.
        # - false if you want it to render below. (true by default).
        RegionMapDecoration = [

        ]

      #======================== Region District Settings ========================#

        # true = enabled: Allows you to change the Region Name on certain parts of the Region Map
        # false = disabled.
        UseRegionDistrictsNames = false

        # - Region Number
        # - [min X, max X]; the minimum X value and the maximum X value, in squares.
        #    example: [0, 32]; when the cursor is between 0 and 32 (including 0 and 32) the name of the region changes (depending on the Y value as well).
        # - [min Y, max Y]; the minimum Y value and the maximum Y value, in squares.
        #    example: [0, 10]; when the cursor is between 0 and 10 (including 0 and 10) the name of the region changes (depending on the X value as well).
        # - Region District Name; this is the name the script will use only when the cursor is inside X and Y range.
        RegionDistricts = [

        ]

        # Link a switch ID to each District (if used). This switch will be turned ON once it's at 100%.
        # You'll need to add a script command containing switchesForDistricts in an event before checking if any switches are turned ON.
        ProgressSwitches = {

        }

      #========================= Region Map Connecting ==========================#

      # true = enabled: Region Conncting is enabled.
      # false = disabled.
      UseRegionConnecting = false


      RegionConnections = {

      }
      
    #================================ Fly Settings ================================#

      # true = enabled: The player can use Fly on the Town Map. This is only allowed if the player can use fly normally.
      # false = disabled: The player can't use fly on the Town Map (only with the field move).
      CanFlyFromTownMap = true

      # true or 0 = enabled: This Feature can be used.

      # false or -1 = disabled.
      # Switch ID = enabled if this Switch is ON.
      CanQuickFly = true

      # Choose which Button will activate the Quick Fly Feature
      # Possible buttons are: JUMPUP, JUMPDOWN, SPECIAL, AUX1 and AUX2. any other buttons are not recommended.
      # Press F1 in game to know which key a button is linked to.
      # IMPORTANT: only change the JUMPUP to SPECIAL for example. So QuickFlyButton = Input::SPECIAL
      QuickFlyButton = Input::JUMPUP

      # true = enabled: The Cursor will automatically move to the selected Location from the Quick Fly Menu (on selecting, not confirming).
      # false = disabled.
      AutoCursorMovement = true

      # true = enabled: The player is allowed to fly from 1 Region to another.
      # false = disabled: The player can't fly from 1 Region to another.
      AllowFlyToOtherRegions = false

      # Set to which Regions you can fly from the current Region. (Use the name of the region)
      FlyToRegions = {
        :Essen => [1, 3], # You can fly from Essen to Tial, Kanto or Johto.
        :Tiall => [0, 3] # You can fly from Tial to Essen only.
      }

      # Set from which locations on a Region you can fly to another Region.
      LocationFlyToOtherRegion = {

      }

      # true = enabled: When confirming the fly location, screen will fade out and in and you teleport directly to that location instead of the fly animation first.
      # false = disabled. When confirming the fly location, fly animation will activate.
      QuickTravelInsteadOfFly = true#false

    #================================ Mode Settings ===============================#
      # Choose which button needs to be pressed to change the map mode. ACTION is the default one in essentials.
      # ATTENTION: if you set this to the same button that has been asigned for quick fly and/or quest preview then you won't be able to change modes anymore.
      ChangeModeButton = Input::ACTION

      # Set the name for each mode you want to display on the Region Map.
      # Only change what's between the " ". quest and berry are modes that requires a plugin to be installed in order to be activated on the Region Map.
      ModeNames = {
        :normal => _INTL("Normal Map"),
        :fly => _INTL("Fly Map"),
        :quest => _INTL("Quest Map"), #requires the "Modern Quest System + UI" plugin to use.
        :berry => _INTL("Berry Map"), #requires the "TDW Berry Planting Improvements" plugin by Authorwrigty12 to use.
        :roaming => _INTL("Roaming Map"), #requires the "Roaming Icons" plugin by -FL- to use.
        :trainer => _INTL("Trainer Map") #requires rematch setup through the phone.
      }

      # true = enabled: When there are 3 or more modes available, you'll be offered a Menu to change modes.
      # false = disabled: There'll be no menu, chaning Modes is done by pressing the button set in ChangeModeButton.
      ChangeModeMenu = true

    #=============================== Music Settings ===============================#

      # true = enabled: The BGM will change when opening the Region Map.
      # false = disabled: The BGM will not change.
      ChangeMusicInRegionMap = true#false

      # You can set different BGM for each region, change the volume and pitch. Volume and Pitch are 100 by default.
      # - The Region number.
      # - The name of the BGM "ORAS 108 The Sky"
      # - Volume level.
      # - Pitch level.
      MusicForRegion = [
		[0, "ORAS 108 The Sky"],
        [1, "ORAS 108 The Sky"]
		#[0, "Radio - Oak", 90, 100], #Volume will be set to 90% and Pitch to 100%
        #[1, "Radio - March"] #Volume and Pitch are both set to 100 by default if not given here.
      ]

    #================================= UI Settings ================================#

      #============================= Map UI Settings ============================#

        # true = enabled: Expand the Map behind the UI (most commonly used for transparent UI's).
        # false = disabled.
        RegionMapBehindUI = false

        # Set for each Region if you want the Player Icon to be visible (true) or invisible (false).
        ShowPlayerOnRegion = {
          #Essen: true,#false,
          #Tiall: true,#false,
		  Beatha: true#false
        }

        # true = enabled: The script will change the Region Map based on the Current Time in the Game
        # false = disabled.
        # Possible Times are Day, Night, Morning, Afternoon and Evening. Name your Region Map for example "Region0Day.png".
        # if a Region Map including Morning, Afternoon, Evening or Night is not found, it'll use Day instead.
        # if none at all are found, it'll give you a message in the console and use the default one.
        TimeBasedRegionMap = false

        # true = enabled: Uses the Special UI in UI/Special
        # false = disabled: Uses the Default UI in UI/Default
        UseSpecialUI = true

      #============================ Map Zoom Settings ===========================#

        # true = enabled: Use the Region Map Zoom feature.
        # false = disabled: Don't use the Region Map Zoom feature.
        UseRegionMapZoom = true

        # Set the zoom speed (100 is default speed, lower number is faster, higher number is slower)
        ZoomSpeed = 100

        # Choose the button you need to press to toggle between "Zoom Mode" and back to "Normal Mode".
        ToggleZoomButton = Input::CTRL

        # Choose the button you need to press to Zoom in. (Only used while in Zoom Mode.)
        ZoomInButton = Input::JUMPUP

        # Choose the button you need to press to Zoom out. (Only used while in Zoom Mode.)
        ZoomOutButton = Input::JUMPDOWN

      #========================= Region Changing Settings =======================#

        # Choose the button that needs to be pressed to change the Region if more than 2 regions are available and have been visited.
        ChangeRegionButton = Input::JUMPDOWN

        # true = enabled: The UI and Graphics will change depending on the Region number.
        # false = disabled: The UI will stay unchanged.
        # For each Region you want the UI to change, make a new Folder and name it "Region1" or any Region number (as long as it matches with the one set in the PBS).
        # These folders are located in Graphics > Pictures > RegionMap > UI for v20.1 or Graphics > UI > Town Map > UI for v21.1.
        # The Default UI will be used if no Region Folder is found for the current Region or if there are missing Graphics.
        ChangeUIOnRegion = false

      #========================== Text Position Settings ========================#

        # Add an offset to each Text individually (optional). This could be handy if you're using a custom UI.
        # Used for the Region and District Name Text Position.
        RegionNameOffsetX = 0
        RegionNameOffsetY = 0

        # Used for the Location Name Text Position.
        LocationNameOffsetX = 0
        LocationNameOffsetY = 0

        # Used for the Point of Interest Text Position.
        PoiNameOffsetX = 0
        PoiNameOffsetY = 0

        # Used for the Mode Name Text Position
        ModeNameOffsetX = 0
        ModeNameOffsetY = 0

      #=========================== Text Color Settings ==========================#

        # Change the color for each Text individually (optional).
        # Color used for the Region and Distric Name Text.
        RegionTextMain = Color.new(248, 248, 248)
        RegionTextShadow = Color.new(0, 0, 0)

        # Color used for the Location Name Text.
        LocationTextMain = Color.new(248, 248, 248)
        LocationTextShadow = Color.new(0, 0, 0)

        # Color used for the Point of Interest Text.
        PoiTextMain = Color.new(248, 248, 248)
        PoiTextShadow = Color.new(0, 0, 0)

        # Color used for the Mode Name Text.
        ModeTextMain = Color.new(248, 248, 248)
        ModeTextShadow = Color.new(0, 0, 0)

      #============================== Menu Settings =============================#

        # Change the max options that'll show at the same time when seeing any choice menu.
        # Mainly used for the Quick Fly, Region Changing and Quest Preview.
        # This will prevent the screen being filled with all the location names incase they are long.
        MaxOptionsChoiceMenu = 4

      #============================= Cursor Settings ============================#

        # true = enabled: The map will move (if possible) when the cursor is 1 position away from the direction's edge of the screen.
        #   example: When you want to move to the Right, the map will start moving once the cursor is 1 tile away from the Right edge of the screen.
        # false = disabled: The map will only move (if possible) when the cursor is on the direction's edge of the screen.
        #   example: When you  want to move to the Right, the map will only start moving once the cursor is all the way on the Right edge of the screen.
        CursorMapOffset = true

        # true = enabled: The Cursor will be centered on the Region Map when there's no Map Position defined for the Game Map the Region Map was opened from.
        # false = disabled: The Cursor will be placed on the Top Left on the Region Map when there's no Map Position defined for the Game Map the Region Map was opened from.
        CenterCursorByDefault = true

      #========================== Mouse Support Settings ========================#
        # true = enabled: The mouse can be used for certain Actions on the Region Map.
        # false = disabled.
        UseMouseOnRegionMap = true

        # For now there are only a limited of actions the mouse can do (more to come in the future)
        # only 2 possible inputs are possible Input::MOUSELEFT and Input::MOUSERIGHT
        # don't set the below settings to the same button or a key button or it'll crash your game.

        # Set the mouse button for selecting a location and interacting with it (same function as pressing USE key)
        MouseButtonSelectLocation = Input::MOUSELEFT
        
        # Set the mouse button for moving the map (press this button and drag the mouse to move the map) and for closing a preview (same function as pressing BACK key)
        MouseButtonMoveMap = Input::MOUSERIGHT

    #=============================== Preview Settings =============================#

      #========================= General Preview Settings =======================#

        # This is the line height each line will take for the Location, Quest and Berry Preview text.
        PreviewLineHeight = 32

        # These Settings only apply to the Quest Name and Berry Name Text.
        # Add a small offset to Quest Name Text position.
        PreviewNameOffsetX = 0
        PreviewNameOffsetY = 0

        # Change the Color of the Quest Name Text.
        PreviewTextMain = Color.new(248, 248, 248)
        PreviewTextShadow = Color.new(0, 0, 0)

      #========================== Button Preview Settings =======================#

        # Choose where you want to display the Button Preview Box on the Region Map.
        # - Set this to 1 to display it in the Top Left.
        # - Set this to 2 to display it in the Bottom Left.
        # - Set this to 3 to display it in the Top Right default position).
        # - Set this to 4 to display it in the Bottom Right.
        # - Set this to nil if you wish to not use the Button Preview.
        ButtonBoxPosition = 3

        # Change the opacity of the Button Preview Box when you move the Cursor behind it.
        # Any value is accepted between 0 and 100 in steps of 5. (Just like the Highlight Opacity Setting).
        ButtonBoxOpacity = 50

        # Add a small offset to Button Box Text Position (optional).
        ButtonBoxTextOffsetX = 0
        ButtonBoxTextOffsetY = 0

        # Change the Color for the Text in the Button Box.
        ButtonBoxTextMain = Color.new(248, 248, 248)
        ButtonBoxTextShadow = Color.new(0, 0, 0)

        # Set the amount of time (in seconds) for the Button Preview Text to change to the next one (when 2 or more Actions).
        ButtonPreviewTimeChange = 3

      #========================= Location Preview Settings ======================#

        # true = enabled: This Feature can be used.
        # false = disabled.
        UseLocationPreview = true

        # Choose the button you need to press to view information about the Current Location.
        ShowLocationButton = Input::USE

        # true = enabled: You can view info of Unvisited Locations as well (This setting has no effect if NoUnvistedMapInfo is set to false).
        # false = disabled: You can only view info of Visited Locations on the Region Map.
        CanViewInfoUnvisitedMaps = true

        # Only used when the setting above is set to true.
        # Default text when the location has not been visited yet.
        UnvisitedMapInfoText = _INTL("No information Available")

        # Note: The Location Previews are numbered by the amount of lines they are meant for,
        # If you change this to a higher number then make sure you have a bigger graphic.
        # Set the max lines the location descripions can take.
        MaxDescriptionLines = 3

        # Add a small offset to the Description Text Position.
        # (Keep in mind that the Icon, Dash Line and Direction Text Y positions are all calculated based on the Y position of the Description text.)
        DescriptionTextOffsetX = 0
        DescriptionTextOffsetY = 0

        # Change the Color of the Description text.
        DescriptionTextMain = Color.new(248, 248, 248)
        DescriptionTextShadow = Color.new(0, 0, 0)

        # true = enabled: The Description Text will be centered when it's smaller in lines that the Map Icon (if used).
        # false = disabled.
        # (2 lines with a lineheight of 32px each would be smaller than an icon of 96px so the description text will be adjusted by 16px)
        CenterDescriptionText = true

        # Set the max height a location Icon can take. (Be careful, this settings should be equal to PreviewLineHeight * MaxDescriptionLines.)
        MaxIconHeight = 96

        # Add a small offset to the Icon Position.
        IconOffsetX = 0
        IconOffsetY = 0

        # true = enabled: The Map Icon will be centered when it's smaller than the Description (in lines). This is similar to the CenterDescriptionText Setting.
        # false = disabled.
        # (3 lines with a lineheight of 32px each would be bigger than an icon of 64px so the icon will be adjusted by 16px.)
        CenterIcon = true

        # How to edit the Location preview Box Graphics:
        # In the UI\Default\LocationPreview folder you'll see different LocPreview Images.
        # Each with a number at the end which tells the script how many lines of text they are meant for.
        # A 2 means 2 lines, 3 means 3 lines and so on.
        # There are 2 variants provided:
        # Normal Version - DirectionHeightSpacing is not set to 0 and there's Direction information given :
        # Simple formula to calculate the Total Height of the Graphic :
        # PreviewLineHeight * Total Lines.

        # Alt Version - DirectionHeightSpacing is set to 0 or no Direction information is given :
        # Simple formula to calculate the Total Height of the Graphic :
        # (PreviewLineHeight * Total Lines) + DirectionHeightSpacing)

        # change the spacing between the Location Description text and the Directions Text.
        # (Keep in mind that changing this number might require you to edit your Location Preview Images as well to provide enough space.)
        DirectionHeightSpacing = 16

        # true = enabled: The mapLocationPreviewDash.png image will be used and will make the script draw a dash line below the description.
        # false = disabled.
        # You can change the width and height and color of this image to your preferences.
        # If the DirectionHeightSpacing is lower than the Dash Image height, the dash will not be drawn to prevent the dash covering text.
        DrawDashImages = true

        # Add a small offset to the Dash Line. (This is the same no matter how many lines the preview box is.)
        DashOffsetX = 0
        DashOffsetY = 0

        # There's no setting to turn location directions on or off as if you don't provide any direction information,
        # it'll not adjust the preview box height and the dash lines will also not be used.

        # Set the max lines the location directions can take.
        MaxDirectionLines = 2

        # Add a small offset to the Direction Text Position.
        DirecitonTextOffsetX = 0
        DirectionTextOffsetY = 0

        # Change the color of the Direction Text.
        DirectionTextBase = Color.new(248, 248, 248)
        DirectionTextShadow = Color.new(0, 0, 0)

        # Change the amount of spaces between each direction for a location (this will give as result some spacing between each direction.).
        LocationDirectionSpaces = 3

      #========================= Extended Preview Settings ======================#

        # true = enabled: This Feature can be used (only when UseLocationPreview = true).
        # false = disabled.
        UseExtendedPreview = true

        # Choose the button you need to press to show the Extended Location Preview of the current Location.
        ShowExtendedButton = Input::USE

        # Choose the button you need to press to open the Encounter Table (for now this is the only function, later it'll be a menu)
        ShowExtendedSubButton = Input::USE

        # Choose the button you need to press to reveal seen species from other maps that can be found on the current location.
        # You can also set this to nil, it'll then always reveal all seen species by default and won't be triggerable.
        RevealAllSeenSpeciesButton = Input::SPECIAL

        # Choose the button you need to press to select a species and view info about it.
        # pressing this button again, will change the info space of the current selected species.
        SelectSpeciesButton = Input::USE

        # true = enabled: The Counter Text on the Main page of the Extended Preview will have a fixed position and won't change if for example no Wild Encounters are available on a map.
        # false = disabled: The Counter Text will show more compact when there's no data for an Counter.
        ExtendedMainInfoFixed = true

        # Add a small offset to the Wild Counter Text.
        ExtendedMainTextWildOffsetX = 0
        ExtendedMainTextWildOffsetY = 0

        # Add a small offset to the Trainer Counter Text.
        ExtendedMainTextTrainerOffsetX = 0
        ExtendedMainTextTrainerOffsetY = 0

        # Add a small offset to the Item Counter Text.
        ExtendedMainTextItemOffsetX = 0
        ExtendedMainTextItemOffsetY = 0

        # Change the color of the Wild, Trainer and Item counter text on the main page of the Extended Preview.
        ExtendedMainTextBase = Color.new(248, 248, 248)
        ExtendedMainTextShadow = Color.new(0, 0, 0)

        # true = enabled: game maps that have "no date for this location" being displayed on the extended preview will be hidden (unless you use the flag "enExtPrev").
        # false = disabled: all game maps of a same map position will be shown (unless you use the flag "disExtPrev").
        ExcludeMapsWithNoData = false

        # Add an array of other maps to a map so that the items on the maps in the array are counted toward the total items.
        # In the example below, map 3, 4 and 8 are linked to map 2 so the items findable on 3, 4 and 8 will be counted toward the total items findable on map 2.
        # You can do this for each map of those in the array as well.
        CountItemsToMainMap = {

        }

        # If you have any custom Encounter Types, you should add them here
        EncounterTypes = {
          :Land => "Grass",
          :LandMorning => "Grass (Morning)",
          :LandDay => "Grass (Day)",
          :LandAfternoon => "Grass (Afternoon)",
          :LandEvening => "Grass (Evening)",
          :LandNight => "Grass (Night)",
          :PokeRadar => "Poké Radar",
          :Cave => "Cave",
          :CaveMorning => "Cave (Morning)",
          :CaveDay => "Cave (Day)",
          :CaveAfternoon => "Cave (Afternoon)",
          :CaveEvening => "Cave (Evening)",
          :CaveNight => "Cave (Night)",
          :Water => "Surfing",
          :WaterMorning => "Surfing (Morning)",
          :WaterDay => "Surfing (Day)",
          :WaterAfternoon => "Surfing (Afternoon)",
          :WaterEvening => "Surfing (Evening)",
          :WaterNight => "Surfing (Night)",
          :OldRod => "Fishing (Old Rod)",
          :GoodRod => "Fishing (Good Rod)",
          :SuperRod => "Fishing (Super Rod)",
          :RockSmash => "Rock Smash",
          :HeadbuttLow => "Headbutt (Rare)",
          :HeadbuttHigh => "Headbutt (Common)",
          :BugContest => "Bug Contest",
		  :TrashCan => "Trash Cans",
		  :TuesdayTrashCan => "Tuesday Trash",
		  :ThursdayTrashCan => "Thursday Trash"
        }

        # true = enabled: The mapExtBoxMain will be replaced with for ex. mapExtBoxGrass for the Grass Encounter Type.
        # false = disabled: The mapExtBoxMain will remain unchanged.
        ChangeExtBoxOnEncounterType = false

        # true = enabled: The mapEncBox will be replaced with for ex. mapEncBoxGrass for the Grass Encounter Type.
        # false = disabled: The mapEncBox will remain unchanged.
        ChangeEncBoxOnEncounterType = false

        # Add a small offset to Species Info Text on the First Page.
        # This doesn't affect the Text in the Raster on the Second Page.
        ExtendedSubTextOffsetX = 0
        ExtendedSubTextOffsetY = 0

        # Change the color of the Species Info Text. (this applies to both pages).
        ExtendedSubTextMain = Color.new(248, 248, 248)
        ExtendedSubTextShadow = Color.new(0, 0, 0)

        # true = enabled: The Icons for the Unseen Species will be shown but will have a black color overlay.
        # false = disabled: The Icons for the Unseen Species will be shown with a ? Icon.
        UseSpritesForUnseenSpecies = true

        # Change the Color Unseen Species Icons will have when the Setting above is set to true (if false, this setting has no effect).
        UnseenSpeciesColor = Color.new(0, 0, 0)

        # Change the Tone Uncaught Species Icons will have.
        UncaughtSpeciesTone = Tone.new(0, 0, 0, 255)

      #========================== Weather Preview Settings ======================#

        # true = enabled: This Feature can be used.
        # false = disabled.
        UseWeatherPreview = false

        # true = enabled: The Weather Preview will only show when viewing a Location's info by using the Location Preview (Normal Mode only).
        # false = disabled. The Weather Preview will always show (when available) for a Location.
        WeatherOnLocationPreviewActive = true

        # Set here in an Array, which modes can display the Weather Preview. (only the number)
        # 0 = Normal Map
        # 1 = Fly Map (this applies to both Flying methods (through the Town Map or Using Fly directly))
        # 2 = Quest Map
        # 3 = Berry Map (not used yet)
        # 4 = Roaming Map (also not used yet).
        WeatherOnModes = [0, 1, 2]

      #=========================== Quest Preview Settings =======================#

        # true or 0 = enabled: Quest Icons will be displayed on the Region Map (Quest Mode) (only the Region Map opened from the Item or PokeGear/Main menu).
        # false or -1 = disabled.
        # Switch ID = enabled when the Switch is ON.
        # This mode will be hidden if there are no active quests (with a map position defined) or if the MQS plugin is not installed.
        ShowQuestIcons = true

        # Choose which button will activate the Quest Review.
        # Possible buttons are: USE, JUMPUP, JUMPDOWN, SPECIAL, AUX1 and AUX2. any other buttons are not recommended.
        # USE can be used this time because unlike with the fly map, it won't do anything.
        # Press F1 in game to know which key a button is linked to.
        # IMPORTANT: only change the "USE" to JUMPDOWN for example so ShowQuestButton = Input::JUMPDOWN
        ShowQuestButton = Input::USE

        # How to edit the Quest preview Box Graphics:
        # This is a bit less complex than the Location Preview Graphics as there are no Alt versions this time.
        # Simple formula to calculate the Total Height of the Graphic :
        # PreviewLineHeight * Total Lines.
        # This includes the Task and Location information.
        MaxQuestLines = 4

        # Add a small offset to the Quest Task and Location Text position.
        QuestInfoTextOffsetX = 0
        QuestInfoTextOffsetY = 0

        # Change the Color of the Quest Task and Location Text.
        QuestInfoTextBase = Color.new(248, 248, 248)
        QuestInfoTextShadow = Color.new(0, 0, 0)

      #=========================== Berry Preview Settings =======================#
        # SHOW_BERRIES_ON_MAP_SWITCH_ID (in the TDW Berry Planting Improvements's Settings file) will be overwritten by this Setting.
        # if you set this to ShowBerryIcons = Settings::SHOW_BERRIES_ON_MAP_SWITCH_ID it'll use the value you've set in that plugin's Settings.
        # true or 0 = enabled: Berry Icons will be shown on the Region Map (Berry Mode).
        # false or -1 = disabled.
        # Switch ID = enabled when the Switch is ON.
        # The Berry mode will be hidden if there are no Berries Planted or when the TDW Berry Planting Improvements Plugin is not installed.
        ShowBerryIcons = false

        # Choose the button you need to press to view information about the Berries planted on the current Location.
        ShowBerryButton = Input::USE

        # Exactly the same as the Quest Preview Setting but then for the Berry Preview
        MaxBerryLines = 4

        # Add a small offset to the Berry Info Text position.
        BerryInfoTextOffsetX = 0
        BerryInfoTextOffsetY = 0

        # Change the Color of the Berry Info Text.
        BerryInfoTextBase = Color.new(248, 248, 248)
        BerryInfoTextShadow = Color.new(0, 0, 0)

      #============================ Roaming Icon Settings =======================#
        # true or 0 = enabled: Roaming Icons will be shown on the Region Map (Roaming Mode).
        # false or -1 = disabled.
        # Switch ID = enabled when the Switch is ON.
        ShowRoamingIcons = false

      #=======================Trainer Rematches Preview Settings=================#
        # true or 0 = enabled: Trainer Icons will be shown on the Region Map (Trainer Mode).
        # false or -1 = disabled.
        # Switch ID = enabled when the Switch is ON.
        ShowTrainerIcons = false

        # Define your Trainer Rematches here by giving a name, the trainer class, event ID and mapID.
        # You can either use a self switch of the event itself or a Game Switch to trigger 1 or more Trainer Rematches at once.
        TrainerRematchesConfig = {

        }

    #=============================== Pokedex Settings =============================#   
      # Choose which button will activate Region Switching on the Pokedex Area Section (nil means disabled)
      ToggleRegionSwitchButton = Input::ACTION 

      # Choose which button will activate the Location Filter Menu on the Pokedex Area Section (nil mean disabled)
      ToggleLocFilterButton = Input::SPECIAL

      # Choose which button will activate the Encounter Type Filter Menu on the Pokedex Area Section (nil means disabled)
      ToggleEncTypeFilterButton = Input::JUMPDOWN

      # "default" = location filter and encounter type filter trigger separatly
      # "choice" = choice menu with which filter to choose and apply.
      # "followUp" = follow up choice menu with the Encounter Type filter first, then the Location Filter
      FilterMenuType = "default"

  end
#======================================= The End ======================================#

# =========== Instructions ===========
# 1. Define any custom event indicators in EVENT_INDICATORS below. (See Defining Indicators)
# 2. Open the event page that you want to show an indicator when active
# 3. In that event page, add a new Comment command.
# 4. Add text to the Comment in the format noted below. The first line must be
#    "Event Indicator" without quotes. The second line follows the format
#    <indicator id> <x adjustment> <y adjustment>
#    - Replace <indicator ID> with the ID of the indicator you want to use. For example, 
#      you could replace it with the word quest for the "quest" indicator.
#    - (Optional) Replace <x adjustment> with the value of x that you want to
#      adjust the placement of the indicator by. For example, you could replace it 
#      with 2 if you want it to be 2 pixels to the right.
#    - (Optional) Replace <y adjustment> with the value of y that you want to
#      adjust the placement of the indicator by. For example, you could replace it 
#      with -6 if you want it to be 6 pixels up.
#   
#    Format:
#      Event Indicator
#      <indicator id> <x adjustment> <y adjustment>
#
#    Example 1:
#      Event Indicator
#      quest
#
#    Example 2:
#      Event Indicator
#      question 2 -6
#
# 5. You're all set! Now when that event page is active, it should show your indicator.
#
# =========== Defining Indicators ===========
# Define each indicator for your game in EVENT_INDICATORS in the Settings module below.
# Each indicator definition is a hash, where the key is the ID of the indicator, as a string, 
# that you'll use when adding Comments to event pages. There are two values/parameters you 
# can define for your indicator:
#   - :graphic => String - The filepath of the graphic you want to use for the indicator
#   - :x_adjustment => (Optional) Integer - Adjust the indicator's x position by this value. 
#                      Can be positive or negative.
#   - :y_adjustment => (Optional) Integer - Adjust the indicator's y position by this value. 
#                      Can be positive or negative.
#   - :always_visible => (Optional) Boolean - If true, the indicator will be visible even when 
#                        you run/interact with the event. If not set or set to false, the
#                        indicator will disappear when you run/interact with the event.
#   - :movement_speed => (Optional) Integer - Adjust the vertical movement speed for this
#                        indicator. The lower the number, the faster the movement.
#   - :no_movement => (Optional) Boolean - If true, the indicator will not have vertical movement.
#   - :animation_frames => (Optional) Integer - Set the number of frames contained within
#                        the graphic for this indicator, to be used for animating the graphic.
#   - :animation_speed => (Optional) Integer - Adjust the animation speed for this
#                        indicator's graphic. The lower the number, the faster the animation.
#   - :condition => (Optional) Proc - Set a condition for the indicator to be visible. 
#                       If not set, it will always appear if the event page is active.
#                       Example: proc { $game_switches[5] }
#  Example:
#        "question" => {
#            :graphic => "Graphics/UI/Event Indicators/event_question",
#            :always_visible => true,
#            :x_adjustment => 2,
#            :y_adjustment => -6,
#            :ignore_time_shading => true,
#            :movement_speed => 20,
#            :animation_frames => 4,
#            :animation_speed => 10,
#        }
#
# =========== Use Cases ===========
# The use case that spawned this plugin is to show an indicator when the event
# can give you a quest. After defining a "quest" indicator in EVENT_INDICATORS,
# You would add the appropriate Comment to the event, in the appropriate page.
# After you run/interact with the event, which gives you the quest, you'll
# likely set a Self Switch or some other condition to make a new page become
# active for the event. Don't include an indicator Comment to that page,
# and it will no longer show an indicator. If wanted, the new page can show
# a new indicator by adding a Comment to that page as well.


module Settings

    #------------------------------------------------------------------------------------
    # Define your Event Indicators
    #------------------------------------------------------------------------------------
    EVENT_INDICATORS = {
        "quest" => {
            :graphic => "Graphics/UI/Event Indicators/quest_available",
            :movement_speed => 20
        },
        "questsimple" => {
            :graphic => "Graphics/UI/Event Indicators/quest_available_simple"
        },
        "questsimpleanimated" => {
            :graphic => "Graphics/UI/Event Indicators/quest_available_simple_anim",
            :animation_frames => 4
        },
        "questsimpleanimatednomove" => {
            :graphic => "Graphics/UI/Event Indicators/quest_available_simple_anim",
            :animation_frames => 4,
            :no_movement => true
        },
        "questshortnpc" => {
            :graphic => "Graphics/UI/Event Indicators/quest_available",
            :y_adjustment => 4
        },
        "question" => {
            :graphic => "Graphics/UI/Event Indicators/event_question",
            :always_visible => true,
            :ignore_time_shading => true
        },
		"questbugmaster" => {
            :graphic => "Graphics/UI/Event Indicators/quest_bugmaster",
            :movement_speed => 30,
			:y_adjustment => -20
        },
		"questdarkmaster" => {
            :graphic => "Graphics/UI/Event Indicators/quest_darkmaster",
            :movement_speed => 30,
			:y_adjustment => -20
        },
		"questdragonmaster" => {
            :graphic => "Graphics/UI/Event Indicators/quest_dragonmaster",
            :movement_speed => 30,
			:y_adjustment => -20
        },
		"questelectricmaster" => {
            :graphic => "Graphics/UI/Event Indicators/quest_electricmaster",
            :movement_speed => 30,
			:y_adjustment => -20
        },
		"questfairymaster" => {
            :graphic => "Graphics/UI/Event Indicators/quest_fairymaster",
            :movement_speed => 30,
			:y_adjustment => -20
        },
		"questfightingmaster" => {
            :graphic => "Graphics/UI/Event Indicators/quest_fightingmaster",
            :movement_speed => 30,
			:y_adjustment => -20
        },
		"questfiremaster" => {
            :graphic => "Graphics/UI/Event Indicators/quest_firemaster",
            :movement_speed => 30,
			:y_adjustment => -20
        },
		"questflyingmaster" => {
            :graphic => "Graphics/UI/Event Indicators/quest_flyingmaster",
            :movement_speed => 30,
			:y_adjustment => -20
        },
		"questghostmaster" => {
            :graphic => "Graphics/UI/Event Indicators/quest_ghostmaster",
            :movement_speed => 30,
			:y_adjustment => -20
        },
		"questgrassmaster" => {
            :graphic => "Graphics/UI/Event Indicators/quest_grassmaster",
            :movement_speed => 30,
			:y_adjustment => -20
        },
		"questgroundmaster" => {
            :graphic => "Graphics/UI/Event Indicators/quest_groundmaster",
            :movement_speed => 30,
			:y_adjustment => -20
        },
		"questicemaster" => {
            :graphic => "Graphics/UI/Event Indicators/quest_icemaster",
            :movement_speed => 30,
			:y_adjustment => -20
        },
		"questnormalmaster" => {
            :graphic => "Graphics/UI/Event Indicators/quest_normalmaster",
            :movement_speed => 30,
			:y_adjustment => -20
        },
		"questpoisonmaster" => {
            :graphic => "Graphics/UI/Event Indicators/quest_poisonmaster",
            :movement_speed => 30,
			:y_adjustment => -20
        },
		"questpsychicmaster" => {
            :graphic => "Graphics/UI/Event Indicators/quest_psychicmaster",
            :movement_speed => 30,
			:y_adjustment => -20
        },
		"questrockmaster" => {
            :graphic => "Graphics/UI/Event Indicators/quest_rockmaster",
            :movement_speed => 30,
			:y_adjustment => -20
        },
		"queststeelmaster" => {
            :graphic => "Graphics/UI/Event Indicators/quest_steelmaster",
            :movement_speed => 30,
			:y_adjustment => -20
        },
		"queststellarmaster" => {
            :graphic => "Graphics/UI/Event Indicators/quest_stellarmaster",
            :movement_speed => 30,
			:y_adjustment => -20
        },
		"questunknownmaster" => {
            :graphic => "Graphics/UI/Event Indicators/quest_unknownmaster",
            :movement_speed => 30,
			:y_adjustment => -20
        },
		"questwatermaster" => {
            :graphic => "Graphics/UI/Event Indicators/quest_watermaster",
            :movement_speed => 30,
			:y_adjustment => -20
        },
    }

    #------------------------------------------------------------------------------------
    # Set x and y adjustments that will apply to all event indicators. Can be positive
    # or negative.
    #------------------------------------------------------------------------------------
    EVENT_INDICATOR_X_ADJ = 0
    EVENT_INDICATOR_Y_ADJ = 0

    #------------------------------------------------------------------------------------
    # Set to true to allow the player to hide indicators in the Options menu.
    #------------------------------------------------------------------------------------
    EVENT_INDICATOR_ALLOW_HIDE_OPTION = false

    #------------------------------------------------------------------------------------
    # Set to true to have indicators bob up and down, when visible.
    #------------------------------------------------------------------------------------
    EVENT_INDICATOR_VERTICAL_MOVEMENT = true

    #------------------------------------------------------------------------------------
    # Set to an integer representing the number of runtime frames between each vertical 
    # movement frame. The lower the number, the faster the movement.
    #------------------------------------------------------------------------------------
    EVENT_INDICATOR_DEFAULT_MOVEMENT_SPEED = 10

    #------------------------------------------------------------------------------------
    # Set to true to allow the player to disable indicator movement in the Options menu.
    #------------------------------------------------------------------------------------
    EVENT_INDICATOR_ALLOW_MOVEMENT_OPTION = false

    #------------------------------------------------------------------------------------
    # Set to an integer representing the number of runtime frames between each graphic 
    # frame for indicators with multiple frames. The lower the number, the faster the 
    # movement.
    #------------------------------------------------------------------------------------
    EVENT_INDICATOR_DEFAULT_ANIMATION_SPEED = 10

end
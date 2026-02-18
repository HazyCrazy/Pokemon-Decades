#=====================================================================================================
# Settings
#=====================================================================================================
module Settings

	#------------------------------------------------------------------------------
	# Due to the complications this plugin creates with being compatible with stuff
	# I made this setting in case you have an edited summary screen that is not 
	# from the "EVs and IVs in Summary v20" or "BW Summary Screen" plugins.
	#
	# If the below setting is true, it will cause direct edits to drawPageThree instead of aliasing:
	# 1) Stat names will be a couple tiles to the left, making the screen look better.
	# 2) The ability + description text will be directly replaced with the EV allocation text
	# 3) The overlay picture used for hiding the ability+description doesn't happen anymore.
	#------------------------------------------------------------------------------

	I_EDITED_MY_SUMMARY = false  # default = false for compatibility

	#==================================================================================================================

	# If you dont like the Mixed EVs part but want to keep everyting else about this plugin, you can disable it below
	PURIST_MODE = false  # default = false  because i'm biased towards my system.
	
end	
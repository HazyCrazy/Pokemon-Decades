# Character Selector by FL
def pbCharacterSelect
  overworld = [
	"trainer_PLAYER_TRAINER_FRLG_Red","trainer_PLAYER_TRAINER_FRLG_Leaf",
    "trainer_PLAYER_TRAINER_HGSS_Ethan","trainer_PLAYER_TRAINER_HGSS_Lyra",
	"trainer_PLAYER_TRAINER_COLO_Wes", "trainer_PLAYER_TRAINER_GSC_Kris",
	"trainer_PLAYER_TRAINER_ORAS_Brendan","trainer_PLAYER_TRAINER_ORAS_May",
	"trainer_PLAYER_TRAINER_PL_Lucas","trainer_PLAYER_TRAINER_PL_Dawn",
	"trainer_PLAYER_TRAINER_BW1_Hilbert","trainer_PLAYER_TRAINER_BW1_Hilda",
    "trainer_PLAYER_TRAINER_B2W2_Nate","trainer_PLAYER_TRAINER_B2W2_Rosa"
    ]
  
  battle = [
	"PLAYER_TRAINER_FRLG_Red","PLAYER_TRAINER_FRLG_Leaf",
    "PLAYER_TRAINER_HGSS_Ethan","PLAYER_TRAINER_HGSS_Lyra",
	"PLAYER_TRAINER_COLO_Wes","PLAYER_TRAINER_GSC_Kris",
	"PLAYER_TRAINER_ORAS_Brendan","PLAYER_TRAINER_ORAS_May",
	"PLAYER_TRAINER_PL_Lucas","PLAYER_TRAINER_PL_Dawn",
	"PLAYER_TRAINER_BW1_Hilbert","PLAYER_TRAINER_BW1_Hilda",
    "PLAYER_TRAINER_B2W2_Nate","PLAYER_TRAINER_B2W2_Rosa"
    ]
  result = startCharacterSelection(overworld,battle) 
  pbChangePlayer(result+1)
  pbTrainerName
end 
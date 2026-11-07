@abstract 
extends Resource


class_name MiniGameResource

enum GameType{
	None,
	ANGRYPOT,
	METEOR
	}

@abstract func get_game_type()->GameType

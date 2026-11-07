@abstract 
extends Resource


class_name MiniGameResource

enum GameType{
	None,
	ANGRYPOT,
	METEOR,
	PAINT
	}

@abstract func get_game_type()->GameType

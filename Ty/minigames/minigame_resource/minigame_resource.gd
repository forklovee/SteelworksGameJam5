@abstract 
class_name MiniGameResource extends Resource

enum GameType{
	None,
	Angrypot,
	Meteor,
	StockManipulation,
	ContractChange,
}

@abstract func get_game_type()->GameType

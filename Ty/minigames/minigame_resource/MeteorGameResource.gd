extends MiniGameResource
class_name MeteorGameResource
@export var backgound_color:Color
@export var rock_times:Array[float]

func get_game_type():
	return MiniGameResource.GameType.METEOR

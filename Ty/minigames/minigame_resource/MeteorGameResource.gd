extends MiniGameResource
class_name MeteorGameResource
@export var backgound_color:Color
@export var rock_times:Array[float]
@export var wave:int=1

func get_game_type():
	return MiniGameResource.GameType.METEOR

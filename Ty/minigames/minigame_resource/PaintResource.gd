extends MiniGameResource
class_name PaintGameResource
@export var backgound_color:Color
@export var painting:CompressedTexture2D
func get_game_type():
	return MiniGameResource.GameType.PAINT

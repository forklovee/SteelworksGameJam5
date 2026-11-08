extends Node

func _ready() -> void:
	get_viewport().warp_mouse(
		get_viewport().get_visible_rect().size*.5
	)

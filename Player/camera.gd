class_name Player extends Camera2D

signal scroll_requested(direction: Vector2)

const SCROLL_MARGIN_PX := 100

@export var center_point: Marker2D
@export var position_limits: Rect2i = Rect2i()

var target_position: Vector2

func _process(delta: float) -> void:
	var mouse_position := get_viewport().get_mouse_position()
	var viewport_size := get_viewport_rect().size
	
	if mouse_position.x < SCROLL_MARGIN_PX:
		move_view(Vector2.LEFT)
	elif mouse_position.x > viewport_size.x - SCROLL_MARGIN_PX:
		move_view(Vector2.RIGHT)
	if mouse_position.y < SCROLL_MARGIN_PX:
		move_view(Vector2.UP)
	elif mouse_position.y > viewport_size.y - SCROLL_MARGIN_PX:
		move_view(Vector2.DOWN)
	
	offset = offset.lerp(target_position, delta * 10.0)

func move_view(direction: Vector2, force: float = 10.0):
	target_position = (target_position + (direction * force)).clamp(position_limits.position, position_limits.size)
	scroll_requested.emit(direction)

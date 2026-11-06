class_name Player extends Camera2D

const COOLDOWN_HOLD_TIME_MSEC := 75.0

signal scroll_requested(direction: Vector2)

@export var scrolling_margin := 50

@export var position_limits: Rect2i = Rect2i()

var target_position: Vector2

var is_mouse_pressed: bool
var last_pressed_msec: float
var hovered_object: GameObject
var held_object: GameObject

func _ready() -> void:
	Game.player = self

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("LeftMouseButton"):
		is_mouse_pressed = true
		last_pressed_msec = Time.get_ticks_msec()
	elif Input.is_action_just_released("LeftMouseButton"):
		is_mouse_pressed = false
		var mouse_pressed_time_elapsed := Time.get_ticks_msec() - last_pressed_msec
		if is_instance_valid(hovered_object) and mouse_pressed_time_elapsed < COOLDOWN_HOLD_TIME_MSEC:
			hovered_object._on_object_clicked()
		if is_instance_valid(held_object):
			held_object._on_object_ended_holding()
		held_object = null

func _process(delta: float) -> void:
	var viewport_mouse_position := get_viewport().get_mouse_position()
	var viewport_size := get_viewport_rect().size
	
	# Item holding
	if !held_object and is_instance_valid(hovered_object) and is_mouse_pressed:
		var mouse_pressed_time_elapsed := Time.get_ticks_msec() - last_pressed_msec
		if mouse_pressed_time_elapsed > COOLDOWN_HOLD_TIME_MSEC:
			held_object = hovered_object
			held_object._on_object_started_holding()
	if is_instance_valid(held_object):
		held_object.global_position = get_local_mouse_position()
	
	# Screen scrolling
	if viewport_mouse_position.x < scrolling_margin:
		move_view(Vector2.LEFT)
	elif viewport_mouse_position.x > viewport_size.x - scrolling_margin:
		move_view(Vector2.RIGHT)
	if viewport_mouse_position.y < scrolling_margin:
		move_view(Vector2.UP)
	elif viewport_mouse_position.y > viewport_size.y - scrolling_margin:
		move_view(Vector2.DOWN)
	
	offset = offset.lerp(target_position, delta * 10.0)

func move_view(direction: Vector2, force: float = 10.0):
	target_position = (target_position + (direction * force)).clamp(position_limits.position, position_limits.size)
	scroll_requested.emit(direction)

func set_hovered_object(new_hovered_object: GameObject):
	hovered_object = new_hovered_object
	print("Hovered: ", hovered_object)

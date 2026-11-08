class_name BankSlingshot extends Area2D

@onready var _projectile_res := preload("res://Ty/minigames/bank_smash/assets/splingshot_projectile.tscn")

@onready var item_slot: Node2D = $ItemSlot
@onready var projectle_slot: Node2D = $ItemSlot/KamienSlot
@onready var band_line: Line2D = $BandLine
@onready var laser_line: Line2D = $ItemSlot/Laser
@onready var laser_pointer: Node2D = $ItemSlot/Laser/Pointer
@onready var hitbox: Area2D = $Hitbox

var projectile: Node2D
var is_grabbed: bool = false
var target_point: Vector2

func _input(_event: InputEvent) -> void:
	if !is_grabbed: return
	if Input.is_action_just_released("LeftMouseButton"):
		_on_band_released()

func _on_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	if Input.is_action_just_pressed("LeftMouseButton"):
		_on_band_grabbed()

func _ready() -> void:
	laser_line.hide()
	load_projectile()
	

func _process(_delta: float) -> void:
	if !is_grabbed: return
	
	var mouse_offset := get_local_mouse_position()
	item_slot.position = mouse_offset
	_update_band_position(mouse_offset)
	_update_laser(mouse_offset)

func _on_band_grabbed():
	is_grabbed = true
	laser_line.show()

func _on_band_released():
	is_grabbed = false
	laser_line.hide()
	
	var target_position: Vector2 = $ItemSlot/Laser/Pointer.global_position
	for window in hitbox.get_overlapping_areas(): 
		if window is BankWindow:
			shoot_towards(window, target_position)
			break
	shoot_towards(null, target_position)
	
	var tween := get_tree().create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.tween_method(_update_band_position, band_line.get_point_position(1), Vector2.ZERO, 0.5)

func load_projectile():
	projectile = _projectile_res.instantiate()
	projectle_slot.add_child(projectile)

func shoot_towards(window: BankWindow, global_point: Vector2):
	var shot_projectile := projectile
	load_projectile()
	shot_projectile.reparent(self, true)
	var duration := 0.4
	var tween := get_tree().create_tween().set_parallel().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(shot_projectile, "global_position", global_point, duration)
	tween.tween_property(shot_projectile, "scale", Vector2.ONE*0.1, duration)
	await tween.finished
	if window:
		window.break_window()
	shot_projectile.queue_free()

func _update_band_position(offset: Vector2):
	band_line.set_point_position(1, offset + Vector2(-80.0, 0))
	band_line.set_point_position(2, offset)
	band_line.set_point_position(3, offset + Vector2(80.0, 0))
	item_slot.position = offset

func _update_laser(offset: Vector2):
	target_point = -offset * 4.0
	laser_line.set_point_position(1, target_point)
	laser_pointer.position = target_point
	hitbox.global_position = laser_pointer.global_position

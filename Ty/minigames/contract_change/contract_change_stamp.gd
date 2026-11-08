class_name ContractStamp2D extends Area2D

@onready var success_sound := preload("res://Ty/minigames/contract_change/Sounds/ralsei-splat.mp3")
@onready var fail_sound := preload("res://Ty/minigames/contract_change/Sounds/bone-crack.mp3")

@onready var rest_position := global_position
@onready var sfx_player := $AudioStreamPlayer2D
@export var type: ContractPage.Type = ContractPage.Type.Creation

var is_picked_up: bool = false
var is_picked_stamp_hovering: bool = false
var hover_tween: Tween

func set_interaction_enabled(state: bool):
	monitorable = state
	input_pickable = state

func pick_up():
	is_picked_up = true
	$Sprite2D.position.y = 0.0

func put_away():
	is_picked_up = false
	is_picked_stamp_hovering = false
	_fly_to_rest_position()

func stamp(is_successful: bool):
	set_interaction_enabled(false)
	
	sfx_player.stream = success_sound if is_successful else fail_sound
	sfx_player.play()
	
	var stamp_mark_res: PackedScene
	match type:
		ContractPage.Type.B2B:
			stamp_mark_res = ResourceLoader.load("res://Ty/minigames/contract_change/Assets/stamp_mark_b2b.tscn")
		ContractPage.Type.Creation:
			stamp_mark_res = ResourceLoader.load("res://Ty/minigames/contract_change/Assets/stamp_mark_creation.tscn")
	var stamp_mark: Node2D = stamp_mark_res.instantiate()
	stamp_mark.modulate = Color(0.718, 0.0, 0.137, 1.0) if !is_successful else Color(0.0, 0.788, 0.275, 1.0)
	get_parent().add_child(stamp_mark)
	stamp_mark.global_position = $Sprite2D.global_position
	_fly_to_rest_position()

func get_stamp_sprite() -> Sprite2D:
	return $Sprite2D

func _fly_to_rest_position():
	is_picked_up = false
	var tween := get_tree().create_tween()
	tween.tween_property($Sprite2D, "global_position", rest_position, 0.15)
	await tween.finished
	set_interaction_enabled(true)


func _on_mouse_entered() -> void:
	if is_picked_up:
		is_picked_stamp_hovering = true
		return
	if hover_tween:
		hover_tween.stop()
	hover_tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	hover_tween.tween_property($Sprite2D, "position:y", -5.0, 0.2)

func _on_mouse_exited() -> void:
	if is_picked_up:
		is_picked_stamp_hovering = false
		return
	if hover_tween:
		hover_tween.stop()
	hover_tween = get_tree().create_tween().set_ease(Tween.EASE_OUT)
	hover_tween.tween_property($Sprite2D, "position:y", 0.0, 0.2)

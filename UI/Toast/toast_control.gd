
extends Control

@export var toast: Panel
@export var boss_image: TextureRect
@export var boss_name: Label
@export var boss_title: Label
@export var boss_message: Label
@export var anim_duration: float = 0.5
@export var hidden_offset: float = -200.0
@export var shown_offset: float = 20.0

var tween: Tween

func _ready() -> void:
	boss_name.text = "Szef"
	toast.offset_transform_position = Vector2(0, hidden_offset)
	toast.modulate.a = 0.0
	toast.visible = false

func show_boss_message(title: String, message: String) -> void:
	boss_message.text = message
	boss_title.text = title
	if tween and tween.is_running():
		tween.kill()
	
	toast.visible = true
	toast.modulate.a = 1.0
	tween = create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(
		toast,
		"offset_transform_position",
		Vector2(0, shown_offset),
		anim_duration
	)
	tween.tween_property(
		toast,
		"modulate:a",
		1.0,
		anim_duration
	)

func hide_boss_message() -> void:
	if tween and tween.is_running():
		tween.kill()
	
	tween = create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(
		toast,
		"offset_transform_position",
		Vector2(0, hidden_offset),
		anim_duration
	)
	tween.tween_property(
		toast,
		"modulate:a",
		0.0,
		anim_duration
	)
	await tween.finished
	toast.visible = false

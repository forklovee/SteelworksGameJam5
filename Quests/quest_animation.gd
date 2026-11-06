extends Node

@export var toast: Control
@export var tablet: Control

var toast_time: float = 4.0
var animation_time: float = 8.0

func _ready() -> void:
	new_quest("chuj", "chuj")

func new_quest(title: String, message: String) -> void:
	tablet.hover_disabled = true
	toast.show_boss_message(title, message)
	
	await get_tree().create_timer(toast_time).timeout
	
	tablet.show_tablet()
	
	await get_tree().create_timer(animation_time).timeout
	
	toast.hide_boss_message()
	tablet.hide_tablet()
	tablet.hover_disabled = false

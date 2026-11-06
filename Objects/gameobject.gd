class_name GameObject extends Area2D

@onready var rest_global_position := global_position

func _ready() -> void:
	set_process(false)
	mouse_entered.connect(Game._on_gameobject_hovered.bind(self))
	mouse_exited.connect(Game._on_gameobject_unhovered.bind(self))

func reset_position():
	global_position = rest_global_position

func _on_object_clicked():
	print(self, " clicked!")

func _on_object_started_holding():
	print(self, " started hold!")

func _on_object_ended_holding():
	print(self, " ended hold!")
	reset_position()

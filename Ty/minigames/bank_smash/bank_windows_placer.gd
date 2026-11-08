extends Node2D

@onready var _window_res := preload("res://Ty/minigames/bank_smash/assets/bank_window.tscn")

@export var rows: int = 2:
	set(value):
		rows = value
		_place_windows()
@export var columns: int = 5:
	set(value):
		columns = value
		_place_windows()

func _place_windows():
	const column_step := 
	for x in range(columns):
		for y in range(rows):
			var window_pos := Vector2(
				x 
			)

@tool
extends ColorRect

@export var selected_id:int
@export var active_color:Color
@export var passive_color:Color

func _process(delta: float) -> void:
	for id in range(get_child_count()):
		if id==selected_id:
			get_child(id).color=active_color
		else:
			get_child(id).color=passive_color
	
	if Input.is_key_pressed(KEY_1):
		selected_id=0
	if Input.is_key_pressed(KEY_2):
		selected_id=1

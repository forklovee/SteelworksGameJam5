extends Area2D


func _physics_process(delta: float) -> void:
	for b in get_overlapping_bodies():
		if b.name=="Eat_Item":
			$"../..".end(true)
	
			#get_tree().reload_current_scene()

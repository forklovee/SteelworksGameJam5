extends AnimationPlayer

func _on_animation_finished(_anim_name: StringName) -> void:
	get_tree().change_scene_to_file("res://main.tscn")

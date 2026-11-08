extends Sprite2D

@export var fade_start_sec := 0.5
@export var fade_duration_sec := 0.5

func _ready() -> void:
	rotation_degrees = randf_range(-25.0, 25.0)
	
	var tween := get_tree().create_tween().set_parallel(false)
	tween.tween_interval(fade_start_sec)
	tween.tween_property(self, "modulate:a", 0.0, fade_duration_sec)
	await tween.finished
	queue_free()

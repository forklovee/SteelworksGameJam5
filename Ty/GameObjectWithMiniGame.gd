extends GameObject

@export var key:GameObject
@export var minigame:MiniGameResource
@export var minigameSystem:MiniGameSystem

func _physics_process(delta: float) -> void:
	if key in get_overlapping_areas():
		minigameSystem.play(minigame)
		self.queue_free()
		

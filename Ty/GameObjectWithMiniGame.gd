extends GameObject

@export var key:GameObject
@export var minigame:MiniGameResource
@export var minigameSystem:MiniGameSystem
@export var minigame_transform_input:Dictionary[String,Node]={}

func _physics_process(delta: float) -> void:
	if key in get_overlapping_areas():
		if minigame_transform_input!={}:
			minigameSystem.play(minigame,minigame_transform_input)
		else:
			minigameSystem.play(minigame)
		self.queue_free()
		

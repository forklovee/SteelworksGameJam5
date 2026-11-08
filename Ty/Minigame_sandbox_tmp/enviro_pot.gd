extends Sprite2D

@export var minigame:MiniGameResource
@export var minigame_transform_input:Dictionary[String,Node]

func _process(delta: float) -> void:
	
	#var on_win=func ():
	#	$"../CanvasLayer/SubViewportContainer".visible=false
	
	
	#if Input.is_key_pressed(KEY_5):
	#	$"../CanvasLayer/SubViewportContainer".visible=true
	#	$"../CanvasLayer/SubViewportContainer/SubViewport/angry_pot".start($"../Camera2D",on_win)
	if Input.is_action_just_pressed("mouse_click"):
		if self.get_rect().has_point( self.get_local_mouse_position()):
			if minigame_transform_input!={}:
				minigame_transform_input["Ammo"]=$"../bar".get_child($"../bar".selected_id).get_child(0)
			$"../MiniGameSystem".play(minigame,minigame_transform_input)
	#		$"../CanvasLayer/SubViewportContainer".visible=true
	#		$"../CanvasLayer/SubViewportContainer/SubViewport/angry_pot".start($"../Camera2D",on_win)
	if self.get_rect().has_point( self.get_local_mouse_position()):
		self.modulate=Color.WHITE
	else:
		self.modulate=Color.GRAY

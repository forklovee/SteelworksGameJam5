extends Node
var on=false
var t=0.0 
@export var c:Color

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("mouse_click"):
		on=true
		$ColorRect.color=c
	if on:
		t+=delta
		if t>1.0:
				self.queue_free()
				$"../NotaCookingGame".process_mode=Node.PROCESS_MODE_INHERIT

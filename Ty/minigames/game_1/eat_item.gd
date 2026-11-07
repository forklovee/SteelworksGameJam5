extends RigidBody2D

func _process(delta: float) -> void:
	if self.position.y>300.0:
		$"../..".end(false)

extends Node

var player: Player
var level #TODO

func _on_gameobject_hovered(gameobject: GameObject):
	if !is_instance_valid(player):
		printerr("Player not set! Can't change hovered object!")
		return
	player.set_hovered_object(gameobject)

func _on_gameobject_unhovered(_gameobject: GameObject):
	if !is_instance_valid(player):
		printerr("Player not set! Can't change hovered object!")
		return
	player.set_hovered_object(null)

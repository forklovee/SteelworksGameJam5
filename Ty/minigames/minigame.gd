class_name MiniGame extends Node

signal finished(minigame: MiniGame, percent_successful: float)

var debug_mode := false

func _ready() -> void:
	if get_tree().current_scene == self: # If minigame scene started with F6, start minigame normally.
		debug_mode = true
		start(null, func(): return, null)

func start(game_camera: Camera2D, _on_win: Callable, game: MiniGameResource):
	print(self, " STARTED!")

func finish(percent_successful: float):
	print(self, " FINISHED with ", percent_successful * 100.0, "% success!")
	finished.emit(self, percent_successful)

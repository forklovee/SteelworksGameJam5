class_name MiniGame extends Node

signal finished(minigame: MiniGame)

func _ready() -> void:
	start()

func start():
	print(self, " STARTED!")

func finish():
	print(self, " FINISHED")
	finished.emit(self)

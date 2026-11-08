class_name MiniGame extends Node

signal finished

func _ready() -> void:
	start()

func start():
	print(self, " STARTED!")

func finish():
	print(self, " FINISHED")
	finished.emit()

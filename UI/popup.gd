extends Panel

func _ready() -> void:
	show()
	$Button.pressed.connect(start)

func start() -> void:
	$"../../QuestAnimation".popup(self)

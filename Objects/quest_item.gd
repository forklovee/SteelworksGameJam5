extends Area2D

var is_active: bool = false
var minigame: String

var stonks: PackedScene = preload("res://Ty/minigames/game_1/angry_pot.tscn")
var gotowanie: PackedScene = preload("res://Ty/minigames/game_1/angry_pot.tscn")
var umowy: PackedScene = preload("res://Ty/minigames/contract_change/contract_change.tscn")
var bank: PackedScene = preload("res://Ty/minigames/game_1/angry_pot.tscn")

func _ready() -> void:
	mouse_entered.connect(on_hovered)
	mouse_exited.connect(on_unhovered)

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if is_active:
			is_active = false
			$"../../UI".hide()
			$"../../Camera2D".scrollable = false
			var game
			match minigame:
				"Stonks":
					game = stonks.instantiate()
					game.game_ended.connect(minigame_done.bind(ResourceLoader.load("res://Quests/bank.tres")))
				"Gotowanie":
					game = gotowanie.instantiate()
					game.finish.connect(outro)
				"Umowy":
					game = umowy.instantiate()
					game.finished.connect(minigame_done.bind(ResourceLoader.load("res://Quests/stonks.tres")))
				"Bank":
					game = bank.instantiate()
					game.game_ended.connect(minigame_done.bind(ResourceLoader.load("res://Quests/gotowanie.tres")))
			
			var minigame_container := get_tree().current_scene.get_node("MinigameContainer")
			minigame_container.add_child(game)
			minigame_container.show()

func minigame_done(game: MiniGame, next_quest: Quest) -> void:
	var minigame_container := get_tree().current_scene.get_node("MinigameContainer")
	minigame_container.hide()
	$"../../UI".show()
	$"../../Camera2D".scrollable = true
	game.queue_free()
	await get_tree().create_timer(2.0).timeout
	$"../../QuestAnimation".new_quest(next_quest)

func outro() -> void:
	pass

func on_hovered() -> void:
	if is_active:
		get_child(0).material.set_shader_parameter("is_active", true)
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func on_unhovered() -> void:
	get_child(0).material.set_shader_parameter("is_active", false)
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func activate(minigame_name: String) -> void:
	is_active = true
	minigame = minigame_name

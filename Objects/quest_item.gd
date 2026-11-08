extends Area2D

var is_active: bool = false
var minigame: String

var stonks: PackedScene = preload("res://Ty/minigames/game_1/angry_pot.tscn")
var gotowanie: PackedScene = preload("res://Ty/minigames/game_1/angry_pot.tscn")
var umowy: PackedScene = preload("res://Ty/minigames/game_1/angry_pot.tscn")
var bank: PackedScene = preload("res://Ty/minigames/game_1/angry_pot.tscn")

func _ready() -> void:
	mouse_entered.connect(on_hovered)
	mouse_exited.connect(on_unhovered)

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if is_active:
			is_active = false
			match minigame:
				"Stonks":
					var game = stonks.instantiate()
					game.game_ended.connect(minigame_done.bind([game, "path"]))
					get_tree().root.add_child(game)
				"Gotowanie":
					var game = gotowanie.instantiate()
					game.game_ended.connect(minigame_done.bind([game, "path"]))
					get_tree().root.add_child(game)
				"Umowy":
					var game = umowy.instantiate()
					game.game_ended.connect(minigame_done.bind([game, "path"]))
					get_tree().root.add_child(game)
				"Bank":
					var game = bank.instantiate()
					game.game_ended.connect(minigame_done.bind([game, "path"]))
					get_tree().root.add_child(game)

func minigame_done(game, next_game) -> void:
	game.queue_free()
	await get_tree().create_timer(2.0).timeout
	$"../../QuestAnimation".new_quest(next_game)

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

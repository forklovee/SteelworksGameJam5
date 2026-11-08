class_name MiniGameSystem extends CanvasLayer

@export var angry_pot_game: PackedScene
@export var meteor_game: PackedScene
@export var stock_man_game: PackedScene
@export var contract_change_game: PackedScene
@export var paint_game:PackedScene
var game_instance:MiniGame=null

func play(game:MiniGameResource):
	var on_win=func (flag):
		if flag:
			$SubViewportContainer.visible=false
			if game_instance!=null:
				game_instance.queue_free()
				game_instance=null
		else:
			$SubViewportContainer.visible=false
			if game_instance!=null:
				game_instance.queue_free()
				game_instance=null
			play(game.duplicate(true))
	var map = {
		MiniGameResource.GameType.Angrypot: angry_pot_game,
		MiniGameResource.GameType.Meteor: meteor_game,
		MiniGameResource.GameType.StockManipulation: stock_man_game,
		MiniGameResource.GameType.ContractChange: contract_change_game
		MiniGameResource.GameType.Paint:paint_game
	}
	assert(game.get_game_type() in map.keys() and map.get(game.get_game_type()) != null)
	var current_game = map[game.get_game_type()]

	$SubViewportContainer.visible=true
	game_instance=current_game.instantiate()
	$SubViewportContainer/SubViewport.add_child(game_instance)
	game_instance.start($"../Camera2D",on_win,game)
	#$SubViewportContainer/SubViewport/angry_pot.start($"../Camera2D",on_win,game)

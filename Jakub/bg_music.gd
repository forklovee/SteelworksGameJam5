extends AudioStreamPlayer

@onready var debug_menu: CanvasLayer = $DebugMenu

@export var debug: bool = false

var current_playing_clip_name: StringName

func _ready() -> void:
	%StartButton.pressed.connect(start_music)
	%OfficeButton.pressed.connect(office)
	%CookingButton.pressed.connect(cooking)
	%BankButton.pressed.connect(bank)
	%PapersButton.pressed.connect(papers)
	%StocksButton.pressed.connect(stocks)

func start_music() -> void:
	play()

func _switch_music(clip_name: StringName) -> void:
	var playback := get_stream_playback() as AudioStreamPlaybackInteractive

	if playback == null:
		return

	playback.switch_to_clip_by_name(clip_name)

	current_playing_clip_name = stream.get_clip_name(get_stream_playback().get_current_clip_index())


func office() -> void:
	_switch_music(&"Office")

func cooking() -> void:
	_switch_music(&"Cooking")

func bank() -> void:
	_switch_music(&"Bank")

func papers() -> void:
	_switch_music(&"Papers")

func stocks() -> void:
	_switch_music(&"Stocks")

func _input(event: InputEvent) -> void:
	if Input.is_action_just_released("MusicDebugMenu"):
		debug_menu.visible = !debug_menu.visible

extends MiniGame

@onready var windows_container := $Windows
@onready var minigame_finishes_screen: MinigameFinishedScreen = $MinigameFinishedScreen
@onready var timer_progressbar: ProgressBar = $ProgressBar

var total_windows: int = 0
var successes: int = 0

var tween_progressbar: Tween

func _ready() -> void:
	super()
	minigame_finishes_screen.try_again_requested.connect(start)
	minigame_finishes_screen.continue_requested.connect(finish)

func start():
	super()
	timer_progressbar.value = 0
	successes = 0
	total_windows = windows_container.get_child_count()
	for window in windows_container.get_children():
		window = window as BankWindow
		window.reset()
		if !window.broken.is_connected(_on_window_broken):
			window.broken.connect(_on_window_broken)
	_start_timer()
	

func _start_timer():
	tween_progressbar = get_tree().create_tween()
	tween_progressbar.tween_property(timer_progressbar, "value", 100.0, $GameTimer.wait_time)
	$GameTimer.start()

func _stop_timer():
	if tween_progressbar:
		tween_progressbar.stop()
	$GameTimer.stop()

func _on_window_broken():
	successes += 1
	
	if successes >= total_windows:
		_stop_timer()
		minigame_finishes_screen.setup(100.0)


func _on_game_timer_timeout() -> void:
	_stop_timer()
	minigame_finishes_screen.setup(0.0)

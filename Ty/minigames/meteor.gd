extends MiniGame

var playing:bool

func _ready() -> void:
	if get_parent().name!="SubViewport":
		playing=true
		on_win=func ():get_tree().reload_current_scene()

var on_win:Callable
func start(game_camera:Camera2D,_on_win:Callable,game:MiniGameResource):
	playing=true
	on_win=_on_win

func _process(delta: float) -> void:
	if playing:
		$rock.position.y+=100.0*delta
		$player.position.x+=100.0*delta if Input.is_key_pressed(KEY_D) else 0.0
		$player.position.x-=100.0*delta if Input.is_key_pressed(KEY_A) else 0.0
		$player.position.x=clamp($player.position.x,0,1000.0)
		if $player.get_overlapping_areas().size()>0:
			on_win.call()
		if $rock.position.y>700.0:
			on_win.call()

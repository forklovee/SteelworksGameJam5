extends MiniGame

var t=0.0

var playing:bool
@export var rock:PackedScene
var meteor_game:MeteorGameResource
var rocks=[]
var rocks_times=[]

func _ready() -> void:
	if get_parent().name!="SubViewport":
		playing=true
		on_win=func (flag):get_tree().reload_current_scene()
		meteor_game=load("res://Ty/minigames/minigame_resource/meteor1.tres")
		rocks_times=meteor_game.rock_times.duplicate()

var on_win:Callable
func start(game_camera:Camera2D,_on_win:Callable,game:MiniGameResource):
	playing=true
	on_win=_on_win
	t=0.0
	meteor_game=game
	rocks_times=meteor_game.rock_times.duplicate()
	$ColorRect.color=meteor_game.backgound_color

func _process(delta: float) -> void:
	if playing:
		t+=delta
		var m:ShaderMaterial=$"../..".material
		m.set_shader_parameter("show",min(t,1.0))	
		if t>1.0:
			if rocks_times.size()>0:
				if rocks_times.front()<t-1.0:
					rocks_times.pop_front()
					var new_rock=rock.instantiate()
					new_rock.position.y=0.0
					new_rock.position.x=1000.0*randf()
					rocks.append(new_rock)
					self.add_child(new_rock)
			for rock:Area2D in rocks:
				rock.position.y+=100.0*delta
				if rock.position.y>700.0:
					rocks.erase(rock)
					rock.queue_free()
				
			$player.position.x+=100.0*delta if Input.is_key_pressed(KEY_D) else 0.0
			$player.position.x-=100.0*delta if Input.is_key_pressed(KEY_A) else 0.0
			$player.position.x=clamp($player.position.x,0,1000.0)
			if $player.get_overlapping_areas().size()>0:
				on_win.call(false)
			if rocks.size()==0 and rocks_times.size()==0:
				on_win.call(true)

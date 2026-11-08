extends MiniGame

@export var minigame_camera:Camera2D
@export var t=0.0
var camera_from:Transform2D
var camera_to:Transform2D
var playing:bool
var shooting:bool

func _ready() -> void:
	camera_to=minigame_camera.transform
	$Line2D/Eat_Item.process_mode=Node.PROCESS_MODE_DISABLED
	$Line2D/Eat_Item.position=Vector2.ZERO

var game_camera_ref
var on_win:Callable
var game_ref
func start(game_camera:Camera2D,_on_win:Callable,game:MiniGameResource,d=null):
	$Line2D/Eat_Item.process_mode=Node.PROCESS_MODE_DISABLED
	$Line2D/Eat_Item.position=Vector2.ZERO
	$Line2D/Eat_Item.linear_velocity=Vector2.ZERO
	print("START")
	on_win=_on_win
	camera_from=game_camera.transform
	if d!=null:
		var s:Node2D=d["Pot"]
		var c:Camera2D=d["Camera"]
		camera_from=Transform2D.IDENTITY.translated(
			$GamePot.global_position-s.global_position).translated(c.global_position)
		#camera_from.translated($GamePot.global_position-s.global_position)
	game_camera_ref=game_camera
	game_ref=game
	t=0.0
	playing=true
	shooting=false
	var game_pot:AngryPotResource=game
	$ColorRect.color=game_pot.backgound_color
	
func arc(v:Vector2):
	var t=PackedVector2Array([])
	
func end(ok:bool):
	
	print("END")
	if not ok:
		#start(game_camera_ref,on_win,game_ref)
		on_win.call(false)
	else:
		playing=false
		shooting=false
		on_win.call(true)
	
	

func _process(delta: float) -> void:
	$Line2D.visible=false
	if playing:
		t=min(2.0,t+delta)
		minigame_camera.global_position=camera_from.origin.lerp(camera_to.origin,max(0.0,t-1.0))
		var m:ShaderMaterial=$"../..".material
		m.set_shader_parameter("show",min(t,1.0))
		if t>=1.5:
			$Line2D.visible=true
			var mouse_realative:Vector2=$Line2D.get_global_mouse_position()-$Line2D.global_position
			$Line2D.points=PackedVector2Array([Vector2.ZERO,mouse_realative.normalized()*100.0])
			if t>=2.0:
				if Input.is_action_just_pressed("mouse_click") and (not shooting):
					shooting=true
					$Line2D/Eat_Item.process_mode=Node.PROCESS_MODE_INHERIT
					$Line2D/Eat_Item.linear_velocity=mouse_realative.normalized()*600.0

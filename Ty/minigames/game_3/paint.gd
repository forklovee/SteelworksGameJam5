extends MiniGame

@export var tex:CompressedTexture2D
var i2:Image
var i:Image
var target_diff=1050
var start_diff=-1
var tex2:Texture2D
var playing:bool
var pgame
var on_win:Callable
var t=0.0

func start(game_camera:Camera2D,_on_win:Callable,game:MiniGameResource,d=null):
	playing=true
	on_win=_on_win
	t=0.0
	pgame=game
	$ColorRect.color=pgame.backgound_color
	parse_img()

func _ready() -> void:
	if get_parent().name!="SubViewport":
		parse_img()
func parse_img():
		i=tex.get_image()
		i2=Image.create_empty(i.get_width(),i.get_height(),false,Image.FORMAT_RGB8)
		print(i.get_pixel(0,0))
		for y in range(i2.get_height()):
			for x in range(i2.get_height()):
				i2.set_pixel(x,y,Color.WHITE)
		var diffrence=0.0
		for y in range(i2.get_height()):
			for x in range(i2.get_height()):
				diffrence+=round(abs(i2.get_pixel(x,y).r-i.get_pixel(x,y).r))
		print(diffrence)
		start_diff=diffrence
		print(i2.get_pixel(0,0))
		tex2=ImageTexture.create_from_image(i2)
		$Paint.texture=tex2
		$ColorRect/ColorRect2.scale.x=1.0-(diffrence-target_diff)/(start_diff-target_diff)

func _process(delta: float) -> void:
	t+=delta
	if get_parent().name=="SubViewport":
		var m:ShaderMaterial=$"../..".material
		m.set_shader_parameter("show",min(t,1.0))	
	
	if Input.is_action_pressed("mouse_click"):
		print("click")
		var p=$Paint.to_local(get_viewport().get_mouse_position())
		if $Paint.get_rect().has_point($Paint.to_local(get_viewport().get_mouse_position())):
			var pc=p+Vector2(32,32)
			i2.set_pixelv(pc,Color.BLACK)
			var diffrence=0.0
			for y in range(i2.get_height()):
				for x in range(i2.get_height()):
					diffrence+=round(abs(i2.get_pixel(x,y).r-i.get_pixel(x,y).r))
			print(diffrence)
			ref_tex()
			$ColorRect/ColorRect2.scale.x=1.0-(diffrence-target_diff)/(start_diff-target_diff)
			if diffrence<target_diff:
				on_win.call(true)

func ref_tex():
	tex2.update(i2)

extends Node

@export var pl:Area2D
@export var cr:CookingResource
@export var ta:Array[CompressedTexture2D]=[]
@export var hud_parent:Node
func _ready() -> void:
	Music.make_sound(Music.Sounds.WATER)
	for c:Area2D in $"good".get_children():
		var s:Sprite2D=c.get_child(1)
		s.texture=cr.images[randi()%3]
	for c:Area2D in $"bad".get_children():
		var s:Sprite2D=c.get_child(1)
		s.texture=cr.images[3]
	for c:Sprite2D in hud_parent.get_children():
		c.visible=false
func end(flag):
	if not flag:
		print("reset")
		var p=get_parent()
		self.queue_free()
		var l:PackedScene=load("res://Minigry_new/game4/do_not_look/nota_cooking_game.tscn")
		var re=l.instantiate()
		p.add_child(re)
	else:
		get_parent().emit_signal("finish")
		self.queue_free()
		Music.make_sound(Music.Sounds.EAT)
		print("FINISH")
		

func destoy(c:Area2D):
	c.reparent($Node)

func _process(delta: float) -> void:
	var dir=clamp((get_viewport().get_mouse_position().x-pl.position.x)*0.01,-1.0,1.0)
	pl.position.x+=300.0*delta * dir
	pl.position.x=clamp(pl.position.x,0.0,get_viewport().size.x)
	for c:Area2D in $"bad".get_children():
		c.position.y+=100.0*delta
		if c.position.y>600.0:
			Music.make_sound(Music.Sounds.POP)
			destoy(c)
			#c.queue_free()
	for c:Area2D in $"good".get_children():
		c.position.y+=100.0*delta
		if c.position.y>600.0:
			Music.make_sound(Music.Sounds.POP)
			destoy(c)
	for c in pl.get_overlapping_areas():
		if c.get_parent().name=="bad":
			Music.make_sound(Music.Sounds.WRONG)
			end(false)
		if c.get_parent().name=="good":
			print("HEHE")
			var t:CompressedTexture2D=c.get_child(1).texture
			print(t.resource_path)
			if not t in ta:
				var pr:Sprite2D=hud_parent.get_child(ta.size())
				pr.texture=t
				pr.visible=true
				ta.append(t)
			else:
				for pr:Sprite2D in hud_parent.get_children():
					if pr.texture==t:
						var la:Label=pr.get_child(0)
						la.text=str(1+la.text.to_int())
						la.visible=true
			Music.make_sound(Music.Sounds.COOKING)
			c.queue_free()
			
	print($"good".get_child_count()+$"bad".get_child_count())
	if $"good".get_child_count()+$"bad".get_child_count()==0:
		
		if ta.size()==3:
			end(true)
		else:
			end(false)
	for c:Area2D in $Node.get_children():
		var sp:Sprite2D=c.get_child(1)
		var m:ShaderMaterial=sp.material.duplicate()
		sp.material=m
		m.set_shader_parameter("d",m.get_shader_parameter("d")+delta*2.0)
		if m.get_shader_parameter("d")>1.0:
			c.queue_free()

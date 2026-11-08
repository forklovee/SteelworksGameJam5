extends Node

@export var pl:Area2D
@export var cr:CookingResource
@export var ta:Array[CompressedTexture2D]=[]
@export var hud_parent:Node
func _ready() -> void:
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
		var p=get_parent()
		self.queue_free()
		var l:PackedScene=load("res://Minigry_new/game4/do_not_look/nota_cooking_game.tscn")
		var re=l.instantiate()
		p.add_child(re)
	else:
		self.queue_free()
		get_parent().emit_signal("finish")

func _process(delta: float) -> void:
	pl.position.x+=300.0*delta if get_viewport().get_mouse_position().x>pl.position.x else -300.0*delta
	pl.position.x=clamp(pl.position.x,0.0,get_viewport().size.x)
	for c:Area2D in $"bad".get_children():
		c.position.y+=100.0*delta
		if c.position.y>600.0:
			c.queue_free()
	for c:Area2D in $"good".get_children():
		c.position.y+=100.0*delta
		if c.position.y>600.0:
			c.queue_free()
	for c in pl.get_overlapping_areas():
		if c.get_parent().name=="bad":
			get_tree().reload_current_scene()
		if c.get_parent().name=="good":
			print("HEHE")
			var t:CompressedTexture2D=c.get_child(1).texture
			print(t.resource_path)
			if not t in ta:
				var pr:Sprite2D=hud_parent.get_child(ta.size())
				pr.texture=t
				pr.visible=true
				ta.append(t)
			c.queue_free()
	print($"good".get_child_count()+$"bad".get_child_count())
	if $"good".get_child_count()+$"bad".get_child_count()==0:
		
		if ta.size()==3:
			end(true)
		else:
			end(false)

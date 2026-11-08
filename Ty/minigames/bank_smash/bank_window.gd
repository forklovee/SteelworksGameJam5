class_name BankWindow extends Area2D

signal broken

@onready var texture_broken := preload("res://Ty/minigames/bank_smash/Sprites/okno_rozbite.png")
@onready var texture_normal := preload("res://Ty/minigames/bank_smash/Sprites/okno.png")
@onready var window_sprite := $Okno
@onready var sfx := $AudioStreamPlayer2D

var is_broken: bool = false

func break_window():
	if is_broken:
		return
	is_broken = true
	monitorable = false
	window_sprite.texture = texture_broken
	broken.emit()
	sfx.play()

func reset():
	is_broken = false
	monitorable = true
	window_sprite.texture = texture_normal

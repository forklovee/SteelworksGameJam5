class_name MinigameFinishedScreen extends Control

signal try_again_requested
signal continue_requested

@onready var message_label := $VBoxContainer/MessageLabel
@onready var percent_label := $VBoxContainer/Control/PercentLabel
@onready var try_again_button := $VBoxContainer/Buttons/TryAgainButton
@onready var continue_button := $VBoxContainer/Buttons/ContinueButton

func _ready() -> void:
	hide()
	try_again_button.pressed.connect(
		func(): 
			try_again_requested.emit()
			try_again_button.hide()
			hide()
	)
	continue_button.pressed.connect(
		func():
			continue_requested.emit()
			continue_button.hide()
			hide()
	)
	try_again_button.hide()
	continue_button.hide()

func setup(percent_successful: float):
	show()
	var is_failed := percent_successful < 50.0
	if is_failed:
		message_label.text = ["O cholibka!", "Och nie!", "Kurcze pieczone!", "Kurza melodia!"].pick_random()
	else:
		message_label.text = ["Super!", "Świetnie!", "Świetna robota!", "Jupikajej!"].pick_random()
	
	percent_label.modulate.a = 0.0
	percent_label.scale = Vector2.ONE * .75
	percent_label.text = ""
	var tween := get_tree().create_tween().set_parallel()
	tween.tween_method(_update_percent_label, 0, floori(percent_successful), 2.0)
	tween.tween_property(percent_label, "scale", Vector2.ONE * 1.0, 1.5)
	tween.tween_property(percent_label, "modulate:a", 1.0, 0.2)
	await tween.finished
	
	if is_failed:
		try_again_button.show()
	else:
		continue_button.show()

func _update_percent_label(value: int):
	if value < 10:
		percent_label.text = "0"+str(value) + "%"
	else:
		percent_label.text = str(value) + "%"

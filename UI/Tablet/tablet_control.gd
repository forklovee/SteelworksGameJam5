extends Control

@export var tablet: Control
@export var anim_duration: float = 0.5
@export var hidden_offset: float = 800.0
@export var shown_offset: float = 350.0

var tween: Tween
var hover_disabled: bool = false
var messagebox: VBoxContainer
var player_message_scene: PackedScene = load("res://UI/Tablet/player_message.tscn")
var gpt_message_scene: PackedScene = load("res://UI/Tablet/gpt_message.tscn")

func _ready() -> void:
	tablet.mouse_entered.connect(show_tablet_user)
	tablet.mouse_exited.connect(check_mouse)
	messagebox = $Tablet/VBoxContainer/MessagesContainer/VBoxContainer

func player_message(message: String) -> void:
	var new_message: PanelContainer = player_message_scene.instantiate()
	var rich_text: RichTextLabel = new_message.get_node("HBoxContainer/VBoxContainer/Message")
	rich_text.text = "|"
	var blink_tween = create_tween()
	blink_tween.set_loops(3)
	blink_tween.tween_property(rich_text, "modulate:a", 0.0, 0.01)
	blink_tween.tween_property(rich_text, "modulate:a", 0.0, 0.25)
	blink_tween.tween_property(rich_text, "modulate:a", 1.0, 0.01)
	blink_tween.tween_property(rich_text, "modulate:a", 1.0, 0.25)
	messagebox.add_child(new_message)
	await get_tree().process_frame
	messagebox.get_parent().scroll_vertical = messagebox.get_parent().get_v_scroll_bar().max_value
	await get_tree().create_timer(2.0).timeout
	rich_text.visible_characters = 0
	rich_text.text = message
	await get_tree().process_frame
	messagebox.get_parent().scroll_vertical = messagebox.get_parent().get_v_scroll_bar().max_value
	var tween2 = create_tween()
	tween2.tween_property(
		rich_text,
		"visible_characters",
		rich_text.text.length(),
		message.length() * 0.02
	)

func gpt_message(message: String, delay: float) -> void:
	var new_message: PanelContainer = gpt_message_scene.instantiate()
	var rich_text: RichTextLabel = new_message.get_node("HBoxContainer/VBoxContainer/Message")
	messagebox.add_child(new_message)
	await get_tree().process_frame
	messagebox.get_parent().scroll_vertical = messagebox.get_parent().get_v_scroll_bar().max_value
	rich_text.text = "[wave amp=20 freq=50]Myśli...[/wave]"
	await get_tree().create_timer(delay).timeout
	rich_text.visible_characters = 0
	rich_text.text = message
	await get_tree().process_frame
	messagebox.get_parent().scroll_vertical = messagebox.get_parent().get_v_scroll_bar().max_value
	var tween2 = create_tween()
	tween2.tween_property(
		rich_text,
		"visible_characters",
		rich_text.text.length(),
		message.length() * 0.005
	)

func show_tablet() -> void:
	animate_tablet(Vector2(0, shown_offset))
	
func show_tablet_user() -> void:
	if hover_disabled:
		return
	animate_tablet(Vector2(0, shown_offset))

func hide_tablet() -> void:
	animate_tablet(Vector2(0, hidden_offset))

func check_mouse() -> void:
	if hover_disabled:
		return
	
	var mouse_position = get_global_mouse_position()
	if not tablet.get_global_rect().has_point(mouse_position):
		hide_tablet()

func animate_tablet(target: Vector2) -> void:
	if tween and tween.is_running():
		tween.kill()
	
	tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(
		tablet,
		"offset_transform_position",
		target,
		anim_duration
	)

extends Control

@export var tablet: Control
@export var anim_duration: float = 0.5
@export var hidden_offset: float = 800.0
@export var shown_offset: float = 350.0

var tween: Tween
var hover_disabled: bool = false

func _ready() -> void:
	tablet.mouse_entered.connect(show_tablet_user)
	tablet.mouse_exited.connect(check_mouse)

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

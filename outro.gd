extends Node

var te=""
var t=0.0
var cli=false
func _ready() -> void:
	te=$RichTextLabel.text

func _process(delta: float) -> void:
	t+=delta
	if t<1.2:
		$RichTextLabel.text=te.left(int(clamp(te.length()*t,0,te.length())))
	if t>0.5:
		if Input.is_action_just_pressed("mouse_click"):
			cli=true
	
	if t>1.3:
		if cli:
			$RichTextLabel.visible=false
			$win.visible=true

extends TextureRect

var stock_value: float = 0.0
var value_set: bool = false

func _gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			stock_value += randf_range(2.0, 5.0)
			update_values()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			stock_value += randf_range(-2.0, -5.0)
			update_values()

func set_value(text: String) -> void:
	if !value_set:
		stock_value = randf_range(-10.0, 10.0)
		value_set = true
		$VBoxContainer/Label.text = text
	else:
		stock_value += randf_range(-5.0, 5.0)
	
	update_values()

func update_values():
	$VBoxContainer/Label2.text = str(snappedf(stock_value, 0.01)) + "%"
	if stock_value < 0.0:
		self.self_modulate = Color.hex(0xeb0049ff)
	else:
		self.self_modulate = Color.hex(0x55ab00ff)

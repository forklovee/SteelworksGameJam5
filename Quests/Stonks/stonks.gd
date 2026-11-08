extends MiniGame

var positive
var negative
var time: float = 26.0
var time_now: float = time
var tag_array: Array[String]
var stop: bool = false

func _ready() -> void:
	super()
	positive = get_tree().get_nodes_in_group("stonk_positive")
	negative = get_tree().get_nodes_in_group("stonk_negative")
	tag_array = generate_array(30)
	$HSlider.value = time
	$HSlider.max_value = time
	
	for stonk in positive:
		stonk.set_value(tag_array.pop_back())
	for stonk in negative:
		stonk.set_value(tag_array.pop_back())
	
	start_timer()
	$Control/Panel/Button.pressed.connect(restart)

func _process(delta: float) -> void:
	if stop:
		return

	if $HSlider.value > 0.0:
		time_now -= delta
		$HSlider.value = time_now
		$Label3.text = str(snapped($HSlider.value, 1)) + "s"
	else:
		check_results()
		stop = true

func start_timer():
	var timer = Timer.new()
	timer.wait_time = 2.0
	timer.one_shot = false
	add_child(timer)
	timer.timeout.connect(update_stonks)
	timer.start()

func start():
	super()

func check_results():
	for stonk in positive:
		if stonk.stock_value < 0.0:
			$Control.show()
			for child in get_children():
				if child is Timer:
					child.queue_free()
			return
	for stonk in negative:
		if stonk.stock_value >= 0.0:
			$Control.show()
			for child in get_children():
				if child is Timer:
					child.queue_free()
			return
	
	$Control2.show()
	await get_tree().create_timer(1.0).timeout
	finished.emit()

func restart():
	$Control.hide()
	$HSlider.value = time
	time_now = time
	$Label3.text = str(snapped($HSlider.value, 1)) + "s"
	$HSlider.max_value = time
	tag_array = generate_array(30)
	
	for stonk in positive:
		stonk.value_set = false
		stonk.set_value(tag_array.pop_back())
	for stonk in negative:
		stonk.value_set = false
		stonk.set_value(tag_array.pop_back())
		
	stop = false
	start_timer()

func generate_array(x: int) -> Array[String]:
	var result: Array[String] = []
	var letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	
	for i in range(x):
		var length = randi_range(3, 4)
		var word = ""

		for j in range(length):
			word += letters[randi_range(0, letters.length() - 1)]

		result.append(word)

	return result

func update_stonks() -> void:
	for stonk in positive:
		stonk.set_value("")
	for stonk in negative:
		stonk.set_value("")

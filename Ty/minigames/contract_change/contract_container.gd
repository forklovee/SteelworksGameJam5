class_name ContractContainer extends Control

signal contract_ready(contract_page: ContractPage)
signal all_contracts_stamped

@onready var _contract_page_res := preload("res://Ty/minigames/contract_change/Assets/contract_page.tscn")

@onready var average_salary_display := $AverageSalaryDisplay
@onready var spawn_point := $SpawnPoint
@onready var center_slot := $CenterSlot

var contract_datas: Array[ContractChangeMinigame.ContractData]
var current_contract_idx := -1

var current_contract_page: ContractPage
var next_contract_page: ContractPage

var is_sliding_next_contract: bool = false

func start(data: Array[ContractChangeMinigame.ContractData], average_salary_pln: int):
	contract_datas = data
	current_contract_idx = -1
	average_salary_display.set_average_salary_pln(average_salary_pln)
	_slide_next_contract()

func _slide_next_contract():
	if is_sliding_next_contract:
		return
	
	current_contract_idx += 1
	if current_contract_idx >= contract_datas.size():
		all_contracts_stamped.emit()
		return
	
	is_sliding_next_contract = true
	if current_contract_page == null and next_contract_page != null: # next page ready
		current_contract_page = next_contract_page
		next_contract_page = null
	
	if current_contract_page == null:
		var this_contract := contract_datas[current_contract_idx]
		if this_contract != null:
			current_contract_page = _spawn_contract(this_contract)
	var next_contract := contract_datas[current_contract_idx+1] if contract_datas.size() > current_contract_idx+1 else null
	if next_contract != null:
		next_contract_page = _spawn_contract(next_contract)
	
	const slide_in_duration := 0.25
	var t := get_tree().create_tween().set_ease(Tween.EASE_IN).set_parallel(true)
	t.tween_property(current_contract_page, "global_position", center_slot.global_position, slide_in_duration)
	t.tween_property(current_contract_page, "rotation_degrees", 0.0, slide_in_duration)
	if next_contract_page != null:
		t.tween_property(next_contract_page, "global_position", spawn_point.global_position, slide_in_duration)
		t.tween_property(next_contract_page, "rotation_degrees", randf_range(-10.0, 10.0), slide_in_duration)
	await t.finished
	contract_ready.emit(current_contract_page)
	is_sliding_next_contract = false

func _on_contract_stamped_success():
	var stamped_page := current_contract_page
	current_contract_page = null
	_slide_next_contract()
	
	const slide_out_duration := 0.2
	var t := get_tree().create_tween()
	t.tween_property(stamped_page, "global_position", center_slot.global_position + Vector2.UP * 800.0, slide_out_duration)
	t.tween_property(stamped_page, "rotation_degrees", 0.0, slide_out_duration)
	await t.finished
	
	stamped_page.queue_free()

func _on_contract_stamped_fail():
	var stamped_page := current_contract_page
	current_contract_page = null
	_slide_next_contract()
	
	const slide_out_duration := 0.2
	var t := get_tree().create_tween()
	t.tween_property(stamped_page, "global_position", center_slot.global_position + Vector2.DOWN * 800.0, slide_out_duration)
	t.tween_property(stamped_page, "rotation_degrees", 0.0, slide_out_duration)
	await t.finished
	
	stamped_page.queue_free()


func _spawn_contract(data: ContractChangeMinigame.ContractData) -> ContractPage:
	var contract: ContractPage = _contract_page_res.instantiate()
	spawn_point.add_child(contract)
	contract.position.x = -1000.0 # Spawn out of bounds, so it can slide in
	contract.size = Vector2.ONE * 0.9
	contract.rotation_degrees = randf_range(-10.0, 10.0)
	contract.setup(data.employee, data.salary_pln, data.currency)
	return contract

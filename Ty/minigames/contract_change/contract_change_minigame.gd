class_name ContractChangeMinigame extends MiniGame

class ContractData extends RefCounted:
	var employee: ContractEmployee
	var salary_pln: int
	var currency: ContractPage.Currency
	
	func _init(new_employe: ContractEmployee, new_salary_pln: int, new_currency: ContractPage.Currency) -> void:
		employee = new_employe
		salary_pln = new_salary_pln
		currency = new_currency

signal contract_stamped_success
signal contract_stamped_fail

@onready var contract_container: ContractContainer = $ContractContainer
@onready var stamp_creation: ContractStamp2D = $StampCreation
@onready var stamp_b2b: ContractStamp2D = $StampB2B
@onready var stamp_target: Area2D = $StampTarget

@export var contract_amount: int = 10
@export var salary_range: Vector2i = Vector2i(3000, 10000)
var average_salary_pln: int = -1

var successes: int = 0

var hovered_stamp: ContractStamp2D
var is_stamp_picked_up := false
var is_stamp_hovering_over_contract := false

func _input(_event: InputEvent) -> void:
	if hovered_stamp == null:
		return
	if Input.is_action_just_pressed("LeftMouseButton"):
		if is_stamp_picked_up:
			if is_stamp_hovering_over_contract:
				# Stamp the contract
				hovered_stamp.stamp()
				var current_contract := contract_container.current_contract_page
				if hovered_stamp.type == ContractPage.Type.Creation and current_contract.salary_pln < average_salary_pln:
					contract_stamped_success.emit()
					successes += 1
				elif hovered_stamp.type == ContractPage.Type.B2B and current_contract.salary_pln >= average_salary_pln:
					contract_stamped_success.emit()
					successes += 1
				else:
					contract_stamped_fail.emit()
				clear_set_stamp()
			elif !is_stamp_hovering_over_contract and hovered_stamp.is_picked_stamp_hovering:
				hovered_stamp.put_away()
				clear_set_stamp()
		else:
			# Pick up the stamp
			if hovered_stamp == stamp_creation:
				stamp_b2b.set_interaction_enabled(false)
			elif hovered_stamp == stamp_b2b:
				stamp_creation.set_interaction_enabled(false)
			is_stamp_picked_up = true
			hovered_stamp.pick_up()

func clear_set_stamp():
	hovered_stamp = null
	is_stamp_picked_up = false
	is_stamp_hovering_over_contract = false
	stamp_b2b.set_interaction_enabled(true)
	stamp_creation.set_interaction_enabled(true)

func _ready() -> void:
	super()
	contract_container.all_contracts_stamped.connect(_on_all_contracts_stamped)
	stamp_target.mouse_entered.connect(_on_stamp_target_hovered)
	stamp_target.mouse_exited.connect(_on_stamp_target_unhovered)
	stamp_creation.mouse_entered.connect(_on_stamp_hovering.bind(stamp_creation))
	stamp_creation.mouse_exited.connect(_on_stamp_unhovered.bind(stamp_creation))
	stamp_b2b.mouse_entered.connect(_on_stamp_hovering.bind(stamp_b2b))
	stamp_b2b.mouse_exited.connect(_on_stamp_unhovered.bind(stamp_b2b))
	contract_stamped_success.connect(contract_container._on_contract_stamped_success)
	contract_stamped_fail.connect(contract_container._on_contract_stamped_fail)

func _process(_delta: float) -> void:
	if hovered_stamp != null and is_stamp_picked_up:
		hovered_stamp.get_stamp_sprite().global_position = contract_container.get_local_mouse_position()

func start(game_camera: Camera2D, _on_win: Callable, game: MiniGameResource):
	super(game_camera, _on_win, game)
	average_salary_pln = Game.rng.randi_range(salary_range.x, salary_range.x + (salary_range.y - salary_range.x)*.5)
	contract_container.start(_generate_contract_data_list(), average_salary_pln)

func _generate_contract_data_list() -> Array[ContractData]:
	var contract_datas: Array[ContractData]
	for i in range(contract_amount):
		var salary_pln: int = Game.rng.randi_range(salary_range.x, salary_range.y)
		#var currency: ContractPage.Currency = [ ContractPage.Currency.PLN, ContractPage.Currency.Dollar, ContractPage.Currency.Euro ].pick_random() Japierdole to jest chujowe fest
		var currency: ContractPage.Currency = ContractPage.Currency.PLN
		contract_datas.append(
			ContractData.new(ContractEmployee.create_random_employee(), salary_pln, currency)
		)
	return contract_datas

static func get_salary(salary_pln: float, currency: ContractPage.Currency) -> int:
	var currency_mul: float = 1.0
	match currency:
		ContractPage.Currency.Dollar:
			currency_mul = 0.2543
		ContractPage.Currency.Euro:
			currency_mul = 0.2277
	return floori(salary_pln * currency_mul)

func _on_all_contracts_stamped():
	var percent_successful := successes / float(contract_amount)
	finish(percent_successful)

func _on_stamp_hovering(stamp: ContractStamp2D) -> void:
	if is_stamp_picked_up:
		return
	hovered_stamp = stamp

func _on_stamp_unhovered(_stamp: ContractStamp2D) -> void:
	if is_stamp_picked_up:
		return
	hovered_stamp = null


func _on_stamp_target_hovered() -> void:
	if hovered_stamp and is_stamp_picked_up:
		is_stamp_hovering_over_contract = true
		return
	is_stamp_hovering_over_contract = false

func _on_stamp_target_unhovered() -> void:
	is_stamp_hovering_over_contract = false

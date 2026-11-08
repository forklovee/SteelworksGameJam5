extends Control

@onready var average_salary_label: Label = $VBoxContainer/Control/AverageSalary

var average_salary_pln: int
var currency: ContractPage.Currency

func update():
	average_salary_label.text = str(ContractChangeMinigame.get_salary(average_salary_pln, currency))

func set_average_salary_pln(new_avg_salary_pln: int):
	average_salary_pln = new_avg_salary_pln
	update()

func _on_pln_switch_pressed() -> void:
	currency = ContractPage.Currency.PLN
	update()

func _on_dollar_switch_pressed() -> void:
	currency = ContractPage.Currency.Dollar
	update()

func _on_euro_switch_pressed() -> void:
	currency = ContractPage.Currency.Euro
	update()

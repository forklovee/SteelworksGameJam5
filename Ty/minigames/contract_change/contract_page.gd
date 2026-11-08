class_name ContractPage extends Control

enum Type{
	B2B,
	Creation
}

enum Currency
{
	PLN,
	Dollar,
	Euro
}

@onready var employee_label := $VBoxContainer/EmployeeLabel
@onready var salary_label := $VBoxContainer/HBoxContainer/SalaryBox/SalaryLabel

var salary_pln: int = 4000
var currency: Currency = Currency.PLN

func setup(employee: ContractEmployee, new_salary_pln: int, new_currency: Currency):
	salary_pln = new_salary_pln
	currency = new_currency
	employee_label.text = employee.get_gender_str() + " " + employee.first_name + " " + employee.last_name
	salary_label.text = str(ContractChangeMinigame.get_salary(salary_pln, currency)) + " " + get_currency_str()

func get_currency_str() -> String:
	match currency:
		Currency.PLN:
			return "zł"
		Currency.Dollar:
			return "$"
		Currency.Euro:
			return "€"
	return ""

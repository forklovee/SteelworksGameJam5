class_name ContractEmployee extends RefCounted

enum Gender
{
	Male,
	Female
}

var first_name: String
var last_name: String
var gender: Gender

func _init(new_first_name: String, new_last_name: String, new_gender: Gender) -> void:
	first_name = new_first_name
	last_name = new_last_name
	gender = new_gender

func get_gender_str() -> String:
	match gender:
		Gender.Male:
			return "Panem"
		Gender.Female:
			return "Panią"
	return ""

static func create_random_employee() -> ContractEmployee:
	var random_gender := Gender.Male if randf() > 0.5 else Gender.Female
	
	var random_first_name := ""
	match random_gender:
		Gender.Male:
			random_first_name = ["Zbychu", "Krzysztof", "Grzegorz", "Jakub", "Idzi", "Kosma", "Alojzy", "Andrzej", "Eustachy"].pick_random()
		Gender.Female:
			random_first_name = ["Elżbieta", "Monika", "Genowefa", "Barbara", "Katarzyna", "Andżelika", "Natalia", "Helena", "Renata"].pick_random()
	var random_last_name = ["Kucharski", "Kononowicz", "Deregatory", "Kurczak", "Wiercistupka", "Mącidupa", "Brzęczymorda", "Sigmastyk", "Tonfa"].pick_random()
	return ContractEmployee.new(random_first_name, random_last_name, random_gender)

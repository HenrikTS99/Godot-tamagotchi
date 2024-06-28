extends Control

@onready var pet = get_tree().get_first_node_in_group("Pet")

# Called when the node enters the scene tree for the first time.
func _ready():
	print(pet)
	if pet:
		pet.hungerChanged.connect(update_hunger)
		pet.connect("happinessChanged", update_happiness)
		pet.hygieneChanged.connect(update_hygiene)
		pet.funChanged.connect(update_fun)
	update()

func update():
	update_hunger()
	update_happiness()
	update_hygiene()
	update_fun()
	
func update_hunger():
	$VBoxContainer/HBoxContainer2/HungerBar.value = pet.hunger * 100 / pet.maxStat
	
func update_happiness():
	$VBoxContainer/HBoxContainer/HappinessBar.value = pet.happiness * 100 / pet.maxStat
	
func update_hygiene():
	$VBoxContainer/HBoxContainer3/HygieneBar.value = pet.hygiene * 100 / pet.maxStat
	
func update_fun():
	$VBoxContainer/HBoxContainer4/FunBar.value = pet.fun * 100 / pet.maxStat

extends Control

@onready var pet = get_tree().get_first_node_in_group("Pet")
@onready var happinessBar = get_node("%HappinessBar")
@onready var hungerBar = get_node("%HungerBar")
@onready var hygieneBar = get_node("%HygieneBar")
@onready var funBar = get_node("%FunBar")
@onready var socialBar = get_node("%SocialBar")
@onready var tirednessBar = get_node("%TirednessBar")

@onready var statsTotalLabel = get_node("%StatsTotal")
@onready var statsAverageLabel = get_node("%StatsAverage")
# Called when the node enters the scene tree for the first time.
func _ready():
	print(pet)
	if pet:
		pet.hungerChanged.connect(update_hunger)
		pet.connect("happinessChanged", update_happiness)
		pet.hygieneChanged.connect(update_hygiene)
		pet.funChanged.connect(update_fun)
		pet.socialChanged.connect(update_social)
		pet.tirednessChanged.connect(update_tiredness)
		pet.totalStatsChanged.connect(update_stats_total)
		update()

func update():
	update_hunger(pet.hunger)
	update_happiness(pet.happiness)
	update_hygiene(pet.hygiene)
	update_fun(pet.fun)
	update_social(pet.social)
	update_tiredness(pet.tiredness)
	
func update_hunger(value):
	hungerBar.value = value
	
func update_happiness(value):
	happinessBar.value = value
	
func update_hygiene(value):
	hygieneBar.value = value
	
func update_fun(value):
	funBar.value = value

func update_social(value):
	socialBar.value = value
	
func update_tiredness(value):
	tirednessBar.value = value
	
func update_stats_total(value):
	statsTotalLabel.text = 'total:' + str(value)
	update_stats_average(value)
	
func update_stats_average(value):
	statsAverageLabel.text = 'average:' + str(value / 6)

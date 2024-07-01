extends Label

@onready var pet = get_tree().get_first_node_in_group("Pet")

func _ready():
	if pet:
		pet.coinsChanged.connect(update_counter)
		

func update_counter(value):
	self.text = 'coins:' + str(value)

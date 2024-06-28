extends ProgressBar

@onready var pet = get_tree().get_first_node_in_group("Pet")
# Called when the node enters the scene tree for the first time.
func _ready():
	pet.hungerChanged.connect(update)
	update()

func update():
	value = pet.hunger * 100 / pet.maxStat

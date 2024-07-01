extends Control

@onready var _petXpLabel = $PetXpLabel
@onready var _pet = get_tree().get_first_node_in_group("Pet")
# Called when the node enters the scene tree for the first time.
func _ready():
	if _pet:
		_pet.xpGained.connect(_petXpLabel.update_label)
	_petXpLabel.update_label(_pet.experience_level, _pet.experience, _pet.experience_required)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

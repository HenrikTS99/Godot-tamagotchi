extends Node2D

@export var item: Item
@onready var sprite = $Sprite2D

func _ready():
	if item:
		sprite.texture = item.texture
		sprite.scale *= 2
	else:
		print('error no item')

func bobble_anim():
	var tween = get_tree().create_tween()
	#position
	for i in range(15):
		tween.tween_property(sprite, "position:y", -2, 0.1)
		tween.tween_property(sprite, "position:y", +2, 0.1)

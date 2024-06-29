extends Marker2D

@onready var sprite = $Sprite2D
var direction_choices = ['left', 'right']
func _ready():
	randomize()
	#position.y -= 150
	var tween = get_tree().create_tween()
	var direction = direction_choices.pick_random()
	if direction == 'left':
		tween.tween_property(sprite, "position", global_position + _get_direction(), 0.8)
	else:
		tween.tween_property(sprite, "position", global_position + _get_direction(), 0.8)
		
		
		
func _get_direction():
	return Vector2(randf_range(-1,1), -randf()) * 32
	
func set_reaction(reaction):
	match reaction:
		"happy":
			sprite.set_frame(0)
		"sad":
			sprite.frame = 15
		"neutral":
			sprite.frame = 3
		"sick":
			sprite.frame = 9
		"love":
			sprite.frame = 2

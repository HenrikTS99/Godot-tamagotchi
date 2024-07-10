extends Panel

@onready var petImage = get_node("%PetImage")
@onready var stars = get_node("%StarsContainer").get_children()

var unfilledColor = Color(0.3, 0.3, 0.3)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update(review):
	petImage.texture = review['image']
	set_star_rating(review['star_rating'])

func set_star_rating(rating: int):
	rating = clamp(rating, 0, stars.size())
	for i in range(stars.size()):
		var star = stars[i]
		if i >= rating:
			star.modulate = unfilledColor

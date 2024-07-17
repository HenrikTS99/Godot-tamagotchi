extends Panel

@onready var petImage = get_node("%PetImage")
@onready var stars = get_node("%StarsContainer").get_children()

var unfilledColor = Color(0.3, 0.3, 0.3)


func update(review):
	petImage.texture = review['image']
	set_star_rating(review['star_rating'])

func set_star_rating(rating: int):
	rating = clamp(rating, 0, stars.size())
	for i in range(stars.size()):
		var star = stars[i]
		if i >= rating:
			star.modulate = unfilledColor

extends Control

@onready var nameLabel = get_node("%NameLabel")
@onready var animalLabel = get_node("%AnimalLabel")
@onready var stayLabel = get_node("%StayLabel")
@onready var petImage = get_node("%PetImage")

	
func set_pet_info(pet_details):
	nameLabel.text = 'Name: ' + pet_details['name']
	animalLabel.text = 'Animal: ' + str(pet_details['animal'])
	stayLabel.text = 'Stay Duration: ' + str(pet_details['days']) + 'Days and ' + str(pet_details['hours']) + 'Hours.'
	petImage.texture = pet_details['image']
	get_tree().paused = true
	
func _on_continue_button_pressed():
	get_tree().paused = false
	queue_free()

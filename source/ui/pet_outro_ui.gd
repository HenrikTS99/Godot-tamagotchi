extends Control

@onready var nameLabel = get_node("%NameLabel")
@onready var animalLabel = get_node("%AnimalLabel")
@onready var stayLabel = get_node("%StayLabel")
@onready var petImage = get_node("%PetImage")
@onready var statsLabel = get_node("%StatsLabel")
@onready var reviewLabel = get_node("%ReviewLabel")
@onready var starRatingImage = get_node("%StarRatingImage")
@onready var coinsLabel = get_node("%CoinsLabel")
@onready var claimButton = get_node("%ClaimButton")
@onready var stars = get_node("%StarsContainer").get_children()
@onready var coinScene = preload("res://source/objects/coin.tscn")
@onready var coinDisplay = get_tree().get_first_node_in_group("CoinDisplay")

var unfilledColor = Color(0.3, 0.3, 0.3)
var coins_amount: int

func _ready():
	pass
	
func set_pet_info(pet_details):
	coins_amount = pet_details['coins']
	nameLabel.text = 'Name: ' + pet_details['name']
	animalLabel.text = 'Animal: ' + str(pet_details['animal'])
	stayLabel.text = 'Stay Duration: ' + str(pet_details['days']) + 'Days and ' + str(pet_details['hours']) + 'Hours.'
	petImage.texture = pet_details['image']
	statsLabel.text = 'Average stats:' + str(pet_details['stats']) + '%'
	reviewLabel.text = 'Review: ' + pet_details['review']
	coinsLabel.text = 'Coins Rewarded:' + str(pet_details['coins'])
	set_star_rating(pet_details['star_rating'])
	get_tree().paused = true

func set_star_rating(rating: int):
	rating = clamp(rating, 0, stars.size())
	for i in range(stars.size()):
		var star = stars[i]
		if i >= rating:
			star.modulate = unfilledColor

func instance_coin(i):
	var coin = coinScene.instantiate()
	coin.global_position = Vector2(claimButton.global_position.x, claimButton.global_position.y)
	add_child(coin)
	return coin

func animation_tween(coins, final_pos):
	for i in range(coins):
		var coin = instance_coin(i)
		var tween = get_tree().create_tween()
		tween.tween_property(coin, "global_position", final_pos, 1)
		await get_tree().create_timer(.1).timeout
	return
		
func _on_continue_button_pressed():
	# self.visible = false
	get_tree().paused = false
	await animation_tween(coins_amount, coinDisplay.global_position)
	queue_free()

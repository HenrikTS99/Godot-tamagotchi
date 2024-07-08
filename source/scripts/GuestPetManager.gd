extends Node

@export var guest_pet_resources: Array[petResource]
@export var stay_duration_hours: int  # Duration in hours

@onready var petIntroductionUI = preload("res://source/ui/pet_introduction_ui.tscn")
@onready var petOutroUI = preload("res://source/ui/pet_outro_ui.tscn")
@onready var reviews_json_path = "res://source/data/reviews.json"
@onready var timeUI = get_tree().get_first_node_in_group("TimeUI")
@onready var _pet = get_tree().get_first_node_in_group("Pet")

var current_guest_pet_resource = null
var pet_introduction_ui = null
var pet_outro_ui = null
var HOURS_PER_DAY = 24
var pet_exit_time = { "day": 0, "hour": 0, "minute": 0 }
var pet_introduced = false
var reviews_data: Dictionary = {}
var file_path: String

func _ready():
	await get_tree().create_timer(1).timeout
	reviews_data = load_json_file(reviews_json_path)
	if reviews_data.is_empty():
		push_error("Failed to load reviews data.")
		return
		
	timeUI.time_tick.connect(check_if_stay_over)
	introduce_guest_pet()

func load_json_file(file_path: String):
	if FileAccess.file_exists(file_path):
		var data_file = FileAccess.open(file_path, FileAccess.READ)
		var parsed_result = JSON.parse_string(data_file.get_as_text())
		if parsed_result is Dictionary:
			return parsed_result
		else:
			print("Error reading file")
	else:
		print("File dosen't exist")
	
	
func check_if_stay_over(day, hour, minute):
	if pet_introduced and day == pet_exit_time.day and hour == pet_exit_time.hour and minute == pet_exit_time.minute:
		_stay_over()

func set_pet_exit_time():
	var stay_duration_days = int(stay_duration_hours / HOURS_PER_DAY)
	var hours = stay_duration_hours % HOURS_PER_DAY
	pet_exit_time.day = timeUI.day + stay_duration_days
	pet_exit_time.hour = timeUI.hour + hours - hours 
	pet_exit_time.minute = timeUI.minute + 8
	
func introduce_guest_pet():
	current_guest_pet_resource = guest_pet_resources[randi() % guest_pet_resources.size()]
	show_pet_intro(current_guest_pet_resource)
	_pet.walk_into_scene()
	_pet.resource = current_guest_pet_resource
	_pet.reset_stats() 
	stay_duration_hours = randi_range(1, 1)
	set_pet_exit_time()
	print('exit time:', pet_exit_time)
	pet_introduced = true

func show_pet_intro(pet_data):
	var pet_details = {
		"image": pet_data.texture,
		"name": pet_data.name,
		"animal": pet_data.get_animal_type_name(),
		"days": int(stay_duration_hours / HOURS_PER_DAY),
		"hours": stay_duration_hours % HOURS_PER_DAY
	}
	pet_introduction_ui = petIntroductionUI.instantiate()
	get_parent().add_child.call_deferred(pet_introduction_ui)
	await pet_introduction_ui.ready
	pet_introduction_ui.set_pet_info(pet_details)

func show_pet_outro(pet_data, average_stats, review, star_rating, coin_amount):
	var pet_details = {
		"image": pet_data.texture,
		"name": pet_data.name,
		"animal": pet_data.get_animal_type_name(),
		"days": int(stay_duration_hours / HOURS_PER_DAY),
		"hours": stay_duration_hours % HOURS_PER_DAY,
		"stats": round(average_stats),
		"review": review,
		"star_rating": star_rating,
		"coins": coin_amount
	}
	pet_outro_ui = petOutroUI.instantiate()
	get_parent().add_child(pet_outro_ui)
	pet_outro_ui.set_pet_info(pet_details)
	await pet_outro_ui.tree_exited
	
func _stay_over():
	pet_introduced = false
	
		
	var average_stats = _pet.pet_stats.get_overall_average_stats()
	var star_rating = get_star_rating(average_stats)
	var review = evaluate_care(star_rating)
	var coin_amount = calculate_coins_reward(star_rating)
	await show_pet_outro(current_guest_pet_resource, average_stats, review, star_rating, coin_amount)
	_pet.walk_out_of_scene()
	await get_tree().create_timer(1).timeout
	introduce_guest_pet()
		
func evaluate_care(rating: int) -> String:
	var all_rating_reviews = reviews_data[str(rating)]
	return all_rating_reviews[randi() % all_rating_reviews.size()]

func get_star_rating(average_stats):
	# Get 1 star rating per 20% stat
	return int(average_stats/ 20) + 1
	
func calculate_coins_reward(star_rating):
	# Gain more or less coins based on star rating. Median is 3 stars.
	var precentage_per_star = 25
	var reward =  int(stay_duration_hours * (1 + (star_rating-3) * precentage_per_star/ 100))
	return reward

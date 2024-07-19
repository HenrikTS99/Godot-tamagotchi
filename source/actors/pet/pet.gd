extends CharacterBody2D

class_name Pet 

@onready var shakeTween = $ShakeTween
@onready var pet_stats = $PetStats
@onready var pet_actions = $PetActions
@onready var anim_player = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var petDebugLabel = $PetDebugLabel

@export var resource: Resource:
	set(new_resource):
		resource = new_resource
		if sprite:
			update_resource()
		else:
			call_deferred("update_resource")
		
signal xpGained(experience_level, experience, experience_required)

const CENTER_POS = Vector2(256, 318)

# States
enum PetState { IDLE, WALKING, EATING, SLEEPING }
var state: PetState = PetState.IDLE

# XP
var experience = 0
var collected_experience = 0
@export var experience_level = 1
var experience_required = get_required_experience(experience_level + 1)

func _physics_process(_delta):
	# Debug state
	petDebugLabel.text = PetState.keys()[state]

func get_pet_save_data():
	var my_data = SavedPet.new()
	my_data.pet_resource =  resource
	my_data.hunger = pet_stats.hunger
	my_data.happiness = pet_stats.happiness
	my_data.hygiene = pet_stats.hygiene
	my_data.fun = pet_stats.fun
	my_data.social = pet_stats.social
	my_data.tiredness = pet_stats.tiredness
	my_data.cumulative_avg_stats = pet_stats.cumulative_avg_stats
	my_data.update_stats_count = pet_stats.update_stats_count
	my_data.feed_counter = pet_actions.feed_counter
	my_data.pet_counter = pet_actions.pet_counter
	my_data.poop_counter = pet_actions.poop_counter
	return my_data

func update_to_save_data(saved_data:SavedData):
	resource = saved_data.pet_resource
	pet_stats.hunger = saved_data.hunger
	pet_stats.happiness = saved_data.happiness
	pet_stats.hygiene = saved_data.hygiene
	pet_stats.fun = saved_data.fun
	pet_stats.social = saved_data.social
	pet_stats.tiredness = saved_data.tiredness
	pet_stats.cumulative_avg_stats = saved_data.cumulative_avg_stats
	pet_stats.update_stats_count = saved_data.update_stats_count
	pet_actions.feed_counter = saved_data.feed_counter
	pet_actions.pet_counter = saved_data.pet_counter
	pet_actions.poop_counter = saved_data.poop_counter
	
func update_resource():
	sprite.texture = resource.texture

#XP logic
func get_required_experience(level):
	return round(pow(level, 1.2) + level * 2 + 10) # Last num is additional xp points, so it wont start at 0
	
func gain_experience(amount):
	collected_experience += amount
	experience += amount
	while experience >= experience_required:
		experience -= experience_required
		level_up()
	emit_signal('xpGained', experience_level, experience, experience_required)
		
func level_up():
	experience_level += 1
	experience_required = get_required_experience(experience_level + 1)
	award_coins_for_level_up(experience_level)
	
func award_coins_for_level_up(level):
	Global.coins += 3 + level
		
func gain_xp_based_on_stats(average_stats):
	if average_stats < 50:
		return
	# Formula to give more xp depending on average stat level, 1 xp at 5 and 8  xp max. 
	# To change formula, plus one number and minus the other.
	gain_experience(average_stats/7 - 6)

func walk_into_scene():
	state = PetState.WALKING
	global_position = Vector2(600, CENTER_POS.y)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", CENTER_POS, 1)
	await tween.finished
	state = PetState.IDLE
	
func walk_out_of_scene():
	if state == PetState.SLEEPING:
		pet_actions.toggle_sleep()
	state = PetState.WALKING
	var new_position = Vector2(-50, position.y)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", new_position, 1)
	await tween.finished
	state = PetState.IDLE

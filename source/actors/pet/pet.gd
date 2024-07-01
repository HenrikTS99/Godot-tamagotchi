extends CharacterBody2D

class_name Pet 

@onready var timeUI = get_tree().get_first_node_in_group("TimeUI")
@onready var reactionScene = preload("res://source/utility/reaction.tscn")
@onready var poopItem = preload("res://source/objects/poop.tscn")
@onready var shakeTween = $ShakeTween
@onready var pet_stats = $PetStats

signal coinsChanged(value)
signal xpGained(experience_level, experience, experience_required)

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Stats interval before change, set in in-game minutes
const HUNGER_INTERVAL = 10
const HAPPINESS_INTERVAL = 15
const HYGINE_INTERVAL = 30
const FUN_INTERVAL = 15
const SOCIAL_INTERVAL = 30
const TIRED_INTERVAL = 45
const POOP_INTERVAL = 30
const XP_GAIN_INTERVAL = 10

# Counters
var feed_counter = 0
var pet_counter = 0
var poop_counter = 0

# counter limits
var feed_limit = 4
var pet_limit = 3

# XP
var experience = 0
var collected_experience = 0
@export var experience_level = 1
var experience_required = get_required_experience(experience_level + 1)


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var coins: int = 0:
	set(new_value):
		coins = new_value
		emit_signal('coinsChanged', coins)

	
func _ready():
	timeUI.time_tick.connect(process_time_events)

	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()


func process_time_events(_day, _hour, minute):
	if minute % HUNGER_INTERVAL == 0:
		pet_stats.hunger += 5
		feed_counter -= 1
	if minute % HAPPINESS_INTERVAL == 0:
		pet_stats.happiness -= 5
		pet_counter -= 1
	if minute % int(max(HYGINE_INTERVAL - (HYGINE_INTERVAL * poop_counter * 0.2), 5)) == 0: # Make hygiene interval shorter by 20% for each poop, dont go below max value (5)
		pet_stats.hygiene -= 5
	if minute % FUN_INTERVAL == 0:
		pet_stats.fun -= 5
	if minute % SOCIAL_INTERVAL == 0:
		pet_stats.social -= 5
	if minute % TIRED_INTERVAL == 0:
		pet_stats.tiredness += 5
	if minute % POOP_INTERVAL == 0:
		random_poop_chance()
	if minute % XP_GAIN_INTERVAL == 0:
		gain_xp_based_on_stats(pet_stats.average_stats)

func random_poop_chance():
	var rand_num = randi_range(1,3 + poop_counter)
	if rand_num == 1:
		spawn_poop()
		
func spawn_poop():
	pet_stats.hygiene -= 10
	poop_counter += 1
	var poop = poopItem.instantiate()
	get_tree().current_scene.add_child(poop)
	poop.poop_removed.connect(poop_removed)
	poop.position = Vector2(global_position.x + randf_range(-200, 200), 355)

func poop_removed():
	poop_counter -= 1
	pet_stats.happiness += 5
	
func reaction_popup(reaction):
	var reaction_instance = reactionScene.instantiate()
	get_tree().current_scene.add_child(reaction_instance)
	reaction_instance.position = Vector2(global_position.x + randf() * 20 , global_position.y - randf_range(50, 80))
	reaction_instance.set_reaction(reaction)
	
func pet_action(action):
	match action:
		"feed":
			shakeTween.start()
			feed()
		"love":
			pet()
			#DialogManager.start_dialog(lines1)
		"clean":
			clean()
		"fun":
			play()
		"social":
			socialize()
		"sleep":
			sleep()
			#DialogManager.start_dialog(lines2)
			
func feed():
	random_poop_chance()
	feed_counter += 1
	if feed_counter > feed_limit or pet_stats.hunger == 0:
		print('feed counter 4: puke')
		pet_stats.happiness -= 15
		pet_stats.tiredness += 10
		reaction_popup('sad')
		return
	if feed_counter == feed_limit or pet_stats.hunger < 10:
		reaction_popup('sick')
		pet_stats.hunger -= 10
		pet_stats.happiness -= 5
		pet_stats.tiredness += 5
		return
	reaction_popup('happy')
	pet_stats.hunger -= 25
	pet_stats.happiness += 5
	gain_experience(2)

func pet():
	pet_counter += 1
	if pet_counter > pet_limit:
		print('dont want pets now')
		reaction_popup('sick')
		pet_stats.happiness -=5
		return
	if pet_counter == pet_limit:
		reaction_popup('sick')
		print('enough pets')
		pet_stats.happiness +=5
		return
	reaction_popup('love')
	pet_stats.happiness += 15
	gain_experience(2)
	
func clean():
	if pet_stats.hygiene > 90:
		pet_stats.fun -=15
		pet_stats.happiness -= 10
	elif pet_stats.hygiene > 70:
		pet_stats.fun -= 10
	elif pet_stats.hygiene < 30:
		pet_stats.happiness += 15
	pet_stats.hygiene = 100
	gain_experience(1)

func play():
	pet_stats.fun += 25
	pet_stats.tiredness += 5
	gain_experience(1)
	
func socialize():
	pet_stats.social += 25
	pet_stats.tiredness += 5
	pet_stats.hunger += 5
	gain_experience(1)

func sleep():
	pet_stats.tiredness -= 10
	gain_experience(1)
	
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
	coins += 3 + level
		
func gain_xp_based_on_stats(average_stats):
	if average_stats < 50:
		return
	# Formula to give more xp depending on average stat level, 1 xp at 5 and 8  xp max. 
	# To change formula, plus one number and minus the other.
	gain_experience(average_stats/7 - 6)

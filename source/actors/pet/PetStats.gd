extends Node

class_name PetStats

@onready var pet = get_tree().get_first_node_in_group("Pet")

signal hungerChanged(value)
signal happinessChanged(value)
signal hygieneChanged(value)
signal funChanged(value)
signal socialChanged(value)
signal tirednessChanged(value)
signal totalStatsChanged(value)

# Stats
@export var happiness: int = 40:
	set(new_value):
		happiness = clamp(new_value, 0, 100)
		update_total_stats()
		emit_signal('happinessChanged', happiness)
		
@export var hunger: int = 50:
	set(new_value):
		hunger = clamp(new_value, 0, 100)
		update_total_stats()
		emit_signal('hungerChanged', hunger)
		
@export var hygiene: int = 80:
	set(new_value):
		hygiene = clamp(new_value, 0, (100 - min((pet.poop_counter * 10), 100))) # Clamp hygiene from 0 to 100, but if there is poop, dont go higher than max  * poops * 10, also make sure it cant go below 0.
		update_total_stats()
		emit_signal('hygieneChanged', hygiene)
		
@export var fun: int = 40:
	set(new_value):
		fun = clamp(new_value, 0, 100)
		update_total_stats()
		emit_signal('funChanged', fun)

@export var social: int = 40:
	set(new_value):
		social = clamp(new_value, 0, 100)
		update_total_stats()
		emit_signal('socialChanged', social)
		
@export var tiredness: int = 40:
	set(new_value):
		tiredness = clamp(new_value, 0, 100)
		update_total_stats()
		emit_signal('tirednessChanged', tiredness)
		
@export var total_stats: int:
	set(new_value):
		total_stats = new_value
		emit_signal('totalStatsChanged', total_stats)
		
func update_total_stats():
	total_stats = happiness + hunger + hygiene + fun + social + tiredness

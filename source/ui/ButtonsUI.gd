extends Control

@onready var pet: Node = null

signal selectedAction(action)
signal selectedShop()
signal openInventory()
signal openComputer()
signal closeUI()


func _ready():
	var room_manager = get_parent().get_node("RoomManager")
	room_manager.ActivePetChanged.connect(update_pet)
	

func update_pet(new_pet: Node):
	if pet:
		disconnect("selectedAction", Callable(pet, "pet_action"))
	pet = new_pet
	connect("selectedAction", Callable(pet, "pet_action"))
	
func _on_feed_button_pressed():
	emit_signal("openInventory", Item.ItemType.Food)
	emit_signal("selectedAction", "feed")

func _on_clean_button_pressed():
	emit_signal("selectedAction", "clean")

func _on_love_button_pressed():
	emit_signal("selectedAction", "love")

func _on_fun_button_pressed():
	emit_signal("selectedAction", "fun")

func _on_social_button_pressed():
	emit_signal("selectedAction", "social")

func _on_sleep_button_pressed():
	emit_signal("selectedAction", "sleep")

func _on_shop_button_pressed():
	emit_signal("selectedShop")

func _on_computer_button_pressed():
	emit_signal("closeUI")
	emit_signal("openComputer")

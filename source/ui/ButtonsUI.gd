extends Control

@onready var pet = get_tree().get_first_node_in_group("Pet")

signal selectedAction(action)
signal selectedShop()
signal openInventory()
signal closeUI()


func _ready():
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
	emit_signal("closeUI")
	emit_signal("selectedShop")

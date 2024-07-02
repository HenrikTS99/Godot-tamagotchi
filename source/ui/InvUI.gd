extends Control

@onready var buttons_ui = get_tree().get_first_node_in_group("ButtonsUI")
var shop_active = false

@onready var inv: Inventory = preload("res://source/inventory/player_inv.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
@onready var selected_item: Item

func _ready():
	self.visible = false
	buttons_ui.openInventory.connect(open_inventory)
	selected_item = preload("res://source/inventory/items/foods/banana.tres")
	# inv.update.connect(update_slots)
	connect_slots_signals(slots)

func connect_slots_signals(slots):
	for slot in slots:
		slot.itemPressed.connect(item_selected)
		
		
func update_slots(item_type):
	var filtered_slots = []
	for slot in inv.slots:
		if slot.item and slot.item.type == item_type:
			filtered_slots.append(slot)
			
	for i in range(min(filtered_slots.size(), slots.size())):
		slots[i].update(filtered_slots[i])

			
func item_selected(item):
	selected_item = item


func open_inventory(inv_type):
	update_slots(inv_type)
	self.visible = true

func _on_close_button_pressed():
	self.visible = false

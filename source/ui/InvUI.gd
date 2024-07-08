extends Control

signal foodSelected(food_item)

@onready var buttons_ui = get_tree().get_first_node_in_group("ButtonsUI")
@onready var inv: Inventory = preload("res://source/inventory/player_inv.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
@onready var selected_item: Item
@onready var itemSlotScene = preload("res://source/inventory/item_ui_slot.tscn")
@onready var itemUIContainer = $NinePatchRect/GridContainer
@onready var pet = get_tree().get_first_node_in_group("Pet")

var ITEM_UI_CONTAINER_PATH = "NinePatchRect/GridContainer/"
var ITEM_UI_SLOT_NAME  = 'ItemUISlot'
var shop_active = false

func _ready():
	setup_signals()
	self.visible = false
	
func setup_signals():
	buttons_ui.openInventory.connect(open_inventory)
	buttons_ui.closeUI.connect(close_inventory)
	pet.itemConsumed.connect(_on_item_consumed)
	inv.itemRemoved.connect(remove_item_ui_slot)

# Inventory Managment
func update_inventory(item_type):
	var item_type_slots = get_item_type_slots(item_type)
	check_for_new_slots(item_type_slots)
	update_slots(item_type_slots)
	
func get_item_type_slots(item_type: Item.ItemType) -> Array[InvSlot]:
	var filtered_slots: Array[InvSlot] = []
	for slot in inv.slots:
		if slot.item and slot.item.type == item_type:
			filtered_slots.append(slot)
	return filtered_slots

# Slot Managment
func check_for_new_slots(item_type_slots):
	for slot in item_type_slots:
		if !get_item_ui_node(slot.item.name):
			create_item_ui_slot(slot)
		
func get_item_ui_node(item_name: String):
	var node_name = ITEM_UI_SLOT_NAME + item_name
	var node_path = ITEM_UI_CONTAINER_PATH + node_name
	if has_node(node_path):
		return get_node(node_path)
	else:
		return null

func create_item_ui_slot(slot: InvSlot):
	var item_ui_slot = itemSlotScene.instantiate()
	item_ui_slot.name = ITEM_UI_SLOT_NAME + slot.item.name
	itemUIContainer.add_child(item_ui_slot)
	item_ui_slot.itemPressed.connect(item_selected)
	slots.append(item_ui_slot)
	
func remove_item_ui_slot(item: Item):
	var item_slot_ui = get_item_ui_node(item.name)
	if item_slot_ui:
		item_slot_ui.itemPressed.disconnect(item_selected)
		slots.erase(item_slot_ui)
		item_slot_ui.queue_free()

func update_slots(item_type_slots: Array[InvSlot]):
	for i in range(min(item_type_slots.size(), slots.size())):
		slots[i].update(item_type_slots[i])

# Item Selection	
func item_selected(item: Item):
	selected_item = item
	if selected_item.type == Item.ItemType.Food:
		foodSelected.emit(selected_item)
	close_inventory()
		
func _on_item_consumed(item: Item):
	inv.remove_item(item)
	update_slots(get_item_type_slots(Item.ItemType.Food))

# Inventory UI
func open_inventory(item_type):
	# Close if already open
	if self.visible == true:
		close_inventory()
		return
	update_inventory(item_type)
	self.visible = true
	
func _on_close_button_pressed():
	close_inventory()

func close_inventory():
	self.visible = false

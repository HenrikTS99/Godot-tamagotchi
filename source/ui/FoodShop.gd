extends Control

@onready var inv: Inventory = preload("res://source/inventory/food_store_inv.tres")
@onready var slots: Array = $GridContainer.get_children()
@onready var selected_item: Item
@onready var selected_item_sprite = $SelectedItemSprite
@onready var selected_item_label = $SelectedItemLabel
@onready var item_price_label = $ItemPrice
@onready var anim_player = $AnimationPlayer

func _ready():
	selected_item = preload("res://source/inventory/items/foods/banana.tres")
	inv.update.connect(update_slots)
	connect_slots_signals()
	update_slots()

func connect_slots_signals():
	for slot in slots:
		slot.itemPressed.connect(item_selected)
		
func update_slots():
	for i in range(min(inv.slots.size(), slots.size())):
		slots[i].update(inv.slots[i])

func item_selected(item):
	selected_item = item
	selected_item_sprite.texture = item.texture
	selected_item_label.text = item.name
	item_price_label.text = 'Price:' + str(item.price)

func _on_button_pressed():
	if selected_item:
		if selected_item.price > Global.coins:
			print('Cannot afford this.')
			return
		Global.coins -= selected_item.price
		Global.collect(selected_item)

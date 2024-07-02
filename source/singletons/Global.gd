extends Node

@onready var inv: Inventory = preload("res://source/inventory/player_inv.tres")


signal coinsChanged(value)

var coins: int = 5:
	set(new_value):
		coins = new_value
		emit_signal('coinsChanged', coins)


func _ready():
	inv.update.connect(print_items)


func collect(item):
	print(item.name, 'added to inventory')
	inv.insert(item)

func print_items():
	for slot in inv.slots:
		if slot.item:
			if slot.item.name:
				print(slot.item.name, slot.amount)
			else:
				print('item name not found')
		else:
			print('empty slot')

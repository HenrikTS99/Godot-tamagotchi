extends Node

@onready var inv: Inventory = preload("res://source/inventory/player_inv.tres")

signal coinsChanged(value)

var coins: int = 35:
	set(new_value):
		if (coins > new_value):
			totalCoinsSpent += coins - new_value
		else:
			totalCoinsEarned += new_value - coins
		coins = new_value
		emit_signal('coinsChanged', coins)

# Stats
var totalCoinsEarned: int = coins
var totalCoinsSpent: int = 0

var visitors: Array = []
var totalVisitors: int = 0
var uniqueVisitors: Array = []
var totalUniqueVisitors: int = 0
var averageHappiness: int = 0

var reviewsInfo: Array = []

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
			
# Stats
func add_visitor_to_array(new_visitor):
	print('new visitor:', new_visitor)
	visitors.append(new_visitor)
	if (new_visitor not in uniqueVisitors):
		uniqueVisitors.append(new_visitor)
		totalUniqueVisitors = uniqueVisitors.size()
	totalVisitors = visitors.size()

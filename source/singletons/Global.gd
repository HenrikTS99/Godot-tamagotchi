extends Node

@onready var inv: Inventory = preload("res://source/inventory/player_inv.tres")

signal coinsChanged(value)

var coins: int = 0:
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
	add_to_group("SaveGroup")
	inv.update.connect(print_items)

func on_save_game(saved_data:Array[SavedData]):
	var my_data = SavedGlobal.new()
	my_data.coins = coins
	my_data.totalCoinsEarned = totalCoinsEarned
	my_data.totalCoinsSpent = totalCoinsSpent
	my_data.visitors = visitors
	my_data.totalVisitors = totalVisitors
	my_data.totalUniqueVisitors = totalUniqueVisitors
	my_data.averageHappiness = averageHappiness
	my_data.reviewsInfo = reviewsInfo
	my_data.inv_slots = inv.slots
	saved_data.append(my_data)

func on_load_game(saved_data:SavedData):
	coins = saved_data.coins
	totalCoinsEarned = saved_data.totalCoinsEarned
	totalCoinsSpent = saved_data.totalCoinsSpent
	visitors = saved_data.visitors
	totalVisitors = saved_data.totalVisitors
	totalUniqueVisitors = saved_data.totalUniqueVisitors
	averageHappiness = saved_data.averageHappiness
	reviewsInfo = saved_data.reviewsInfo
	update_inv_slots(saved_data.inv_slots)
	
func update_inv_slots(inv_slots: Array[InvSlot]):
	# Update inv slots to saved inv slots
	inv.slots = []
	for slot in inv_slots:
		var new_slot = InvSlot.new()
		new_slot.item = slot.item
		new_slot.amount = slot.amount
		inv.slots.append(new_slot)
		
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

extends Resource

class_name Inventory

signal update
signal itemRemoved(item)

@export var slots: Array[InvSlot]

func insert(item: Item):
	var item_slots = slots.filter(func(slot): return slot.item == item)
	if !item_slots.is_empty():
		item_slots[0].amount += 1
	else:
		add_slot()
		var emptyslots = slots.filter(func(slot): return slot.item == null)
		if !emptyslots.is_empty():
			emptyslots[0].item = item
			emptyslots[0].amount = 1
	update.emit()

func remove_item(item: Item):
	var item_slots = slots.filter(func(slot): return slot.item == item)
	if !item_slots.is_empty():
		item_slots[0].amount -= 1
		if item_slots[0].amount <= 0:
			slots.erase(item_slots[0])
			itemRemoved.emit(item)
			print('slot removed!')
		update.emit()
		return
	assert(false, "Item not found in inventory: %s" % item.name)
		
func add_slot():
	print('extra inv slot added')
	var new_slot = InvSlot.new()
	slots.append(new_slot)

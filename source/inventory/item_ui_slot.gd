extends Panel

@onready var itemDisplay: Sprite2D = $CenterContainer/Panel/ItemDisplay
@onready var amount_label:Label = $CenterContainer/Panel/AmountLabel

var item: Item


signal itemPressed()

func update(slot: InvSlot):
	print(slot.item)
	if !slot.item:
		itemDisplay.visible = false
		amount_label.visible = false
	else:
		itemDisplay.visible = true
		itemDisplay.texture = slot.item.texture
		if slot.amount > 1:
			amount_label.visible = true
		else:
			amount_label.visible = false
		amount_label.text = str(slot.amount)
		item = slot.item


func _on_center_container_mouse_entered(event):
	pass


func _on_center_container_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if item:
				print(item.name)
				itemPressed.emit(item)
			pass

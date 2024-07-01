extends Area2D

signal poop_removed

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			print('poop clicked')
			poop_removed.emit()
			queue_free()
extends Area2D

signal poop_removed

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			poop_removed.emit()
			queue_free()

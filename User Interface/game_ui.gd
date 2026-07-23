extends Control


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("close_menu"):
		_hide_windows()

func _hide_windows() -> void:
	for child in get_children():
		if child is CanvasItem:
			child.visible = false

extends Camera2D


var zoom_speed = 1.0
var min_zoom = 0.6
var max_zoom = 2.0

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			set_zoom_level(zoom.x + 0.1)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			set_zoom_level(zoom.x - 0.1)


func set_zoom_level(value: float) -> void:
	value = clamp(value, min_zoom, max_zoom)
	zoom = Vector2(value, value)

extends Node2D

@onready var player :Player= get_parent()

@onready var weapon_marker: Marker2D = $WeaponMarker


func _process(delta: float) -> void:
	swap_side()

func swap_side() -> void:
	if player.direction_x < 0.0:
		weapon_marker.scale.x = -1
	else:
		weapon_marker.scale.x = 1

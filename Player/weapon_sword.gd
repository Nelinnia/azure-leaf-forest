extends Node2D

@onready var player :Player= get_parent().get_parent()

@onready var weapon_marker: Marker2D = $WeaponMarker


func _process(delta: float) -> void:
	swap_side()

func swap_side() -> void:
	pass

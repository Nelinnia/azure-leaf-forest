class_name DamageIndicator
extends Node2D

@onready var label: Label = %Label

var is_crit :bool= false

func display_amount(amount: int) -> void:
	position.x += randf_range(-32, 32)
	label.text = str(amount)
	if is_crit:
		label.add_theme_color_override("font_color", Color(0.8, 0.6, 0.0))
		label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 1))

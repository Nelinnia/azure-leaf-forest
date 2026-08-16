@icon("res://Editor/CritArea2D.png")
class_name CritArea2D
extends Area2D


func take_damage(damage: int) -> void:
	get_parent().take_damage(damage, true)
	

func apply_poison(damage_per_tick: int, ticks :int= 5) -> void:
	get_parent().apply_poison(damage_per_tick, ticks)

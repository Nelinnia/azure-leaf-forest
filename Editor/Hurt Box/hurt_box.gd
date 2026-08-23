class_name HurtBox

extends Area2D

@export var node: Node2D


func _ready() -> void:
	assert(node != null and node.has_method("take_damage"), "HurtBox node needs take_damage")

func take_damage(damage: int, source_position: Vector2 = global_position) -> void:
	print("hurtbox took damage: ", damage)
	node.take_damage(damage, source_position)

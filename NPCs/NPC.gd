class_name NPC
extends Area2D


@export var health :int= 100: set = set_health
@export var base_xp :int= 5


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_health(health)




func set_health(new_health: int) -> void:
	health = maxi(0, new_health)
	
	
	if health <= 0.0:
		_die(true)



func take_damage(damage: int) -> void:
	set_health(health - damage)
	
	var damage_indicator :Node2D= preload("res://User Interface/HUD/damage_indicator.tscn").instantiate()
	get_tree().current_scene.add_child(damage_indicator)
	damage_indicator.global_position = global_position
	damage_indicator.display_amount(damage)


func _die(was_killed :bool= false) -> void:
	if was_killed:
		PlayerStats.player_xp += base_xp
	
	queue_free()

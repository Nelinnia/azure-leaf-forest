class_name NPC
extends Node


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



func _die(was_killed :bool= false) -> void:
	if was_killed:
		PlayerStats.player_xp += base_xp
	
	queue_free()

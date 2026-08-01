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



var _poison_timer :Timer= null
var _poison_damage :int= 0
var _poison_accumulator :int= 0
func apply_poison(damage_per_tick: int) -> void:
	_poison_damage += damage_per_tick
	if _poison_timer == null:
		_poison_timer = Timer.new()
		add_child(_poison_timer)
		_poison_timer.wait_time = 5.0
		_poison_timer.timeout.connect(_on_poison_tick)
		_poison_timer.start()
func _on_poison_tick() -> void:
	if _poison_damage > 0:
		_poison_accumulator += _poison_damage
	



func _die(was_killed :bool= false) -> void:
	if was_killed:
		PlayerStats.player_xp += base_xp
	
	queue_free()

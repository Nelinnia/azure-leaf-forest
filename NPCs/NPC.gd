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



func take_damage(damage: int, is_crit: bool = false) -> void:
	if is_crit:
		damage *= 1.5
	set_health(health - damage)
	_spawn_damage_indicator(damage, false, is_crit)




var _poison_timer :Timer= null
var _poison_damage :int= 0
var _poison_ticks_remaining :int= 0
func apply_poison(damage_per_tick: int, ticks :int= 5) -> void:
	_poison_damage += damage_per_tick
	_poison_ticks_remaining = ticks
	if _poison_timer == null:
		_poison_timer = Timer.new()
		add_child(_poison_timer)
		_poison_timer.wait_time = 1.0
		_poison_timer.timeout.connect(_on_poison_tick)
	_poison_timer.start()
func _on_poison_tick() -> void:
	if _poison_damage > 0:
		set_health(health - _poison_damage)
		_spawn_damage_indicator(_poison_damage, true)
	_poison_ticks_remaining -= 1
	if _poison_ticks_remaining <= 0:
		_poison_timer.stop()



func _spawn_damage_indicator(amount: int, poison: bool, crit: bool = false) -> void:
	var damage_indicator :Node2D= preload("res://User Interface/HUD/damage_indicator.tscn").instantiate()
	get_tree().current_scene.add_child(damage_indicator)
	damage_indicator.global_position = global_position
	damage_indicator.is_poison = poison
	damage_indicator.is_crit = crit
	damage_indicator.display_amount(amount)


func _die(was_killed :bool= false) -> void:
	if was_killed:
		PlayerStats.player_xp += base_xp
	
	queue_free()

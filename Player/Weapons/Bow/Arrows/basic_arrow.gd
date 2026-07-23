class_name Arrow
extends Area2D

@export_category("Per-Charge Stats")
@export var charge_speeds :Array[float]= [500.0, 1000.0, 1500.0, 2000.0]
@export var charge_drop_speeds :Array[float]= [250.0, 180.0, 110.0, 40.0]
@export var charge_drop_rotations :Array[float]= [180.0, 90.0, 50.0, 10.0]
@export var charge_drop_start_distance: Array[float] = [100.0, 1000.0, 2000.0, 3000.0]

@export var max_distance :float= 10000.0

var speed :float
var drop_speed :float
var drop_rotation :float
var drop_start_distance :float


var bow :WeaponBow

var _traveled_distance :float= 0.0
var _start_rotation :float
var _max_rotation_offset :float= deg_to_rad(90.0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void: 
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)
	
	
var _rotation_sign :float= 1.0
func apply_charge(charge: int) -> void:
	var index := clampi(charge, 0, charge_speeds.size() - 1)
	speed = charge_speeds[index]
	drop_speed = charge_drop_speeds[index]
	drop_rotation = charge_drop_rotations[index]
	drop_start_distance = charge_drop_start_distance[index]
	_start_rotation = rotation
	_rotation_sign = 1.0 if cos(_start_rotation) >= 0.0 else -1.0

func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta
	if _traveled_distance > drop_start_distance:
		position += Vector2.DOWN * drop_speed * delta
	
		var rotated_amount := absf(wrapf(rotation - _start_rotation, -PI, PI))
		if rotated_amount < _max_rotation_offset:
			rotation += _rotation_sign * drop_rotation * delta * (PI / 180.0)
	
	_traveled_distance += speed * delta
	if _traveled_distance > max_distance:
		queue_free()


func _on_area_entered(other_area: Area2D) -> void: #detects NPCs
	if other_area is NPC:
		other_area.take_damage(bow.base_bow_damage)
	queue_free()
func _on_body_entered(body: Node2D) -> void: #detects the ground
	queue_free()

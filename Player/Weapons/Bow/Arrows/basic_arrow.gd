class_name Arrow
extends Area2D

@export var speed :float= 400.0
@export var max_distance :float= 10000.0
@export var drop_speed :float= 100
@export var drop_rotation :float= 1.0


var bow :WeaponBow

var _traveled_distance :float= 0.0
var velocity :Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void: 
	area_entered.connect(_on_area_entered)
	
	
	
func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta
	position += Vector2.DOWN * drop_speed * delta
	rotation_degrees += drop_rotation * delta
	
	_traveled_distance += velocity.length() * delta
	if _traveled_distance > max_distance:
		queue_free()

func calculate_arrow_variables() -> void:
	bow.draw_counter


func _on_area_entered(other_area: Area2D) -> void:
	pass

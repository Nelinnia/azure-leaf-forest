class_name FishingRod
extends WeaponBase


@onready var bow_marker: Marker2D = $"../WeaponBow/BowMarker"
@onready var line_marker: Marker2D = $FishingRodMarker/LineMarker
@onready var fishing_line: Line2D = $FishingLine
@onready var attack_animation_player: AnimationPlayer = %AttackAnimationPlayer

const LURE = preload("res://Player/Weapons/Fishing Rod/lure.tscn")
const CAST_SPEED :float= 600.0

var aim_angle :float= 0.0
var current_lure :Lure= null

func _ready() -> void:
	fishing_line.clear_points()
	fishing_line.visible = false

func handle_process(delta: float) -> void:
	var to_mouse := get_global_mouse_position() - player.global_position
	
	aim_angle = to_mouse.angle()
	bow_marker.rotation = aim_angle
	
	var facing_left := absf(wrapf(aim_angle, -PI, PI)) > PI / 2.0
	
	_update_fishing_line()


func on_attack_pressed() -> void:
	if current_lure == null:
		attack_animation_player.play("Casting")
		_cast_lure()
	else:
		current_lure.reel_in()

#spawns line between lure and pole
func _update_fishing_line() -> void:
	if current_lure == null:
		fishing_line.visible = false
		return
	
	fishing_line.visible = true
	fishing_line.clear_points()
	fishing_line.add_point(fishing_line.to_local(line_marker.global_position))
	fishing_line.add_point(fishing_line.to_local(current_lure.global_position))

#spawns lure
func _cast_lure() -> void:
	current_lure = LURE.instantiate()
	get_tree().current_scene.add_child(current_lure)
	current_lure.global_position = line_marker.global_position
	current_lure.velocity = Vector2.from_angle(aim_angle) * CAST_SPEED
	current_lure.reeled_in.connect(_on_lure_reeled_in)

func _on_lure_reeled_in() -> void:
	current_lure = null

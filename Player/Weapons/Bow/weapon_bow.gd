class_name WeaponBow
extends WeaponBase


@onready var bow_marker: Marker2D = $BowMarker
@onready var bow_ani_sprite: AnimatedSprite2D = $BowMarker/BowAniSprite
@onready var arrow_sprite: Sprite2D = $BowMarker/ArrowSprite

@onready var draw_timer: Timer = %DrawTimer

const BASIC_ARROW :PackedScene= preload("res://Player/Weapons/Bow/Arrows/basic_arrow.tscn")

var draw_counter :int= 0

var aim_angle :float= 0.0


func _ready() -> void:
	draw_timer.timeout.connect(_draw_bow)

func handle_process(delta: float) -> void:
	var to_mouse := get_global_mouse_position() - player.global_position
	
	aim_angle = to_mouse.angle()
	bow_marker.rotation = aim_angle
	
	var facing_left := absf(wrapf(aim_angle, -PI, PI)) > PI / 2.0
	bow_ani_sprite.flip_v = facing_left
	arrow_sprite.flip_v = facing_left

func on_attack_pressed() -> void:
	draw_timer.start()
	arrow_sprite.visible = true

func on_attack_released() -> void:
	draw_timer.stop()
	arrow_sprite.visible = false
	bow_ani_sprite.frame = 0
	
	var arrow :Node2D= BASIC_ARROW.instantiate()
	get_tree().current_scene.add_child(arrow)
	arrow.global_position = bow_marker.global_position
	arrow.global_rotation = aim_angle
	arrow.apply_charge(draw_counter)
	
	draw_counter = 0
	
	launch_backward()

@export var max_charge :int= 3
func _draw_bow() -> void:
	if draw_counter < max_charge:
		draw_counter += 1
		bow_ani_sprite.frame += 1
	
	if draw_counter >= max_charge:
		draw_timer.stop()

func launch_backward() -> void:
	var to_mouse := get_global_mouse_position() - player.global_position
	if draw_counter >= 3 and not player.State.GROUND :
		pass

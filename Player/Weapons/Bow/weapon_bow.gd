class_name WeaponBow
extends WeaponBase


@onready var bow_marker: Marker2D = $BowMarker
@onready var bow_ani_sprite: AnimatedSprite2D = $BowMarker/BowAniSprite
@onready var arrow_sprite: Sprite2D = $BowMarker/ArrowSprite

@onready var draw_timer: Timer = %DrawTimer
@onready var lock_out_timer: Timer = %LockOutTimer
@onready var bow_draw_audio: AudioStreamPlayer2D = %BowDrawAudio


const BASIC_ARROW :PackedScene= preload("res://Player/Weapons/Bow/Arrows/basic_arrow.tscn")

var draw_counter :int= 0
@export var base_bow_damage :int= 2

var aim_angle :float= 0.0
var is_locked_out :bool= false

@export var boost_distance :float= 300.0

func _ready() -> void:
	draw_timer.timeout.connect(_draw_bow)
	lock_out_timer.timeout.connect(_lock_out_timeout)

func handle_process(delta: float) -> void:
	var to_mouse := get_global_mouse_position() - player.global_position
	
	aim_angle = to_mouse.angle()
	bow_marker.rotation = aim_angle
	
	var facing_left := absf(wrapf(aim_angle, -PI, PI)) > PI / 2.0
	bow_ani_sprite.flip_v = facing_left
	arrow_sprite.flip_v = facing_left

func on_attack_pressed() -> void:
	if is_locked_out: #prevents the player from spamming base arrow.
		return
	draw_timer.start()
	arrow_sprite.visible = true

func on_attack_released() -> void:
	if is_locked_out: #prevents the player from spamming base arrow.
		return
	draw_timer.stop()
	arrow_sprite.visible = false
	bow_ani_sprite.frame = 0
	
	if draw_counter == 0: #prevents the player from spamming base arrow.
		is_locked_out = true
		lock_out_timer.start() 
	
	var arrow :Node2D= BASIC_ARROW.instantiate()
	get_tree().current_scene.add_child(arrow)
	arrow.global_position = bow_marker.global_position
	arrow.global_rotation = aim_angle
	arrow.bow = self
	arrow.apply_charge(draw_counter)
	
	launch_backward()
	
	draw_counter = 0

@export var max_charge :int= 3
func _draw_bow() -> void:
	#get_bow_damage()
	bow_draw_audio.play()
	if draw_counter < max_charge:
		draw_counter += 1
		bow_ani_sprite.frame += 1
	
	if draw_counter >= max_charge:
		draw_timer.stop()

@export var charge_multipliers :Array[float]= [1, 2, 3, 5]
func get_bow_damage(charge: int) -> float:
	var index := clampi(charge, 0, charge_multipliers.size() - 1)
	var multiplier := charge_multipliers[index]
	return (base_bow_damage + PlayerStats.get_bow_damage_bonus()) * multiplier
	

func launch_backward() -> void:
	var is_airboren := player.current_state != Player.State.GROUND
	var is_max_charge := draw_counter >= max_charge
	
	if is_airboren and is_max_charge:
		var boost_direction := -Vector2.RIGHT.rotated( aim_angle)
		player.apply_movement_boost(boost_direction * boost_distance)

#prevents the player from spamming base arrow.
func _lock_out_timeout() -> void:
	is_locked_out = false

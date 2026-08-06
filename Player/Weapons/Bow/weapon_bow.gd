class_name WeaponBow
extends WeaponBase


@onready var weapon_magic :WeaponMagic= get_parent().get_node("WeaponMagic")

@onready var bow_marker: Marker2D = $BowMarker
@onready var bow_ani_sprite: AnimatedSprite2D = $BowMarker/BowAniSprite
@onready var arrow_sprite: Sprite2D = $BowMarker/ArrowSprite
@onready var charge_gpu_particles: GPUParticles2D = $ChargeGPUParticles


@onready var draw_timer: Timer = %DrawTimer
@onready var lock_out_timer: Timer = %LockOutTimer

@onready var bow_draw_audio: AudioStreamPlayer2D = %BowDrawAudio
@onready var arrow_loose_audio: AudioStreamPlayer2D = %ArrowLooseAudio



const BASIC_ARROW :PackedScene = preload("res://Player/Weapons/Bow/Arrows/basic_arrow.tscn")
const MAGIC_ARROW :PackedScene = preload("res://Player/Weapons/Bow/Arrows/Magic_Arrow/magic_arrow.tscn")


var draw_counter :int= 0
@export var base_bow_damage :int= 2

var mana_consumed :bool= false

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
	mana_consumed = false
	if PlayerStats.is_magic_active == true:
		if PlayerStats.player_mana >= MagicArrow.MANA_COST:
			mana_consumed = true
			player.mana_cost(MagicArrow.MANA_COST)
			charge_gpu_particles.emitting = true
		else:
			PlayerStats.set_magic_active(false)
	_get_draw_time()
	draw_timer.start()
	arrow_sprite.visible = true

func on_attack_released() -> void:
	if is_locked_out: #prevents the player from spamming base arrow.
		return
	draw_timer.stop()
	arrow_sprite.visible = false
	bow_ani_sprite.frame = 0
	charge_gpu_particles.emitting = false
	arrow_loose_audio.play()
	
	if draw_counter == 0: #prevents the player from spamming base arrow.
		is_locked_out = true
		lock_out_timer.start() 
	 
	if PlayerStats.is_magic_active == true and mana_consumed == true:
		var arrow: Node2D = MAGIC_ARROW.instantiate()
		get_tree().current_scene.add_child(arrow)
		arrow.global_position = bow_marker.global_position
		arrow.global_rotation = aim_angle
		arrow.bow = self
		arrow.apply_charge(draw_counter)
		#player.mana_cost(arrow.mana_cost)
	else:
		var arrow :Node2D = BASIC_ARROW.instantiate()
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

func get_magic_damage(charge: int) -> float:
	var index := clampi(charge, 0, charge_multipliers.size() - 1)
	var multiplier := charge_multipliers[index]
	return (PlayerStats.get_magic_damage_bonus() * 2)


@export var base_draw_time := 1.05
func _get_draw_time() -> void:
	var timer_reduction := PlayerStats.get_weapon_charge_rate_deduction()
	draw_timer.wait_time = maxf(base_draw_time - timer_reduction, 0.05)

func launch_backward() -> void:
	var direction := -Vector2.RIGHT.rotated(aim_angle)
	launch_boost(direction, draw_counter >= max_charge, boost_distance)

#prevents the player from spamming base arrow.
func _lock_out_timeout() -> void:
	is_locked_out = false

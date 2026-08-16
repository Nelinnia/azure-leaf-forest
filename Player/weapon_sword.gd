class_name WeaponSword
extends WeaponBase



@onready var weapon_marker: Marker2D = $WeaponMarker
@onready var charge_timer: Timer = %ChargeTimer
@onready var sword_area_2d: Area2D = $WeaponMarker/Sword/SwordArea2D
@onready var air_spin_area: Area2D = %AirSpinArea

@onready var sparkle: Sprite2D = %Sparkle
@onready var sparkle_2: Sprite2D = %Sparkle2
@onready var sparkle_3: Sprite2D = %Sparkle3
@onready var charge_ani_sprite: AnimatedSprite2D = $WeaponMarker/Pips/ChargeAniSprite

@onready var poison_anim: AnimatedSprite2D = $WeaponMarker/Sword/PoisonAnim
@onready var poison_swing_anim: AnimatedSprite2D = $WeaponMarker/Sword/PoisonSwingAnim

@export var boost_distance :float= 300.0

@onready var pipcharge_audio: AudioStreamPlayer2D = $WeaponMarker/Pips/PipchargeAudio


var charges :int= 0 # used to count the charges before sword begins swinging
@export var max_charge :int= 3

@export var base_sword_damage :int= 7
var charge_level :int= 0 # used so when sword swings it remembers what charge the attack had

const MANA_COST :int= 10
var mana_consumed :bool = false

func _ready() -> void:
	charge_timer.timeout.connect(_on_charge_timeout)
	sword_area_2d.area_entered.connect(_on_area_entered) 

func get_aim_direction() -> Vector2:
	return(get_global_mouse_position() - player.global_position).normalized()

func on_attack_pressed() -> void:
	mana_consumed = false
	if PlayerStats.is_magic_active == true:
		if PlayerStats.player_mana >= MANA_COST:
			mana_consumed = true
			player.mana_cost(MANA_COST)
			poison_anim.visible = true
			poison_anim.play("PoisonStart")
		else:
			PlayerStats.set_magic_active(false)
			poison_anim.visible = false
	_get_charge_time()
	charge_timer.start()
	player.attack_animation_player.play("sword_swing_charge")
	player.left_arm.play("sword_swing_ground")
	player.left_arm.frame = 1
	player.left_arm.pause()
	player.right_arm.frame = 1
	player.right_arm.pause()

func on_attack_released() -> void:
	var is_airborne := player.current_state != Player.State.GROUND
	if is_airborne:
		air_spin_area.monitoring = true
	sword_area_2d.monitoring = true
	charge_level = charges
	charge_timer.stop()
	player._start_attack()
	if mana_consumed == true:
		poison_swing_anim.visible = true
		poison_swing_anim.play("PoisonTrail")
	launch_forward()
	reset_charges()

func on_attack_end() -> void: #called during animations as method tracks. 
	var is_airborne := player.current_state != Player.State.GROUND
	sword_area_2d.monitoring = false
	poison_swing_anim.visible = false
	if is_airborne:
		air_spin_area.monitoring = false


func _on_charge_timeout() -> void:
	charges += 1
	#print(charges)
	if charges == 1:
		sparkle.visible = true
		pipcharge_audio.play()
	if charges == 2:
		sparkle_2.visible = true
		pipcharge_audio.play()
	if charges == 3:
		sparkle_3.visible = true
		charge_ani_sprite.visible = true
		pipcharge_audio.play()

func reset_charges() -> void:
	charges = 0
	sparkle.visible = false
	sparkle_2.visible = false
	sparkle_3.visible = false
	charge_ani_sprite.visible = false

@export var charge_multipliers :Array[float]= [1, 2, 3, 5]
func get_sword_damage(charge: int) -> float:
	var index := clampi(charge, 0, charge_multipliers.size() - 1)
	var multiplier := charge_multipliers[index]
	return (base_sword_damage + PlayerStats.get_sword_damage_bonus()) * multiplier

func get_poison_damage(charge: int) -> float:
	var index := clampi(charge, 0, charge_multipliers.size() - 1)
	var multiplier := charge_multipliers[index]
	return (PlayerStats.get_magic_damage_bonus() * multiplier)

func _on_area_entered(other_area: Area2D) -> void:
	if other_area.has_method("take_damage"):
		other_area.take_damage(get_sword_damage(charge_level))
		if mana_consumed:
			other_area.apply_poison(get_poison_damage(charge_level))


@export var base_charge_time := 1.05
func _get_charge_time() -> void:
	var timer_reduction := PlayerStats.get_weapon_charge_rate_deduction()
	charge_timer.wait_time = maxf(base_charge_time - timer_reduction, 0.05)

func launch_forward() -> void:
	var direction := get_aim_direction()
	launch_boost(direction, charges >= max_charge, boost_distance)

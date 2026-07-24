class_name WeaponSword
extends WeaponBase



@onready var weapon_marker: Marker2D = $WeaponMarker
@onready var charge_timer: Timer = %ChargeTimer
@onready var sword_area_2d: Area2D = $WeaponMarker/Sword/SwordArea2D

@onready var sparkle: Sprite2D = %Sparkle
@onready var sparkle_2: Sprite2D = %Sparkle2
@onready var sparkle_3: Sprite2D = %Sparkle3
@onready var charge_ani_sprite: AnimatedSprite2D = $WeaponMarker/Pips/ChargeAniSprite

@export var boost_distance :float= 300.0

@onready var pipcharge_audio: AudioStreamPlayer2D = $WeaponMarker/Pips/PipchargeAudio


var charges :int= 0 # used to count the charges before sword begins swinging
@export var max_charge :int= 3

@export var base_sword_damage :int= 7
var charge_level :int= 0 # used so when sword swings it remembers what charge the attack had


func _ready() -> void:
	charge_timer.timeout.connect(_on_charge_timeout)
	sword_area_2d.area_entered.connect(_on_area_entered) 

func on_attack_pressed() -> void:
	#sword_area_2d.monitoring = false
	charge_timer.start()
	player.attack_animation_player.play("sword_swing_charge")
	player.left_arm.play("sword_swing_ground")
	player.left_arm.frame = 1
	player.left_arm.pause()
	player.right_arm.frame = 1
	player.right_arm.pause()

func on_attack_released() -> void:
	sword_area_2d.monitoring = true
	charge_level = charges
	charge_timer.stop()
	player._start_attack()
	launch_forward()
	reset_charges()

func on_attack_end() -> void: #called during animations as method tracks. 
	sword_area_2d.monitoring = false

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

func _on_area_entered(other_area: Area2D) -> void:
	if other_area is NPC:
		other_area.take_damage(get_sword_damage(charge_level))

func launch_forward() -> void:
	var is_airborn := player.current_state != Player.State.GROUND
	var is_max_charge := charges >= max_charge
	
	if is_airborn and is_max_charge:
		var boost_direction := player.velocity.normalized()
		if boost_direction == Vector2.ZERO:
			boost_direction = Vector2.LEFT if player.is_facing_left else Vector2.RIGHT
		player.apply_movement_boost(boost_direction * boost_distance)

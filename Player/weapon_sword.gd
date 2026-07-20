class_name WeaponSword
extends WeaponBase




@onready var weapon_marker: Marker2D = $WeaponMarker
@onready var charge_timer: Timer = %ChargeTimer

@onready var sparkle: Sprite2D = %Sparkle
@onready var sparkle_2: Sprite2D = %Sparkle2
@onready var sparkle_3: Sprite2D = %Sparkle3
@onready var charge_ani_sprite: AnimatedSprite2D = $WeaponMarker/Pips/ChargeAniSprite


@onready var pipcharge_audio: AudioStreamPlayer2D = $WeaponMarker/Pips/PipchargeAudio



var charges :int= 0

func _ready() -> void:
	charge_timer.timeout.connect(_on_charge_timeout)

func on_attack_pressed() -> void:
	charge_timer.start()
	player.attack_animation_player.play("sword_swing_charge")
	player.left_arm.play("sword_swing_ground")
	player.left_arm.frame = 1
	player.left_arm.pause()
	player.right_arm.frame = 1
	player.right_arm.pause()

func on_attack_released() -> void:
	charge_timer.stop()
	player._start_attack()
	reset_charges()


func _on_charge_timeout() -> void:
	charges += 1
	print(charges)
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

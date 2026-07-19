extends Node2D

@onready var player :Player= get_parent().get_parent()


@onready var weapon_marker: Marker2D = $WeaponMarker
@onready var charge_timer: Timer = %ChargeTimer

@onready var sparkle: Sprite2D = %Sparkle
@onready var sparkle_2: Sprite2D = %Sparkle2
@onready var sparkle_3: Sprite2D = %Sparkle3


var charges :int= 0

func _ready() -> void:
	charge_timer.timeout.connect(_on_charge_timeout)


func _on_charge_timeout() -> void:
	charges += 1
	print(charges)
	if charges == 1:
		sparkle.visible = true
	if charges == 2:
		sparkle_2.visible = true
	if charges == 3:
		sparkle_3.visible = true


func reset_charges() -> void:
	charges = 0
	sparkle.visible = false
	sparkle_2.visible = false
	sparkle_3.visible = false

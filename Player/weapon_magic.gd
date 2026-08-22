class_name WeaponMagic
extends WeaponBase



@onready var poison_anim: AnimatedSprite2D = $"../Visuals/Weapon/WeaponMarker/Sword/PoisonAnim"




func _input(event: InputEvent) -> void:
	if event.is_action_pressed("magic"):
		PlayerStats.set_magic_active(!PlayerStats.is_magic_active)
		if poison_anim.visible: # poison would stay on if magic was manually turned off
			poison_anim.visible = false



func magic_arrow() -> void:
	if Player.Weapon_State.BOW:
		pass

func magic_sword() -> void:
	if Player.Weapon_State.SWORD:
		pass

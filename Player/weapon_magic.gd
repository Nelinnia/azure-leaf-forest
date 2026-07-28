class_name WeaponMagic
extends WeaponBase







func _input(event: InputEvent) -> void:
	if event.is_action_pressed("magic"):
		PlayerStats.set_magic_active(!PlayerStats.is_magic_active)



func magic_arrow() -> void:
	if Player.Weapon_State.BOW:
		pass

func magic_sword() -> void:
	if Player.Weapon_State.SWORD:
		pass

class_name WeaponBase
extends  Node2D

var player: Player

func setup(p: Player) -> void:
	player = p

func activate() -> void:
	visible = true

func deactivate() -> void:
	visible = false

func handle_process(delta: float) -> void:
	pass

func on_attack_pressed() -> void:
	pass

func on_attack_released() -> void:
	pass


func launch_boost(direction: Vector2, is_max_charge: bool, distance: float) -> void:
	var is_airborne := player.current_state != Player.State.GROUND
	if is_airborne and is_max_charge:
		player.apply_movement_boost(direction * distance)

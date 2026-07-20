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

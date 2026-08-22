class_name FishingArea
extends Area2D


var player_in_area :Player= null

func _ready() -> void:
	body_entered.connect(_on_player_entered)
	body_exited.connect(_on_player_exited)


func _on_player_entered(body: Node2D) -> void:
	if body is Player:
		player_in_area = body
		player_in_area.can_fish = true
		if player_in_area.current_weapon == Player.Weapon_State.BOW:
			player_in_area.equip_weapon(Player.Weapon_State.FISHING_ROD)

func _on_player_exited(body: Node2D) -> void:
	if body == player_in_area:
		player_in_area.can_fish = false
		if player_in_area.current_weapon == Player.Weapon_State.FISHING_ROD:
			player_in_area.equip_weapon(Player.Weapon_State.BOW)
		player_in_area = null

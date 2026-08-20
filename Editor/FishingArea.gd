class_name FishingArea
extends Area2D


var can_fish :bool= false

func _ready() -> void:
	area_entered.connect(_on_player_entered)


func _on_player_entered() -> void:
	if Player.Weapon_State.BOW:
		can_fish = true
	else:
		return

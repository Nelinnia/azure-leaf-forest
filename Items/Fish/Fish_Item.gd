class_name FishItem
extends Item

@export var catch_chance :float= 1.0
@export var xp_reward :int= 1


func on_acquired(player: Player) -> void:
	PlayerStats.add_xp(xp_reward)
	

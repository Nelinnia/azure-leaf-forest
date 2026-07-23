extends NPC





func take_damage(damage: int) -> void:
	set_health(health - damage)
	PlayerStats.player_xp += base_xp


func _die(was_killed :bool= false) -> void:
	if  health >= 0.0:
		PlayerStats.player_xp += base_xp
		health += 1000

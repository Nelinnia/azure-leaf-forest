extends NPC

# BUG: when hody is hit damage isnt registered(fix later) 
# Arrow only hits head since its "NPC" body is just area2D
@onready var body_area: Area2D = %BodyArea

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	super._ready()
	self.area_entered.connect(_on_head_hit)
	body_area.area_entered.connect(_on_body_hit)



func _on_body_hit(area: Area2D) -> void:
	animation_player.play("body_hit")
func _on_head_hit(area: Area2D) -> void:
	animation_player.play("head_hit")

func take_damage(damage: int) -> void:
	set_health(health - damage)
	PlayerStats.player_xp += base_xp
	var damage_indicator :Node2D= preload("res://User Interface/HUD/damage_indicator.tscn").instantiate()
	get_tree().current_scene.add_child(damage_indicator)
	damage_indicator.global_position = global_position
	damage_indicator.display_amount(damage)
	print(health)


func _die(was_killed :bool= false) -> void:
	if  health >= 0.0:
		PlayerStats.player_xp += base_xp
		health += 1000

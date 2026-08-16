class_name StandingTarget
extends NPC



@onready var crit_area_2d: CritArea2D = %CritArea2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer



func _ready() -> void:
	super._ready()
	self.area_entered.connect(_on_body_hit)
	crit_area_2d.area_entered.connect(_on_head_hit)



func _on_body_hit(area: Area2D) -> void:
	animation_player.play("body_hit")
func _on_head_hit(area: Area2D) -> void:
	animation_player.play("head_hit")

func take_damage(damage: int, is_crit :bool= false) -> void:
	super.take_damage(damage, is_crit)
	PlayerStats.add_xp(base_xp)
	print(health)


func _die(was_killed :bool= false) -> void:
	if  health >= 0.0:
		PlayerStats.add_xp(base_xp * 2)
		health += 1000

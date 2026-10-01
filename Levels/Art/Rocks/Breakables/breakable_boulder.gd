class_name BreakableObject
extends NPC


@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var breakable: Sprite2D = $Breakable
@onready var breakable_2: Sprite2D = $Breakable2

@onready var max_health :int= health


var is_broken :bool = false
func take_damage(damage: int, is_crit: bool = false) -> void:
	super.take_damage(damage, is_crit)
	sprite_2d.frame = floori(5.0 * (max_health - health) / max_health)
	if sprite_2d.frame >= 3 and not is_broken:
		is_broken = true
		breakable.visible = true
		breakable_2.visible = true
		animation_player.play("Breaking")

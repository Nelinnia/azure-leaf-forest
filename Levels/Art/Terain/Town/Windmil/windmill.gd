extends Node2D


@onready var player_anim: AnimationPlayer = $AnimationPlayer



func _ready() -> void:
	player_anim.play("spin")
	var anim := player_anim.get_animation("spin")
	var random_time := randf_range(0.0, anim.length)
	player_anim.seek(random_time, true)

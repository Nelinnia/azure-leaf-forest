class_name LureArea
extends Area2D

@export var fish_pool :Array[FishItem] = []
@export var fish_remaining :int = 0

const SPLASH_ANIM := preload("res://Levels/Art/Effects/Water/Splash/splash_anim.tscn")


func _ready() -> void:
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)
	

func _on_area_entered(area:  Area2D) -> void:
	_spawn_splash(area.global_position)

func _on_body_entered(body: Node2D) -> void:
	_spawn_splash(body.global_position)


func _spawn_splash(positon: Vector2) -> void:
	var splash := SPLASH_ANIM.instantiate()
	get_tree().current_scene.add_child(splash)
	splash.global_position = positon


func catch() -> FishItem:
	if fish_remaining <= 0 or fish_pool.is_empty():
		return null
	
	var total_weight := 0.0
	for fish in fish_pool:
		total_weight += fish.catch_chance
	
	var roll := randf() * total_weight
	var total :float= 0.0
	for fish in fish_pool:
		total += fish.catch_chance
		if roll <= total:
			fish_remaining -= 1
			return fish
	
	return null

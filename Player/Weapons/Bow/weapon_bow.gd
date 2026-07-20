class_name WeaponBow
extends WeaponBase



@onready var bow_marker: Marker2D = $BowMarker
@onready var bow_ani_sprite: AnimatedSprite2D = $BowMarker/BowAniSprite
@onready var arrow_sprite: Sprite2D = $BowMarker/ArrowSprite

@onready var draw_timer: Timer = %DrawTimer

const BASIC_ARROW :PackedScene= preload("res://Player/Weapons/Bow/Arrows/basic_arrow.tscn")

var draw_counter :int= 0

func _ready() -> void:
	draw_timer.timeout.connect(_draw_bow)

func handle_process(delta: float) -> void:
	var to_mouse := get_global_mouse_position() - player.global_position
	bow_marker.rotation = to_mouse.angle()

func on_attack_pressed() -> void:
	draw_timer.start()
	arrow_sprite.visible = true

func on_attack_released() -> void:
	draw_timer.stop()
	arrow_sprite.visible = false
	bow_ani_sprite.frame = 0
	draw_counter = 0
	
	var arrow :Node2D= BASIC_ARROW.instantiate()
	get_tree().current_scene.add_child(arrow)
	arrow.global_transform = bow_marker.global_transform


func _draw_bow() -> void:
	draw_counter += 1
	bow_ani_sprite.frame += 1

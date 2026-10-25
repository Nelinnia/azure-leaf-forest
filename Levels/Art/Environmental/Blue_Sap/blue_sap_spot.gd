
extends Node2D



@onready var blue_sap_spot_anim: AnimatedSprite2D = %Blue_Sap_Spot_Anim
@onready var marker_2d: Marker2D = $Blue_Sap_Spot_Anim/Marker2D


func _ready() -> void:
	var frame_count := blue_sap_spot_anim.sprite_frames.get_frame_count(blue_sap_spot_anim.animation)
	blue_sap_spot_anim.frame = randi() % frame_count
	blue_sap_spot_anim.play()
	blue_sap_spot_anim.frame_changed.connect(_on_sap_drop)
	


func _on_sap_drop() -> void:
	var blue_sap_ball :Node2D= preload("res://Levels/Art/Environmental/Blue_Sap/blue_sap_ball.tscn").instantiate()
	if blue_sap_spot_anim.frame == 0:
		blue_sap_ball.global_transform  = marker_2d.global_transform
		get_tree().current_scene.add_child(blue_sap_ball)

extends Node2D


@onready var fog_spawn_timer: Timer = %FogSpawnTimer


@onready var fog_spawn_marker: Marker2D = $FogSpawnMarker
@onready var fog_spawn_marker_2: Marker2D = $FogSpawnMarker2
@onready var fog_spawn_marker_3: Marker2D = $FogSpawnMarker3
@onready var fog_spawn_marker_4: Marker2D = $FogSpawnMarker4


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fog_spawn_timer.timeout.connect(_on_fog_timer_time_out)




func _on_fog_timer_time_out() -> void:
	var spawn_points := [fog_spawn_marker, fog_spawn_marker_2, fog_spawn_marker_3, fog_spawn_marker_4]
	var spawn_point :Marker2D= spawn_points.pick_random()
	var fog_cloud :Node2D= preload("res://Levels/Art/Effects/Fog/fog.tscn").instantiate()
	
	fog_cloud.global_transform = spawn_point.global_transform
	get_tree().current_scene.add_child(fog_cloud)

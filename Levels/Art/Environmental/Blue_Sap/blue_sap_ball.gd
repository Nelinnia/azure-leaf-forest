extends Sprite2D


@onready var area_2d: Area2D = %Area2D
@onready var blue_sap_ball_anim: Sprite2D = %BlueSapBallAnim


func _ready() -> void:
	area_2d.body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	var splash :Node2D= preload("res://Levels/Art/Effects/Water/Splash/splash_anim.tscn").instantiate()
	blue_sap_ball_anim.visible = false
	get_tree().current_scene.add_child(splash)
	splash.global_position = global_position
	splash.scale = Vector2(0.3, 0.3)
	queue_free()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.global_position.y += 4

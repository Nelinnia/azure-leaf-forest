extends Sprite2D





# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.z_index = 10


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.global_position.x -= 1

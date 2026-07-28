extends Timer

@onready var player: Player = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.timeout.connect(_on_timeout)


func _on_timeout() -> void:
	player.restore_health(1)
	player.restore_mana(PlayerStats.max_player_mana * 0.05)

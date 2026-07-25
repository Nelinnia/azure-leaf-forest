extends Control

@onready var mana_bar: TextureProgressBar = $ManaBar
@onready var health_bar: TextureProgressBar = $HealthBar
@onready var exp_bar: TextureProgressBar = $ExpBar

func _ready() -> void:
	PlayerStats.health_changed.connect(update_health_bar)


func update_health_bar() -> void:
	health_bar.value = PlayerStats.player_health
	health_bar.max_value = PlayerStats.max_player_hp

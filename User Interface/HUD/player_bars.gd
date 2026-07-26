extends Control

@onready var mana_bar: TextureProgressBar = $ManaBar
@onready var health_bar: TextureProgressBar = $HealthBar
@onready var exp_bar: TextureProgressBar = $ExpBar

func _ready() -> void:
	PlayerStats.health_changed.connect(update_health_bar)
	PlayerStats.xp_changed.connect(update_xp_bar)

func update_health_bar(current: int, max_hp: int) -> void:
	health_bar.value = current
	health_bar.max_value = max_hp


func update_xp_bar(current: int) -> void:
	exp_bar.value = current

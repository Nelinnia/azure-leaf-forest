class_name PlayerBars
extends Control


@onready var mana_bar: TextureProgressBar = $ManaBar
@onready var health_bar: TextureProgressBar = $HealthBar
@onready var exp_bar: TextureProgressBar = $ExpBar

@onready var mana_active_sprite: Sprite2D = $ManaBar/ManaActiveSprite

func _ready() -> void:
	PlayerStats.health_changed.connect(update_health_bar)
	PlayerStats.mana_changed.connect(update_mana_bar)
	PlayerStats.xp_changed.connect(update_xp_bar)
	PlayerStats.magic_activated.connect(mana_bar_toggle)


func update_health_bar(current: int, max_hp: int) -> void:
	health_bar.value = current
	health_bar.max_value = max_hp


func update_xp_bar(current: int) -> void:
	exp_bar.value = current


func update_mana_bar(current: int, max_mana: int) -> void:
	mana_bar.value = current
	mana_bar.max_value = max_mana

func mana_bar_toggle(active: bool) -> void:
	mana_active_sprite.visible = active

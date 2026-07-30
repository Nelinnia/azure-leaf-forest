class_name PlayerBars
extends Control


@onready var mana_bar: TextureProgressBar = $ManaBar
@onready var health_bar: TextureProgressBar = $HealthBar
@onready var exp_bar: TextureProgressBar = $ExpBar

@onready var mana_bar_label: Label = $ManaBar/ManaBarLabel
@onready var health_bar_label: Label = $HealthBar/HealthBarLabel

@onready var mana_active_sprite: Sprite2D = $ManaBar/ManaActiveSprite

func _ready() -> void:
	PlayerStats.health_changed.connect(update_health_bar)
	PlayerStats.mana_changed.connect(update_mana_bar)
	PlayerStats.xp_changed.connect(update_xp_bar)
	PlayerStats.magic_activated.connect(mana_bar_toggle)


func update_health_bar(current: int, max_hp: int) -> void:
	health_bar.value = current
	health_bar.max_value = max_hp
	health_bar_label.text = "%.0f" % health_bar.value

func update_xp_bar(current: int) -> void:
	exp_bar.value = current


func update_mana_bar(current: int, max_mana: int) -> void:
	mana_bar.value = current
	mana_bar.max_value = max_mana
	mana_bar_label.text = "%.0f" % mana_bar.value

func mana_bar_toggle(active: bool) -> void:
	mana_active_sprite.visible = active

#called in settings manager 
func bar_label_visibility_toggle(enabled) -> void:
	health_bar_label.visible = enabled
	mana_bar_label.visible = enabled

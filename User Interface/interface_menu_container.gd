class_name InterfaceMenu
extends PanelContainer


@onready var player_bars: PlayerBars = %PlayerBars


@onready var player_bar_toggle_label: Label = %PlayerBarToggleLabel
@onready var player_bar_toggle_check: CheckButton = %PlayerBarToggleCheck


func _ready() -> void:
	player_bar_toggle_check.button_pressed = SettingsManager.player_bar_numbers_enabled
	player_bar_toggle_check.toggled.connect(_on_player_bar_enabled)


func _on_player_bar_enabled(enabled : bool) -> void:
	SettingsManager.player_bar_numbers_enabled = enabled
	SettingsManager.save_settings()
	player_bars.bar_label_visibility_toggle(enabled)

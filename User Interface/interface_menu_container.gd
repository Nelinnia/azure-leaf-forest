class_name InterfaceMenu
extends PanelContainer


@onready var player_bars: PlayerBars = %PlayerBars
@onready var player_ui: Control = $"../.."



@onready var player_bar_toggle_check: CheckButton = %PlayerBarToggleCheck
@onready var ui_scale_slider: HSlider = %UIScaleSlider


func _ready() -> void:
	player_bar_toggle_check.button_pressed = SettingsManager.player_bar_numbers_enabled
	player_bar_toggle_check.toggled.connect(_on_player_bar_enabled)
	
	ui_scale_slider.value = SettingsManager.ui_scale
	ui_scale_slider.value_changed.connect(_on_scale_UI)



func _on_player_bar_enabled(enabled : bool) -> void:
	SettingsManager.player_bar_numbers_enabled = enabled
	SettingsManager.save_settings()
	player_bars.bar_label_visibility_toggle(enabled)


func _on_scale_UI(value: float) -> void:
	SettingsManager.ui_scale = value
	SettingsManager.save_settings()
	apply_UI_scale(value)
	
func apply_UI_scale(value: float) -> void:
	player_ui.pivot_offset = player_ui.size / 2.0
	player_ui.scale = Vector2(value, value)

class_name StatControl
extends Control



# Strength stat nodes
@onready var str_decrease_button: TextureButton = $PanelContainer/VBoxContainer/StrengthGrid/STRDecreaseButton
@onready var str_stat_number_label: Label = $PanelContainer/VBoxContainer/StrengthGrid/STRStatNumberLabel
@onready var str_increase_button: TextureButton = $PanelContainer/VBoxContainer/StrengthGrid/STRIncreaseButton

# Dexterity stat nodes
@onready var dex_decrease_button: TextureButton = $PanelContainer/VBoxContainer/DexterityGrid/DEXDecreaseButton
@onready var dex_stat_number_label: Label = $PanelContainer/VBoxContainer/DexterityGrid/DEXStatNumberLabel
@onready var dex_increase_button: TextureButton = $PanelContainer/VBoxContainer/DexterityGrid/DEXIncreaseButton

# Agility stat nodes
@onready var agi_decrease_button: TextureButton = $PanelContainer/VBoxContainer/AgilityGrid/AGIDecreaseButton
@onready var agi_stat_number_label: Label = $PanelContainer/VBoxContainer/AgilityGrid/AGIStatNumberLabel
@onready var agi_increase_button: TextureButton = $PanelContainer/VBoxContainer/AgilityGrid/AGIIncreaseButton

# Wisdom stat nodes
@onready var wis_decrease_button: TextureButton = $PanelContainer/VBoxContainer/WisdomGrid/WISDecreaseButton
@onready var wis_stat_number_label: Label = $PanelContainer/VBoxContainer/WisdomGrid/WISStatNumberLabel
@onready var wis_increase_button: TextureButton = $PanelContainer/VBoxContainer/WisdomGrid/WISIncreaseButton


@onready var click_audio: AudioStreamPlayer2D = $ClickAudio

var _stat_labels :Dictionary= {}

func _ready() -> void:
	_stat_labels = {
		"strength": str_stat_number_label,
		"dexterity": dex_stat_number_label,
		"agility": agi_stat_number_label,
		"wisdom": wis_stat_number_label,
	}
	
	# find way to simplify?
	str_increase_button.pressed.connect(_on_button_press.bind("strength", 1))
	str_decrease_button.pressed.connect(_on_button_press.bind("strength", -1))
	dex_increase_button.pressed.connect(_on_button_press.bind("dexterity", 1))
	dex_decrease_button.pressed.connect(_on_button_press.bind("dexterity", -1))
	agi_increase_button.pressed.connect(_on_button_press.bind("agility", 1))
	agi_decrease_button.pressed.connect(_on_button_press.bind("agility", -1))
	wis_increase_button.pressed.connect(_on_button_press.bind("wisdom", 1))
	wis_decrease_button.pressed.connect(_on_button_press.bind("wisdom", -1))
	
	PlayerStats.stat_changed.connect(_on_stat_changed)
	
	for stat_name in _stat_labels.keys():
		_update_label(stat_name, PlayerStats.get(stat_name))
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("stat_panel"):
		visible = !visible

func _on_button_press(stat_name: String, amount: int) -> void:
	click_audio.play()
	PlayerStats.change_stat(stat_name, amount)

func _on_stat_changed(stat_name: String, new_value: int) -> void:
	_update_label(stat_name, new_value)

func _update_label(stat_name: String, value: int) -> void:
	if _stat_labels.has(stat_name):
		_stat_labels[stat_name].text = str(value)

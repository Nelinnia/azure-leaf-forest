class_name StatControl
extends Control



# Strength stat nodes
@onready var str_decrease_button: TextureButton = $VBoxContainer/StrengthGrid/STRDecreaseButton
@onready var str_stat_number_label: Label = $VBoxContainer/StrengthGrid/STRStatNumberLabel
@onready var str_increase_button: TextureButton = $VBoxContainer/StrengthGrid/STRIncreaseButton

# Dexterity stat nodes
@onready var dex_decrease_button: TextureButton = $VBoxContainer/DexterityGrid/DEXDecreaseButton
@onready var dex_stat_number_label: Label = $VBoxContainer/DexterityGrid/DEXStatNumberLabel
@onready var dex_increase_button: TextureButton = $VBoxContainer/DexterityGrid/DEXIncreaseButton

# Agility stat nodes
@onready var agi_decrease_button: TextureButton = $VBoxContainer/AgilityGrid/AGIDecreaseButton
@onready var agi_stat_number_label: Label = $VBoxContainer/AgilityGrid/AGIStatNumberLabel
@onready var agi_increase_button: TextureButton = $VBoxContainer/AgilityGrid/AGIIncreaseButton

# Wisdom stat nodes
@onready var wis_decrease_button: TextureButton = $VBoxContainer/WisdomGrid/WISDecreaseButton
@onready var wis_stat_number_label: Label = $VBoxContainer/WisdomGrid/WISStatNumberLabel
@onready var wis_increase_button: TextureButton = $VBoxContainer/WisdomGrid/WISIncreaseButton


var button_array :Array[Button]= []


func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("stat_panel"):
		visible = !visible

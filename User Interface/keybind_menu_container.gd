class_name KeybindMenu
extends PanelContainer



@onready var move_left_button: Button = %MoveLeftButton
@onready var move_right_button: Button = %MoveRightButton
@onready var jump_button: Button = %JumpButton
@onready var attack_button: Button = %AttackButton
@onready var weapon_swap_button: Button = %WeaponSwapButton
@onready var magic_active_button: Button = %MagicActiveButton
@onready var player_stats_button: Button = %PlayerStatsButton



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

class_name InteractArea
extends Area2D


@onready var interact_label: Label = $InteractLabel

@export var dialogue_start :DialogueLine

var player_in_range :bool= false



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(func(body: Node) -> void:
		if body is Player:
			player_in_range = true
			interact_label.visible = true
			interact_label.text = "Talk " + "(E)"
		)
	body_exited.connect(func(body: Node) -> void:
		if body is Player:
			player_in_range = false
			interact_label.visible = false
			if DialogueManager.dialogue_box.current_line == dialogue_start:
				DialogueManager.dialogue_box.close_dialogue()
		)


func _unhandled_input(event: InputEvent) -> void:
	if not player_in_range or not event.is_action_pressed("interact"):
		return
	
	if DialogueManager.dialogue_box.visible:
		return
	DialogueManager.dialogue_box.open_dialogue(dialogue_start)

class_name EventTrigger
extends Area2D


signal player_entered
signal player_exited

@export var once :bool= false  #used for one off triggers

var _has_fired :bool= false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node) -> void:
	if body is Player and not (once and _has_fired):
		_has_fired = true
		player_entered.emit()

func _on_body_exited(body: Node) -> void:
	if body is Player:
		player_exited.emit()

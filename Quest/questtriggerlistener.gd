class_name QuestTriggerListener
extends Node

@export var event_trigger :EventTrigger
@export var objective_type :String
@export var target_id :String

func _ready() -> void:
	event_trigger.player_entered.connect(func() -> void:
		QuestManager.report_progress(objective_type, target_id)
		)

extends  Node

signal quest_updated

var active_quests :Dictionary= {}


func start_quest(quest_resource: Quest) -> void:
	var progress := QuestProgress.new()
	progress.quest = quest_resource
	active_quests[quest_resource.quest_id] = progress
	quest_updated.emit()


func report_progress(objective_type: String, target_id: String, amount: int = 1) -> void:
	for quest_id in active_quests:
		var progress :QuestProgress= active_quests[quest_id]
		var stage :QuestStage= progress.quest.stages[progress.current_stage_index]
		
		if stage.objective_type == objective_type and stage.target_id == target_id:
			progress.current_amount += amount

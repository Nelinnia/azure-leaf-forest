extends Control


@onready var quest_list: VBoxContainer = $QuestList
@onready var quest_button_temp: Button = $QuestList/QuestButtonTemp

@onready var quest_detail_panel: VBoxContainer = $QuestDetailPanel
@onready var title_label: Label = $QuestDetailPanel/TitleLabel
@onready var objective_label: Label = $QuestDetailPanel/ObjectiveLabel
@onready var description_label: Label = $QuestDetailPanel/DescriptionLabel
@onready var back_button: Button = $QuestDetailPanel/BackButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	quest_button_temp.hide()
	quest_detail_panel.hide()
	QuestManager.quest_updated.connect(update_quest_list)
	back_button.pressed.connect(_on_back_button_pressed)
	update_quest_list()


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("quest_book"):
		visible = !visible

func update_quest_list() -> void:
	for child in quest_list.get_children():
		if child != quest_button_temp:
			child.queue_free()
	
	for quest_id in QuestManager.active_quests:
		add_quest_button(QuestManager.active_quests[quest_id])


func add_quest_button(progress: QuestProgress) -> void:
	var button := quest_button_temp.duplicate()
	button.text = progress.quest.title
	button.show()
	button.pressed.connect(_on_quest_button_pressed.bind(progress.quest.quest_id))
	quest_list.add_child(button)

func _on_quest_button_pressed(quest_id: String) -> void:
	show_quest_details(quest_id)

func show_quest_details(quest_id: String) -> void:
	var progress :QuestProgress= QuestManager.active_quests[quest_id]
	var stage :QuestStage= progress.quest.stages[progress.current_stage_index]
	
	title_label.text = progress.quest.title
	description_label.text = stage.description
	objective_label.text = "%s: %d / %d" % [stage.stage_name, progress.current_amount, stage.required_amount]
	
	quest_list.hide()
	quest_detail_panel.show()

func _on_back_button_pressed() -> void:
	quest_detail_panel.hide()
	quest_list.show()

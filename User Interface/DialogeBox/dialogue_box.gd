class_name  DialogueBox
extends Control



@onready var npc_name_label: Label = $NPCNameLabel
@onready var text_label: RichTextLabel = $PanelContainer/VBoxContainer/TextLabel
@onready var choice_list: VBoxContainer = $PanelContainer/VBoxContainer/ChoiceList
@onready var temp_button: Button = $PanelContainer/VBoxContainer/ChoiceList/TempButton
@onready var panel_container: PanelContainer = $PanelContainer


var current_line :DialogueLine
var current_page :int= 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DialogueManager.dialogue_box = self
	panel_container.gui_input.connect(_on_panel_container_input)
	temp_button.hide()
	hide()


func _on_panel_container_input(event: InputEvent) -> void:
	if not event.is_action_pressed("attack"):
		return
	if current_page < current_line.pages.size() - 1:
		current_page += 1
		show_page()


func open_dialogue(first_line: DialogueLine) -> void:
	show()
	show_line(first_line)

func show_line(line: DialogueLine) -> void:
	current_line = line
	current_page = 0
	npc_name_label.text = line.npc_name
	show_page()

func show_page() -> void:
	text_label.text = current_line.pages[current_page]
	
	var on_last_page := current_page == current_line.pages.size() - 1
	choice_list.visible = on_last_page
	if on_last_page:
		show_choices()
	
	
func show_choices() -> void:
	for child in choice_list.get_children():
		if child != temp_button:
			child.queue_free()
	
	for choice in current_line.choices:
		add_choice_button(choice.text, _on_choice_selected.bind(choice))
	
	if current_line.choices.is_empty():
		add_choice_button("...", close_dialogue)


func add_choice_button(button_text: String, on_pressed: Callable) -> void:
	var button := temp_button.duplicate()
	button.text = button_text
	button.show()
	button.pressed.connect(on_pressed)
	choice_list.add_child(button)


func _on_choice_selected(choice: DialogueChoice) -> void:
	print("Choice selected: ", choice.text)
	if choice.start_quest:
		print("Starting quest: ", choice.start_quest.title)
		QuestManager.start_quest(choice.start_quest)
	
	if choice.next_line:
		show_line(choice.next_line)
	else:
		close_dialogue()


func close_dialogue() -> void:
	hide()

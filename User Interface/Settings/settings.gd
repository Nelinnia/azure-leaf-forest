extends Control



@onready var graphics_texture_button: TextureButton = $GraphicsTextureButton
@onready var graphics_menu_container: PanelContainer = $GraphicsMenuContainer


@onready var sound_texture_button: TextureButton = $SoundTextureButton
@onready var sound_menu_container: PanelContainer = $SoundMenuContainer


@onready var interface_texture_button: TextureButton = $InterfaceTextureButton
@onready var interface_menu_container: InterfaceMenu = $InterfaceMenuContainer



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interface_texture_button.pressed.connect(_on_interface_button_pressed)
	sound_texture_button.pressed.connect(_on_sound_button_pressed)
	graphics_texture_button.pressed.connect(_on_graphic_button_pressed)


func _on_interface_button_pressed() -> void:
	interface_menu_container.visible = true
	_settings_button_pressed()
func _on_sound_button_pressed() -> void:
	sound_menu_container.visible = true
	_settings_button_pressed()
func _on_graphic_button_pressed() -> void:
	graphics_menu_container.visible = true
	_settings_button_pressed()

func _settings_button_pressed() -> void:
	pass


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("close_menu"):
		self.visible = !visible

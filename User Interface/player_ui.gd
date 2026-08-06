extends Control


@onready var click_audio: AudioStreamPlayer2D = $ClickAudio

@onready var graphics_texture_button: TextureButton = $Settings/GraphicsTextureButton
@onready var keybind_texture_button: TextureButton = $Settings/KeybindTextureButton
@onready var sound_texture_button: TextureButton = $Settings/SoundTextureButton
@onready var interface_texture_button: TextureButton = $Settings/InterfaceTextureButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	graphics_texture_button.pressed.connect(on_button_pressed)
	keybind_texture_button.pressed.connect(on_button_pressed)
	sound_texture_button.pressed.connect(on_button_pressed)
	interface_texture_button.pressed.connect(on_button_pressed)

func on_button_pressed() -> void:
	click_audio.play()

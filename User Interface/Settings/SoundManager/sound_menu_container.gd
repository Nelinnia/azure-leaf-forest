class_name  SoundOptionMenu
extends PanelContainer



@onready var master_sound_slider: HSlider = %MasterSoundSlider
@onready var master_sound_label: Label = $GridContainer/VBoxContainer/MasterSoundLabel

@onready var music_slider: HSlider = %MusicSlider
@onready var music_label: Label = $GridContainer/VBoxContainer/MusicLabel

@onready var sfx_slider: HSlider = %SfxSlider
@onready var sfx_label: Label = $GridContainer/VBoxContainer/SfxLabel

@onready var ambiance_slider: HSlider = %AmbianceSlider
@onready var ambiance_label: Label = $GridContainer/VBoxContainer/AmbianceLabel



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	master_sound_slider.value = SettingsManager.volume_master
	master_sound_slider.min_value = 0.0
	master_sound_slider.max_value = 1.0
	master_sound_slider.step = 0.05
	
	music_slider.value = SettingsManager.volume_music
	music_slider.min_value = 0.0
	music_slider.max_value = 1.0
	music_slider.step = 0.05
	
	sfx_slider.value = SettingsManager.volume_sfx
	sfx_slider.min_value = 0.0
	sfx_slider.max_value = 1.0
	sfx_slider.step = 0.05
	
	ambiance_slider.value = SettingsManager.volume_ambiance
	ambiance_slider.min_value = 0.0
	ambiance_slider.max_value = 1.0
	ambiance_slider.step = 0.05
	
	master_sound_slider.value_changed.connect(func(v): SettingsManager.set_volume("master", v); master_sound_label.text = "Master %d%%" % int(v * 100))
	music_slider.value_changed.connect(func(v): SettingsManager.set_volume("music", v); music_label.text = "Music %d%%" % int(v * 100))
	sfx_slider.value_changed.connect(func(v): SettingsManager.set_volume("sfx", v); sfx_label.text = "SFX %d%%" % int(v * 100))
	ambiance_slider.value_changed.connect(func(v): SettingsManager.set_volume("ambiance", v); ambiance_label.text = "Ambiance %d%%" % int(v * 100))

func _on_volume_changed(value: float) -> void:
	SettingsManager.set_volume("master", value)

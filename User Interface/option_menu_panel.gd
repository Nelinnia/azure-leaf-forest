class_name OptionMenu
extends PanelContainer

@onready var particle_toggle: CheckButton = %ParticleToggle
@onready var damage_toggle: CheckButton = %DamageToggle

@onready var master_vol_slider: HSlider = %MasterVolSlider
@onready var master_volume_label: Label = %MasterVolumeLabel

@onready var turret_vol_slider: HSlider = %TurretVolSlider
@onready var turret_volume_label: Label = %TurretVolumeLabel

@onready var ambiance_vol_slider: HSlider = %AmbianceVolSlider
@onready var ambiance_volume_label: Label = %AmbianceVolumeLabel

@onready var music_vol_slider: HSlider = %MusicVolSlider
@onready var music_volume_label: Label = %MusicVolumeLabel

@onready var menu_sound: AudioStreamPlayer2D = $MenuSound


static var particles_enabled :bool= true

var settingsmanager

func _ready() -> void:
	visible = false
	
	particle_toggle.button_pressed = SettingsManager.particles_enabled
	damage_toggle.button_pressed = SettingsManager.damage_text_enabled
	
	master_vol_slider.min_value = 0.0
	master_vol_slider.max_value = 1.0
	master_vol_slider.step = 0.05
	master_vol_slider.value = SettingsManager.volume_master
	
	turret_vol_slider.min_value = 0.0
	turret_vol_slider.max_value = 1.0
	turret_vol_slider.step = 0.05
	turret_vol_slider.value = SettingsManager.volume_turret
	
	ambiance_vol_slider.min_value = 0.0
	ambiance_vol_slider.max_value = 1.0
	ambiance_vol_slider.step = 0.05
	ambiance_vol_slider.value = SettingsManager.volume_ambiance
	
	music_vol_slider.min_value = 0.0
	music_vol_slider.max_value = 1.0
	music_vol_slider.step = 0.05
	music_vol_slider.value = SettingsManager.volume_music
	
	particle_toggle.toggled.connect(_on_particle_toggled)
	damage_toggle.toggled.connect(_on_damage_text_enabled)
	
	master_vol_slider.value_changed.connect(func(v): SettingsManager.set_volume("master", v) ;master_volume_label.text = "Master Volume: %d%%" % int(v * 100))
	turret_vol_slider.value_changed.connect(func(v): SettingsManager.set_volume("turrets", v) ;turret_volume_label.text = "Turret Volume: %d%%" % int(v * 100))
	ambiance_vol_slider.value_changed.connect(func(v): SettingsManager.set_volume("ambiance", v) ;ambiance_volume_label.text = "Ambiance Volume: %d%%" % int(v * 100))
	music_vol_slider.value_changed.connect(func(v): SettingsManager.set_volume("music", v) ;music_volume_label.text = "Music Volume: %d%%" % int(v * 100))
	#_on_particle_toggled(enabled)
	
	master_volume_label.text = "Master Volume: %d%%" % int(SettingsManager.volume_master * 100)
	turret_volume_label.text = "Turret Volume: %d%%" % int(SettingsManager.volume_turret * 100)
	ambiance_volume_label.text = "Ambiance Volume: %d%%" % int(SettingsManager.volume_ambiance * 100)
	music_volume_label.text = "Music Volume: %d%%" % int(SettingsManager.volume_music * 100)
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Menu"):
		visible = !visible
		menu_sound.play()


func _on_particle_toggled(enabled: bool) -> void:
	particles_enabled = enabled
	SettingsManager.particles_enabled = enabled
	SettingsManager.save_settings()
	get_tree().call_group("Turret_Particles", "set_emitting", enabled)

func _on_damage_text_enabled(enabled: bool) -> void:
	SettingsManager.damage_text_enabled = enabled

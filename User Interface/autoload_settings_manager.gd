extends Node

const SAVE_PATH = "user://settings.cfg"
var config := ConfigFile.new()

#Graphics variables
var particles_enabled :bool= true

var damage_text_enabled :bool = true

#Audio variables
var volume_master :float= 0.5 #starts at 50% volume
var volume_sfx :float= 1.0
var volume_ambiance :float= 1.0
var volume_music :float= 1.0

func _ready() -> void:
	load_settings()

func load_settings() -> void:
	if config.load(SAVE_PATH) != OK:
		return
		
		particles_enabled = config.get_value("graphics", "particles_enabled", true)
		volume_master = config.get_value("audio", "master", 1.0)
		volume_sfx = config.get_value("audio", "SFX", 1.0)
		volume_ambiance = config.get_value("audio", "ambiance", 1.0)
		volume_music = config.get_value("audio", "music", 1.0)
	_apply_volumes()

func save_settings() -> void:
	config.set_value("graphics", "particles_enabled", particles_enabled)
	config.set_value("audio", "master", volume_master)
	config.set_value("audio", "SFX", volume_sfx)
	config.set_value("audio", "ambiance", volume_ambiance)
	config.set_value("audio", "music", volume_music)
	config.save(SAVE_PATH)

func set_volume(bus_name: String, value: float) -> void:
	var linear :float= clamp(value, 0.0, 1.0)
	match bus_name:
		"master": volume_master = linear
		"SFX": volume_sfx = linear
		"ambiance": volume_ambiance = linear
		"music": volume_music = linear
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index(bus_name.capitalize()),
		linear_to_db(linear)
	)
	save_settings()

func _apply_volumes() -> void:
	set_volume("master", volume_master)
	set_volume("SFX", volume_sfx)
	set_volume("ambiance", volume_ambiance)
	set_volume("music", volume_music)


#func _on_particle_toggled(enabled: bool) -> void:
#	SettingsManager.particles_enabled = enabled
#	SettingsManager.save_settings()
#	get_tree().call_group("Turret_Particles", "set_emitting", enabled)
#
#func _on_damage_text_toggled(enabled: bool) -> void:
#	SettingsManager.damage_text_enabled = enabled
#	SettingsManager.save_settings()

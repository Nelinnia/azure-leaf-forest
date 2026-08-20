extends Node

const SAVE_PATH = "user://settings.cfg"
var config := ConfigFile.new()
 
#Interface variables
var player_bar_numbers_enabled :bool= true
var ui_scale :float= 1.0

#Graphics variables


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
	
	
	volume_master = config.get_value("audio", "master", 1.0)
	volume_sfx = config.get_value("audio", "sfx", 1.0)
	volume_ambiance = config.get_value("audio", "ambiance", 1.0)
	volume_music = config.get_value("audio", "music", 1.0)
	_apply_volumes()

func save_settings() -> void:
	#config.set_value("graphics", "particles_enabled", particles_enabled)
	config.set_value("interface", "player_bar_numbers_enabled", player_bar_numbers_enabled)
	config.set_value("interface", "ui_scale", ui_scale)
	config.set_value("audio", "master", volume_master)
	config.set_value("audio", "sfx", volume_sfx)
	config.set_value("audio", "ambiance", volume_ambiance)
	config.set_value("audio", "music", volume_music)
	config.save(SAVE_PATH)

func set_volume(bus_name: String, value: float) -> void:
	var linear :float= clamp(value, 0.0, 1.0)
	match bus_name:
		"master": volume_master = linear
		"sfx": volume_sfx = linear
		"ambiance": volume_ambiance = linear
		"music": volume_music = linear
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index(bus_name.capitalize()),
		linear_to_db(linear)
	)
	save_settings()

func _apply_volumes() -> void:
	set_volume("master", volume_master)
	set_volume("sfx", volume_sfx)
	set_volume("ambiance", volume_ambiance)
	set_volume("music", volume_music)

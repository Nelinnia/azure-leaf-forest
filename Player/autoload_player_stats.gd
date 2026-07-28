extends Node


signal stat_changed (stat_name: String, new_value: int)
signal skill_points_changed(new_value: int)
signal health_changed(current: int, max: int)
signal mana_changed(current: int, max: int)
signal xp_changed (current: int)
signal level_changed(current: int)

signal magic_activated(active: bool)

var is_magic_active :bool

var player_hp := 100
var max_player_hp := 100
var player_mana := 20
var max_player_mana := 20
var player_lv := 1
var player_xp := 0
var player_skill_points_available := 99


var strength :int= 1 #Increases sword damage, max height of base jumo
var dexterity :int= 1 #Increases bow damage, max height of double jump
var agility :int= 1 #Increases weapon charge rate, move speed
var wisdom :int= 1 #Increases magic damage,  mana


const MIN_STAT :int= 1
const MAX_STAT :int= 99


func change_stat(stat_name: String, amount: int) -> void:
	if amount > 0 and player_skill_points_available <= 0:
		return
		
	var current :int= get(stat_name)
	var new_value :int= clamp(get(stat_name) + amount, MIN_STAT, MAX_STAT)
	if new_value == current:
		return
	
	set(stat_name, new_value)
	stat_changed.emit(stat_name, new_value)
	
	var actual_change := new_value - current
	player_skill_points_available -= actual_change
	skill_points_changed.emit(player_skill_points_available)


func get_sword_damage_bonus() -> float:
	return strength * 3
func get_bow_damage_bonus() -> float:
	return dexterity * 2

func get_jump_bonus() -> float:
	return strength * 5.0 #base 200
func get_double_jump_bonus() -> float:
	return dexterity * 3.0 #base 120
func get_move_speed_bonus() -> float:
	return agility * 5   #base 480

func get_weapon_charge_rate_deduction() -> float:
	return agility * 0.05   #unsure, 1 agility = .05 seconds. change later mabey

func get_max_mana_increase() -> void:
	max_player_mana = 20 + (wisdom * 2)
	player_mana = clampi(player_mana, 0, max_player_mana)
	mana_changed.emit(player_mana, max_player_mana)
func set_mana(new_mana: int) -> void:
	player_mana = clampi(new_mana, 0, max_player_mana)
	mana_changed.emit(player_mana, max_player_mana)

func get_max_health_increase() -> void:
	max_player_hp = 100 + (player_lv * 2)
	player_hp = clampi(player_hp, 0, max_player_hp)
	health_changed.emit(player_hp, max_player_hp)
func set_hp(new_hp: int) -> void:
	player_hp = clampi(new_hp, 0, max_player_hp)
	health_changed.emit(player_hp, max_player_hp)

func add_xp(amount: int) -> void:
	player_xp += amount
	xp_changed.emit(player_xp)
	level_up()
func level_up() -> void:
	if player_xp >= 100:
		player_xp -= 100
		player_lv += 1
		level_changed.emit(player_lv)
		player_skill_points_available += 1
		skill_points_changed.emit(player_skill_points_available)
		xp_changed.emit(player_xp)
		get_max_health_increase()

func set_magic_active(active: bool) -> void:
	is_magic_active = active
	magic_activated.emit(active)

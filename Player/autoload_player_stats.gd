extends Node


signal stat_changed (stat_name: String, new_value: int)


var player_hp := 100
var player_mana := 10
var player_lv := 1
var player_xp := 0
var player_skill_points_available := 0


var strength :int= 1 #Increases sword damage, max height of base jumo
var dexterity  :int= 1 #Increases bow damage, max height of double jump
var agility :int= 1 #Increases weapon charge rate, move speed
var wisdom :int= 1 #Increases magic damage,  mana


const MIN_STAT  :int= 1
const MAX_STAT :int= 99


func change_stat(stat_name: String, amount: int) -> void:
	var new_value :int= clamp(get(stat_name) + amount, MIN_STAT, MAX_STAT)
	set(stat_name, new_value)
	stat_changed.emit(stat_name, new_value)

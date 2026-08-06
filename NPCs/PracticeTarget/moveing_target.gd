extends StandingTarget



@export_category("Path")
@export var path :Path2D= null :set= set_path
@export var start_at_end :bool= false
@export var back_and_forth :bool= true

@export_group("Movement")
@export var movement_speed :float= 16.0
@export var tween_trans_type :Tween.TransitionType= Tween.TRANS_SINE
@export var wave_height :float= 7.0


var curve_length :float= 1.0
var _tween :Tween= null




func set_path(value: Path2D) -> void:
	path = value
	
	if Engine.is_editor_hint():
		return
	
	if path == null or path.curve == null:
		return
	
	var start_offset := 1.0 if start_at_end else 0.0
	var end_offset := 0.0 if start_at_end else 1.0
	_interpolate_position(start_offset)
	curve_length = path.curve.get_baked_length()
	var duration := curve_length / movement_speed
	if _tween != null and _tween.is_valid():
		_tween.kill()
	_tween = create_tween().set_loops(0).set_process_mode(Tween.TWEEN_PROCESS_PHYSICS). set_trans(tween_trans_type)
	
	_tween.tween_method(_interpolate_position, start_offset, end_offset, duration)
	if back_and_forth:
		_tween.tween_method(_interpolate_position, end_offset, start_offset, duration)


func _interpolate_position(offset: float) -> void:
	var new_position := path.global_position + path.curve.sample_baked(offset * curve_length)
	new_position.y += sin(offset * TAU) * wave_height
	global_position = new_position

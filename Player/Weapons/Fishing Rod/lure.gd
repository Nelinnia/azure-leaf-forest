class_name Lure
extends Area2D

signal reeled_in

@onready var player :Player= null

@onready var bite_check_timer: Timer = $BiteCheckTimer
@onready var react_timer: Timer = $ReactTimer
@onready var fish_marker: Marker2D = $FishMarker

@onready var animation_player: AnimationPlayer = $AnimationPlayer



enum Lure_State {
	CASTING,
	GROUNDED,
	WATING,
	BITING,
	REELING
}

const GRAVITY :float= 800.0
const BITE_CHANCE :float= 0.2
const REACT_TIME :float= 1.0

var state :Lure_State= Lure_State.CASTING
var current_area :LureArea= null
var velocity :Vector2= Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)
	bite_check_timer.timeout.connect(_on_bite_check_timeout)
	react_timer.timeout.connect(_on_react_timeout)
	react_timer.one_shot = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if state == Lure_State.CASTING:
		velocity.y += GRAVITY * delta
		global_position += velocity * delta


func _on_area_entered(area: Area2D) -> void:
	if state == Lure_State.CASTING and area is LureArea:
		current_area = area
		_land_in_water()


func _on_body_entered(body: Node2D) -> void:
	if state == Lure_State.CASTING:
		_land_on_land()

func _land_in_water() -> void:
	state = Lure_State.WATING
	velocity = Vector2.ZERO
	_start_wait_timer()

func _land_on_land() -> void:
	state = Lure_State.GROUNDED
	velocity = Vector2.ZERO


const MIN_WAIT :float= 1.5
const MAX_WAIT :float= 4.0
func _start_wait_timer() -> void:
	bite_check_timer.wait_time = randf_range(MIN_WAIT, MAX_WAIT)
	bite_check_timer.start()

func _on_bite_check_timeout() -> void:
	if state != Lure_State.WATING:
		return
	if randf() < BITE_CHANCE:
		state = Lure_State.BITING
		animation_player.play("bob")
		react_timer.wait_time = REACT_TIME
		react_timer.start()
	else:
		_start_wait_timer()

func _on_react_timeout() -> void:
	if state != Lure_State.BITING:
		return
	state = Lure_State.WATING
	_start_wait_timer()


const REEL_DURATION :float= 0.3
func reel_in(target_pos: Vector2) -> void:
	if state == Lure_State.REELING:
		return
	
	var caught_fish := state == Lure_State.BITING #snapshot check (future learning)
	print("fish caught ", caught_fish)
	
	state = Lure_State.REELING
	bite_check_timer.stop()
	react_timer.stop()
	
	if caught_fish and current_area:
		pass
		var fish := current_area.catch()
		print("caught fish ", fish)
		if fish:
			_caught_fish(fish)
	
	var tween := create_tween()
	tween.tween_property(self, "global_position", target_pos, REEL_DURATION)
	tween.tween_callback(_reel_finished)
	



func _caught_fish(fish: FishItem) -> void:
	print("showing fish, ", fish.item_texture)
	var sprite := Sprite2D.new()
	sprite.texture = fish.item_texture
	fish_marker.add_child(sprite)
	fish.on_acquired(player)


func _reel_finished() -> void:
	reeled_in.emit()
	queue_free()

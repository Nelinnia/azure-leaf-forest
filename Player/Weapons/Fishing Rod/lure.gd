class_name Lure
extends Area2D

signal reeled_in

@onready var bite_check_timer: Timer = $BiteCheckTimer
@onready var react_timer: Timer = $ReactTimer

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
const REACT_TIME :float= 1

var state :Lure_State= Lure_State.CASTING
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
		react_timer.wait_time = REACT_TIME
		react_timer.start()
	else:
		animation_player.play("bob")
		_start_wait_timer()

func _on_react_timeout() -> void:
	if state != Lure_State.BITING:
		return
	state = Lure_State.WATING
	_start_wait_timer()


func reel_in() -> void:
	if state == Lure_State.REELING:
		return
	
	var caught_fish := state == Lure_State.BITING #snapshot check (future learning)
	
	state = Lure_State.REELING
	bite_check_timer.stop()
	react_timer.stop()
	
	if caught_fish:
		pass
	
	reeled_in.emit()
	queue_free()

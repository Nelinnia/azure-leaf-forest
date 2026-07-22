class_name Player
extends CharacterBody2D



@onready var hair_back: Sprite2D = %HairBack
@onready var player_parts: Node2D = %PlayerParts
@onready var right_arm: AnimatedSprite2D = %Right_Arm
@onready var left_arm: AnimatedSprite2D = %Left_Arm


#Quad every base value
@export var acceleration :float= 2800.0
@export var deceleration :float= 5600.0
@export var max_speed :float= 480.0

@export var max_fall_speed :float= 1000.0
@export var air_acceleration :float= 2000.0

const MAX_JUMPS :int= 2
var jump_count :int= 0

@export_category("Jump")
@export_range(10.0, 200.0) var jump_height :float= 200.0
@export_range(0.1, 1.5) var jump_time_to_peak :float= 0.37 #not quad
@export_range(0.1, 1.5) var jump_time_to_descent :float= 0.2 #not quad
@export_range(50.0, 200.0) var jump_horizontal_distance :float= 360.0
@export_range(5.0, 50.0) var jump_cut_divider :float= 15.0

@export_category("Double Jump")
@export_range(10.0, 200.0) var double_jump_height :float= 120.0
@export_range(0.1, 1.5) var double_jump_time_to_peak :float= 0.3 #not quad
@export_range(0.1, 1.5) var double_jump_time_to_descent :float= 0.25 #not quad

@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var attack_animation_player: AnimationPlayer = %AttackAnimationPlayer
@onready var visuals: Node2D = %Visuals

#player weapons
@onready var weapon_sword: WeaponSword = %Weapon
@onready var weapon_bow: WeaponBow = $WeaponBow

# Jumping variables
@onready var jump_speed := calculate_jump_speed(jump_height, jump_time_to_peak)
@onready var jump_gravity := calculate_jump_gravity(jump_height, jump_time_to_peak)
@onready var fall_gravity := calculate_fall_gravity(jump_height, jump_time_to_descent)
@onready var jump_horizontal_speed := calculate_jump_horizontal_speed(jump_horizontal_distance, jump_time_to_peak, jump_time_to_descent)

@onready var double_jump_speed := calculate_jump_speed(double_jump_height, double_jump_time_to_peak)
@onready var double_jump_gravity := calculate_jump_gravity(double_jump_height, double_jump_time_to_peak)
@onready var double_jump_fall_gravity := calculate_fall_gravity(double_jump_height, double_jump_time_to_descent)

@onready var coyote_timer := Timer.new()


enum Weapon_State {
	SWORD,
	BOW
}

var current_weapon_node :WeaponBase
var current_weapon :Weapon_State= Weapon_State.SWORD

enum State {
	GROUND,
	JUMP,
	DOUBLE_JUMP,
	FALL
}

var is_attacking :bool= false 
var current_state :State= State.GROUND
var direction_x :float= 0.0
var is_facing_left :bool= false
var current_gravity :float= 0.0

func _ready() -> void:
	_transition_to_state(current_state)
	weapon_sword.setup(self)
	weapon_bow.setup(self)
	current_weapon_node = weapon_sword
	_swap_weapon()
	coyote_timer.wait_time = 0.1
	coyote_timer.one_shot = true
	add_child(coyote_timer)
	attack_animation_player.animation_finished.connect(_on_attack_finished)

func _physics_process(delta: float) -> void:
	direction_x = signf(Input.get_axis("move_left", "move_right"))
	current_weapon_node.handle_process(delta)
	
	match current_state:
		State.GROUND:
			process_ground_state(delta)
		State.JUMP:
			process_jump_state(delta)
		State.FALL:
			process_fall_state(delta)
		State.DOUBLE_JUMP:
			process_double_jump_state(delta)
	
	velocity.y += current_gravity * delta
	velocity.y = minf(velocity.y, max_fall_speed)
	
	move_and_slide()



@onready var pips: Node2D = %Pips
@onready var charge_timer: Timer = %ChargeTimer
@onready var weapon_marker: Marker2D = $Visuals/Weapon/WeaponMarker
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("weapon_swap"):
		_swap_weapon()
	if event.is_action_pressed("attack") and not is_attacking:
		current_weapon_node.on_attack_pressed()
	if event.is_action_released("attack") and not is_attacking:
		current_weapon_node.on_attack_released()
func _start_attack() -> void:
	is_attacking = true
	var is_ground := current_state == State.GROUND
	var attack_anim := "sword_swing_ground" if is_ground else "sword_swing_air"
	attack_animation_player.play(attack_anim)
	left_arm.play(attack_anim)
	right_arm.play(attack_anim)
func _on_attack_finished(anim_name: StringName) -> void:
	if anim_name == "sword_swing_ground" or anim_name == "sword_swing_air":
		is_attacking = false
		weapon_marker.rotation = 0.0
		weapon_marker.position = Vector2.ZERO
		charge_timer.stop()


# handles the direction the player sprites are facing
func _update_facing(new_direction_x: float) -> void:
	if new_direction_x == 0.0:
		return #idle faces the direction the player stoped moving in
	is_facing_left = new_direction_x < 0.0
	
	visuals.scale.x = -1.0 if is_facing_left else 1.0

# Handles the node visibility for when the weapons are swapped
func _swap_weapon() -> void:
	current_weapon = Weapon_State.BOW if current_weapon == Weapon_State.SWORD else Weapon_State.SWORD
	current_weapon_node.deactivate()
	current_weapon_node = weapon_bow if current_weapon == Weapon_State.BOW else  weapon_sword
	current_weapon_node.activate()
	
	match  current_weapon:
		Weapon_State.SWORD:
			weapon_bow.visible = false
			left_arm.visible = true
			right_arm.visible = true
		Weapon_State.BOW:
			weapon_bow.visible = true
			left_arm.visible = false
			right_arm.visible = false


func process_ground_state(delta: float) -> void:
	var is_moving := absf(direction_x) > 0.0
	if is_moving:
		velocity.x += acceleration * direction_x * delta
		velocity.x = clampf(velocity.x, -max_speed, max_speed)
		
		_update_facing(direction_x)
		hair_back.visible = true
		animated_sprite.play("run")
		animation_player.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration * delta)
		
		hair_back.visible = true
		animated_sprite.play("idle")
		animation_player.play("idle")
	
	if Input.is_action_just_pressed("jump"):
		_transition_to_state(State.JUMP)
	elif not is_on_floor():
		_transition_to_state(State.FALL)

func process_jump_state(delta: float) -> void:
	if direction_x != 0:
		velocity.x += air_acceleration * direction_x * delta
		velocity.x = clampf(velocity.x, -jump_horizontal_speed, jump_horizontal_speed)
		_update_facing(direction_x)
	
	if Input.is_action_just_released("jump"):
		var jump_cut_speed := jump_speed / jump_cut_divider
		if velocity.y < 0.0 and velocity.y < jump_cut_speed:
			velocity.y = jump_cut_speed
	
	if velocity.y >= 0:
		_transition_to_state(State.FALL)
	elif  Input.is_action_just_pressed("jump"):
		_transition_to_state(State.DOUBLE_JUMP)

func process_fall_state(delta: float) -> void:
	if direction_x != 0.0:
		velocity.x += air_acceleration *  direction_x * delta
		velocity.x = clampf(velocity.x, -jump_horizontal_speed, jump_horizontal_speed)
		_update_facing(direction_x)
		animation_player.play("falling")
	
	if Input.is_action_just_pressed("jump"):
		if not coyote_timer.is_stopped():
			_transition_to_state( State.JUMP)
		elif jump_count < MAX_JUMPS:
			_transition_to_state(State.DOUBLE_JUMP)
	elif is_on_floor():
		_transition_to_state(State.GROUND)

func process_double_jump_state(delta: float) -> void:
	if direction_x != 0.0:
		velocity.x += air_acceleration * direction_x * delta
		velocity.x = clampf(velocity.x, -jump_horizontal_speed, jump_horizontal_speed)
		_update_facing(direction_x)
	
	if velocity.y >= 0.0:
		_transition_to_state(State.FALL)

func _transition_to_state(new_state: State) -> void:
	var previous_state := current_state
	
	match  previous_state:
		State.FALL:
			coyote_timer.stop()
	
	current_state = new_state
	
	match current_state:
		State.GROUND:
			jump_count = 0
			if previous_state == State.FALL:
				pass
		State.JUMP:
			velocity.y = jump_speed
			current_gravity = jump_gravity
			velocity.x = direction_x * jump_horizontal_speed
			animated_sprite.play("jump_anim")
			jump_count = 1
		State.FALL:
			animated_sprite.play("falling")
			animation_player.play("falling")
			hair_back.visible = false
			if jump_count == MAX_JUMPS:
				current_gravity = double_jump_fall_gravity
			else:
				current_gravity = fall_gravity
			
			if previous_state == State.GROUND:
				coyote_timer.start()
		State.DOUBLE_JUMP:
			velocity.y = double_jump_speed
			current_gravity = double_jump_gravity
			velocity.x = direction_x * jump_horizontal_speed
			animated_sprite.play("jump_anim")
			jump_count = MAX_JUMPS





func calculate_jump_speed(height: float, time_to_peak: float) -> float:
	return (-2.0 * height) / time_to_peak

func calculate_jump_gravity(height: float, time_to_peak: float) -> float:
	return (2.0 * height) / pow(time_to_peak, 2.0)

func calculate_fall_gravity(height: float, time_to_descent: float) -> float:
	return (2.0 * height) / pow(time_to_descent, 2.0)

func calculate_jump_horizontal_speed(distance: float, time_to_peak: float, time_to_descent: float) -> float:
	return distance / (time_to_peak + time_to_descent)

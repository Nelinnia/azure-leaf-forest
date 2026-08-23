class_name Rock
extends CharacterBody2D


@onready var boulder_sprite: Sprite2D = %BoulderSprite
@onready var hurt_box_collision: CollisionShape2D = %HurtBoxCollision



const KNOCKBACK_PER_DAMAGE :int= 8




func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += get_gravity().y * delta
	velocity.x = move_toward(velocity.x, 0.0 , 200.0 * delta)
	move_and_slide()
	_roll(delta)



func _roll(delta: float) -> void:
	if absf(velocity.x) > 1.0:
		boulder_sprite.rotation += velocity.x * 0.01 * delta

func take_damage(damage: int, player_position: Vector2 = global_position) -> void:
	if Player.instance:
		player_position = Player.instance.global_position
	
	var push_direction := signf(global_position.x - player_position.x)
	if push_direction == 0.0:
		push_direction = 1.0
	velocity.x = push_direction * damage * KNOCKBACK_PER_DAMAGE

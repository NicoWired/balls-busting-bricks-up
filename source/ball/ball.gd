class_name Ball
extends CharacterBody2D

const HEIGHT: int = 6
const WIDTH: int = 6
const SPEED: int = 120
const STARTING_ANGLE: float = deg_to_rad(315)
const MIN_Y_ANGLE: float = deg_to_rad(20)
const PADDLE_X_FACTOR: float = 0.3
const MAX_COLLISION_LOOP: int = 10

var speed_multiplier: float = 1.0
var frame_movement: Vector2
var collision: KinematicCollision2D
var on_hold: bool = true
var hold_position: Marker2D
var collision_counter: int = 0

func _ready() -> void:
	velocity = Vector2.from_angle(STARTING_ANGLE) * SPEED

func _physics_process(delta: float) -> void:
	if on_hold:
		if hold_position:
			global_position = hold_position.global_position
	else:
		frame_movement = velocity * speed_multiplier * delta
		collision = move_and_collide(frame_movement)
		while collision:
			collision_counter += 1
			if collision.get_collider() is Brick:
				collision.get_collider().hit()
			elif collision.get_collider() is Paddle:
				velocity = add_paddle_speed(velocity, collision.get_collider().velocity.x)
			velocity = velocity.bounce(collision.get_normal())
			if collision.get_remainder().length() > 0.001:
				collision = move_and_collide(velocity.normalized() * collision.get_remainder().length())
			else:
				break
			if collision_counter > MAX_COLLISION_LOOP:
				break
		collision_counter = 0
		velocity = enforce_min_y(velocity)

func enforce_min_y(current_movement: Vector2) -> Vector2:
	var angle: float = atan2(absf(current_movement.y), absf(current_movement.x))
	var new_movement: Vector2
	if angle < MIN_Y_ANGLE:
		new_movement = Vector2(
			cos(MIN_Y_ANGLE) * current_movement.length() * signf(current_movement.x),
			sin(MIN_Y_ANGLE) * current_movement.length() * signf(current_movement.y)
			)
	else:
		new_movement = current_movement
	return new_movement

func add_paddle_speed(current_movement: Vector2, paddle_x: float) -> Vector2:
	var new_movement: Vector2
	var current_length: float = current_movement.length()
	current_movement.x += paddle_x * PADDLE_X_FACTOR
	new_movement = current_movement.normalized() * current_length
	return new_movement

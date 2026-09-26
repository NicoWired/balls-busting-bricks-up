class_name Ball
extends CharacterBody2D

const HEIGHT: int = 6
const WIDTH: int = 6
const SPEED: int = 120
const STARTING_ANGLE: float = deg_to_rad(315)
const MIN_Y_ANGLE: float = deg_to_rad(20)

var speed_multiplier: float = 1.0
var frame_movement: Vector2
var collision: KinematicCollision2D
var on_hold: bool = true
var hold_position: Marker2D

func _ready() -> void:
	velocity = Vector2.from_angle(STARTING_ANGLE) * SPEED

func _physics_process(delta: float) -> void:
	if on_hold:
		if hold_position:
			global_position = hold_position.global_position
	else:
		velocity = enforce_min_y(velocity)
		frame_movement = velocity * speed_multiplier * delta
		collision = move_and_collide(frame_movement)
		while collision:
			if collision.get_collider() is Brick:
				collision.get_collider().hit()
			velocity = velocity.bounce(collision.get_normal())
			velocity = enforce_min_y(velocity)
			if collision.get_remainder().length() > 0.001:
				collision = move_and_collide(velocity.normalized() * collision.get_remainder().length())
			else:
				break

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

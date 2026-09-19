class_name Paddle
extends CharacterBody2D

const SIDE_X: int = 4
const MID_X: int = 8
const HEIGHT: int = 6
const SPEED: int = 6000
const BALL_Y_OFFSET = -6

@onready var paddle_left: Sprite2D = $PaddleLeft
@onready var paddle_mid: Sprite2D = $PaddleMid
@onready var paddle_right: Sprite2D = $PaddleRight
@onready var paddle_collision: CollisionShape2D = $PaddleCollision
@onready var ball_spawn: Marker2D = $BallSpawn


func _ready() -> void:
	change_paddle_size(3)

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("left"):
		velocity.x = SPEED * delta * -1
	elif Input.is_action_pressed("right"):
		velocity.x = SPEED * delta
	else:
		velocity.x = 0
	move_and_slide()

func align_paddle() -> void:
	# reset all vertical positions
	paddle_left.position.y = 0
	paddle_mid.position.y = 0
	paddle_right.position.y = 0
	paddle_collision.position.y = 0

	# calculate the horizontal position of each piece based on the scale of the center piece
	@warning_ignore("integer_division")
	@warning_ignore("narrowing_conversion")
	var half_mid_paddle: int = (MID_X * paddle_mid.scale.x) / 2
	paddle_left.position.x = (SIDE_X + half_mid_paddle) * -1
	paddle_mid.position.x = (half_mid_paddle) * -1
	paddle_right.position.x = half_mid_paddle
	
	# update the collider to match the paddle
	var collider: RectangleShape2D = RectangleShape2D.new()
	collider.size = Vector2(paddle_left.texture.get_size().x + paddle_right.texture.get_size().x + paddle_mid.texture.get_size().x * paddle_mid.scale.x, HEIGHT)
	paddle_collision.shape = collider
	@warning_ignore("integer_division")
	paddle_collision.position.y += HEIGHT / 2
	
	# update the ball spawn marker
	ball_spawn.position.y = BALL_Y_OFFSET
	ball_spawn.position.x = (paddle_right.position.x + SIDE_X) / 2


func change_paddle_size(factor: int) -> void:
	paddle_mid.scale.x = factor
	align_paddle()

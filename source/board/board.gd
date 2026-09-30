class_name Board
extends CanvasLayer

signal life_lost
signal no_bricks_left
signal score_increase

const BRICK_LAYOUT: Vector2i = Vector2i(10,6)
const BRICK_Y_OFFSET: int = 32
const PADDLE_START_POS: Vector2i = Vector2i(80, 260)

var paddle: Paddle
var ball: Ball

@onready var bricks: Node2D = $Bricks
@onready var balls: Node2D = $Balls
@onready var death_area: Area2D = $DeathArea

func _ready() -> void:
	paddle = preload("res://source/paddle/paddle.tscn").instantiate()
	add_child(paddle)
	setup_walls()
	setup_death()

#func _process(_delta: float) -> void:
	#if Input.is_action_just_pressed("start"):
		#if ball.on_hold:
			#ball.on_hold = false

#region setup
func setup_board():
	setup_bricks()
	setup_paddle()
	setup_ball()

func setup_bricks() -> void:
	for brick in bricks.get_children():
		brick.queue_free()
	
	var brick_pos: Vector2i = Vector2i.ZERO
	brick_pos.y += BRICK_Y_OFFSET
	for y in range(1, BRICK_LAYOUT.y +1):
		for x in range(1, BRICK_LAYOUT.x +1):
			var brick: Brick = preload("res://source/brick/Brick.tscn").instantiate()
			brick.position = brick_pos
			brick.points = 1
			brick.got_hit.connect(_on_brick_hit)
			brick.tree_exited.connect(_on_brick_exited)
			bricks.add_child(brick)
			brick_pos.x = x * Brick.SIZE.x
			if y%2 == 0:
				brick.set_texture(1)
			else:
				brick.set_texture(2)
		brick_pos.x = 0
		brick_pos.y = (y * Brick.SIZE.y) + BRICK_Y_OFFSET

func setup_paddle() -> void:
	paddle.position = PADDLE_START_POS

func setup_walls() -> void:
	var left_wall: Wall = preload("res://source/walls/wall.tscn").instantiate()
	var right_wall: Wall = preload("res://source/walls/wall.tscn").instantiate()
	var ceiling: Wall = preload("res://source/walls/wall.tscn").instantiate()
	
	var window_size: Vector2i = get_viewport().get_visible_rect().size
	
	add_child(left_wall)
	add_child(right_wall)
	add_child(ceiling)
	
	left_wall.set_shape(Vector2i.ZERO, Vector2i(0, window_size.y))
	right_wall.set_shape(Vector2i(window_size.x, 0), window_size)
	ceiling.set_shape(Vector2i.ZERO, Vector2i(window_size.x, 0))

func setup_ball() -> void:
	for child in balls.get_children():
		child.queue_free()
	ball = preload("res://source/ball/Ball.tscn").instantiate()
	ball.global_position = paddle.ball_spawn.global_position
	ball.hold_position = paddle.ball_spawn
	balls.add_child(ball)

func setup_death() -> void:
	death_area.body_entered.connect(_on_death_area_entered)

func reset_ball() -> void:
	ball.queue_free()
	call_deferred("setup_paddle")
	call_deferred("setup_ball")
#endregion setuph

func space_pressed() -> void:
	if ball.on_hold:
		ball.on_hold = false

func _on_brick_hit(hit_brick: Brick) -> void:
	score_increase.emit(hit_brick.points)
	hit_brick.queue_free()

func _on_death_area_entered(body) -> void:
	if body is Ball:
		life_lost.emit()

func _on_brick_exited() -> void:
	if len(bricks.get_children()) == 0:
		no_bricks_left.emit()

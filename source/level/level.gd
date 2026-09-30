class_name Level
extends Node

const MAX_LIFE: int = 3

var life: int = MAX_LIFE
var awaiting_restart: bool = false
var current_level: int = 0

var score: int = 0:
	set(value):
		score = value
		hud.set_score(score)

@onready var board: Board = $Board
@onready var hud: HUD = $HUD
@onready var menu: CanvasLayer = $Menu
@onready var announcements: Announcements = $Announcements


func _ready() -> void:
	board.life_lost.connect(_on_life_lost)
	board.no_bricks_left.connect(_on_no_bricks_left)
	board.score_increase.connect(_on_score_increase)
	start_level()


func _process(_delta: float) -> void:
	if Input.is_action_pressed("speedup") and not awaiting_restart:
		Engine.time_scale = 2
	else:
		Engine.time_scale = 1
	if Input.is_action_just_pressed("start"):
		if awaiting_restart:
			restart_level()
		else:
			board.space_pressed()
	if Input.is_action_just_pressed("debug"):
		_on_no_bricks_left()

func start_level() -> void:
	current_level += 1
	board.setup_board()
	hud.set_life(life)
	hud.set_score(score)

func restart_level() -> void:
	life = MAX_LIFE
	score = 0
	get_tree().paused = false
	announcements.visible = false
	awaiting_restart = false
	start_level()

func _on_life_lost() -> void:
	if life > 0:
		life -= 1
		hud.set_life(life)
		board.reset_ball()
	else:
		game_over()

func _on_score_increase(points: int) -> void:
	score += points

func _on_no_bricks_left() -> void:
	restart_level()
	announcements.next_level(current_level)

func game_over() -> void:
	awaiting_restart = true
	announcements.game_over()

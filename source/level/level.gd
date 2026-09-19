class_name Level
extends Node

const MAX_LIFE: int = 3

var life: int
var game_stoped: bool = false

var score: int = 0:
	set(value):
		score = value
		hud.set_score(score)

@onready var board: Board = $Board
@onready var hud: HUD = $HUD
@onready var menu: CanvasLayer = $Menu
@onready var announcements: Announcements = $Announcements


func _ready() -> void:
	life = MAX_LIFE
	board.life_lost.connect(_on_life_lost)
	board.no_bricks_left.connect(_on_no_bricks_left)
	board.score_increase.connect(_on_score_increase)
	hud.set_life(life)
	hud.set_score(score)

func _process(_delta: float) -> void:
	if game_stoped:
		Engine.time_scale = 0
	elif Input.is_action_pressed("speedup"):
		Engine.time_scale = 2
	else:
		Engine.time_scale = 1

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
	set_announcement("YOU WIN")

func game_over() -> void:
	set_announcement("GAME OVER")

func set_announcement(message: String) -> void:
	announcements.visible = true
	game_stoped = true
	announcements.set_label(message)

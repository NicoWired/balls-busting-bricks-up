class_name Announcements
extends CanvasLayer

@onready var next_level_timer: Timer = Timer.new()
@onready var main_label: Label = $LabelsContainer/MainLabel
@onready var bottom_label: Label = $LabelsContainer/BottomLabel

func _ready() -> void:
	next_level_timer.timeout.connect(_next_level_timeout)
	next_level_timer.autostart = false
	next_level_timer.one_shot = true
	add_child(next_level_timer)

func set_label(message: String) -> void:
	main_label.text = message

func game_over() -> void:
	visible = true
	get_tree().paused = true
	main_label.text = "GAME OVER"
	bottom_label.text =  "PRESS SPACE TO PLAY AGAIN"

func next_level(level: int) -> void:
	visible = true
	main_label.text = "LEVEL %s" % str(level)
	bottom_label.text = ""
	get_tree().paused = true
	
	next_level_timer.wait_time = 1
	next_level_timer.start()

func _next_level_timeout() -> void:
	visible = false
	get_tree().paused = false

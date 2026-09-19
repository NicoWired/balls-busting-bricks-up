class_name HUD
extends CanvasLayer

@onready var score: Label = $HUDContainer/FullContainer/TopContainer/Score
@onready var lives: Label = $HUDContainer/FullContainer/TopContainer/Lives

func set_score(new_score: int) -> void:
	score.text = str(new_score)

func set_life(new_life: int) -> void:
	lives.text = str(new_life)

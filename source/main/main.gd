class_name Main
extends Node

@onready var menu: CanvasLayer = $Menu


func _ready() -> void:
	var level: Level = preload("res://source/level/Level.tscn").instantiate()
	add_child(level)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("menu"):
		menu.visible = not menu.visible

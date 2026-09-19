class_name Main
extends Node


func _ready() -> void:
	var level: Level = preload("res://source/level/Level.tscn").instantiate()
	add_child(level)

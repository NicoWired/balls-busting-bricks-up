class_name Announcements
extends CanvasLayer

@onready var label: Label = $CenterContainer/Label


func set_label(message: String) -> void:
	label.text = message

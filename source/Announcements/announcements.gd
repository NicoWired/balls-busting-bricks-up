class_name Announcements
extends CanvasLayer

@onready var main_label: Label = $LabelsContainer/MainLabel

func set_label(message: String) -> void:
	main_label.text = message

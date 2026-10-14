class_name PowerUp
extends Area2D

const SPEED: float = 100
const ALPHA_TWEEN_SPEED: float = 0.5

enum POWERUP_TYPE {
	MULTIBALL,
	EXTRALIFE
}

var powerup_type: POWERUP_TYPE = randi_range(0, POWERUP_TYPE.size() - 1) as POWERUP_TYPE

@onready var sprite: Sprite2D = $Sprite


func _ready() -> void:
	var alpha_tween: Tween = create_tween()
	alpha_tween.set_loops()
	alpha_tween.tween_property(sprite, "modulate", Color(1,1,1,0), ALPHA_TWEEN_SPEED)
	alpha_tween.tween_property(sprite, "modulate", Color(1,1,1,1), ALPHA_TWEEN_SPEED)
	alpha_tween.play()

func _physics_process(delta: float) -> void:
	position.y += SPEED * delta

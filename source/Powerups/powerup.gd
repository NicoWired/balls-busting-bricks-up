class_name PowerUp
extends Area2D

const SPEED: float = 100
const ALPHA_TWEEN_SPEED: float = 0.5

enum {
	MULTIBALL,
	EXTRALIFE
}

var powerup_types: Array[Dictionary] = [
	{"id": MULTIBALL, "weight": 3},
	{"id": EXTRALIFE, "weight": 1}
]

var powerup_type: int = _pick_powerup()

@onready var sprite: Sprite2D = $Sprite


func _ready() -> void:
	var alpha_tween: Tween = create_tween()
	alpha_tween.set_loops()
	alpha_tween.tween_property(sprite, "modulate", Color(1,1,1,0), ALPHA_TWEEN_SPEED)
	alpha_tween.tween_property(sprite, "modulate", Color(1,1,1,1), ALPHA_TWEEN_SPEED)
	alpha_tween.play()

func _physics_process(delta: float) -> void:
	position.y += SPEED * delta

func _pick_powerup() -> int:
	var total: int = 0
	for powerup in powerup_types:
		total += powerup["weight"]
	
	var choice: int = randi_range(1, total)
	var counter: int = 0
	for powerup in powerup_types:
		counter += powerup["weight"]
		if counter >= choice:
			return powerup["id"]
	
	return -1

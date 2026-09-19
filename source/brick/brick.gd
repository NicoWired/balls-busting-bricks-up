class_name Brick
extends StaticBody2D

signal got_hit

const SIZE: Vector2i = Vector2i(16,8)
const TEXTURES: Dictionary[int,Texture2D] = {
	1: preload("res://assets/bricks/brick2.png"),
	2: preload("res://assets/bricks/brick3.png")
}

var points: int = 0

@onready var brick_sprite: Sprite2D = $BrickSprite

func hit() -> void:
	got_hit.emit(self)

func set_texture(texture: int) -> void:
	assert(texture in TEXTURES, "Invalid texture")
	brick_sprite.texture = TEXTURES[texture]

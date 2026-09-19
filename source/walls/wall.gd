class_name Wall
extends StaticBody2D

@onready var wall_shape: CollisionShape2D = $WallShape


func set_shape(start: Vector2i, end: Vector2i):
	var shape: SegmentShape2D = SegmentShape2D.new()
	shape.a = start
	shape.b = end
	wall_shape.shape = shape
	

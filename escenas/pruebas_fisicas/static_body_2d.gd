@tool
extends StaticBody2D

@onready var col: CollisionShape2D = $CollisionShape2D
@onready var rect: ColorRect = $ColorRect

func _process(_delta):
	if col and col.shape is RectangleShape2D and rect:
		var s: Vector2 = col.shape.size
		rect.size = s
		rect.position = col.position - s / 2.0

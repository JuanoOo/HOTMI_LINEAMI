extends Camera2D

@export var player: CharacterBody2D
@export var targetOffset = Vector2.ZERO
var aimMult = 0.5
var mult = 0.25

var camSpeed = 10

func _process(delta: float) -> void:
	var center = get_viewport().get_visible_rect().size / 2 # creo que es el centro
	var mouseOffset = get_viewport().get_mouse_position() - center
	var multiplier = mult
	if Input.is_action_pressed("look"): multiplier = aimMult
	var playerPosition = player.global_position
	
	targetOffset = targetOffset.lerp(mouseOffset * multiplier, camSpeed * delta)
	global_position = playerPosition + targetOffset

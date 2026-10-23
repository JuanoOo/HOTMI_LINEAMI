extends CharacterBody2D
const SPEED = 300.0 #pixels | pixels per frame
const ACCELERATION = 10
const LERP_T = 30

@onready var topAnimation:AnimatedSprite2D = $Top
@onready var bottomAnimation:AnimatedSprite2D = $Bottom
@export var camera:Camera2D

signal disparo(origin, direction, speed, vel, exclusion)

var aim:CompressedTexture2D = load("res://sprites/mouseSprite.png")

func _ready() -> void:
	Input.set_custom_mouse_cursor(aim, Input.CURSOR_ARROW, Vector2(aim.get_width()*0.5, aim.get_height()*0.5))
	#Input.set_custom_mouse_cursor(null, Input.CURSOR_ARROW)

func _physics_process(delta: float) -> void:
	var targetVelocity = Input.get_vector("move_left", "move_right", "move_up", "move_down") * SPEED
	var newVel = lerp(velocity, targetVelocity, ACCELERATION * delta)
	
	if !("targetOffset" in camera):
		# apuntar en la dirección del movimiento
		topAnimation.rotation = lerp_angle(topAnimation.rotation, bottomAnimation.rotation, LERP_T * delta)
	else:
		topAnimation.rotation = camera.targetOffset.angle() #atan2 devuelve radianes así que hay que agregar 90 en radianes (1rad, creo)
	
	if Input.is_action_just_pressed("interactuar"):
		# disparar hacia targetOffset
		disparo.emit(position, camera.targetOffset, 5, velocity, [self])
	
	if velocity.length() < 5: # .length es la magnitud del vector
		topAnimation.play("idle")
		bottomAnimation.play("idle")
	else:
		bottomAnimation.rotation = lerp_angle(bottomAnimation.rotation, velocity.angle(), LERP_T * delta) # godot tiene lerp_angle() para interpolar y tomar el camino mas corto entre angulos 
		topAnimation.play("corriendo")
		bottomAnimation.play("corriendo")
	
	
	velocity = newVel
	move_and_slide()

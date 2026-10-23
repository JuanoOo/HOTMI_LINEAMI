extends CharacterBody2D
const SPEED = 300.0 #pixels | pixels per frame
const ACCELERATION = 10
const LERP_T = 30

@onready var topAnimation:AnimatedSprite2D = $Top
@onready var bottomAnimation:AnimatedSprite2D = $Bottom
@onready var collider: CollisionShape2D = $CollisionShape2D

var vivo = true

#signal disparo(origin, direction, speed, vel, exclusion)

func _physics_process(delta: float) -> void:
	var targetVelocity = Input.get_vector("move_left", "move_right", "move_up", "move_down") * SPEED
	if vivo:
		var newVel = lerp(velocity, targetVelocity, ACCELERATION * delta)
		topAnimation.rotation = lerp_angle(topAnimation.rotation, bottomAnimation.rotation, LERP_T * delta)
		
		if velocity.length() < 5: # .length() devuelve la magnitud del vector
			topAnimation.play("idle")
			bottomAnimation.play("idle")
		else:
			bottomAnimation.rotation = lerp_angle(bottomAnimation.rotation, velocity.angle(), LERP_T * delta) # godot tiene lerp_angle() para interpolar y tomar el camino mas corto entre angulos 
			topAnimation.play("corriendo")
			bottomAnimation.play("corriendo")
		
		velocity = newVel
		move_and_slide()

func morir():
	print("Muerto!")
	vivo = false
	collider.disabled = true
	topAnimation.play("idle")
	bottomAnimation.play("idle")

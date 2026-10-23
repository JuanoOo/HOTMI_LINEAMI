extends Node2D
# i nee mor bulles, i nee mor bulles

const MAX_DIST: float = 250000

@export var speed: float
@export var direction: Vector2
@export var velocity: Vector2 #velocidad adicional del personaje (no sirve creo)
@export var exclusion: Array #el blacklist del raycast se llama exclusion en gordot

@onready var tracer = $Tracer

var distance: float
var speedMult: float = 500.0
var ended = false

func _ready() -> void:
	speed = speed * speedMult

func _process(delta: float) -> void:
	if !ended:
		var space_state = get_world_2d().direct_space_state
		var movimiento = (direction + velocity).normalized() * speed * delta #se supone que le añado la velocidad del jugaor pero no se nota (creo q es por el lerp de la camara)
		var query = PhysicsRayQueryParameters2D.create(global_position, global_position + movimiento) #(from, to) ambos parametros son posiciones, no normalizar!
		query.collide_with_areas = true
		query.exclude = exclusion
		var result = space_state.intersect_ray(query)

		if result:#devuelve posición, normal, colliderID, collider, shape y rid(?)
			if "morir" in result.collider:
				result.collider.morir()
			position = result.position
			tracer.set_point_position(1, Vector2.ZERO)
			queue_free()
			ended = true
		else:
			# que no pase la distancia ni el tiempo limite.
			if distance > MAX_DIST:
				print("Exceeded max distance", distance)
				queue_free()
			tracer.set_point_position(1, direction.normalized() * speed * delta)
			distance += direction.length() * (speed * delta)
			position = position + direction.normalized() * (speed * delta)

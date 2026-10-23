extends Node2D

@onready var player: CharacterBody2D = $jacket

var bala_tscn = preload("res://escenas/bala/bala.tscn")

func _on_disparo(origin, direction, speed, velocity, exclusion):
	var nodo = bala_tscn.instantiate()
	nodo.position = origin
	nodo.direction = direction
	nodo.velocity = velocity
	nodo.speed = speed
	nodo.exclusion = exclusion
	$Balas.add_child(nodo)

func _ready() -> void:
	player.disparo.connect(_on_disparo)

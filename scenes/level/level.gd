extends Node2D

@onready var _animal_start_marker: Marker2D = $AnimalStartMarker

const _ANIMAL_SCENE: PackedScene = preload("res://scenes/animal/animal.tscn")

func _ready() -> void:
	create_animal_on_start_position()
	SignalsAutoload.on_game_ended.connect(create_animal_on_start_position)

func create_animal_on_start_position() -> void:
	var animal: Animal = _ANIMAL_SCENE.instantiate()
	animal.position = _animal_start_marker.position
	add_child(animal)

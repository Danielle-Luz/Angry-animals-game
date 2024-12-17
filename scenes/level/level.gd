extends Node2D

@onready var _animal_start_marker: Marker2D = $AnimalStartMarker

const _ANIMAL_SCENE: PackedScene = preload("res://scenes/animal/animal.tscn")
const _MAIN_SCENE = preload("res://scenes/main/main.tscn")

func _ready() -> void:
	create_animal_on_start_position()
	SignalsAutoload.on_game_ended.connect(create_animal_on_start_position)
	ScoreAutoload.cup_quantity = self.get_tree().get_nodes_in_group("cup").size()
	
func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("back")):
		self.navigate_to_main_scene()

func create_animal_on_start_position() -> void:
	var animal: Animal = _ANIMAL_SCENE.instantiate()
	animal.position = _animal_start_marker.position
	animal._animal_start_marker = self._animal_start_marker.position
	add_child(animal)
	
func store_score_on_file() -> void:
	ScoreAutoload.store_score_on_file()

func navigate_to_main_scene() -> void:
	self.get_tree().change_scene_to_packed(self._MAIN_SCENE)

extends TextureButton

@export var level: int
@export var score: int

@onready var _level_label: Label = $MarginContainer/VBoxContainer/LevelLabel
@onready var _score_label: Label = $MarginContainer/VBoxContainer/ScoreLabel
@onready var _animation_player: AnimationPlayer = $AnimationPlayer

var loaded_scene: PackedScene
const levels: Dictionary = {
	"1": "res://scenes/level/level_1.tscn", 
	"2": "res://scenes/level/level_2.tscn", 
	"3": "res://scenes/level/level_3.tscn"
}

func _ready() -> void:
	self._level_label.text = str(self.level)
	self._score_label.text = str(self.score)

func on_mouse_entered() -> void:
	self._animation_player.play("size_up")

func on_mouse_exited() -> void:
	self._animation_player.play("RESET")

func on_pressed() -> void:
	var scene_path: String = levels[self._level_label.text]
	self.loaded_scene = load(scene_path)
	self.get_tree().change_scene_to_packed(self.loaded_scene)

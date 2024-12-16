extends TextureButton

@export var level: int
@export var score: int

@onready var _level_label: Label = $MarginContainer/VBoxContainer/LevelLabel
@onready var _score_label: Label = $MarginContainer/VBoxContainer/ScoreLabel

func _ready() -> void:
	self._level_label.text = str(self.level)
	self._score_label.text = str(self.score)

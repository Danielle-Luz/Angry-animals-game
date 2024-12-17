extends Control

@onready var _score_label: Label = $MarginContainer/VBoxContainer/ScoreLabel
@onready var _tentatives_label: Label = $MarginContainer/VBoxContainer/TentativesLabel
@onready var _game_over_container: VBoxContainer = $MarginContainer/GameOverContainer
@onready var _game_over_music: AudioStreamPlayer = $GameOverMusic

const _MAIN_SCENE = preload("res://scenes/main/main.tscn")

func _ready() -> void:
	self.set_label_info()
	
	SignalsAutoload.on_tentative.connect(self.set_label_info)
	SignalsAutoload.on_hit_all_cups.connect(self.show_game_over_message)
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		self.go_to_main_screen()

func set_label_info() -> void:
	self._score_label.text = "Score: %d" % ScoreAutoload.current_score
	self._tentatives_label.text = "Attempts: %d" % ScoreAutoload.tentatives

func show_game_over_message() -> void:
	self._game_over_container.visible = true
	self._game_over_music.play()

func go_to_main_screen() -> void:
	self.get_tree().change_scene_to_packed(self._MAIN_SCENE)
	

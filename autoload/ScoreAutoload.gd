extends Node

const SCORE_FILE_PATH: String = "user://score.txt"

var current_score: int = 0
var cup_quantity: int
var level_scores: Dictionary = {"1": 0, "2": 0, "3": 0}
var tentatives: int = 0
var current_level_number: String

func _ready() -> void:
	self.level_scores = self.get_score_from_file()
	self.cup_quantity = self.get_tree().get_node_count_in_group("cup")

func increment_score() -> void:
	self.current_score += 1000
	
	if(self.current_score >= self.level_scores[current_level_number]):
		self.level_scores[current_level_number] = self.current_score
	
	check_hit_cups_quantity()

func reset_numbers() -> void:
	self.current_score = 0
	self.tentatives = 0

func store_score_on_file() -> void:
	var score_file: FileAccess = FileAccess.open(self.SCORE_FILE_PATH, FileAccess.WRITE)
	
	if score_file:
		score_file.store_string(JSON.stringify(self.level_scores))

func get_score_from_file() -> Dictionary:
	var score_file: FileAccess = FileAccess.open(self.SCORE_FILE_PATH, FileAccess.READ)

	if score_file && score_file.get_length() > 0:
		var score_as_json = score_file.get_as_text()
		return JSON.parse_string(score_as_json)

	return self.level_scores
	
func check_hit_cups_quantity() -> void:
	if self.cup_quantity == self.current_score:
		SignalsAutoload.on_hit_all_cups.emit()

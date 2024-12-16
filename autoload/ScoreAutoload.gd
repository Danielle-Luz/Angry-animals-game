extends Node

const SCORE_FILE_PATH: String = "user://score.txt"

var score: Dictionary = { "current_score": 0, "highest_score": 0}

func _ready() -> void:
	self.score = self.get_score_from_file()

func increment_score() -> void:
	self.score.current_score += 1

	if(self.score.current_score >= self.score.highest_score):
		self.score.highest_score = self.score.current_score

func store_score_on_file() -> void:
	var score_file: FileAccess = FileAccess.open(self.SCORE_FILE_PATH, FileAccess.WRITE)
	
	if score_file:
		score_file.store_string(JSON.stringify(self.score))

func get_score_from_file() -> Dictionary:
	var score_file: FileAccess = FileAccess.open(self.SCORE_FILE_PATH, FileAccess.READ)

	if score_file && score_file.get_length() > 0:
		var score_as_json = score_file.get_as_text()
		return JSON.parse_string(score_as_json)

	return self.score

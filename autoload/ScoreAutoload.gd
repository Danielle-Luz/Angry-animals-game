extends Node

const SCORE_FILE_PATH: String = "user://score.txt"

var current_score: int = 0
var score: Dictionary = { "highest_score": 0}
var tentatives: int = 0

func _ready() -> void:
	self.score = self.get_score_from_file()

func increment_score() -> void:
	self.current_score += 1

	if(self.current_score >= self.score.highest_score):
		self.score.highest_score = self.current_score
	print(self.score)

func store_score_on_file() -> void:
	var score_file: FileAccess = FileAccess.open(self.SCORE_FILE_PATH, FileAccess.WRITE)
	
	if score_file:
		score_file.store_string(JSON.stringify(self.score))
		print("score was stored")

func get_score_from_file() -> Dictionary:
	var score_file: FileAccess = FileAccess.open(self.SCORE_FILE_PATH, FileAccess.READ)
	print("get - file ", score_file)

	if score_file && score_file.get_length() > 0:
		print("get - info got from score file: ", score_file.get_as_text())
		print("get - info from score as json: ", JSON.parse_string(score_file.get_as_text()))
		
		var score_as_json = score_file.get_as_text()
		return JSON.parse_string(score_as_json)

	return self.score

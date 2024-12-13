extends RigidBody2D

class_name Animal

func _ready() -> void:
	SignalsAutoload.on_game_ended.connect(die)

func die() -> void:
	queue_free()

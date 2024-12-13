extends RigidBody2D

class_name Animal

func _physics_process(delta: float) -> void:
	pass

func die() -> void:
	queue_free()

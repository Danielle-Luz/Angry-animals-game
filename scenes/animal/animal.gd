extends RigidBody2D

class_name Animal

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("drag"):
		set_animal_position_by_mouse()
	elif Input.is_action_just_released("drag"):
		self.freeze = false

func set_animal_position_by_mouse() -> void:
	self.freeze = true
	self.position = get_global_mouse_position()

func die() -> void:
	self.queue_free()

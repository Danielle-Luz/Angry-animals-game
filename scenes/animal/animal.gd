extends RigidBody2D

class_name Animal

var _is_mouse_over: bool = false
var _was_mouse_holded: bool = false

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("drag") && (self._is_mouse_over || self._was_mouse_holded):
		set_animal_position_by_mouse()
	if Input.is_action_just_released("drag") && self._was_mouse_holded:
		self.freeze = false

func set_animal_position_by_mouse() -> void:
	self.freeze = true
	self.position = get_global_mouse_position()
	self._was_mouse_holded = true

func die() -> void:
	self.queue_free()

func on_mouse_entered() -> void:
	self._is_mouse_over = true

func on_mouse_exited() -> void:
	self._is_mouse_over = false

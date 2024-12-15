extends RigidBody2D

class_name Animal

var _is_mouse_over: bool = false
var _was_mouse_holded: bool = false
var _mouse_start_position: Vector2
var _animal_start_marker: Vector2

const _MAX_POSITION: Vector2 = Vector2(0, 60)
const _MIN_POSITION: Vector2 = Vector2(-60, 0)

@onready var _arrow: Sprite2D = $Arrow
@onready var _arrow_stretch_sound: AudioStreamPlayer2D = $ArrowStretchSound

func _ready() -> void:
	SignalsAutoload.on_drag_animal.connect(play_arrow_stretch_sound)

func _physics_process(delta: float) -> void:
	var is_animal_moving: bool = self.linear_velocity != Vector2.ZERO
	self.set_mouse_start_position()
	
	if (
		Input.is_action_pressed("drag") && 
		(self._is_mouse_over || self._was_mouse_holded) &&
		is_animal_moving == false
	):
		set_animal_position_by_mouse()
		SignalsAutoload.on_drag_animal.emit()

	if Input.is_action_just_released("drag") && self._was_mouse_holded:
		self.freeze = false

func set_animal_position_by_mouse() -> void:
	var new_animal_position: Vector2 = get_global_mouse_position()
	
	self.freeze = true

	self.position.x = clampf(
		new_animal_position.x, 
		self._animal_start_marker.x - 60, 
		self._animal_start_marker.x
	)
	
	self.position.y = clampf(
		new_animal_position.y, 
		self._animal_start_marker.y, 
		self._animal_start_marker.y + 60
	)
	
	self._was_mouse_holded = true
	self.set_arrow_angle()
	
func set_arrow_angle() -> void:
	var distance_from_mouse = self._animal_start_marker - self.position
	distance_from_mouse.x = abs(distance_from_mouse.x)
	var arrow_angle: float = distance_from_mouse.angle()
	self._arrow.rotation = arrow_angle
	
func play_arrow_stretch_sound() -> void:
	var is_dragging_animal = self.get_animal_moved_distance() > Vector2.ZERO
	self._arrow.visible = true
	
	if(is_dragging_animal && self._arrow_stretch_sound.playing == false):
		self._arrow_stretch_sound.position = self.position
		self._arrow_stretch_sound.play()

func die() -> void:
	self.queue_free()
	
func set_mouse_start_position() -> void:
	# sets the mouse start position, if it's the first time moving the bird, then it will be its position
	# otherwise, if the bird was already moved, it will be its previous position
	self._mouse_start_position = self.global_position if self._was_mouse_holded else get_global_mouse_position()
	
func get_animal_moved_distance() -> Vector2:
	var animal_start_position: Vector2 = self.position
	return self.position - self._mouse_start_position

func on_mouse_entered() -> void:
	self._is_mouse_over = true

func on_mouse_exited() -> void:
	self._is_mouse_over = false

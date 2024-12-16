extends RigidBody2D

class_name Animal

var _is_mouse_over: bool = false
var _was_mouse_holded: bool = false
var _was_wood_knocked: bool = false
var _mouse_start_position: Vector2
var _animal_start_marker: Vector2
var _arrow_default_scale: float

const _MAX_POSITION: Vector2 = Vector2(0, 60)
const _MIN_POSITION: Vector2 = Vector2(-60, 0)
const _IMPULSE_MULTIPLIER: float = 30.0
const _MAX_ARROW_SCALE: float = 0.435

@onready var _arrow: Sprite2D = $Arrow
@onready var _arrow_stretch_sound: AudioStreamPlayer2D = $ArrowStretchSound
@onready var _vanish_sound: AudioStreamPlayer2D = $VanishSound
@onready var _wood_knock_sound: AudioStreamPlayer2D = $WoodKnockSound

func _ready() -> void:
	SignalsAutoload.on_drag_animal.connect(self.play_arrow_stretch_sound)
	self._arrow_default_scale = self._arrow.scale.x

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
		self.apply_impulse(self.get_impulse())
		
	if is_animal_moving && self._arrow.visible:
		self._arrow.visible = false

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
	var distance_from_mouse = self.get_animal_moved_distance()
	distance_from_mouse.x = abs(distance_from_mouse.x)
	var arrow_angle: float = distance_from_mouse.angle()
	self._arrow.rotation = arrow_angle
	
func play_arrow_stretch_sound() -> void:
	var distance_from_mouse: Vector2 = self.position - self._mouse_start_position
	var is_dragging_animal = distance_from_mouse > Vector2.ZERO
	self._arrow.visible = true
	
	if(is_dragging_animal && self._arrow_stretch_sound.playing == false):
		self._arrow_stretch_sound.position = self.position
		self._arrow_stretch_sound.play()
		
	self.scale_arrow()

func get_impulse() -> Vector2:
	return self.get_animal_moved_distance() * self._IMPULSE_MULTIPLIER

func die() -> void:
	self.queue_free()
	SignalsAutoload.on_game_ended.emit()
	
func set_mouse_start_position() -> void:
	# sets the mouse start position, if it's the first time moving the bird, then it will be its position
	# otherwise, if the bird was already moved, it will be its previous position
	self._mouse_start_position = self.global_position if self._was_mouse_holded else get_global_mouse_position()
	
func get_animal_moved_distance() -> Vector2:
	return self._animal_start_marker - self.position

func scale_arrow() -> void:
	var max_distance_length: float = (self._MAX_POSITION - self._MIN_POSITION).length()
	var streched_percentage_from_max_distance: float = self.get_animal_moved_distance().length() / max_distance_length
	var clamped_arrow_x_scale = clampf(
		self._arrow_default_scale + streched_percentage_from_max_distance, 
		self._arrow_default_scale, 
		self._MAX_ARROW_SCALE
	)
	self._arrow.scale.x = clamped_arrow_x_scale

func on_mouse_entered() -> void:
	self._is_mouse_over = true

func on_mouse_exited() -> void:
	self._is_mouse_over = false

func on_sleeping_state_changed() -> void:
	if self.sleeping:
		call_deferred("die")
		self._vanish_sound.position = self.position
		self._vanish_sound.play()

func _on_body_entered(body: Node) -> void:
	if self._wood_knock_sound.playing == false && self._was_wood_knocked == false:
		self._wood_knock_sound.play()
		self._was_wood_knocked = true

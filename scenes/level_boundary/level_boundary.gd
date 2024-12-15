extends Area2D

@onready var _collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export var _x: int
@export var _y: int

func _ready() -> void:
	self._collision_shape_2d.shape.normal.x = self._x
	self._collision_shape_2d.shape.normal.y = self._y

extends KinematicBody2D
class_name Actor

export var ACCELERATION = 500
export var MAX_SPEED = 80
export var ROLL_SPEED = 120
export var FRICTION = 500

const FLOOR_NORMAL: = Vector2.UP

export var speed: = Vector2(200.0, 0.0)
export var gravity: = 3500.0

var _velocity: = Vector2.ZERO


func _physics_process(delta: float) -> void:
	_velocity.y += gravity * delta

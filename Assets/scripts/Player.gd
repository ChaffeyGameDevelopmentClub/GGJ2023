extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const G := Vector2(0, 9.8)
export var speed := 300.0
var _velocity := Vector2.ZERO
var _input_vector = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#handle input events
func _input(event):
	pass
	
func _process(delta):
	_input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	_input_vector = _input_vector.normalized()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	_velocity.x = 0
	_velocity += G
	_velocity += _input_vector*speed
	move_and_slide(_velocity, Vector2.UP)

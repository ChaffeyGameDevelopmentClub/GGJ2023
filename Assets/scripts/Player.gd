extends LivingObject


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const G := Vector2(0, 9.8)
export var speed := 300.0
var _velocity := Vector2.ZERO
var _input_vector = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("on_killed", self, "on_player_killed")

# Called when the player is killed.	
func on_player_killed():
	print("Game OVER!")

#handle input events
func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_T:
			lower_health(10)

func _process(delta):
	_input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	_input_vector = _input_vector.normalized()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	_velocity.x = 0
	_velocity += G
	_velocity += _input_vector*speed
	move_and_slide(_velocity, Vector2.UP)
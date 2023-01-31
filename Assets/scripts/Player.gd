# Represents the Player object.

extends LivingObject

# Declare member variables here. 
export var gravity = 8
export var speed := 300.0
export var fallMultiplier := 2
export var lowJumpMultiplier := 10
export var jumpVelocity := 400
export var jump_vector := Vector2(0, -300)
var _velocity := Vector2.ZERO
var _input_vector = Vector2.ZERO
var seed_planter : SeedPlanter
var last_collision : KinematicCollision2D
var can_plant_seed := false

# Called when the node enters the scene tree for the first time.
func _ready():
# warning-ignore:return_value_discarded
	connect("on_killed", self, "_on_player_killed")
	seed_planter = get_node("SeedPlanter")
	var model = PlatformTreeSeed.new()
	seed_planter.set_seed_model(model)

# Called when the player is killed.	
func _on_player_killed() -> void:
	print("Game OVER!")

#handle input events
func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_T:
			seed_planter.plant_seed()
			#lower_health(10)

func _process(_delta):
	_input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	_input_vector = _input_vector.normalized()
	_velocity.y += gravity
	if _velocity.y > 0:
		_velocity +=  Vector2.UP * (fallMultiplier) * (-9.81)  
	elif Input.is_action_just_released("ui_select") and _velocity.y < 0:
		_velocity += Vector2.UP * (-9.81) * (lowJumpMultiplier)
	if is_on_floor():
		if Input.is_action_just_pressed("ui_accept"):
			_velocity = Vector2.UP * jumpVelocity
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	_velocity.x = 0
	_velocity.x += _input_vector.x*speed
	_velocity = move_and_slide(_velocity, Vector2(0,-1))

	last_collision = get_last_slide_collision()
	
	if last_collision != null:
		var collider = last_collision.collider
		if collider is TileMap:
			pass

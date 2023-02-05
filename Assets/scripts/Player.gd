# Represents the Player object.

extends LivingObject

signal grounded_updated(is_grounded)
# Declare member variables here. 
export var gravity = 8
export var speed := 300.0
export var fallMultiplier := 2
export var lowJumpMultiplier := 10
export var jumpVelocity := 400
export var jump_vector := Vector2(0, -300)
const _max_velocity = 130
var is_jumping = false
var is_grounded
var _velocity := Vector2.ZERO
var _input_vector = Vector2.ZERO

var seed_planter : SeedPlanter
var _last_collision : KinematicCollision2D
var _collision : KinematicCollision2D
var _tile_snap = Vector2.ZERO
var tile_map : TileMap
#True when you can plant seed
var can_plant_seed := false
var _has_friction := true
var player_state = PlayerState.IDLE
onready var player_tween := $PlayerTween
onready var tween_target := $TweenTarget

#Restart functions
onready var TransitionTween = $CanvasLayer/RestartTransition/Tween
onready var ColorTrans = $CanvasLayer/RestartTransition
signal restart_player
signal give_seed
signal ready_to_spawn

#Enumerated player states
enum PlayerState {
	IDLE,
	WALKING,
	JUMPING,
	FALLING,
	PLANTING
}

# Called when the node enters the scene tree for the first time.
func _ready():
# warning-ignore:return_value_discarded
	connect("on_killed", self, "_on_player_killed")
	seed_planter = get_node("SeedPlanter")
	var model = PlatformTreeSeed.new()
	seed_planter.set_seed_model(model)

# Called when the player is killed.	
func _on_player_killed() -> void:
	_restart()
	print("Game OVER!")

#handle input events
func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_T and can_plant_seed and player_state != PlayerState.PLANTING:
			if seed_planter.get_seed_model() is BridgeSeed:
				if can_plant_right():
					var new_snap = tile_map.world_to_map(_tile_snap)
					new_snap.x += 1
					new_snap = tile_map.map_to_world(new_snap)
					_tile_snap = new_snap
				elif can_plant_left():
					var new_snap = tile_map.world_to_map(_tile_snap)
					new_snap.x -= 3
					new_snap = tile_map.map_to_world(new_snap)
					_tile_snap = new_snap

				else:
					return
			bury()
			seed_planter.plant_seed()

func _process(_delta):
	if player_state != PlayerState.PLANTING:
		if Player.is_dead():
			_input_vector.x = 0
			animated_sprite.set_animation("death")
			return;

		match(player_state):
			PlayerState.IDLE:
				animated_sprite.set_animation("idle")
			PlayerState.WALKING:
				animated_sprite.set_animation("walking")
			PlayerState.JUMPING:
				animated_sprite.set_animation("jumping")
			PlayerState.FALLING:
				animated_sprite.set_animation("falling")
			_:
				pass
				#animated_sprite.set_animations("idle")

		if Input.is_action_just_pressed("CycleSeed"):
			seed_planter.cycle_seed()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if player_state != PlayerState.PLANTING:
		if _has_friction:
			_velocity.x = 0
		_velocity.x += _input_vector.x*speed
		_velocity.x = clamp(_velocity.x, -_max_velocity, _max_velocity)

		#_velocity = 
		_velocity = move_and_slide(_velocity, Vector2.UP)
		_update_animation_state()
		_handle_collisions()

		_input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		_input_vector = _input_vector.normalized()
		if _velocity.y > 0:
			_velocity +=  Vector2.UP * (fallMultiplier) * (-9.81)  
		elif Input.is_action_just_released("ui_select") and _velocity.y < 0:
			_velocity += Vector2.UP * (-9.81) * (lowJumpMultiplier)
		if is_on_floor():
			if Input.is_action_just_pressed("ui_accept"):
				_velocity = Vector2.UP * jumpVelocity
		
		if Input.is_action_just_pressed("Restart"): 
			_restart()
			
			
		_velocity.y += gravity
		
		var was_grounded = is_grounded
		is_grounded = is_on_floor()
		
		if was_grounded == null || is_grounded != was_grounded:
			emit_signal("grounded_updated", is_grounded)

func bury():
	if seed_planter.plant_occupies_tile():
		return

	if seed_planter.seed_power.get_value() > 0 and can_plant_seed and player_state != PlayerState.PLANTING: 
		player_state = PlayerState.PLANTING
		player_tween.interpolate_property(Player, "position", Player.global_position, tween_target.global_position, 0.5, Tween.TRANS_LINEAR)
		player_tween.interpolate_property(Player, "scale", Player.scale, Vector2(0.1, 0.1), 0.5, Tween.TRANS_LINEAR)
		player_tween.start()

func _restart():
	TransitionTween.interpolate_property(ColorTrans, "modulate:a", 0,1,1, Tween.TRANS_LINEAR ,Tween.EASE_IN)
	TransitionTween.start()
	yield(TransitionTween, "tween_completed")
	emit_signal("restart_player")
	TransitionTween.interpolate_property(ColorTrans, "modulate:a", 1,0,1, Tween.TRANS_LINEAR ,Tween.EASE_IN)
	TransitionTween.start()
		
func _handle_collisions():
	for i in get_slide_count():
		_collision = get_slide_collision(i)
		_check_ground_to_plant(_collision)
		_check_block_damage(_collision)
		_check_friction(_collision)
	if not is_on_floor():
			can_plant_seed = false

func _update_animation_state():
	if _velocity.y > 0:
		player_state = PlayerState.FALLING
		return
	elif _velocity.y < 0: 
		player_state = PlayerState.JUMPING
		return

	if abs(_velocity.x) > 0:
		player_state = PlayerState.WALKING
		if (_velocity.x > 0):
			animated_sprite.flip_h = false
		else:
			animated_sprite.flip_h = true
	else:
		player_state = PlayerState.IDLE

#Check the ground if we can plant a seed
func _check_ground_to_plant(collision : KinematicCollision2D) -> void:
	if collision != null:
		if collision.collider is CollisionTile:
			if is_on_floor():
				can_plant_seed = ( collision.collider.plantable_dict[collision.collider.get_tile_id(collision.position)])
				
func _check_friction(collision : KinematicCollision2D):
	if collision != null:
		if collision.collider is SpawnablePlant:
			_has_friction = true	
		elif collision.collider is CollisionTile:
			_has_friction = (collision.collider.friction_dict[collision.collider.get_tile_id(collision.position)])

#Checks the damage of the given block that was collided with, and returns it
func _check_block_damage(collision : KinematicCollision2D) -> void:
	var damage = 0
	if collision != null:
		if collision.collider is CollisionTile:
			damage = collision.collider.tile_damage_dict[collision.collider.get_tile_id(collision.position)]
			if damage > 0:
				lower_health(damage)

func can_plant_right() -> bool:
	var snap_pos = Vector2(tile_map.world_to_map(_tile_snap))
	snap_pos.x += 1
	
	if not tile_map.get_cell(snap_pos.x, snap_pos.y) == tile_map.INVALID_CELL:
		return false

	snap_pos.x += 1

	if not tile_map.get_cell(snap_pos.x, snap_pos.y) == tile_map.INVALID_CELL:
		return false
	
	snap_pos.x += 1

	if not tile_map.get_cell(snap_pos.x, snap_pos.y) == tile_map.INVALID_CELL:
		return false
	
	return true

func can_plant_left() -> bool:
	var snap_pos = Vector2(tile_map.world_to_map(_tile_snap))
	snap_pos.x -= 1
	
	if not tile_map.get_cell(snap_pos.x, snap_pos.y) == tile_map.INVALID_CELL:
		return false

	snap_pos.x -= 1

	if not tile_map.get_cell(snap_pos.x, snap_pos.y) == tile_map.INVALID_CELL:
		return false
	
	snap_pos.x -= 1

	if not tile_map.get_cell(snap_pos.x, snap_pos.y) == tile_map.INVALID_CELL:
		return false
	
	return true
	

func update_tile_snap(var pos : Vector2):
	pos.x += 16 #adjust for half the width of a tile in pixels (16 px per tile)
	_tile_snap = pos

func get_tile_snap() -> Vector2:
	return _tile_snap

func _on_PlantTween_tween_all_completed():
	emit_signal("ready_to_spawn")

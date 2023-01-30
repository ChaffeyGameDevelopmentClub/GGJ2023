extends KinematicBody2D

class_name LivingObject

# The maximum value for health.
export var max_health := 100

# Can the health exceed max health, for example if the player drinks a health potion?
export var can_exceed_max_health := false

var health : ClampedInteger
var _has_died := false
var _is_initialized := false

# Called when this object runs out of health and is killed.
signal on_killed()


func _ready():
	health = ClampedInteger.new(0, max_health)
	set_health(max_health)
	_is_initialized = true


# Returns whether or not this object has run out of health and has died.
func is_dead() -> bool:
	return _has_died or health.get_value() <= 0

# Returns the current health of this object.
func get_health() -> int:
	return health.get_value()

# Raise health by an amount. 
# Returns the new health for convenience.
func raise_health(amount : int) -> int:
	return set_health(health.get_value() + amount)

# Lowers health by an amount. 
# Returns the new health for convenience.
func lower_health(amount : int) -> int:
	return set_health(health.get_value() - amount)

# Set the health to a new value. 
# Returns the new health for convenience.
func set_health(new_health : int) -> int:
	
	# Exit function if we're already dead.
	if _is_initialized and is_dead():
		return health.get_value()

	# Change health and fire signal.
	var old_health = health.get_value()
	health.set_value(new_health)

	# Exit function if no change was made.
	if health.get_value() == old_health:
		return health.get_value()

	print("Health for \"%s\" has been set to %s" % [name, health.get_value()])

	# Check if dead.
	if is_dead():
		_has_died = true
		print("\"%s\" has died" % name)
		emit_signal("on_killed")        

	return health.get_value()


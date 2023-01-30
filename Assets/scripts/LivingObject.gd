extends KinematicBody2D

class_name LivingObject

# The maximum value for _health.
export var max_health := 100

# Can the _health exceed max _health, for example if the player drinks a _health potion?
export var can_exceed_max_health := false

var _health := 0
var _has_died := false
var _is_initialized := false

# Called when this object runs out of _health and is killed.
signal on_killed()

# Called whenever the _health changes for this object.
signal on_health_changed(old_health, new_health)


func _ready():
    set_health(max_health)
    _is_initialized = true


# Returns whether or not this object has run out of _health and has died.
func is_dead() -> bool:
    return _has_died or _health <= 0

# Returns the current health of this object.
func get_health() -> int:
    return _health

# Raise _health by an amount. 
# Returns the new _health for convenience.
func raise_health(amount : int) -> int:
    return set_health(_health + amount)

# Lowers _health by an amount. 
# Returns the new health for convenience.
func lower_health(amount : int) -> int:
    return set_health(_health - amount)

# Set the health to a new value. 
# Returns the new health for convenience.
func set_health(new_health : int) -> int:
    
    # exit function if we're already dead.
    if _is_initialized and is_dead():
        return _health
        
    # make sure data is valid.
    if new_health < 0:
        new_health = 0
    elif not can_exceed_max_health and new_health > max_health:
        new_health = max_health

    # change _health and fire signal.
    var old_health = _health
    _health = new_health
    emit_signal("on_health_changed", old_health, _health)
    print("Health for \"%s\" has been set to %s" % [name, _health])

    # check if dead.
    if is_dead():
        _has_died = true
        print("\"%s\" has died" % name)
        emit_signal("on_killed")        

    return _health


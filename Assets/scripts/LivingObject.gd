extends KinematicBody2D

class_name LivingObject

# The maximum value for health.
export var max_health := 100

# Can the health exceed max health, for example if the player drinks a health potion?
export var can_exceed_max_health := false

var health := 0
var has_died := false
var initialized := false

# Called when this object runs out of health and is killed.
signal on_killed()

# Called whenever the health changes for this object.
signal on_health_changed(old_health, new_health)


func _ready():
    set_health(max_health)
    initialized = true


# Returns whether or not this object has run out of health and has died.
func is_dead() -> bool:
    return has_died or health <= 0

# Returns the current health of this object.
func get_health() -> int:
    return health

# Raise health by an amount. 
# Returns the new health for convenience.
func raise_health(amount : int) -> int:
    return set_health(health + amount)

# Lowers health by an amount. 
# Returns the new health for convenience.
func lower_health(amount : int) -> int:
    return set_health(health - amount)

# Set the health to a new value. 
# Returns the new health for convenience.
func set_health(new_health : int) -> int:
    
    # exit function if we're already dead.
    if initialized and is_dead():
        return health
        
    # make sure data is valid.
    if new_health < 0:
        new_health = 0
    elif not can_exceed_max_health and new_health > max_health:
        new_health = max_health

    # change health and fire signal.
    var old_health = health
    health = new_health
    emit_signal("on_health_changed", old_health, health)
    print("Health for \"%s\" has been set to %s" % [name, health])

    # check if dead.
    if is_dead():
        has_died = true
        print("\"%s\" has died" % name)
        emit_signal("on_killed")        

    return health


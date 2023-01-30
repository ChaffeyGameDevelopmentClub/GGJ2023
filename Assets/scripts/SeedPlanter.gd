extends Object
class_name SeedPlanter

# switch this to a ClampedInteger
export var max_seed_power := 3
var _seed_power := 0
var _seed_model : SeedModel

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

# Returns the current seed model.
func get_seed_model() -> SeedModel:
	return _seed_model

# Returns our current seed power.
func get_seed_power() -> int:
	return _seed_power

# Set's our seed power to a new value.
func set_seed_power(new_value : int) -> int:

	
	if new_value < 0:
		new_value = 0
	elif new_value > max_seed_power:
		new_value = max_seed_power

	
	return _seed_power
	


# Sets the seed model to a new seed model.
func set_seed_model(new_seed_model : SeedModel) -> void:
	_seed_model = new_seed_model
	print("Seed Model set to %s" % _seed_model.seed_name)

# Plant this seed.
func plant_seed():
	_seed_model._on_seed_planted()
# Controls all functionality related to planting seeds.

extends Object
class_name SeedPlanter

# The maximum seed power we can have.
export var _max_seed_power := 3

# Our current seed power.
var seed_power : ClampedInteger

# The current seed model used in this planter. When a seed is planted it will be this type. Do not get/set it directly.
var _seed_model : SeedModel

# Called when this planter runs out of seed power.
signal on_seed_power_depleted()

# Called when the node enters the scene tree for the first time.
func _init():
	seed_power = ClampedInteger.new(0, _max_seed_power)
	seed_power.connect("on_value_changed", self, "_check_for_depletion")
	seed_power.set_value(_max_seed_power)
	pass # Replace with function body.

# Returns the current seed model.
func get_seed_model() -> SeedModel:
	return _seed_model

# Sets the seed model to a new seed model.
func set_seed_model(new_seed_model : SeedModel) -> void:
	_seed_model = new_seed_model
	print("Seed Model set to %s" % _seed_model.seed_name)

# Plant this seed.
func plant_seed():
	_seed_model._on_seed_planted()

func _check_for_depletion(old_value, new_value):
	if seed_power.get_value() == seed_power._min_value:
		print("Seed power depleted!")
		emit_signal("on_seed_power_depleted")
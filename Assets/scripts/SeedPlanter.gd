# Controls all functionality related to planting seeds.

extends Node2D
class_name SeedPlanter



# The maximum seed power we can have.
export var _max_seed_power := 3

# Our current seed power.
var seed_power : ClampedInteger

# The current seed model used in this planter. When a seed is planted it will be this type. Do not get/set it directly.
var _seed_model : SeedModel

var seeds = [PlatformTreeSeed.new(), BouncyFlowerSeed.new()]
var _seed_index = 0

# Called when this planter runs out of seed power.
signal on_seed_power_depleted()
signal give_seed

# Called when the node enters the scene tree for the first time.
func _ready():
	seed_power = ClampedInteger.new(0, _max_seed_power)
	seed_power.connect("on_value_changed", self, "_check_for_depletion")
	seed_power.set_value(_max_seed_power)
	Player.connect("give_seed", self, "_seed_replenish")
	
	pass # Replace with function body.

func cycle_seed() -> void:
	_seed_index += 1
	_seed_index = 0 if _seed_index >= len(seeds) else _seed_index
	set_seed_model(seeds[_seed_index])

# Returns the current seed model.
func get_seed_model() -> SeedModel:
	return _seed_model

# Sets the seed model to a new seed model.
func set_seed_model(new_seed_model : SeedModel) -> void:
	if _seed_model != null && new_seed_model.seed_name == _seed_model.seed_name:
		return # Exit if the seed models are the same type.

	_seed_model = new_seed_model
	print("Seed Model set to %s" % _seed_model.seed_name)

# Returns whether or not we have enough seed power to plant the current seed model.
func can_plant_seed() -> bool:
	return _seed_model.seed_power_cost <= seed_power.get_value()

# Checks for depletion. Do not use.
func _check_for_depletion(_old_value, _new_value) -> void:
	if seed_power.get_value() != seed_power._min_value:
		return # Exit function if we still have seed power.

	print("Seed power depleted!")
	emit_signal("on_seed_power_depleted")

# Plant this seed.
func plant_seed() -> void:
	if not can_plant_seed():
		print("Can't plant seed, out of seed power")
		return # Exit if we can't plant a seed.

	var planted_object = _seed_model.spawn_plant()
	if planted_object == null:
		return

	add_child(planted_object)
	planted_object.position = Player._tile_snap
	planted_object.set_as_toplevel(true)
	
	seed_power.lower_value(_seed_model.seed_power_cost)

func _seed_replenish():
	seed_power.set_value(_max_seed_power)

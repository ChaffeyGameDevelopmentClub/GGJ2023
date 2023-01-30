# Controls all functionality related to planting seeds.

extends Node
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
func _ready():
	seed_power = ClampedInteger.new(0, _max_seed_power)
	seed_power.connect("on_value_changed", self, "_check_for_depletion")
	seed_power.set_value(_max_seed_power)
	pass # Replace with function body.

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
	
	# move planted object to the player's position.
	var player = get_parent()
	var player_sprite_radius = 32
	var current_position = player.get_position()
	var new_position = Vector2(current_position.x + planted_object.get_position().x, current_position.y + planted_object.get_position().y + player_sprite_radius)
	planted_object.set_position(new_position)

	_seed_model._on_seed_planted(planted_object)
	add_child(planted_object)
	seed_power.lower_value(_seed_model.seed_power_cost)

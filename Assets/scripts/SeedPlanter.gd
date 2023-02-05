# Controls all functionality related to planting seeds.

extends Node2D
class_name SeedPlanter



# The maximum seed power we can have.
export var _max_seed_power := 3

# Our current seed power.
var seed_power : ClampedInteger

# The current seed model used in this planter. When a seed is planted it will be this type. Do not get/set it directly.
var _seed_model : SeedModel

var seeds = [PlatformTreeSeed.new(), BouncyFlowerSeed.new(), BridgeSeed.new()]
var _seed_index = 0
onready var plant_tween = $PlantTween

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

	if plant_occupies_tile():
		return

	var planted_object = _seed_model.spawn_plant()
	if planted_object == null:
		return
		
	Player.add_child(planted_object)
	planted_object.position = Player.tween_target.global_position
	planted_object.scale = Vector2(0.1, 0.1)
	
	plant_tween.interpolate_property(planted_object, "position", planted_object.position, Player.get_tile_snap(), 0.5, Tween.TRANS_LINEAR)
	plant_tween.interpolate_property(planted_object, "scale", planted_object.scale, Vector2(1, 1), 0.5, Tween.TRANS_LINEAR)
	planted_object.set_as_toplevel(true)
	
	seed_power.lower_value(_seed_model.seed_power_cost)

func seed_replenish():
	seed_power.set_value(_max_seed_power)

func plant_occupies_tile() -> bool:
	#We check if any plants already exist on player's tile.
	for child in Player.get_children():
		if child is SpawnablePlant:
			if child.position == Player.get_tile_snap():
				return true
	return false


func _on_PlayerTween_tween_all_completed():
	if Player.player_state == Player.PlayerState.PLANTING:
		plant_tween.start()

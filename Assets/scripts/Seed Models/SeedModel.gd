# The base class for seeds. Do not use this directly, instead inherit it in other classes and define functionality there.

extends Object
class_name SeedModel

# The name of this seed.
var seed_name : String

# The asset path to the object to spawn when the seed is planted.
var plant_asset_path : String

# How much seed power it costs to plant this seed.
var seed_power_cost := 1

# Called when the seed is planted. Passes in the spawned plant. Must be overriden in derrived classes.
func _on_seed_planted(spawned_plant : Node) -> void:
	pass

# Spawn the plant
func spawn_plant() -> Node:
	if plant_asset_path == null or plant_asset_path == "":
		printerr("Can't spawn plant because plant_asset_path wasn't set for %s seed" % seed_name)
		return null

	var plant_scene = load(plant_asset_path)
	var plant = plant_scene.instance()
	return plant

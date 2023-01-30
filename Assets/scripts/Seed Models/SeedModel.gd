# The base class for seeds. Do not use this directly, instead inherit it in other classes and define functionality there.

extends Object
class_name SeedModel

# The name of this seed.
var seed_name : String

# How much seed power it costs to plant this seed.
var seed_power_cost := 1

# Called when the seed is planted. Must be overriden in derrived classes.
func _on_seed_planted() -> void:
	pass
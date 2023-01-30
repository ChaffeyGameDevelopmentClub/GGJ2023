# The base class for seeds. Do not use this directly, instead inherit it in other classes and define functionality there.

extends Object
class_name SeedModel

# The name of this seed.
var seed_name : String

# Called when the seed is planted. Must be overriden in derrived classes.
func _on_seed_planted() -> void:
	pass
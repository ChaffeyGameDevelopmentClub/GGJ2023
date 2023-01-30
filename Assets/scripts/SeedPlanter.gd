extends Object
class_name SeedPlanter

var _seed_model : SeedModel

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Returns the current seed model.
func get_seed_model() -> SeedModel:
	return _seed_model

# Sets the seed model to a new seed model.
func set_seed_model(new_seed_model : SeedModel) -> void:
	_seed_model = new_seed_model
	print("Seed Model set to %s" % _seed_model.seed_name)

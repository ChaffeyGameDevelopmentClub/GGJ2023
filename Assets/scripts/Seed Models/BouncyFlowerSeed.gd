# Represents a seed that, when planted, creates a bouncy flower that the player can jump on to go higher than a regular jump.

extends SeedModel
class_name BouncyFlowerSeed

func _init():
	seed_name = "Bouncy Flower"
	plant_asset_path = "res://Assets/scenes/Spawnable Plants/BouncyFlower.tscn" # todo

func _on_seed_planted(spawned_plant : Node) -> void:
	print("Planted %s seed" % seed_name)
	

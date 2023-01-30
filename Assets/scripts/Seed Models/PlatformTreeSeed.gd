# Represents a seed that, when planted, creates a platform tree that the player can jump on.

extends SeedModel
class_name PlatformTreeSeed

func _init():
	seed_name = "Platform Tree"
	plant_asset_path = "res://Assets/scenes/Spawnable Plants/PlatformTree.tscn"

func _on_seed_planted(spawned_plant : Node) -> void:
	print("Planted %s seed" % seed_name)
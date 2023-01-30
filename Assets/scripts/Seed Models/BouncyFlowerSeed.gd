# Represents a seed that, when planted, creates a bouncy flower that the player can jump on to go higher than a regular jump.

extends SeedModel
class_name BouncyFlowerSeed

func _init():
	seed_name = "Bouncy Flower"

func _on_seed_planted() -> void:
	# implement here
	pass
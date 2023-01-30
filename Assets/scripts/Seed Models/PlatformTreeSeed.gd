# Represents a seed that, when planted, creates a platform tree that the player can jump on.

extends SeedModel
class_name PlatformTreeSeed

func _init():
	seed_name = "Platform Tree"

func _on_seed_planted() -> void:
	# implement here
	pass
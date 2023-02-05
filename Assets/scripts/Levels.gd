extends Node

var levels = ["res://Assets/scenes/levels/Level1.tscn", "res://Assets/scenes/levels/Level2.tscn", "res://Assets/scenes/levels/Level3.tscn"]
var level_index = 0

func start_next_level():
	level_index += 0.5
	if level_index > len(levels)-1:
		return
	get_tree().change_scene(levels[level_index])

	

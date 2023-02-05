extends Node

var levels = ["res://Assets/scenes/levels/DebugLevel.tscn", "res://Assets/scenes/levels/DebugLevel.tscn", "res://Assets/scenes/levels/DebugLevel.tscn"]
var level_index = 0

func start_next_level():
	level_index += 0.5
	if level_index > len(levels)-1:
		return
	get_tree().change_scene(levels[level_index])

	

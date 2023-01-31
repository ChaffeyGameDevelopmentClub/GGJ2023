extends Node2D
class_name LevelBase

var start_time := 0.0
var level_state = LevelState.NotStarted

#Where the player spawns
onready var starting_point = $StartingPoint
#Where the player must go to complete the level
onready var ending_point = $EndingPoint

enum LevelState {
	NotStarted,
	Started,
	Paused,
	Ended
}

signal on_level_started
signal on_level_completed

func _ready():
	self.connect("on_level_started", self, "_on_level_started")

#Start the level
func start_level():
	emit_signal("on_level_started")

#Get time elapsed from the start of the level
func get_time_elapsed() -> float:
	if level_state == LevelState.Started:
		return OS.get_ticks_msec() - start_time
	else: 
		return 0.0

#Function that executes whenever the level is started
func _on_level_started():
	start_time = OS.get_ticks_msec

#When the player enters the ending point, the level is completed
func _on_Area2D_body_entered(body:Node):
	#if body is Player
	emit_signal("on_level_completed")

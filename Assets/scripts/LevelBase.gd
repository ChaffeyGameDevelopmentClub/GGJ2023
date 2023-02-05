"""
Levels should be an inherited scene of the LevelBase scene.
"""

extends Node2D
class_name LevelBase

export var level_name := ""
export var start_on_load := false
onready var checkpoint := $StartingPoint
onready var a2d = $EndingPoint/Area2D
var start_time := 0.0
var level_state = LevelState.NOT_STARTED

#Where the player must go to complete the level
onready var ending_point = $EndingPoint

enum LevelState {
	NOT_STARTED,
	STARTED,
	PAUSED,
	ENDED
}

signal on_level_started
signal on_level_completed

func _ready():
	Player.player_state = Player.PlayerState.PLANTING
	Player.visible = false
	Player.scale = Vector2(0.1, 0.1)

	self.connect("on_level_started", self, "_on_level_started")
	Player.connect("restart_player", self, "_level_restart")
	Player.connect("ready_to_spawn", self, "_setup_player_drop")
	Player.connect("on_checkpoint", self, "_set_active_checkpoint")
	
	if start_on_load:
		start_level()

#Start the level
func start_level():
	emit_signal("on_level_started")
	Player.player_state = Player.PlayerState.IDLE
	_set_active_checkpoint(checkpoint)
	level_state = LevelState.STARTED
	
	Player.visible = true
	_setup_player_drop()
	

func _set_active_checkpoint(_checkpoint):
	if 	Player.player_state != Player.PlayerState.PLANTING:
		if _checkpoint.active == false:
			_checkpoint.start_glow()
			_checkpoint.active = true
			Player.seed_planter.seed_replenish()
			checkpoint = _checkpoint


#Get time elapsed from the start of the level
func get_time_elapsed() -> float:
	if level_state == LevelState.STARTED:
		return OS.get_system_time_msecs() - start_time
	else: 
		return 0.0

func _setup_player_drop():
	Player.position = checkpoint.position
	Player.position.y -= 50
	Player.scale = Vector2(0.1, 0.1)

	Player.player_state = Player.PlayerState.IDLE
	Player.player_tween.interpolate_property(Player, "scale", Vector2(0.1, 0.1), Vector2(1, 1), 1, Tween.TRANS_LINEAR)
	Player.player_tween.start()


#Function that executes whenever the level is started
func _on_level_started():
	Player.position = checkpoint.position
	start_time = OS.get_system_time_msecs()

func _level_restart():
	Player.position = checkpoint.position
	Player.revive()
	for child in Player.get_children():
		if child is SpawnablePlant:
			child.queue_free()

	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.revive()
	Player.seed_planter.seed_replenish()

var ended = false
#When the player enters the ending point, the level is completed
func _on_Area2D_body_entered(body:Node):
	if body == Player and level_state != LevelState.ENDED and not ended:
		level_state = LevelState.ENDED
		ended = true
		_level_restart()
		Player.position = Vector2.ZERO
		emit_signal("on_level_completed")
		Levels.start_next_level()
		print("level %s completed"  % level_name)
		
func _process(delta):
	if Input.is_action_just_pressed("Born") and level_state == LevelState.NOT_STARTED:
		start_level()

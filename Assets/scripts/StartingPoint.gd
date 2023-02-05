extends Position2D

class_name StartingPoint
onready var sprite = $SpawnTree
onready var tween = $Tween

var active = false
signal checkpoint_reached

func _ready():
	self.connect("checkpoint_reached", Player, "_on_checkpoint")

func _on_Area2D_body_entered(body:Node):
	if body == Player:
		emit_signal("checkpoint_reached", self)

func start_glow():
	tween.interpolate_property(self.sprite, "modulate:r", 0, 255, 5, Tween.TRANS_LINEAR)
	tween.interpolate_property(self.sprite, "modulate:g", 0, 255, 5, Tween.TRANS_LINEAR)
	tween.interpolate_property(self.sprite, "modulate:b", 0, 255, 5, Tween.TRANS_LINEAR)
	tween.start()
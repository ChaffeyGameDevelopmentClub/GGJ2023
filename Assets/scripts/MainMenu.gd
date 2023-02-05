extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Player.label.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Player.position = Vector2(0, 0)
	if Input.is_action_just_pressed("start"):
		Player.label.visible = true
		Player.camera.current = true
		Player.position = Vector2(50, 0)
		Player.camera.position = Player.position
		#Player.position = Vector2.ZERO
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		get_tree().change_scene("res://Assets/scenes/levels/Level1.tscn")

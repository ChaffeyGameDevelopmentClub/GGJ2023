extends AnimatedSprite

onready var animation_player = $Area2D/Label3/AnimationPlayer

func _on_Area2D_body_entered(body:Node):
	if body == Player:
		Player.complete_game()
		animation_player.play("RESET")

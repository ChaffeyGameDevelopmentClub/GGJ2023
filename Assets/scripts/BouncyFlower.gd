extends AnimatedSprite


export var bouncyPower = 1
onready var hit_box = $HitBoxs
onready var bounce = $AudioStreamPlayer2D





#When a body enters the hit box of the flower then the body will get shoot up
func _on_HitBoxs_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body == Player:
		self.set_animation("bounce")
		bounce.play()
		
		#body._velocity = Vector2(0, 0)
		if body._velocity.y > 0:
			body._velocity.y *= -0.6*bouncyPower
			#body._velocity.y += 1
		#body._velocity.y += 

func _on_BouncyFlower_animation_finished():
	self.set_animation("idle")

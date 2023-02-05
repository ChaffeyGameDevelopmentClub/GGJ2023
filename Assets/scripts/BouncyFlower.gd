extends AnimatedSprite


export var BouncyPower = 1.5
onready var hit_box = $HitBoxs





#When a body enters the hit box of the flower then the body will get shoot up
func _on_HitBoxs_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body == Player:
		self.set_animation("bounce")
		
		#body._velocity = Vector2(0, 0)
		if body._velocity.y > 0:
			body._velocity.y *= -0.6
			#body._velocity.y += 1
		#body._velocity.y += 

func _on_BouncyFlower_animation_finished():
	self.set_animation("idle")

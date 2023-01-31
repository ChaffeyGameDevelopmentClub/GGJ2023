extends Sprite


export var BouncyPower = 1.5





#When a body enters the hit box of the flower then the body will get shoot up
func _on_HitBoxs_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	print(body)
	body._velocity =  Vector2(0, 0)
	body._velocity += body.jump_vector * BouncyPower

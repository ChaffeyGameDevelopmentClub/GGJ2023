extends LivingObject

class_name Enemy

var speed = 40
var dir_vector = Vector2.ZERO
var _velocity = Vector2.ZERO
var pos_init := Vector2.ZERO
export var tile_move_distance = 3
onready var hit_box = $Hitbox
onready var hurt_box = $Hurtbox
onready var collider_1 = $CollisionShape2D
onready var collider_2 = $CollisionShape2D2
onready var sprite = $AnimatedSprite

var dead := false

func _ready():
	pos_init = self.global_position
	dir_vector = Vector2.LEFT

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	_velocity = speed*dir_vector
	move_and_slide(_velocity)

	if (pos_init.x - global_position.x) > tile_move_distance*32:
		dir_vector = Vector2.RIGHT
		sprite.flip_h = true
	elif (pos_init.x - global_position.x) < 5:
		dir_vector = Vector2.LEFT
		sprite.flip_h = false



func _on_Hurtbox_body_entered(body:Node):
	if body == Player:
		self.visible = false
		dead = true

func revive():
	self.visible = true
	dead = false

func _on_Hitbox_body_entered(body:Node):
	if body == Player and not dead:
		Player.lower_health(100)

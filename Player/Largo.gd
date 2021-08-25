extends Actor
export var damage: = 2
export var score:= 100
export var health:= 5

func _ready():
	set_physics_process(false)
	_velocity.x = -speed.x

func _on_StompDetector_body_entered(body):
	var player = "Player"
	if (body.name == player):
		if (body._velocity.y > 10) and !body.is_on_floor():
			take_damage(body)
		else:
			body.take_damage(self)

	
func _physics_process(delta):
	_velocity.y += gravity * delta
	if is_on_wall():
		_velocity.x *=-1.0
	_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y

func die():
	queue_free()
	PlayerData.score += score
	
func take_damage(attacker):
	attacker.attack(self)
	if health <= 0:
		die()

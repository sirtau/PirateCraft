extends Actor

export (PackedScene) var bullet_scene
export var health:= 10
export var damage: = 3
export var times_can_jump:= 1
export var times_jumped:= 0
export var knockback_impulse:= 50.0
export var stomp_impulse: = 600.0
export var coins: = 0
var hurt = false
export var MOVE_SPEED:= 0.8
export var JUMP_SPEED:= 0.8


onready var state_machine = $AnimationTree.get("parameters/playback")
onready var hurt_timer = $hurtTimer
export var bounce_height: = 1000.0




func _physics_process(delta: float) -> void:
	var is_jump_interrupted: = Input.is_action_just_released("jump") and _velocity.y < 0.0
	var direction: = get_direction()
	animateChar(direction)

	if hurt:
		direction = hurt_react(direction)
	
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
	var snap: Vector2 = Vector2.DOWN * 10 if direction.y == 0.0 else Vector2.ZERO
	_velocity = move_and_slide_with_snap(
		_velocity, snap, FLOOR_NORMAL, true
	)


func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") * MOVE_SPEED - Input.get_action_strength("move_left") * MOVE_SPEED,
		-Input.get_action_strength("jump") * JUMP_SPEED if is_on_floor() and Input.is_action_just_pressed("jump") else 0.0
	)


func calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		speed: Vector2,
		is_jump_interrupted: bool
	) -> Vector2:
	var out: = linear_velocity
	out.x = speed.x * direction.x
	if direction.y != 0.0:
		out.y = speed.y * direction.y
	if is_jump_interrupted:
		out.y = 0.0
	return out

func knockback():
	_velocity = calculate_knockback_velocity(_velocity, stomp_impulse)
	print("knocked?")

func bounce():
	_velocity = calculate_stomp_velocity(_velocity, stomp_impulse)
	
func attack(target):
	target.health -= damage
	bounce()
	print("attacked")

func calculate_knockback_velocity(linear_velocity: Vector2, knockback_impulse: float) -> Vector2:
	var out: = linear_velocity
	out.x = knockback_impulse
	return out

func calculate_stomp_velocity(linear_velocity: Vector2, stomp_impulse: float) -> Vector2:
	var out: = linear_velocity
	out.y = -stomp_impulse
	return out
	
func jump():
	if is_on_floor():
		pass
		
func take_damage(attacker):
	health -= attacker.damage
	print("yo")
	hurt = true
	print(health)
	if (health <= 0):
		die()
	
func animateChar(direction):
	if hurt:
		state_machine.travel("Hurt")
	elif direction.x > 0:
		state_machine.travel("WalkRight")
	elif direction.x < 0:
		state_machine.travel("WalkLeft")
	elif Input.is_action_just_released("move_left"):
		state_machine.travel("IdleLeft")
	elif Input.is_action_just_released("move_right"):
		state_machine.travel("IdleRight")
	
	
func hurt_react(direction):
	hurt_timer.start()
	_on_hurtTimer_timeout()
	direction.y = -.9

	return direction
	

func get_coins(amount):
	coins += amount
	
	print(coins)

func die():
	PlayerData.deaths += 1
	print(PlayerData.deaths)
	queue_free()
	
	
func _on_MobTimer_timeout():
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.offset = randi()

	var bullet = bullet_scene.instance()
	add_child(bullet)

	var direction = mob_spawn_location.rotation + PI / 2

	bullet.position = mob_spawn_location.position

	direction += rand_range(-PI / 4, PI / 4)
	bullet.rotation = direction

	var velocity = Vector2(rand_range(bullet.min_speed, bullet.max_speed), 0)
	bullet.linear_velocity = velocity.rotated(direction)

# turning mob into bullets because I'm insane.



func _on_hurtTimer_timeout():
	hurt = false

extends Area2D

onready var anim_player: AnimationPlayer = get_node("AnimationPlayer")

export var score:= 10

func on_ready():
	anim_player.play("bounce")


func _on_Coin_body_entered(body):
	if body.name == "Player":
		body.get_coins(10)
		PlayerData.score += score
		anim_player.play("fade")
		yield(anim_player, "animation_finished")
		die()
		

func die():
	queue_free()
	

	

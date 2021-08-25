extends Control

onready var scene_tree: = get_tree()
onready var pause_overlay:= $PauseOverlay
onready var score: Label = $ScoreLabel
onready var pause_title: Label = $PauseOverlay/PausedText
var paused: = false setget set_paused

const MESSAGE_DIED: = "You died"

func _ready() -> void:
	PlayerData.connect("score_updated", self, "update_interface")
	PlayerData.connect("player_died", self, "_on_PlayerData_player_died")
	update_interface()
	
func _on_PlayerData_player_died() -> void:
	update_interface()
	self.paused = true
	print(MESSAGE_DIED)
	pause_title.text = MESSAGE_DIED
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		self.paused = not paused
		
func update_interface() -> void:
	score.text = "Score: %s\n Deaths: %s" % [PlayerData.score, PlayerData.deaths]
	

func set_paused(value: bool) -> void:
	paused = value
	scene_tree.paused = value
	pause_overlay.visible = value



#_PlayerData_player_died

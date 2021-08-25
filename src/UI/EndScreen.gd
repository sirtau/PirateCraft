extends Control

onready var label: Label = $ScoreLabel

func _ready() -> void:
	label.text = label.text % [PlayerData.score, PlayerData.deaths]


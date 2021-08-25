extends Button
tool

export(String, FILE) var next_scene_path = ""

func _on_PlayButton_button_up():
	get_tree().change_scene(next_scene_path)

func _get_configuration_warning():
	return "next_Scene_path must be set for the button to work" if next_scene_path == "" else ""

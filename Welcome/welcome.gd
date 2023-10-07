extends Control

func _ready():
	ConfigManager.read_config()

func _on_new_schedule_button_pressed():
	get_tree().change_scene_to_file(ConfigManager.NEW_SCHEDULE_SCENE_PATH)

func _on_modifychedule_button_pressed():
	pass # Replace with function body.

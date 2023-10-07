extends Control

func _ready():
	$Background/Foreground/HeaderLabel.set_text(ConfigManager.selected_movie)


func _on_back_button_pressed():
	get_tree().change_scene_to_file(GlobalManager.EDIT_SELECTED_SCHEDULE_PATH)


func _on_close_button_pressed():
	add_child(GlobalManager.confirm_quit_planner())

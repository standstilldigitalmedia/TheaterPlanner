extends Node


const CONFIG_PATH = "user://theater-planner.cfg"
const MY_CONFIRM_WINDOW_PATH = "res://MyConfirmWindow/my_confirm_window.tscn"
const MY_BUTTON_SCENE_PATH = "res://UI/Scenes/my_button.tscn"
const WELCOME_SCENE_PATH = "res://Welcome/welcome.tscn"
const EDIT_SELECTED_SCHEDULE_PATH = "res://EditSelectedSchedule/edit_selected_schedule.tscn"
const EDIT_SELECTED_MOVIE_PATH = "res://EditSelectedMovie/edit_selected_movie.tscn"

func create_confim_window(title, question, button_1_text, button_2_text):
	var confirm_window_scene = load(MY_CONFIRM_WINDOW_PATH)
	var confirm_window = confirm_window_scene.instantiate()
	confirm_window.set_confirm_box(title, question, button_1_text, button_2_text)
	return confirm_window

func quit_planner():
	get_tree().quit()

func confirm_quit_planner():
	var confirm_window = create_confim_window("Quit?", "Are you sure you wish to quit?", "Quit", "Cancel")
	confirm_window.button1.connect(quit_planner)
	
	return confirm_window
	#$Background/Foreground/SchedulesScrollContainer/SchedulesContainer.add_child(schedule_button)

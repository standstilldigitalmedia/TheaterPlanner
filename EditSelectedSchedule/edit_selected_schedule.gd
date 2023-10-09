extends Control

func on_movie_button_press(movie_name):
	ConfigManager.selected_movie = movie_name
	get_tree().change_scene_to_file(GlobalManager.EDIT_SELECTED_MOVIE_PATH)

func delete_all_movie_controls():
	for movie in $Background/Foreground/MovieButtonsScrollContainer/MovieButtonsContainer.get_children():
		movie.queue_free()
		
func on_delete_movie():
	ConfigManager.delete_selected_movie()
	spawn_movie_controls()
		
func on_confirm_delete_movie():
	var confirm = GlobalManager.create_confim_window("Delete " + ConfigManager.selected_movie + "?", "Are you sure you want to delete " + ConfigManager.selected_movie + " movie? This can not be undone.", "Delete", "cancel")
	confirm.button1.connect(on_delete_movie)
	add_child(confirm)
		
func on_movie_control_update():
	spawn_movie_controls()
	var confim = GlobalManager.create_confim_window("Updated", "Your record has been updated", "Ok", "Cancel")
	add_child(confim)
	
func on_showings():
	get_tree().change_scene_to_file(GlobalManager.EDIT_SHOWINGS_SCENE_PATH)
		
func spawn_movie_controls():
	delete_all_movie_controls()
	var data_obj = ConfigManager.get_schedule_movies()
	for movie in data_obj:
		var movie_name = movie["movie_name"]
		var movie_control_scene = load(GlobalManager.MOVIE_CONTROLS_PATH)
		var movie_control = movie_control_scene.instantiate()
		var priority = movie["priority"]
		var movie_color = movie["movie_color"]
		movie_control.set_values(movie_name, priority, movie_color)
		movie_control.update.connect(on_movie_control_update)
		movie_control.delete.connect(on_confirm_delete_movie)
		movie_control.showings.connect(on_showings)
		$Background/Foreground/MovieButtonsScrollContainer/MovieButtonsContainer.add_child(movie_control)
			
func _ready():
	var selected_schedule = ConfigManager.config_obj[ConfigManager.selected_schedule]
	$Background/Foreground/HeaderLabel.set_text(ConfigManager.selected_schedule)
	spawn_movie_controls()
	$Background/Foreground/ErrorLabel.set_text("")

func _on_close_button_pressed():
	add_child(GlobalManager.confirm_quit_planner())

func _on_add_movie_button_pressed():
	var movie_name = $Background/Foreground/InputsContainer/MovieNameInputBackground/MovieNameInput.get_text()
	var priority = $Background/Foreground/InputsContainer/PrioritySpinBox.get_value()
	var color = $Background/Foreground/InputsContainer/MovieColorPicker.get_pick_color()
	$Background/Foreground/InputsContainer/MovieNameInputBackground/MovieNameInput.set_text("")
	$Background/Foreground/InputsContainer/PrioritySpinBox.set_value(0)
	$Background/Foreground/InputsContainer/MovieColorPicker.color = Color("#009696")
	if movie_name == null or movie_name == "" or movie_name.length() < 3:
		$Background/Foreground/ErrorLabel.set_text("Please enter a movie name with 3 or more characters")
		return
	
	ConfigManager.add_movie(movie_name, priority, color)
	spawn_movie_controls()

func _on_back_button_pressed():
	get_tree().change_scene_to_file(GlobalManager.WELCOME_SCENE_PATH)

func delete_selected_schedule():
	ConfigManager.delete_selected_schedule()
	get_tree().change_scene_to_file(GlobalManager.WELCOME_SCENE_PATH)

func _on_delete_schedule_button_pressed():
	var confirm = GlobalManager.create_confim_window("Delete " + ConfigManager.selected_schedule + "?", "Are you sure you want to delete the entire " + ConfigManager.selected_schedule + " schedule? This can not be undone.", "Delete", "cancel")
	confirm.button1.connect(delete_selected_schedule)
	add_child(confirm)

func _on_view_report_button_pressed():
	get_tree().change_scene_to_file(GlobalManager.GRAPH_REPORT_SCENE_PATH)

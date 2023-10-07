extends Control

func on_movie_button_press(movie_name):
	ConfigManager.selected_movie = movie_name
	get_tree().change_scene_to_file(GlobalManager.EDIT_SELECTED_MOVIE_PATH)

func delete_all_movie_buttons():
	for movie in $Background/Foreground/MovieButtonsScrollContainer/MovieButtonsContainer.get_children():
		movie.queue_free()
		
func spawn_movie_buttons():
	delete_all_movie_buttons()
	var data_obj = ConfigManager.config_obj[ConfigManager.selected_schedule]["data"]
	for movie in data_obj:
		if data_obj[movie]["entry_type"] == "movie":
			var movie_name = data_obj[movie]["entry_name"]
			var movie_button_scene = load(GlobalManager.MY_BUTTON_SCENE_PATH)
			var movie_button = movie_button_scene.instantiate()
			movie_button.set_text(movie_name)
			movie_button.pressed.connect(on_movie_button_press.bind(movie_name))
			$Background/Foreground/MovieButtonsScrollContainer/MovieButtonsContainer.add_child(movie_button)
			
func _ready():
	var selected_schedule = ConfigManager.config_obj[ConfigManager.selected_schedule]
	$Background/Foreground/HeaderLabel.set_text(selected_schedule["entry_name"])
	spawn_movie_buttons()
	$Background/Foreground/ErrorLabel.set_text("")

func _on_close_button_pressed():
	add_child(GlobalManager.confirm_quit_planner())

func _on_add_movie_button_pressed():
	var movie_name = $Background/Foreground/InputsContainer/MovieNameInputBackground/MovieNameInput.get_text()
	var priority = $Background/Foreground/InputsContainer/PriorityContainer/PrioritySpinBox.get_line_edit().get_text()
	var color = $Background/Foreground/InputsContainer/MovieColorContainer/MovieColorPicker.get_pick_color()
	if movie_name == null or movie_name == "" or movie_name.length() < 3:
		$Background/Foreground/ErrorLabel.set_text("Please enter a movie name with 3 or more characters")
		return
	
	ConfigManager.add_movie(movie_name, priority, color)
	spawn_movie_buttons()


func _on_back_button_pressed():
	get_tree().change_scene_to_file(GlobalManager.WELCOME_SCENE_PATH)

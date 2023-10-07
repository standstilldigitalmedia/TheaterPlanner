extends Control

func _on_add_movie_button_pressed():
	var movie_name = $Background/HBoxContainer/MovieNameInputBackground/MovieNameInput.get_text()
	var priority = $Background/HBoxContainer/PriorityContainer/PrioritySpinBox.get_line_edit().get_text()
	var color = $Background/HBoxContainer/MovieColorContainer/MovieColorPicker.get_pick_color()
	if movie_name == null or movie_name == "" or movie_name.length() < 3:
		$Background/ErrorLabel.set_text("Please enter a movie name with 3 or more characters")
		return
	
	ConfigManager.add_movie({"movie_name": movie_name, "priority": priority, "color": color, "listings": []})
	ConfigManager.write_config()

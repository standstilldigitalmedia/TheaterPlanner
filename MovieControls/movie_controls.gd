extends Control

signal update
signal delete

var previous_name = ""

func set_values(movie_name, priority, movie_color):
	$InputsContainer/NameInputBackground/NameInput.set_text(movie_name)
	$InputsContainer/PrioritySpinBox.set_value(priority)
	$InputsContainer/MovieColorPicker.color = movie_color
	previous_name = movie_name
	
func update_config():
	var new_prev_name = previous_name
	previous_name = $InputsContainer/NameInputBackground/NameInput.get_text()
	ConfigManager.update_movie($InputsContainer/NameInputBackground/NameInput.get_text(),new_prev_name, $InputsContainer/PrioritySpinBox.get_value(), $InputsContainer/MovieColorPicker.color)
	update.emit()


func _on_delete_button_pressed():
	ConfigManager.selected_movie = $InputsContainer/NameInputBackground/NameInput.get_text()
	delete.emit()

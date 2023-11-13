extends HBoxContainer

signal update
signal delete
signal showings

var previous_name = ""

func set_values(movie_name, priority, movie_color):
	$NameInputBackground/NameInput.set_text(movie_name)
	$PrioritySpinBox.set_value(priority)
	$MovieColorPicker.color = movie_color
	previous_name = movie_name
	
func update_config():
	var new_prev_name = previous_name
	previous_name = $NameInputBackground/NameInput.get_text()
	ConfigManager.update_movie($NameInputBackground/NameInput.get_text(),new_prev_name, $PrioritySpinBox.get_value(), $MovieColorPicker.color)
	update.emit()


func _on_delete_button_pressed():
	ConfigManager.selected_movie = previous_name
	delete.emit()


func _on_showings_button_pressed():
	ConfigManager.selected_movie = previous_name
	showings.emit()

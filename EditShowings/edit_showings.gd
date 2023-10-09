extends Control

func reset_controls():
	$Background/Foreground/ControlsContainer/AmPmOptionButton.set_text("AM")
	$Background/Foreground/ControlsContainer/RunHour.set_value(1)
	$Background/Foreground/ControlsContainer/RunMinute.set_value(0)
	$Background/Foreground/ControlsContainer/StartHour.set_value(1)
	$Background/Foreground/ControlsContainer/StartMinute.set_value(0)
	
func delete_all_showing_controls():
	for showing in $Background/Foreground/ShowingsControlsScrollContainer/ShowingsControlsContainer.get_children():
		showing.queue_free()
		
func on_delete_showing():
	ConfigManager.delete_selected_showing()
	spawn_showing_controls()
		
func on_confirm_delete_showing():
	var confirm = GlobalManager.create_confim_window("Delete Showing?", "Are you sure you want to delete this showing? This can not be undone.", "Delete", "Cancel")
	confirm.button1.connect(on_delete_showing)
	add_child(confirm)
	
func on_update_showing(start_hour, start_minute, start_ampm, run_hour, run_min):
	ConfigManager.update_showing(start_hour, start_minute, start_ampm, run_hour, run_min)
	spawn_showing_controls()
	var confirm = GlobalManager.create_confim_window("Updated", "Your record has been updated", "Ok", "Cancel")
	add_child(confirm)
		
func spawn_showing_controls():
	delete_all_showing_controls()
	var spacer_scene = load(GlobalManager.SPACER_PATH)
	$Background/Foreground/ShowingsControlsScrollContainer/ShowingsControlsContainer.add_child(spacer_scene.instantiate())
	var data_obj = ConfigManager.get_selected_movie_showings()
	for showing in data_obj:
		var start_hour = showing["start_hour"]
		var start_minute = showing["start_minute"]
		var start_ampm = showing["start_ampm"]
		var run_hour = showing["run_hour"]
		var run_minute = showing["run_minute"]
		
		var showing_control_scene = load(GlobalManager.SHOWING_CONTROLS_PATH)
		var showing_control = showing_control_scene.instantiate()
		
		showing_control.set_values(start_hour, start_minute, start_ampm, run_hour, run_minute)
		showing_control.delete.connect(on_confirm_delete_showing)
		showing_control.update.connect(on_update_showing)
		$Background/Foreground/ShowingsControlsScrollContainer/ShowingsControlsContainer.add_child(showing_control)

func _ready():
	$Background/Foreground/HeaderLabel.set_text(ConfigManager.selected_movie)
	$Background/Foreground/ErrorLabel.set_text("")
	$Background/Foreground/ControlsContainer/AmPmOptionButton.set_text("AM")
	spawn_showing_controls()

func _on_close_button_pressed():
	add_child(GlobalManager.confirm_quit_planner())

func _on_back_button_pressed():
	get_tree().change_scene_to_file(GlobalManager.EDIT_SELECTED_SCHEDULE_PATH)

func _on_add_showing_button_pressed():
	ConfigManager.add_showing($Background/Foreground/ControlsContainer/StartHour.get_value(), $Background/Foreground/ControlsContainer/StartMinute.get_value(), $Background/Foreground/ControlsContainer/AmPmOptionButton.get_text(), $Background/Foreground/ControlsContainer/RunHour.get_value(), $Background/Foreground/ControlsContainer/RunMinute.get_value())
	reset_controls()
	spawn_showing_controls()
	
func on_delete_all_showings():
	ConfigManager.delete_all_showings()
	spawn_showing_controls()

func _on_delete_all_showings_button_pressed():
	var confirm = GlobalManager.create_confim_window("Delete All Showings?", "Are you sure you want to delete all showings? This can not be undone.", "Delete", "Cancel")
	confirm.button1.connect(on_delete_all_showings)
	add_child(confirm)

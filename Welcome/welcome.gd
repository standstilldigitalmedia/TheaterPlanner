extends Control

func delete_all_schedules():
	for schedule in $Background/Foreground/SchedulesScrollContainer/SchedulesContainer.get_children():
		schedule.queue_free()
		
func on_schedule_button_click(schedule_name):
	ConfigManager.selected_schedule = schedule_name
	get_tree().change_scene_to_file(GlobalManager.EDIT_SELECTED_SCHEDULE_PATH)
		
func spawn_schedule_buttons():
	delete_all_schedules()
	for schedule in ConfigManager.config_obj:
		var schedule_button_scene = load(GlobalManager.MY_BUTTON_SCENE_PATH)
		var schedule_button = schedule_button_scene.instantiate()
		schedule_button.set_text(schedule)
		schedule_button.pressed.connect(on_schedule_button_click.bind(schedule))
		$Background/Foreground/SchedulesScrollContainer/SchedulesContainer.add_child(schedule_button)

func _on_add_schedule_button_pressed():
	var schedule_name = $Background/Foreground/InputsContainer/ScheduleNameInputBackground/ScheduleNameInput.get_text()
	$Background/Foreground/InputsContainer/ScheduleNameInputBackground/ScheduleNameInput.set_text("")
	if schedule_name.length() < 4:
		$Background/Foreground/InputsContainer/ErrorLabel.set_text("Please enter a name that is 4 or more characters long.")
	else:
		$Background/Foreground/InputsContainer/ErrorLabel.set_text("")
		ConfigManager.add_schedule(schedule_name)
	spawn_schedule_buttons()
	
func _ready():
	ConfigManager.read_config()
	spawn_schedule_buttons()
	$Background/Foreground/InputsContainer/ErrorLabel.set_text("")

func _on_delete_data_button_pressed():
	var confirm = GlobalManager.create_confim_window("Delete Data?", "Are you sure you wish to delete all your data? Everything you have entered will be lost.", "Delete", "Cancel")
	confirm.button1.connect(ConfigManager.delete_config)
	confirm.button1.connect(spawn_schedule_buttons)
	add_child(confirm)
	
func _on_close_button_pressed():
	add_child(GlobalManager.confirm_quit_planner())

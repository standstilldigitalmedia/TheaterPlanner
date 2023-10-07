extends Control

func delete_all_schedules():
	for schedule in $Background/Foreground/SchedulesScrollContainer/SchedulesContainer.get_children():
		schedule.queue_free()
		
func spawn_schedule_buttons():
	delete_all_schedules()
	for schedule in ConfigManager.config_obj:
		if ConfigManager.config_obj[schedule]["entry_type"] == "schedule":
			var schedule_button_scene = load(GlobalManager.MY_BUTTON_SCENE_PATH)
			var schedule_button = schedule_button_scene.instantiate()
			schedule_button.set_text(ConfigManager.config_obj[schedule]["entry_name"])
			$Background/Foreground/SchedulesScrollContainer/SchedulesContainer.add_child(schedule_button)

func _on_add_schedule_button_pressed():
	var schedule_name = $Background/Foreground/InputsContainer/ScheduleNameInputBackground/ScheduleNameInput.get_text()
	if schedule_name.length() < 4:
		$Background/Foreground/InputsContainer/ErrorLabel.set_text("Please enter a name that is 4 or more characters long.")
	else:
		$Background/Foreground/InputsContainer/ErrorLabel.set_text("")
		ConfigManager.add_schedule(schedule_name)
		
	spawn_schedule_buttons()
	
func _ready():
	ConfigManager.read_config()
	spawn_schedule_buttons()

func _on_delete_data_button_pressed():
	var confirm = GlobalManager.create_confim_window("Delete Data?", "Are you sure you wish to delete all your data? Everything you have entered will be lost.", "Delete", "Cancel")
	confirm.button1.connect(ConfigManager.delete_config)
	confirm.button1.connect(spawn_schedule_buttons)
	add_child(confirm)
	
func _on_close_button_pressed():
	add_child(GlobalManager.confirm_quit_planner())

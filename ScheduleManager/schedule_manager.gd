extends Control

func delete_all_schedules():
	for schedule in $Background/SchedulesScrollContainer/SchedulesContainer.get_children():
		schedule.queue_free()
		
func spawn_schedule_buttons():
	delete_all_schedules()
	for schedule in ConfigManager.config_obj:
		if ConfigManager.config_obj[schedule]["entry_type"] == "schedule":
			var schedule_button_scene = load(ConfigManager.MY_BUTTON_SCENE_PATH)
			var schedule_button = schedule_button_scene.instantiate()
			schedule_button.set_text(ConfigManager.config_obj[schedule]["entry_name"])
			$Background/SchedulesScrollContainer/SchedulesContainer.add_child(schedule_button)

func _on_add_schedule_button_pressed():
	var schedule_name = $Background/InputsContainer/ScheduleNameInputBackground/ScheduleNameInput.get_text()
	if schedule_name.length() < 4:
		$Background/InputsContainer/ErrorLabel.set_text("Please enter a name that is 4 or more characters long.")
	else:
		$Background/InputsContainer/ErrorLabel.set_text("")
		ConfigManager.add_schedule(schedule_name)
		
	spawn_schedule_buttons()
	
func _ready():
	ConfigManager.read_config()
	spawn_schedule_buttons()


func _on_delete_data_button_pressed():
	DirAccess.remove_absolute(ConfigManager.CONFIG_PATH)

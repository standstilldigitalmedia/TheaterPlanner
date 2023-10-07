extends Control

func delete_all_schedules():
	for schedule in $Background/SchedulesScrollContainer/SchedulesContainer.get_children():
		schedule.queue_free()
		
func spawn_schedule_buttons():
	delete_all_schedules()
	for schedule in ConfigManager.config_obj:
		#print("schedule loop obj = " + JSON.stringify(ConfigManager.config_obj))
		#print("schedule loop = " + ConfigManager.config_obj[schedule].schedule_name)
		var schedule_button_scene = load(ConfigManager.MY_BUTTON_SCENE_PATH)
		var schedule_button = schedule_button_scene.instantiate()
		schedule_button.set_text(schedule)
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
	spawn_schedule_buttons()


func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file(ConfigManager.WELCOME_SCENE_PATH)

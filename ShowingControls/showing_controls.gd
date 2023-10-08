extends Control

signal update
signal delete

var prev_start_hour = 0
var prev_start_min = 0
var prev_start_ampm = ""
var prev_run_hour = 0
var prev_run_min = 0

func get_values():
	print("n")

func set_values(start_hour, start_minute, start_ampm, run_hour, run_min):
	$InputsContainer/StartHour.set_value(start_hour)
	$InputsContainer/StartMinute.set_value(start_minute)
	$InputsContainer/AmPmOptionButton.set_text(start_ampm)
	$InputsContainer/RunHour.set_value(run_hour)
	$InputsContainer/RunMinute.set_value(run_min)
	prev_start_hour = start_hour
	prev_start_min = start_minute
	prev_start_ampm = start_ampm
	prev_run_hour = run_hour
	prev_run_min = run_min

func _on_update_button_pressed():
	ConfigManager.selected_showing = str(prev_start_hour) + str(prev_start_min) + str(prev_start_ampm) + str(prev_run_hour) + str(prev_run_min)
	update.emit()

func _on_delete_button_pressed():
	ConfigManager.selected_showing = str(prev_start_hour) + str(prev_start_min) + str(prev_start_ampm) + str(prev_run_hour) + str(prev_run_min)
	delete.emit()

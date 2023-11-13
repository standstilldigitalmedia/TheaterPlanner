extends Control

signal update(start_hour, start_minute, start_ampm, run_hour, run_min)
signal delete

var prev_start_hour = 0
var prev_start_min = 0
var prev_start_ampm = ""
var prev_run_hour = 0
var prev_run_min = 0

func set_values(start_hour, start_minute, start_ampm, run_hour, run_min):
	$StartHour.set_value(start_hour)
	$StartMinute.set_value(start_minute)
	$AmPmOptionButton.select(start_ampm)
	$RunHour.set_value(run_hour)
	$RunMinute.set_value(run_min)
	prev_start_hour = start_hour
	prev_start_min = start_minute
	prev_start_ampm = start_ampm
	prev_run_hour = run_hour
	prev_run_min = run_min

func _on_update_button_pressed():
	ConfigManager.selected_showing = str(prev_start_hour) + str(prev_start_min) + str(prev_start_ampm) + str(prev_run_hour) + str(prev_run_min)
	update.emit($StartHour.get_value(),$StartMinute.get_value(),$AmPmOptionButton.get_selected(),$RunHour.get_value(),$RunMinute.get_value())

func _on_delete_button_pressed():
	ConfigManager.selected_showing = str(prev_start_hour) + str(prev_start_min) + str(prev_start_ampm) + str(prev_run_hour) + str(prev_run_min)
	delete.emit()

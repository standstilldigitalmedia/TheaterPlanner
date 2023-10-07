extends Control

var sep = "*"
func get_values():
	var theatre = $ListingContainer/TheatreContainer/TheatreSelectButton.get_text()
	var start_hour = $ListingContainer/StartTimeContainer/StartHour.get_line_edit().get_text()
	var start_min = $ListingContainer/StartTimeContainer/StartMinute.get_line_edit().get_text()
	var start_am_pm = $ListingContainer/StartTimeContainer/AmPmButton.get_text()
	var run_time_hour = $ListingContainer/RunTimeContainer/Hour.get_line_edit().get_text()
	var run_time_minute = $ListingContainer/RunTimeContainer/Minute.get_line_edit().get_text()
	return {"theatre": theatre, "start_hour": start_hour, "start_min": start_min, "start_am_pm": start_am_pm, "run_time_hour": run_time_hour, "run_time_minute": run_time_minute}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

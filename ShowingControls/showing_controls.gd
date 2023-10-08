extends Control

var prev_start_hour = 0
var prev_start_min = 0
var prev_start_ampm = ""
var prev_run_hour = 0
var prev_run_min = 0

func set_values(start_hour, start_minute, start_ampm, run_hour, run_min):
	$ControlsContainer/StartHour.set_value(start_hour)
	$ControlsContainer/StartMinute.set_value(start_minute)
	$ControlsContainer/AmPmOptionButton.set_text(start_ampm)
	$ControlsContainer/RunHour.set_value(run_hour)
	$ControlsContainer/RunMinute.set_value(run_min)
	prev_start_hour = start_hour
	prev_start_min = start_minute
	prev_start_ampm = start_ampm
	prev_run_hour = run_hour
	prev_run_min = run_min

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

extends Button

signal graph_click(clicked_button)

var start_hour = 0
var start_minute = 0
var ampm = 0
var run_hour = 0
var run_minute = 0
var bg_color = Color(0,0,0,1)
var nineam = 12
var hour_size = 62
var noon = 248
var tooltip = ""
var movie = ""

func get_military_hour(hour, ampm):
	if ampm == 0:
		return hour
	elif hour == 12:
		if ampm == 0:
			return 0
		else:
			return 12
	var new_hour = hour + 12
	if new_hour > 23:
		if new_hour == 24:
			new_hour = 0
		else:
			new_hour -= 24
	return new_hour
	
func get_non_military_time_string(hour, minute):
	var minute_string = str(minute)
	print("non military hour = " + str(hour))
	if minute < 10:
		minute_string = "0" + minute_string
	if hour == 24 or hour == 0:
		return "12:" + minute_string + "AM"
	if hour < 12:
		return str(hour) + ":" + minute_string + " AM"
	if hour < 24:
		var new_hour = hour - 12
		if new_hour == 0:
			return "12:" + minute_string + " AM"
		return str(new_hour) + ":" + minute_string + " PM"
	return "invalid hour"
	
func get_start_hour():
	return get_military_hour(start_hour, ampm)
	
func get_end_hour():
	var end_time = get_military_hour(start_hour, ampm) + run_hour
	if end_time > 23:
		if end_time == 24:
			end_time = 0
		else:
			end_time -= 24
	return end_time

#func create_json_obj():
	#return {"start_hour":start_hour, "start_minute":start_minute,"ampm":ampm, "run_hour":run_hour,"run_minute":run_minute,"bg_color":bg_color,"tooltip":tooltip,"movie":movie}

func get_ampm_string():
	if ampm == 0:
		return "AM"
	else:
		return "PM"
		
func get_rect_x_pos():
	var new_x = 0
	if ampm == 0:
		if start_hour > 8:
			new_x = (hour_size * (start_hour - 9)) + nineam
		else:
			new_x = (hour_size * 24) + (hour_size * (start_hour - 9)) + nineam
	else:
		if start_hour == 12:
			new_x = (hour_size * 3) + nineam
		else:
			new_x = ((start_hour * hour_size) + noon + nineam) - hour_size
	#if minute != 0:
	new_x += start_minute
	return new_x
	
func get_end_time():
	var end_minutes = start_minute + run_minute
	var end_hour = 0
	var end_ampm = get_ampm_string()
	end_hour = start_hour + run_hour
	end_hour = get_military_hour(end_hour,ampm)
	if end_minutes > 60:
		end_minutes -= 60
		end_hour += 1
	return get_non_military_time_string(end_hour,end_minutes)

func set_values(s_hour, s_minute, am_pm, r_hour, r_minute, color, mov):
	start_hour = s_hour
	start_minute = s_minute
	ampm = am_pm
	run_hour = r_hour
	run_minute = r_minute
	bg_color = color
	movie = mov
	var start_minute_string = str(start_minute)
	if start_minute < 10:
		start_minute_string = "0" + start_minute_string
	
	tooltip = movie + "\n" + get_non_military_time_string(get_military_hour(start_hour, ampm),start_minute) + " - " + get_end_time()
	
func get_disabled_style_box():
	var new_stylebox = get_theme_stylebox("normal").duplicate()
	var color_html = bg_color.left(bg_color.length() - 2)
	color_html += "30"
	new_stylebox.bg_color = color_html
	return new_stylebox
	
func get_normal_style_box():
	var new_stylebox = get_theme_stylebox("normal").duplicate()
	var color_html = bg_color.left(bg_color.length() - 2)
	color_html += "BB"
	new_stylebox.bg_color = color_html
	return new_stylebox

func get_clicked_style_box():
	var new_stylebox = get_theme_stylebox("normal").duplicate()
	new_stylebox.bg_color = bg_color
	return new_stylebox
	
func create_color_rect():
	var width = (run_hour * hour_size) + run_minute
	custom_minimum_size = Vector2(width,31)
	position = Vector2(get_rect_x_pos(),0)
	
	add_theme_stylebox_override("normal", get_normal_style_box())
	add_theme_stylebox_override("hover", get_clicked_style_box())
	add_theme_stylebox_override("pressed", get_clicked_style_box())
	add_theme_stylebox_override("focus", get_clicked_style_box())
	add_theme_stylebox_override("disabled", get_disabled_style_box())
	tooltip_text = tooltip

func _on_pressed():
	graph_click.emit(self)


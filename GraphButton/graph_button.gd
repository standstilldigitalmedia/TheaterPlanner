extends Button

signal graph_click(clicked_button, json_obj)

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

func create_json_obj():
	return {"start_hour":start_hour, "start_minute":start_minute,"ampm":ampm, "run_hour":run_hour,"run_minute":run_minute,"bg_color":bg_color,"tooltip":tooltip,"movie":movie}

func get_rect_x_pos():
	var new_x = 0
	if ampm == 0:
		new_x = (hour_size * (start_hour - 9)) + nineam
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
	var end_ampm = "AM"
	end_hour = start_hour + run_hour
	if end_minutes > 60:
		end_minutes -= 60
		end_hour += 1
	if ampm == 0:
		if end_hour > 12:
			end_ampm = "PM"
			end_hour = end_hour - 12
	else:
		if end_hour > 12:
			end_ampm = "AM"
			end_hour = end_hour - 12
	var end_minutes_string = str(end_minutes)
	if end_minutes < 10:
		end_minutes_string = "0" + end_minutes_string
	return str(end_hour) + ":" + end_minutes_string

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
	tooltip = movie + "\n" + str(start_hour) + ":" + start_minute_string + " - " + get_end_time()
	
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
	graph_click.emit(self,create_json_obj())


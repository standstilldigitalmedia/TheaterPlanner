extends Control

const NAME_LABEL_PATH = "res://GraphReport/movie_name_label.tscn"
const GRAPH_CONTAINER_PATH = "res://GraphReport/movie_graph_container.tscn"
var nineam = 12
var hour_size = 62
var noon = 248

func spawn_name_label(movie_name):
	var name_label_scene = load(NAME_LABEL_PATH)
	var name_label = name_label_scene.instantiate()
	name_label.set_text(movie_name)
	$Background/Foreground/GraphScrollContainer/GraphContainer/MovieNamesContainer.add_child(name_label)
	
func color_rect_click():
	print("Look at me")
	
func create_color_rect(x_pos,width, color, tooltip):
	var new_rect = Button.new()
	new_rect.position = Vector2(x_pos,0)
	new_rect.custom_minimum_size = Vector2(width,31)
	var new_stylebox_normal = new_rect.get_theme_stylebox("normal").duplicate()
	new_stylebox_normal.bg_color = color
	new_rect.add_theme_stylebox_override("normal", new_stylebox_normal)
	new_rect.add_theme_stylebox_override("hover", new_stylebox_normal)
	new_rect.add_theme_stylebox_override("pressed", new_stylebox_normal)
	new_rect.add_theme_stylebox_override("disabled", new_stylebox_normal)
	new_rect.tooltip_text = tooltip
	new_rect.pressed.connect(color_rect_click)
	return new_rect
	
func spawn_graph_container():
	var graph_container_scene = load(GRAPH_CONTAINER_PATH)
	var graph_container = graph_container_scene.instantiate()
	return graph_container

func get_rect_x_pos(hour, minute, ampm):
	var new_x = 0
	print("hour - 9 = " + str(hour - 9))
	if ampm == "AM":
		new_x = (hour_size * (hour - 9)) + nineam
	else:
		if hour == 12:
			new_x = noon
		else:
			new_x = ((hour * hour_size) + noon + nineam) - hour_size
	print("rect_x_pos " + str(new_x + (minute / 60)))
	if minute != 0:
		new_x += (minute / 60)
	return new_x
	
func get_end_time(start_hour, start_minute, ampm, run_hour, run_minute):
	var end_minutes = start_minute + run_minute
	var end_hour = 0
	var end_ampm = "AM"
	end_hour = start_hour + run_hour
	if end_minutes > 60:
		end_minutes -= 60
		end_hour += 1
	if ampm == "AM":
		if end_hour > 12:
			end_ampm = "PM"
			end_hour = end_hour - 12
	else:
		if end_hour > 12:
			end_ampm = "AM"
			end_hour = end_hour - 12
	return str(end_hour) + ":" + str(end_minutes)
	
func _ready():
	$Background/Foreground/HeaderLabel.set_text(ConfigManager.selected_schedule)
	for movie in ConfigManager.config_obj[ConfigManager.selected_schedule]:
		spawn_name_label(movie)
		var graph_container = spawn_graph_container()
		for listing in ConfigManager.config_obj[ConfigManager.selected_schedule][movie]["showings"]:
			var config_listing = ConfigManager.config_obj[ConfigManager.selected_schedule][movie]["showings"][listing]
			var start_hour = config_listing["start_hour"]
			var start_minute = config_listing["start_minute"]
			var ampm = config_listing["start_ampm"]
			var run_hour = config_listing["run_hour"]
			var run_minute = config_listing["run_minute"]
			
			var x_pos = get_rect_x_pos(start_hour, start_minute, ampm)
			var minute = 0
			if start_minute != 0:
				minute = start_minute / 60
			var width = (run_hour * hour_size) + run_minute + start_minute
			var color = ConfigManager.config_obj[ConfigManager.selected_schedule][movie]["movie_color"]
			var new_start_minute = start_minute
			if start_minute == 0:
				new_start_minute = "00"
			var tooltip = movie + "\n" + str(start_hour) + ":" + str(new_start_minute) + " - " + get_end_time(start_hour, start_minute, ampm, run_hour, run_minute)
			var color_rect = create_color_rect(x_pos,width, color, tooltip)
			graph_container.add_child(color_rect)
		$Background/Foreground/GraphScrollContainer/GraphContainer/MovieGraphsContainer.add_child(graph_container)
	
func _on_close_button_pressed():
	add_child(GlobalManager.confirm_quit_planner())

func _on_back_button_pressed():
	get_tree().change_scene_to_file(GlobalManager.EDIT_SELECTED_SCHEDULE_PATH)

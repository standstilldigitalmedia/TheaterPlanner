extends Control

const NAME_LABEL_PATH = "res://GraphReport/movie_name_label.tscn"
const GRAPH_CONTAINER_PATH = "res://GraphReport/movie_graph_container.tscn"

var graph_buttons_array = []

func spawn_name_label(movie_name):
	var name_label_scene = load(NAME_LABEL_PATH)
	var name_label = name_label_scene.instantiate()
	name_label.set_text(movie_name)
	$Background/Foreground/GraphScrollContainer/GraphContainer/MovieNamesContainer.add_child(name_label)
	
func color_rect_click():
	print("Look at me")

func spawn_graph_container():
	var graph_container_scene = load(GRAPH_CONTAINER_PATH)
	var graph_container = graph_container_scene.instantiate()
	return graph_container
	
func get_military_hour(hour, ampm):
	if ampm == 0:
		return hour
	elif hour == 12:
		return 12
	return hour + 12

func on_graph_button_click(clicked_button, json_object):
	for graph_button in graph_buttons_array:
		if graph_button != clicked_button:
			var graph_button_mil_start_hour = get_military_hour(graph_button.start_hour, graph_button.ampm)
			var json_object_mil_start_hour = get_military_hour(json_object["start_hour"], json_object["ampm"])
			var graph_button_mil_end_hour = graph_button_mil_start_hour + graph_button.run_hour
			var json_object_mil_end_hour = json_object_mil_start_hour + json_object["run_hour"]
			
			var graph_button_end_minute = graph_button.start_minute + graph_button.run_minute
			if graph_button_end_minute > 60:
				graph_button_mil_end_hour += 1
				graph_button_end_minute -= 60
				
			var json_object_end_minute = json_object["start_minute"] + json_object["run_minute"]
			if json_object_end_minute > 60:
				json_object_mil_end_hour += 1
				json_object_end_minute -= 60
				
			if graph_button_mil_start_hour == json_object_mil_start_hour:
				if graph_button.start_minute >= json_object["start_minute"]:
					graph_button.set_disabled(true)
					continue
			if graph_button_mil_end_hour == json_object_mil_end_hour:
				if graph_button_end_minute <= json_object["start_minute"]:
					graph_button.set_disabled(true)
					continue	
			if graph_button_mil_start_hour == json_object_mil_end_hour:
				if graph_button.start_minute < json_object_end_minute:
					graph_button.set_disabled(true)
					continue
			if graph_button_mil_end_hour == json_object_mil_start_hour:
				if graph_button_end_minute > json_object["start_minute"]:
					graph_button.set_disabled(true)
					continue
	
			if graph_button_mil_start_hour > json_object_mil_start_hour and graph_button_mil_start_hour < json_object_mil_end_hour:
				graph_button.set_disabled(true)
				continue
			if graph_button_mil_end_hour > json_object_mil_start_hour and graph_button_mil_end_hour < json_object_mil_end_hour:
				graph_button.set_disabled(true)
				continue
				
			if json_object_mil_start_hour > graph_button_mil_start_hour and json_object_mil_start_hour < graph_button_mil_end_hour:
				graph_button.set_disabled(true)
				continue
			if json_object_mil_end_hour > graph_button_mil_start_hour and json_object_mil_end_hour < graph_button_mil_end_hour:
				graph_button.set_disabled(true)
				continue
				
func _ready():
	$Background/Foreground/HeaderLabel.set_text(ConfigManager.selected_schedule)
	for movie in ConfigManager.config_obj[ConfigManager.selected_schedule]:
		spawn_name_label(movie)
		var graph_container = spawn_graph_container()
		for listing in ConfigManager.config_obj[ConfigManager.selected_schedule][movie]["showings"]:
			var config_listing = ConfigManager.config_obj[ConfigManager.selected_schedule][movie]["showings"][listing]
			var graph_button_scene = load(GlobalManager.GRAPH_BUTTON_PATH)
			var graph_button = graph_button_scene.instantiate()
			graph_button.set_values(config_listing["start_hour"], config_listing["start_minute"], config_listing["start_ampm"], config_listing["run_hour"], config_listing["run_minute"], ConfigManager.config_obj[ConfigManager.selected_schedule][movie]["movie_color"], movie)
			graph_button.create_color_rect()
			graph_button.graph_click.connect(on_graph_button_click)
			graph_container.add_child(graph_button)
			graph_buttons_array.append(graph_button)
		$Background/Foreground/GraphScrollContainer/GraphContainer/MovieGraphsContainer.add_child(graph_container)
	
func _on_close_button_pressed():
	add_child(GlobalManager.confirm_quit_planner())

func _on_back_button_pressed():
	get_tree().change_scene_to_file(GlobalManager.EDIT_SELECTED_SCHEDULE_PATH)


func _on_clear_button_pressed():
	for graph_button in graph_buttons_array:
		graph_button.set_disabled(false)

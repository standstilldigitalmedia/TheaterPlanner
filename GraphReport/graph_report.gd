extends Control

const NAME_LABEL_PATH = "res://GraphReport/movie_name_label.tscn"
const GRAPH_CONTAINER_PATH = "res://GraphReport/movie_graph_container.tscn"

var graph_buttons_array = []

func spawn_name_label(movie_name):
	var name_label_scene = load(NAME_LABEL_PATH)
	var name_label = name_label_scene.instantiate()
	name_label.set_text(movie_name)
	$Background/Foreground/GraphScrollContainer/GraphContainer/MovieNamesContainer.add_child(name_label)
	
func spawn_graph_container():
	var graph_container_scene = load(GRAPH_CONTAINER_PATH)
	var graph_container = graph_container_scene.instantiate()
	return graph_container

func on_graph_button_click(clicked_button, disable):
	for graph_button in graph_buttons_array:
		if graph_button != clicked_button:
			if graph_button.movie == clicked_button.movie:
				graph_button.set_disabled(disable)
				continue
				
			var graph_button_mil_start_hour = graph_button.get_military_hour(graph_button.start_hour, graph_button.ampm)
			var json_object_mil_start_hour = clicked_button.get_military_hour(clicked_button.start_hour, clicked_button.ampm)
			var graph_button_mil_end_hour = graph_button_mil_start_hour + graph_button.run_hour
			var json_object_mil_end_hour = json_object_mil_start_hour + clicked_button.run_hour
			
			var graph_button_end_minute = graph_button.start_minute + graph_button.run_minute
			if graph_button_end_minute > 60:
				graph_button_mil_end_hour += 1
				graph_button_end_minute -= 60
				
			var json_object_end_minute = clicked_button.start_minute + clicked_button.run_minute
			if json_object_end_minute > 60:
				json_object_mil_end_hour += 1
				json_object_end_minute -= 60
				
			if graph_button_mil_start_hour == json_object_mil_start_hour:
				if graph_button.start_minute >= clicked_button.start_minute:
					graph_button.set_disabled(disable)
					continue
			if graph_button_mil_end_hour == json_object_mil_end_hour:
				if graph_button_end_minute <= clicked_button.start_minute:
					graph_button.set_disabled(disable)
					continue	
			if graph_button_mil_start_hour == json_object_mil_end_hour:
				if graph_button.start_minute < json_object_end_minute:
					graph_button.set_disabled(disable)
					continue
			if graph_button_mil_end_hour == json_object_mil_start_hour:
				if graph_button_end_minute > clicked_button.start_minute:
					graph_button.set_disabled(disable)
					continue
	
			if graph_button_mil_start_hour > json_object_mil_start_hour and graph_button_mil_start_hour < json_object_mil_end_hour:
				graph_button.set_disabled(disable)
				continue
			if graph_button_mil_end_hour > json_object_mil_start_hour and graph_button_mil_end_hour < json_object_mil_end_hour:
				graph_button.set_disabled(disable)
				continue
				
			if json_object_mil_start_hour > graph_button_mil_start_hour and json_object_mil_start_hour < graph_button_mil_end_hour:
				graph_button.set_disabled(disable)
				continue
			if json_object_mil_end_hour > graph_button_mil_start_hour and json_object_mil_end_hour < graph_button_mil_end_hour:
				graph_button.set_disabled(disable)
				continue
				
func _ready():
	$Background/Foreground/HeaderLabel.set_text(ConfigManager.selected_schedule)
	for movie in ConfigManager.get_schedule_movies():
		spawn_name_label(movie["movie_name"])
		var graph_container = spawn_graph_container()
		for listing in movie["showings"]:
			print("lising json = " + JSON.stringify(listing))
			var this_listing = movie["showings"][listing]
			#var config_listing = ConfigManager.config_obj[ConfigManager.selected_schedule][movie]["showings"][listing]
			var graph_button_scene = load(GlobalManager.GRAPH_BUTTON_PATH)
			var graph_button = graph_button_scene.instantiate()
			graph_button.set_values(this_listing["start_hour"], this_listing["start_minute"], this_listing["start_ampm"], this_listing["run_hour"], this_listing["run_minute"], ConfigManager.config_obj[ConfigManager.selected_schedule][movie["movie_name"]]["movie_color"], movie["movie_name"])
			graph_button.create_color_rect()
			graph_button.graph_clicked.connect(on_graph_button_click)
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

extends Node

var config: ConfigFile
var config_obj = {}
const CONFIG_PATH = "user://theater-planner.cfg"
const MY_BUTTON_SCENE_PATH = "res://UI/Scenes/my_button.tscn"
const WELCOME_SCENE_PATH = "res://Welcome/welcome.tscn"
const NEW_SCHEDULE_SCENE_PATH = "res://NewSchedule/new_schedule.tscn"
const NEW_MOVIE_SCENE_PATH = "res://NewMovie/new_movie.tscn"

func write_config():
	config.set_value("planner_section","planner_json",JSON.stringify(config_obj))
	config.save(CONFIG_PATH)
	print("config written = " + JSON.stringify(config_obj))
	
func read_config():
	config = ConfigFile.new()
	var err = config.load(CONFIG_PATH)
	
	if err != OK:
		config = ConfigFile.new()
		config.set_value("planner_section", "planner_json", "")
		return
		
	var json = JSON.new()
	var json_string = config.get_value("planner_section", "planner_json")
	var error = json.parse(json_string)
	if error == OK:
		var data_received = json.data
		config_obj = data_received
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		
	print("config read = " + JSON.stringify(config_obj))

func get_selected_schedule():
	return config_obj[config_obj["selected_schedule"]]

func add_schedule(schedule_name):
	config_obj[schedule_name] = {"schedule_name":schedule_name}
	config_obj[schedule_name]["selected_schedule"] = schedule_name
	write_config()
	
func get_selected_movie():
	var selected_schedule = get_selected_schedule()
	for movie in selected_schedule:
		if movie["movie_name"] == config_obj["selected_movie"]:
			return movie
	
func add_movie(movie_obj):
	#add movie_obj to config_obj
	config_obj[config_obj["selected_schedule"]].append(movie_obj)
	#swtich selected_movie to the new movie
	config_obj["selected_movie"] = movie_obj
	write_config()

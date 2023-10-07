extends Node

var config: ConfigFile
var config_obj = {}

func write_config():
	config.set_value("planner_section","planner_json",JSON.stringify(config_obj))
	config.save(GlobalManager.CONFIG_PATH)
	
func read_config():
	config_obj = {}
	config = ConfigFile.new()
	var err = config.load(GlobalManager.CONFIG_PATH)
	
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

func delete_config():
	DirAccess.remove_absolute(GlobalManager.CONFIG_PATH)
	read_config()

func get_selected_schedule():
	return config_obj["selected_schedule"]
	
func set_selected_schedule(schedule_name):
	config_obj["selected_schedule"] = config_obj[schedule_name]

func add_schedule(schedule_name):
	config_obj[schedule_name] = {"entry_type":"schedule", "entry_name":schedule_name, "data":{}}
	config_obj["selected_schedule"] = config_obj[schedule_name]
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

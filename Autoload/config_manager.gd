extends Node

var config: ConfigFile
var config_obj = {}
var selected_schedule = ""
var selected_movie = ""

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

func add_schedule(schedule_name):
	config_obj[schedule_name] = {"entry_type":"schedule", "entry_name":schedule_name, "data":{}}
	write_config()
	
func add_movie(movie_name, priority, color):
	config_obj[selected_schedule]["data"][movie_name] = {"entry_type":"movie","entry_name":movie_name, "data": {"priority":priority, "color":color, "data": []}}
	write_config()

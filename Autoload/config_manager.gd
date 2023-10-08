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
	
func delete_selected_schedule():
	config_obj.erase(selected_schedule)
	selected_schedule = ""
	write_config()
	
func delete_selected_movie():
	config_obj[selected_schedule].erase(selected_movie)
	selected_movie = ""
	write_config()

func add_schedule(schedule_name):
	config_obj[schedule_name] = {}
	write_config()
	
func add_movie(movie_name, priority, color):
	config_obj[selected_schedule][movie_name] = {"movie_name":movie_name, "priority":priority, "movie_color":color.to_html(), "showings": []}
	write_config()
	
func update_movie(new_movie_name,movie_name, priority, color):
	var old_showings = {}
	if config_obj[selected_schedule].has(movie_name):
		old_showings = config_obj[selected_schedule][movie_name]["showings"]
		config_obj[selected_schedule].erase(movie_name)
	elif config_obj[selected_schedule].has(new_movie_name):
		old_showings = config_obj[selected_schedule][new_movie_name]["showings"]
	config_obj[selected_schedule][new_movie_name]= {"movie_name":new_movie_name, "priority":priority, "movie_color":color.to_html(), "showings": old_showings}
	write_config()
	
func get_schedule_movies():
	var return_var = []
	for movie in config_obj[selected_schedule]:
		return_var.append({"movie_name":config_obj[selected_schedule][movie]["movie_name"],"priority":config_obj[selected_schedule][movie]["priority"],"movie_color":config_obj[selected_schedule][movie]["movie_color"]})
	return return_var

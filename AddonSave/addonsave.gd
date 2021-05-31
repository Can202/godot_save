extends Node


#Convert this in a AutoLoad

#Modify

var data_in_folder = true      # true changes "user://" to "res://"
var folder_name = "save"        # Folder name
var print_in_terminal = true    # if it changes to false, this script will not print

var screenshot_in_folder = true            # true changes "user://" to "res://"
var screenshot_folder_name = "screenshots"  # Folder name
var screenshot_print_in_terminal = true     # if it changes to false, this script will not print

#End










var res_user = "user://"
var S_res_user = "user://"

func _ready():
	if data_in_folder == false:
		res_user = "user://"
	else:
		res_user = "res://"
		
	
	#Screenshot needs
	if screenshot_in_folder == false:
		S_res_user = "user://"
	else:
		S_res_user = "res://"
	thread = Thread.new()
	mutex = Mutex.new()
		

func create_folder():
	var path = Directory.new()
	if !path.dir_exists(res_user + folder_name):
		path.open(res_user)
		path.make_dir(res_user + folder_name)
		if print_in_terminal:
			print("making directory")

func save_data(var data : Dictionary, var profile : String = ""):
	
	create_folder()
	
	if profile == "":
		profile = "save"
	var thefile = File.new()
	thefile.open(res_user + folder_name + "/" + profile + ".sav", File.WRITE)
	
	thefile.store_line(to_json(data))
	thefile.close()
	
	if print_in_terminal:
		print("Saved:")
		print(str(data))

func edit_data(var profile : String = ""):
	
	create_folder()
	
	var thefile = File.new()
	var data = {}
	if profile == "":
		profile = "save"
	if (!thefile.file_exists(res_user + folder_name + "/" + profile + ".sav")):
		if print_in_terminal:
			print("the file doesn't exist yet, return empty dictionary")
	else:
		thefile.open(res_user + folder_name + "/" + profile + ".sav", File.READ)
		if !thefile.eof_reached():
			var almost_data = parse_json(thefile.get_line())
			if almost_data != null:
				data = almost_data
	return data
	



#This is modified by me (Can202), but the author is fractilegames
#GitHub: https://github.com/fractilegames/godot-screenshot-queue

#ScreenshotQueue.screenshot_snap(get_viewport())


var thread
var mutex
var queue = []
const MAX_QUEUE_LENGTH = 4

func _exit_tree():
	if thread.is_active():
		thread.wait_to_finish()


func screenshot_snap(var viewport : Viewport):
	
	_create_screenshots_folder()
	
	var dt = OS.get_datetime()
	var timestamp = "%04d%02d%02d%02d%02d%02d" % [dt["year"], dt["month"], dt["day"], dt["hour"], dt["minute"], dt["second"]]
	
	var image = viewport.get_texture().get_data()
	
	screenshot_save(image, S_res_user + screenshot_folder_name +"/screenshot-" + timestamp + ".png")


func screenshot_save(var image : Image, path : String):
	
	mutex.lock()
	
	if queue.size() < MAX_QUEUE_LENGTH:
		queue.push_back({"image" : image, "path" : path})
	else:
		if screenshot_print_in_terminal:
			print("Screenshot queue overflow")
	
	if queue.size() == 1:
		if thread.is_active():
			thread.wait_to_finish()
		thread.start(self, "worker_function")
	
	mutex.unlock()


func worker_function(_userdata):
	
	mutex.lock()
	while not queue.empty():
		var item = queue.front()
		mutex.unlock()
		
		if screenshot_print_in_terminal:
			print("Saving screenshot to " + item["path"])
		
		item["image"].flip_y()
		item["image"].save_png(item["path"])
		
		mutex.lock()
		queue.pop_front()
	
	mutex.unlock()


func _create_screenshots_folder():
	var path = Directory.new()
	if !path.dir_exists(S_res_user + screenshot_folder_name):
		path.open(S_res_user)
		path.make_dir(S_res_user + screenshot_folder_name)
		if print_in_terminal:
			print("making screenshots directory")

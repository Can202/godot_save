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
		

func create_folder(resuser : String,folder : String):
	var path = DirAccess
	if !path.dir_exists_absolute(resuser + folder):
		path.open(resuser)
		path.make_dir_absolute(resuser + folder)
		if print_in_terminal:
			print("making " + resuser + folder + " directory")

func save_data(data : Dictionary, profile : String = "save", typefile : String = ".sav"):
	
	create_folder(res_user, folder_name)
	
	if profile == "":
		profile = "save"
	var thefile = FileAccess.open(res_user + folder_name + "/" + profile + typefile, FileAccess.WRITE)
	thefile.store_line(JSON.stringify(data))
	thefile.close()
	
	if print_in_terminal:
		print("Saved: " + str(data))

func edit_data(profile : String = "save", typefile : String = ".sav"):
	
	create_folder(res_user, folder_name)
	
	
	var thedir = DirAccess
	var thefile = FileAccess
	var data = {}
	if profile == "":
		profile = "save"
	var path = str(res_user + folder_name + "/" + profile + typefile)
	if (!thefile.file_exists(path)):
		if print_in_terminal:
			print("the file doesn't exist yet, return empty dictionary")
	else:
		thefile = FileAccess.open(path, FileAccess.READ)
		if not thefile.eof_reached():
			var almost_data = JSON.parse_string(thefile.get_line())
			if almost_data != null:
				data = almost_data
	return data
	
func save_data_in_folder(data : Dictionary, resuser : String, folder : String, profile : String = "save", typefile : String = ".sav"):
	
	create_folder(resuser, folder)
	
	if profile == "":
		profile = "save"
	var thefile = DirAccess
	thefile.open(resuser + folder + "/" + profile + typefile)
	
	thefile.store_line(JSON.stringify(data))
	thefile.close()
	
	if print_in_terminal:
		print("Saved: " + str(data))

func edit_data_in_folder(resuser : String, folder : String, profile : String = "save", typefile : String = ".sav"):
	
	create_folder(resuser, folder)
	
	var thefile = FileAccess
	var thedir = DirAccess
	var data = {}
	if profile == "":
		profile = "save"
	var path = str(resuser + folder + "/" + profile + typefile)
	if (!thefile.file_exists(path)):
		if print_in_terminal:
			print("the file doesn't exist yet, return empty dictionary")
	else:
		thedir.open(path)
		if !thedir.eof_reached():
			var almost_data = JSON.parse_string(thedir.get_line())
			if almost_data != null:
				data = almost_data
	return data

func remove_data(profile : String = "save", typefile : String = ".sav"):
	var dir = DirAccess
	var path = str(res_user + folder_name + "/" + profile + typefile)
	dir.remove_absolute(path)
	if print_in_terminal:
		print(path + " removed")
func remove_data_in_folder(resuser : String, folder : String, profile : String = "save", typefile : String = ".sav"):
	var dir = DirAccess
	var path = str(resuser + folder + "/" + profile + typefile)
	dir.remove_absolute(path)
	if print_in_terminal:
		print(path + " removed")

#This is modified by me (Can202) & (Kingunner), but the author is fractilegames
#GitHub: https://github.com/fractilegames/godot-screenshot-queue

#ScreenshotQueue.screenshot_snap(get_viewport())


var thread:Thread
var mutex
var queue = []
const MAX_QUEUE_LENGTH = 4

func _exit_tree():
	if thread.is_active():
		thread.wait_to_finish()


func screenshot_snap(viewport : Viewport):
	
	create_folder(S_res_user, screenshot_folder_name)
	
	var dt = Time.get_datetime_dict_from_system()
	var timestamp = "%04d%02d%02d%02d%02d%02d" % [dt["year"], dt["month"], dt["day"], dt["hour"], dt["minute"], dt["second"]]
	
	var image = viewport.get_texture().get_image()
	
	screenshot_save(image, S_res_user + screenshot_folder_name +"/screenshot-" + timestamp + ".png")


func screenshot_save(image : Image, path : String):
	
	mutex.lock()
	
	if queue.size() < MAX_QUEUE_LENGTH:
		queue.push_back({"image" : image, "path" : path})
	else:
		if screenshot_print_in_terminal:
			print("Screenshot queue overflow")
	
	if queue.size() == 1:
		if thread.is_alive():
			thread.wait_to_finish()
		thread.start(Callable(self,"worker_function"))
	
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

extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_right"):
		$player.position.x += 200 * delta
	elif Input.is_action_pressed("ui_left"):
		$player.position.x += -200 * delta


func _on_screenshot_pressed():
	#take a screenshot
	Addonsave.screenshot_snap(get_viewport())
	
func _save():
	
	#get data
	var data = Addonsave.edit_data("save") #name can be "save, "settings", "ingame", "other", etc.
	
	#save information in data
	data.positionx = $player.position.x
	data.positiony = $player.position.y
	
	
	#save data
	Addonsave.save_data(data, "save")
func _load():
	
	#get data
	var data = Addonsave.edit_data("save")
	
	#Verify if the data is null, if it's null, give it a value
	if !data.has("positionx"):
		data.positionx = 480
	if !data.has("positiony"):
		data.positiony = 304
	
	#put the data information on variables
	$player.position.x = data.positionx
	$player.position.y = data.positiony
	
	#save data, cause maybe the data was modified
	Addonsave.save_data(data, "save")

func _on_save_pressed():
	_save()
func _on_load_pressed():
	_load()

extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Node2D/OptionButton.add_item("Low", 1)
	$Node2D/OptionButton.add_item("Medium", 2)
	$Node2D/OptionButton.add_item("High", 3)
	_load()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _save():
	var data = Addonsave.edit_data_in_folder("res://", "settings", "quality", ".txt")
	data["quality"] = $Node2D/OptionButton.selected
	data["activated"] = $Node2D/CheckButton.pressed
	Addonsave.save_data_in_folder(data, "res://", "settings", "quality", ".txt")
func _load():
	var data = Addonsave.edit_data_in_folder("res://", "settings", "quality", ".txt")
	if !data.has("quality"):
		data["quality"] = 1
	if !data.has("activated"):
		data["activated"] = false
	
	$Node2D/OptionButton.selected = data["quality"]
	$Node2D/CheckButton.pressed = data["activated"]
	Addonsave.save_data_in_folder(data, "res://", "settings", "quality", ".txt")


func _on_save_pressed():
	_save()


func _on_Button_pressed():
	Addonsave.remove_data_in_folder("res://", "settings", "quality", ".txt")

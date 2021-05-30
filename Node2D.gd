extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var prueba
var prueb2


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_up"):
		Save.screenshot_snap(get_viewport())

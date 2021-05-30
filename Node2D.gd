extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var prueba
var prueb2


# Called when the node enters the scene tree for the first time.
func _ready():
	var data = Savedata.edit_data()
	prueba = data.score
	if !data.has("f"):
		data.f = 2
	prueb2 = data.f
	data.score = 7
	data.df = 2
	Savedata.save_data(data)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

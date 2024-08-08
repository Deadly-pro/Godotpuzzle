extends Control

@export_file("npc1.json") var d_file

var dialouge
var current_dialouge_id=0

func _ready():
	start()
func start():
	dialouge=load_dialouge()
	current_dialouge_id=-1
	next_script()
func load_dialouge():
	var file=FileAccess.open("res://dialogues/npc1.json",FileAccess.READ)
	var content=JSON.parse_string(file.get_as_text())
	return content

func next_script():
	current_dialouge_id+=1
	if current_dialouge_id>=len(dialouge):
		return 
	NinePatchRect/

extends Control

@export_file("npc1.json") var d_file

var dialouge
var current_dialouge_id=0
var d_active=false
signal  dialouge_done

func _ready():
	$NinePatchRect.visible=false

func start():
	if d_active:
		return
	d_active=true
	
	$NinePatchRect.visible=true
	dialouge=load_dialouge()
	current_dialouge_id=-1
	next_script()

func load_dialouge():
	var file=FileAccess.open("res://dialogues/npc1.json",FileAccess.READ)
	var content=JSON.parse_string(file.get_as_text())
	return content

func _input(event):
	if !d_active:
		return
	if event.is_action_pressed("ui_accept"):
		next_script()

func next_script():
	current_dialouge_id+=1
	if current_dialouge_id>=len(dialouge):
		d_active=false
		$NinePatchRect.visible=false
		emit_signal("dialouge_done")
		return 
	$NinePatchRect/name.text=dialouge[current_dialouge_id]["name"]
	$NinePatchRect/chat.text=dialouge[current_dialouge_id]["chat"]

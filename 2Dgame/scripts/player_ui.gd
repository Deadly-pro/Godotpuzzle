extends Control

@export_file("test.json") var d_file
var dialouge
var dia
var current_dialouge_id=0
var d_active=false
signal  dialouge_done

func _ready():
	$NinePatchRect/instuction.text="Explore the Area"
	$NinePatchRect/name.visible=false
	$NinePatchRect/chat.visible=false
	$"../ColorRect".visible=false

func start(current_level,person):
	if d_active:
		return
	d_active=true
	$NinePatchRect/name.visible=true
	$NinePatchRect/chat.visible=true
	$"../ColorRect".visible=true
	dialouge=load_dialouge()
	dia=dialouge[current_level][person]
	current_dialouge_id=-1
	next_script()

func load_dialouge():
	var file=FileAccess.open("res://dialogues/test.json",FileAccess.READ)
	var content=JSON.parse_string(file.get_as_text())
	return content

func _input(event):
	if !d_active:
		return
	if event.is_action_pressed("ui_accept"):
		next_script()
func instruction(instr):
	$NinePatchRect/instuction.visible=true
	$NinePatchRect/instuction.text=instr
	
func dialouge_load(text):
	var content = text
	return content
func next_script():
	current_dialouge_id+=1
	if current_dialouge_id>=len(dia):
		d_active=false
		$NinePatchRect/name.visible=false
		$NinePatchRect/chat.visible=false
		$"../ColorRect".visible=false
		emit_signal("dialouge_done")
		return 
	$NinePatchRect/name.text=dia[current_dialouge_id]["name"]
	$NinePatchRect/chat.text=dia[current_dialouge_id]["chat"]

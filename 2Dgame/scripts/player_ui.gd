extends Control
var d_active=false
signal prompt_done
var current_id
var last_id
func _ready():
	$NinePatchRect/name.visible=false
	$NinePatchRect/chat.visible=false
func _input(event):
	if !d_active:
		return
	if event.is_action_pressed("ui_accept"):
		next_script()
func ui_pormpt(text):
	d_active=true
	$NinePatchRect/name.text=text["name"]
	$NinePatchRect/chat.text=text["chat"]
func next_script():
	emit_signal("prompt_done")
	if current_id!=last_id:
		await "display"
	else: 
	

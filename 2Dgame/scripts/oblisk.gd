extends Node2D
var in_range
var interacting
@export var current_opt=0
var all_options={"king":{1:["a fire","a beast","a child??"],2:["","",""],3:["","",""]},
"Agnis":[]}
@export var npc="king"
@export var selected_opt=0
signal selected
var cur_que=1
var option
func _ready():
	self.visible=false
	$Label.visible=false
	interacting=false

func _process(delta):
	if interacting:self.visible=true
	if in_range && interacting:
		$Label.text="[E] "+all_options[npc][cur_que][current_opt]
		$Label.visible=true
	else:
		$Label.visible=false
	if Input.is_action_just_pressed("interact")&& interacting:
		interacting=true
		emit_signal("selected")
func _on_interaction_area_body_entered(body):
	if body.has_method("_picked"):
		in_range=true

func _on_interaction_area_body_exited(body):
	if body.has_method("_picked"):
		in_range=false

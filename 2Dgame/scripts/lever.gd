extends StaticBody2D
@export var state ="Off"
@onready var area =%"interactable area"
@onready var gate= %gate

func _gate():
	if state=="Off":
		state="On"
		_setgate(state)
	elif state=="On":
		state="Off"
		_setgate(state)

# Called when the node enters the scene tree for the first time.
func _ready():
	area.interact= Callable(self,"_gate")

func _process(delta):
	pass
func _setgate(state):
	pass

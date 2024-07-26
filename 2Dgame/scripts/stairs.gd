extends Area2D
@export var entryindex:int = 0
@export var exitindex:int = 0
var prevbodyindex:int = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body: CharacterBody2D): 
	print("body detected")
	if body.z_index>=0:
		if body.z_index < prevbodyindex:
				body.z_index=prevbodyindex
		elif body.z_index < exitindex:
			body.z_index=exitindex
	else : body.z_index=3

	 

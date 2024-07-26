extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body: CharacterBody2D):
	if (body.velocity.x>0 || body.velocity.y>0):
			body.z_index-=10
	else: pass

func _on_body_exited(body: CharacterBody2D):
	if (body.velocity.x>0 || body.velocity.y>0):
			body.z_index+=10
	else: pass

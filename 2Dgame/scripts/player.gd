extends CharacterBody2D
signal done
var can_move=true
var inventory={"key":0,"coin":0}
var invsprdat={"heart":0,"power":1,"key":7}
const max_speed = 300.0
const friction = 1000.0
const accel =1500
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var input=Vector2.ZERO
func _physics_process(delta):
	player_movement(delta)

func get_input():
	input.x=int(Input.is_action_pressed("right"))-int(Input.is_action_pressed("left"))
	input.y=int(Input.is_action_pressed("downward"))-int(Input.is_action_pressed("forward"))
	return input.normalized()

func player_movement(delta):
	input=get_input()
	if input==Vector2.ZERO:
		if velocity.length()>(friction*delta):
			velocity-=velocity.normalized()*(friction*delta)
		else :
			velocity=Vector2.ZERO
	else:
		velocity+=(input*accel*delta)
		velocity=velocity.limit_length(max_speed)
	
	move_and_slide()

func _picked(item):
	match(item):
		"key": inventory["key"]+=1
		"coin":inventory["coin"]+=1
func dialouge(cl,pr):
	await $Camera2D/CanvasLayer/player_ui.start(cl,pr)
func _on_player_ui_dialouge_done():
	emit_signal("done")

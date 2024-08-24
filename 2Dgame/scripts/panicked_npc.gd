extends CharacterBody2D
const speed = 100
var is_moving=true
var is_chating=false
var in_range=false
@export var panic=true
var states=[
	"IDLE",
	"NEW_DIR",
	"MOVE"]

@export var current_state = "IDLE"
var dir=Vector2.LEFT
var start_pos
var prev_pos
# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.visible=false
	start_pos=position
	print("ready")

func _process(delta):
	if in_range && !is_chating:
		$Label.visible=true
	else:
		$Label.visible=false 
	if current_state == states[0] or current_state == states[1]:
		$AnimatedSprite2D.play("idle")
	elif current_state == states[2] and !is_chating:
		if dir.x == -1:
			$AnimatedSprite2D.flip_h=false
			$AnimatedSprite2D.play("walk_sd")
		elif dir.x == 1:
			$AnimatedSprite2D.flip_h=true
			$AnimatedSprite2D.play("walk_sd")
		elif dir.y == -1:
			$AnimatedSprite2D.play("walk_bk")
		elif dir.x == 1:
			$AnimatedSprite2D.play("walk_fr")
	if is_moving:
		is_chating=false
		match current_state:
			"IDLE":pass
			"NEW_DIR":dir=chose([Vector2.RIGHT,Vector2.LEFT,Vector2.DOWN,Vector2.UP]) 
			"MOVE": move(delta)
	if !is_chating:
		if Input.is_action_just_pressed("interact") && in_range:
			print("chatting")
			current_state="IDLE"
			await $"../player".dialouge("first_level","panicked_npc")
			is_chating=true
			is_moving=false

 
func chose(array):
	array.shuffle()
	current_state="MOVE"
	return array.front()

func move(delta):
	if !is_chating:
		if position!=prev_pos:
			prev_pos=position
			position += dir*speed*delta
		elif position==prev_pos:
			if current_state=="MOVE":
				current_state="NEW_DIR"
				prev_pos=Vector2(0,0) 
		move_and_slide()

func _on_interaction_area_body_entered(body):
	if body.has_method("_picked"):
		in_range=true

func _on_interaction_area_body_exited(body):
	if body.has_method("_picked"):
		in_range=false

func _on_timer_timeout():
	$Timer.wait_time=chose([0.5,0.25,0.15])
	current_state=chose(["IDLE","MOVE","NEW_DIR"])
	
func _on_player_done():
	is_chating=false
	is_moving=true
	_on_timer_timeout()

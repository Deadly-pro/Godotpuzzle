extends CharacterBody2D
const speed = 100
var is_moving=true
var is_chating=false
var in_range=false
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
	start_pos=position
	print("ready")

func _process(delta):
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
		match current_state:
			"IDLE":pass
			"NEW_DIR":dir=chose([Vector2.RIGHT,Vector2.LEFT,Vector2.DOWN,Vector2.UP]) 
			"MOVE": move(delta)
	elif !is_moving:
		if Input.is_action_just_pressed("interact"):
			print("chatting")
			is_chating=true
			 
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
		current_state="IDLE"
		in_range=true
		is_moving=false
		

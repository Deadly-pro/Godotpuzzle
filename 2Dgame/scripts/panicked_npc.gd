extends CharacterBody2D
var speed = 100
var is_moving=true
var is_chating=false
var in_range=false
@export var panic=true
var states=[
	"IDLE",
	"NEW_DIR",
	"MOVE"]

@export var current_state = "MOVE"
var dir=Vector2.LEFT
var start_pos
var prev_pos

func _ready():
	$panicked.visible=true
	current_state="MOVE"
	start_pos=position
	print("ready")

func _process(delta):
	if panic:
		speed=300
		$panicked.play("panicked")
	else:
		speed=100
		$panicked.visible=false
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


func _on_golem_peace():
	panic=false
	current_state="IDLE"

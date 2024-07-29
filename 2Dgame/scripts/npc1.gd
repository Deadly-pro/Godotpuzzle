extends CharacterBody2D
const speed = 100
var is_moving=true
var is_chating=false

var states=[
	"IDLE",
	"NEW_DIR",
	"MOVE"]

var current_state = "MOVE"
var dir=Vector2.RIGHT
var start_pos
# Called when the node enters the scene tree for the first time.
func _ready():
	start_pos=position

func _process(delta):
	if current_state == states[0] or current_state == states[1]:
		$AnimatedSprite2D.play("idle")
	elif current_state == states[2] and !is_chating:
		if dir.x == -1:
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
func chose(array):
	array.shuffle()
	return array.front()

func move(delta):
	if !is_chating:
		position += dir*speed*delta
		move_and_slide()

func _on_timer_timeout():
	$Timer.wait_time=chose([0.5,1,1.5])
	current_state=chose(["IDLE","NEW_DIR","MOVE"])

extends RichTextLabel

const SHAKE_DURATION = 0.1
const SHAKE_AMOUNT = 1.0
var shake_timer = 0.0
var original_position = global_position
@onready var camera = get_node("/root/scene/Camera2D")
func _ready():
	pass # Replace with function body.
func shake():
	shake_timer = SHAKE_DURATION
	original_position = global_position

func _process(delta):
	if shake_timer > 0:
		shake_timer -= delta
		print(shake_timer)
		var offset1 = Vector2(randf_range(-SHAKE_AMOUNT, SHAKE_AMOUNT), randf_range(-SHAKE_AMOUNT, SHAKE_AMOUNT))
		global_position = original_position + offset1
	elif text == "YOU DIED!" or text == "YOU WON!":
		global_position = camera.position - Vector2(43,0)
	else:
		global_position = camera.position - Vector2(150, 100)

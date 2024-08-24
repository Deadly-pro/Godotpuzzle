extends Node2D

@onready var label = get_node("Camera2D/Lable1")
@onready var is_shook = false
@onready var timer = $FlashTimer
@onready var retry_button = get_node("Camera2D/Button")

func _process(delta):
	update_label_text()
	if delta > 0.05:
		print("The game is lagging lol")

func _ready():
	retry_button.connect("pressed", _on_RetryButton_pressed)

func update_label_text():
	if timer.time_left > 0:
		label.set_text("Time remaining: %s" % timer.time_left)
	if timer.time_left < 10 and not is_shook:
		label.set_visible_characters(20)
		label.shake()
		is_shook = true


func _on_flash_timer_timeout():
	print_debug("Timer working!")
	label.set_text("YOUR SCORE: %s" % $prop_gen.last_level)
	label.add_theme_color_override("default_color", Color(0.0, 1.0, 0.0, 1.0))
	label.position = $Camera2D.position - Vector2(100, 0)
	$player.player_state = 420 

func game_set():
	var camera = get_node("/root/scene/Camera2D")
	$player.position = Vector2(0, -45)
	camera.set_camera()
	$player.player_state = 0
	
func _on_RetryButton_pressed():
	get_tree().reload_current_scene()

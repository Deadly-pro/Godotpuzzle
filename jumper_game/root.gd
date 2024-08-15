extends Node2D

@onready var label = get_node("Camera2D/Lable1")
@onready var is_shook = false
@onready var timer = $FlashTimer

func _process(delta):
	update_label_text()
	check_game_conditions(delta)

func update_label_text():
	if timer.time_left > 0:
		label.set_text("Time remaining: %s" % timer.time_left)
	if timer.time_left < 10 and not is_shook:
		label.set_visible_characters(20)
		label.shake()
		is_shook = true

func check_game_conditions(delta):
	if delta > 0.05:
		print("The game is lagging lol")
	if $player.position.y > 300 and $player.player_state != 420 and $player.player_state != 69:
		win()

func _on_flash_timer_timeout():
	print_debug("Timer working!")
	label.set_text("YOU DIED!")
	label.position = $Camera2D.position - Vector2(100, 0)
	$player.player_state = 420

func win():
	print_debug("You won!")
	label.set_text("YOU WON!")
	label.add_theme_color_override("default_color", Color(0.0, 1.0, 0.0, 1.0))
	timer.stop()
	$player.player_state = 69

func game_set():
	var camera = get_node("/root/scene/Camera2D")
	$player.position = Vector2(0, -45)
	camera.set_camera()
	$player.player_state = 0

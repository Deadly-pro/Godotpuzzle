extends Node2D
@onready var transition =$transition
func _process(delta):
	pass

func _on_player_ready():
	await get_tree().create_timer(1).timeout
	$player.dialouge("first_level","You")

func _on_portal_transition():
	transition.play("fade_out")
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://scenes/castle_lv_2.tscn")

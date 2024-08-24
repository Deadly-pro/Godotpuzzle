extends Node2D

func _process(delta):
	pass


func _on_player_ready():
	await get_tree().create_timer(1).timeout
	$player.dialouge("first_level","You")

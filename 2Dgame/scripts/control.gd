extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_lv_1_pressed():
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")


func _on_lv_2_pressed():
	get_tree().change_scene_to_file("res://scenes/castle_lv_2.tscn")

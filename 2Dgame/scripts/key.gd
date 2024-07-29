extends Area2D


func _on_body_entered(body:CharacterBody2D):
	print("key picked")
	body._picked("key")
	queue_free()

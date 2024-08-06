extends Area2D

func _on_body_entered(body:CharacterBody2D):
	if body.has_method("_picked"):
		print("key picked")
		body._picked("key")
		queue_free()
	else:pass

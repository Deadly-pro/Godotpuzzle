extends Area2D

func _on_body_entered(body:CharacterBody2D):
	if body.has_method("_picked"):
		print("gear picked")
		body._picked("gear")
		queue_free()
	else:pass

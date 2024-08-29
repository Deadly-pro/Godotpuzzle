extends Node2D
signal transition

func _on_interaction_area_body_entered(body):
	if body.has_method("_picked"):
		emit_signal("transition")

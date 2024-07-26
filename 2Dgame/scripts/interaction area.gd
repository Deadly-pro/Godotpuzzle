extends Area2D

class_name interaction_area

@export var action_name: String="interact"

var interact:Callable = func():pass

func _on_body_entered(body):
	InteractionManager.register(self)

func _on_body_exited(body):
	InteractionManager.unregister(self)

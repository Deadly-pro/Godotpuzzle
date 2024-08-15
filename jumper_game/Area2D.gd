extends Area2D

func _ready():
	connect("area_entered", self, "_on_Area2D_area_entered")

func _on_Area2D_area_entered(area):
	print("Collided with: ", area.name)
	# You can access any property or method of the collided node using `area`
	pass

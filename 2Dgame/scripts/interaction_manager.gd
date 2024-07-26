extends Node2D

@onready var player= get_tree().get_first_node_in_group("player")
@onready var label=$Label

const  text ="[E] to "
var active_areas=[]
var interact=true

func register(area:interaction_area):
	active_areas.push_back(area)

func unregister(area:interaction_area):
	var index=active_areas.find(area)
	if index!=-1:
		active_areas.remove_at(index)

func _process(delta):
	if active_areas.size()>0:
		active_areas.sort_custom(_sort_by_distance_to_player)
		label.text=text+active_areas.index[0].action_name
		label.global_position=active_areas.index[0].global_position
		label.global_position.y-=40
		label.global_position.x-=label.size.x/2
		label.show()
	else:
		label.hide()

func _sort_by_distance_to_player(area1,area2):
	var dis1=player.global_position.distance_to(area1.global_position)
	var dis2=player.global_position.distance_to(area2.global_position)
	return dis1 < dis2

func _input(event):
	if event.is_action_pressed("interact")&&interact:
		if active_areas.size()>0:
			interact=false
			label.hide()
			
			await active_areas[0].interact.call()
			interact=true

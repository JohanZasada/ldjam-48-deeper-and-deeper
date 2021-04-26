extends Node

onready var _Drill = get_tree().get_root().get_node("Main/RoomAssembly/Drill")

func get_target(body):
	for area in get_children():
		if area.overlaps_body(body):
			return area.get_node("Position3D")
	
	return _Drill # default

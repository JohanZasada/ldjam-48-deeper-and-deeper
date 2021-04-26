extends Control


func _ready():
	pass


func _on_Panel_gui_input(event):
	if event is InputEventMouseButton:
		get_tree().reload_current_scene()

extends Control


func _ready():
	$Popup2.popup()


func _on_Panel_gui_input(event):
	if event is InputEventMouseButton:
		get_tree().reload_current_scene()


func _on_StartPanet_gui_input(event):
	if event is InputEventMouseButton:
		get_tree().paused = false
		$Popup2.hide()

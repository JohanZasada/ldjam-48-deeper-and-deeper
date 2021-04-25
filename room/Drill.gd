extends Spatial

export var drill_material = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_DrillArea_body_entered(body):
	var ressource_node = body.get_node("./")
	if ressource_node.get_name() == "Player":
		drill_material = ressource_node.get("player_material")
		ressource_node.set("player_material", 0)

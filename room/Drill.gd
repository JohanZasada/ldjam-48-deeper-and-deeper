extends Spatial

export var material_interval = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	var material_timer = Timer.new()
	material_timer.set_wait_time(material_interval)
	material_timer.set_one_shot(false)
	material_timer.connect("timeout", self, "spawn_material")
	add_child(material_timer)
	material_timer.start()

func spawn_material():
	var drill = get_tree().get_root().get_node("Main/RoomAssembly/Drill/Spawn")
	var material_instance = load("res://room/BasicMaterial.tscn").instance()
	material_instance.transform.origin = drill.transform.origin
	get_tree().get_root().get_node("Main/RoomAssembly").add_child(material_instance)

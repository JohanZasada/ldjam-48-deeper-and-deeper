extends Spatial

export var material_interval = 2

onready var materialSpawn: Position3D = $MaterialSpawn

# Called when the node enters the scene tree for the first time.
func _ready():
	var material_timer = Timer.new()
	material_timer.set_wait_time(material_interval)
	material_timer.set_one_shot(false)
	material_timer.connect("timeout", self, "spawn_material")
	add_child(material_timer)
	material_timer.start()

func spawn_material():
	var material_instance = load("res://room/BasicMaterial.tscn").instance()
	material_instance.transform.origin = to_global(materialSpawn.translation)
	get_tree().get_root().get_node("Main/RoomAssembly").add_child(material_instance)

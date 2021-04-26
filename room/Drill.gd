extends Spatial

export var material_interval_max = 10
export var material_interval_min = 1
export var material_interval_step = 0.1
export var life = 1000
export var max_life = 1000

var total_material = 0

var material_timer
var material_interval

onready var materialSpawn: Position3D = $MaterialSpawn

# Called when the node enters the scene tree for the first time.
func _ready():
	material_interval = material_interval_max

	material_timer = Timer.new()
	material_timer.set_wait_time(material_interval)
	material_timer.set_one_shot(false)
	material_timer.connect("timeout", self, "spawn_material")
	add_child(material_timer)
	material_timer.start()

func spawn_material():
	if life > 0:
		var material_instance = load("res://room/BasicMaterial.tscn").instance()
		material_instance.transform.origin = to_global(materialSpawn.translation)
		material_instance.rotation = materialSpawn.rotation
		get_tree().get_root().get_node("Main/RoomAssembly").add_child(material_instance)
		total_material += 10
		
		material_interval -= material_interval_step
		if material_interval < material_interval_min:
			material_interval = material_interval_min
		material_timer.set_wait_time(material_interval)

func hit(amount):
	life -= amount
	update_hud()
	if life <= 0:
		var popup = get_tree().get_root().get_node("Main/Control/Popup")
		popup.popup()
		get_tree().paused = true

func repare(amount):
	var max_amount = max_life - life
	if amount > max_amount:
		amount = max_amount
	life += amount
	update_hud()
	return amount

func update_hud():
	var progress = get_tree().get_root().get_node("Main/Control/ProgressBar")
	var score = get_tree().get_root().get_node("Main/Control/Popup/ColorRect/Label2")
	progress.set("max_value", max_life)
	progress.set("value", life)
	score.set("text", "Score: %s" % total_material)

func get_enemies_target():
	return $EnemiesTarget

extends Spatial

export var speed = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	rotation.y += delta * speed

func set_bar_scale(bar_scale):
	set_scale(Vector3(scale.x, bar_scale, scale.z))

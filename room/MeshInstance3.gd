extends MeshInstance

export var speed = 1

# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	rotation.y += delta * speed

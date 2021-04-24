extends AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	get_animation("Idle").set_loop(true)
	get_animation("Run").set_loop(true)


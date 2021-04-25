extends KinematicBody

export var speed = 7
export var gravity = 75
export var acceleration = 15

var velocity = Vector3.ZERO

onready var camera = $Camera
onready var pivot = $Pivot
onready var animationTree = $Pivot/Mike/AnimationTree

const RUN_PARAM = "parameters/run_blend/blend_amount"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	# We create a local variable to store the input direction.
	var direction = Vector3.ZERO
	var da = delta * acceleration

	# We check for each move input and update the direction accordingly.
	direction.x += Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.z += Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	direction = direction.rotated(Vector3.UP, camera.rotation.y)
	
	if direction.length() < 0.2:
		direction = Vector3.ZERO

	if direction != Vector3.ZERO:
		if direction.length() > 1:
			direction = direction.normalized()
		pivot.look_at(translation + direction, Vector3.UP)
	
	animationTree.set(RUN_PARAM, lerp(animationTree.get(RUN_PARAM), direction.length(), da))
	
	# Ground velocity
	velocity.x = lerp(velocity.x, direction.x * speed, da)
	velocity.z = lerp(velocity.z, direction.z * speed, da)
	# Vertical velocity
	velocity.y -= gravity * delta
	# Moving the character
	velocity = move_and_slide(velocity, Vector3.UP)


func _on_Area_body_entered(body):
	print_debug(body.get_node("../").name)

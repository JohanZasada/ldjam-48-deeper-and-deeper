extends KinematicBody

# How fast the player moves in meters per second.
export var speed = 7
# The downward acceleration when in the air, in meters per second squared.
export var gravity = 75

var velocity = Vector3.ZERO

onready var camera = $Camera
onready var pivot = $Pivot

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	# We create a local variable to store the input direction.
	var direction = Vector3.ZERO

	# We check for each move input and update the direction accordingly.
	direction.x += Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.z += Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	direction = direction.rotated(Vector3.UP, camera.rotation.y)
	
	if direction != Vector3.ZERO:
		if direction.length() > 1:
			direction = direction.normalized()
		pivot.look_at(translation + direction, Vector3.UP)
	
	# Ground velocity
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	# Vertical velocity
	velocity.y -= gravity * delta
	# Moving the character
	velocity = move_and_slide(velocity, Vector3.UP)
	

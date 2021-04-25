extends KinematicBody

export var speed = 7
export var gravity = 75
export var acceleration = 15
export var jump_impulse = 22

var velocity = Vector3.ZERO

var material = 0
var energy = 0

onready var camera = $Camera
onready var pivot = $Pivot
onready var animationTree = $Pivot/Mike/AnimationTree

const RUN_PARAM = "parameters/run_blend/blend_amount"
const JUMP_PARAM = "parameters/jump_shot/active"
const JUMP_SCALE_PARAM = "parameters/jump_scale/scale"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	# We create a local variable to store the input direction.
	var direction = Vector3.ZERO
	var da = delta * acceleration
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y += jump_impulse
		animationTree.set(JUMP_PARAM, true)
		animationTree.set(JUMP_SCALE_PARAM, 1.7)

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
	var ressource_node = body.get_node("../")
	var ressource_type = ressource_node.get_name()

	if ressource_type == "MeshInstanceBasicMaterial":
		material += 1
		ressource_node.remove_child(self)
		ressource_node.queue_free()

	if ressource_type == "MeshInstanceBasicEnergy":
		energy += 1
		ressource_node.remove_child(self)
		ressource_node.queue_free()

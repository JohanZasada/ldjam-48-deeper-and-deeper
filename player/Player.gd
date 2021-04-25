extends KinematicBody


###############

export var player_material = 20

enum State {MOVE, PUNCH1, PUNCH2, PUNCH3}
var state = State.MOVE

export var speed = 10
export var gravity = 75
export var acceleration = 15
export var jump_impulse = 22
export var punch_move_speed = 2

func add_material(amount):
	player_material += amount
	update_label()

###############

var velocity = Vector3.ZERO
var direction_saved = Vector3.ZERO
var continue_punch = false

onready var camera = $Camera
onready var _Pivot = $Pivot
onready var animationTree = $Pivot/Mike/AnimationTree
onready var _TurretSpawn = $Pivot/TurretSpawn

const RUN_PARAM = "parameters/run_blend/blend_amount"
const JUMP_PARAM = "parameters/jump_shot/active"
const PUNCH1_PARAM = "parameters/punch1_shot/active"
const PUNCH2_PARAM = "parameters/punch2_shot/active"

# Called when the node enters the scene tree for the first time.
func _ready():
	animationTree.set("parameters/jump_scale/scale", 1.7)
	animationTree.set("parameters/punch1_scale/scale", 1.7)
	animationTree.set("parameters/punch2_scale/scale", 1.7)
	update_label()

func save_punch_direction(direction):
	if direction.length() > punch_move_speed:
		direction_saved = direction.normalized() * punch_move_speed
	else:
		direction_saved = direction

func _physics_process(delta):
	# Direction input
	var direction = Vector3.ZERO
	var da = delta * acceleration
	direction.x += Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.z += Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	direction = direction.rotated(Vector3.UP, camera.rotation.y)

	# Punch
	if state == State.PUNCH1:
		if not animationTree.get(PUNCH1_PARAM):
			if continue_punch:
				state = State.PUNCH2
				continue_punch = false
				save_punch_direction(direction)
				animationTree.set(PUNCH2_PARAM, true)
			else:
				state = State.MOVE
	elif state == State.PUNCH2:
		if not animationTree.get(PUNCH2_PARAM):
			state = State.MOVE
			continue_punch = false

	if Input.is_action_just_pressed("punch"):
		if state == State.MOVE:
			state = State.PUNCH1
			continue_punch = false
			save_punch_direction(direction)
			animationTree.set(PUNCH1_PARAM, true)
		elif state == State.PUNCH1:
			continue_punch = true

	# Move
	if state == State.PUNCH1 or state == State.PUNCH2:
		direction = direction_saved
		if direction != Vector3.ZERO:
			_Pivot.look_at(translation + direction, Vector3.UP)
	else:
		if direction != Vector3.ZERO:
			if direction.length() > 1:
				direction = direction.normalized()
			_Pivot.look_at(translation + direction, Vector3.UP)

		animationTree.set(RUN_PARAM, lerp(animationTree.get(RUN_PARAM), direction.length(), da))

		direction *= speed

	# Jump
	if state == State.MOVE and is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y += jump_impulse
		animationTree.set(JUMP_PARAM, true)

	# Ground velocity
	velocity.x = lerp(velocity.x, direction.x, da)
	velocity.z = lerp(velocity.z, direction.z, da)
	# Vertical velocity
	velocity.y -= gravity * delta
	# Moving the character
	velocity = move_and_slide(velocity, Vector3.UP)

func _on_Area_body_entered(body):
	if body.is_in_group("material"):
		add_material(5)
		body.get_owner().queue_free()

	if body.get_node("../").get_name() == "MeshInstanceBasicEnergy":
		add_material(1)
		body.get_owner().queue_free()

func _input(event):
	if event.is_action_pressed("use") and is_on_floor():
		if _TurretSpawn.get_overlapping_bodies().size() == 0:
			if player_material >= 3:
				add_material(-3)
				var turret = load("res://room/BasicTurret.tscn").instance()
				turret.global_transform.origin = _TurretSpawn.global_transform.origin
				turret.rotation.y = _Pivot.rotation.y
				get_tree().get_root().get_node("Main/RoomAssembly").add_child(turret)

func update_label():
	var label = get_tree().get_root().get_node("Main/Control/Label")
	label.set("text", "Material: %s" % player_material)

extends KinematicBody

############################

export var health = 100
export var max_health = 100

enum State { MOVE, ATTACK, DEAD }
var state = State.MOVE

export var speed = 5
export var gravity = 75
export var acceleration = 15
export var hit_amount = 10

############################

var body_attack = null

var velocity = Vector3.ZERO

onready var _Pivot = $Pivot
onready var _AnimationTree: AnimationTree = $AnimationTree
onready var _AttackArea: Area = $AttackArea
onready var _TargetArea: Area = $TargetArea
onready var _PunchTimer: Timer = $PunchTimer
onready var _Drill = get_tree().get_root().get_node("Main/RoomAssembly/Drill")
onready var _LifeBarRed = $LifeBarRed

const PARAM_DEAD = "parameters/dead_transition/current"
const PARAM_RUN = "parameters/run_blend/blend_amount"
const PARAM_SHOT = "parameters/punch_shot/active"

func hit(amount):
	if health <= 0:
		return

	health -= amount
	if health <= 0:
		health = 0
		state = State.DEAD
		_AnimationTree.set(PARAM_DEAD, 1)
		$CollisionShape.disabled = true
		$DeathTimer.start()
		_PunchTimer.stop()
	update_health_bar()

func set_victory():
	state = State.DEAD
	_AnimationTree.set(PARAM_DEAD, 2)
	

func _ready():
	_AnimationTree.set("parameters/hit_scale/scale", 1.0)
	_AnimationTree.set("parameters/punch_scale/scale", 1.0)
	_AnimationTree.set("parameters/run_scale/scale", 1.0)


func _physics_process(delta):
	var direction = Vector3.ZERO
	var da = delta * acceleration

	match state:
		State.MOVE:
			if not is_instance_valid(body_attack):
				body_attack = null

			if body_attack == null or body_attack == _Drill:
				for body in _TargetArea.get_overlapping_bodies():
					if body.is_in_group("turret"):
						body_attack = body.get_owner()
						break
				if body_attack == null:
					body_attack = _Drill

			var body_target = body_attack.get_enemies_target()
			var target_pos = to_local(body_target.global_transform.origin)
			target_pos.y = translation.y
			_Pivot.look_at(to_global(target_pos), Vector3.UP)
			direction = target_pos.normalized() * speed
			_AnimationTree.set(PARAM_RUN, 1.0)
			
			if _AttackArea.overlaps_area(body_target):
				state = State.ATTACK
		State.ATTACK:
			if body_attack == null or not is_instance_valid(body_attack):
				body_attack = null
				state = State.MOVE
			else:
				_AnimationTree.set(PARAM_RUN, 0.0)
				if not _AnimationTree.get(PARAM_SHOT):
					_AnimationTree.set(PARAM_SHOT, true)
					_PunchTimer.start()
		State.DEAD:
			return

	# Ground velocity
	velocity.x = lerp(velocity.x, direction.x, da)
	velocity.z = lerp(velocity.z, direction.z, da)
	# Vertical velocity
	velocity.y -= gravity * delta
	# Moving the character
	velocity = move_and_slide(velocity, Vector3.UP)


func _on_DeathTimer_timeout():
	queue_free()


func _on_PunchTimer_timeout():
	if body_attack == null or not is_instance_valid(body_attack):
		body_attack = null
		state = State.MOVE
	else:
		body_attack.hit(hit_amount)


func update_health_bar():
	_LifeBarRed.set_bar_scale(float(health) / max_health)
	if health <= 0 and is_instance_valid(_LifeBarRed):
		_LifeBarRed.queue_free()

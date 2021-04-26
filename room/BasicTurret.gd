extends Spatial

############################

export var health = 100.0
export var max_health = 150.0

enum State { SEARCH, ATTACK }
var state = State.SEARCH

############################

var body_tracked: PhysicsBody = null

export var life = 10.0

onready var _Pivot = $Pivot
onready var _attackArea: Area = $AttackArea
onready var _BulletStartPos = $Pivot/BulletStartPos
onready var _ShotTimer = $ShotTimer
onready var _Bullets = $Bullets
onready var _LifeBar = $LifeBar

onready var Bullet = preload("res://bullet/Bullet.tscn")

func _ready():
	_ShotTimer.stop()
	update_health_bar()

func _physics_process(_delta):
	match state:
		State.SEARCH:			
			body_tracked = null	
			for body in _attackArea.get_overlapping_bodies():
				if body.is_in_group("enemy"):
					body_tracked = body
			if body_tracked:
				state = State.ATTACK
				_ShotTimer.start()
		State.ATTACK:
			if not is_instance_valid(body_tracked) or not _attackArea.overlaps_body(body_tracked):
				state = State.SEARCH
				_ShotTimer.stop()
			else:
				var pos = body_tracked.global_transform.origin
				pos.y = _Pivot.global_transform.origin.y
				_Pivot.look_at(pos, Vector3.UP)

func _on_ShotTimer_timeout():
	var b = Bullet.instance()
	_Bullets.add_child(b)
	b.global_transform.origin = _BulletStartPos.global_transform.origin
	b.rotation.y = rotation.y + _Pivot.rotation.y

func hit(amount):
	health -= amount
	if health <= 0:
		health = 0
		queue_free()
	update_health_bar()

func repare(amount):
	var max_amount = max_health - health
	if amount > max_amount:
		amount = max_amount
	health += amount
	update_health_bar()
	return amount

func update_health_bar():
	_LifeBar.set_bar_scale(float(health) / max_health)

func get_enemies_target():
	return $EnemiesTarget

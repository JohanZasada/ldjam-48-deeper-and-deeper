extends Spatial

############################

export var health = 100

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

onready var Bullet = preload("res://bullet/Bullet.tscn")
var life_bare = load("res://hud/LifeBar.tscn").instance()

func _ready():
	_ShotTimer.stop()
	setup_life_hud()

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
	manage_life(0.2)
	
func setup_life_hud():
	print_debug("life bare setup")
	life_bare.transform.origin = Vector3(0, 2, 0)
	life_bare.rotation = Vector3(90, 0, 0)
	self.add_child(life_bare)
	
func _on_LifeArea_body_entered(body):
	if body.is_in_group("ennemy"):
		manage_life(1)

func manage_life(health):
	life -= health
	life_bare.scale.y = life / 10
	if life <= 0:
		self.queue_free()

func hit(amount):
	health -= amount
	if health <= 0:
		queue_free()

func get_enemies_target():
	return $EnemiesTarget

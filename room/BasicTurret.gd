extends Spatial

enum State { SEARCH, ATTACK }
var state = State.SEARCH
var body_tracked: PhysicsBody = null

export var life = 10.0

onready var _Pivot = $Pivot
onready var _attackArea: Area = $AttackArea
onready var _bulletStartPos = $Pivot/BulletStartPos
onready var _ShotTimer = $ShotTimer
onready var _dontMoveTimer = $DontMoveTimer
onready var _Bullets = $Bullets

onready var Bullet = preload("res://bullet/Bullet.tscn")
var life_bare = load("res://hud/LifeBar.tscn").instance()

func _ready():
	_ShotTimer.stop()
	setup_life_hud()

func _physics_process(_delta):
	match state:
		State.SEARCH:				
			for body in _attackArea.get_overlapping_bodies():
				if body.is_in_group("player"):
					body_tracked = body
			if body_tracked:
				state = State.ATTACK
				_ShotTimer.start()
		State.ATTACK:
			if not _attackArea.overlaps_body(body_tracked):
				state = State.SEARCH
				_ShotTimer.stop()
			else:
				var pos = body_tracked.global_transform.origin
				pos.y = _Pivot.global_transform.origin.y
				_Pivot.look_at(pos, Vector3.UP)

func _on_ShotTimer_timeout():
	var b = Bullet.instance()
	b.global_transform.origin = _bulletStartPos.global_transform.origin
	b.rotation.y = rotation.y + _Pivot.rotation.y
	_Bullets.add_child(b)
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
	

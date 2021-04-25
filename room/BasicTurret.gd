extends Spatial

enum State { SEARCH, ATTACK }
var state = State.SEARCH
var body_tracked: PhysicsBody = null

onready var _pivot = $Pivot
onready var _attackArea: Area = $AttackArea
onready var _bulletStartPos = $Pivot/BulletStartPos
onready var _shotTimer = $ShotTimer
onready var _Bullets = $Bullets

onready var Bullet = preload("res://bullet/Bullet.tscn")

func _ready():
	_shotTimer.stop()

func _physics_process(_delta):
	match state:
		State.SEARCH:				
			for body in _attackArea.get_overlapping_bodies():
				if body.is_in_group("player"):
					body_tracked = body
			if body_tracked:
				state = State.ATTACK
				_shotTimer.start()
		State.ATTACK:
			if not _attackArea.overlaps_body(body_tracked):
				state = State.SEARCH
				_shotTimer.stop()
			else:
				var pos = body_tracked.global_transform.origin
				pos.y = global_transform.origin.y
				_pivot.look_at(pos, Vector3.UP)

func _on_ShotTimer_timeout():
	var b = Bullet.instance()
	b.global_transform.origin = _bulletStartPos.global_transform.origin
	b.rotation.y = _pivot.rotation.y
	_Bullets.add_child(b)

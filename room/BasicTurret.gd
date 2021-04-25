extends Spatial

enum State { SEARCH, ATTACK }
var state = State.SEARCH
var body_tracked: PhysicsBody = null

onready var pivot = $Pivot
onready var attackArea: Area = $AttackArea
onready var laser = $Pivot/Laser
onready var laserStartPos = $Pivot/LaserStartPos

func _ready():
	laser.visible = true

func _physics_process(_delta):
	match state:
		State.SEARCH:
			laser.visible = false
				
			for body in attackArea.get_overlapping_bodies():
				if body.is_in_group("player"):
					body_tracked = body
			if body_tracked:
				state = State.ATTACK
		State.ATTACK:
			if not attackArea.overlaps_body(body_tracked):
				state = State.SEARCH
			else:
				var target_pos = pivot.to_local(body_tracked.global_transform.origin)
				
				# Orientation
				target_pos.y = pivot.translation.y
				pivot.look_at(pivot.to_global(target_pos), Vector3.UP)
				
				# Laser beam
				var start_pos = laserStartPos.translation
				target_pos.y = start_pos.y
				laser.height = (target_pos - start_pos).length()
				laser.translation.z = laserStartPos.translation.z - laser.height / 2
				laser.visible = true



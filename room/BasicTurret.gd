extends Spatial

enum State { SEARCH, ATTACK }
var state = State.SEARCH
var body_tracked = null

onready var pivot = $Pivot
onready var attackArea: Area = $AttackArea

func _physics_process(_delta):
	match state:
		State.SEARCH:
			for body in attackArea.get_overlapping_bodies():
				if body.is_in_group("player"):
					body_tracked = body
			if body_tracked:
				state = State.ATTACK
		State.ATTACK:
			if not attackArea.overlaps_body(body_tracked):
				state = State.SEARCH
			else:
				pivot.look_at(body_tracked.translation, Vector3.UP)



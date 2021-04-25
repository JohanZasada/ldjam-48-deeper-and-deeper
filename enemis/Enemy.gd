extends KinematicBody

export var health = 100

enum State { SEARCH, ATTACK }
var state = State.SEARCH

var body_attack: PhysicsBody = null

onready var pivot = $Pivot
onready var attackArea: Area = $AttackArea

func hit(delta):
	health -= delta

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Area_body_entered(body):
	pass # Replace with function body.

#
#func _physics_process(_delta):
#	match state:
#		State.SEARCH:				
#			for body in attackArea.get_overlapping_bodies():
#				if body.is_in_group("ennemy"):
#					body_attack = body
#			if body_attack:
#				state = State.ATTACK
#		State.ATTACK:
#			if not attackArea.overlaps_body(body_attack):
#				state = State.SEARCH
#			else:
#				var target_pos = pivot.to_local(body_attack.global_transform.origin)

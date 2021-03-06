extends RigidBody

const DAMAGE = 20
const SPEED = 500

func _ready():
	set_as_toplevel(true)
	
func _physics_process(delta):
	apply_impulse(transform.basis.z, -transform.basis.z * SPEED * delta) 

func _on_Bullet_body_entered(body):
	if body.is_in_group("enemy"):
		body.hit(DAMAGE)
	queue_free()


func _on_KillTimer_timeout():
	queue_free()

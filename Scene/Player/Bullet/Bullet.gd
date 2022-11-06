extends Area

export var speed = 40
export var damage = 50

func _physics_process(delta):
	translation += global_transform.basis.z * speed * delta

func _on_Bullet_body_entered(body):
	queue_free()
	if body.is_in_group("Enemy"):
		body.health -= damage
		queue_free()

extends Node3D

const SPEED : float = 25.0

var has_shot = false
var damage = 10.0
var direction

func hit(body):
	has_shot = true
	for i in self.get_children():
		if not i is GPUParticles3D:
			i.queue_free()
	if body.is_in_group("player"):
		body.take_damage(damage)
		body.cam.apply_shake()
	damage = 0
	$GPUParticles3D.emitting = true
	await get_tree().create_timer(0.2).timeout
	queue_free()


func _process(delta):
	direction = Vector3.ZERO
	
	direction -= transform.basis.z
	self.position += (direction * SPEED) * delta



func _on_area_3d_body_entered(body):
	if not has_shot:
		hit(body)

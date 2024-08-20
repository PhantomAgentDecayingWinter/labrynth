extends Node3D

@onready var Meshes = $Meshes
@onready var particles = $GPUParticles3D
var health_increase = 15

func _process(_delta):
	if Meshes != null:
		Meshes.rotate_y(deg_to_rad(1))

func pickup_success(): #Add FX later
	particles.emitting = true
	await get_tree().create_timer(1).timeout
	queue_free() 

func picked_up(body: Node3D):
	if body.is_in_group("player"):
		$pickup_area.queue_free()
		$Meshes.queue_free()
		pickup_success()
		for i in range(15):
			body.hp += 1
			await get_tree().create_timer(0.003).timeout


func _on_pickup_area_body_entered(body):
	picked_up(body)

extends CharacterBody3D

var dead = false
var speed: float = 1.0
@onready var agent = $NavigationAgent3D 
@onready var gun = $gun
@onready var shoot_view = $gun/RayCast3D
@onready var particles = $GPUParticles3D
var move_state
var damage = 10.0
var bullet: PackedScene = preload("res://scenes/bullet.tscn")
var target : Node3D
var can_shoot : bool = false
var hp: float = 15

func take_damage(dmg):
	hp -= dmg
	if hp <= 0:
		die()


func die():
	dead = true
	move_state = "nah neither"
	can_shoot = false
	$gun.queue_free()
	$detection_range.queue_free()
	$gun_range.queue_free()
	$CollisionShape3D.queue_free()
	$MeshInstance3D.queue_free()
	damage = 0
	speed = 0
	particles.emitting = true
	await get_tree().create_timer(1).timeout
	queue_free()

func _ready():
	agent.velocity_computed.connect(Callable(_on_velocity_computed))

func shoot():
	if dead != true:
		
		can_shoot = false
		move_state = "ZERO"
		speed = 0
		await get_tree().create_timer(0.15).timeout
		
		var new = bullet.instantiate()
		
		self.get_parent().add_child(new)
		
		# Setting the location, rotation and scale
		
		if new != null and gun != null and gun.get_child(0) != null:
			new.global_position = $gun/Node3D.global_position
			new.global_rotation = $gun/Node3D.global_rotation
			
		await get_tree().create_timer(0.1).timeout
		
		move_state = true
		
		await get_tree().create_timer(1).timeout
		
		can_shoot = true
		move_state = false


func set_movement_target(target_pos : Vector3):
	agent.set_target_position(target_pos)
	
func _physics_process(delta):
	
	randomize()
	
	if dead != true:
		if target != null:
			self.look_at(target.position)
			
			self.rotate_y(deg_to_rad(180))
			
			self.rotation.x = 0.0
			
			self.rotation.z = 0.0
			
			gun.look_at(target.position)

			if not can_shoot:
				await get_tree().create_timer(0.1).timeout
				
				if target != null:
					set_movement_target(target.position)
					
			elif can_shoot:
				shoot()
				move_state = false
				
			if not move_state:
				speed = 1.5
				
			if move_state:
				can_shoot = false
				speed = 5.0
				
		if target != null:
			await get_tree().create_timer(0.1).timeout
		
			if target != null:
				set_movement_target(target.position)
				
		var next_path_position : Vector3
		
		if agent != null: 
			if agent.is_navigation_finished():
				return
	
			next_path_position = agent.get_next_path_position()
			
			var new_velocity : Vector3 = global_position.direction_to(next_path_position) * speed
			
			if agent.avoidance_enabled:
				agent.velocity = new_velocity
				
			else:
				_on_velocity_computed(new_velocity)

func _on_velocity_computed(safe_velocity: Vector3):
	velocity = safe_velocity
	move_and_slide()


func _on_detection_range_body_entered(body):
	if body.is_in_group("player"):
		target = body
		move_state = true

func _on_gun_range_body_exited(body):
	if body.is_in_group("player"):
		can_shoot = false
		move_state = true


func _on_gun_range_body_entered(body):
	if body.is_in_group("player"):
			can_shoot = true
			move_state = false

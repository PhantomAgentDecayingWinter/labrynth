extends Node3D


var weapon_type := 1
@onready var anim_player = $AnimationPlayer
var damage = 5
var can_shoot = true
func _ready():
	randomize()
func _process(_delta):

	if Input.is_action_just_pressed("e"):
		weapon_type += 1
		if weapon_type == 4:
			weapon_type = 1
	elif Input.is_action_just_pressed("q"):
		weapon_type -= 1
		if weapon_type == 0:
			weapon_type = 3
	if Input.is_action_just_pressed("fire1"):
		fire()
func fire():
	if can_shoot:
		can_shoot = false
		anim_player.play("shoot")
		for i in $Node3D.get_children():
			i.force_raycast_update()

			i.rotation.y = deg_to_rad(randi_range(-7, 7))
			i.rotation.z = deg_to_rad(randi_range(-7, 7))
			if i.is_colliding():
				draw.line(i.global_position, i.get_collision_point(), Color.YELLOW, 0.005)
				if i.get_collider().is_in_group("enemy"):
					i.get_collider().take_damage(damage / 3)
				for r in $Node3D.get_children():
					r.force_raycast_update()
					if r.is_colliding():
						if r.get_collider().is_in_group("enemy"):
							var enemy = r.get_collider()
							var particles = enemy.particles.duplicate()
							particles.emitting = true
							self.get_parent().add_child(particles)
							particles.global_position = enemy.global_position
							break
			elif not i.is_colliding():
				draw.line(i.global_position, i.get_child(0).global_position, Color.YELLOW, 0.005)
		await get_tree().create_timer(1).timeout
		can_shoot = true

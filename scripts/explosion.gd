extends Node3D

@onready var anim_player = $AnimationPlayer
@onready var explosion_sound = $AudioStreamPlayer3D
@onready var explosion_cast = $ShapeCast3D
@onready var debris = $GPUParticles3D

var plr_explosion_dmg = 25.0
var enemy_explosion_dmg = 60.0

func explode():
	explosion_cast.force_shapecast_update()
	debris.emitting = true
	anim_player.play("bang")
	explosion_sound.play()
	for i in range(explosion_cast.get_collision_count()):
		var obj = explosion_cast.get_collider(i)
		if obj.is_in_group("enemy"):
			# blood
			var new = obj.particles
			self.get_parent().add_child(new)
			new.global_position = obj.global_position
			
			new.amount = 100
			new.emitting = true
			obj.take_damage(enemy_explosion_dmg)
		if obj is Player:
			obj.take_damage(plr_explosion_dmg)
			var force = Vector3.ZERO
			force = (-(global_position - obj.global_position) * 5)
			
			force = clamp(force, -Vector3(50,50,50), Vector3(50,50,50))
			
			
			obj.velocity = force
	$ShapeCast3D.queue_free()
	
	await get_tree().create_timer(0.4).timeout
	$MeshInstance3D.queue_free()
	await get_tree().create_timer(4.6).timeout
	queue_free()

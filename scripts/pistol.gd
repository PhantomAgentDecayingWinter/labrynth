extends Node3D

var can_shoot = true
const fire_rate = 0.5
@onready var player = $AnimationPlayer2
@onready var cast = $"../../global_cast"
@onready var area_cast = $"../../global_cast_area3D"
@onready var muzzle = $muzzle
var hit : PackedScene = preload("res://scenes/hit.tscn")

const DAMAGE = 30

func shoot():
	player.play("shoot")
	can_shoot = false
	
	draw.line(muzzle.global_position, $forward.global_position, Color.YELLOW, 0.01)
	
	if area_cast.is_colliding():
		var collider = area_cast.get_collider()
		area_cast.get_collider().get_parent().explode()
	
	if cast.is_colliding():
		var b = hit.instantiate()
		get_tree().get_root().add_child(b)       ##  *this line preserves scale of decal too! *
		b.global_transform.origin = cast.get_collision_point()
		var surface_dir_up = Vector3(0,1,0)
		var surface_dir_down = Vector3(0,-1,0)
		if cast.get_collision_normal() == surface_dir_up:
			b.look_at(cast.get_collision_point() + cast.get_collision_normal(), Vector3.RIGHT)
		elif cast.get_collision_normal() == surface_dir_down:
			b.look_at(cast.get_collision_point() + cast.get_collision_normal(), Vector3.RIGHT)
		else:
			b.look_at(cast.get_collision_point() + cast.get_collision_normal(), Vector3.DOWN)
		b.rotate_z(deg_to_rad(90))

		if cast.get_collider().is_in_group("enemy"):
			cast.get_collider().take_damage(DAMAGE)
			var enemy = cast.get_collider()
			var particles = enemy.particles.duplicate()
			particles.emitting = true
			self.get_parent().get_parent().add_child(particles)
			particles.global_position = enemy.global_position
		

		await get_tree().create_timer(0.2).timeout
		b.queue_free()
	await get_tree().create_timer(0.3).timeout
	can_shoot = true



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("fire1"):
		if can_shoot: shoot()

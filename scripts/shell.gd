extends RigidBody3D

var explosion : PackedScene = preload("res://scenes/explosion.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func explode():
		var new = explosion.instantiate()
		self.get_parent().add_child(new)
		new.global_position = self.global_position
		new.explode()
		queue_free()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if $ShapeCast3D.is_colliding():
		for i in $ShapeCast3D.collision_result.size():
			var collider = $ShapeCast3D.get_collider(i)
			if not collider is Player:
				explode()

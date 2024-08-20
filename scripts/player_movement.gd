extends CharacterBody3D
class_name Player
#normal vars
var direction : Vector3

#onready vars
@onready var head : Node3D = $Head
@onready var canvas = $CanvasLayer
@onready var p_collision = $CollisionShape3D

@onready var cam = $Head/Camera3D


var hp = 85
var SENSITIVITY: float = 0.2


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
func take_damage(damage : float):
	for i in range(int(damage)):
		hp -= 1
		if hp <= 0:
			self.position.z = lerp(self.position.z, 12345.0, 1.0)

		canvas.get_child(0).scale = Vector2(1.5, 1.5)
		await 0.05



func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * SENSITIVITY))
		head.rotate_x(deg_to_rad(-event.relative.y * SENSITIVITY))
		
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-75), deg_to_rad(75))
		
#Movement variables

const MAX_SPEED := 100.0
const MAX_SPEED_AIR := 25.0
var GROUND_ACCEL := 45.0
var AIR_ACCEL := 15
var FRICTION := 3.5
const JUMP_VELOCITY := 4.5

var is_sliding := false
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 9.8


func _process(delta):
	if Input.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _physics_process(delta):
	p_collision.shape.height = clamp(p_collision.shape.height, 1.75, 1.8)
	head.position.y = clamp(head.position.y, 0.4, head.position.y)
	var speed = velocity.length()

	canvas.get_child(0).text = "HP : " + str(Math.round(hp, 0)) ## HP counter

	canvas.get_child(0).scale = lerp(canvas.get_child(0).scale, Vector2(1,1), 100 * delta) ## HP reduce juice
	
	canvas.get_child(1).text = str(Math.round(speed, 2)) ## Speed counter
	if is_on_floor():
		slide(delta)
		gravity = 9.8
		
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_VELOCITY
			is_sliding = false
			return
		velocity = accelerate(direction, delta, GROUND_ACCEL, MAX_SPEED)
		
		#Apply friction
		
		if speed != 0:
			var drop = speed * FRICTION * delta
			velocity *= max(speed - drop, 0) / speed
	else:
		p_collision.shape.height = lerpf(p_collision.shape.height, 1.8, 0.5)
		if Input.is_action_just_pressed("ctrl"):
			gravity = 50.0
		velocity = accelerate(direction, delta, AIR_ACCEL, MAX_SPEED_AIR)
		velocity.y -= gravity * delta
	move_and_slide()

	# Get the input direction and handle the movement/deceleration.

	var input_dir = Input.get_vector("left", "right", "forward", "back")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

func accelerate(dir, delta, accel_type, max_velocity):
	var proj_vel = velocity.dot(dir)
	var accel_vel = accel_type * delta

	if (proj_vel + accel_vel > max_velocity):
		accel_vel = max_velocity - proj_vel

	return velocity + (dir * accel_vel)

func slide(delta: float, crouchspeed := 5):
	p_collision.shape.height -= crouchspeed * delta

	
	## Clamping heights
	
	p_collision.shape.height = clamp(p_collision.shape.height, 1.75, 1.8)

	
	
	
	GROUND_ACCEL = 90.0

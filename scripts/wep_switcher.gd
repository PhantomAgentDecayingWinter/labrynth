extends Node3D

var weapons = []
@onready var player = $"../.."
var default_position : Vector3 = Vector3.ZERO

func init():
	for i in self.get_children():
		weapons.append(i)

func _ready():
	init()

func change_state(state : bool, obj : Node3D):
	for object in obj.get_children():
		if object is AudioStreamPlayer3D and state == false:
			object.stop()
		else:
			pass
	obj.set_process(state)
	obj.set_physics_process(state)
	obj.set_visible(state)
func _process(_delta):

	
	
	
	if Input.is_action_pressed("1"):
		for i in weapons:
			change_state(false, i)
		change_state(true, weapons[0])
	if Input.is_action_pressed("2"):
		for i in weapons:
			change_state(false, i)
		change_state(true, weapons[1])
	if Input.is_action_just_pressed("3"):
		for i in weapons:
			change_state(false, i)
		change_state(true, weapons[2])

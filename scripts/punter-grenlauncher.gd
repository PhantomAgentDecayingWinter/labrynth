extends Node3D

@export var damage = 25
@export var fire_rate = 1
@export var speed = 150

var can_shoot = true
var shell: PackedScene = preload("res://scenes/shell.tscn")

@onready var animator = $AnimationPlayer
@onready var muzzle = $muzzle
@onready var player = $"../../../.." ## Player according to current hierarchy

func shoot():
	can_shoot = false
	animator.play("shoot")
	var bullet = shell.instantiate()
	player.get_parent().add_child(bullet)
	bullet.global_position = muzzle.global_position
	var vector: Vector3 = Vector3.ZERO
	bullet.apply_force(-$"../..".global_transform.basis.z * speed)
	bullet.apply_force(player.direction * 25)
	await get_tree().create_timer(1.1).timeout
	can_shoot = true



func _process(_delta):
	if can_shoot and Input.is_action_just_pressed("fire1"):
		shoot()

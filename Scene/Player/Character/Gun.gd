extends Spatial

#   GUN
var current_Weapon = 1
onready var Gun1 = $head/hand/Gun1
onready var Gun2 = $head/hand/Gun2
onready var Gun3 = $head/hand/Gun3

onready var damage = 100
onready var Aim = $head/FPS/Kamera/Aim
onready var Gun1Muzzle = $head/hand/Gun1/Gun1Muzzle
onready var Gun2Muzzle = $head/hand/Gun2/Gun2Muzzle
onready var Gun3Muzzle = $head/hand/Gun3/Gun3Muzzle

onready var bulletscene = preload("res://Scene/Player/Bullet/Bullet.tscn")
onready var Grenade = preload("res://Scene/Player/Bullet/Grenade/Grenade.tscn")
const GRENADE_LAUNCH_SPEED = 20

onready var Ammo = 12
var can_shoot = true

func _ready():
	pass


func Weapon():
	if Input.is_action_just_pressed("weapon1"):
		current_Weapon = 1
		print("WEAPON1")
	if Input.is_action_just_pressed("weapon2"):
		current_Weapon = 2
		print("WEAPON2")
	if Input.is_action_just_pressed("weapon3"):
		current_Weapon = 3
		print("WEAPON3")
	
	if current_Weapon == 1:
		Gun1.show()
		if Input.is_action_just_pressed("fire"):
			Pistol_Shoot()
	else:
		Gun1.hide()
	if current_Weapon == 2:
		Gun2.show()
		if Input.is_action_pressed("fire"):
			Assault_Shoot()
	else:
		Gun2.hide()
	if current_Weapon == 3:
		Gun3.show()
		if Input.is_action_just_pressed("fire"):
			Grenade_Shoot()
	else:
		Gun3.hide()

func Pistol_Shoot():
	if can_shoot == true:
		var bullet = bulletscene.instance()
		get_parent().add_child(bullet)
		bullet.global_transform = Gun1Muzzle.global_transform
		bullet.scale = Vector3.ONE
		Ammo -= 1
		can_shoot = false
		$PistolWaitTime.start()

func Assault_Shoot():
	if can_shoot == true:
		var bullet = bulletscene.instance()
		get_parent().add_child(bullet)
		bullet.global_transform = Gun2Muzzle.global_transform
		bullet.scale = Vector3.ONE
		Ammo -= 1
		can_shoot = false
		$AssaultWaitTime.start()

func Grenade_Shoot():
	var new_bullet = Grenade.instance()
	get_tree().root.add_child(new_bullet)
	new_bullet.global_transform = Gun3Muzzle.global_transform
	new_bullet.linear_velocity = new_bullet.global_transform.basis.z * GRENADE_LAUNCH_SPEED

extends KinematicBody

var gravity = 30.0
var direction = Vector3()
var velocity = Vector3.ZERO
var snap = Vector3.DOWN

export var speed = 18

var jump_count = 0
export var Jump_max = 2
export var jump_height = 17

onready var head = get_node("head")
onready var Cam = get_node("head/Kamera")
onready var body = get_node("player_mesh")
onready var WeaponCam = get_node("head/Kamera/ViewportContainer/Viewport/WeaponCam")

#   GUN
var current_Weapon = 0
var can_shoot = true
onready var Ammo = 12
onready var Guns = get_tree().get_nodes_in_group("GUN")
onready var BulletDecal = preload("res://Scene/Player/Decal/BulletDecal.tscn")

onready var damage = 100
onready var Aim = get_node("head/Kamera/Aim")
onready var Muzzle = get_node("head/WeaponHolder/hand/Muzzle")
onready var GunTimer = get_node("head/WeaponHolder/hand/GunTimer")

onready var bulletscene = preload("res://Scene/Player/Bullet/Bullet.tscn")
onready var Grenade = preload("res://Scene/Player/Bullet/Grenade/Grenade.tscn")
export var GRENADE_LAUNCH_SPEED = 20


func _ready():
	var WeaponViewPort = get_node("head/Kamera/ViewportContainer/Viewport")
	WeaponViewPort.size = OS.window_size

func _process(delta):
	Locomotion(delta)
	Weapon()
	WeaponCam.global_transform = Cam.global_transform
	body.rotation.y = lerp(body.rotation.y, head.rotation.y,0.1)

func Locomotion(delta):
	direction = Vector3.ZERO
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.z = Input.get_action_strength("backward") - Input.get_action_strength("forward")
	direction = direction.rotated(Vector3.UP,head.rotation.y).normalized()
	
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	velocity.y -= gravity * delta
	
	var just_landed = is_on_floor() and snap == Vector3.ZERO
	
	if is_on_floor() and jump_count != 0:
		jump_count = 0
	elif just_landed:
		snap = Vector3.DOWN
	velocity = move_and_slide_with_snap(velocity,snap,Vector3.UP,true)
	
	if jump_count < Jump_max:
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_height
			jump_count += 1
			snap = Vector3.ZERO

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			match event.button_index:
				BUTTON_WHEEL_UP:
					current_Weapon += 1
					pass
				BUTTON_WHEEL_DOWN:
					current_Weapon -= 1
					pass

func Weapon():
	current_Weapon = clamp(current_Weapon,0,2)
	
	for i in range(0,Guns.size()):
		if i == current_Weapon:
			Guns[i].visible = true
			if can_shoot == true:
				if i == 1:
					if Input.is_action_pressed("shoot"):
						Shoot()
						get_node("head").shake(0.2,.04)
						if Aim.is_colliding():
							DecalSpawn()
				if Input.is_action_just_pressed("shoot"):
					if i == 0:
						Shoot()
						get_node("head").shake(0.2,.01)
						if Aim.is_colliding():
							DecalSpawn()
					if i == 2:
						Grenade_Shoot()
						get_node("head").shake(0.2,.015)
		else:
			Guns[i].visible = false

func Shoot():
	var bullet = bulletscene.instance()
	get_parent().add_child(bullet)
	bullet.global_transform = Muzzle.global_transform
	bullet.scale = Vector3.ONE
	Ammo -= 1
	can_shoot = false
	if current_Weapon == 0:
		GunTimer.wait_time = 0.25
		GunTimer.start()
	elif current_Weapon == 1:
		GunTimer.wait_time = 0.1
		GunTimer.start()

func Grenade_Shoot():
	var new_bullet = Grenade.instance()
	get_tree().root.add_child(new_bullet)
	new_bullet.global_transform = Muzzle.global_transform
	new_bullet.linear_velocity = new_bullet.global_transform.basis.z * GRENADE_LAUNCH_SPEED

func DecalSpawn():
	var BH = BulletDecal.instance()
	Aim.get_collider().add_child(BH)
	BH.global_transform.origin = Aim.get_collision_point()
	
	var Surface_dir_Up = Vector3(0,1,0)
	var Surface_dir_Down = Vector3(0,-1,0)
	
	if Aim.get_collision_normal() == Surface_dir_Up:
		BH.look_at(Aim.get_collision_point() + Aim.get_collision_normal(),Vector3.RIGHT)
	elif Aim.get_collision_normal() == Surface_dir_Down:
		BH.look_at(Aim.get_collision_point() + Aim.get_collision_normal(),Vector3.RIGHT)
	else:
		BH.look_at(Aim.get_collision_point() + Aim.get_collision_normal(),Vector3.DOWN)

func _on_GunTimer_timeout():
	can_shoot = true

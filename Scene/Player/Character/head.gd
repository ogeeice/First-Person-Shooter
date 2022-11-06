extends Spatial

onready var camera = get_parent().Cam

var shake_amount = 55
onready var default_translation = get_node("Kamera").translation
onready var tween = get_node("Kamera/ShakeTween")
onready var timer = get_node("Kamera/Shake")

func _ready():
	set_process(false)
	randomize()

func _input(event):
#   ROTATION
	if event is InputEventMouseMotion:
		rotation_degrees.x = clamp(rotation_degrees.x-event.relative.y * 0.1,-70,70)
		rotation_degrees.y -= event.relative.x * 0.1

func _process(_delta):
	get_node("Kamera").translation = Vector3(rand_range(-1,1) * shake_amount,rand_range(-1,1) * shake_amount,rand_range(0,0) * shake_amount)

func shake(time,amount):
	timer.wait_time = time
	shake_amount = amount
	set_process(true)
	timer.start()

func _on_Shake_timeout():
	set_process(false)
	tween.interpolate_property(get_node("Kamera"),'translation', get_node("Kamera").translation, default_translation, 0.1, 6, 2)

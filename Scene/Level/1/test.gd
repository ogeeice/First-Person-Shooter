extends Spatial

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(_event):
	if Input.is_action_just_pressed("reload"):
		if get_tree().reload_current_scene() != OK:
			print("ERROR RELOADING SCENE")

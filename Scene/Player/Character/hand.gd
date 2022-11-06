extends Spatial

var Mouse_mov
var Sway_Threashold = 5
var Sway_Lerp = 5

export var SwayLeft : Vector3
export var SwayRight : Vector3
export var SwayNormal : Vector3

func _input(event):
	if event is InputEventMouseMotion:
		Mouse_mov = -event.relative.x

func _process(delta):
	if Mouse_mov != null:
		if Mouse_mov > Sway_Threashold:
			rotation = rotation.linear_interpolate(SwayLeft,Sway_Lerp * delta)
		elif Mouse_mov < Sway_Threashold:
			rotation = rotation.linear_interpolate(SwayRight,Sway_Lerp * delta)
		else:
			rotation = rotation.linear_interpolate(SwayNormal,Sway_Lerp * delta)

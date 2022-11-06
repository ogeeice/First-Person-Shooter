extends KinematicBody

var velocity = Vector3()

export var gravity = -27
onready var player : Node = get_node("/root/Test/Player")
export var moveSpeed = 8


export (float) var distancePatrolRight = 5;
export (float) var velocityMax = 3.0; 
var sideRotation = 1;
var angleRotation =0;  
var originPosition; 
var mesh; 

var follow = false

func _process(delta):
	
	if follow == false:
		patrol(delta);
	
	if follow == true:
		var dir = (player.translation - translation).normalized()
		$AnimationPlayer.play("Bounce")
		 # move the enemy towards the player
		velocity.y += gravity * delta
		velocity = move_and_slide(dir * moveSpeed,Vector3(0,1,0))



func _ready():
	#setup_animations();
	originPosition = global_transform.origin; 
	
#	mesh = get_node("model");


func patrol(delta):
#	rotationMesh(delta); 
	
	var newPosX = sideRotation * delta * moveSpeed;
		
	global_transform.origin.x += newPosX;
	if(sideRotation == 1.0 && global_transform.origin.x > (originPosition.x+distancePatrolRight)):
		sideRotation = -1;
		angleRotation = -180;
			
	if(sideRotation == -1.0 && global_transform.origin.x < originPosition.x):
		sideRotation = 1;
		angleRotation = 180; 



#func rotationMesh(delta): 
#		if(angleRotation>0):
#			mesh.rotate_y(deg2rad(delta*500));
#			angleRotation -= delta*500;
#			if(angleRotation<=0):
#				angleRotation = 0 ;
#
#		if(angleRotation<0):
#			mesh.rotate_y(deg2rad(-delta*500));
#			angleRotation += delta*500;
#			if(angleRotation>=0):
#				angleRotation = 0 ;


func _on_detect_body_entered(body):
	if body.name == "Player":
		follow = true
	pass # Replace with function body.


func _on_detect_body_exited(body):
	if body.name == "Player":
		yield(get_tree().create_timer(100),"timeout")
		follow = false

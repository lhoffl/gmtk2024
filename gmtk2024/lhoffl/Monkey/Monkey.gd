extends RigidBody3D

@export var speed = 50.0
@export var maxSpeed = 500.0
@export var minSpeed = 1.0

@export var maxMass = 1000.0
@export var minMass = 0.1
@export var massScaleFactor = 0.1

@export var monkeyScale = 0.25
@export var jumpForce = 500

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	$Marker3D.top_level = true
	$FloorCheck.top_level = true
	
func _physics_process(delta):
	var previous_camera_position = $Marker3D.global_transform.origin
	var monkey_position = global_transform.origin
	$Marker3D.global_transform.origin = lerp(previous_camera_position, monkey_position, 0.9)
	$FloorCheck.global_transform.origin = global_transform.origin
	
	if Input.is_action_just_pressed("smolMonkey"):
		speed *= 2 
		mass *= 4
		monkeyScale /= 1.2
		gravity /= 1.2
	
	if Input.is_action_just_pressed("bigMonkey"):
		speed /= 2 
		mass /= 4 
		monkeyScale *= 1.2
		gravity *= 1.2	
		
	mass = clampf(mass, minMass, maxMass)
	monkeyScale = clampf(monkeyScale, 0.08, 0.4)
	jumpForce = clampf(jumpForce, 1, 1000)
	speed = clampf(speed, minSpeed, maxSpeed)
	$MeshInstance3D/MonkeyMesh.scale = Vector3(monkeyScale, monkeyScale, monkeyScale) #Vector3($CurrentMonkeyState.monkeyScale, $CurrentMonkeyState.monkeyScale, $CurrentMonkeyState.monkeyScale)
	
	if Input.is_action_pressed("forward"):
		angular_velocity.x -=  speed * delta
	elif Input.is_action_pressed("back"):
		angular_velocity.x += speed * delta
	if Input.is_action_pressed("right"):
		angular_velocity.z -= speed * delta
	elif Input.is_action_pressed("left"):
		angular_velocity.z += speed * delta
			
	if Input.is_action_just_pressed("jump") and $FloorCheck.is_colliding():
		apply_central_impulse(Vector3.UP * jumpForce)

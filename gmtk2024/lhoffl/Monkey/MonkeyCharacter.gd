extends CharacterBody3D

@export var speed = 50.0
@export var maxSpeed = 500.0
@export var minSpeed = 1.0

@export var monkeyScale = 0.25
@export var jumpForce = 500

@export var minGravity = 9.8
@export var maxGravity = 20.0
@export var gravity = 9.8

func _ready():
	$Marker3D.top_level = true
	$FloorCheck.top_level = true

func _process(delta):
	pass
	
func _physics_process(delta):
	var previous_camera_position = $Marker3D.global_transform.origin
	var monkey_position = global_transform.origin
	$Marker3D.global_transform.origin = lerp(previous_camera_position, monkey_position, 0.1)

	$FloorCheck.global_transform.origin = global_transform.origin
	
	if Input.is_action_just_pressed("smolMonkey"):
		speed *= 2 
		monkeyScale /= 1.2
		gravity /= 1.2
	
	if Input.is_action_just_pressed("bigMonkey"):
		speed /= 2 
		monkeyScale *= 1.2
		gravity *= 1.2
		
	monkeyScale = clampf(monkeyScale, 0.08, 0.4)
	jumpForce = clampf(jumpForce, 1, 1000)
	speed = clampf(speed, minSpeed, maxSpeed)
	gravity = clamp(gravity, minGravity, maxGravity)
	$MeshInstance3D/MonkeyMesh.scale = Vector3(monkeyScale, monkeyScale, monkeyScale) #Vector3($CurrentMonkeyState.monkeyScale, $CurrentMonkeyState.monkeyScale, $CurrentMonkeyState.monkeyScale)
	
	if Input.is_action_pressed("left"):
		velocity.x -=  speed * delta
	elif Input.is_action_pressed("right"):
		velocity.x += speed * delta
	if Input.is_action_pressed("forward"):
		velocity.z -= speed * delta
	elif Input.is_action_pressed("back"):
		velocity.z += speed * delta
		
	if(!is_on_floor()):
		velocity.y += -gravity * delta

	move_and_slide()


#	if Input.is_action_just_pressed("jump") and $FloorCheck.is_colliding():
#		apply_central_impulse(Vector3.UP * jumpForce)

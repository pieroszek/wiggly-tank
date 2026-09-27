extends CharacterBody3D

const BULLET_SCENE = preload("res://projectile.tscn")
const EXPLOSION_SCENE = preload("res://boom.tscn")
@onready var muzzle = $Muzzle
@onready var shoot_timer = $Timer 
@export var speed = 10
@export var rot_speed = 25
var target_velocity = Vector3.ZERO
var target_rotation = Vector3.ZERO

signal hit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _physics_process(delta):
	# We create a local variable to store the input direction.
	var direction = Vector3.ZERO
	var tank_rotation = Vector3.ZERO
	

	# We check for each move input and update the direction accordingly.
	if Input.is_action_pressed("move right"):
		#direction.x += 1
		tank_rotation.y -= 0.1 
		rotate_y(tank_rotation.y * rot_speed * delta)
		
	if Input.is_action_pressed("move left"):
		#direction.x -= 1
		tank_rotation.y += 0.1 
		rotate_y(tank_rotation.y * rot_speed * delta)
		
	if Input.is_action_pressed("move backward"):
		# Notice how we are working with the vector's x and z axes.
		# In 3D, the XZ plane is the ground plane.
		direction.z -= 1
	if Input.is_action_pressed("move forward"):
		direction.z += 1
		
	if Input.is_action_pressed("shoot") and shoot_timer.is_stopped():
		shoot()
		
	if direction != Vector3.ZERO:
		$AnimationPlayer.speed_scale = 4
	else:
		$AnimationPlayer.speed_scale = 1
		

# and shoot_timer.is_stopped()
	#if direction != Vector3.ZERO:
			#direction = direction.normalized()
			# Setting the basis property will affect the rotation of the node.
			#$Pivot.basis = Basis.looking_at(direction)

	# Ground Velocity
	#target_velocity.x = rotation.y * speed
	#target_velocity.z = direction.z * speed

	# Vertical Velocity
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		target_velocity.y = target_velocity.y - (75 * delta)
	
	# Moving the Character
	#velocity = target_velocity
	var forward_vector = -global_transform.basis.z
	velocity = forward_vector * direction.z * speed
	move_and_slide()

func shoot():
	shoot_timer.start()
	#print("shoot")
	# Create a live instance of the bullet scene
	var bullet_instance = BULLET_SCENE.instantiate()
	
	# Add the bullet to the main game world (not as a child of the tank, 
	# otherwise the bullet will move and turn whenever the tank turns!)
	get_tree().current_scene.add_child(bullet_instance)
	
	# 3. Position the bullet at the gun muzzle
	bullet_instance.global_position = muzzle.global_position
	
	# 4. Match the tank's rotation so it points the right way
	bullet_instance.global_rotation = global_rotation
	
	# 5. Send it flying! Get the local forward vector of the muzzle/tank
	var shoot_direction = -muzzle.global_transform.basis.z
	bullet_instance.velocity = shoot_direction * bullet_instance.speed
	
	
func spawn_explosion(impact_position: Vector3):
	var explosion = EXPLOSION_SCENE.instantiate()
	
	# Spawn it into the main world scene so it lives independently
	get_tree().current_scene.add_child(explosion)
	
	# Place the explosion exactly where the bullet hit the truck
	explosion.global_position = impact_position
	
func die():
	hit.emit()
	spawn_explosion(muzzle.position)
	queue_free()


func _on_truck_detector_body_entered(body: Node3D) -> void:
	if body.is_in_group("truck"):
		die()
	pass
	

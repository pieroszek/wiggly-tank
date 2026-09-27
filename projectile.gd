extends CharacterBody3D

@export var speed: float = 30.0
#var velocity: Vector3 = Vector3.ZERO

const EXPLOSION_SCENE = preload("res://boom.tscn")

func spawn_explosion(impact_position: Vector3):
	var explosion = EXPLOSION_SCENE.instantiate()
	
	# Spawn it into the main world scene so it lives independently
	get_tree().current_scene.add_child(explosion)
	
	# Place the explosion exactly where the bullet hit the truck
	explosion.global_position = impact_position
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect the collision signal to handle hitting things
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _physics_process(_delta):
	# Move forward constantly along the assigned velocity path
	#global_position += velocity * delta
	
	move_and_slide()
	# Iterate through all collisions that occurred this frame
	for index in range(get_slide_collision_count()):
		var collision = get_slide_collision(index)
		
		# Prevent processing duplicate collisions if the target was already deleted
		if collision.get_collider() == null:
			continue
			
		var hit_object = collision.get_collider()
		
		# Check if the object we collided with is in the "truck" group
		if hit_object.is_in_group("truck"):
			print("truck hit")
			spawn_explosion(hit_object.position)
			
			# Call the squash method if it exists on the truck
			if hit_object.has_method("squash"):
				hit_object.squash()
				
			queue_free() # Destroy the bullet immediately on impact
			break # Stop checking other collisions this frame

extends Node3D
@onready var particles = $GPUParticles3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	particles.emitting = true
	var total_duration = particles.lifetime + particles.lifetime * particles.randomness
	await get_tree().create_timer(total_duration).timeout
	
	queue_free()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

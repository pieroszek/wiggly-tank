extends Node3D


@export var mob_scene: PackedScene

func _on_timer_timeout():
	pass
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Control/Retry.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_mob_timer_timeout() -> void:
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()
	# Choose a random location on the SpawnPath.
	# We store the reference to the SpawnLocation node.
	var mob_spawn_location = get_node("SpawnLocation/SpawnPath")
	#print(mob_spawn_location)
	# And give it a random offset.
	mob_spawn_location.progress_ratio = randf()
	var player_position = $tank.position
	mob.initialize(mob_spawn_location.position, player_position)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)
	mob.squashed.connect($Control/ScoreLabel._on_mob_squashed.bind())



func _on_tank_hit() -> void:
	$MobTimer.stop()
	$Control/Retry.show()
	
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $Control/Retry.visible:
		# This restarts the current scene.
		get_tree().reload_current_scene()

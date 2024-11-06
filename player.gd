extends RigidBody3D

## How much vertical force to apply when moving.
@export_range(1000, 3000) var thrust: float = 2000.0
## How much rotational thrust effects the left and right rotation.
@export var torque_thrust: float = 100.0

var is_transitioning: bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("boost"):
		apply_central_force(basis.y * delta * thrust)
		
	if Input.is_action_pressed("rotate_left"):
		apply_torque(Vector3(0.0, 0.0, torque_thrust * delta))
		
	if Input.is_action_pressed("rotate_right"):
		apply_torque(Vector3(0.0, 0.0, -(torque_thrust * delta)))


func _on_body_entered(body: Node) -> void:
	if not is_transitioning:
		if "Goal" in body.get_groups():
			complete_level(body.file_path)
		if "Hazard" in body.get_groups():
			crash_sequence()
		
func crash_sequence() -> void:
	print("KABOOM!")
	set_process(false)
	is_transitioning = true
	var tween = create_tween()
	tween.tween_interval(1.0)
	tween.tween_callback(get_tree().reload_current_scene)
	#get_tree().call_deferred("reload_current_scene")
	
	
func complete_level(next_level_file: String) -> void:
	print("LEVEL COMPLETE!")
	set_process(false)
	is_transitioning = true
	var tween = create_tween()
	tween.tween_interval(1.0)
	tween.tween_callback(
		get_tree().change_scene_to_file.bind(next_level_file)
	)
	#get_tree().call_deferred("change_scene_to_file", next_level_file)

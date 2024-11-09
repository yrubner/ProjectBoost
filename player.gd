extends RigidBody3D

## How much vertical force to apply when moving.
@export_range(1000, 3000) var thrust: float = 2000.0
## How much rotational thrust effects the left and right rotation.
@export var torque_thrust: float = 100.0

var is_transitioning: bool = false

@onready var explosion_audio: AudioStreamPlayer = $ExplosionAudio
@onready var success_audio: AudioStreamPlayer = $SuccessAudio
@onready var rocket_audio: AudioStreamPlayer3D = $RocketAudio
@onready var booster_particles: GPUParticles3D = $BoosterParticles
@onready var right_booster_particles: GPUParticles3D = $RightBoosterParticles
@onready var left_booster_particles: GPUParticles3D = $LeftBoosterParticles
@onready var explosion_particles: GPUParticles3D = $ExplosionParticles
@onready var success_particles: GPUParticles3D = $SuccessParticles


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("boost"):
		booster_particles.emitting = true
		if rocket_audio.playing == false:
			rocket_audio.play()
		apply_central_force(basis.y * delta * thrust)
	else:
		booster_particles.emitting = false
		rocket_audio.stop()
		
	if Input.is_action_pressed("rotate_left"):
		right_booster_particles.emitting = true
		apply_torque(Vector3(0.0, 0.0, torque_thrust * delta))
	else:
		right_booster_particles.emitting = false
		
	if Input.is_action_pressed("rotate_right"):
		left_booster_particles.emitting = true
		apply_torque(Vector3(0.0, 0.0, -(torque_thrust * delta)))
	else:
		left_booster_particles.emitting = false
		
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()


func _on_body_entered(body: Node) -> void:
	if not is_transitioning:
		if "Goal" in body.get_groups():
			complete_level(body.file_path)
		if "Hazard" in body.get_groups():
			crash_sequence()
		
func crash_sequence() -> void:
	print("KABOOM!")
	explosion_particles.emitting = true
	explosion_audio.play()
	set_process(false)
	is_transitioning = true
	var tween = create_tween()
	tween.tween_interval(2.5)
	tween.tween_callback(get_tree().reload_current_scene)
	#get_tree().call_deferred("reload_current_scene")
	
	
func complete_level(next_level_file: String) -> void:
	print("LEVEL COMPLETE!")
	success_particles.emitting = true
	success_audio.play()
	set_process(false)
	is_transitioning = true
	var tween = create_tween()
	tween.tween_interval(2.0)
	tween.tween_callback(
		get_tree().change_scene_to_file.bind(next_level_file)
	)
	#get_tree().call_deferred("change_scene_to_file", next_level_file)

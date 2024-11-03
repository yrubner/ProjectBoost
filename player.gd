extends RigidBody3D

## How much vertical force to apply when moving.
@export_range(1000, 3000) var thrust: float = 2000.0
## How much rotational thrust effects the left and right rotation.
@export var torque_thrust: float = 100.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("boost"):
		apply_central_force(basis.y * delta * thrust)
		
	if Input.is_action_pressed("rotate_left"):
		apply_torque(Vector3(0.0, 0.0, torque_thrust * delta))
		
	if Input.is_action_pressed("rotate_right"):
		apply_torque(Vector3(0.0, 0.0, -(torque_thrust * delta)))


func _on_body_entered(body: Node) -> void:
	if "Goal" in body.get_groups():
		print("You win!")
	if "Hazard" in body.get_groups():
		print("You crashed!")

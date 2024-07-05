extends CharacterBody3D

const JUMP_VELOCITY = 4.5
static var SCORE = 0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity.y = JUMP_VELOCITY
	
	if position.y <= -5:
		get_tree().reload_current_scene()

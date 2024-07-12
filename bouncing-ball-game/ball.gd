extends CharacterBody3D

const JUMP_VELOCITY = 4.5
static var SCORE = 0
@onready var col_shape = $CollisionShape3D

func _physics_process(delta: float) -> void:
	if Manager.GO == false: return
	
	#When the ball is respawned in the air, it shouldn't collide with the tiles at the top of the ring.
	col_shape.disabled = (position.y >= 1)
	
	
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity.y = JUMP_VELOCITY
	
	if position.y <= -5:
		position.y = 10
		velocity.y = 0
		#get_tree().reload_current_scene()

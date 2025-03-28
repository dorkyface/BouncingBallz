extends CharacterBody3D

var time : float = 0.0
var zero_time : float = 0.0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	time += delta
	position.y = 5.0 * time - 5 * pow(time, 2.0)
	
	#if time != 0 and position.y < 0.1 and position.y > 0.0:
		#zero_time = time
	
	var col = move_and_collide(Vector3.UP * delta * sign(position.y))
	
	if col:
		time = zero_time
	
	print(position.y)

extends Node3D

@export var rotation_speed : float = 1.0
var time = 0
@export var bobbing_magnitude : float = 0.2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#var tw = get_tree().create_tween()
	#tw.tween_property()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Label3D.rotate(Vector3.UP, delta * rotation_speed)
	time += delta
	$Label3D.position.y = sin(time) * bobbing_magnitude + bobbing_magnitude

func play_particles():
	
	$Label3D.visible = false
	var t = get_tree().create_tween()
	t.set_parallel(true)
	for i in range(2, 8):
		get_child(i).visible = true
		var dir = Vector2.LEFT.rotated(deg_to_rad(45.0 * ( i + 1)))
		var dir3 = Vector3(dir.x, dir.y, 0)
		t.tween_property(get_child(i),"position", dir3 * 10, 1.0)
	$AudioStreamPlayer.play()
	
	await get_tree().create_timer(1.5).timeout
	for i in range(2, 8):
		get_child(i).visible = false
		get_child(i).position = Vector3.ZERO
	$Label3D.visible = true

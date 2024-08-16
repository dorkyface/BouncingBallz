extends Node3D

const SPEED = 2
const TILE_DISTANCE_LIMIT = 4
const RESET_DISTANCE_MULTIPLIER = 2
@onready var start_z = position.z
@onready var SEG_COUNT = get_tree().get_node_count_in_group("SEGMENT") - 1
@export var radius: float = 2.0
var sensitivity: float = 0.005
var is_dragging: bool = false
var last_touch_position: Vector2 = Vector2.ZERO

# Probability of disabling a child (0.0 to 1)
# ...probably my favorite comment ever written, and I can't even take credit for it.
# I asked chatGPT for help on the relevant function.
@export var disable_probability: float = 0.5

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.is_pressed():
			is_dragging = true
			last_touch_position = event.position
		else:
			is_dragging = false
	elif event is InputEventScreenDrag and is_dragging:
		var delta = event.position - last_touch_position
		last_touch_position = event.position

		# Rotate the object based on the drag delta
		var _rotation_x = delta.y * sensitivity
		var rotation_y = delta.x * sensitivity
		
		rotate_z(rotation_y)

func _ready() -> void:
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# Initialize the tiles into a circle arrangement
	arrange_children_in_circle()
	
	on_reset()

# This function is called when this segment of tiles is looped back to be used again
# or when the game is loaded.
func on_reset():
	disable_children_randomly(false)
	randomize()
	disable_children_randomly(true)
	
	for i in get_child_count():
		get_child(i).triggered = false
		var anim : AnimationPlayer = get_child(i).animPlayer
		anim.play("RESET")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# For testing purposes, use left and right arrows to control the movement.
	var rot = 0.05 * (int(Input.is_action_pressed("ui_left")) - int(Input.is_action_pressed("ui_right")))
	rotate_z(rot)
	
	if Manager.GO == false: return
	if Manager.BALL_TYPE.does_not_move: return
	position.z += delta * (speed_calc(Manager.SCORE) + speed_calc(Manager.STREAK * 0.5))
	if position.z >= TILE_DISTANCE_LIMIT:
		position.z = -RESET_DISTANCE_MULTIPLIER * (SEG_COUNT-1)
		on_reset()

# This is a mathmatical formula that calculates the speed multiplier based on score.
# This version reaches 4x speed at 80 points.
# It cannot go higher than 5 (horizontal asymptote), no matter how large the score.
# It starts at a multiplier of 1x.
func speed_calc(n : int) -> float:
	var M : float = 100
	var O : float = 25
	var C : float = 5
	var numerator : float = -M
	var denominator : float = n + O
	var speed : float = (numerator / denominator) + C
	return speed

func arrange_children_in_circle():
	var num_children = get_child_count()
	if num_children == 0:
		return
		
	for i in range(num_children):   
		var child = get_child(i) as Node3D
		if not child:
			continue
		
		# Calculate the angle for the current child   
		var angle = (float(i) / float(num_children)) * TAU
		var x = radius * cos(angle)
		var z = radius * sin(angle)
		
		# Set the child's position
		child.position = Vector3(x, z, 0)
		
		# Set the child facing the center by rotating it around its Z axis
		child.rotate_object_local(Vector3(0, 0, 1), angle + PI/2)
	


func disable_children_randomly(to_disable: bool):
	var disabled_children = 0
	for i in range(get_child_count()):
		var child = get_child(i) as Node3D
		if child and randf() < (disable_probability - (0.1 * disabled_children)):
			disabled_children += 1
			
			
			child.visible = !to_disable
			
			
			# Disable collision shapes if any
			disable_collisions(child, to_disable)

func disable_collisions(node: Node, disable: bool):
	# Recursively disable all collision shapes
	for child in node.get_children():
		if child is CollisionShape3D:
			child.disabled = disable
		elif child.has_method("get_children"):
			disable_collisions(child, disable)

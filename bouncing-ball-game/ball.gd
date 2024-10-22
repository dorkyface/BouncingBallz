extends CharacterBody3D

@export var JUMP_VELOCITY : float = 4.5
@onready var col_shape : CollisionShape3D = $CollisionShape3D

@onready var streak_flash_sprite : Sprite3D = $StreakFlashSprite
@onready var streak_flash_anim : AnimationPlayer = $StreakFlashSprite/StreakFlashAnimationPlayer

@onready var ball_data : BallData = Manager.BALL_TYPE
@onready var ball_mesh : MeshInstance3D = $MeshInstance3D
@onready var rng = RandomNumberGenerator.new()
@onready var base_scale : Vector3 = Vector3.ONE
@onready var SQUASH_SCALE : Vector3 = Vector3(1.25, 0.5, 1.25) * ball_data.scale_factor
const SQUASH_TIME : float = 0.05
@onready var STRETCH_SCALE : Vector3 = Vector3(0.75, 1.25, 0.75) * ball_data.scale_factor
const STRETCH_TIME : float = 0.2
const SQUASH_N_STRETCH_RETURN_TIME = 0.4
const TUMBLE_TIME = 0.8

var MINIMUM_HEIGHT_LIMIT = -5
var RESPAWN_HEIGHT = 5

const HANG_TIME_STREAK_MINIMUM : int = 11
var last_frame_y : float = 0
var hang_time : int = 0
#var ball_data : BallData

func _ready() -> void:
	rng.randomize()
	load_ball_data()

func load_ball_data():
	#var ball_data = Manager.BALL_TYPE
	if ball_data == null: 
		print("No ball data loaded at all.")
		return
	
	if ball_data.ball_mesh == null:
		ball_mesh.mesh = load("res://Ball Data Resources/DefaultCube.tres")
		return
	
	ball_mesh.mesh = Manager.BALL_TYPE.ball_mesh
	base_scale *= ball_data.scale_factor
	ball_mesh.scale *= base_scale
	ball_mesh.rotation_degrees = ball_data.alt_rotation
	

func _physics_process(delta: float) -> void:
	if Manager.GO == false: return
	
	#When the ball is respawned in the air, it shouldn't collide with the tiles at the top of the ring.
	col_shape.disabled = (position.y >= 1)
	
	# Add the gravity.
	if not is_on_floor() and ball_data.does_not_respect_gravity == false:
		velocity += get_gravity() * delta
		
	# If the ball collides with a tile (although rn it doesn't check specifically for tiles)
	# then set the Y velocity to the JUMP VELOCITY.
	var collision = move_and_collide(velocity * delta)
	if collision and Manager.BALL_TYPE.does_not_bounce == false:
		velocity.y = JUMP_VELOCITY
		call_tween_bounce_animations()
	elif collision and Manager.BALL_TYPE.does_not_bounce:
		if Manager.BALL_TYPE.does_not_roll == false:
			rolling_animation()
		velocity.y = 0
	
	# When the ball falls into the void, respawn and reset streak
	if position.y <= MINIMUM_HEIGHT_LIMIT:
		position.y = RESPAWN_HEIGHT
		velocity.y = 0
		Manager.on_player_death()
		#Manager.PREVIOUS_SCORE = Manager.STREAK
		#Manager.STREAK = 0
	
	# Streaking is triggered when the ball "grips" the underside of platforms.
	# When this is happening, the ball isn't changing its y position.
	# So when the ball holds at a given Y position for N frames,
	# trigger streaking effects.
	if abs(position.y - last_frame_y) < 0.01 and Manager.BALL_TYPE.does_not_streak == false:
		hang_time += 1
		if hang_time >= HANG_TIME_STREAK_MINIMUM:
			#Manager.SCORE += 1
			Manager.STREAK += 1
			streak_flash_sprite.visible = true
			streak_flash_anim.play("FLASHING")
			
	else:
		hang_time = 0
		streak_flash_sprite.visible = false
	last_frame_y = position.y

func call_tween_bounce_animations():
	#I use two seperate tweens so that I can call differant actions at the same time.
	# NOTE There is probably a way to combine these into one tween.
	var ball_mesh_tween : Tween = get_tree().create_tween()
	var ball_mesh_tween_rot : Tween = get_tree().create_tween()
	
	# The logic of the squash and stretch effect is extrmely straightforward.
	ball_mesh_tween.tween_property(ball_mesh,"scale", SQUASH_SCALE, SQUASH_TIME)
	ball_mesh_tween.tween_property(ball_mesh,"scale", STRETCH_SCALE, STRETCH_TIME)
	ball_mesh_tween.tween_property(ball_mesh,"scale", base_scale, SQUASH_N_STRETCH_RETURN_TIME)
	
	# The ball also tumbles either across its x or y axis.
	# Which axis is determined randomly.
	var rotationAngles = ["rotation:x", "rotation:y"]
	var axis = rng.randi_range(0,rotationAngles.size()-1)
	
	# Whether or not the ball rotates around its Y axis clockwise or counterclockwise
	# is also determined randomly.
	# However, we don't want the ball to tumble BACKWARDS.
	# So some math logic is used in the s variable (the clamp function).
	# Basically, if the axis is the Y axis, then the ball should always tumble forwards 
	# (ie, s must = -1)
	var signs = [-1, 1]
	var s = signs[rng.randi() % signs.size() * clamp(axis, 0, 1)]
	ball_mesh_tween_rot.tween_property(
		ball_mesh, rotationAngles[axis], 
		2 * PI * s, 
		TUMBLE_TIME).from(0)

func rolling_animation():
	var ball_mesh_tween : Tween = get_tree().create_tween()
	ball_mesh_tween.tween_property(ball_mesh, "rotation:x", 360, 10.0).as_relative()

func find_mesh_resource_by_name(resource_path: String, mesh_name: String) -> Mesh:
	var dir = DirAccess.open(resource_path)
	if not dir:
		push_error("Cannot open directory: " + resource_path)
		return null
	
	dir.list_dir_begin()
	
	var file_name = dir.get_next()
	while file_name != "":
		if file_name.ends_with(".res"):
			var mesh_resource = ResourceLoader.load(dir.get_current_dir() + "/" + file_name)
			if mesh_resource and mesh_resource is Mesh and file_name.get_basename() == mesh_name:
				return mesh_resource
		
		file_name = dir.get_next()
	
	dir.list_dir_end()
	print("Mesh resource not found: " + mesh_name)
	return null

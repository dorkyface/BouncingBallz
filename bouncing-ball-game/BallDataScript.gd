extends Resource
class_name BallData

@export var ball_name : String
@export var ball_mesh : Mesh = load("res://Ball Data Resources/DefaultCube.tres")
@export_multiline var ball_description : String = "..."
@export var does_not_streak = false
@export var does_not_bounce = false
@export var does_not_roll = false
@export var does_not_move = false
@export var does_not_respect_gravity = false
@export var alt_shadow : Texture2D = null
@export var scale_factor : float = 0.01
@export var alt_rotation : Vector3 = Vector3.ZERO
@export var alt_default_fov : float = 0.0
@export var alt_tile_move_speed : float = 1.0

extends Resource
class_name BallData

@export var ball_name : String
@export var ball_mesh : Mesh = load("res://Ball Data Resources/DefaultCube.tres")
@export_multiline var ball_description : String = "..."
@export var does_not_bounce = false
@export var does_not_roll = false
@export var does_not_move = false
@export var alt_shadow : Texture2D = null

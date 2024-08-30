extends Node3D

@onready var main_mesh : MeshInstance3D = $MeshInstance3D_MAIN
@onready var alt_mesh : MeshInstance3D = $MeshInstance3D_DUPE
@onready var anim : AnimationPlayer = $AnimationPlayer

@onready var r2ltoggle : bool = false

@export var ball_data_array: Array[BallData] = []

var ball_index : int = 0
func get_ball_index(n : int = 0):
	var i = ball_index + n
	if i >= ball_data_array.size(): i = 0
	if i < 0: i = ball_data_array.size() - 1
	
	return i

signal current_ball(ball : BallData)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_ball.emit(ball_data_array[get_ball_index()])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	revolve_mesh(delta)

func _on_selection_menu_ui_on_swipe_up(swipe_is_left: bool) -> void:
	if swipe_is_left: ball_right_2_left()
	else: ball_left_2_right()
	
	current_ball.emit(ball_data_array[get_ball_index()])


func ball_right_2_left():
	match r2ltoggle:
		true:
			anim.play("DUPE2MAIN_R2L")
			set_meshes(ball_data_array[get_ball_index(1)].ball_mesh, ball_data_array[get_ball_index()].ball_mesh)
			r2ltoggle = false
		false:
			set_meshes(ball_data_array[get_ball_index()].ball_mesh, ball_data_array[get_ball_index(1)].ball_mesh)
			anim.play("MAIN2DUPE_R2L")
			r2ltoggle = true
	
	update_index(+1)

func ball_left_2_right() -> void:
	match r2ltoggle:
		true:
			anim.play_backwards("DUPE2MAIN_R2L")
			set_meshes(ball_data_array[get_ball_index()].ball_mesh, ball_data_array[get_ball_index(-1)].ball_mesh)
			r2ltoggle = false
		false:
			set_meshes(ball_data_array[get_ball_index(-1)].ball_mesh, ball_data_array[get_ball_index()].ball_mesh)
			anim.play_backwards("MAIN2DUPE_R2L")
			r2ltoggle = true
	
	update_index(-1)

func set_meshes(mesh1 : Mesh, mesh2 : Mesh):
	main_mesh.mesh = mesh1
	alt_mesh.mesh = mesh2

func update_index(n : int):
	ball_index += n
	if ball_index >= ball_data_array.size(): ball_index = 0
	if ball_index < 0: ball_index = ball_data_array.size() - 1

func revolve_mesh(delta : float):
	main_mesh.rotate(Vector3.UP, delta)
	alt_mesh.rotate(Vector3.UP, delta)

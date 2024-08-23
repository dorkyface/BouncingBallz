
extends Node3D

@export var ball_data_array: Array[BallData] = []

signal ui_text_update(ball : BallData)

@export var radius: float = 5.0 :
	get:
		return radius
	set(value):
		radius = value

#var rotation_step : int = 6
var child_index : int = 1
var is_tweening : bool = false
var rot_on_start : bool = true

func _ready():
	#game_start = true
	update_positions()
	#ui_text_update.emit(ball_desc_dict[get_mesh_name()][0], ball_desc_dict[get_mesh_name()][1])


func get_mesh_name():
	var c : MeshInstance3D = get_child(child_index)
	var m : Mesh = c.mesh
	return m.resource_name
	#var m =

func _process(delta: float) -> void:
	update_positions()
	#if game_start == false: return
	spin_the_child(delta)


func update_rotation(value : int):
	is_tweening = true
	var child_count = get_child_count()
	if child_count == 0:
		return
	
	var angle_step = (2 * PI / child_count)
	
	var tween : Tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, "rotation:y", angle_step * value, 0.5).as_relative()
	tween.connect("finished", turn_off_tweening)

func turn_off_tweening():
	is_tweening = false

func update_positions():
	var child_count = get_child_count()
	if child_count == 0:
		return

	var angle_step = 2 * PI / child_count
	for i in range(child_count):
		var child = get_child(i)
		if child is Node3D:
			var angle = i * angle_step
			var x = radius * cos(angle)
			var z = radius * sin(angle)
			child.transform.origin = Vector3(x, 0, z)

func spin_the_child(delta):
	if child_index == null: return
	var child = get_child(child_index)
	child.rotation.y += delta
	#child.rotation.x += delta

func update_child_index(value):
	var cc = get_child_count() - 1
	child_index += value
	if child_index > cc: child_index = 0
	if child_index < 0: child_index = cc

func _on_selection_menu_ui_update_rot(value: Variant) -> void:
	if is_tweening: return
	update_child_index(value)
	update_rotation(value)
	ui_text_update.emit(get_ball_data_alt(child_index))
	#get_ball_data_alt(child_index)
	#ui_text_update.emit(ball_desc_dict[get_mesh_name()][0], ball_desc_dict[get_mesh_name()][1])

func get_ball_data() -> BallData:
	var ball_name = get_mesh_name()
	for i in ball_data_array.size():
		if ball_data_array[i].ball_name == ball_name:
			return ball_data_array[i]
	
	print("Could not find ball data")
	return null

func get_ball_data_alt(n: int):
	var c : BallDataContainer = get_child(n)
	var data = c.ball_data_file
	
	return data

func _on_selection_menu_ui_select_ball() -> void:
	var ball : BallData = get_ball_data_alt(child_index)
	if ball == null : return
	
	Manager.BALL_TYPE = ball
	get_tree().change_scene_to_file("res://test_lvl.tscn")
	#print("hello")
	#var bawl = get_mesh_name()
	#for i in ball_data_array.size():
		#if ball_data_array[i].ball_name == bawl:
			#Manager.BALL_TYPE = ball_data_array[i]
			#print("FOUND AND SElECtED BALL")
			#get_tree().change_scene_to_file("res://test_lvl.tscn")
			#return
	
	#print("Unable to find ball resource")
	#print(bawl)
	#Manager.BALL = bawl
	#get_tree().change_scene_to_file("res://test_lvl.tscn")


func _on_back_button_button_up() -> void:
	get_tree().change_scene_to_file("res://test_lvl.tscn")

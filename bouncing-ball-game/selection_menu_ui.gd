extends Control

signal update_rot(value)
signal select_ball
signal on_swipe_up(swipe_is_left : bool)

@onready var ball_name_lable  = $MarginContainer/BallNameLable
@onready var ball_desc_lable = $MarginContainer/BallDescriptionLable
@onready var spending_points_lable = $MarginContainer3/SpendingPointsLable

var current_ball : BallData = Manager.BALL_TYPE

#extends Node2D  # or Control, depending on your node type

# Variables to track swipe
var touch_start_position: Vector2
var is_swiping: bool = false
var swipe_threshold: float = 50.0  # Minimum distance for a swipe to be recognized

func _ready() -> void:
	update_points_to_spend(Manager.SCORE)

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.pressed:
		# When touch starts, record the starting position
		touch_start_position = event.position
		is_swiping = true
	elif event is InputEventScreenTouch and not event.pressed:
		# When touch ends, check if a swipe occurred
		if is_swiping:
			var touch_end_position = event.position
			var swipe_vector = touch_end_position - touch_start_position

			if swipe_vector.length() >= swipe_threshold:
				if abs(swipe_vector.x) > abs(swipe_vector.y):
					if swipe_vector.x > 0:
						#print("Right")
						on_swipe(false)
					else:
						#print("Left")
						on_swipe(true)
			is_swiping = false
		elif event is InputEventScreenDrag:
			# When dragging, set swiping state to true
			is_swiping = true

func on_swipe(swipe_is_left : bool):
	on_swipe_up.emit(swipe_is_left)


#func _on_texture_button_r_button_up() -> void:
	#update_menu_rotation(-1)
#
#func update_menu_rotation(value : int):
	#update_rot.emit(value)
#
#
#func _on_texture_button_l_button_up() -> void:
	#update_menu_rotation(1)


#func _on_ball_selection_radial_menu_ui_text_update(ball : BallData) -> void:
	#ball_name_lable.text = ball.ball_name
	#ball_desc_lable.text = "[center]" + ball.ball_description


func _on_buy_button_button_up() -> void:
	if Manager.SCORE >= current_ball.cost:
		Manager.SCORE -= current_ball.cost
		
		Manager.BALL_TYPE = current_ball
		get_tree().change_scene_to_file("res://test_lvl.tscn")
		#emit_signal("select_ball")
		return
	
	print("You do have the funds to purchase this ball")


func _on_ball_selection_menu_v_2_current_ball(ball: BallData) -> void:
	current_ball = ball
	ball_name_lable.text = ball.ball_name
	ball_desc_lable.text = "[center]Cost: " + str(ball.cost) + "[p align=center]" + ball.ball_description

func update_points_to_spend(value : int):
	spending_points_lable.text = str(value)

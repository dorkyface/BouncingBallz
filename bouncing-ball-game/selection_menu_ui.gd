extends Control

signal update_rot(value)
signal select_ball

@onready var ball_name_lable  = $MarginContainer/BallNameLable
@onready var ball_desc_lable = $MarginContainer/BallDescriptionLable

func _on_texture_button_r_button_up() -> void:
	update_menu_rotation(-1)

func update_menu_rotation(value : int):
	update_rot.emit(value)


func _on_texture_button_l_button_up() -> void:
	update_menu_rotation(1)


func _on_ball_selection_radial_menu_ui_text_update(ball : BallData) -> void:
	ball_name_lable.text = ball.ball_name
	ball_desc_lable.text = "[center]" + ball.ball_description


func _on_buy_button_button_up() -> void:
	emit_signal("select_ball")

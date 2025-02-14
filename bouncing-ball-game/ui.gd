extends Control

@onready var scoreLable = $"MarginContainer/Score Lable"
@onready var prevScoreLable = $"MarginContainer/Previous Score Lable"
@onready var errorLable = $"MarginContainer/Error Console"
@onready var playAnim = $"PlayControl/Play Animator"
@onready var optionsMenu = $"Options Menu"

@export var life_point_ui_elements: Array[Node] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Manager.player_death.connect(on_player_death)
	Manager.scored_point.connect(on_player_score)

func on_player_score():
	pass
	#print("Player scored")

func on_player_death(lives_remaining):
	if lives_remaining < 0: return
	
	var i = life_point_ui_elements.size() - 1 - lives_remaining
	var hit_point : life_node = life_point_ui_elements[i].shatter()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	scoreLable.text = str(Manager.SCORE)


func _on_play_button_button_up() -> void:
	playAnim.play("clicked_play")
	Manager.GO = true


func _on_options_button_toggled(toggled_on: bool) -> void:
	print("clicked")
	optionsMenu.visible = toggled_on
	get_tree().paused = toggled_on


func _on_quit_button_button_up() -> void:
	get_tree().quit()


func _on_option_1_button_up() -> void:
	Manager.GO = false
	Manager.save()
	#print(Manager.SCORE)
	get_tree().paused = false
	get_tree().change_scene_to_file("res://ball_selection_menu_v2.tscn")

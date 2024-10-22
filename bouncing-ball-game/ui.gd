extends Control

@onready var scoreLable = $"MarginContainer/Score Lable"
@onready var prevScoreLable = $"MarginContainer/Previous Score Lable"
@onready var errorLable = $"MarginContainer/Error Console"
@onready var playAnim = $"PlayControl/Play Animator"
@onready var optionsMenu = $"Options Menu"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Manager.player_death.connect(on_player_death)

func on_player_death():
	prevScoreLable.text = str( Manager.PREVIOUS_SCORE )

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	scoreLable.text = str(Manager.STREAK)


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

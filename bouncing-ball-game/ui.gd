extends Control

@onready var scoreLable = $"MarginContainer/Score Lable"
@onready var errorLable = $"MarginContainer/Error Console"
@onready var playAnim = $"PlayControl/Play Animator"
@onready var optionsMenu = $"Options Menu"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	scoreLable.text = str(Manager.SCORE)


func _on_play_button_button_up() -> void:
	playAnim.play("clicked_play")
	Manager.GO = true


func _on_options_button_toggled(toggled_on: bool) -> void:
	print("clicked")
	optionsMenu.visible = toggled_on


func _on_quit_button_button_up() -> void:
	get_tree().quit()

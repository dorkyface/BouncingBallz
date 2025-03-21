extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var score_label: Label = $"Menu Rect/MarginContainer/VBoxContainer/Score Label"
@onready var high_score_label: Label = $"Menu Rect/MarginContainer/VBoxContainer/High Score Label"
var player_has_died = false
@onready var click_player: AudioStreamPlayer = $ClickPlayer
@onready var clicking_finish_player: AudioStreamPlayer = $ClickingFinishPlayer
@onready var button_click_player: AudioStreamPlayer = $ButtonClickPlayer

const SCORE_ROLL_TIME : float = 2.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	Manager.player_death.connect(on_player_death)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_player_death(lives):
	if lives <= 0 and player_has_died == false:
		player_has_died = true
		await get_tree().create_timer(1.0).timeout
		get_tree().paused = true
		animation_player.play_backwards("menu_open")
		set_score_in_menu()


func set_score_in_menu():
	var loop_total = Manager.SCORE + 1
	for i in (loop_total):
		await get_tree().create_timer(SCORE_ROLL_TIME / loop_total).timeout
		click_player.play()
		score_label.text = str(i)
	
	clicking_finish_player.play()
	high_score_label.text = "High Score: " + str(Manager.SCORE)

func _on_quit_button_button_up() -> void:
	button_click_player.play()
	await button_click_player.finished
	get_tree().quit()


func _on_main_menu_button_button_up() -> void:
	button_click_player.play()
	print("Clicked Main Menu")


func _on_replay_button_button_up() -> void:
	button_click_player.play()
	await button_click_player.finished
	get_tree().paused = false
	
	Manager.reset_game()
	get_tree().reload_current_scene()

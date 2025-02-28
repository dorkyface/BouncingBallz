extends Control

@onready var score_label: Label = $"MarginContainer/MarginContainer/MarginContainer/VBoxContainer/Score Label"
@onready var high_score_label: Label = $"MarginContainer/MarginContainer/MarginContainer/VBoxContainer/High Score Label"

@onready var master_volume_slider: HSlider = $"MarginContainer/MarginContainer/MarginContainer/VBoxContainer/Menu Row/Control2/Master Volume Slider"
@onready var master_volume_label: Label = $"MarginContainer/MarginContainer/MarginContainer/VBoxContainer/Menu Row/Master Volume Label"
@onready var volume_icon_texture_rect: TextureRect = $"MarginContainer/MarginContainer/MarginContainer/VBoxContainer/Menu Row/Control/Volume Icon Texture Rect"
const AUDIO_ON = preload("res://UI Assets/Kennys UI Assets/audioOn.png")
const AUDIO_OFF = preload("res://UI Assets/Kennys UI Assets/audioOff.png")

@onready var music_icon_texture_rect: TextureRect = $"MarginContainer/MarginContainer/MarginContainer/VBoxContainer/Menu Row2/Control/Music Icon Texture Rect"
@onready var music_volume_slider: HSlider = $"MarginContainer/MarginContainer/MarginContainer/VBoxContainer/Menu Row2/Control2/Music Volume Slider"
@onready var music_volume_label: Label = $"MarginContainer/MarginContainer/MarginContainer/VBoxContainer/Menu Row2/Music Volume Label"
const MUSIC_ON = preload("res://UI Assets/Kennys UI Assets/musicOn.png")
const MUSIC_OFF = preload("res://UI Assets/Kennys UI Assets/musicOff.png")

@onready var balls_button: Button = $"MarginContainer/MarginContainer/MarginContainer/VBoxContainer/Button Margin Container/Balls Button"
@onready var replay_button: Button = $"MarginContainer/MarginContainer/MarginContainer/VBoxContainer/Button Margin Container2/Replay Button"
@onready var main_menu_button: Button = $"MarginContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/Button Margin Container3/Main Menu Button"
@onready var quit_button: Button = $"MarginContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/Button Margin Container4/Quit Button"



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Manager.player_death.connect(on_player_death)
	master_volume_label.text = str(master_volume_slider.value) + "%"
	music_volume_label.text = str(music_volume_slider.value) + "%"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func on_player_death(lives):
	if lives <= 0:
		visible = true
		get_tree().paused = true

func _on_master_volume_slider_value_changed(value: float) -> void:
	master_volume_label.text = str(value) + "%"
	if value == 0: volume_icon_texture_rect.texture = AUDIO_OFF
	else: volume_icon_texture_rect.texture = AUDIO_ON


func _on_music_volume_slider_value_changed(value: float) -> void:
	music_volume_label.text = str(value) + "%"
	if value == 0: music_icon_texture_rect.texture = MUSIC_OFF
	else: music_icon_texture_rect.texture = MUSIC_ON


func _on_balls_button_button_up() -> void:
	pass # Replace with function body.


func _on_replay_button_button_up() -> void:
	get_tree().paused = false
	Manager.reset_game()
	get_tree().reload_current_scene()
	


func _on_main_menu_button_button_up() -> void:
	pass # Replace with function body.


func _on_quit_button_button_up() -> void:
	get_tree().quit()

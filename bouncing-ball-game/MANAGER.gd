extends Node

signal player_death(lives_remaining)
signal scored_point

var GO : bool = false
var SCORE : int = 0
var PREVIOUS_SCORE : int = 0
var STREAK : int = 0
const STARTING_LIVES : int = 3
var LIVES : int = 3
var ppref = PlayerPref.new()
var basketball_data_string = "res://Ball Data Resources/basketball.tres"
var toonball_data_string = "res://Ball Data Resources/Cartoon.tres"


var BALL = "BASKETBALL"
@onready var BALL_TYPE : BallData = load(toonball_data_string)

func score_point():
	SCORE += 1
	
	emit_signal("scored_point")

func on_player_death():
	LIVES -= 1
	player_death.emit(LIVES)


#TODO Make this function actually save values to system.
func save():
	SCORE = STREAK + PREVIOUS_SCORE
	ppref.set_pref("Score", SCORE)

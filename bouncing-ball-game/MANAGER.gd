extends Node

signal player_death
signal scored_point

var GO : bool = false
var SCORE : int = 0
var PREVIOUS_SCORE : int = 0
var STREAK : int = 0
var ppref = PlayerPref.new()
var basketball_data_string = "res://Ball Data Resources/basketball.tres"
var toonball_data_string = "res://Ball Data Resources/Cartoon.tres"


var BALL = "BASKETBALL"
@onready var BALL_TYPE : BallData = load(toonball_data_string)

func score_point():
	STREAK += 1
	#SCORE += 1
	emit_signal("scored_point")

func on_player_death():
	#PREVIOUS_SCORE = max(PREVIOUS_SCORE, STREAK)
	PREVIOUS_SCORE += STREAK
	STREAK = 0
	emit_signal("player_death")

#TODO Make this function actually save values to system.
func save():
	SCORE = STREAK + PREVIOUS_SCORE
	ppref.set_pref("Score", SCORE)

extends Node

signal player_death

var GO : bool = false
var SCORE : int = 0
var PREVIOUS_SCORE : int = 0
var STREAK : int = 0

func on_player_death():
	PREVIOUS_SCORE = max(PREVIOUS_SCORE, STREAK)
	STREAK = 0
	emit_signal("player_death")
	

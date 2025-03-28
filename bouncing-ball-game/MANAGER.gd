extends Node

signal player_death(lives_remaining)
signal scored_point

signal speed_up(rarity)
signal health_up
signal score_up(rarity, magnitude)

var GO : bool = false
var SCORE : int = 0
var PREVIOUS_SCORE : int = 0
var STREAK : int = 0
const STARTING_LIVES : int = 3
var LIVES : int = 3
const STARTING_SPEED : int = 2
var current_speed : int = 2
var bonus_speed : int = 0
var bonus_speed_timer: float = 0
var ppref = PlayerPref.new()
var basketball_data_string = "res://Ball Data Resources/basketball.tres"
var toonball_data_string = "res://Ball Data Resources/Cartoon.tres"


var BALL = "BASKETBALL"
@onready var BALL_TYPE : BallData = load(toonball_data_string)

var rand = RandomNumberGenerator.new()
var SPEED_BOUND = 25
var HEALUP_BOUND = 75

func _process(delta: float) -> void:
	if bonus_speed > 0:
		bonus_speed_timer += delta
	if bonus_speed_timer > 5:
		bonus_speed = 0
		bonus_speed_timer = 0

func score_point():
	SCORE += 1
	
	emit_signal("scored_point")

func on_player_death():
	LIVES -= 1
	player_death.emit(LIVES)
	if LIVES <= 0: 
		pass
		#print("Player is dead")


func reset_game():
	Manager.GO = false
	LIVES = STARTING_LIVES
	SCORE = 0
	current_speed = STARTING_SPEED

func apply_powerup(type : int, rarity : int):
	match(type):
		1:
			speedup(rarity)
		2:
			healthup(rarity)
		3:
			scoreup(rarity)


func speedup(rarity : int):
	print("Applying speedup")
	bonus_speed_timer = 0
	current_speed += 1
	match(rarity):
		3:
			bonus_speed += rand.randi_range(1,2)
		2: 
			bonus_speed += rand.randi_range(3,4)
		1:
			bonus_speed += rand.randi_range(5,6)
	speed_up.emit(rarity)

func healthup(rarity : int):
	print("applying healthup")

func scoreup(rarity : int):
	print("scoreup")
	var magnitude : int = 1
	match(rarity):
		3:
			magnitude = rand.randi_range(2,10)
			SCORE += magnitude
		2: 
			magnitude = rand.randi_range(2,3)
			SCORE *= magnitude
		1:
			magnitude = rand.randi_range(5,10)
			SCORE *= magnitude
	score_up.emit(rarity, magnitude)

func get_random_percentile() -> int:
	rand.randomize()
	return randi_range(0, 100)

func powerup_type_determiner()-> Array:
	var n = get_random_percentile()
	var r = get_random_percentile()
	if r < 25:
		# Uncommon
		r = 2
	elif r < 5:
		# Rare
		r = 1
	else:
		# Common 
		r = 3
	
	if n < SPEED_BOUND:
	#speedup()
		return [1, r]
	if n > HEALUP_BOUND:
		#healthup()
		return [2, r]
	#scoreup()
	return [3, r]

#TODO Make this function actually save values to system.
func save():
	SCORE = STREAK + PREVIOUS_SCORE
	ppref.set_pref("Score", SCORE)

extends Area3D

var triggered : bool = false
var is_power_up: bool = false
@onready var animPlayer : AnimationPlayer = $AnimationPlayer

var powerupType = []
 # [type, rarity]
# 1 = speed, rare
# 2 = health, uncommon
# 3 = score, rare

func _on_body_entered(_body: Node3D) -> void:
	if triggered: return
	if Manager.BALL_TYPE.does_not_bounce and Manager.BALL_TYPE.does_not_roll and Manager.BALL_TYPE.does_not_move:
		Manager.score_point()
		triggered = true
		trigger_powerup()
		
		return
	
	animPlayer.play("triggered")
	Manager.score_point()
	trigger_powerup()
	
	triggered = true

func powerup():
	$"Powerup Indicator".visible = true
	powerupType = Manager.powerup_type_determiner()

func powerdown():
	$"Powerup Indicator".visible = false

func trigger_powerup():
	if $"Powerup Indicator".visible == false: return
	$"Powerup Indicator".play_particles()
	Manager.apply_powerup(powerupType[0],powerupType[1])

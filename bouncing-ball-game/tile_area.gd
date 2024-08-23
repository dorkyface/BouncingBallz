extends Area3D

var triggered : bool = false
@onready var animPlayer : AnimationPlayer = $AnimationPlayer


func _on_body_entered(_body: Node3D) -> void:
	if triggered: return
	if Manager.BALL_TYPE.does_not_bounce and Manager.BALL_TYPE.does_not_roll and Manager.BALL_TYPE.does_not_move:
		Manager.score_point()
		triggered = true
		#Manager.SCORE += 1
		#Manager.STREAK += 1
		return
	
	animPlayer.play("triggered")
	Manager.score_point()
	#Manager.SCORE += 1
	#Manager.STREAK += 1
	triggered = true

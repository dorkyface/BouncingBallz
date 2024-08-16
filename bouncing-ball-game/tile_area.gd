extends Area3D

var triggered : bool = false
@onready var animPlayer : AnimationPlayer = $AnimationPlayer


func _on_body_entered(_body: Node3D) -> void:
	if Manager.BALL_TYPE.does_not_bounce and Manager.BALL_TYPE.does_not_roll and Manager.BALL_TYPE.does_not_move:
		Manager.SCORE += 1
		Manager.STREAK += 1
		return
	if triggered: return
	animPlayer.play("triggered")
	Manager.SCORE += 1
	Manager.STREAK += 1
	triggered = true

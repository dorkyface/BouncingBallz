extends Area3D

var triggered : bool = false
@onready var animPlayer : AnimationPlayer = $AnimationPlayer


func _on_body_entered(body: Node3D) -> void:
	if triggered: return
	animPlayer.play("triggered")
	Manager.SCORE += 1
	Manager.STREAK += 1
	triggered = true

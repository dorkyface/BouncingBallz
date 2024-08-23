extends StaticBody3D

var triggered : bool = false
@onready var animPlayer : AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# If this tile is already triggered, do nothing. No double jepardy.
	if triggered: return
	
	# To detect if the player has landed on it, make a SIMULATED collision check
	# as if the tile is moving up.
	var collide = move_and_collide(Vector3(0,0.3,0), true)
	#if collide == null: move_and_collide(Vector3(0.3,0.3,0), true)
	#if collide == null: move_and_collide(Vector3(-0.3,0.3,0), true)
	
	# If the simulation predicts no collision, do nothing.
	if collide == null: return
	
	# If there IS a collision, make sure that it is the ball 
	# (and not another tile, for instance)
	if collide.get_collider().is_in_group("BALL"):
		Manager.score_point()
		#Manager.SCORE += 1
		#Manager.STREAK += 1
		#print(Manager.STREAK)
		animPlayer.play("triggered")
		triggered = true

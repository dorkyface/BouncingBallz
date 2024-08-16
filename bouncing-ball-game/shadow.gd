extends Decal

#@onready var ball = get_tree().get_first_node_in_group("BALL")
@export var ball : Node3D
@onready var start_scale = scale

func _ready() -> void:
	if ball == null: return
	var ball_data = Manager.BALL_TYPE
	if ball_data.alt_shadow != null:
		texture_albedo = ball_data.alt_shadow

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if ball == null: return
	
	# Grows and shrinks the shadow based on how far away the ball is.
	scale = start_scale * (1.5/(position.distance_to(ball.position)+1))

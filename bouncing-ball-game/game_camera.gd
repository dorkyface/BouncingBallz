extends Camera3D

@onready var DEFAULT_FOV = fov
#@onready var twee : Tween = get_tree().create_tween()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Manager.scored_point.connect(update_fov)
	Manager.player_death.connect(reset_fov)
	if Manager.BALL_TYPE.alt_default_fov != 0: 
		DEFAULT_FOV = Manager.BALL_TYPE.alt_default_fov
		fov = DEFAULT_FOV


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	#fov = DEFAULT_FOV + Manager.STREAK

func update_fov():
	var twee : Tween = get_tree().create_tween()
	#twee.EaseType = twee.TRANS_ELASTIC
	twee.set_ease(Tween.EASE_OUT)
	twee.set_trans(Tween.TRANS_EXPO)
	var new_fov = clamp(DEFAULT_FOV + Manager.STREAK - 5, DEFAULT_FOV, DEFAULT_FOV + 30)
	twee.tween_property(self, "fov", new_fov, 0.5)

func reset_fov():
	var twee : Tween = get_tree().create_tween()
	twee.set_ease(Tween.EASE_OUT)
	twee.set_trans(Tween.TRANS_ELASTIC)
	twee.tween_property(self, "fov", DEFAULT_FOV, 1.5)

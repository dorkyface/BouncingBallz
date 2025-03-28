extends AudioStreamPlayer

var base_score : int = 0
@export var enabled : bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if enabled == false: return
	if delta_score() > 2:
		if !playing:
			stream.set_sync_stream_volume(0, -60)
			play()
			var t = get_tree().create_tween()
			t.tween_method(set_stream_volume,-60, 0, 10.0)

func set_stream_volume(db):
	stream.set_sync_stream_volume(0, db)

func delta_score():
	return Manager.SCORE - base_score

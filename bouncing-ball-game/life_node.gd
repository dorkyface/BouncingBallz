extends Control
class_name life_node

const shatter_time = 5.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		shatter()
		

func shatter():
		hide_excess_textures()
	
		for i in $"Pie Parent".get_children().size():
			var dir = Vector2.LEFT.rotated(deg_to_rad(-22.5 + 45.0 * (i + 1)))
			
			var t : Tween = get_tree().create_tween()
			t.set_parallel(true)
			t.set_ease(Tween.EASE_OUT)
			t.set_trans(Tween.TRANS_EXPO)
			t.tween_property($"Pie Parent".get_child(i), "position", dir * 20000, shatter_time).as_relative()
			t.tween_property($"Pie Parent".get_child(i), "self_modulate", Color.TRANSPARENT, shatter_time)

func hide_excess_textures():
	$"Pie Cover".visible = false
	$Outline.visible = false

extends Control
class_name life_node

@onready var outline: TextureRect = $Outline
@onready var pie_cover: TextureRect = $"Pie Cover"

const shatter_time = 10.0
const SHATTER_DISTANCE_FACTOR = 50000

@onready var shatter_sfx_player: AudioStreamPlayer3D = $ShatterSFXPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#if Input.is_action_just_pressed("ui_accept"):
		#shatter()

func shatter():
		hide_excess_textures()
		shatter_sfx_player.play()
		
		for i in $"Pie Parent".get_children().size():
			var dir = Vector2.LEFT.rotated(deg_to_rad(-22.5 + 45.0 * (i + 1)))
			
			var t : Tween = get_tree().create_tween()
			t.set_parallel(true)
			t.set_ease(Tween.EASE_OUT)
			t.set_trans(Tween.TRANS_EXPO)
			t.tween_property($"Pie Parent".get_child(i), "position", dir * SHATTER_DISTANCE_FACTOR, shatter_time).as_relative()
			t.tween_property($"Pie Parent".get_child(i), "self_modulate", Color.TRANSPARENT, shatter_time)

func hide_excess_textures():
	pie_cover.visible = false
	outline.visible = false

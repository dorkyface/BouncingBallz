extends CharacterBody3D

const JUMP_VELOCITY : float = 4.5
@onready var col_shape : CollisionShape3D = $CollisionShape3D
@onready var streak_hang_timer : Timer = $StreakHangTimer
@onready var streak_flash_sprite : Sprite3D = $StreakFlashSprite
@onready var streak_flash_anim : AnimationPlayer = $StreakFlashSprite/StreakFlashAnimationPlayer

var MINIMUM_HEIGHT_LIMIT = -5
var RESPAWN_HEIGHT = 5

const HANG_TIME_STREAK_MINIMUM : int = 11
var last_frame_y : float = 0
var hang_time : int = 0

func _physics_process(delta: float) -> void:
	if Manager.GO == false: return
	
	#When the ball is respawned in the air, it shouldn't collide with the tiles at the top of the ring.
	col_shape.disabled = (position.y >= 1)
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	# If the ball collides with a tile (although rn it doesn't check specifically for tiles)
	# then set the Y velocity to the JUMP VELOCITY.
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity.y = JUMP_VELOCITY
	
	# When the ball falls into the void, respawn and reset streak
	if position.y <= MINIMUM_HEIGHT_LIMIT:
		position.y = RESPAWN_HEIGHT
		velocity.y = 0
		Manager.STREAK = 0
	
	if abs(position.y - last_frame_y) < 0.01:
		hang_time += 1
		if hang_time >= HANG_TIME_STREAK_MINIMUM:
			Manager.SCORE += 1
			Manager.STREAK += 1
			streak_flash_sprite.visible = true
			streak_flash_anim.play("FLASHING")
			streak_flash_sprite.frame += 1
	else:
		hang_time = 0
		streak_flash_sprite.visible = false
	last_frame_y = position.y

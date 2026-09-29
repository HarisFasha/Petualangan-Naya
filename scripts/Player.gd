extends CharacterBody2D

const SPEED = 220.0
const JUMP_VELOCITY = -420.0
const GRAVITY = 980.0
const MAX_JUMPS = 2

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurt_timer: Timer = $HurtTimer
@onready var invincible_timer: Timer = $InvincibleTimer
@onready var blink_timer: Timer = $BlinkTimer

var jumps_left := MAX_JUMPS
var is_hurt := false
var is_invincible := false
var last_safe_position: Vector2 = Vector2(150, 440)
var was_on_floor := true

func _physics_process(delta: float) -> void:
	if is_hurt:
		# Lagi kena hit, jangan proses gerakan sama sekali
		move_and_slide()
		return

	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		jumps_left = MAX_JUMPS
		last_safe_position = global_position
		if not was_on_floor:
			SFX.play("bump")
	was_on_floor = is_on_floor()

	# Lompat (bisa 2x di udara = double jump)
	if Input.is_action_just_pressed("ui_accept") and jumps_left > 0:
		velocity.y = JUMP_VELOCITY
		SFX.play("jump" if jumps_left == MAX_JUMPS else "jump_high")
		jumps_left -= 1

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * SPEED
		sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	update_animation()

	if global_position.y > 3000:
		die()

func update_animation() -> void:
	if not is_on_floor():
		sprite.play("jump")
	elif abs(velocity.x) > 10:
		sprite.play("walk")
	else:
		sprite.play("idle")

func die() -> void:
	if is_invincible or is_hurt:
		return
	is_hurt = true
	velocity = Vector2.ZERO
	sprite.play("hit")
	SFX.play("hurt")
	GameManager.set_checkpoint(last_safe_position)
	GameManager.lose_life()
	hurt_timer.start()

func _on_hurt_timer_timeout() -> void:
	is_hurt = false
	if GameManager.lives > 0:
		GameManager.respawn_player(self)
		start_invincibility()

func start_invincibility() -> void:
	is_invincible = true
	invincible_timer.start()
	blink_timer.start()

func _on_invincible_timer_timeout() -> void:
	is_invincible = false
	blink_timer.stop()
	sprite.modulate.a = 1.0

func _on_blink_timer_timeout() -> void:
	sprite.modulate.a = 0.3 if sprite.modulate.a == 1.0 else 1.0

func bounce() -> void:
	velocity.y = JUMP_VELOCITY * 0.6
	jumps_left = 1

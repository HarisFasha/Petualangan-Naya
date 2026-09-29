extends CharacterBody2D

@export var speed: float = 60.0
@export var patrol_distance: float = 100.0

const GRAVITY = 980.0

var start_x: float = 0.0
var direction: int = 1

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	start_x = global_position.x
	if sprite:
		sprite.play("walk")  # atau "walk"

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	velocity.x = direction * speed

	# Balik arah patrol
	if global_position.x > start_x + patrol_distance:
		direction = -1
	elif global_position.x < start_x - patrol_distance:
		direction = 1

	# Flip sprite sesuai arah
	if sprite:
		sprite.flip_h = direction < 0

	move_and_slide()

func _on_hurt_zone_body_entered(body: Node) -> void:
	if body.name == "Player":
		body.die()

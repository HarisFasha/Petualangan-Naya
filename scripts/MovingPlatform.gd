extends AnimatableBody2D

## Arah dan jarak gerakan relatif dari posisi awal
@export var move_vector: Vector2 = Vector2(150, 0)
@export var speed: float = 50.0

var start_pos: Vector2
var target_pos: Vector2
var moving_to_target: bool = true

func _ready() -> void:
	start_pos = global_position
	target_pos = global_position + move_vector

func _physics_process(delta: float) -> void:
	var target := target_pos if moving_to_target else start_pos
	var to_target := target - global_position
	var dist := to_target.length()

	if dist < 4.0:
		moving_to_target = !moving_to_target
	else:
		global_position += to_target.normalized() * speed * delta

extends Area2D

var activated: bool = false

func _on_body_entered(body: Node) -> void:
	if body.name == "Player" and not activated:
		activated = true
		SFX.play("magic")
		GameManager.set_checkpoint(global_position)
		$Flag.color = Color(0.2, 0.9, 0.3, 1)

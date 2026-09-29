extends Area2D

func _on_body_entered(body: Node) -> void:
	if body.name == "Player":
		SFX.play("coin")
		GameManager.add_score(10)
		queue_free()
